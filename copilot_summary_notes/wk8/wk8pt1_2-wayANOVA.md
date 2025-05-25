#Week8 Part 1: 2 Way ANOVA

---

## One-way ANOVA (Refresher)
- **Purpose:** Tests if the mean of a dependent variable (Y) differs across groups defined by one independent variable (X).
- **How it works:** 
  - If all variation in Y can be explained by X, then knowing X tells you everything about Y.
  - In reality, some variation in Y is explained by X, and some is just random noise.
  - ANOVA measures how much of Y’s variation is explained by X versus unexplained (noise).
- **X can be categorical:** For example, comparing gene expression between groups like “smokers” vs “non-smokers”.

**Example in R:**
```r
lm.1970.s.at.fp <- lm(exprs(ALL)["1970_s_at",]~fus.prot)
anova(lm.1970.s.at.fp)
```
This fits a model and runs ANOVA to see if gene expression differs by fusion protein status.

---

## Two-way ANOVA (Two Independent Variables)
- **Purpose:** Tests how two independent variables (e.g., Drug A and Drug B) affect a dependent variable, and if there’s an interaction between them.
- **Interaction:** Means the effect of one variable depends on the level of the other (e.g., Drug A works differently if Drug B is present).
- **Design:** 
  - Both variables are categorical (e.g., Drug A: Yes/No, Drug B: Yes/No).
  - Four groups: No drugs, A only, B only, A+B.
- **Why not run two separate tests?**
  - If there’s interaction, separate tests miss it.
  - Two-way ANOVA can test for both main effects and interaction.

---

**In summary:**  
- **One-way ANOVA:** Tests effect of one variable on outcome.
- **Two-way ANOVA:** Tests effects of two variables and their interaction on outcome.

Certainly! Here’s a clear explanation of **Scenarios 1–4** from your notes, focusing on what’s happening with the two drugs (A and B) and the outcome variable:

---

## Scenario 1: **No Effect**
- **What’s happening:**  
  Neither drug A nor drug B has any effect on the outcome.
- **What you’d see:**  
  All groups (no drugs, A only, B only, A+B) have the same outcome value.
- **Graph:**  
  Both lines (A=0 and A=1) are flat and overlap—no difference between groups.
- **Interpretation:**  
  There’s no main effect of A, no main effect of B, and no interaction.

---

## Scenario 2: **Independent (Additive) Effects**
- **What’s happening:**  
  Both drugs have an effect, and their effects simply add together. The effect of one drug does not depend on the presence of the other.
- **What you’d see:**  
  - Drug A increases the outcome by a certain amount.
  - Drug B increases the outcome by a certain amount.
  - Both together increase the outcome by the sum of their effects.
- **Graph:**  
  Two parallel lines, separated vertically (showing the effect of A), both sloping upward (showing the effect of B).
- **Interpretation:**  
  There are main effects for both A and B, but no interaction.

---

## Scenario 3: **Mutual Enhancement (Positive Interaction)**
- **What’s happening:**  
  Each drug has an effect on its own, but when given together, the combined effect is **greater than the sum** of their individual effects.
- **What you’d see:**  
  - A only: moderate increase.
  - B only: moderate increase.
  - A+B: much larger increase than expected from adding the two effects.
- **Graph:**  
  Lines are **not parallel**—the gap between them widens as you move along the B axis, showing that the effect of A is bigger when B is present (and vice versa).
- **Interpretation:**  
  There are main effects for A and B, **plus a positive interaction**.

---

## Scenario 4: **Negative Interaction (Mutual Weakening)**
- **What’s happening:**  
  Each drug has an effect on its own, but when given together, they **cancel each other out** or weaken each other’s effect.
- **What you’d see:**  
  - A only: increase.
  - B only: increase.
  - A+B: outcome is similar to no drugs, or less than expected.
- **Graph:**  
  Lines **cross**—the effect of A is reduced or reversed when B is present.
- **Interpretation:**  
  Main effects are masked or disappear due to a **negative interaction**.

---

### **Summary Table**

| Scenario | Main Effect A | Main Effect B | Interaction | Graph Shape         |
|----------|---------------|---------------|-------------|---------------------|
| 1        | No            | No            | No          | Flat, overlapping   |
| 2        | Yes           | Yes           | No          | Parallel lines      |
| 3        | Yes           | Yes           | Positive    | Lines diverge       |
| 4        | Yes           | Yes           | Negative    | Lines cross         |

---

Absolutely! Here’s a detailed, step-by-step explanation of the section you’re struggling with, focusing on **two-way ANOVA** and how the variance is split up:

---

## Key Concepts

### 1. **What is Two-Way ANOVA?**
- **Two-way ANOVA** is a statistical test used to determine how two different factors (independent variables) affect a single outcome (dependent variable).
- It also checks if there’s an **interaction** between the two factors (i.e., does the effect of one factor depend on the level of the other?).

---

### 2. **How is the Data Organized?**
- Imagine you have two factors:  
  - **A** (e.g., Drug A: Yes/No)
  - **B** (e.g., Drug B: Yes/No)
- You measure the outcome (e.g., cholesterol) for each combination:
  - No Drug A, No Drug B
  - Drug A only
  - Drug B only
  - Both drugs

---

### 3. **How is the Variance Split?**
- **Total variance** in your data (how much the outcome varies overall) can be split into:
  1. **Variance explained by Factor A** (row effect)
  2. **Variance explained by Factor B** (column effect)
  3. **Variance explained by the interaction** (A and B together)
  4. **Unexplained variance** (random noise, within-group)

#### **Formulas:**
- **Total Sum of Squares (SStotal):**  
  Measures how much all your data points vary from the overall mean.
- **Within-group Sum of Squares (SSwithin):**  
  Measures how much data points vary from their group mean (i.e., random noise).
- **Between-group Sum of Squares (SSbetween):**  
  SStotal - SSwithin; how much is explained by your factors.

#### **Breaking Down SSbetween:**
- **SSrow:** Variance explained by Factor A (row means vs. overall mean)
- **SScol:** Variance explained by Factor B (column means vs. overall mean)
- **SSinteraction (SSRxC):** Variance explained by the interaction between A and B

So:
```
SSbetween = SSrow + SScol + SSinteraction
```
Or rearranged:
```
SSinteraction = SSbetween - SSrow - SScol
```

---

### 4. **Degrees of Freedom**
- **NT:** Total number of measurements
- **r:** Number of levels for Factor A (rows)
- **c:** Number of levels for Factor B (columns)
- Each source of variance (row, column, interaction, within) has its own degrees of freedom, which are used to calculate the F-statistics.

---

### 5. **What Do the F-Tests Tell You?**
- **Frow:** Is there a main effect of Factor A?
- **Fcol:** Is there a main effect of Factor B?
- **Finteraction:** Is there an interaction between A and B?

Each F-test compares the variance explained by that factor to the unexplained variance (noise).

---

## **Summary Table**

| Source         | Sum of Squares | Degrees of Freedom      | F-test         |
|----------------|----------------|------------------------|----------------|
| Factor A (row) | SSrow          | r - 1                  | Frow           |
| Factor B (col) | SScol          | c - 1                  | Fcol           |
| Interaction    | SSinteraction  | (r - 1) * (c - 1)      | Finteraction   |
| Within         | SSwithin       | NT - r * c             |                |
| Total          | SStotal        | NT - 1                 |                |

---

## **In Plain English**

- **Two-way ANOVA** lets you see if each factor matters, and if their combination matters in a way you wouldn’t expect from looking at them separately.
- The math splits up the total variation in your data into parts explained by each factor, their interaction, and random noise.
- You use F-tests to see if each part is big enough to be considered “real” (statistically significant).

---
Here’s a simplified breakdown of each section of your notes:

---

### **5. Interpretation of the Results**

- **Main effects can be confounded by interaction:**  
  If two variables interact, it’s hard to interpret the effect of each variable alone.
- **Why run a two-way ANOVA?**  
  To check if there’s an interaction between variables.
- **If interaction exists:**  
  Main effects (the effect of each variable alone) may not make sense. You may need to split (stratify) your data and analyze each group separately.
- **If you don’t suspect interaction:**  
  The main effect is just the effect of one variable, averaged over the other.

---

### **Example: Drug A and Sex**

- If you only look at Drug A, you might miss that it works differently in males and females.
- If you later split the data by sex, you might find Drug A helps males but harms females.
- In this case, the overall effect of Drug A is meaningless—you need to look at each group separately.

---

### **6. Examples in R**

- **Dataset:**  
  Two categorical variables: sex (M/F) and relapse (TRUE/FALSE) in the ALL dataset.
- **Goal:**  
  Study how these two variables affect gene expression for one gene.
- **R code:**  
  - `table(pData(ALL)[,c("sex","relapse")])` shows how many patients are in each group.
  - `anova(lm(expr.158.at~sex*relapse,df.tmp))` runs a two-way ANOVA with interaction.
  - `boxplot(expr.158.at~sex+relapse,df.tmp)` shows gene expression by both variables.
  - `boxplot(expr.158.at~relapse,df.tmp)` shows gene expression by relapse only.

---

### **Interpreting the R Output**

- The ANOVA table shows:
  - **sex** and **relapse** main effects are not significant.
  - **sex:relapse** interaction is highly significant.
- **What does this mean?**  
  The effect of relapse depends on sex (and vice versa). Main effects alone are misleading.

---

### **Visualizing the Data**

- When you plot gene expression by both sex and relapse:
  - In females, relapse increases expression.
  - In males, relapse decreases expression.
- If you only look at relapse (ignoring sex), you see no effect—this is why interaction matters.

---

### **Understanding the Design Matrix**
model.matrix(lm(expr.158.at~sex*relapse,df.tmp))[1:5,]

###       (Intercept) sexM relapseTRUE sexM:relapseTRUE
### 01005           1    1           0                0
### 01010           1    1           1                1
### 03002           1    0           1                0
### 04006           1    1           1                1
### 04007           1    1           1                1

- The design matrix is how R encodes the groups for the model.
- **Intercept:** Mean for the reference group (sex=F, relapse=FALSE).
- **sexM:** Difference between males and the reference group (when relapse=FALSE).
- **relapseTRUE:** Difference between relapse=TRUE and the reference group (when sex=F).
- **sexM:relapseTRUE:** The extra effect when both sex=M and relapse=TRUE (the interaction).
- The coefficients in the model tell you how much each group mean differs from the reference group.

In R, when you use `lm()` with categorical variables, the **design matrix** columns are created based on the variable names and their levels. Here’s how you can tell which variable is which column:

### 1. **Intercept**
- The first column, usually called `(Intercept)`, represents the baseline group (the reference level for all categorical variables).

### 2. **Main Effects**
- Each categorical variable gets a column for each level **except** the reference level.
- The column name is the variable name plus the level (e.g., `sexM` means "sex is Male" compared to the reference, which is Female).

### 3. **Interaction Terms**
- For interactions (e.g., `sex*relapse`), R creates columns named like `sexM:relapseTRUE`.
- This column is 1 only when **both** `sex` is "M" and `relapse` is `TRUE`.

### 4. **Check with `model.matrix()`**
- You can always see the actual design matrix and column names by running:
    ```r
    model.matrix(lm(expr.158.at ~ sex * relapse, df.tmp))
    ```
- The column names will show you exactly which variable and level each column represents.

---

**Summary Table Example:**

| Column Name           | Meaning                                 |
|---------------------- |-----------------------------------------|
| (Intercept)           | sex = F, relapse = FALSE (reference)    |
| sexM                  | sex = M, relapse = FALSE                |
| relapseTRUE           | sex = F, relapse = TRUE                 |
| sexM:relapseTRUE      | sex = M, relapse = TRUE (interaction)   |

---

**Tip:**  
The reference level is usually the first level alphabetically, unless you set it with `factor()` and `levels=`.

Yes! Here’s how you can **check which group each column in the design matrix represents by looking at the means**:

---

### **How the Means Relate to the Design Matrix Columns**

Suppose you have two categorical variables: `sex` (F/M) and `relapse` (FALSE/TRUE).  
R’s default design matrix for `lm(expr ~ sex * relapse, data)` will have these columns:
- `(Intercept)`
- `sexM`
- `relapseTRUE`
- `sexM:relapseTRUE`

#### **What Each Column Means**
- **(Intercept):**  
  The mean of the reference group (here, `sex = F` and `relapse = FALSE`).
- **sexM:**  
  The difference between the mean of `sex = M, relapse = FALSE` and the reference group.
- **relapseTRUE:**  
  The difference between the mean of `sex = F, relapse = TRUE` and the reference group.
- **sexM:relapseTRUE:**  
  The extra difference for `sex = M, relapse = TRUE` beyond what you’d expect from adding the main effects.

---

### **How to Check This with Means**

You can **calculate the mean expression** for each group and compare it to the model coefficients:

#### **Example:**
Suppose your means are:
- `mean_F_FALSE = 4.25` (sex=F, relapse=FALSE)
- `mean_M_FALSE = 4.50` (sex=M, relapse=FALSE)
- `mean_F_TRUE = 4.54` (sex=F, relapse=TRUE)
- `mean_M_TRUE = 4.40` (sex=M, relapse=TRUE)

And your model summary gives:
- `(Intercept)` = 4.25
- `sexM` = 0.25
- `relapseTRUE` = 0.29
- `sexM:relapseTRUE` = -0.39

#### **How to Interpret:**
- `(Intercept)` is the mean for `sex=F, relapse=FALSE` (matches `mean_F_FALSE`).
- `sexM` is `mean_M_FALSE - mean_F_FALSE` (should be 4.50 - 4.25 = 0.25).
- `relapseTRUE` is `mean_F_TRUE - mean_F_FALSE` (should be 4.54 - 4.25 = 0.29).
- `sexM:relapseTRUE` is the extra effect for `sex=M, relapse=TRUE`:
    - Predicted mean for `sex=M, relapse=TRUE` =  
      `(Intercept)` + `sexM` + `relapseTRUE` + `sexM:relapseTRUE`
    - Plug in the numbers: 4.25 + 0.25 + 0.29 + (-0.39) = 4.40 (matches `mean_M_TRUE`).

---

### **Summary Table**

| Group                | Formula using Coefs                | Should Equal      |
|----------------------|------------------------------------|------------------|
| F, FALSE (reference) | (Intercept)                        | mean_F_FALSE     |
| M, FALSE             | (Intercept) + sexM                 | mean_M_FALSE     |
| F, TRUE              | (Intercept) + relapseTRUE          | mean_F_TRUE      |
| M, TRUE              | (Intercept) + sexM + relapseTRUE + sexM:relapseTRUE | mean_M_TRUE |

---

**This is how you check which group each column represents:**
- Calculate the mean for each group.
- See how the model coefficients add up to those means.
- This confirms the meaning of each column in the design matrix.

---

**Summary:**  
- If there’s a significant interaction, main effects are not meaningful on their own.
- Always check for interaction before interpreting main effects.
- The design matrix and model coefficients help you understand how each group compares to the reference group.
___


## 6.1 Selectig most significant cross-terms
Great observation! Let’s clarify what’s happening in your design matrix:

```
##   (Intercept) sex.wo.naM relapse.wo.naTRUE sex.wo.naM:relapse.wo.naTRUE
## 1           1          1                 0                            0
## 2           1          1                 1                            1
## 3           1          0                 1                            0
## 4           1          1                 1                            1
## 5           1          1                 1                            1
```

### **What does the `sex.wo.naM` column mean?**

- `sex.wo.naM` is **1 if the sample is male**, **0 if female**.
- In your first 5 rows, it’s 1 for rows 1, 2, 4, and 5, so those samples are male.
- Row 3 is the only one with `sex.wo.naM = 0`, so that sample is female.

### **What about the interaction column?**

- `sex.wo.naM:relapse.wo.naTRUE` is **1 only if both** `sex.wo.naM` and `relapse.wo.naTRUE` are 1 (i.e., male AND relapse TRUE).
- For example, row 2: both `sex.wo.naM` and `relapse.wo.naTRUE` are 1, so the interaction is 1.
- Row 3: `sex.wo.naM = 0` (female), so interaction is 0, even though `relapse.wo.naTRUE = 1`.

### **Why does it look like there are only males?**

- In your sample, the first 5 rows just happen to be mostly males. This is just the order of your data, not a property of the design matrix itself.
- If you look further down, you’ll see rows with `sex.wo.naM = 0` (females).

### **Summary Table for Your Example**

| Row | (Intercept) | sex.wo.naM | relapse.wo.naTRUE | sex.wo.naM:relapse.wo.naTRUE | Interpretation         |
|-----|-------------|------------|-------------------|------------------------------|-----------------------|
| 1   | 1           | 1          | 0                 | 0                            | Male, relapse=FALSE   |
| 2   | 1           | 1          | 1                 | 1                            | Male, relapse=TRUE    |
| 3   | 1           | 0          | 1                 | 0                            | Female, relapse=TRUE  |
| 4   | 1           | 1          | 1                 | 1                            | Male, relapse=TRUE    |
| 5   | 1           | 1          | 1                 | 1                            | Male, relapse=TRUE    |

**So:**  
- The second column (`sex.wo.naM`) being 1 means the sample is male.
- If you see 1s in both `sex.wo.naM` and `relapse.wo.naTRUE`, and also in the interaction column, that’s a male with relapse=TRUE.
- There is **never** a case where a sample is both male and female; the columns just encode group membership.

Here’s what these lines do, step by step:

```r
limma.fit.e <- eBayes(lmFit(exprs.wo.na,design))
#note that we ask for most significant cross-terms below:
topTable(limma.fit.e,"sex.wo.naM:relapse.wo.naTRUE",5)
```

### **Explanation**

1. **`lmFit(exprs.wo.na, design)`**  
   - Fits a linear model to the expression data for **all genes** at once, using your design matrix (which includes sex, relapse, and their interaction).
   - Each gene gets its own set of coefficients for the model.

2. **`eBayes(...)`**  
   - Applies empirical Bayes moderation to the standard errors, which improves statistical reliability when testing thousands of genes.

3. **`topTable(limma.fit.e, "sex.wo.naM:relapse.wo.naTRUE", 5)`**  
   - Finds the **top 5 genes** with the most significant interaction effect between sex (male) and relapse (TRUE).
   - `"sex.wo.naM:relapse.wo.naTRUE"` tells `topTable` to focus on the interaction term (the cross-term column in your design matrix).

### **In summary:**
- This code identifies the genes whose expression is **most strongly affected by the interaction** between sex and relapse status, not just by sex or relapse alone.
- The result is a table of the top 5 genes for this interaction effect, showing statistics like log fold change, t-value, and p-value for the interaction.

When you specify `"sex.wo.naM:relapse.wo.naTRUE"` in `topTable()`, you are asking for genes where the **interaction** between being male and having relapse=TRUE is strongest. This means:

- The coefficient for `sex.wo.naM:relapse.wo.naTRUE` tells you **how much the effect of relapse=TRUE is different in males compared to females** (or vice versa).
- If you are **female and relapse=TRUE**, the interaction term is **not** included in your predicted value (because `sex.wo.naM = 0` for females, so the interaction is 0).

#### **What about females with relapse=TRUE?**
- Their effect is captured by the **main effect** for `relapse.wo.naTRUE` (not the interaction).
- The interaction term only “activates” (is nonzero) when both `sex.wo.naM = 1` (male) **and** `relapse.wo.naTRUE = 1` (relapse=TRUE).

#### **Summary Table:**

| Sex    | Relapse | Main Effects Used                | Interaction Used? |
|--------|---------|----------------------------------|-------------------|
| Female | FALSE   | (Intercept)                      | No                |
| Female | TRUE    | (Intercept) + relapse.wo.naTRUE  | No                |
| Male   | FALSE   | (Intercept) + sex.wo.naM         | No                |
| Male   | TRUE    | (Intercept) + sex.wo.naM + relapse.wo.naTRUE | **Yes** (`sex.wo.naM:relapse.wo.naTRUE`) |

**So:**  
- The interaction term specifically measures the “extra” effect in **males with relapse=TRUE** compared to what you’d expect from adding the main effects of sex and relapse alone.
- For **females with relapse=TRUE**, only the main effect for relapse is used.

If you want to find genes where the effect is strongest in **females with relapse=TRUE**, you would look at the main effect for `relapse.wo.naTRUE` (and possibly compare it to the interaction term to see if the effect is different in males).

## 6.3 Categorical and continuous variables

Here’s a clear breakdown of what these results mean for the **fit with interaction**:

---

### **Coefficient Table (`summary(lm(D2R~G*FP,df.41690.fp))$coef`)**

| Term           | Estimate    | Std. Error | t value  | Pr(>|t|)   | Interpretation |
|----------------|-------------|------------|----------|------------|---------------|
| (Intercept)    | 135.09      | 17.06      | 7.92     | 9.8e-07    | Baseline days-to-remission when G=0 and FP is the reference group (probably "p190"). |
| G              | -9.15       | 2.32       | -3.95    | 0.00129    | For the reference FP group, each unit increase in gene expression **decreases** days-to-remission by ~9.15 days (significant). |
| FPp190/p210    | 4.36        | 47.35      | 0.09     | 0.93       | No significant difference in baseline D2R between "p190" and "p190/p210" when G=0. |
| FPp210         | -179.51     | 38.92      | -4.61    | 0.00034    | Strongly **lower** baseline D2R for "p210" group compared to "p190" when G=0 (significant). |
| G:FPp190/p210  | -0.75       | 6.17       | -0.12    | 0.91       | No significant interaction between G and "p190/p210". |
| G:FPp210       | 23.87       | 4.97       | 4.81     | 0.00023    | **Strong, significant interaction:** In the "p210" group, the effect of G on D2R is **much more positive** (i.e., the relationship between gene expression and D2R is very different in this group). |

---

### **ANOVA Table**

| Source | Df | Sum Sq | Mean Sq | F value | Pr(>F)   | Interpretation |
|--------|----|--------|---------|---------|----------|---------------|
| G      | 1  | 458.16 | 458.16  | 5.17    | 0.038*   | Gene expression has a significant effect on D2R, but only when considering the interaction. |
| FP     | 2  | 241.11 | 120.55  | 1.36    | 0.29     | Fusion protein status alone is **not** significant. |
| G:FP   | 2  | 2131.18| 1065.59 | 12.04   | 0.00076*** | The **interaction** between gene expression and fusion protein status is **highly significant**. |
| Resid. | 15 | 1328.02| 88.53   |         |          | Remaining unexplained variance. |

---

### **What does this mean?**

- **The interaction term (G:FPp210) is highly significant.**  
  This means the effect of gene expression on days-to-remission **depends strongly on which fusion protein group the patient is in**—especially for the "p210" group.
- **Main effects alone (G or FP) are not enough:**  
  If you ignore the interaction, you miss the real relationship. The effect of gene expression is very different in the "p210" group compared to others.
- **In summary:**  
  - For most groups, gene expression may not matter much.
  - For the "p210" group, gene expression has a **very strong and opposite effect** on days-to-remission.
  - This is why the interaction term is so important and highly significant.

---

**Bottom line:**  
The relationship between gene expression and days-to-remission is **not the same for all fusion protein groups**. The "p210" group behaves very differently, and this is only revealed when you include the interaction in your model.

---

### To create plot like seen in notes:

```
# Assume df.41690.fp has columns: D2R, G, FP

# Set up colors for each fusion protein group
fp.groups <- c("p190", "p190/p210", "p210")
colors <- c("black", "blue", "red")

# Assign colors to each point based on FP group
point.colors <- colors[as.numeric(factor(df.41690.fp$FP, levels=fp.groups))]

# Plot with open triangles
plot(df.41690.fp$G, df.41690.fp$D2R,
     col=point.colors,
     pch=2, # open triangle
     xlab="41690_at",
     ylab="D2R")

# Add regression lines for each group (dashed)
for (i in seq_along(fp.groups)) {
  idx <- df.41690.fp$FP == fp.groups[i]
  abline(lm(D2R ~ G, data=df.41690.fp, subset=idx), col=colors[i], lty=2, lwd=2)
}

# Add colored legend
legend("bottomleft",
       legend=fp.groups,
       col=colors,
       lty=1, lwd=2, text.col=colors, pch=2, bty="n")
```
