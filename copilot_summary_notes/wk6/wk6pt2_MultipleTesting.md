Of course! Let’s break this down step by step.

### **What is the Bonferroni Correction?**
The Bonferroni correction is a statistical method used to prevent too many false positives when performing multiple tests. Normally, when we run a single test at a **p-value** threshold of 0.05 (or 5%), there is a 5% chance that we’ll incorrectly reject the null hypothesis—this is called a **Type I Error** (False Positive Rate, or FPR).

Now, imagine running **many** tests (N tests). If we set the p-value cutoff to 0.05 for each test, we might accumulate too many false positives, simply because we're testing so many things. That’s where the Bonferroni correction comes in—it **adjusts the p-value** to compensate for multiple comparisons.

### **How Does the Correction Work?**
- Instead of keeping the p-value at **0.05** for each test, Bonferroni correction **divides it** by the number of tests (N).
- The new adjusted threshold becomes:  
  \[
  p_{\text{corrected}} = \frac{0.05}{N}
  \]
  This means that if we perform **10,000** tests, our corrected p-value would be:
  \[
  0.05 / 10,000 = 0.000005
  \]
  So now, a test result must have a p-value lower than **0.000005** to be considered statistically significant.

### **Why Do We Use It?**
- When we conduct a lot of tests (like in **genetic studies** where we analyze thousands of genes), the risk of false positives increases.
- Bonferroni correction ensures that we maintain a **low chance** of making at least one false discovery across all tests, rather than just looking at individual tests separately.

### **Limitations**
- It is **very conservative**—sometimes **too** conservative!  
  - It reduces false positives but **can also eliminate true positives** (real effects that should be detected).
  - For example, in the dataset example from your notes, only **11 out of 12,625 genes** met the Bonferroni-adjusted threshold, and most were related to the Y chromosome (which isn’t that interesting for studying male/female disease differences).
  - Some real differences (e.g., subtle but meaningful differences in gene expression) **might be missed** because of how strict the correction is.

### **What’s Next?**
Since Bonferroni correction can be overly strict, researchers sometimes prefer **other methods** for controlling false discoveries, like:
- **False Discovery Rate (FDR) correction**, which is less extreme and allows for some false positives in exchange for detecting more true effects.



### **Measures of Prediction Quality**
When we perform tests, we can make **two types of errors**:
1. **False Positives (Type I Error)** – We incorrectly reject the null hypothesis when it is actually true.
   - Example: A medical test incorrectly diagnoses a healthy person as having a disease.
   
2. **False Negatives (Type II Error)** – We incorrectly **accept** the null hypothesis when it is actually false.
   - Example: A test fails to detect a disease in a person who actually has it.

But beyond just false positives and false negatives, there are **other metrics** that help us evaluate how good a test is. These metrics depend on **True Positives (TP), False Positives (FP), False Negatives (FN), and True Negatives (TN).** Let’s go through them:

### **Key Metrics**
| Metric | Formula | Meaning |
|--------|---------|---------|
| **Negative Predictive Value (NPV)** | `TN / (TN + FN)` | How reliable a negative test result is. A **low** NPV means we are **missing a lot of true events** and misclassifying them as negatives (false negatives). |
| **Positive Predictive Value (PPV)** | `TP / (TP + FP)` | How reliable a positive test result is. A **low** PPV means we are **too eager to reject the null hypothesis**, leading to **too many false positives**. |
| **False Discovery Rate (FDR)** | `FP / (TP + FP)` | The percentage of false positives among all positive test results. A **high FDR means many results are false alarms**. |
| **Sensitivity (True Positive Rate, TPR)** | `TP / (TP + FN)` | How good the test is at **detecting true cases** (positive events). A **low sensitivity** means the test **misses** many cases. |
| **Specificity (True Negative Rate, TNR)** | `TN / (TN + FP)` | How good the test is at **identifying true negatives** (non-events). A **low specificity** means the test **produces many false positives** (detects things that aren’t there). |

### **Example Scenario**
Imagine we are testing for a disease in a population of **2,030 people**, where:
- **30 people actually have the disease** (P = 30)
- **2,000 people do not have the disease** (N = 2,000)
- Our test is applied to everyone.

Now, depending on how well our test works, we will get **true positives (correct diagnoses)** and **false positives (incorrect diagnoses)**. Some trade-offs include:
- If **specificity is low**, **many healthy people** may be falsely diagnosed.
- If **sensitivity is low**, **many sick people** may not be detected.
- If **False Discovery Rate (FDR) is high**, **most of the positive test results may actually be wrong**—imagine a disease test where **90% of positive results** are actually **healthy people**!

### **Why Does This Matter?**
Different tests prioritize different metrics **depending on the real-world consequences**:
- In **medicine**, missing a **true positive** (false negative) could be life-threatening—so **high sensitivity is crucial**.
- In **scientific research**, too many **false positives** could lead to misleading conclusions—so **low FDR is important**.

In exploratory analysis (such as studying gender-related differences in gene expression), we usually care more about **controlling for False Discovery Rate (FDR)**—we don’t want too many false alarms!


## FDR Evaluation
Sure! Let's break this down into simpler terms so you can better understand both the **concept** and the **code**.

---

### **What is FDR (False Discovery Rate)?**
FDR helps us control how many of the **significant** results in a study are actually **false positives**. In real-world scenarios (like genetics), we often test thousands of hypotheses at once, and we **expect** that some will be falsely deemed significant. Instead of preventing **any** false positives (which can be too restrictive), FDR allows us to **minimize** them while still detecting real effects.

To understand FDR, the example in your notes simulates a **hypothetical dataset** where we already **know the truth** and can compare it to the statistical results.

---

### **Breaking Down the Dataset**
We create a dataset with **400 genes**, each measured in **two conditions**:
- **Healthy Controls (group 1)**
- **Diseased Subjects (group 2)**

For each gene, we record **10 measurements** from each group.

#### **Two types of genes in the simulation**
1. **200 genes show NO real difference** between healthy and diseased subjects.
   - We model this by randomly drawing values from **the same normal distribution** (mean = 0, sd = 1) for both conditions.
   - Some differences might appear due to random chance.

2. **200 genes DO show a real difference** between healthy and diseased subjects.
   - Healthy samples are still drawn from **a normal distribution with mean = 0**.
   - Diseased samples are drawn from **a normal distribution with mean = 1** (showing higher expression).
   - This simulates genes where there’s **actually a biological change in expression**.

---

### **How Does the Code Work?**
Let’s go through each part step by step.

#### **Step 1: Create empty vectors to store p-values**
```r
pvals.200.same <- numeric()
pvals.200.diff <- numeric()
```
- These will store p-values for **200 genes that don't change** (`pvals.200.same`) and **200 genes that do change** (`pvals.200.diff`).

#### **Step 2: Generate data and run t-tests**
```r
for (i in 1:200) {
    x <- rnorm(10)
    y <- rnorm(10)  # x/y: measurements for unchanged genes
    w <- rnorm(10)  # w/z: measurements for changed genes
    z <- rnorm(10, mean=1)  # Diseased group has shifted mean

    pvals.200.same[i] <- t.test(x,y)$p.value  # Store p-value for unchanged genes
    pvals.200.diff[i] <- t.test(w,z)$p.value  # Store p-value for changed genes
}
```
- **Loop runs 200 times** (simulating 200 genes).
- It generates **10 random measurements** for healthy and diseased subjects.
- Then, it runs a **t-test** to compare the groups and **stores the p-value**.

#### **Step 3: Visualizing the Results**
```r
oldpar <- par(mfrow=c(3,1))
hist(pvals.200.same, breaks=20, xlim=c(0,1))
hist(pvals.200.diff, breaks=20, xlim=c(0,1))
hist(c(pvals.200.same, pvals.200.diff), breaks=20, xlim=c(0,1))
```
- **Creates 3 histograms** to show the distribution of p-values:
  1. **First Histogram** – p-values for genes with **no real difference**.
  2. **Second Histogram** – p-values for genes **with a real difference**.
  3. **Third Histogram** – Combined distribution of p-values.

---

### **What Does This Show?**
- **For unchanged genes**, the p-values should be **uniformly distributed** (some results might appear significant just by chance).
- **For changed genes**, the p-values should cluster **towards lower values**, indicating real differences.
- This demonstrates the challenge: How do we separate **real discoveries** from **random false positives**? That’s where **FDR methods** come in!

---
### **Breaking Down FDR Estimation**
In real experiments, we **do not know the truth**—meaning we don't have a clean separation between true positives and false positives. We only see the **mixed distribution of p-values**, which contains **both real and false discoveries**. The challenge is figuring out how many **false positives** are among our significant findings.

---

### **Key Idea: How FDR Depends on the P-value Cutoff**
- If we **set the p-value cutoff too high** (e.g., 1), **all genes will pass**, including both true and false positives.  
  - We **know** that half of our genes have **no real difference**, so **50% of our "significant" findings are false positives** (FDR = 0.5).
- **If we lower the p-value cutoff**, we start filtering out more false positives, enriching our selection with **more true positives**.

FDR, often called **q-value**, is the fraction of false discoveries among our selected findings.

---

### **Understanding the Code**
### **How the Loop Works**
You have this sequence:
```r
pval.cutoff <- seq(0,1,by=0.05)
```
- This creates a list of cutoff values starting at **0**, increasing by **0.05** each step, until reaching **1**.
- These values represent possible thresholds for determining **which genes are considered significant** based on their p-values.

Now, for **each value in `pval.cutoff`**, we count:
1. **False positives (`n.same`)**—Genes that exhibit **no real difference** but have a p-value below that cutoff.
2. **True positives (`n.diff`)**—Genes that **do have a real difference** but still fall below the cutoff.

This is done using:
```r
n.same <- sapply(pval.cutoff,function(x) sum(pvals.200.same<x))
n.diff <- sapply(pval.cutoff,function(x) sum(pvals.200.diff<x))
```
- `sapply()` applies the function **to each value in `pval.cutoff`**.
- `sum(pvals.200.same<x)` counts **how many false positive genes** fall below the current cutoff. (as we are summing the result from logical expression > leads to True False values, count the True)
- `sum(pvals.200.diff<x)` counts **how many true positive genes** fall below the current cutoff.

### **Computing the False Discovery Rate (FDR)**
```r
qval <- n.same / (n.same + n.diff)
```
- This calculates the **FDR (False Discovery Rate)** for **each cutoff value**.
- It divides **the number of false positives** by **the total number of significant genes** (false + true positives).

### **Visualizing the Trends**
```r
plot(pval.cutoff, n.same, pch=19, type='b', xlab="P-value cutoff", ylab="# false positives")
plot(pval.cutoff, n.diff, pch=19, type='b', xlab="P-value cutoff", ylab="# true positives")
plot(pval.cutoff, qval, pch=19, type='b', xlab="P-value cutoff", ylab="Q-value")
```
- **First plot**: Shows how the number of **false positives** changes as we adjust the p-value cutoff.
- **Second plot**: Shows how the number of **true positives** changes.
- **Third plot**: Displays the **FDR trend**, revealing the trade-off between keeping sensitivity **vs. minimizing false positives**.

### **How It All Comes Together**
The whole process **evaluates different possible p-value cutoffs** so we can choose an **optimal threshold**—one that:
- **Includes enough true positives** to be meaningful.
- **Keeps false positives low** enough to avoid misleading results.

Let me know if you need more clarification on any part! 😊

---

### **Interpreting the Results**
- **At very low p-value cutoffs**, FDR is low (we mostly select true findings).  
- **As cutoff increases**, we include more false positives, **raising FDR**.  
- This shows **a tradeoff**: higher sensitivity comes **at the cost of increasing false positives**.

Great question! Let’s break this down into clear sections.

### **1. What Does “We Know the Truth” Mean?**
Since this is a **simulated dataset**, we already **know** which genes have a **real difference** between the conditions and which do not. This allows us to **track** how well our statistical tests perform—something we couldn’t do in a real experiment, where we don’t know in advance which findings are true or false.

---

### **2. Why Are We Studying FDR at Different P-value Cutoffs?**
The goal is to **understand how False Discovery Rate (FDR) changes** as we adjust the p-value cutoff.  
- **A high p-value cutoff** lets **everything** through—including both true findings and false positives.
- **A lower p-value cutoff** filters out more false positives but might also remove some true positives.

We’re testing a **range** of p-value cutoffs (from `0 to 1`) to see the **full picture** of how FDR behaves.

---

### **3. How Are False Positives and True Positives Counted?**
For **each p-value cutoff**, we:
- Count how many **false positives** are below the cutoff (`n.same` → genes with no real difference but low p-values).
- Count how many **true positives** are below the cutoff (`n.diff` → genes with a real difference and low p-values).

These counts are visualized in the **top two plots**:
1. **False positives grow linearly** because p-values for these genes follow a **uniform distribution**—meaning they increase steadily as we raise the cutoff.
2. **True positives grow rapidly at lower p-values** because their distribution clusters toward smaller values (this creates the "cusp" in the histogram).

---

### **4. Understanding the FDR (Q-value) Curve**
The **bottom plot** shows FDR:
- **At very low p-value cutoffs**, FDR is **low** because we mostly select **true positives**.
- **As cutoff increases, FDR rises** because we start including more false positives.
- **At p-value = 1**, everything is selected, so FDR is **50%** (since we know half of the dataset is false positives).

This tradeoff illustrates **sensitivity vs. FDR**:
- **Higher sensitivity** (detecting more real effects) comes at the **cost of increasing false positives**.
- We want to **balance** these factors to find the **best** p-value cutoff.

---

### **5. The Importance of the Dataset and Test Choice**
- The **exact shape of the FDR curve** depends on the dataset (how much noise exists, how strong the real effects are).
- **A more powerful test** might detect more **true cases** while keeping FDR lower.

---

### **6. Why Is Q-value a Property of a Selected Set?**
- FDR (or q-value) only makes sense **after selecting a set of genes**.
- **We used p-value cutoffs** to define significant genes, but we **could have chosen another method** (like filtering by genes with a **two-fold change in expression**).

Different selection methods can **produce different FDR values**, which is why the way we filter our data matters.

---

### **Final Thoughts**
This section explains how adjusting **p-value cutoffs** impacts the **balance between sensitivity and false discoveries**. The key takeaway?  
- **A very strict cutoff misses real effects** (low sensitivity).  
- **A loose cutoff includes many false positives** (high FDR).  
- **Finding the optimal cutoff** depends on **the dataset and the research goals**.

### **Breaking Down Q-value Calculation**
In practice, **q-values** (False Discovery Rate estimates) are reported **for each individual p-value in the dataset**—meaning each gene has a corresponding q-value. The key idea is:

- **A gene with p-value = p has a q-value** that tells us the **FDR** we would have **if we selected all genes with p-values up to p**.
- This allows researchers to choose a **desired FDR threshold** and select genes accordingly.

---

### **Understanding the Code**
This code takes the **actual p-values** from the t-test and uses them as cutoff values to compute q-values.

#### **Step 1: Define P-value Cutoffs**
```r
pval.cutoff <- c(pvals.200.same, pvals.200.diff)
```
- Instead of **creating an external sequence of cutoff values** (like before), this time we **use the actual p-values** as cutoffs.
- This means each **p-value from a gene becomes a threshold** to compute FDR.

#### **Step 2: Count False Positives & True Positives**
```r
n.same <- sapply(pval.cutoff, function(x) sum(pvals.200.same<x))
n.diff <- sapply(pval.cutoff, function(x) sum(pvals.200.diff<x))
```
- For each **p-value cutoff**, count:
  - **False positives (`n.same`)** → genes with **no true effect**, but p-values below the cutoff.
  - **True positives (`n.diff`)** → genes **with real effect**, and p-values below the cutoff.

#### **Step 3: Compute Q-values**
```r
qval <- n.same / (n.same + n.diff)
```
- The **q-value for each p-value** is calculated using:
  \[
  q = \frac{\text{False Positives}}{\text{Total Selected Genes (False + True Positives)}}
  \]
- This tells us the **percentage of false discoveries** among selected genes.

#### **Step 4: Plot Q-values**
```r
plot(pval.cutoff, qval, xlab="t-test p-value", ylab="q-value",
     cex.axis=1.7, cex.lab=1.7, cex=0.8)
```
- This graph shows **how q-value changes** across different p-values.
- Every point represents **an actual gene**, making the representation **more practical**.


### **Interpreting the Q-value Plot**
- We can **select genes with p-values up to ~0.2** while keeping **FDR at 20%**.
- This allows **flexibility** in choosing an FDR threshold **based on the dataset and study goals**.

