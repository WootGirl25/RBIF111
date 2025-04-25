### Overview: Introducing Confidence Intervals

- **Context:**  
  Up to now, we've used hypothesis testing. In hypothesis testing, based on a set significance level (like 5% or 0.1%), we decide whether there’s “evidence” to accept or reject a hypothesis. That gives you a yes/no answer.

- **What’s Different Here:**  
  Instead of just saying “significant” or “not significant,” confidence intervals give you a **range** of values. This range is chosen so that, if you repeated the study many times, a given percentage of those intervals (say, 95%) would contain the true value (like the true mean).

- **Two Cases:**
  1. **Known variance:** The population’s variability (\( \sigma^2 \)) is known.
  2. **Unknown variance:** More realistic; the variability is estimated from the sample, and we use the Student’s t-distribution instead.

---

### Confidence Intervals

Imagine you collect data and compute the sample mean (denoted as \( \bar{x} \)). However, because of random fluctuations, this \( \bar{x} \) is not exactly the true population mean (\( \mu \)). We want to know: “How close is \( \bar{x} \) likely to be to \( \mu \)?”

The idea of a confidence interval is to create a range \([\bar{x}_{\text{low}}, \bar{x}_{\text{high}}]\) such that we can be “confident” (say, 95% confident) that the true mean \( \mu \) lies within that range.

---

### Important Notes and Interpretations

1. **Changing the Confidence Level:**  
   The constant 1.96 comes from the fact that 95% of the standard normal distribution lies within ±1.96 standard deviations. If you wanted a 98% or 79% confidence interval, you'd use a different constant (sometimes called \( z_0 \)).

2. **Interpretation of the Confidence Interval:**  
   - **In Repeated Sampling:** If you were to take many samples and calculate this interval each time, **95% of those intervals** would contain the true mean \( \mu \).  
   - **For a Specific Sample:** Once you compute the interval from your sample, it’s a fixed range; the true mean either falls within that range or it doesn’t. The “95% confidence” does not mean there is a 95% chance for this specific interval to contain \( \mu \). Instead, it reflects the reliability of the procedure used to construct the interval.

3. **Connection to Hypothesis Testing:**  
   Think of hypothesis testing: you might reject a hypothesis because your sample mean falls outside a certain region. Here, the confidence interval gives you a continuous view of the uncertainty in your sample mean. For example, if the interval contains 0, you might say that \( \mu = 0 \) is a plausible hypothesis.

4. **The Role of the Sample Mean \( \bar{x} \):**  
   The confidence interval is built around your sample mean. Since \( \bar{x} \) is a random variable (varying from sample to sample), if you took another sample, \( \bar{x} \) would likely be different, and so would your confidence interval.

5. **Known vs. Estimated Variance:**  
   The notes above work with the assumption that \( \sigma \) is known. In most practical situations, you estimate \( \sigma \) from your data, and then you typically use the Student’s t-distribution to compute the interval instead of the standard normal. This change accounts for the additional uncertainty in estimating the variance.

### Recap in Plain English

1. **You collect data and compute the sample mean \(\bar{x}\).**  
   - But \(\bar{x}\) can vary if you were to repeat your experiment.

2. **You know from theory (and the Central Limit Theorem) that \(\bar{x}\) is roughly normally distributed with standard deviation \(\sigma/\sqrt{n}\).**

3. **By rephrasing the deviation \(\bar{x} - \mu\) in units of its standard error, you get a standardized value \(Z\) that follows a normal curve with mean 0 and standard deviation 1.**

4. **Using the fact that 95% of the normal curve lies between -1.96 and 1.96, you set up an inequality that accounts for 95% of possible sample outcomes:**

   

\[
   P(-1.96 < Z < 1.96) = 0.95
   \]



5. **Solving this inequality for the true mean \(\mu\) yields the 95% confidence interval:**

   

\[
   \bar{x} - 1.96 \frac{\sigma}{\sqrt{n}} < \mu < \bar{x} + 1.96 \frac{\sigma}{\sqrt{n}}
   \]



6. **This interval gives you a "range" that, over many repeated samples, would capture the true mean in 95% of cases.**
___
### Breaking Down the Connection Between Hypothesis Testing and Confidence Intervals

---

#### 1. Confidence Intervals and Hypothesis Testing Are Closely Related

- **Key Idea:**  
  Both methods are ways of quantifying uncertainty about a parameter—here, the population mean \( \mu \). They can even be equivalent when set up appropriately.

- **Example:**  
  Consider testing the null hypothesis that \( \mu = 0 \).

---

#### 2. Hypothesis Testing Approach for \( \mu = 0 \)

- **Step A: Setting Up the Test**  
  - We have a sample with sample mean \( \bar{x} \).
  - To test if \( \mu = 0 \), we ask: *"What is the probability of obtaining a sample mean as extreme as (or more extreme than) our observed \( \bar{x} \), assuming that \( \mu = 0 \)?"*

- **Step B: Standardizing the Sample Mean**  
  - Introduce the standardized variable (Z-score) given by:

    **Equation (7):**
    

\[
    \bar{Z}_0 = \frac{\bar{x}}{\sigma/\sqrt{n}}
    \]



  - This transformation assumes the null hypothesis \( \mu = 0 \).

- **Step C: Calculating the Extreme Tail Probability**  
  - The probability of observing an absolute Z-score greater than \( \bar{Z}_0 \) is:

    

\[
    P(|Z| > \bar{Z}_0)
    \]



- **Step D: Using a Significance Level \( \alpha \)**  
  - We set a significance cutoff \( \alpha \) (like 0.05).
  - We reject the null hypothesis (i.e. call the result “significant”) when:

    **Equation (8):**
    

\[
    P(|Z| > \bar{Z}_0) < \alpha
    \]



  - **Interpretation:** If the likelihood of observing such an extreme value (when \( \mu = 0 \)) is very low, then the observed sample mean is unlikely to be due to random chance.

---

#### 3. The Role of the Standard Normal Distribution

- **Monotonic Decrease:**  
  - The probability \( P(|Z| > \bar{Z}_0) \) is the area in both tails of the standard normal curve beyond \( \bar{Z}_0 \).  
  - This probability decreases as \( \bar{Z}_0 \) increases.

- **Threshold \( z_0 \):**  
  - There exists a value \( z_0 \) such that:

    **Equation (9):**
    

\[
    P(|Z| > z_0) = \alpha
    \]



  - **Significance Decision:**  
    For any observed \( \bar{Z}_0 > z_0 \), the test would be deemed significant.

- **Recasting in Terms of \( \bar{x} \):**  
  - Since

    **Equation (7):**
    

\[
    \bar{Z}_0 = \frac{\bar{x}}{\sigma/\sqrt{n}},
    \]



    we can rewrite the significance condition as:

    **Equation (10):**
    

\[
    \bar{x} > z_0 \frac{\sigma}{\sqrt{n}}
    \]



  - Thus, if the sample mean exceeds this threshold, the result is significant.

---

#### 4. Linking to Confidence Intervals

- **Standard Confidence Interval Formula:**  
  With known \( \sigma \), the confidence interval for \( \mu \) at a confidence level \( \gamma \) is:

  **Equation (12):**
  

\[
  \bar{x} - z_0 \frac{\sigma}{\sqrt{n}} < \mu < \bar{x} + z_0 \frac{\sigma}{\sqrt{n}}
  \]



  Here, \( z_0 \) is determined from the probability statement:

  **Equation (11):**
  

\[
  P(-z_0 < Z < z_0) + P(|Z| > z_0) = 1
  \]



  Note that since \( P(|Z| > z_0) = 1 - \gamma \), setting \( \gamma = 1 - \alpha \) ties the confidence level directly to the significance level.

- **Interpreting the Confidence Interval:**
  - **Significant Sample Mean:**  
    - If the observed \( \bar{x} \) is such that

      **Equation (10):**
      

\[
      \bar{x} > z_0 \frac{\sigma}{\sqrt{n}},
      \]



      then the *lower bound* of the confidence interval (i.e. \( \bar{x} - z_0 \frac{\sigma}{\sqrt{n}} \)) will be positive.  
    - This means the interval does **not** include 0, suggesting that the hypothesis \( \mu = 0 \) is not plausible.

  - **Non-Significant Sample Mean:**  
    - If \( \bar{x} \) is not large enough (i.e. does not satisfy the significance condition), then the confidence interval will span across \( \mu = 0 \), indicating that 0 remains a plausible value.

- **Key Takeaway:**  
  The confidence interval and hypothesis test convey the same information:
  - **Hypothesis Test:** Provides a **yes/no** decision on whether to reject \( \mu = 0 \).
  - **Confidence Interval:** Shows the **range of plausible values** for \( \mu \). If this range excludes 0, it aligns with a significant result from the hypothesis test.

---

#### 5. Summarizing the Equivalence

- Both methods use the standard normal (or its t-distribution variant when \( \sigma \) is unknown) to assess the deviation of the sample mean from the hypothesized value.
- By choosing the same threshold \( z_0 \), both the significance test and the confidence interval are based on the same probability areas.
- **Conclusion:**  
  - If a sample mean is significant under hypothesis testing, the corresponding confidence interval excludes the null hypothesis value (e.g., \( \mu=0 \)).  
  - Conversely, if the confidence interval includes \( \mu=0 \), the test would not reject the null hypothesis at that significance level.

### 3. Chi-square and t‑Distributions

In the previous section, we used the normal distribution to work with probabilities and confidence intervals. All our formulas that involve finding thresholds (e.g., \( z_0 = 1.96 \) when


\[
P(-z_0 < Z < z_0) = 0.95
\]


) were based on the properties of the standard normal distribution. In general, for any variable \( Z \) with density \( f(Z) \), we have:


\[
P(-z_0 < Z < z_0) = \int_{-z_0}^{z_0} f(Z) \, dZ
\]


and this equation must be solved for \( z_0 \) (often numerically, since analytical solutions may not exist).

---

#### When the Population Standard Deviation is Unknown

The Central Limit Theorem (CLT) tells us that the distribution of the sample mean is approximately normal. However, to use that result, we must know the population standard deviation \( \sigma \) (as seen in the confidence interval formulas). In reality, \( \sigma \) is usually unknown and is estimated from the sample by using the sample standard deviation \( s \).

One might think to simply replace \( \sigma \) with \( s \) in previous equations. That approach gives an approximation, but there is a more accurate method that leads to the use of the Student’s t‑distribution.

---

#### Defining the t‑Statistic (Equation 13)

Instead of using the unknown \( \sigma \), we define a new random variable:
 
**Equation (13):**


\[
T = \frac{\bar{x} - \mu}{s/\sqrt{n}}
\]


  
Here:
- \( \bar{x} \) is the sample mean.
- \( \mu \) is the (unknown) population mean.
- \( s \) is the sample standard deviation.
- \( n \) is the sample size.

Since both \( \bar{x} \) and \( s \) are random variables (they change from sample to sample), \( T \) becomes a ratio of two random quantities. While the numerator (the sample mean) is normally distributed (especially if \( X \) itself is normally distributed), the denominator \( s \) introduces extra uncertainty.

---

#### The Chi‑Square Distribution and the Sample Variance

Before we can fully understand \( T \), we need to consider the distribution of the sample variance. Recall that if \( X \) is a normally distributed random variable and we have independent observations, then the sum of squares is given by:

**Equation (14):**


\[
Y = X_1^2 + X_2^2 + \dots + X_n^2
\]



For normally distributed \( X_i \)'s, the random variable \( Y \) follows a chi‑square distribution:


\[
Y \sim \chi^2(n)
\]


  
Its probability density function is given as:

**Equation (15):**


\[
f_n(x) = \begin{cases}
\frac{x^{n/2-1} e^{-x/2}}{2^{n/2} \Gamma(n/2)} & \text{if } x \ge 0 \\
0 & \text{otherwise}
\end{cases}
\]



Since the sample variance \( s^2 \) (scaled appropriately) is essentially a sum of squared deviations (when \( \mu=0 \) for simplification), it follows a chi‑square distribution if the original \( X \) is normal.

---

#### Deriving Student’s t‑Distribution

It can be shown that the t‑statistic defined in Equation (13), which is the ratio of the normal variable \( \bar{x} \) (minus \( \mu \)) to a chi‑square-related variable (through \( s \)), follows what is known as the Student’s t‑distribution. Its probability density function is:

**Equation (16):**


\[
f_n(t) = \frac{1}{\sqrt{n}\,B\left(\frac{1}{2}, \frac{n}{2}\right)} \left(1+\frac{t^2}{n}\right)^{-\frac{n+1}{2}}
\]


  
Here, \( B(a,b) \) is the beta function. Importantly, for a sample of size \( n \), the t‑statistic \( T \) in Equation (13) follows a t‑distribution with \( n-1 \) degrees of freedom.

---

#### Application in the t‑Test

This Student’s t‑distribution is exactly what is used in the t‑test:
- You compute the statistic \( T \) using Equation (13).
- Instead of comparing it to the normal distribution (as in previous sections), you now use the t‑distribution given by Equation (16).
- This adjustment accounts for the extra uncertainty when \( \sigma \) is unknown.

---

#### Key Assumptions and Requirements of the t‑Test

1. **Normality of the Original Data \( X \):**  
   - For small sample sizes, the sample mean \( \bar{x} \) is normally distributed only if the original variable \( X \) is normally distributed.
   - The sample variance \( s^2 \) follows a chi‑square distribution only when \( X \) is normal.

2. **Large Sample Sizes:**  
   - For large \( n \), the CLT ensures that \( \bar{x} \) is approximately normal, and the chi‑square distribution of \( s^2 \) approaches normal behavior.
   - Therefore, the t‑distribution (and the t‑test) works reasonably well even when \( X \) is not exactly normal.

---

### Recap in Plain English

1. **Switching from Normal to t‑Distribution:**
   - We originally used the standard normal distribution to build confidence intervals and test hypotheses. That method required knowing the population standard deviation \( \sigma \).
   - In practice, we don’t know \( \sigma \), so we estimate it using the sample standard deviation \( s \).

2. **Defining the t‑Statistic:**
   - To account for the extra uncertainty from estimating \( \sigma \), we define a new statistic \( T \) as:
     

\[
     T = \frac{\bar{x} - \mu}{s/\sqrt{n}}
     \]


   - This ratio involves two random parts (\( \bar{x} \) and \( s \)) and thus does not follow the standard normal distribution.

3. **Role of the Chi‑Square Distribution:**
   - The sample variance (which uses \( s^2 \)) is based on the sum of squared deviations of \( X \). If \( X \) is normally distributed, this sum follows a chi‑square distribution.
   - This connection is critical because the distribution of \( T \) ends up being derived as a combination of a normal and a chi‑square variable.

4. **Student’s t‑Distribution:**
   - The t‑statistic \( T \) defined above follows the Student’s t‑distribution, which has thicker tails than the normal distribution. This adjustment reflects the additional variability introduced by using \( s \) instead of \( \sigma \).
   - For a sample of size \( n \), \( T \) follows a t‑distribution with \( n-1 \) degrees of freedom.

5. **When Is the t‑Test Appropriate?**
   - For small sample sizes, the t‑test works best when the original data \( X \) are normally distributed.
   - For larger samples, the t‑test is robust and performs well even if \( X \) isn’t perfectly normal because both the sample mean and sample variance become more stable.

In summary, when we don’t know the true standard deviation, we switch from using the normal distribution to the t‑distribution, which better captures the extra uncertainty from estimating \( \sigma \). This is the basis for the t‑test used widely in statistics.

### 4. Confidence Intervals: Unknown Population Variance

Now we are finally in a position to build a confidence interval in the more realistic case where we have a sample but do not know the underlying population variance. In such cases, we must estimate the variance from the sample itself.

#### Using the t‑Statistic

Putting together the machinery we developed earlier, we start by defining the dimensionless variable \(T\) as in Equation (13):
  
**Equation (13):**


\[
T = \frac{\bar{x} - \mu}{s/\sqrt{n}}
\]


  
Here:
- \(\bar{x}\) is the sample mean.
- \(\mu\) is the unknown population mean.
- \(s\) is the sample standard deviation (our estimate for \(\sigma\)).
- \(n\) is the sample size.

If the underlying variable \(X\) is normal (or if \(n\) is sufficiently large), then \(T\) follows a Student’s t‑distribution, not the standard normal distribution. Therefore, when constructing the confidence interval, we need to use the t‑distribution.

#### Determining the t‑Quantiles

When looking for a confidence interval at significance level \(\gamma\), we want to find the boundary \(z_0\) such that the probability to observe the value \(T\) in the interval \([-z_0, z_0]\) is equal to \(\gamma\). That is:

**Equation (17):**


\[
P(-z_0 < T < z_0) = \gamma
\]



Because the t‑distribution is symmetric, the remaining probability \(1 - \gamma\) is equally split between the two tails:
  
**Equation (18):**


\[
P(T < -z_0) = \frac{1 - \gamma}{2}
\]



**Equation (19):**


\[
P(T > z_0) = \frac{1 - \gamma}{2}
\]



Or equivalently, we can express it as:
  
**Equation (20):**


\[
P(T < z_0) = 1 - \frac{1 - \gamma}{2}
\]



The value \(-z_0\) (and accordingly \(z_0\)) is defined as the quantile of the t‑distribution corresponding to the lower \(\frac{1 - \gamma}{2}\) (or upper \(1 - \frac{1 - \gamma}{2}\)) tail probability. For example, for a 95% confidence interval (\(\gamma = 0.95\)), we want the boundaries such that 2.5% of the distribution is left in each tail – so the interval spans from the 2.5th percentile to the 97.5th percentile.

#### Building the Confidence Interval

Once the boundaries \(z_0\) are determined from the t‑distribution with \(n-1\) degrees of freedom, we substitute back into Equation (13). Rearranging the inequality


\[
-z_0 < \frac{\bar{x} - \mu}{s/\sqrt{n}} < z_0
\]


to solve for \(\mu\) gives us:

**Equation (21):**


\[
\bar{x} - z_0\frac{s}{\sqrt{n}} < \mu < \bar{x} + z_0\frac{s}{\sqrt{n}}
\]



**Note:**  
Although Equation (21) appears similar to Equation (12) (from the case with known \(\sigma\)), the value of \(z_0\) here is determined using the t‑distribution rather than the normal distribution.

#### An R Example

The notes then illustrate this with an example in R:
- A sample \(x\) is randomly drawn from a normal distribution using `rnorm()`.
- A simple linear model `lm(x ~ 1)` (which includes only an intercept) is fitted. In this model, the intercept is equivalent to the sample mean.
- The function `confint()` is used to compute the confidence interval for the intercept.
- The output confirms that the intercept is the same as `mean(x)` and that `sd(x)` corresponds to the sample standard deviation.
- Finally, it is noted that R provides functions such as `qt()` to compute t‑distribution quantiles. For any distribution available in R, you have corresponding functions (e.g., `dnorm()`, `rnorm()`, `qnorm()` for the normal distribution and similarly `dt()`, `rt()`, `qt()` for the t‑distribution).

The t‑statistic for a sample of size \(n\) follows a t‑distribution with \(n-1\) degrees of freedom, which is why the quantile \(z_0\) in Equation (21) is determined accordingly.

---

### Recap in Plain English

1. **Unknown Population Variance:**  
   In many real-world scenarios, we don’t know the population variance. Therefore, we estimate it with the sample standard deviation \(s\).

2. **Defining the t‑Statistic:**  
   To account for the extra uncertainty when estimating the population variance, we define the t‑statistic:
   

\[
   T = \frac{\bar{x} - \mu}{s/\sqrt{n}}
   \]


   This statistic follows a t‑distribution rather than a normal distribution.

3. **Finding the t‑Quantile:**  
   To construct a confidence interval, we determine the boundary \(z_0\) from the t‑distribution such that the probability that \(T\) falls between \(-z_0\) and \(z_0\) equals our desired confidence level \(\gamma\) (typically 0.95 for a 95% confidence interval). This involves splitting the remaining probability equally into both tails of the distribution.

4. **Constructing the Confidence Interval:**  
   Once \(z_0\) is obtained, we plug it into the rearranged inequality of the t‑statistic, which gives:
   

\[
   \bar{x} - z_0\frac{s}{\sqrt{n}} < \mu < \bar{x} + z_0\frac{s}{\sqrt{n}}
   \]


   Although this looks similar to the interval where \(\sigma\) is known, the key difference is that here \(z_0\) is based on the t‑distribution (reflecting the extra uncertainty due to estimating variance).

5. **Practical Implementation:**  
   In R, functions such as `qt()` can compute the required quantiles. Additionally, linear model functions (`lm()`) and `confint()` can automatically generate confidence intervals, verifying the manual calculation.

In essence, by recognizing the unknown variance and using the t‑distribution, we build a more accurate confidence interval that reflects the uncertainty in our sample-based variance estimation.

