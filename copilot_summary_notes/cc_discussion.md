# Question 2:\
## "Describe how much this number of dimensions explaining most of the variance in the data changes for different number of genes considered."

Your PCA results suggest that the overall structure of variation in your data is dominated by a small number of dimensions, regardless of whether you focus on the top 100 or top 1000 most variable genes. Here’s a breakdown of what your output indicates:

1. **Dimensionality of Variance:**  
   - **Top 100 genes:** The first 2 principal components (PCs) account for 50% of the total variance, and the first 4 PCs reach 75% of the variance.  
   - **Top 1000 genes:** You see the same numbers—2 PCs for 50% and 4 PCs for 75%.  
   
   This means that the main sources of variation in your gene expression data lie along these same few directions. In other words, the “signal” embedded in the data (the main patterns you want to capture) is very concentrated. Even when expanding the analysis from 100 to 1000 genes, those additional genes do not contribute significantly to new, substantial axes of variation.

2. **Robustness to Gene Selection:**  
   Typically, one might expect that adding more genes could introduce extra variability—either by incorporating additional biological signals or more noise. However, your results tell a different story. The fact that the number of PCs needed to achieve 50% or 75% explained variance remains unchanged indicates that the most variable genes (the “top” ones) already capture the bulk of the structured differences between samples. The extra 900 genes in the top 1000 likely have lower variance relative to the top ones and thus add little new information in terms of major variance components.

3. **Practical Implications:**  
   - **Data simplification:** Since only a few PCs account for most of the variance, you can effectively reduce your data dimensionality without losing much information. This might be very useful for downstream analyses such as clustering, visualization, or regression.
   - **Biological insight:** If the top PCs are reflecting underlying biological processes or technical artifacts, it shows that these processes are very prominent. It might be worth further investigating what these dominant patterns represent.  
   - **Consistency:** The stability in the number of PCs required implies that if you were to perform further analyses with variations of gene sets (or even after additional filtering), you might expect similar underlying low-dimensional structure.

4. **Beyond the Numbers:**  
   While the thresholds of 50% and 75% variance are useful benchmarks, it can also be insightful to look at the scree plots (which you’ve already generated) to visualize how quickly the variance drops off. A sharp “elbow” early in the plot reinforces the idea of a low intrinsic dimensionality of your data. Additionally, consider how these PCs relate to known biological factors—sometimes the first few PCs correlate with experimental conditions, batch effects, or other biological variables.

In summary, your analysis shows that the main variance in your dataset is captured by just a couple of PCs, and expanding the gene set from the top 100 to the top 1000 does not change the number of dimensions required to capture 50% or 75% of the variance. This finding implies that the most variable genes contain the dominant information, and including many more genes does not significantly alter the overall variance structure.


## "Examine structure in the data as revealed by visualizing in PC projection. Color points by any annotation features available (e.g. treatment, sex, batch, ect…) in a scatter plot (a 3D scatter plot will be best). Describe your findings. Repeat this analysis with normalized data and compare the results. Describe which version produces the best results and explain why."

Here’s an analysis and discussion of your PCA results, based on the four 3D scatterplots comparing **raw vs normalized data** and **top 100 vs top 1000 most variable genes**:

---

### 1. **Normalized vs Raw Data**

- **Normalized Data (left plots):**
  - The clusters for each treatment group (DMSO, LOX, MPB) are more compact and separated, especially in the top 1000 genes plot.
  - Normalization (log2 transformation) reduces the influence of extreme values and technical noise, making biological differences more apparent.
  - The spread along the principal components is more balanced, and the overall structure is clearer.

- **Raw Data (right plots):**
  - The clusters are less distinct, and there is more overlap between treatment groups.
  - The spread along PC axes is more uneven, suggesting that technical variation or outliers may be dominating the variance.
  - Raw counts can be heavily influenced by highly expressed genes, masking subtle biological differences.

**Conclusion:**  
**Normalization improves the clarity and interpretability of PCA plots**, making it easier to distinguish between treatment groups.

---

### 2. **Top 100 vs Top 1000 Most Variable Genes**

- **Top 100 Genes (top row):**
  - The separation between groups is visible, but the structure is simpler.
  - Using fewer genes focuses on the most variable features, which can highlight strong group differences but may miss subtler patterns.

- **Top 1000 Genes (bottom row):**
  - The structure is more complex, and group separation is still visible, especially in the normalized data.
  - Including more genes captures more of the overall variance in the data, which can reveal additional biological or technical effects.
  - However, too many genes can also introduce noise if less informative genes are included.

**Conclusion:**  
**Using more genes (top 1000) can provide a richer view of the data’s structure,** but normalization is key to making this interpretable. The best separation is seen in the normalized, top 1000 genes plot.

---

### 3. **Treatment Group Structure**

- In all plots, **treatment groups show some degree of clustering**, indicating that treatment is a major driver of variance in your data.
- The best group separation is observed in the **normalized, top 1000 genes** plot, suggesting that both normalization and including more variable genes help reveal biological structure.

---

### 4. **Recommendations**

- **For exploratory analysis and visualization, always normalize your data.**
- **Consider using the top 1000 most variable genes** for PCA to capture more biological variation, but be aware of potential noise.
- **Coloring by annotation (treatment) is essential** for interpreting PCA plots and understanding what drives sample clustering.

---

### **Summary Table**

|                | Top 100 Genes | Top 1000 Genes |
|----------------|--------------|---------------|
| **Raw**        | Some separation, less clear | More complex, but noisy |
| **Normalized** | Clearer, compact clusters   | Best separation and structure |

---

**In summary:**  
**Normalization and using a larger set of variable genes both improve the ability of PCA to reveal biologically meaningful structure in your data.** The normalized, top 1000 genes plot provides the clearest separation of treatment groups, supporting the use of these preprocessing steps in your analysis.

--->> Which version provides the best results, why?\
**The normalized data with the top 1000 most variable genes provides the best results.**

**Why?**

- **Normalization** (log-transform) reduces the impact of extreme values and technical noise, making biological differences between groups clearer.
- **Using more genes** (top 1000) captures more of the overall variance and biological signal, allowing for better separation of treatment groups if those differences are present.
- In your plots, the **normalized, top 1000 genes** panel shows the most distinct and compact clustering by treatment group, with less overlap between groups compared to the raw data or the top 100 genes.

**Summary:**  
Normalization plus a larger set of variable genes gives the clearest, most biologically meaningful separation of your samples in PCA. This is consistent with best practices in RNA-seq and high-dimensional data analysis.

# Question 3:\

## "Visually compare and describe changes in the membership in the several top level clusters for each number of the genes chosen"

Here’s how you can visually compare and describe the changes in cluster membership as you increase the number of genes used for hierarchical clustering:

---

### Visual Comparison

- **Top 100 genes:**  
  The dendrogram on the left shows clustering based on the 100 most variable genes. The samples are split into two main clusters at the highest level. The separation is relatively distinct, but some samples may be grouped differently compared to the other dendrograms.

- **Top 1000 genes:**  
  The middle dendrogram, using the top 1000 genes, shows a similar overall structure, but some samples may shift between clusters compared to the 100-gene case. The branches are generally longer, indicating greater overall dissimilarity, and the main split may occur at a different point.

- **All genes:**  
  The rightmost dendrogram, using all genes, is similar in structure to the 1000-gene dendrogram, but with subtle differences. Some samples that clustered together with fewer genes may now be separated, or vice versa. The overall height of the dendrogram is similar to the 1000-gene case, suggesting that adding more genes beyond the top 1000 does not drastically change the main cluster structure.

---

### Description of Changes

- **Cluster Membership Stability:**  
  The core membership of the largest clusters remains relatively stable as you increase from 100 to 1000 to all genes, but there are some samples that change cluster assignment, especially at the boundaries of clusters.

- **Resolution and Separation:**  
  Using more genes (1000 or all) tends to increase the resolution of the clustering, sometimes splitting or merging smaller subclusters. The main top-level split (k=2) is generally preserved, but the exact composition of each cluster can shift.

- **Interpretation:**  
  - With only 100 genes, clustering is driven by the most variable features, which may highlight the strongest biological differences but can miss subtler patterns.
  - With 1000 or all genes, clustering incorporates more information, which can refine the clusters but may also introduce noise if less informative genes are included.
  - If the main clusters are consistent across all three dendrograms, this suggests robust biological structure in the data.

---

**Summary:**  
As you increase the number of genes, the main top-level clusters remain similar, but the membership of some samples at the cluster boundaries can change. Using more genes can provide finer resolution but may also introduce noise, so it’s important to balance the number of genes used with the biological question at hand.

## "Compare these results, describe how each clustering method works, and compare the results to PCA results obtained above."

For your RNA-seq data and the goal of comparing clustering results, I recommend the following three metrics/methods to compare against the default Euclidean/complete linkage:

1. **Ward.D2 (with Euclidean distance)**  
   - **Why:** Ward.D2 is widely used for gene expression data because it tends to produce compact, spherical clusters and is less sensitive to noise/outliers than single or complete linkage. It’s the default "ward" method in R and is generally preferred over the original "ward".
   - **How:** `hclust(dist(t(mat)), method = "ward.D2")`

2. **Average linkage (UPGMA, with Euclidean distance)**  
   - **Why:** Average linkage is a balanced method that considers the average distance between all pairs of samples in two clusters. It often gives more interpretable results than single or complete, especially for biological data.
   - **How:** `hclust(dist(t(mat)), method = "average")`

3. **Spearman correlation distance (with complete linkage)**  
   - **Why:** Spearman correlation is robust to non-normality and focuses on the rank order of gene expression, which is useful for RNA-seq data where absolute values can vary widely. Using complete linkage with this distance lets you see how clusters change when using a correlation-based metric.
   - **How:**  
     ```r
     d_spear <- as.dist(1 - cor(mat, method = "spearman"))
     hclust(d_spear, method = "complete")
     ```

---

**Summary Table:**

| Method/Metric         | Distance      | Linkage   | Rationale                                      |
|---------------------- |--------------|-----------|------------------------------------------------|
| Ward.D2               | Euclidean    | Ward.D2   | Compact, robust clusters for expression data    |
| Average linkage       | Euclidean    | Average   | Balanced, interpretable for biological data     |
| Spearman correlation  | 1 - Spearman | Complete  | Rank-based, robust to scale, RNA-seq friendly   |

---

These three will give you a good range of clustering behaviors and biological interpretability for your data.

---

Here’s a comparison and description of the four clustering methods, based on your dendrograms:

---

### **How Each Clustering Method Works**

1. **Euclidean + Complete Linkage**
   - **How it works:** Uses Euclidean distance between samples; at each step, merges clusters whose *most distant* members are closest (maximal inter-cluster distance).
   - **Effect:** Tends to produce compact, spherical clusters and is sensitive to outliers. Clusters are merged only if all members are relatively close.

2. **Euclidean + Ward.D2**
   - **How it works:** Uses Euclidean distance; merges clusters to minimize the total within-cluster variance (sum of squared differences).
   - **Effect:** Produces clusters of similar size and shape, often more balanced and less sensitive to outliers than complete linkage.

3. **Euclidean + Average Linkage (UPGMA)**
   - **How it works:** Uses Euclidean distance; merges clusters based on the *average* distance between all pairs of samples in the two clusters.
   - **Effect:** Produces clusters that are a compromise between single and complete linkage, less sensitive to outliers, and can handle clusters of different shapes.

4. **Spearman + Complete Linkage**
   - **How it works:** Uses 1 - Spearman correlation as a distance (focuses on rank similarity, not absolute values); merges clusters based on the maximum distance between members.
   - **Effect:** Groups samples with similar expression *patterns* (regardless of scale), robust to outliers and normalization issues.

---

### **Comparison to Euclidean + Complete**

- **Ward.D2:**  
  The overall structure is similar to complete linkage, but the clusters tend to be more balanced in size and less affected by outliers. The main splits may occur at slightly different heights, and some samples may shift between clusters, especially at the boundaries.

- **Average Linkage:**  
  This method often produces clusters that are less tight than complete linkage. You may notice that some clusters merge earlier (at lower heights), indicating that average linkage is more permissive in merging clusters that are moderately similar.

- **Spearman + Complete:**  
  The dendrogram structure is noticeably different. Since Spearman focuses on rank order, samples with similar expression trends (even if their absolute values differ) are grouped together. This can reveal biologically meaningful clusters that are not apparent with Euclidean distance, especially if there are global shifts in expression levels.

---

### **Which is Best?**

- **Euclidean + Complete** is a standard choice and works well for compact, well-separated clusters, but can be sensitive to outliers.
- **Ward.D2** is often preferred for gene expression data because it minimizes within-cluster variance and produces balanced clusters.
- **Average Linkage** is a good compromise but may not capture tight clusters as well as complete or Ward.D2.
- **Spearman + Complete** is best if you care about *patterns* of expression rather than absolute levels, and is robust to normalization and scaling issues.

**Based on your dendrograms and typical RNA-seq analysis:**
- **Ward.D2** is generally the best choice for most gene expression datasets, as it balances cluster compactness and robustness.
- **Spearman + Complete** is also excellent if you expect strong pattern-based grouping or want to reduce the influence of outliers and scaling.

**Recommendation:**  
**Ward.D2** is likely the best overall for your data, but if you are interested in clusters defined by similar expression trends (not absolute values), also consider **Spearman + Complete**.

---

**Summary Table:**

| Method                  | Best for...                              | Notes                                   |
|-------------------------|------------------------------------------|-----------------------------------------|
| Euclidean + Complete    | Compact, tight clusters                  | Sensitive to outliers                   |
| Euclidean + Ward.D2     | Balanced, robust clusters                | Often best for gene expression          |
| Euclidean + Average     | Moderate, less tight clusters            | Compromise, less sensitive to outliers  |
| Spearman + Complete     | Pattern-based, rank similarity clusters  | Robust to scaling, good for trends      |