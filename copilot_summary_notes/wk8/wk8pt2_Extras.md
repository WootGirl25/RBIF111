# Week 8 Part 2: Extras

# Random Effects Models

### **Key Points of Random Effects Models**
1. **Fixed vs. Random Effects:**
   - **Fixed effects** are factors controlled or measured in an experiment—like gender or drug treatment.
   - **Random effects** are uncontrolled variables that contribute to variability—like differences in reagent batches or patient genetics.

2. **Philosophical Nature of the Distinction:**
   - The classification of an effect as fixed or random **depends on study design**.
   - Example: Genetic background is a fixed effect if deliberately studied but a random effect if patients were selected without considering individual genotypes.

3. **Expanding the Study:**
   - **Fixed effects remain unchanged** in a larger study (e.g., male vs. female).
   - **Random effects change** with more subjects, batches, or hospitals.

4. **Modeling Random Effects:**
   - Studies like drug trials, gene expression analyses, and hospital-based research often include random effects.
   - A common model format:
     \[
     y_{ij} = \mu + \alpha_{i} + \epsilon_{ij}
     \]
     where:
     - \( \mu \) = grand mean (average outcome)
     - \( \alpha_i \) = random effect contribution (e.g., differences between hospitals)
     - \( \epsilon_{ij} \) = pure random noise

5. **Why Use Random Effects Models?**
   - These models help **account for batch effects** (systematic differences between groups).
   - They improve **the accuracy of outcome estimates** by considering partial correlations in the data.

### **Main Takeaway**
Random effects models help **differentiate controlled (fixed) vs. uncontrolled (random) factors**, ensuring **better statistical accuracy** in experimental studies!

```
set.seed(1234)
n.batch <- 7 # number of batches
n.reps <- 3 # n replicated measurements in each batch
sd.batch <- 1.0 # sd of random effect term (sigma_r) 
sd.rep <- 0.2 # sd of measurement error, epsilon
mu <- 1.0 # grand mean
# now we will generate 21 measurements: 3 per batch, 7 batches:
# sample 7 distinct values for alpha_i; replicate 3 times: 
batch.eff <- rep(rnorm(n.batch,sd=sd.batch),n.reps) # alpha-term 
rep.eff <- rnorm(n.reps*n.batch,sd=sd.rep) # sample measurement err
re.df <- data.frame(batch=rep(paste("b",1:n.batch),n.reps),
 y=mu+batch.eff+rep.eff) # make sure everything in matching order
boxplot(y~batch,re.df)
library(lme4)
```

### **What This Example Does**
This code simulates **data with batch effects**, then fits a **random effects model** using the `lme4` package in R.

---

### **Step 1: Data Simulation**
1. **Setting parameters:**
   - We define **7 batches** (`n.batch`).
   - Each batch has **3 replicated measurements** (`n.reps`).
   - **Batch effects (`sigma_r`)** have a standard deviation of **1.0**.
   - **Measurement errors (`epsilon`)** have a standard deviation of **0.2**.
   - **Grand mean (`mu`)** of the outcome variable is set to **1.0**.

2. **Generating random effects:**
   - **Batch effect (`alpha_i`)** is sampled from a normal distribution and replicated across three measurements per batch.
   - **Measurement error (`epsilon`)** is sampled separately from another normal distribution.

3. **Creating the data:**
   - The simulated measurements (`y`) are constructed as:
     \[
     y = \mu + \text{batch effect} + \text{measurement error}
     \]
   - The results are stored in a **dataframe** (`re.df`) with batch labels.

---

### **Step 2: Visualizing Data**
- The `boxplot(y ~ batch, re.df)` command **plots the variation across batches**, showing how different batches contribute to overall variability.

---

### **Step 3: Fitting the Random Effects Model**
- `lmer(y ~ (1 | batch), re.df)` fits a **linear mixed-effects model**:
  - The formula `y ~ (1 | batch)` means that `y` does **not depend on any fixed effects**, only **random batch effects**.
  - This accounts for **batch-to-batch variation** in our model.

---

### **Step 4: Interpreting Results**
1. **Estimated batch standard deviation** is **1.2131**—close to the true value of **1.0**.
2. **Estimated residual standard deviation** (measurement error) is **0.1587**, close to the simulated **0.2**.
3. **Grand mean estimate** is **0.6803**, which matches the mean of the actual simulated data.
4. **Standard error of the mean** is **adjusted upwards** due to large batch variation:
   - If we **ignored** batch effects, the standard error would be underestimated (`~0.25` vs. `~0.46`).

---

### **Big Takeaway**
This example **shows how a random effects model correctly accounts for batch-to-batch variability**, leading to **more accurate estimates** of the mean and standard error. Without it, **we might underestimate the uncertainty** in our data.

# Generalized Linear Models:

### **Key Points of Generalized Linear Models (GLMs)**
1. **GLMs are an Extension of Linear Models**
   - Traditional linear models assume a **normally distributed outcome variable** and restrict transformations mostly to explanatory variables.
   - GLMs **relax that limitation**, allowing **transformed response variables** and **non-normal error distributions**.

2. **Equation Representation of GLMs**
   - The general form:
     \[
     f(Y) = a_0 + a_1 \phi_1(X_1) + ... + a_n \phi_n(X_n) + \epsilon
     \]
   - Here, \( f(Y) \) is a **link function** that transforms the response variable.

---

### **Logistic Regression: A Special Case of GLMs**
#### **Why Do We Need Logistic Regression?**
- Linear models struggle with **binary outcomes** (e.g., disease relapse vs. no relapse).
- Logistic regression correctly models the **probability of an event occurring**, ensuring values stay within the **\[0,1\] range**.

#### **Key Idea**
1. **Binary outcomes follow a Bernoulli process**—essentially a **coin flip with an unknown probability \( P \)**.
2. The probability \( P \) depends on explanatory variables.
3. Directly modeling \( P \) using a linear function can lead to **nonsensical predictions** outside the \[0,1\] range.

#### **The Logistic Function Fixes These Issues**
- Logistic regression assumes:
  \[
  P(Z) = \frac{e^Z}{1 + e^Z}
  \]
- Here, \( Z \) is modeled as:
  \[
  Z = a_0 + a_1 \phi_1(X_1) + ... + a_n \phi_n(X_n) + \epsilon
  \]

#### **Logit Transformation**
- The logistic function ensures \( P \) remains in \[0,1\], but we **reformulate it** using a **logit transformation**:
  \[
  Z = \log\left(\frac{P}{1-P}\right)
  \]
- This transforms probabilities into an **unbounded range**, allowing a linear model to fit \( Z \) instead.

#### **Final Logistic Regression Model**
\[
\log\left(\frac{P}{1-P}\right) = a_0 + a_1 \phi_1(X_1) + ... + a_n \phi_n(X_n) + \epsilon
\]
This is **a GLM with a logit link function**, making it ideal for predicting **binary outcomes**.

Then we can solve for P:  
Since logistic regression models **log(P / (1 - P))** as a linear function, solving for **P** requires reversing the logit transformation.

Starting with:
\[
\log\left(\frac{P}{1-P}\right) = a_0 + a_1 X_1 + ... + a_n X_n
\]

To solve for **P**, exponentiate both sides:
\[
\frac{P}{1-P} = e^{(a_0 + a_1 X_1 + ... + a_n X_n)}
\]

Now, isolate **P**:
\[
P = \frac{e^{(a_0 + a_1 X_1 + ... + a_n X_n)}}{1 + e^{(a_0 + a_1 X_1 + ... + a_n X_n)}}
\]

This gives the **predicted probability** based on the logistic regression model! 🎉

---

### **Why is This Important?**
- GLMs **generalize linear regression** to handle **different types of response variables**.
- Logistic regression **solves issues with binary classification** and ensures **probabilities stay realistic**.

This is a game-changer when predicting events like **disease relapse, voting choices, or customer behavior**—whenever the outcome is either **yes/no** rather than a continuous value.

```
library(ALL); data(ALL)
b.mask <- !is.na(pData(ALL)$relapse)
relapse.wo.na <- pData(ALL)$relapse[b.mask]
exprs.wo.na <- exprs(ALL)[,b.mask]
# save expr. levels into variable with a short name (pure convenience):
ge <- exprs.wo.na["1584_at",] # we pick a gene here, just an example
br <- seq(min(ge),max(ge),by=(max(ge)-min(ge))/10)
cnt.1 <- hist(ge[relapse.wo.na],breaks=br)$counts
cnt.0 <- hist(ge[!relapse.wo.na],breaks=br)$counts
glm.1584.at <- glm(relapse.wo.na~ge, family="binomial")
summary(glm.1584.at)
old.par<-par(ps=16)
plot(ge,relapse.wo.na, xlab="1584_at",ylab="Relapse")
points((br[1:10]+br[2:11])/2, 
       cnt.1/(cnt.0+cnt.1),pch=19,col='red',cex=1.2)
segments(br[1:10], cnt.1/(cnt.0+cnt.1),
         br[2:11], cnt.1/(cnt.0+cnt.1),col='red')
y.pred <- predict(glm.1584.at)
points(ge, exp(y.pred)/(1+exp(y.pred)),col="blue",pch='+')
par(old.par)
```

### **What’s Happening in This Example?**
This R code is **fitting a logistic regression model** to determine if gene expression levels influence **the probability of disease relapse** in patients.

---

### **Step 1: Loading and Cleaning Data**
- **`library(ALL); data(ALL)`** loads a dataset of **acute lymphoblastic leukemia (ALL) patients**.
- The variable **`relapse.wo.na`** extracts relapse status (TRUE = relapse, FALSE = no relapse), excluding missing values.
- **`exprs.wo.na`** stores gene expression levels of these patients.

---

### **Step 2: Selecting a Gene for Analysis**
- **`ge <- exprs.wo.na["1584_at",]`** selects gene **1584_at** for analysis.
- **Why?** We want to check if **the expression level of this gene** correlates with disease relapse.

---

### **Step 3: Creating a Histogram-Based Estimate of Relapse Probability**
- The dataset contains **continuous gene expression values**, but relapse is binary (0 or 1).
- We **group gene expression values into 10 intervals** (`br` variable).
- Then, we count how many patients **relapsed vs. did not relapse** in each interval:
  - **`cnt.1`** stores relapse (TRUE = 1).
  - **`cnt.0`** stores no relapse (FALSE = 0).
- Estimated probability of relapse per gene expression interval:
  \[
  P = \frac{\text{relapsed patients}}{\text{total patients in interval}}
  \]
- These estimated probabilities are plotted with **red dots** on the graph.

---

### **Step 4: Fitting the Logistic Regression Model**
- **`glm(relapse.wo.na ~ ge, family="binomial")`** fits a logistic regression model:
  - **Predicting relapse (`relapse.wo.na`) using gene expression levels (`ge`)**.
  - **`family="binomial"`** ensures a **logistic function is used** (since relapse is binary).

---

### **Step 5: Interpreting Model Results**
- The summary of `glm.1584.at` shows:
  - **Intercept = 15.228** (base probability level).
  - **Gene coefficient = -4.010** (**negative relationship** → higher gene expression **reduces relapse probability**).
  - **Significance values** (p-values):
    - The gene expression coefficient is **highly significant** (`p = 0.000462`).
    - This suggests **strong evidence** that gene expression level **impacts relapse probability**.

---

### **Step 6: Visualizing the Results**
- **Black dots**: Raw 0/1 relapse values against gene expression.
- **Red dots**: Estimated probability of relapse in each gene expression interval.
- **Blue crosses**: Predicted probabilities from **logistic regression model**.

### **Big Takeaway**
This code demonstrates **logistic regression correctly modeling relapse probability based on gene expression**, rather than just treating the outcome as strictly binary. It **smooths out** the trends and helps **predict probabilities** rather than relying only on raw counts.



### **What Does `glm()` Do?**
1. **Fits regression models where the outcome variable isn’t necessarily continuous or normally distributed.**
2. **Allows different link functions** to transform predictions appropriately.
3. **Handles binary, count, and other types of response variables** with different error distributions.

---

### **How Does It Work in the Example?**
- **Formula:** `relapse.wo.na ~ ge`
  - Predicts **relapse** (binary: 1 = relapse, 0 = no relapse) using **gene expression levels** (`ge`).
- **Family Argument:** `family="binomial"`
  - Since relapse is a **binary outcome**, this tells `glm()` to use **logistic regression**.
  - Uses the **logit function** for probability transformation.
- **Internal Processing:** 
  - `glm()` estimates the **coefficients (`a_0, a_1, ...`)** by **maximizing likelihood**, rather than just minimizing squared error (as in linear regression).

---

### **Why Use `glm()` Instead of `lm()`?**
- **`lm()` (Linear Model):** Assumes a **continuous response variable**.
- **`glm()` (Generalized Linear Model):** Works with **binary, count, or other distributions**.
  - Example: In logistic regression, `glm()` correctly models probabilities **without exceeding the 0–1 range**.

---

### **Final Takeaway**
In this example, `glm()` **automatically estimates the probability of relapse based on gene expression levels**, ensuring the model fits a proper **logistic curve** rather than forcing linear predictions.

# Survival Analysis  

## **What is Survival Analysis?**
Survival Analysis models **time-to-event data**—for example:
- **Time until remission** in patients undergoing treatment.
- **Time until death** in a medical study.

The challenge? **Survival times are rarely normally distributed**, and some subjects **never experience the event during the study period**. These incomplete observations are **censored data**, and we need special techniques to handle them.

---

## **Breaking Down the Code**
### **Step 1: Loading and Cleaning Data**
```r
library(survival) # load survival analysis library
ALL.pdat <- pData(ALL)
date.cr.chr <- as.character(ALL.pdat$date.cr)
diag.chr <- as.character(ALL.pdat$diagnosis)
date.cr.t <- strptime(date.cr.chr, "%m/%d/%Y")
diag.t <- strptime(diag.chr, "%m/%d/%Y")
d2r <- as.numeric(date.cr.t - diag.t)
```
**What's happening?**
- Loads the **survival analysis library**.
- Extracts **diagnosis dates** (`diag.t`) and **remission dates** (`date.cr.t`).
- Computes **days-to-remission (`d2r`)** by subtracting diagnosis date from remission date.

---

### **Step 2: Handling Censored Data**
```r
d2r.ind <- as.numeric(!is.na(d2r))  # T where remission data exists, F otherwise
d2r.surv <- Surv(d2r, d2r.ind)
```
**Why does this matter?**
- **`d2r.ind`** creates a **logical vector** marking whether remission data exists (`TRUE`) or is missing (`FALSE`).
- **`Surv(d2r, d2r.ind)`** creates a **Survival Object**, which labels remission times while handling **censored data**.

If a patient **never experienced remission** before the study ended, their data is **right-censored**—meaning we only know they survived **at least** that long, but we don’t know the exact remission time.

---

### **Step 3: Plotting the Survival Curve**
```r
plot(survfit(d2r.surv ~ sex, data = pData(ALL)),
 col = c(2,4), xlab = "Days",
 ylab = "1 - p(remission)")
legend(100, 0.8, legend = c('M', 'F'), lwd = 1, col = c('blue', 'red'))
```
**What is being plotted?**
- **`survfit(d2r.surv ~ sex, data = pData(ALL))`** fits a survival model, stratifying the data by gender (`sex`).
- **The curve shows the proportion of patients NOT in remission over time** (higher values mean more patients remain sick).
- **Different colors represent males (`blue`) and females (`red`)**.

**Interpretation of the plot**
- **Both groups reach remission around day 100**, but **males** seem to **recover slightly faster** than **females**.

---

## **Step 4: Statistical Testing with Cox Proportional Hazards Model**
### **Understanding the Cox Model**
We now ask: **Is this gender difference statistically significant?**
To do that, we fit a **Cox Proportional Hazards Model**:
```r
coxph(Surv(d2r, as.numeric(!is.na(d2r))) ~ sex, data = pData(ALL))
```
This models the **hazard rate**—or risk—of remission occurring at any given time, **while accounting for gender**.
---

## **What is the Cox Model?**
The Cox model, developed by **Sir David Cox**, is a **semi-parametric survival model** that estimates the effect of explanatory variables (like sex, age, or treatment) on the **hazard function**—the **instantaneous risk** of the event happening.

Unlike other survival models, the Cox model:
- **Does not require specifying the baseline hazard function** \( h_0(t) \).
- **Focuses on hazard ratios** (relative risk comparisons between groups).
- **Accounts for censored data**, making it ideal for time-to-event studies.

---

## **Key Formulas**
### **1. Hazard Function**
The **hazard function** \( h(t) \) represents the **instantaneous risk** of an event occurring at time \( t \), given that the individual has survived until \( t \).

\[
h(t) = \lim_{\Delta t \to 0} \frac{P(t \leq T < t + \Delta t | T \geq t)}{\Delta t}
\]

This equation expresses the probability of the event occurring **right after time \( t \)**, **conditional on survival until \( t \)**.

---

### **2. Survival Function**
The **survival function** \( S(t) \) is the probability of surviving **past time \( t \)**:

\[
S(t) = P(T > t) = 1 - P(T \leq t)
\]

It complements the cumulative probability function \( P(t) \), which describes the chance of experiencing the event **before time \( t \)**.

---

### **3. Cox Proportional Hazards Model**
The Cox model assumes the hazard function takes the form:

\[
h_i(t) = h_0(t) e^{\beta_1 X_{i1} + \beta_2 X_{i2} + \dots + \beta_k X_{ik}}
\]

Where:
- \( h_i(t) \) = hazard function for individual \( i \).
- \( h_0(t) \) = baseline hazard function (not specified in the model).
- \( X_{i1}, X_{i2}, \dots X_{ik} \) = explanatory variables.
- \( \beta_1, \beta_2, \dots \beta_k \) = coefficients representing the effect of each explanatory variable.

---

### **4. Hazard Ratio**
Since the baseline hazard \( h_0(t) \) cancels out in comparisons, the Cox model estimates **hazard ratios**:

\[
\frac{h_i(t)}{h_j(t)} = e^{\beta_1 (X_{i1} - X_{j1}) + \beta_2 (X_{i2} - X_{j2}) + \dots + \beta_k (X_{ik} - X_{jk})}
\]

This tells us how much **more or less likely** one individual is to experience the event compared to another.

Example:
- If **sex** is included as an explanatory variable (\( \beta_{\text{sex}} \)), and the hazard ratio for males vs. females is **1.5**, then males are **50% more likely** to experience remission earlier.

---

## **Interpreting the R Output**
From the `coxph()` results:
```
        coef exp(coef) se(coef)     z     p
sexM  0.2989    1.3483   0.2338 1.278 0.201
```
### **What Each Value Means**
- **`coef` (0.2989):** The estimated effect of **being male** on remission time.
- **`exp(coef)` (1.3483):** **Hazard ratio** (males are **1.35 times** more likely to achieve remission at any given time).
- **`se(coef)` (0.2338):** Standard error of the coefficient.
- **`p-value` (0.201):** Not statistically significant (**p > 0.05**), meaning the difference in remission times between males and females **could be due to random chance**.

---

## **Big Takeaways**
1. The **Cox model estimates hazard ratios** rather than absolute survival times.
2. The **baseline hazard function remains unspecified**, making it flexible.
3. **Statistical significance matters**—even if one group appears to recover faster, **if \( p > 0.05 \), the difference may not be real**.
4. **Censored data is handled correctly**, ensuring accurate results in survival studies.


### **Step 5: Interpreting the Results**
The output:
```
        coef exp(coef) se(coef)     z     p
sexM  0.2989   1.3483   0.2338  1.278 0.201
```
- **The key number is the p-value (`p = 0.201`)**—this tells us **whether males recover significantly faster than females**.
- Since **p > 0.05**, **there is no statistically significant difference** between male and female remission times.

---

## **The Big Takeaways**
1. **Survival Analysis is used when modeling time-to-event data**—it’s crucial for studies where not all subjects experience the event.
2. **We handled censored data** (patients who haven’t had remission yet).
3. **We plotted survival curves** stratified by gender and observed a slight difference.
4. **The Cox model tested statistical significance**—and found **no strong evidence** that gender affects remission time.

---

