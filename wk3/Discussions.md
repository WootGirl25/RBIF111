>Question1

From the attached plots and histograms of residuals for the linear models fitted to the probes with the maximum and minimum p-values, here are some observations and suggestions:

### Observations:
1. **QQ Plots**:
   - The QQ plots for both `max.lm` and `min.lm` show deviations from the theoretical quantiles, particularly in the tails. This indicates that the residuals are not perfectly normally distributed, which is an assumption of linear regression.
   - The deviations are more pronounced for the model with the maximum p-value (`max.lm`), suggesting that the fit is weaker for this probe.

2. **Histograms of Residuals**:
   - The histograms of residuals for both models show some skewness or non-normality. This further supports the observation from the QQ plots that the residuals deviate from normality.

3. **ANOVA Results**:
   - The ANOVA results for the probe with the minimum p-value (`min.lm`) show a highly significant effect (very low p-value), indicating a strong relationship between gene expression and age for this probe.
   - For the probe with the maximum p-value (`max.lm`), the effect is not significant, as expected.

### Interpretation:
- The deviations from normality in the residuals could be due to:
  - Non-linear relationships between gene expression and age.
  - Outliers or heteroscedasticity (non-constant variance of residuals).
  - Biological variability or noise in the data.

- The significant p-value for the `min.lm` model suggests that this probe has a meaningful relationship with age, while the non-significant p-value for the `max.lm` model indicates no strong relationship.

### Suggestions:
1. **Transformations**:
   - Consider applying transformations (e.g., log or square root) to the gene expression data to improve normality and linearity.

2. **Outlier Detection**:
   - Check for outliers in the data that might be influencing the residuals and consider removing or addressing them.

3. **Non-linear Models**:
   - If the relationship between gene expression and age is non-linear, consider using non-linear regression models or generalized additive models (GAMs).

4. **Batch Correction**:
   - As mentioned in your second question, perform batch correction to account for technical variability. This might improve the fit of the models and the normality of residuals.

5. **Validation**:
   - Validate the findings by splitting the dataset into training and testing subsets or using cross-validation to ensure the robustness of the models.

Let me know if you'd like help implementing any of these suggestions!

> Question 2
SeSAMe: reducing artifactual detection of DNA methylation by Infinium BeadChips in genomic deletions

### Summary
The article introduces SeSAMe, an R package designed to address artifacts in DNA methylation measurements from Illumina HumanMethylation450 and MethylationEPIC arrays. These artifacts arise from failed hybridization due to genomic deletions or hyperpolymorphism, leading to spurious intermediate methylation signals that can confound epigenome-wide association studies (EWAS) and methylation-quantitative trait loci (meQTL) analyses.

SeSAMe implements a novel detection P-value method, pOOBAH (P-value with out-of-band array hybridization), which effectively masks problematic probes. Key features and findings include:
- **Artifact Reduction**: SeSAMe reduces false-positive methylation signals caused by genomic deletions and cross-hybridization.
- **Improved Consistency**: It enhances consistency between HM450, EPIC, and whole-genome bisulfite sequencing (WGBS) platforms.
- **Batch Effect Mitigation**: SeSAMe reduces technical variation (e.g., batch effects) while retaining biological variation.
- **Cross-Platform Integration**: Facilitates combined analyses of HM450 and EPIC data, addressing the need to integrate legacy and new datasets.

### Key Results
1. **Detection of Artifacts**: SeSAMe identifies and masks probes affected by germline and somatic deletions, hyperpolymorphic regions (e.g., HLA loci), and low signal intensities.
2. **Improved Data Quality**: It reduces spurious intermediate methylation signals, particularly in regions like tumor suppressor genes (e.g., CDKN2A, RB1).
3. **Enhanced Cross-Platform Correlation**: SeSAMe improves agreement between HM450 and EPIC platforms, as well as with WGBS data.
4. **Technical Variation Reduction**: By addressing non-detection artifacts, SeSAMe minimizes batch effects and improves clustering of biological replicates.

### Applications
SeSAMe is a lightweight, modular tool for preprocessing DNA methylation data, suitable for large-scale studies. It is particularly useful for:
- EWAS and meQTL studies
- Cancer research involving copy number alterations
- Cross-platform data integration

### Conclusion
SeSAMe provides a robust solution to reduce technical artifacts in DNA methylation data, improving the reliability of downstream analyses and enabling better integration of legacy and modern datasets.

___
Given that they used SeSAMe to normalize (which has a key point about batch effect mitigation), what would you expect to be the differences between results(wk3 homeword.Rmd) if sesame normalization was not already applied to the dataset

If SeSAMe normalization had **not** already been applied to the dataset, the results of your analysis in `wk3 homeword.Rmd` would likely differ in the following ways:

---

### 1. **Increased Technical Artifacts**:
   - Without SeSAMe normalization, the dataset would likely contain more technical artifacts, such as:
     - **Spurious intermediate methylation signals** caused by genomic deletions or hyperpolymorphic regions.
     - **Cross-hybridization artifacts** from probes binding to unintended genomic regions.
   - These artifacts could lead to inflated or deflated p-values in your ANOVA results, making it harder to distinguish true biological signals from noise.

---

### 2. **Batch Effects**:
   - SeSAMe includes steps to mitigate batch effects, even though it is not a dedicated batch correction tool. Without SeSAMe, batch effects (e.g., differences between processing labs or platforms) would likely be more pronounced.
   - This could result in:
     - Clustering of samples by batch rather than biological variables (e.g., age).
     - Increased variability in residuals from your linear models, leading to poorer model fits and less reliable QQ plots.

---

### 3. **Reduced Data Quality**:
   - SeSAMe improves the consistency of methylation measurements across platforms (e.g., HM450, EPIC, WGBS). Without this normalization:
     - The data might show greater variability between probes and samples.
     - The histograms of residuals and p-values might exhibit irregular patterns, reflecting technical noise rather than biological variation.

---

### 4. **Weaker Biological Signal**:
   - SeSAMe masks problematic probes (e.g., those with low signal intensities or affected by deletions). Without this masking:
     - Probes with unreliable measurements could dominate the analysis, diluting the biological signal.
     - The probe with the "most significant" p-value might not truly reflect a strong biological relationship but instead be an artifact.

---

### 5. **Impact on Diagnostic Plots**:
   - **QQ Plots**:
     - Without SeSAMe, the QQ plots for residuals might show greater deviations from normality, especially in the tails, due to uncorrected technical artifacts.
   - **Histograms of Residuals**:
     - The histograms might show more skewness or irregular distributions, reflecting uncorrected noise in the data.

---

### 6. **Batch Correction Would Be More Critical**:
   - If SeSAMe normalization had not been applied, batch correction (e.g., using ComBat) would become more important to address technical variability.
   - However, batch correction alone cannot address all the issues that SeSAMe resolves, such as cross-hybridization artifacts or spurious signals from genomic deletions.

---

### Expected Differences in Results:
1. **P-Value Distribution**:
   - Without SeSAMe, the histogram of p-values might show a less uniform distribution, with more extreme values caused by technical noise.
   
2. **Linear Model Fits**:
   - The linear models for the probes with the most and least significant p-values might show poorer fits, with higher residual variability and less meaningful biological interpretation.

3. **Biological Insights**:
   - The biological conclusions drawn from the analysis might be less reliable, as technical artifacts could obscure true relationships between methylation and age.

---

### Conclusion:
SeSAMe normalization plays a critical role in improving data quality and mitigating technical artifacts, including batch effects. Without it, your analysis would likely be more affected by noise and technical variability, leading to less reliable results. If SeSAMe normalization had not been applied, additional preprocessing steps (e.g., batch correction, probe filtering) would be necessary to achieve comparable data quality.

