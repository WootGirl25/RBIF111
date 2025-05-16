# Week 7 Part 1 & 2  
# Part1 - Model prediction
Can use Model Cross-Validation or Model Bootstrapping - printed notes very clear. Concept is to train the model on a subset of data, then test it on the other subset which should be unknown data.   
- If sigma^2 (residual varaince) from lm() fitted to whole data == MSE (mean of squared error) (from cross validation or bootstrapping) --> then model generalizes well.  
- If sigma^2 < MSE  --> Model is overfitting. Meaning the model fits training data better than test data, ie it is learning the noise as if it were a signal.  

## Model Selection:
"As we have mentioned earlier, there is still a caveat with the approach we were following so far. If we had an externally defined model and just needed to assess its accuracy, what we did would be acceptable. However, our situation was different. Namely, while we assessed the model properly by splitting the data into the training and testing sets, the model selection was performed using the whole dataset. Indeed, you may remember how we ended up with a particular gene we were using here: we started with the days-to-remission variable Y, which we considered as being dependent on gene expression. We have checked the association of every gene’s expression profile Xi with Y using all the patients (i.e. we started from a large number of potentially predictive models), and then we selected the model (gene) Y∼X
with the most significant association. In light of the model accuracy assessment we are performing now, this is not fair: the very identity of the most significant association we have found is aware of all the data (and thus of the test set as well). We can thus suspect that the prediction quality estimation will be still too optimistic, because we chose a gene (model) in a way that captured to some extent an association present in a test set. Instead, we should have selected and trained the model on a training set, while being completely blind to the test set. We will realize this program in the rest of this week material."
 

Qn "This is essentially saying that we should train our initial linear model to determine which gene has the lowest pvalue right?"   
Yes, you're absolutely right — and you're touching on a **very important concept in model evaluation and selection**: **data leakage** and **selection bias**.

---

### 🔍 What happened in your original approach?

1. **You used the entire dataset** to:
   - Test the association between **every gene** and the outcome (`Days-to-Remission`).
   - Select the gene with the **lowest p-value** (i.e., the strongest apparent association).

2. Then, you:
   - Built a model using that gene.
   - Evaluated its performance using cross-validation.

---

### ⚠️ Why is this a problem?

Because the **gene selection step** already "saw" the entire dataset — including what would later be used as the **test set** in cross-validation.

This means:
- The model was **influenced by the test data** before it was even evaluated.
- The **test set is no longer independent**, which violates a core principle of model validation.
- As a result, your **cross-validation MSE is likely too optimistic**.

---

### ✅ What should be done instead?

To properly assess model performance, you should:

1. **Split the data** into training and test sets **first**.
2. **Within the training set only**:
   - Perform gene selection (e.g., find the gene with the lowest p-value).
   - Train the model using that gene.
3. **Then**, evaluate the model on the **held-out test set**.

This ensures that:
- The test set is **completely unseen** during model selection and training.
- Your performance estimate is **unbiased and realistic**.

### 🧠 So yes — your understanding is correct!


# Part2 - Design Matrix  

You're working with a **linear regression model** of the form:

$$
y_i = a x_i + b + \varepsilon_i
$$

This can be rewritten in **matrix form** as:

$$
\begin{bmatrix}
y_1 \\
y_2 \\
\vdots \\
y_n
\end{bmatrix}
=
\begin{bmatrix}
1 & x_1 \\
1 & x_2 \\
\vdots & \vdots \\
1 & x_n
\end{bmatrix}
\begin{bmatrix}
b \\
a
\end{bmatrix}
+
\begin{bmatrix}
\varepsilon_1 \\
\varepsilon_2 \\
\vdots \\
\varepsilon_n
\end{bmatrix}
$$

### So, which part is the **design matrix**?

The **design matrix** is:

$$
\mathbf{X} =
\begin{bmatrix}
1 & x_1 \\
1 & x_2 \\
\vdots & \vdots \\
1 & x_n
\end{bmatrix}
$$

This matrix contains:
- A column of 1s (to account for the intercept \( b \)),
- A column of the observed values \( x_1, x_2, \dots, x_n \).

### Why is it called the design matrix?

Because it "designs" how the predictors (in this case, just \( x \)) are used to model the response variable \( y \). It's a standard term in linear regression and more generally in linear models.
---

### Why are the coefficients \( a \) and \( b \) placed in their own matrix?
That's a really insightful question — and it gets to the heart of how **linear algebra** is used in regression modeling.  
This is done to express the **linear model** in a compact and generalizable **matrix form**:

$$
\mathbf{y} = \mathbf{X} \boldsymbol{\beta} + \boldsymbol{\varepsilon}
$$

Where:
- \( \mathbf{y} \) is the **vector of observed outputs** (the \( y_i \)'s),
- \( \mathbf{X} \) is the **design matrix** (containing the inputs \( x_i \)'s and a column of 1s),
- \( \boldsymbol{\beta} \) is the **vector of model parameters** (in this case, \( \begin{bmatrix} b \\ a \end{bmatrix} \)),
- \( \boldsymbol{\varepsilon} \) is the **vector of residuals** (errors).

### Why separate them?

1. **Clarity and Modularity**: By separating the coefficients into their own vector, we can clearly distinguish between:
   - The **structure of the data** (in \( \mathbf{X} \)),
   - The **parameters we want to estimate** (in \( \boldsymbol{\beta} \)).

2. **Matrix Multiplication Rules**: This form allows us to use matrix multiplication to compute predictions:
   $$
   \mathbf{X} \boldsymbol{\beta} =
   \begin{bmatrix}
   1 & x_1 \\
   1 & x_2 \\
   \vdots & \vdots \\
   1 & x_n
   \end{bmatrix}
   \begin{bmatrix}
   b \\
   a
   \end{bmatrix}
   =
   \begin{bmatrix}
   b + a x_1 \\
   b + a x_2 \\
   \vdots \\
   b + a x_n
   \end{bmatrix}
   $$

3. **Generalization**: This structure scales easily to **multiple predictors**. For example, if you had more variables (say \( x_1, x_2, x_3 \)), your design matrix would have more columns, and your coefficient vector would grow accordingly — but the matrix form stays the same.

---
 
Consider a linear model Y ~ X with X being now a categorical variable with three levels , α1, α2, α3.   
You're asking a really important question — and it's a common point of confusion when moving from **numerical** to **categorical** variables in linear models. Let's unpack it step by step.

---

### 🔁 Recap: What’s Going On?

You have a **categorical variable** \( X \) with **three levels**: \( \alpha_1, \alpha_2, \alpha_3 \). You’re fitting a linear model:

$$
Y \sim X
$$

But since \( X \) is categorical, you **can’t** just plug in numbers like 1, 2, 3 — because those numbers would imply a scale or order that doesn’t exist.

Instead, you use **dummy (indicator) variables** to represent the categories.

---

### 🧱 The Design Matrix

The design matrix looks like this (simplified):

| Observation | Intercept (1) | α₂ Indicator | α₃ Indicator |
|-------------|----------------|----------------|----------------|
| α₁          | 1              | 0              | 0              |
| α₁          | 1              | 0              | 0              |
| α₂          | 1              | 1              | 0              |
| α₂          | 1              | 1              | 0              |
| α₃          | 1              | 0              | 1              |
| α₃          | 1              | 0              | 1              |
| α₃          | 1              | 0              | 1              |

And your model is:

$$
\mathbf{y} = \mathbf{X} \boldsymbol{\beta} + \boldsymbol{\varepsilon}
$$

Where:

$$
\boldsymbol{\beta} =
\begin{bmatrix}
a_1 \\
a_2 \\
a_3
\end{bmatrix}
$$

---

### 🤔 What Do the Coefficients Mean?

Here’s the key:

- **\( a_1 \)** is the **mean of \( y \)** when \( x = \alpha_1 \)**.
- **\( a_2 \)** is the **difference** between the mean of \( y \) for \( \alpha_2 \) and \( \alpha_1 \)**.
- **\( a_3 \)** is the **difference** between the mean of \( y \) for \( \alpha_3 \) and \( \alpha_1 \)**.

So:

- For \( x = \alpha_1 \):  
  $$ y = a_1 $$
- For \( x = \alpha_2 \):  
  $$ y = a_1 + a_2 $$
- For \( x = \alpha_3 \):  
  $$ y = a_1 + a_3 $$

This is because:
- The intercept \( a_1 \) captures the **baseline** (mean of the reference group, \( \alpha_1 \)),
- The other coefficients \( a_2 \) and \( a_3 \) capture how much **higher or lower** the other groups are compared to that baseline.

---

### 🧠 Why Do It This Way?

This is called **reference coding** (or **treatment coding**), and it’s standard in regression with categorical variables. It allows you to:
- Interpret coefficients as **differences from a baseline**,
- Avoid overparameterization (you don’t need a separate parameter for every level — just \( k - 1 \) for \( k \) levels).

### Why is a1 the intercept?   
You're absolutely right to notice this — and the confusion comes from the **difference in how we treat numerical vs. categorical variables** in linear models.

Let’s clarify the two situations:

---

### ✅ In a **numerical** linear model:

You typically write:

$$
y = a x + b + \varepsilon
$$

- Here, **\( b \)** is the **intercept** — the value of \( y \) when \( x = 0 \).
- \( a \) is the **slope** — how much \( y \) changes when \( x \) increases by 1.

So yes, in this case, the intercept is **explicitly labeled \( b \)**.

---

### ✅ In a **categorical** linear model:

You write:

$$
y = a_1 + a_2 \cdot \text{[is α₂]} + a_3 \cdot \text{[is α₃]} + \varepsilon
$$

- The intercept is now **\( a_1 \)** — and it represents the **mean of \( y \)** for the **reference category** (here, \( \alpha_1 \)).
- The other coefficients \( a_2 \), \( a_3 \) are **differences** from that reference group.

So in this setup:
- \( a_1 \) **plays the role of the intercept** (like \( b \) did before),
- But we don’t call it \( b \) — because we’re using a different parameterization.

---

### 🔁 Why the change in naming?

It’s just a **notational shift** to reflect the structure of the model:

- In numerical models: we use \( y = a x + b \)
- In categorical models: we use \( y = a_1 + a_2 D_2 + a_3 D_3 \), where \( D_2, D_3 \) are dummy variables

So **\( a_1 \) is the intercept**, even though it’s not labeled \( b \). It’s the baseline value of \( y \) when all dummy variables are 0 — i.e., when \( x = \alpha_1 \).


## lmfit() and Examples of designs.   
see code from notes:
```
# if (!require("BiocManager", quietly = TRUE))
#     install.packages("BiocManager")
# BiocManager::install("limma")
library(limma)

library(ALL); data(ALL)
fp.df <- data.frame(fp=pData(ALL)[,"fusion protein"], 
 g1=exprs(ALL)["1970_s_at",], 
 g2=exprs(ALL)["1002_f_at",])
fp.df <- fp.df[!is.na(fp.df$fp),] 
table(fp.df$fp)

# try this! This is design matrix used by lm():
model.matrix(fp.df$g1~fp.df$fp) 

# the following design has all 1 in the 1st column (p190), 
# and an additional 1 
# in corresponding cols for p190/p210, p210 (that’s default for lm()),
# just the same way we defined design matrix for a 3-level variable in
# our example of Eq.(5) above:
design.lm <- cbind(p190=1, 
 p190.p210=as.numeric(fp.df$fp == "p190/p210"),
 p210=as.numeric(fp.df$fp == "p210"))
expr.arrays <- matrix(c(fp.df$g1,fp.df$g2),nrow=2,ncol=33,byrow=T)
# fit result is the mean of p190, and offsets from that mean for
# means of other classes:
lmFit(expr.arrays,design.lm)$coefficients

# the following design has 1 in corresponding columns ONLY,
# for each of p190,p190/p210,p210 levels:
design.1 <- cbind(p190=as.numeric(fp.df$fp == "p190"),
 p190.p210=as.numeric(fp.df$fp == "p190/p210"),
 p210=as.numeric(fp.df$fp == "p210")) 
# fit results=corresponding means in each class:
lmFit(expr.arrays,design.1)$coefficients
```



Here’s a clear summary of the key points from your notes, focusing on the differences between `lm()` and `lmFit()`, and when to use `table()`, `model.matrix()`, and `cbind()` with `lmFit()`:

---

### 🔹 **`lm()` vs `lmFit()`**

| Feature | `lm()` (Base R) | `lmFit()` (from **limma** package) |
|--------|------------------|------------------------------------|
| Purpose | General-purpose linear modeling | Designed for **high-throughput** modeling (e.g., gene expression data) |
| Input | One model at a time | Can fit **many models at once** (e.g., one per gene) |
| Design Matrix | Created internally or via `model.matrix()` | Must be **explicitly provided** |
| Efficiency | Slower for many models (e.g., looping over genes) | Much **faster and vectorized** |
| Use Case | Small datasets, general regression | Microarray / genomics data, large-scale modeling |

---

### 🔹 **When to use `table()`**

- Use `table()` to **inspect the distribution** of a categorical variable.
- Example: `table(fp.df$fp)` shows how many patients fall into each fusion protein category (`p190`, `p190/p210`, `p210`).
- It’s **not used in modeling**, just for **exploratory data analysis**.

---

### 🔹 **When to use `model.matrix()`**

- Use `model.matrix()` to **automatically generate a design matrix** from a formula (like in `lm()`).
- It encodes categorical variables using **reference coding** (baseline + offsets).
- Example:
  ```r
  model.matrix(fp.df$g1 ~ fp.df$fp)
  ```
  This creates a matrix where:
  - First column = intercept (baseline group, e.g., `p190`)
  - Other columns = indicator variables for other levels (`p190/p210`, `p210`)

- This design gives:
  - First coefficient = mean of baseline group
  - Other coefficients = **differences** from that baseline

---

### 🔹 **When to use `cbind()` with `lmFit()`**

You use `cbind()` to **manually construct a design matrix**. There are two common styles:

#### 1. **Reference Coding (like `model.matrix()`):**
```r
design.lm <- cbind(
  p190 = 1,
  p190.p210 = as.numeric(fp.df$fp == "p190/p210"),
  p210 = as.numeric(fp.df$fp == "p210")
)
```
- First column is all 1s (intercept for `p190`)
- Other columns are 1 only when the sample belongs to that group
- **Interpretation**:
  - `p190` = mean of `p190` group
  - `p190.p210` = difference from `p190`
  - `p210` = difference from `p190`

#### 2. **One-Hot Coding (no baseline):**
```r
design.1 <- cbind(
  p190 = as.numeric(fp.df$fp == "p190"),
  p190.p210 = as.numeric(fp.df$fp == "p190/p210"),
  p210 = as.numeric(fp.df$fp == "p210")
)
```
- Each column corresponds to **one group only**
- **Interpretation**:
  - Each coefficient = **mean expression** in that group
  - No baseline or reference group

---

### 🔹 **What results do they give?**

| Design Matrix Type | Coefficients from `lmFit()` |
|--------------------|-----------------------------|
| `model.matrix()` or `design.lm` | Baseline mean + **offsets** for other groups |
| `design.1` (one-hot) | **Group means** directly |

---

### ✅ **When to use what?**

- Use `lm()` for **simple models** or when learning.
- Use `lmFit()` when:
  - You have **many genes** or features to model
  - You want **speed and scalability**
- Use `model.matrix()` when:
  - You want to **automatically** generate a design matrix
  - You’re using **reference coding**
- Use `cbind()` when:
  - You want **manual control** over the design matrix
  - You want to switch between **reference coding** and **one-hot encoding**



