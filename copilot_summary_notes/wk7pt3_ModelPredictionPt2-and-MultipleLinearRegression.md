# Week 7 Part 3: Model Prediction (part 2) and Multiple Linear Regression

## Model Prediction Continued
### 📦 **Cross-Validation Code with Detailed Comments**

```r
# 1. Compute days to remission as the difference between two dates
days2remiss <- as.numeric(date.cr.t - diag.t)  # Note 1

# 2. Remove patients with missing remission data from expression matrix
ALL.exprs <- exprs(ALL)[, !is.na(days2remiss)]

# 3. Remove corresponding entries from days2remiss
days2remiss <- days2remiss[!is.na(days2remiss)]

# 4. Create a design matrix for linear modeling: intercept + days2remiss
design.matrix <- cbind(rep(1, length(days2remiss)), days2remiss)

# 5. Set number of cross-validation folds
n.xval <- 5

# 6. Initialize vector to store squared prediction errors
s2.xval <- numeric()

# 7. Randomly assign each sample to one of the folds
xval.grps <- sample((1:dim(ALL.exprs)[2]) %% n.xval + 1)

# 8. Begin cross-validation loop
for (i.xval in 1:n.xval) {

  # 9. Subset training data (exclude current fold)
  ALL.exprs.train <- ALL.exprs[, xval.grps != i.xval]
  design.matrix.train <- design.matrix[xval.grps != i.xval, ]

  # 10. Fit linear models for all genes using training data
  d2r.fit.train <- lmFit(ALL.exprs.train, design.matrix.train)

  # 11. Identify the most predictive gene for days2remiss
  best.gene <- rownames(topTable(eBayes(d2r.fit.train), "days2remiss"))[1]

  # 12. Print the best gene for this fold (all on one line, newline after last fold) fill = i.xval == n.xval: This is a formatting option. If i.xval == n.xval (i.e., this is the last fold of cross-validation), then fill = TRUE. fill = TRUE causes cat() to start a new line after printing. For earlier folds, fill = FALSE, so the gene names are printed on the same line.
  cat(best.gene, " ", fill = i.xval == n.xval)

  # 13. Create a data frame with expression of best gene and days2remiss
  tmp.df <- data.frame(G = ALL.exprs[best.gene, ], D2R = days2remiss)

  # 14. Fit a simple linear model on training data using best gene
  lm.xval <- lm(D2R ~ G, tmp.df[xval.grps != i.xval, ])

  # 15. Predict days2remiss on test set
  test.pred <- predict(lm.xval, tmp.df[xval.grps == i.xval, ])

  # 16. Compute squared prediction errors and store them
  s2.xval <- c(s2.xval, (test.pred - tmp.df[xval.grps == i.xval, "D2R"])^2)
}

# 17. (Optional) Compute average prediction error across all folds
mean(s2.xval)
```

---

### 🧠 Summary of What This Code Does

- Performs **5-fold cross-validation** to evaluate how well gene expression predicts `days2remiss`.
- In each fold:
  - Trains on 4/5 of the data,
  - Selects the **best gene** based on training data,
  - Predicts on the remaining 1/5,
  - Stores the **squared prediction errors**.
- At the end, `s2.xval` contains all squared errors, and `mean(s2.xval)` gives the **average prediction error**.

---
### qn: but since this is repeating for a total of 5 times, what if in the next round of train data it comes up with a different highest gene but still adds the sigma^2 results to the s2.val vector.   
You're absolutely right to raise this — and your understanding is spot-on.

### 🔁 Yes, in each fold of cross-validation:
- A **different subset** of the data is used for training.
- So, the **best gene** (i.e. the one most associated with `days2remiss`) **can change** from fold to fold.
- Despite this, the code **always adds the squared prediction errors** to the same vector `s2.xval`.

---

### 🧠 Why is this okay — and even expected?

This is actually **by design** in cross-validation. Here's why:

#### ✅ 1. **Each fold is independent**
- You're simulating how well your model generalizes to **unseen data**.
- In each fold, you **retrain** the model from scratch — including selecting the best gene.
- This mimics a real-world scenario where you might choose a different predictor based on the available data.

#### ✅ 2. **You're evaluating a strategy, not a fixed model**
- The goal here is not to evaluate one specific gene.
- You're evaluating the **strategy**: “Pick the best gene based on training data, then predict `days2remiss` using it.”
- So it's valid to let the best gene vary — and still collect the squared errors.

#### ✅ 3. **The final metric (e.g., mean of `s2.xval`) tells you how well this strategy performs**
- After the loop, you might compute:
  ```r
  mean(s2.xval)
  ```
  to get the **average squared prediction error** across all folds.
- This gives you an estimate of how well your **gene-selection-and-prediction pipeline** performs on new data.

---

### 📌 Summary

Yes, the best gene can change in each fold — and that’s **expected**. You're not evaluating a single gene, you're evaluating a **modeling approach** that includes:
1. Selecting the best gene from training data,
2. Fitting a model using that gene,
3. Predicting on test data,
4. Measuring error.

Here's a **summary of the key points** made in the note:

---

### 🔍 **Problem with Previous Cross-Validation**
- Earlier model validation was flawed because the gene used to build the model was selected using the **entire dataset**, including the test set.
- This leads to **data leakage**, resulting in **overly optimistic** estimates of model performance.

---

### ✅ **Correct Cross-Validation Approach**
- The dataset is split into **5 folds** for cross-validation.
- In each iteration:
  1. **One fold is held out** as the test set.
  2. The model is trained on the remaining data.
  3. The **most significant gene** is selected **using only the training set**.
  4. A linear model is fit using that gene.
  5. Predictions are made on the test set, and **squared residuals** are recorded.

---

### 🧪 **Tools and Methods Used**
- `lmFit()` is used instead of `lm()` for efficiency with microarray data.
- A **design matrix** is created with:
  - Column 1: Intercept (all 1s)
  - Column 2: Days to remission
- `eBayes()` and `topTable()` are used to find the most significant gene.

---

### 📉 **Results and Observations**
- The **mean squared error** (MSE) from this correct method is **~272**, compared to **~204** from the flawed method.
- This shows that the earlier method **overestimated accuracy by ~25%**.
- The **most significant gene varies** across folds, indicating:
  - Multiple genes may be similarly predictive.
  - Some training sets may include **outliers** that skew results.

---

### 🤔 **Interpretation and Strategies**
Several strategies are discussed for handling variability in gene selection:

1. **Consensus Approach**:
   - Run multiple resamplings.
   - Select genes that appear most frequently as significant.
   - More robust, but **not ideal for estimating prediction accuracy**.

2. **Multi-Gene Models**:
   - Combine multiple significant genes into one model.
   - May improve predictive power.

3. **Focus on Predictive Power**:
   - If the goal is to assess **dataset potential**, not specific genes, variability is less concerning.

4. **Hybrid Approach**:
   - Set aside a **true test set**.
   - Use resampling on the training set to select genes.
   - Evaluate final model on the untouched test set.

## Multiple Linear Regression

### 🧠 **Conceptual Background**

#### 1. **Simple vs. Multiple Linear Regression**
- **Simple linear regression** models the relationship between one independent variable (e.g., expression of a single gene) and a dependent variable (e.g., days to remission).
- **Multiple linear regression** extends this to include **multiple independent variables** (e.g., expression levels of several genes) to predict the dependent variable.

#### 2. **Why Use Multiple Genes?**
- In real biological systems, outcomes like remission time are rarely influenced by a single gene.
- Multiple genes may each contribute **unique information** that improves prediction.
- However, if two genes are **highly correlated** (e.g., one is a linear transformation of the other), adding both doesn’t help because they don’t provide new information.

---

### 🔍 **Feature Selection**
- The goal is to find a **subset of genes** that:
  - Are **strongly correlated** with the outcome (D2R).
  - Are **not too correlated** with each other (to avoid redundancy).
- This is a classic **feature selection** problem in machine learning and statistics.

---

### 🧪 **Practical Example in R**

#### Step 1: Create a Data Frame
```r
g3.df <- data.frame(D2R=x.d2r, G1=exprs.34852, G2=exprs.35296, G3=exprs.1213)
g3.df <- g3.df[!is.na(g3.df$D2R),]
```
- Combines D2R and expression levels of three genes into a single data frame.
- Removes rows with missing D2R values.

#### Step 2: Fit Models
```r
lm.g1 <- lm(D2R ~ G1, g3.df)
lm.g12 <- lm(D2R ~ G1 + G2, g3.df)
```
- `lm.g1`: Simple regression with one gene.
- `lm.g12`: Multiple regression with two genes.

#### Step 3: Interpret Model Summary
```r
summary(lm.g12)
```
- Shows coefficients, standard errors, t-values, and p-values.
- Both G1 and G2 are statistically significant predictors of D2R.

#### Step 4: ANOVA Analysis
```r
anova(lm.g12)
```
- Breaks down how much **variance** each gene explains.
- G1 explains 6000.1 units of variance.
- G2 adds another 2146.3 units.

#### Step 5: Compare Models
```r
anova(lm.g1, lm.g12)
```
- Compares the one-gene and two-gene models.
- Shows that adding G2 significantly improves the model (p = 0.00073).

---

### 🔁 **Trying a Different Gene Combination**
```r
lm.g13 <- lm(D2R ~ G1 + G3, g3.df)
```
- Replaces G2 with G3.
- G3 explains **more variance** (2805.9 vs. 2146.3), suggesting a better model.

This section builds on the previous discussion of **multiple linear regression** by diving deeper into:

1. **Model coefficients and design matrices**
2. **Model diagnostics**
3. **Model complexity and overfitting**
4. **Model comparison using AIC (Akaike Information Criterion)**

Let’s break it down clearly:

---

### 🧮 1. **Model Coefficients and Design Matrix**

#### Coefficients:
```r
summary(lm.g1)$coef
summary(lm.g13)$coef
```
- These show the **estimated coefficients** for the intercept and gene expression variables.
- For example, in `lm.g1`, the coefficient for `G1` is -21.87, meaning that for each unit increase in `G1`, the predicted `D2R` decreases by ~21.87 days, assuming a linear relationship.

#### Design Matrix:
```r
model.matrix(lm.g1)[1:3,]
model.matrix(lm.g13)[1:3,]
```
- The **design matrix** is the matrix of input features used in the regression.
- The predicted values are computed as:
  $$
  \hat{y} = X \cdot \beta
  $$
  where \( X \) is the design matrix and \( \beta \) is the vector of fitted coefficients.

---

### 📉 2. **Model Diagnostics**

Using:
```r
plot(lm.g1)
plot(lm.g13)
```
- These generate diagnostic plots (residuals vs fitted, Q-Q plot, etc.).
- Even though `lm.g13` fits the data better (lower residual sum of squares), it may **violate assumptions** (e.g., normality, homoscedasticity) more than the simpler model.

---

### ⚠️ 3. **Model Complexity and Overfitting**

- Adding more variables **always improves fit** (or at least doesn’t worsen it) because the model becomes more flexible.
- But this can lead to **overfitting**—fitting noise rather than signal.
- Example: fitting 93 data points with 1000 genes will almost certainly overfit.

---

### 📊 4. **Model Comparison with AIC**

#### AIC Formula:
$$
\text{AIC} = n \cdot \log\left(\frac{\text{RSS}}{n}\right) + 2k
$$
- \( n \): number of observations
- \( \text{RSS} \): residual sum of squares
- \( k \): number of parameters (including intercept)

#### Interpretation:
- **Lower AIC is better**.
- AIC balances **fit quality** (via RSS) and **model complexity** (via \( k \)).

#### Example Output:
```r
AIC(lm(D2R~G1,g3.df),
    lm(D2R~G3,g3.df),
    lm(D2R~G1+G3,g3.df),
    lm(D2R~G1*G3,g3.df))
```
| Model               | df | AIC     |
|--------------------|----|---------|
| D2R ~ G1           | 3  | 783.48  |
| D2R ~ G3           | 3  | 786.84  |
| D2R ~ G1 + G3      | 4  | 769.68  |
| D2R ~ G1 * G3      | 5  | 770.55  |

- **Best model**: `D2R ~ G1 + G3` (lowest AIC).
- Adding an interaction term (`G1 * G3`) slightly improves fit but **not enough** to justify the extra parameter.

---

### 📌 **What is BIC?**

The **Bayesian Information Criterion** is defined as:

$$
\text{BIC} = k \cdot \log(n) - 2 \cdot \log(L)
$$

Where:
- \( k \) = number of model parameters (including the intercept),
- \( n \) = number of observations (data points),
- \( L \) = likelihood of the model given the data.

When the residual sum of squares (RSS) is known and assuming constant variance, BIC can be approximated as:

$$
\text{BIC} = n \cdot \log\left(\frac{\text{RSS}}{n}\right) + k \cdot \log(n)
$$

---

### 🔍 **How is BIC Different from AIC?**

- **AIC** penalizes model complexity with a constant factor: \( 2k \)
- **BIC** penalizes complexity more heavily as \( \log(n) \cdot k \), which **increases with sample size**
- As a result, **BIC tends to favor simpler models** more strongly than AIC, especially when \( n \) is large.

---

### 🧪 **Example Output (Using `AIC()` with `k = log(n)`)**

```r
AIC(lm(D2R~G1, g3.df),
    lm(D2R~G3, g3.df),
    lm(D2R~G1+G3, g3.df),
    lm(D2R~G1*G3, g3.df),
    k=log(dim(g3.df)[1]))
```

| Model               | df | BIC (via AIC with `k=log(n)`) |
|--------------------|----|-------------------------------|
| D2R ~ G1           | 3  | 791.17                        |
| D2R ~ G3           | 3  | 794.53                        |
| D2R ~ G1 + G3      | 4  | 779.94                        |
| D2R ~ G1 * G3      | 5  | 783.37                        |

- **Best model**: `D2R ~ G1 + G3` (lowest BIC).
- Adding the interaction term (`G1 * G3`) increases complexity without enough improvement in fit, so BIC increases.

---

### ✅ **Key Takeaways**

- **BIC is more conservative** than AIC in adding parameters.
- Both AIC and BIC are useful for comparing **non-nested and nested models**.
- When comparing models with the **same number of parameters**, AIC and BIC reduce to comparing likelihoods.
- In this example, both AIC and BIC agree that `D2R ~ G1 + G3` is the best model among those tested.

---
