WootGirl25: Please analyze the linked txt document. Please make a summary of these notes - the purpose of the summary notes will be to act as a quick refresher of things I have learnt from the full version, I want to be able to come back and read over the summary to revise what I have learnt this week. Highlight all key points in the learning materials and provide examples where appropiate.

GitHub Copilot: ### Summary Notes: Week 1 - Programming in R

#### **1. Overview**
- **R** is a widely used language/platform with a broad range of third-party libraries.
- **Purpose of this week**: Learn how to extend R using packages, work with datasets, and handle data import/export.

---

#### **2. Packages and Datasets in R**
- **Packages**: Bundles containing libraries, datasets, and documentation.
  - Installed once and can be loaded into any session.
  - Example: `library(limma)` loads the `limma` library.
- **Datasets**: Prepackaged data that can be loaded into R sessions.
  - Example: `data(ALL)` loads the `ALL` dataset.
- **Installing Packages**:
  - From CRAN: `install.packages("package_name")`.
  - From Bioconductor:
    ```r
    if (!require("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
    BiocManager::install("ALL")
    ```
- **Loading Data**:
  - Example:
    ```r
    library(ALL)
    data(ALL)
    ```

---

#### **3. Working with the ALL Dataset**
- **ALL Dataset**: Gene expression levels and clinical data for patients with acute lymphoblastic leukemia.
- **Accessing Data**:
  - `pData(ALL)`: Clinical information (data frame).
  - `exprs(ALL)`: Gene expression levels (matrix).
- **Examples**:
  ```r
  dim(pData(ALL))      # 128 patients, 21 clinical parameters
  colnames(pData(ALL)) # Lists column names of clinical data
  pData(ALL)[1:3, 1:5] # View first 3 rows and 5 columns of clinical data
  ```

---

#### **4. Loading and Saving Data**
- **Working Directory**:
  - `getwd()`: Prints the current working directory.
  - `setwd("path")`: Changes the working directory.
- **Exporting Data**:
  - Example:
    ```r
    write.table(pData(ALL)[1:5, 1:5], "ALLtmp.txt", quote = FALSE, sep = "\t", col.names = TRUE, row.names = FALSE)
    ```
    - Writes the first 5 rows and columns of clinical data to a tab-separated file.
- **Importing Data**:
  - Example:
    ```r
    all.tmp <- read.table("ALLtmp.txt", sep = "\t", header = TRUE)
    ```
    - Reads the exported file back into R as a data frame.

---

#### **5. Data Types and Conversions**
- **Column Data Types**:
  - Use `sapply()` to check column types:
    ```r
    sapply(all.tmp, class)
    ```
- **Default Behavior**:
  - `read.table()` converts character columns to factors by default.
  - To prevent this, use `as.is = TRUE` or specify `colClasses`:
    ```r
    all.tmp <- read.table("ALLtmp.txt", sep = "\t", header = TRUE, as.is = TRUE)
    ```
    OR
    ```r
    all.tmp <- read.table("ALLtmp.txt", sep = "\t", header = TRUE, colClasses = c("character", "character", "factor", "integer", "factor"))
    ```
- **Manual Conversion**:
  - Example:
    ```r
    all.tmp$diagnosis <- as.character(all.tmp$diagnosis)
    ```

---

#### **6. Useful Functions**
- **`apply()` Family**:
  - `lapply()`: Applies a function to each element of a list.
  - `sapply()`: Similar to `lapply()` but returns a vector/matrix.
  - Example:
    ```r
    unlist(lapply(pData(ALL)[, 1:5], class)) # Check column types
    ```
- **`table()`**:
  - Counts occurrences of unique values in a vector.
  - Example:
    ```r
    table(pData(ALL)$sex) # Counts male and female patients
    ```

---

#### **7. Key Takeaways**
- **Packages**: Extend R's functionality and provide datasets.
- **Datasets**: Prepackaged data like `ALL` can be loaded and explored.
- **Data Import/Export**: Use `write.table()` and `read.table()` for flat files.
- **Data Types**: Be cautious of automatic type conversions (e.g., characters to factors).
- **Exploration**: Always inspect data after loading to ensure correctness.

---

#### **Examples for Practice**
1. **Export and Import Data**:
   ```r
   write.table(pData(ALL)[1:5, 1:5], "example.txt", sep = "\t", quote = FALSE, col.names = TRUE, row.names = FALSE)
   imported_data <- read.table("example.txt", sep = "\t", header = TRUE)
   ```
2. **Check Column Types**:
   ```r
   sapply(imported_data, class)
   ```
3. **Count Unique Values**:
   ```r
   table(pData(ALL)$BT)
   ```

This summary provides a quick refresher on the key concepts and examples from the full notes.