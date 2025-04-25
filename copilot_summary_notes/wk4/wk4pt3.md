# Confidence Intervals and Related Distributions

This document combines several sections that explain confidence intervals, hypothesis testing, and the related chi‑square and t‑distributions. It builds from the known‑variance case to the more realistic situation where the population variance is unknown.

---

## Overview: Introducing Confidence Intervals

- **Context:**  
  Up to now, we've used hypothesis testing. In hypothesis testing, based on a set significance level (say, 5% or 0.1%), we decide whether there’s evidence to accept or reject a hypothesis. That gives you a yes/no answer.

- **What’s Different Here:**  
  Instead of just saying “significant” or “not significant,” confidence intervals give you a **range** of values. This range is chosen so that, if you repeated the study many times, a given percentage of those intervals (e.g., 95%) would contain the true value (like the true mean).

- **Two Cases:**
  1. **Known Variance:** The population’s variability ($$\sigma^2$$) is known.
  2. **Unknown Variance:** More realistic; the variability is estimated from the sample, and we use the Student’s t‑distribution instead.

---

## Confidence Intervals

Imagine you collect data and compute the sample mean (denoted as $$\bar{x}$$). However, due to random fluctuations, this $$\bar{x}$$ is not exactly the true population mean ($$\mu$$). We want to know: “How close is $$\bar{x}$$ likely to be to $$\mu$$?”

The idea of a confidence interval is to create a range $$[\bar{x}_{\text{low}}, \bar{x}_{\text{high}}]$$ such that we can be “confident” (say, 95% confident) that the true mean $$\mu$$ lies within that range.

---

## Important Notes and Interpretations

1. **Changing the Confidence Level:**  
   The constant 1.96 comes from the fact that 95% of the standard normal distribution lies within $$\pm1.96$$ standard deviations. If you wanted a 98% or 79% confidence interval, you’d use a different constant (often called $$z_0$$).

2. **Interpretation of the Confidence Interval:**  
   - **In Repeated Sampling:** If you were to take many samples and calculate this interval each time, *95% of those intervals* would contain the true mean $$\mu$$.
   - **For a Specific Sample:** Once you compute the interval from your sample, it’s a fixed range; the true mean either falls within that range or it doesn’t. The “95% confidence” refers to the reliability of the procedure used to construct the interval, not the probability for this specific interval.

3. **Connection to Hypothesis Testing:**  
   In hypothesis testing, you might reject a hypothesis because your sample mean falls outside a specific region. The confidence interval provides a continuous estimate of uncertainty – for example, if the interval includes 0, then $$\mu=0$$ remains a plausible hypothesis.

4. **The Role of the Sample Mean $$\bar{x}$$:**  
   The interval is centered on $$\bar{x}$$. Since $$\bar{x}$$ is a random variable that varies from sample to sample, the calculated confidence interval would change with each new sample.

5. **Known vs. Estimated Variance:**  
   The discussion above assumes $$\sigma$$ is known. In practice, $$\sigma$$ is unknown and must be estimated from the sample; this then requires adjustments using the Student’s t‑distribution.

---

## Breaking Down the Connection Between Hypothesis Testing and Confidence Intervals

### 1. Confidence Intervals and Hypothesis Testing Are Closely Related

- **Key Idea:**  
  Both methods quantify uncertainty about a parameter (here, the population mean $$\mu$$). They can even be equivalent when set up appropriately.

- **Example:**  
  Consider testing the null hypothesis that $$\mu = 0$$.

---

### 2. Hypothesis Testing Approach for $$\mu = 0$$

- **Step A: Setting Up the Test**  
  We have a sample with sample mean $$\bar{x}$$. To test if $$\mu = 0$$, we ask, "What is the probability of obtaining a sample mean as extreme or more extreme than $$\bar{x}$$, assuming $$\mu = 0$$?"

- **Step B: Standardizing the Sample Mean**  
  We standardize using the Z‑score:
  
  $$\textbf{(7)} \quad \bar{Z}_0 = \frac{\bar{x}}{\sigma/\sqrt{n}}$$
  
  This transformation assumes $$\mu = 0$$.

- **Step C: Calculating the Extreme Tail Probability**  
  The probability is given by:
  
  $$P(|Z| > \bar{Z}_0)$$

- **Step D: Using a Significance Level $$\alpha$$**  
  We set a significance cutoff $$\alpha$$ (e.g., 0.05) and reject the null hypothesis when:
  
  $$\textbf{(8)} \quad P(|Z| > \bar{Z}_0) < \alpha$$
  
  This means that if the observed value is very unlikely under the null hypothesis, we call the result significant.

---

### 3. The Role of the Standard Normal Distribution

- **Monotonic Decrease:**  
  The probability $$P(|Z| > \bar{Z}_0)$$ is the area in both tails beyond $$\bar{Z}_0$$, which decreases as $$\bar{Z}_0$$ increases.

- **Threshold $$z_0$$:**  
  There is a value $$z_0$$ such that:
  
  $$\textbf{(9)} \quad P(|Z| > z_0) = \alpha$$
  
  For any observed $$\bar{Z}_0 > z_0$$, the test is significant.

- **Recasting in Terms of $$\bar{x}$$:**  
  Since
  
  $$\bar{Z}_0 = \frac{\bar{x}}{\sigma/\sqrt{n}},$$
  
  the significance condition becomes:
  
  $$\textbf{(10)} \quad \bar{x} > z_0 \frac{\sigma}{\sqrt{n}}$$

---

### 4. Linking to Confidence Intervals

- **Standard Confidence Interval Formula:**  
  For known $$\sigma$$, the confidence interval for $$\mu$$ at confidence level $$\gamma$$ is:
  
  $$\textbf{(12)} \quad \bar{x} - z_0\frac{\sigma}{\sqrt{n}} < \mu < \bar{x} + z_0\frac{\sigma}{\sqrt{n}}$$
  
  Here, $$z_0$$ is determined from the probability statement:
  
  $$\textbf{(11)} \quad P(-z_0 < Z < z_0) + P(|Z| > z_0) = 1$$
  
  With $$P(|Z| > z_0) = 1 - \gamma$$, setting $$\gamma = 1 - \alpha$$ aligns the confidence level with the significance level.

- **Interpreting the Confidence Interval:**  
  - **Significant Sample Mean:**  
    If $$\bar{x}$$ is such that
  
    $$\textbf{(10)} \quad \bar{x} > z_0 \frac{\sigma}{\sqrt{n}},$$
  
    then the lower bound, $$\bar{x} - z_0\frac{\sigma}{\sqrt{n}}$$, will be positive. Thus, the interval does not include 0, implying $$\mu=0$$ is unlikely.
  
  - **Non-Significant Sample Mean:**  
    If $$\bar{x}$$ does not exceed the threshold, the interval includes 0, meaning that $$\mu=0$$ remains plausible.

- **Key Takeaway:**  
  The hypothesis test provides a yes/no decision on whether to reject $$\mu=0$$, while the confidence interval shows the range of plausible values for $$\mu$$. If the interval excludes 0, it agrees with a significant test result.

---

### 5. Summarizing the Equivalence

- Both methods use a standardized statistic (normal or t) to measure the deviation of the sample mean from the hypothesized value.
- Selecting the same threshold $$z_0$$ ensures that the test and the interval are based on equivalent probability areas.
- **Conclusion:**  
  If the sample mean is significant by hypothesis testing, the corresponding confidence interval will not contain $$\mu=0$$. Conversely, if the interval includes $$\mu=0$$, then the hypothesis test would not reject $$\mu=0$$.

---

## 3. Chi‑Square and t‑Distributions

In previous sections, we assumed the distribution of our test statistic was normal. All our equations used the standard normal distribution to find probability thresholds (e.g., $$z_0 = 1.96$$ from $$P(-z_0 < Z < z_0) = 0.95$$). In general, for any variable $$Z$$ with density $$f(Z)$$, we have

$$
P(-z_0 < Z < z_0) = \int_{-z_0}^{z_0} f(Z)\, dZ,
$$

and this must be solved for $$z_0$$ (usually numerically).

### When the Population Standard Deviation is Unknown

The Central Limit Theorem (CLT) tells us the sample mean is approximately normal. However, this requires knowing $$\sigma$$, the population standard deviation. In reality, $$\sigma$$ is unknown, so we estimate it with the sample standard deviation $$s$$.

A naive approach might be to substitute $$s$$ for $$\sigma$$ using the normal distribution. However, a more principled approach defines a new random variable:

**Equation (13):**
$$
T = \frac{\bar{x} - \mu}{s/\sqrt{n}}
$$

This statistic is the ratio of the normally distributed sample mean (minus $$\mu$$) to the estimated variability $$s/\sqrt{n}$$. Because both $$\bar{x}$$ and $$s$$ are random, $$T$$ does not follow a standard normal distribution; instead, it follows the Student’s t‑distribution.

### The Chi‑Square Distribution and Sample Variance

Consider a sum of squares of independent standard normal variables:
  
**Equation (14):**
$$
Y = X_1^2 + X_2^2 + \dots + X_n^2.
$$

For normally distributed $$X_i$$'s, $$Y$$ follows a chi‑square distribution with $$n$$ degrees of freedom:
  
$$
Y \sim \chi^2(n).
$$

Its probability density function is given by:

**Equation (15):**
$$
f_n(x) = \begin{cases}
\frac{x^{\frac{n}{2}-1} e^{-x/2}}{2^{\frac{n}{2}} \Gamma\left(\frac{n}{2}\right)} & \text{if } x \ge 0, \\
0 & \text{otherwise}.
\end{cases}
$$

Since the sample variance is essentially a (scaled) sum of squared deviations, when $$X$$ is normal, $$s^2$$ (scaled correctly) follows a chi‑square distribution.

### Deriving Student’s t‑Distribution

It can be shown that the t‑statistic (Equation (13)), which is the ratio of a normal variable to a chi‑square related variable, follows the Student’s t‑distribution:

**Equation (16):**
$$
f_n(t) = \frac{1}{\sqrt{n}\,B\left(\frac{1}{2}, \frac{n}{2}\right)} \left(1+\frac{t^2}{n}\right)^{-\frac{n+1}{2}},
$$

where $$B(a, b)$$ is the beta function. For a sample of size $$n$$, the t‑statistic follows a t‑distribution with $$n-1$$ degrees of freedom.

### Application in the t‑Test

The t‑distribution is used in the t‑test:
- Compute $$T$$ using Equation (13).
- Use the t‑distribution (Equation (16)) to determine the probability of $$T$$ being extreme, which accounts for the uncertainty from estimating $$\sigma$$.

#### Assumptions for the t‑Test

1. **Normality of the Original Data $$X$$:**  
   - For small $$n$$, $$\bar{x}$$ is normally distributed only if $$X$$ is normal.
   - The sample variance follows a chi‑square distribution only when $$X$$ is normal.

2. **Large Sample Sizes:**  
   - If $$n$$ is large, the CLT ensures that $$\bar{x}$$ is nearly normal and $$s^2$$ is more stable. Then, the t‑test works well even if $$X$$ isn’t perfectly normal.

---

## 4. Confidence Intervals: Unknown Population Variance

Now we build the confidence interval when the population variance is unknown and must be estimated by $$s$$.

### Using the t‑Statistic

We begin with the t‑statistic (Equation (13)):

$$
T = \frac{\bar{x} - \mu}{s/\sqrt{n}}.
$$

If $$X$$ is normal (or if $$n$$ is large), then $$T$$ follows a Student’s t‑distribution. Thus, when solving for confidence intervals, we use the t‑distribution instead of the normal distribution.

### Determining the t‑Quantiles

For a desired confidence level $$\gamma$$, we need to find a value $$z_0$$ such that the probability of $$T$$ falling within $$[-z_0, z_0]$$ is $$\gamma$$:

**Equation (17):**
$$
P(-z_0 < T < z_0) = \gamma.
$$

Because the t‑distribution is symmetric, the tails each contain:

**Equation (18):**
$$
P(T < -z_0) = \frac{1 - \gamma}{2},
$$

and

**Equation (19):**
$$
P(T > z_0) = \frac{1 - \gamma}{2}.
$$

Alternatively, we express it as:

**Equation (20):**
$$
P(T < z_0) = 1 - \frac{1 - \gamma}{2}.
$$

For example, for a 95% confidence interval ($$\gamma = 0.95$$), we choose $$z_0$$ such that the lower 2.5% and upper 2.5% of the t‑distribution are cut off. In other words, the interval spans from the 2.5th percentile to the 97.5th percentile.

### Building the Confidence Interval

Once $$z_0$$ is determined, we return to the inequality derived from the definition of $$T$$:

$$
-z_0 < \frac{\bar{x} - \mu}{s/\sqrt{n}} < z_0.
$$

Rearrange this inequality to solve for $$\mu$$:

**Equation (21):**
$$
\bar{x} - z_0\frac{s}{\sqrt{n}} < \mu < \bar{x} + z_0\frac{s}{\sqrt{n}}.
$$

**Note:** While Equation (21) looks similar to the interval when $$\sigma$$ is known (Equation (12)), the value of $$z_0$$ here comes from the t‑distribution rather than the normal distribution.

### An R Example

The notes also describe an example in R:
- A sample $$x$$ is drawn from a normal distribution using `rnorm()`.
- A linear model (using `lm(x ~ 1)`) is fitted. The intercept represents the sample mean.
- The function `confint()` computes the confidence interval for the intercept.
- The R functions `mean(x)` and `sd(x)` confirm the sample mean and sample standard deviation.
- To compute the t‑quantile, use the function `qt()` in R.

For a sample of size $$n$$, the t‑statistic follows a t‑distribution with $$n-1$$ degrees of freedom, and the correct quantile $$z_0$$ is obtained accordingly.

---

# Recap in Plain English

1. **Unknown Population Variance:**  
   In real-world scenarios, we usually do not know the true variance $$\sigma^2$$. Instead, we estimate it using the sample standard deviation $$s$$.

2. **Defining the t‑Statistic:**  
   To account for the uncertainty in $$s$$, we define the t‑statistic as:
   $$
   T = \frac{\bar{x} - \mu}{s/\sqrt{n}}.
   $$
   This statistic follows a Student’s t‑distribution rather than a standard normal.

3. **Finding the t‑Quantiles:**  
   To build a confidence interval at confidence level $$\gamma$$, we find the quantile $$z_0$$ from the t‑distribution such that the probability that $$T$$ lies between $$-z_0$$ and $$z_0$$ is $$\gamma$$ (which is equivalent to leaving out equal tail probabilities of $$\frac{1-\gamma}{2}$$ each).

4. **Constructing the Confidence Interval:**  
   Rearranging the inequality defining $$T$$ gives:
   $$
   \bar{x} - z_0\frac{s}{\sqrt{n}} < \mu < \bar{x} + z_0\frac{s}{\sqrt{n}}.
   $$
   This interval reflects the additional uncertainty from estimating the standard deviation.

5. **Practical Use in R:**  
   R functions like `qt()` compute the necessary t‑quantile, and functions like `confint()` (when combined with `lm()`) can automatically compute the confidence interval. This ensures that the interval properly accounts for the estimation of the variance.

In summary, when the population variance is unknown, we use the t‑distribution to redesign our confidence interval so that it accurately reflects the extra variability from estimating $$\sigma$$ with $$s$$.

