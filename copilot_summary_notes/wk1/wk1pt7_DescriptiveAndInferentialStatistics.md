WootGirl25: Please analyze the linked txt document. Please make a summary of these notes - the purpose of the summary notes will be to act as a quick refresher of things I have learnt from the full version, I want to be able to come back and read over the summary to revise what I have learnt this week. Highlight all key points in the learning materials and provide examples where appropiate.

GitHub Copilot: ### Summary Notes: Week 1 - Descriptive and Inferential Statistics

#### **1. Overview**
- **Descriptive Statistics**: Summarizes and organizes data (e.g., mean, median, mode, standard deviation).
- **Inferential Statistics**: Draws conclusions about a population based on a sample (e.g., hypothesis testing, confidence intervals).

---

#### **2. Key Concepts in Descriptive Statistics**
- **Central Tendency**:
  - **Mean**: Arithmetic average of data.
    - Example: `mean(1:5)` → 3.
  - **Median**: Middle value of sorted data, robust to outliers.
    - Example: `median(c(1:5, 100))` → 3.5.
  - **Mode**: Most frequently occurring value.

- **Spread of Data**:
  - **Standard Deviation (SD)**: Measures spread around the mean.
    - Formula: `s = sqrt((1/n) * Σ(xi - x̄)^2)`
    - Example: `sd(ALL$age, na.rm=T)` → 13.8033.
  - **Median Absolute Deviation (MAD)**: Robust alternative to SD.
    - Example: `mad(ALL$age, na.rm=T)` → 16.3086.
  - **Range**: Difference between max and min values.
    - Example: `range(ALL$age, na.rm=T)` → [5, 58].
  - **Interquartile Range (IQR)**: Spread of the middle 50% of data.
    - Example: `IQR(ALL$age, na.rm=T)` → 26.5.

---

#### **3. Visualizing Data**
- **Histograms**:
  - Groups data into bins and shows frequency distribution.
  - Example: `hist(ALL$age)` → Reveals age group 15-20 is over-represented.

- **Boxplots**:
  - Visualizes the "5-number summary" (Min, Q1, Median, Q3, Max).
  - Example: `boxplot(ALL$age)` → Median age ~30, IQR ~20-45.
  - Stratified Boxplots: `boxplot(age~sex, ALL)` → Compares distributions by sex.

- **Stripcharts**:
  - Displays individual data points.
  - Example: `stripchart(ALL$age, method="jitter")` → Adds vertical scatter for clarity.

- **Dotcharts**:
  - Similar to stripcharts but separates points vertically.

- **Stem-and-Leaf Plots**:
  - Text-based histogram alternative.
  - Example: `stem(ALL$age)` → Groups ages into bins with detailed values.

---

#### **4. Gaussian (Normal) Distribution**
- **Definition**:
  - Bell-shaped curve defined by:
    ```
    f(x) = (1 / sqrt(2πσ²)) * e^(-(x-μ)² / (2σ²))
    ```
  - Parameters:
    - **μ (mean)**: Center of the distribution.
    - **σ (standard deviation)**: Spread of the distribution.

- **Properties**:
  - 68% of data within 1 SD of the mean.
  - 95% of data within 2 SDs.
  - 99.8% of data within 3 SDs.

---

#### **5. Box-and-Whisker Plot**
- **5-Number Summary**:
  - Min, Q1 (lower quartile), Median, Q3 (upper quartile), Max.
  - Whiskers extend to:
    - `Lower quartile - 1.5 * IQR` or Min.
    - `Upper quartile + 1.5 * IQR` or Max.
  - Outliers are plotted as individual points.

- **Example**:
  - `quantile(ALL$age, na.rm=T)`:
    ```
    0%   25%   50%   75%  100%
    5.0  19.0  29.0  45.5 58.0
    ```

---

#### **6. Comparing Groups**
- **Stratified Boxplots**:
  - Example: `boxplot(age~sex, ALL)` → Males appear younger overall compared to females.

---

#### **7. Summary**
- **Key Metrics**:
  - Central Tendency: Mean, Median, Mode.
  - Spread: SD, MAD, Range, IQR.
- **Key Visualizations**:
  - Histograms, Boxplots, Stripcharts, Dotcharts, Stem-and-Leaf Plots.
- **Gaussian Distribution**:
  - Widely used in statistics; defined by mean (μ) and SD (σ).
- **Boxplots**:
  - Useful for summarizing data distribution and identifying outliers.

These notes provide a concise refresher on descriptive and inferential statistics, focusing on key metrics, visualizations, and the Gaussian distribution.---

#### **6. Comparing Groups**
- **Stratified Boxplots**:
  - Example: `boxplot(age~sex, ALL)` → Males appear younger overall compared to females.

---

#### **7. Summary**
- **Key Metrics**:
  - Central Tendency: Mean, Median, Mode.
  - Spread: SD, MAD, Range, IQR.
- **Key Visualizations**:
  - Histograms, Boxplots, Stripcharts, Dotcharts, Stem-and-Leaf Plots.
- **Gaussian Distribution**:
  - Widely used in statistics; defined by mean (μ) and SD (σ).
- **Boxplots**:
  - Useful for summarizing data distribution and identifying outliers.

These notes provide a concise refresher on descriptive and inferential statistics, focusing on key metrics, visualizations, and the Gaussian distribution.