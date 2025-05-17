Here is the properly formatted Markdown version of your file:

# Statistical Analysis Using Permutations in R

## 1. Introduction to Permutations

### What Are Permutations?
Permutations involve randomly reshuffling data to create a null distribution—a distribution that represents what we'd expect to see if there were no true association between variables. This method is useful when traditional statistical tests rely on assumptions about normality, which might not hold in real-world datasets.

### Why Use Permutations?
- Helps evaluate statistical significance without assuming normality.
- Allows testing of hypotheses by randomizing labels in the dataset to simulate the expected variation.
- Useful for gene expression analysis and comparing age distributions in medical datasets.

---

## 2. Positional Indexing in R
Even when working with vectors instead of full dataframes, R maintains positional relationships between elements in multiple vectors. This allows indexing based on conditions applied to one vector.

### Example: Filtering Values Based on Another Vector
```r
# Sample dataset
x.age <- c(25, 30, 22, 28)
x.sex <- c("M", "F", "F", "M")

# Logical indexing (select ages where sex is "M")
x.age[x.sex == "M"]  
# Output: [25, 28]

x.age[x.sex == "F"]  
# Output: [30, 22]
```

Despite `x.age` and `x.sex` being separate vectors, R maintains their positional relationship, meaning `x.sex == "M"` filters corresponding values from `x.age`.

---

## 3. Handling NA Values in Two Vectors

### Using `!is.na()` with Multiple Vectors
When working with data that contains missing values (`NA`), we often need to filter out rows where either of two vectors have missing values.

### Example: Removing NA Values in Two Vectors
```r
x.age <- c(25, NA, 30, 22, NA, 28)
x.s <- c("M", "F", NA, "F", "M", NA)

# Logical filter: Keep rows where BOTH age and sex are not NA
x.keep <- !is.na(x.age) & !is.na(x.s)

# Apply filter to each vector
x.age <- x.age[x.keep]
x.s <- x.s[x.keep]

# Checking filtered values
print(x.age)  # Output: [25, 22]
print(x.s)    # Output: ["M", "F"]
```

This ensures that missing values in either vector are removed without losing positional alignment between them.

---

## 4. Logical Operations for Counting (`>=` in Summation)

### Using `>=` to Count True Conditions
In permutation testing, comparisons like `>=` generate a logical vector of `TRUE` and `FALSE`. These logical vectors can be summed up to count how often a condition is met.

### Example: Counting How Many Simulated Differences Are Greater Than the Observed Difference
```r
# Simulated data (difference from shuffled samples)
diff.sim <- c(1.5, 2.0, 0.5, 2.1, 1.7, 1.3)

# Original observed difference
diff.ori <- 1.6  

# Logical vector (TRUE where simulated values are >= observed)
comparison <- abs(diff.sim) >= abs(diff.ori)
print(comparison)  # [FALSE, TRUE, FALSE, TRUE, TRUE, FALSE]

# Sum of TRUE values
count_extreme <- sum(comparison)  
print(count_extreme)  # Output: 3 (3 values met the condition)

# Calculate proportion
p.value <- count_extreme / length(diff.sim)
print(p.value)  # Output: 0.5
```

This logic is frequently used in permutation-based hypothesis testing.

---

## 5. Full R Code for Permutation Testing
Now, bringing all concepts together:

```r
library(ALL); data(ALL)

# Extract observations
x.age <- pData(ALL)$age  
x.sex <- pData(ALL)$sex  

# Remove NAs using logical indexing
x.keep <- !is.na(x.age) & !is.na(x.sex)
x.age <- x.age[x.keep]  
x.sex <- x.sex[x.keep]

# Compute original mean difference
diff.ori <- mean(x.age[x.sex == "M"]) - mean(x.age[x.sex == "F"])

# Initialize simulation
diff.sim <- numeric(10000)

# Permutation test: shuffle ages 10,000 times
for (i in 1:10000) {
  x.tmp <- sample(x.age)  # Reshuffling ages
  diff.sim[i] <- mean(x.tmp[x.sex == "M"]) - mean(x.tmp[x.sex == "F"])
}

# Compute p-value
p.value <- sum(abs(diff.sim) >= abs(diff.ori)) / 10000  

# Compare with t-test
t_test_pval <- t.test(x.age[x.sex == "M"], x.age[x.sex == "F"], var.equal = TRUE)$p.value  

# Print results
print(p.value)  # ~0.10 (permutation result)
print(t_test_pval)  # ~0.106 (t-test result)
```

---

## 6. Summary of Key Concepts

| Concept               | Explanation                                                                 |
|-----------------------|-----------------------------------------------------------------------------|
| **Positional Indexing** | R maintains alignment between vectors, allowing indexing in one vector using a condition from another. |
| **Handling NAs**       | Using `!is.na(x.age) & !is.na(x.s)` ensures rows with missing values in either vector are removed. |
| **Logical Counting (`>=`)** | `>=` creates a logical vector (`TRUE/FALSE`), which can be summed to count occurrences for statistical tests. |
| **Permutation Testing** | Reshuffling data helps determine the significance of an observed difference by comparing it to a null distribution. |

---

## 7. Final Takeaway
- Permutation tests provide a flexible, assumption-free way to assess statistical significance.
- Logical indexing and filtering allow efficient data manipulation.
- Summing logical conditions (`>=` comparisons) enables probability estimation in hypothesis testing.
- Both permutation methods and traditional t-tests can give similar results when sample sizes are large.
```

This version uses proper Markdown formatting for headings, code blocks, and tables. Let me know if you need further adjustments!


### Bootstrapping Approach
- **Definition**: Bootstrapping is a resampling method where you repeatedly sample from your data with replacement. This means some data points may appear multiple times in a sample, while others may not appear at all.
- **Non-parametric Method**: It doesn't make any assumptions about the underlying distribution of the data, relying solely on the data at hand.

### Comparison with Permutations
- **Permutations**: Involve reshuffling the data without replacement, which doesn't change statistics like the mean or standard deviation.
- **Bootstrapping**: By resampling with replacement, it assesses the effect of outliers and variability in the data.

### Example Code Breakdown
1. **Generate Data**: 
   ```r
   x <- rnorm(100)
   ```
   - This creates a sample of 100 data points from a normal distribution.

2. **Prepare for Bootstrapping**:
   ```r
   v <- numeric(10000)
   ```
   - This initializes a vector to store the means of 10,000 bootstrapped samples.

3. **Bootstrapping Loop**:
   ```r
   for (n in 1:10000) {
       x1 <- sample(x, replace = TRUE)
       v[n] <- mean(x1)
   }
   ```
   - For each iteration, a new sample `x1` is created by resampling `x` with replacement. The size of the sample (by default) is the length of `x`. But remember you may have some values multiple times, as we are replacing each value, then choosing another length(x) times.
   - The mean of each bootstrapped sample is calculated and stored in `v`.

4. **Calculate Standard Deviation**:
   ```r
   sd(v)
   sd(x) / 10
   ```
   - The standard deviation of the bootstrapped sample means (`sd(v)`) is compared to the theoretical standard error of the mean (`sd(x) / sqrt(100)`).
   - Reminder: Theoretical Standard Error of the Mean (SEM): This is calculated as the standard deviation of the original sample divided by the square root of the sample size. It gives an estimate of how much the sample mean is expected to vary from the true population mean.

### Key Points
- **Purpose**: The comparison is to see how close the bootstrapped estimate of the standard error (i.e., the standard deviation of the bootstrapped sample means) is to the theoretical standard error of the mean.
- **Result**: In the example, the standard deviation of the bootstrapped sample means (sd(v)) is very close to the theoretical SEM (sd(x) / sqrt(100)). This shows that bootstrapping provides a reliable estimate of the SEM even without knowing the underlying distribution of the data.
- **Comparison with Permutations**: Permutations wouldn't change the mean, but bootstrapping provides a way to assess variability and significance.

___
**Breaking down the boot() code:**

 **Loading the Library**:
   ```r
   library(boot)
   ```
   - This loads the `boot` library, which contains functions for bootstrapping.

**Defining the Statistic Function**:
```r
MF.age.diff <- function(x, i) {
    age.m <- x[i, "age"][x[i, "sex"] == "M"]
    age.f <- x[i, "age"][x[i, "sex"] == "F"]
    mean(age.m) - mean(age.f)
}
```
- **Purpose**: This function calculates the difference in mean ages between male and female patients for a given subset of data.
- **Parameters**:
  - `x`: The entire dataset.
  - `i`: Indices of the resampled data.
  - First, x[i, "age"] selects the ages for the rows indexed by i. Then, [x[i, "sex"] == "M"] filters these ages to include only those where the sex is "M".

### Data Frame Creation
```r
x.df.tmp <- data.frame(age = x.age, sex = x.sex)
```
- **Purpose**: Creates a data frame with columns for age and sex.

### Bootstrapping
```r
boot.res <- boot(x.df.tmp, statistic = MF.age.diff, R = 10000, strata = x.sex)
```
- **Purpose**: Performs bootstrapping using the `boot` function.
- **Parameters**:
  - `x.df.tmp`: The data frame.
  - `statistic`: The function to calculate the statistic of interest (`MF.age.diff`).
  - `R = 10000`: Specifies 10,000 bootstrap iterations.
  - `strata = x.sex`: Ensures resampling is done separately for males and females.

### How Repetitions Work
1. **Bootstrap Iterations**:
   - The `boot` function performs 10,000 iterations.
   - In each iteration, it randomly selects indices from the original data with replacement.

2. **Resampling**:
   - For each iteration, the function `MF.age.diff` is called with the full dataset `x` and the resampled indices `i`.
   - The function calculates the mean age difference between males and females for the resampled data.

3. **Calculation**:
   - Within `MF.age.diff`, `x[i, "age"]` selects the ages for the resampled indices.
   - `[x[i, "sex"] == "M"]` filters these ages to include only males.
   - `[x[i, "sex"] == "F"]` filters these ages to include only females.
   - The function then calculates the difference between the mean ages of males and females for each resampled dataset.

4. **Collecting Results**:
   - The `boot` function collects the mean age differences for all 10,000 iterations.
   - These results are stored in the `boot.res` object.

### Summary
- **Repetitions**: The bootstrapping process involves repeating the resampling and calculation 10,000 times.
- **Result**: You get an empirical distribution of the mean age differences between males and females, which can be used to estimate confidence intervals and assess significance.


### CIs
**Calculating Confidence Intervals**:
   ```r
   boot.ci(boot.res, type = "norm")$normal
   ```
   - `boot.ci()` calculates the confidence interval for the bootstrapped statistic.
   - `type = "norm"` specifies a normal approximation for the confidence interval.

### Explanation of the Process

- **Bootstrapping**: The `boot()` function resamples the data 10,000 times, each time calculating the difference in mean ages between males and females.
- **Stratification**: By using `strata = x.sex`, the resampling is done within each sex group, maintaining the same number of males and females in each resampled dataset.
- **Result**: The `boot()` function returns an object containing the bootstrapped statistics. The `boot.ci()` function then calculates the confidence interval for these statistics.

### Comparing with t-test

- **t-test**:
   ```r
   t.test(x.age[x.sex == "M"], x.age[x.sex == "F"], var.equal = TRUE)$conf.int
   ```
   - This performs a t-test to calculate the confidence interval for the difference in mean ages.
- **Comparison**: The confidence interval from the t-test is very close to the one obtained from bootstrapping, showing that bootstrapping provides a reliable estimate without making assumptions about the underlying distribution.

---

### Summary of the Notes

1. **boot() Function**:
   - **Returns an Object**: Contains multiple elements, including:
     - `t0`: The statistic calculated on the whole original dataset.
     - `t`: The statistic calculated for each resampling (10,000 elements in this case).

2. **boot.ci() Function**:
   - **Purpose**: Takes the object returned by `boot()` and calculates the confidence interval of the statistic.
   - **Method**: Uses the distribution of bootstrapped values to estimate the confidence interval.

3. **Confidence Interval Calculation**:
   - **Assumption**: Similar to a t-test, assuming normality to calculate the interval containing 95% of the distribution. (b/c using sample means)
   - **Empirical Distribution**: The confidence interval is based on the empirical distribution from bootstrapping, without assumptions about the underlying distribution.

