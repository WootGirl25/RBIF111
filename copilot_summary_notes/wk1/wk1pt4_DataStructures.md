WootGirl25: test

GitHub Copilot: ### Summary Notes: Vectors in R

#### Key Concepts:
1. **Everything is a Vector**:
   - In R, all data is represented as vectors, even single values (scalars).
   - A vector is an ordered set of data of the same type.
   - Order is preserved unless explicitly changed.

2. **Order Matters**:
   - The order of elements in a vector is fixed and important.
   - This ensures data alignment across multiple vectors (e.g., patient names and their respective measurements).

3. **Single Values as Vectors**:
   - A single value in R is treated as a vector of length 1.
   - Output always starts with `[1]`, even for single values.

4. **Vector Length**:
   - Vectors can have any length, including zero.
   - Length can be queried using the `length()` function.

5. **Vector Creation**:
   - **Ranges**: `2:6` creates a sequence from 2 to 6.
   - **Sequences**: `seq(from, to, by=step)` generates sequences with specified steps.
   - **Concatenation**: `c()` combines multiple vectors into one.

6. **Type Consistency**:
   - All elements in a vector must have the same type (mode).
   - R automatically promotes types to the most general mode (e.g., integers to floating-point numbers).

7. **Variable Naming**:
   - Dots (`.`) are allowed in variable names (e.g., `x.y`), but they do not imply object-oriented behavior.

8. **Functions Returning Vectors**:
   - Many R functions return vectors (e.g., `rnorm(5)` generates a vector of 5 random numbers from a normal distribution).

9. **Special Values**:
   - `NA`: Represents missing data, has a length of 1.
   - `NULL`: Represents "nothing," has a length of 0.
   - Concatenating `NULL` drops it, while `NA` is retained in the resulting vector.

#### Examples:
1. **Range and Sequence**:
   ```r
   y <- 2:6; y  # Shortcut for seq(2, 6, by=1)
   ## [1] 2 3 4 5 6

   z <- seq(1, 1.4, by=0.1); z
   ## [1] 1.0 1.1 1.2 1.3 1.4
   ```

2. **Concatenation**:
   ```r
   x <- c(5.2, 1.7, 6.3); x
   ## [1] 5.2 1.7 6.3

   x.y <- c(x, y); x.y
   ## [1] 5.2 1.7 6.3 2.0 3.0 4.0 5.0 6.0
   ```

3. **Length Queries**:
   ```r
   length(y); length(1); length(NA); length(NULL)
   ## [1] 5
   ## [1] 1
   ## [1] 1
   ## [1] 0
   ```

4. **Special Values**:
   ```r
   c(NULL, NULL, 1, 2, NA)
   ## [1] 1 2 NA
   ```

### Summary: Accessing Vector Elements in R

#### **Key Concepts**

1. **Basic Access with Square Brackets (`[]`)**:
   - Use numeric indices to access elements.
   - Indexing starts at **1** (unlike many other languages where it starts at 0).
   - Example:
     ```R
     clrs <- c("red", "blue", "gray", "pink", "cyan")
     clrs[1]  # Access the first element
     ## [1] "red"
     ```

2. **Accessing Subsets**:
   - Use a range or a vector of indices to access multiple elements.
   - Example:
     ```R
     clrs[2:4]  # Access elements 2 to 4
     ## [1] "blue" "gray" "pink"
     clrs[c(1, 3, 5)]  # Access specific elements
     ## [1] "red"  "gray" "cyan"
     ```

3. **Negative Indices**:
   - Exclude elements by using negative indices.
   - Example:
     ```R
     clrs[c(-2, -3)]  # Exclude elements 2 and 3
     ## [1] "red"  "pink" "cyan"
     ```

4. **Out-of-Bounds and Empty Indexing**:
   - Out-of-bounds indices return `NA`.
   - Empty indices return an empty vector.
   - Example:
     ```R
     clrs[6]  # Out of bounds
     ## [1] NA
     clrs[integer(0)]  # Empty index
     ## character(0)
     ```

5. **Named Elements**:
   - Assign names to vector elements and access them by name.
   - Example:
     ```R
     names(clrs) <- c("red", "blue", "gray", "pink", "cyan")
     clrs["blue"]  # Access by name
     ## [1] "blue"
     ```

6. **Logical Indexing**:
   - Use logical vectors (`TRUE`/`FALSE`) to select elements.
   - Example:
     ```R
     clrs[c(TRUE, FALSE, FALSE, TRUE, FALSE)]  # Select elements at TRUE positions
     ## [1] "red"  "pink"
     ```

7. **Recycling**:
   - If the logical indexing vector is shorter than the source vector, it is recycled.
   - Example:
     ```R
     clrs[c(TRUE, FALSE)]  # Recycled logical vector
     ## [1] "red"  "gray" "cyan"
     ```

8. **Filtering with Logical Conditions**:
   - Use logical conditions to filter elements.
   - Example:
     ```R
     x <- c(12, -3, 7, -5, 6)
     x[x > 0]  # Select positive elements
     ## [1] 12  7  6
     ```

9. **Double Brackets (`[[]]`)**:
   - Used for accessing a single element (not subsets).
   - Example:
     ```R
     clrs[[2]]  # Access the second element
     ## [1] "blue"
     ```

#### **Important Notes**
- **NA Handling**: Missing values (`NA`) are returned for out-of-bounds indices or when the indexing vector contains `NA`.
- **Logical Indexing**: Logical vectors can include `NA`, which propagates into the result.
- **Recycling**: Be cautious with recycling as it may lead to unintended results.
- **Double Brackets**: Primarily useful for lists and data frames, not vectors.

#### **Examples for Practice**
1. Access the third and fifth elements of a vector:
   ```R
   clrs[c(3, 5)]
   ```

2. Exclude the first element:
   ```R
   clrs[-1]
   ```

3. Select elements greater than 0 from a numeric vector:
   ```R
   x <- c(-2, 4, 0, 7, -5)
   x[x > 0]
   ```

### Summary: Assigning Vector Elements and Vector Operations in R

#### **Key Concepts**

1. **Assigning Vector Elements**:
   - Use indexing on the **left-hand side** of an assignment to modify elements in-place.
   - Right-hand side values are assigned element by element, with **recycling** if needed.
   - Example:
     ```R
     clrs <- c("red", "blue", "gray", "pink", "cyan")
     clrs[c(1, 3)] <- c("scarlet", "black")  # Modify elements 1 and 3
     ## [1] "scarlet" "blue" "black" "pink" "cyan"
     ```

2. **Logical Indexing for Assignment**:
   - Use logical conditions to select elements for assignment.
   - Example:
     ```R
     x <- c(3:8, NA)
     x[x > 5] <- -1  # Assign -1 to elements greater than 5
     ## [1]  3  4  5 -1 -1 -1 NA
     ```

3. **Vectorized Operations**:
   - Arithmetic and logical operations are applied **element by element**.
   - Example:
     ```R
     x <- c(3:8, NA)
     x + 1:4  # Adds 1, 2, 3, 4 to x with recycling
     ## [1]  4  6  8 10  8 10 NA
     exp(x)  # Applies exponential function to each element
     ## [1]   20.08554   54.59815  148.41316  403.42879 1096.63316 2980.95799 NA
     ```

4. **Common Vector Functions**:
   - **Comparison and Logical Functions**:
     - `any()`: Checks if **any** element meets a condition.
     - `all()`: Checks if **all** elements meet a condition.
     - Example:
       ```R
       xx <- c(-2:2, NA)
       any(xx > 0)  # Is any element > 0?
       ## [1] TRUE
       all(xx > 0)  # Are all elements > 0?
       ## [1] FALSE
       ```

   - **Membership and Matching**:
     - `is.element(v1, v2)`: Checks if elements of `v1` exist in `v2`.
     - `match(v1, v2)`: Returns positions of `v1` elements in `v2`.
     - Example:
       ```R
       is.element(0, xx)  # Is 0 in xx?
       ## [1] TRUE
       match(c(0, -2, 10), xx)  # Positions of 0, -2, and 10 in xx
       ## [1]  3  1 NA
       ```

   - **Sorting and Ordering**:
     - `sort()`: Sorts a vector.
     - `order()`: Returns indices for sorting.
     - Example:
       ```R
       yy <- c(3, -3, 5, -5, 4, 4)
       sort(yy)  # Sort in ascending order
       ## [1] -5 -3  3  4  4  5
       rev(sort(yy)) # revery the order of the arguement
       ## [1]  5  4  4  3 -3 -5
       order(yy) # returns indices of the arguement in the order that would sort the vector (-5 is the 4th index, -3 is 2nd, etc.)
       ## [1] 4 2 1 5 6 3
       yy[order(yy)]  # Sort using indices (provides same output as using sort)
       ## [1] -5 -3  3  4  4  5
       ```

5. **Logical Operations**:
   - Use `&` (AND) and `|` (OR) for element-wise logical operations.
   - Example:
     ```R
     xx <- c(-2:2, NA)
     (xx > -1) & (xx < 2)  # Logical AND
     ## [1] FALSE FALSE TRUE TRUE FALSE NA
     xx[(xx > -1) & (xx < 2)]  # Filter elements
     ## [1]  0  1 NA
     ```

6. **Handling Missing Values (`NA`)**:
   - Many functions handle `NA` intuitively:
     - `sum(xx > 0, na.rm = TRUE)`: Ignores `NA` when summing.
     - Example:
       ```R
       sum(xx > 0, na.rm = TRUE)  # Count positive elements, ignoring NA
       ## [1] 2
       ```

7. **Recycling**:
   - Shorter vectors are **recycled** to match the length of longer vectors.
   - Example:
     ```R
     x <- c(3:8, NA)
     x + 1:4  # Recycles 1:4
     ## [1]  4  6  8 10  8 10 NA
     ```

#### **Important Notes**
- **Recycling Warnings**: Warnings are issued if the longer vector's length is not a multiple of the shorter vector's length.
- **Function Behavior**: Always check documentation for functions, as behavior may vary (e.g., `is.element()` ignores `NA`).

#### **Examples for Practice**
1. Modify specific elements of a vector:
   ```R
   clrs <- c("red", "blue", "gray", "pink", "cyan")
   clrs[c(2, 4)] <- c("navy", "rose")
   ```

2. Filter elements using logical conditions:
   ```R
   xx <- c(-2:2, NA)
   xx[xx > 0]
   ```

3. Sort a vector in descending order:
   ```R
   yy <- c(3, -3, 5, -5, 4, 4)
   sort(yy, decreasing = TRUE)
   ```

### Summary: Matrices in R

#### **Key Concepts**

1. **Definition of a Matrix**:
   - A matrix is a **two-dimensional table** of data where all elements must be of the same type (numeric, character, logical, etc.).
   - Created using the `matrix()` function:
     ```R
     m <- matrix(1:12, nrow = 4, byrow = TRUE)
     ##      [,1] [,2] [,3]
     ## [1,]    1    2    3
     ## [2,]    4    5    6
     ## [3,]    7    8    9
     ## [4,]   10   11   12
     ```

2. **Matrix Creation Parameters**:
   - **Data**: A vector of values to fill the matrix.
   - **Dimensions**:
     - `nrow`: Number of rows.
     - `ncol`: Number of columns.
   - **Filling Order**:
     - `byrow = TRUE`: Fill by rows.
     - `byrow = FALSE` (default): Fill by columns.

3. **Matrix-Vector Dualism**:
   - Matrices are stored internally as **vectors** (column-major order - meaning c(1:3) = a single column whose rows would be 1, 2,3).
   - Operations between matrices and vectors are allowed, with **recycling** if needed.
   - Example:
     ```R
     y <- -1:2
     m.new <- m + y  # Adds y to each column of m, recycling y at each column
     ```

4. **Accessing Matrix Elements**:
   - Use two indices separated by a comma: `matrix[row, column]`.
   - Leave an index blank to select all rows or columns:
     ```R
     m[, 2]       # Select all rows, column 2
     m[1, ]       # Select row 1, all columns
     m[c(1, 3), ] # Select rows 1 and 3, all columns
     ```

5. **Subsetting and Excluding**:
   - Use negative indices to exclude rows or columns:
     ```R
     m[-c(1, 3), ]       # Exclude rows 1 and 3
     m[-c(2, 4), -c(2)]  # Exclude rows 2, 4 and column 2
     ```

6. **Matrix Operations**:
   - **Transpose**: Switch rows and columns using `t()`:
     ```R
     t(m)
     ```
   - **Dimensions**: Use `dim()` to get the number of rows and columns.
   - **Length**: Returns the total number of elements in the matrix.

7. **Naming Rows and Columns**:
   - Assign names to rows and columns using `rownames()` and `colnames()`:
     ```R
     rownames(m) <- c('a', 'b', 'c', 'd')
     colnames(m) <- c('x', 'y', 'z')
     ```

8. **Matrix Indexing Rules**:
   - Selection always operates on a **rectangular grid**.
   - Example:
     ```R
     m[c(1, 3), c(2, 3)]  # Select rows 1, 3 and columns 2, 3
     ```

#### **Important Notes**
- **Matrix-Vector Operations**: Be cautious when mixing matrices and vectors, as R may silently treat matrices as vectors.
- **Recycling**: Shorter vectors are recycled to match the matrix dimensions during operations.

#### **Examples for Practice**
1. Create a 3x4 matrix filled by rows:
   ```R
   m <- matrix(1:12, nrow = 3, byrow = TRUE)
   ```

2. Select specific rows and columns:
   ```R
   m[c(1, 3), c(2, 4)]  # Rows 1, 3 and columns 2, 4
   ```

3. Exclude rows and columns:
   ```R
   m[-c(2), -c(3)]  # Exclude row 2 and column 3
   ```

4. Assign names to rows and columns:
   ```R
   rownames(m) <- c('row1', 'row2', 'row3')
   colnames(m) <- c('col1', 'col2', 'col3', 'col4')
   ```

### Summary: Lists and Data Frames in R

---

### **6. Lists**

#### **Key Concepts**
1. **Definition**:
   - A **list** is a container for **heterogeneous data** (different types of objects like vectors, matrices, data frames, or even other lists).
   - Lists can have an arbitrary number of elements.

2. **Creating Lists**:
   - Use `list()` to create a list:
     ```R
     a <- list()
     a[[1]] <- "first element"
     a[[2]] <- 2
     a[[5]] <- 1:3  # Auto-expands, uninitialized elements are set to NULL
     ```

3. **Accessing List Elements**:
   - **Single Brackets (`[]`)**: Returns a **sublist** (still a list).
     ```R
     a[2]  # Returns a list containing the second element
     ```
   - **Double Brackets (`[[]]`)**: Extracts the **content** of a single element.
     ```R
     a[[2]]  # Returns the actual value of the second element
     ```
   - **Dollar Sign (`$`)**: Access elements by name (convenience operator).
     ```R
     b <- list(name = "John", age = 30)
     b$name  # Returns "John"
     ```

4. **Named Lists**:
   - Elements can be named during creation:
     ```R
     b <- list(name = "John", age = 30, scores = c(90, 85, 88))
     ```
   - Access by name:
     ```R
     b[["name"]]  # Returns "John"
     b$name       # Returns "John"
     ```

5. **Key Differences Between `[]` and `[[]]`**:
   - `[]`: Returns a **list** (can select multiple elements).
   - `[[]]`: Returns the **content** of a single element (cannot select multiple elements).

6. **Partial Matching**:
   - `$` allows partial matching of names:
     ```R
     b$na  # Matches "name" if no other name starts with "na"
     ```

---

### **7. Data Frames**

#### **Key Concepts**
1. **Definition**:
   - A **data frame** is a **rectangular table** where:
     - Each column is a vector (can have different types: numeric, character, etc.).
     - All columns must have the same length.

2. **Creating Data Frames**:
   - Use `data.frame()` to create a data frame:
     ```R
     m2 <- data.frame(age = c(23, 43, 32), sex = c("M", "F", "M"))
     ```

3. **Accessing Data Frame Elements**:
   - **Matrix-like Access**:
     ```R
     m2[1:2, ]  # Select rows 1 and 2, all columns
     m2[, 1]    # Select all rows, column 1 (returns a vector)
     ```
   - **List-like Access**:
     ```R
     m2$age      # Access column "age" as a vector
     m2[["age"]] # Same as above
     ```

4. **Adding Columns**:
   - Add new columns dynamically:
     ```R
     m2$new_col <- c(TRUE, FALSE, TRUE)
     ```

5. **Key Properties**:
   - **Class**: `"data.frame"`
   - **Mode**: `"list"` (data frames are lists of column vectors).
   - **Preserves Data Types**: Columns retain their original types (e.g., numeric, character).

6. **Functions for Data Frames**:
   - `dim()`: Returns dimensions (rows, columns).
   - `length()`: Returns the number of columns.
   - `attach()`: Promotes columns to variables in the workspace.
     ```R
     attach(m2)
     age  # Access column "age" directly
     ```

7. **Differences Between Data Frames and Matrices**:
   - **Data Frames**:
     - Can store heterogeneous data types.
     - Columns are named and accessed like lists.
   - **Matrices**:
     - Homogeneous data types (all elements must be the same type).

---

### **Examples for Practice**

#### **Lists**:
1. Create a list with mixed data types:
   ```R
   my_list <- list(name = "Alice", age = 25, scores = c(90, 85, 88))
   ```

2. Access elements:
   ```R
   my_list$name       # Access by name
   my_list[[2]]       # Access by position
   my_list[1:2]       # Sublist with first two elements
   ```

#### **Data Frames**:
1. Create a data frame:
   ```R
   df <- data.frame(id = 1:3, name = c("A", "B", "C"), score = c(85, 90, 88))
   ```

2. Access rows and columns:
   ```R
   df[1, ]       # First row
   df[, "score"] # Column "score"
   df$score      # Same as above
   ```

3. Add a new column:
   ```R
   df$passed <- c(TRUE, TRUE, FALSE)
   ```

### Summary: Factors in R

---

### **Key Concepts**

1. **Definition**:
   - A **factor** is a special data type in R used to represent **categorical variables**.
   - Factors store **discrete, finite, and fixed sets of values** called **levels**.

2. **Creating Factors**:
   - Use `as.factor()` to convert a vector into a factor:
     ```R
     s <- c("M", "F", "M")
     f <- as.factor(s)
     ## [1] M F M
     ## Levels: F M
     ```

3. **Levels**:
   - Factors store the **unique values** in the data as levels.
   - Use `levels()` to view the levels:
     ```R
     levels(f)
     ## [1] "F" "M"
     ```

4. **Internal Representation**:
   - Factors are stored internally as integers corresponding to their levels:
     ```R
     as.numeric(f)  # Converts factor to its internal numeric representation
     ## [1] 2 1 2
     ```

5. **Ordered Factors**:
   - Factors can be **ordered** (e.g., "High school" < "College" < "Advanced degree").
   - Use `ordered = TRUE` when creating ordered factors.

6. **Conversion Between Types**:
   - Convert factors back to character or numeric:
     ```R
     as.character(f)  # Converts factor to character
     ## [1] "M" "F" "M"
     as.numeric(f)    # Converts factor to internal numeric representation
     ## [1] 2 1 2
     ```

7. **Assignment and Validation**:
   - Factors enforce valid levels:
     ```R
     f[3] <- "Z"  # Invalid level assignment
     ## [1] M    F    <NA>
     ## Levels: F M
     ```

---

### **Important Notes**

1. **Automatic Conversion in Data Frames**:
   - When creating a data frame, character vectors are automatically converted to factors unless wrapped in `I()` (the "AsIs" operator).
     ```R
     df <- data.frame(sex = c("M", "F", "M"))  # Converts to factor
     df <- data.frame(sex = I(c("M", "F", "M")))  # Keeps as character
     ```

2. **Potential Pitfalls**:
   - Factors are internally numeric, which can lead to **unexpected results** when coerced:
     ```R
     as.numeric(f)  # Returns internal numeric representation, not the original values
     ```
   - Be cautious when using factors in functions that expect numeric inputs.

3. **Explicit Levels**:
   - If some levels are missing in the data, specify them explicitly:
     ```R
     f <- factor(s, levels = c("M", "F", "O"))  # Adds "O" as a level
     ```

4. **Use Cases**:
   - Factors are useful for:
     - Statistical modeling.
     - Grouping and stratifying data.
   - Avoid using factors for non-categorical data (e.g., names, IDs).

---

### **Examples for Practice**

1. **Create a Factor**:
   ```R
   s <- c("M", "F", "M")
   f <- as.factor(s)
   ```

2. **View Levels**:
   ```R
   levels(f)
   ```

3. **Add Explicit Levels**:
   ```R
   f <- factor(s, levels = c("M", "F", "O"))
   ```

4. **Prevent Automatic Conversion in Data Frames**:
   ```R
   df <- data.frame(sex = I(c("M", "F", "M")))  # Keeps as character
   ```

5. **Ordered Factors**:
   ```R
   edu <- factor(c("High school", "College", "Advanced degree"), 
                 levels = c("High school", "College", "Advanced degree"), 
                 ordered = TRUE)
   ```

