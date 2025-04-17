Certainly! Below is a simplified and organized version of the notes, following the same structure as the original content. I've broken down the concepts into digestible sections with explanations, examples, and practical applications.

---

## **Week 3 Notes: Statistical Models and Maximum Likelihood Estimation**

### **1. Overview**
- **Statistical Models**: These are frameworks that describe relationships between variables using probability distributions. They help generalize findings from data and identify trends or dependencies.
- **Key Idea**: When we assume a specific distribution (e.g., Gaussian), we can use parameters like mean and variance to characterize the data.
- **Example**: If patient ages follow a normal distribution, we can use the mean and variance to summarize the data and perform tests like the t-test.

---

### **2. Statistical Models**
- **Definition**: A statistical model is a family of distributions or relationships between variables with unknown parameters determined from data.
- **Parametric Models**: These assume a specific functional form (e.g., Gaussian distribution) but leave parameters (e.g., mean, variance) to be estimated from data.
  
#### **Example: Gaussian Distribution**
- The probability density function for a Gaussian distribution is:
  \[
  f(x|\mu, \sigma^2) = \frac{1}{\sqrt{2\pi\sigma^2}} e^{-\frac{(x-\mu)^2}{2\sigma^2}}
  \]
  - \( \mu \): Mean
  - \( \sigma^2 \): Variance

- **Application**: If gene expression levels follow a Gaussian distribution, we can use this model to predict outcomes or test hypotheses.

---

### **3. Statistical Independence**
- **Definition**: Two random variables \( X \) and \( Y \) are independent if knowing \( X \) provides no information about \( Y \):
  \[
  P(Y|X) = P(Y)
  \]

#### **Example in R**:
```R
# Simulate independent variables
x <- rnorm(10000, mean = 10, sd = 3)
y <- rnorm(10000, mean = 10, sd = 3)

# Plot histograms and scatterplot
hist(x, main = "Distribution of X")
hist(y, main = "Distribution of Y")
plot(x, y, main = "Scatterplot of X vs Y")
```
- **Observation**: The scatterplot shows no relationship between \( X \) and \( Y \), confirming independence.

---

### **4. Linear Models**
- **Definition**: A linear model describes the relationship between a predictor variable \( X \) and a response variable \( Y \):
  \[
  Y = \beta_0 + \beta_1 X + \epsilon
  \]
  - \( \beta_0 \): Intercept
  - \( \beta_1 \): Slope
  - \( \epsilon \): Error term (unexplained variation)

#### **Key Concepts**:
- **Residuals**: The difference between observed and predicted values:
  \[
  r_i = y_i - (\beta_0 + \beta_1 x_i)
  \]
- **Least Squares**: The most common method to fit a linear model by minimizing the sum of squared residuals:
  \[
  \sum_{i=1}^N r_i^2
  \]

#### **Example in R**:
```R
# Simulate data
x <- rnorm(100, mean = 10, sd = 3)
y <- 2 * x + 5 + rnorm(100, sd = 2)

# Fit linear model
model <- lm(y ~ x)
summary(model)

# Plot data and fitted line
plot(x, y, main = "Linear Model Fit")
abline(model, col = "red")
```

---

### **5. Maximum Likelihood Estimation (MLE)**
- **Definition**: MLE estimates model parameters by maximizing the likelihood of the observed data under the model.
- **Likelihood Function**: The probability of observing the data given the parameters:
  \[
  L(\Theta|x_1, y_1; \dots; x_N, y_N) = \prod_{i=1}^N P(x_i, y_i|\Theta)
  \]
  - \( \Theta \): Parameters (e.g., \( a, b \) in a linear model)

#### **Log-Likelihood for Linear Models**:
- Assuming Gaussian noise, the log-likelihood is:
  \[
  \log L = -\frac{n}{2} \log(2\pi\sigma^2) - \frac{1}{2\sigma^2} \sum_{i=1}^N (y_i - ax_i - b)^2
  \]
  - The second term is the sum of squared residuals.

#### **Key Insight**:
- Maximizing the log-likelihood is equivalent to minimizing the sum of squared residuals (least squares method).

#### **Steps to Perform MLE**:
1. Assume a model (e.g., \( y = ax + b + \epsilon \)).
2. Compute the likelihood or log-likelihood.
3. Differentiate with respect to parameters (\( a, b \)) and solve for the maximum.

---

### **6. Connection Between MLE and Least Squares**
- **Key Insight**: Least squares estimates are MLE estimates under the assumption of Gaussian noise.
- **Why This Matters**: This connection provides a statistical justification for using least squares in linear regression.

---

### **7. Practical Application**
- **Real-World Example**: Predicting patient blood pressure (\( Y \)) based on age (\( X \)).
  - Fit a linear model: \( Y = \beta_0 + \beta_1 X + \epsilon \).
  - Use MLE to estimate \( \beta_0 \) and \( \beta_1 \).
  - Analyze residuals to validate the model.

---

### **8. Residual Analysis**
- **Purpose**: To assess the goodness of fit and validate model assumptions (e.g., normality, constant variance).
- **Steps**:
  1. Calculate residuals: \( r_i = y_i - y'_i \).
  2. Plot residuals vs. fitted values.
  3. Check for patterns (e.g., non-random patterns indicate model issues).

---

### **Summary**
- **Statistical Models**: Frameworks for understanding data relationships.
- **Linear Models**: Simple yet powerful tools for quantifying dependencies.
- **MLE**: A robust method for parameter estimation, closely related to least squares.
- **Practical Applications**: Widely used in biomedical research for prediction and hypothesis testing.

Let me know if you'd like further clarification or additional examples!

Similar code found with 1 license type