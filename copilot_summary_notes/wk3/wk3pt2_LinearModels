Here is a simplified and organized version of the updated notes, following the same structure as the original content. I've broken down the concepts into digestible sections with explanations, examples, and practical applications.

---

## **Week 3 Notes Part 2: Practicing Linear Models**

### **1. Overview**
- **Goal**: Use the ALL dataset to run a linear regression model and evaluate its results.
- **Key Steps**:
  1. Perform a linear fit in R.
  2. Generate diagnostic plots to assess the quality of the fit.
  3. Interpret the results and significance of the model.

---

### **2. Preparing the Data**
- **Dataset**: The ALL dataset contains gene expression levels and patient information.
- **Objective**: Investigate the relationship between gene expression levels and time-to-remission (days from diagnosis to remission).

#### **Code Example**:
```R
library(ALL); data(ALL)
ALL.pdat <- pData(ALL)
date.cr.chr <- as.character(ALL.pdat$date.cr)
diag.chr <- as.character(ALL.pdat$diagnosis)
date.cr.t <- strptime(date.cr.chr, "%m/%d/%Y")
diag.t <- strptime(diag.chr, "%m/%d/%Y")
days2remiss <- as.numeric(date.cr.t - diag.t)

plot(exprs(ALL)["34852_g_at",], as.numeric(days2remiss),
     xlab = "Gene Expression", ylab = "Days-to-remission")
```

- **Explanation**:
  - Convert date strings into date objects using `strptime()`.
  - Calculate `days2remiss` as the difference between remission and diagnosis dates.
  - Plot gene expression (`34852_g_at`) against days-to-remission.

---

### **3. Fitting a Linear Model**
- **Model**: Fit a linear regression model to predict days-to-remission (\( D2R \)) based on gene expression (\( G \)).
- **Formula**: \( D2R \sim G \)

#### **Code Example**:
```R
exprs.34852 <- exprs(ALL)["34852_g_at",]
d2r.34852 <- data.frame(G = exprs.34852, D2R = days2remiss)
lm.34852.g.at <- lm(D2R ~ G, d2r.34852)

coef(lm.34852.g.at)
## (Intercept)           G 
##   152.59905   -21.87222

print(lm.34852.g.at)
## Call:
## lm(formula = D2R ~ G, data = d2r.34852)
## Coefficients:
## (Intercept)            G  
##      152.60       -21.87
```

- **Explanation**:
  - `lm()` fits a linear model.
  - The coefficients indicate:
    - Intercept (\( \beta_0 \)): ~152.6
    - Slope (\( \beta_1 \)): ~-21.9
  - Interpretation: For every unit increase in \( G \), \( D2R \) decreases by ~21.9 days.

---

### **4. Visualizing the Fit**
- **Scatter Plot**: Overlay predicted values on the actual data.

#### **Code Example**:
```R
plot(exprs(ALL)["34852_g_at",], as.numeric(days2remiss),
     xlab = "Gene Expression", ylab = "Days to remission")
points(d2r.34852$G[!is.na(d2r.34852$D2R)],
       predict(lm.34852.g.at), col = "red", pch = 20)
```

- **Explanation**:
  - `predict()` generates predicted values from the fitted model.
  - Red points represent predicted \( D2R \) values for each \( G \).

---

### **5. Quality Control for Model Fitting**
- **Importance**: Real-world data often contain outliers or non-linear trends. Diagnostic plots help assess the fit.

#### **Key Diagnostic Tools**:
1. **Quantile-Quantile (QQ) Plot**:
   - Compares residuals to a normal distribution.
   - Deviations from the diagonal indicate non-normality.

   ```R
   qqnorm(resid(lm.34852.g.at))
   qqline(resid(lm.34852.g.at))
   ```

2. **Histogram of Residuals**:
   - Visualizes the distribution of residuals.

   ```R
   hist(resid(lm.34852.g.at))
   ```

3. **Shapiro-Wilk Test**:
   - Tests for normality of residuals.

   ```R
   shapiro.test(resid(lm.34852.g.at))$p.value
   ## [1] 0.656474
   ```

   - **Interpretation**:
     - \( p > 0.05 \): Residuals are likely normal.
     - \( p \leq 0.05 \): Residuals deviate significantly from normality.

---

### **6. Residuals vs. Fitted Values**
- **Purpose**: Check for patterns in residuals across the range of fitted values.

#### **Code Example**:
```R
plot(fitted(lm.34852.g.at), d2r.34852[!is.na(d2r.34852$D2R), "D2R"],
     xlab = "Fitted", ylab = "Observed")
abline(0, 1, lty = 2)
```

- **Interpretation**:
  - Points should lie close to the diagonal (\( y = x \)).
  - Deviations indicate poor fit or heteroscedasticity (non-constant variance).

---

### **7. Residuals vs. Fitted Plot**
- **Purpose**: Identify non-uniformity in residuals.

#### **Code Example**:
```R
plot(fitted(lm.34852.g.at), resid(lm.34852.g.at),
     xlab = "Fitted", ylab = "Residuals")
abline(h = 0, lty = 2)
```

- **Interpretation**:
  - A "funnel" shape suggests heteroscedasticity.
  - Residuals should have constant variance across fitted values.

---

### **8. Advanced Diagnostic Plots**
- **Built-in Diagnostic Plots**:
  - Generate multiple diagnostic plots at once.

#### **Code Example**:
```R
old.par <- par(mfrow = c(2, 2), ps = 16)
plot(lm.34852.g.at)
par(old.par)
```

- **Plots Generated**:
  1. Residuals vs. Fitted
  2. Normal QQ Plot
  3. Scale-Location Plot
  4. Residuals vs. Leverage (with Cook’s Distance)

- **Key Insights**:
  - High leverage points with large residuals can disproportionately affect the fit.
  - Cook’s Distance helps identify influential points.

---

### **9. Significance Testing with ANOVA**
- **Purpose**: Assess the significance of the predictor variable (\( G \)).

#### **Code Example**:
```R
anova(lm.34852.g.at)
## Analysis of Variance Table
## 
## Response: D2R
##           Df  Sum Sq Mean Sq F value    Pr(>F)    
## G          1  6000.1  6000.1  30.498 2.959e-07 ***
## Residuals 94 18493.6   196.7                      
anova(lm.34852.g.at)$"Pr(>F)"[1]
## [1] 2.958899e-07
```

- **Interpretation**:
  - \( p = 2.96 \times 10^{-7} \): Strong evidence that \( G \) significantly affects \( D2R \).
  - Low \( p \)-value indicates the observed effect is unlikely due to chance.

---

### **10. Testing Another Gene**
- **Objective**: Fit the same model for a different gene and compare results.

#### **Code Example**:
```R
plot(exprs(ALL)["37138_at",], as.numeric(days2remiss),
     xlab = "Gene Expression", ylab = "Days-to-remission")

anova(lm(D2R ~ G, data.frame(
  G = exprs(ALL)["37138_at",],
  D2R = as.numeric(days2remiss))))
## Analysis of Variance Table
## 
## Response: D2R
##           Df  Sum Sq Mean Sq F value Pr(>F)
## G          1    11.1   11.09  0.0426  0.837
## Residuals 94 24482.6  260.45
```

- **Interpretation**:
  - \( p = 0.837 \): No significant relationship between this gene and \( D2R \).
  - Different genes may have varying levels of influence on the response variable.

---

### **Summary**
- **Linear Models**: Useful for exploring relationships between variables.
- **Diagnostics**: Essential for validating model assumptions and identifying issues.
- **Significance Testing**: ANOVA helps quantify the effect of predictors.
- **Practical Application**: Use these tools to analyze gene expression data and its impact on clinical outcomes.

Let me know if you'd like further clarification or additional examples!

Similar code found with 1 license type