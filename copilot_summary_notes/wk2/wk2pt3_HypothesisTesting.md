Certainly! Here's a detailed breakdown of the notes provided:

---
Here’s a detailed breakdown of the notes with clear explanations, definitions, and the purpose of each step. I'll focus on making the material more digestible while explaining what we are trying to achieve at each stage.

---

## 1. Overview
### **What are we trying to achieve?**
We want to compare two samples to determine if the differences between them are due to random chance or if they reflect a real difference in their underlying distributions.

### **Key Concept: Hypothesis Testing**
- **Null Hypothesis (H₀):** Assumes no difference between the two samples (e.g., they come from the same distribution).
- **Alternative Hypothesis (H₁):** Assumes a real difference exists between the two samples.

---

## 2. Comparing Two Samples
### **What are we trying to achieve?**
We aim to visualize and understand the differences between two groups (e.g., male and female patients) using the ALL dataset.

### **Steps:**
1. **Load the ALL dataset**:
   ```r
   library(ALL)
   data(ALL)
   pData(ALL)[1:5, 1:5]  # View the first few rows of patient data
   ```
   This gives us a quick look at the dataset, which includes variables like `sex`, `age`, and `diagnosis`.

2. **Visualize the data**:
   - **Boxplot for all patients**:
     ```r
     boxplot(pData(ALL)$age, cex.axis = 2)
     ```
     This shows the overall age distribution of all patients.

   - **Boxplot stratified by gender**:
     ```r
     boxplot(age ~ sex, pData(ALL), cex.axis = 2)
     ```
     This compares the age distributions of male and female patients.

   - **Histogram of ages**:
     ```r
     hist(pData(ALL)$age, cex.axis = 2)
     ```
     This shows the empirical distribution of ages.

### **Key Observations:**
- Male patients tend to have a lower median age compared to females.
- The question arises: Is this difference real, or could it be due to random sampling?

---

## 3. Hypothesis Testing
### **What are we trying to achieve?**
We want to determine if the observed difference between the two groups (e.g., male and female ages) is statistically significant or just due to chance.

---

### 3.1 Resampling Experiment (Brute Force Simulation)
#### **What is it?**
A method to test the null hypothesis by simulating random samples from the same distribution and comparing the observed difference to the simulated differences.

#### **Steps:**
1. **Define the observed difference**:
   ```r
   ori.diff <- mean(x.f) - mean(x.m)
   ```

2. **Simulate differences**:
   - Randomly sample subsets of ages from the same distribution (e.g., all male ages).
   - Compute the difference in means for each simulation.
   - Repeat this process many times (e.g., 10,000 simulations).

   ```r
   diff.sim <- numeric()
   for (i.sim in 1:10000) {
       x.sim <- sample(m.ages[!is.na(m.ages)], 20)
       diff.sim[i.sim] <- mean(x.sim[1:9]) - mean(x.sim[10:20])
   }
   ```

3. **Visualize the results**:
   - Plot the simulated differences and highlight the observed difference.
   ```r
   hist(diff.sim, breaks = 20, main = "Simulated Differences")
   abline(v = ori.diff, col = "red", lwd = 2)
   ```

#### **Key Interpretation:**
- If the observed difference is rare (e.g., in the extreme tail of the simulated distribution), it suggests a real difference.
- If the observed difference is common, it could be due to chance.

---

### 3.2 t-Test
#### **What is it?**
A statistical test to compare the means of two groups. It assumes the data is normally distributed.

#### **Formula:**
For two samples:
```plaintext
t = (X̄₁ - X̄₂) / √(S₁²/n₁ + S₂²/n₂)
```
Where:
- `X̄₁, X̄₂`: Sample means
- `S₁, S₂`: Sample standard deviations
- `n₁, n₂`: Sample sizes

#### **Steps:**
1. **Perform the t-test in R**:
   ```r
   t.test(x.f, x.m, alternative = "greater")
   ```

2. **Interpret the p-value**:
   - If p-value < 0.05, reject the null hypothesis and conclude a significant difference.
   - If p-value ≥ 0.05, fail to reject the null hypothesis.

#### **Key Takeaway:**
The t-test provides a computationally efficient way to test for differences without needing brute-force simulations.

---

## 4. Testing for Data Normality
### **What are we trying to achieve?**
Before performing a t-test, we need to check if the data is normally distributed because the t-test assumes normality.

### **Shapiro-Wilk Test:**
- Tests the null hypothesis that the data is normally distributed.
- If p-value < 0.05, the data is not normal.

#### **Steps:**
1. **Perform the Shapiro-Wilk test**:
   ```r
   shapiro.test(blood_storage$Median.RBC.Age)
   ```

2. **Interpret the results**:
   - If the data is not normal, use a non-parametric test like the Mann-Whitney U Test.

---

## 5. Mann-Whitney U Test
### **What is it?**
A non-parametric test to compare two independent samples. It does not assume normality.

#### **Formula:**
```plaintext
U₁ = n₁n₂ + n₁(n₁ + 1)/2 - R₁
```
Where:
- `n₁, n₂`: Sample sizes
- `R₁`: Sum of ranks for the first sample

#### **Steps:**
1. **Perform the test in R**:
   ```r
   wilcox.test(blood_storage$Median.RBC.Age, blood_storage$PreopPSA)
   ```

2. **Interpret the p-value**:
   - If p-value < 0.05, reject the null hypothesis and conclude a significant difference.

#### **Key Takeaway:**
The Mann-Whitney U Test is a robust alternative to the t-test when the data is not normally distributed.

---

## Summary of Key Points:
1. **Visualization**: Always start by visualizing the data (e.g., boxplots, histograms).
2. **Hypothesis Testing**: Use statistical tests to determine if observed differences are significant.
3. **Normality Check**: Test for normality before choosing a statistical test.
4. **t-Test**: Use for normally distributed data.
5. **Mann-Whitney U Test**: Use for non-normal data.

Let me know if you'd like further clarification or additional examples!

### **1. Non-Parametric Hypothesis Testing: Mann-Whitney U Test**
- **When to Use**:
  - The Mann-Whitney U Test (also known as the Wilcoxon Rank Sum Test) is used when the data is **not normally distributed**.
  - It is a **non-parametric test**, meaning it does not assume any specific distribution for the data.
  - It is used to compare two independent groups to determine if their distributions differ significantly.

#### **Definition**:
- The Mann-Whitney U Test calculates two statistics, `U1` and `U2`, based on the ranks of the data:
  ```math
  U1 = n1 * n2 + (n1 * (n1 + 1)) / 2 - R1
  U2 = n1 * n2 + (n2 * (n2 + 1)) / 2 - R2
  ```
  - `n1` and `n2` are the sample sizes of the two groups.
  - `R1` and `R2` are the sums of the ranks for the two groups.

#### **Assumptions**:
1. The two groups being compared are **independent**.
2. The data is **continuous**.
3. Both samples are **randomly selected**.

---

### **2. Performing the Mann-Whitney U Test in R**
- **Function**: `wilcox.test()`
- **Example**:
  ```r
  wilcox.test(blood_storage$Median.RBC.Age, blood_storage$PreopPSA, 
              conf.int = TRUE, paired = FALSE)
  ```
  - `blood_storage$Median.RBC.Age`: Data for the first group.
  - `blood_storage$PreopPSA`: Data for the second group.
  - `conf.int = TRUE`: Requests a confidence interval for the difference in location.
  - `paired = FALSE`: Indicates that the samples are independent.

#### **Output**:
- Example output:
  ```
  Wilcoxon rank sum test with continuity correction

  data:  blood_storage$Median.RBC.Age and blood_storage$PreopPSA
  W = 88005, p-value < 2.2e-16
  alternative hypothesis: true location shift is not equal to 0
  95 percent confidence interval:
   7.199952 9.200053
  sample estimates:
  difference in location 
                8.300047
  ```
  - **W**: The test statistic.
  - **p-value**: Indicates the probability of observing the data under the null hypothesis (no difference between groups).
  - **Confidence Interval**: The range of values for the difference in location between the two groups.
  - **Difference in Location**: The estimated difference between the medians of the two groups.

#### **Interpretation**:
- A **small p-value** (e.g., `< 0.05`) suggests that the two groups are significantly different.
- The **confidence interval** provides a range for the difference in medians. If it does not include 0, the difference is significant.

---

### **3. Example Explanation**
- **Scenario**:
  - You want to determine if there is a significant difference between `Median.RBC.Age` and `PreopPSA` in the `blood_storage` dataset.
- **Code**:
  ```r
  wilcox.test(blood_storage$Median.RBC.Age, blood_storage$PreopPSA, 
              conf.int = TRUE, paired = FALSE)
  ```
- **Output**:
  - The p-value is `< 2.2e-16`, which is extremely small, indicating a significant difference between the two groups.
  - The confidence interval `[7.199952, 9.200053]` does not include 0, further confirming the significant difference.
  - The estimated difference in location (median) is `8.300047`.

---

### **4. Key Takeaways**
1. **Mann-Whitney U Test**:
   - A non-parametric alternative to the t-test.
   - Used when data is not normally distributed.
   - Compares the medians of two independent groups.
2. **R Implementation**:
   - Use the `wilcox.test()` function.
   - Interpret the p-value, confidence interval, and difference in location.
3. **Practical Application**:
   - Useful in biomedical statistics when data violates normality assumptions.
   - Provides robust results without requiring transformations of the data.

---

Let me know if you'd like further clarification or additional examples!