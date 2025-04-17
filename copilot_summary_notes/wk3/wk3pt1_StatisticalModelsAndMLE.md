Here is the updated document with all instances of improperly formatted symbols replaced with their proper mathematical symbols:

---

## **Week 3 Notes: Statistical Models and Maximum Likelihood Estimation**

### **1. Overview**
- **Statistical Models**: These are frameworks that describe relationships between variables using probability distributions. They help generalize findings from data and identify trends or dependencies.
- **Key Idea**: When we assume a specific distribution (e.g., Gaussian), we can use parameters like mean (𝜇) and variance (𝜎²) to characterize the data.
- **Example**: If patient ages follow a normal distribution, we can use the mean and variance to summarize the data and perform tests like the t-test.

---

### **2. Statistical Models**
- **Definition**: A statistical model is a family of distributions or relationships between variables with unknown parameters determined from data.
- **Parametric Models**: These assume a specific functional form (e.g., Gaussian distribution) but leave parameters (e.g., mean, variance) to be estimated from data.
  
#### **Example: Gaussian Distribution**
- The probability density function for a Gaussian distribution is:
  ```markdown
  𝑓(𝑥|𝜇, 𝜎²) = 1 / √(2𝜋𝜎²) 𝑒^(-(𝑥−𝜇)² / 2𝜎²)
  ```
  - 𝜇: Mean
  - 𝜎²: Variance

- **Application**: If gene expression levels follow a Gaussian distribution, we can use this model to predict outcomes or test hypotheses.

---

### **3. Statistical Independence**
- **Definition**: Two random variables 𝑋 and 𝑌 are independent if knowing 𝑋 provides no information about 𝑌:
  ```markdown
  𝑃(𝑌|𝑋) = 𝑃(𝑌)
  ```

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
- **Observation**: The scatterplot shows no relationship between 𝑋 and 𝑌, confirming independence.

---

### **4. Linear Models**
- **Definition**: A linear model describes the relationship between a predictor variable 𝑋 and a response variable 𝑌:
  ```markdown
  𝑌 = 𝛽₀ + 𝛽₁𝑋 + 𝜀
  ```
  - 𝛽₀: Intercept
  - 𝛽₁: Slope
  - 𝜀: Error term (unexplained variation)

#### **Key Concepts**:
- **Residuals**: The difference between observed and predicted values:
  ```markdown
  𝑟ᵢ = 𝑦ᵢ − (𝛽₀ + 𝛽₁𝑥ᵢ)
  ```
- **Least Squares**: The most common method to fit a linear model by minimizing the sum of squared residuals:
  ```markdown
  ∑ᵢ₌₁ⁿ 𝑟ᵢ²
  ```

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
  ```markdown
  𝐿(𝜃|𝑥₁, 𝑦₁; …; 𝑥ₙ, 𝑦ₙ) = ∏ᵢ₌₁ⁿ 𝑃(𝑥ᵢ, 𝑦ᵢ|𝜃)
  ```
  - 𝜃: Parameters (e.g., 𝑎, 𝑏 in a linear model)

#### **Log-Likelihood for Linear Models**:
- Assuming Gaussian noise, the log-likelihood is:
  ```markdown
  log 𝐿 = −(𝑛 / 2) log(2𝜋𝜎²) − (1 / 2𝜎²) ∑ᵢ₌₁ⁿ (𝑦ᵢ − 𝑎𝑥ᵢ − 𝑏)²
  ```
  - The second term is the sum of squared residuals.

#### **Key Insight**:
- Maximizing the log-likelihood is equivalent to minimizing the sum of squared residuals (least squares method).

#### **Steps to Perform MLE**:
1. Assume a model (e.g., 𝑦 = 𝑎𝑥 + 𝑏 + 𝜀).
2. Compute the likelihood or log-likelihood.
3. Differentiate with respect to parameters (𝑎, 𝑏) and solve for the maximum.

---

### **6. Connection Between MLE and Least Squares**
- **Key Insight**: Least squares estimates are MLE estimates under the assumption of Gaussian noise.
- **Why This Matters**: This connection provides a statistical justification for using least squares in linear regression.

---

### **7. Practical Application**
- **Real-World Example**: Predicting patient blood pressure (𝑌) based on age (𝑋).
  - Fit a linear model: 𝑌 = 𝛽₀ + 𝛽₁𝑋 + 𝜀.
  - Use MLE to estimate 𝛽₀ and 𝛽₁.
  - Analyze residuals to validate the model.

---

### **8. Residual Analysis**
- **Purpose**: To assess the goodness of fit and validate model assumptions (e.g., normality, constant variance).
- **Steps**:
  1. Calculate residuals: 𝑟ᵢ = 𝑦ᵢ − 𝑦′ᵢ.
  2. Plot residuals vs. fitted values.
  3. Check for patterns (e.g., non-random patterns indicate model issues).

---

### **Summary**
- **Statistical Models**: Frameworks for understanding data relationships.
- **Linear Models**: Simple yet powerful tools for quantifying dependencies.
- **MLE**: A robust method for parameter estimation, closely related to least squares.
- **Practical Applications**: Widely used in biomedical research for prediction and hypothesis testing.

---

Let me know if you need further adjustments or additional examples!