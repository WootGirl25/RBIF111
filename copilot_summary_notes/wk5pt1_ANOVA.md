Week 5 Notes Part 1 ANOVA  

See potential errors at end of document.
---

### **Section 1: Overview**
This section introduces **one-way Analysis of Variance (ANOVA)**, a statistical method used to compare the means of multiple groups to determine if they are significantly different. It explains that ANOVA is related to linear models and the F-test, and it provides an example of its application in R.

**Summary**:  
ANOVA is a statistical test used to compare the means of two or more groups. It helps determine if the differences between group means are statistically significant.

---

### **Section 2: Analysis of Variance**

#### **2.1 Between- and Within-Sample Variance**
This section explains the concepts of **between-group variance** and **within-group variance**. It introduces the formulas for calculating these variances and how they relate to the total variance.

1. **Total Mean**:
   ```
   x¯=(∑j=1p∑i=1nixij)/NwhereN=∑j=1pnj
   ```
   - `x¯`: Total mean of all observations.
   - `N`: Total number of observations across all groups.

2. **Group Means**:
   ```
   x¯j=(∑i=1njxij)/nj
   ```
   - `x¯j`: Mean of group `j`.

3. **Total Sum of Squares (SStotal)**:
   ```
   SStotal=∑j=1p∑i=1ni(xij−x¯)2
   ```

4. **Within-Group Sum of Squares (SSwithin)**:
   ```
   SSwithin=∑j=1p∑i=1nj(xij−x¯j)2
   ```

5. **Between-Group Sum of Squares (SSbetween)**:
   ```
   SSbetween=∑j=1pnj(x¯j−x¯)2
   ```

6. **Relationship Between Variances**:
   ```
   SStotal=SSwithin+SSbetween
   ```

**Summary**:  
- **Within-group variance** measures variability within each group (how spread out the data is within a group).  
- **Between-group variance** measures variability between group means (how different the group means are from the overall mean).  
- The total variance is the sum of within-group and between-group variances.

---

#### **2.2 F-Statistics**
This section introduces the **F-statistic**, which is the ratio of between-group variance to within-group variance. It is used to test the null hypothesis that all group means are equal.

1. **Mean Sum of Squares Between Groups (MSSbetween)**:
   ```
   MSSbetween=SSbetween/(p−1)
   ```
   - `p`: Number of groups.

2. **Mean Sum of Squares Within Groups (MSSwithin)**:
   ```
   MSSwithin=SSwithin/(N−p)
   ```
   - `N`: Total number of observations.

3. **F-Statistic**:
   ```
   F=MSSbetween/MSSwithin
   ```

**Summary**:  
The F-statistic compares the variance between groups to the variance within groups. A large F-value suggests that the group means are significantly different.

---

### **Section 3: ANOVA Examples**

#### **Example 1: Gene Expression and Fusion Protein Status**
This example uses the **ALL dataset** to analyze the relationship between gene expression levels and fusion protein status using ANOVA.

1. **Data Preparation**:
   - The dataset is split into three groups based on fusion protein status: `p190`, `p190/p210`, and `p210`.

2. **Linear Model Coefficients**:
   - The coefficients of the linear model represent the mean expression levels for each group.

3. **Manual Calculation of SSbetween**:
   ```
   SSbetween=17*(3.866913−3.7052303)^2+8*(3.866913−3.7052303−0.3614408)^2+8*(3.866913−3.7052303−0.3054996)^2
   ```

4. **ANOVA Table**:
   - The ANOVA table shows the sum of squares, mean squares, F-value, and p-value for the model.

**Summary**:  
This example demonstrates how to calculate between-group variance manually and verify it using ANOVA in R. The significant p-value indicates that the differences in gene expression levels between groups are statistically significant.

---

#### **Example 2: Another Gene**
This example repeats the analysis for a different gene. The results show no significant effect, as indicated by the high p-value.

**Summary**:  
Not all genes show significant differences in expression levels between groups. This highlights the importance of interpreting p-values in the context of the data.

---

### **Plain English Explanation**
- ANOVA is like comparing the averages of multiple groups to see if they are "too different" to be due to random chance.
- It splits the total variability in the data into two parts: variability **within groups** (noise) and variability **between groups** (signal).
- The F-statistic is a ratio of the signal to the noise. A high F-value means the signal (difference between groups) is strong compared to the noise (random variation within groups).
- A small p-value means the differences between group means are unlikely to be due to chance.

Let me know if you'd like further clarification on any part!

---

Errors?

The notes appear to be well-written and detailed, but there are a few areas where mistakes or ambiguities could potentially exist. Here are some points to consider when reviewing the notes for correctness:

---

### **1. Formula Consistency**
- The formula for the total mean:
  ```
  x¯=(∑j=1p∑i=1nixij)/NwhereN=∑j=1pnj
  ```
  This formula is correct, but the formatting could be improved for clarity. For example, separating `N` into its own definition (`N=∑j=1pnj`) would make it easier to read.

---

### **2. Explanation of Degrees of Freedom**
- The explanation of degrees of freedom in the context of ANOVA is correct but dense. For example:
  ```
  MSSbetween=SSbetween/(p−1)
  MSSwithin=SSwithin/(N−p)
  ```
  These formulas are correct, but the explanation of why the denominators are `p−1` and `N−p` could be simplified. Degrees of freedom are tied to the number of groups (`p`) and the total number of observations (`N`), but the notes might overwhelm readers with too much detail.

---

### **3. Manual Calculation of SSbetween**
- The manual calculation of `SSbetween`:
  ```
  SSbetween=17*(3.866913−3.7052303)^2+8*(3.866913−3.7052303−0.3614408)^2+8*(3.866913−3.7052303−0.3054996)^2
  ```
  This calculation looks correct, but it would be helpful to explicitly state what each term represents (e.g., group size, group mean, total mean). Without context, it might confuse readers.

---

### **4. F-Statistic Definition**
- The F-statistic formula:
  ```
  F=(RSS1−RSS2)/(p2−p1) / (RSS2/(n−p2))
  ```
  This formula is correct, but the notes should clarify that `RSS1` and `RSS2` are the residual sum of squares for two nested models, and `p1` and `p2` are the number of parameters in those models. The explanation is there but could be more explicit.

---

### **5. Interpretation of ANOVA Results**
- The notes correctly explain that a significant p-value (e.g., `4.477e-06`) indicates a meaningful difference between group means. However, the explanation of what happens when the p-value is not significant (e.g., `0.9499`) could be expanded. For example, it could mention that this suggests no strong evidence to reject the null hypothesis.

---

### **6. Potential Typos or Ambiguities**
- The use of `anovaI()` in the notes might be a typo. The correct function in R is `anova()`. If `anovaI()` is intentional, it should be clarified.
- Some sections, such as the explanation of the F-distribution, are overly technical and might confuse readers who are not familiar with advanced statistical concepts.

---

### **Suggestions for Improvement**
1. **Clarify Key Concepts**: Simplify the explanations of degrees of freedom, F-statistics, and p-values for easier understanding.
2. **Add Context to Formulas**: Provide more context for each formula, such as what each variable represents and why the formula is structured that way.
3. **Check for Typos**: Ensure that all function names and variable names match their usage in R (e.g., `anova()` vs. `anovaI()`).
4. **Highlight Key Takeaways**: Summarize each section with a clear takeaway to reinforce understanding.

---

If you'd like, I can help rewrite or clarify specific sections of the notes to make them easier to understand. Let me know!