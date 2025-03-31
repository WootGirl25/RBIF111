WootGirl25: Please analyze the linked txt document. Please make a summary of these notes - the purpose of the summary notes will be to act as a quick refresher of things I have learnt from the full version, I want to be able to come back and read over the summary to revise what I have learnt this week. Highlight all key points in the learning materials and provide examples where appropiate.

Workspace: Collecting workspace information### Summary Notes: Week 1 - Programming in R

#### **1. Overview**
- R is a versatile language for data manipulation and analysis.
- Key topics covered:
  - Program flow control (e.g., `if-else`, loops).
  - Functions and parameter handling.
  - Lazy evaluation.
  - Efficiency of vectorized operations vs explicit loops.

---

#### **2. Execution Flow Control**
- **Conditional Statements (`if-else`)**:
  - Syntax:
    ```r
    if (condition) { code } else { code }
    ```
  - Single-line statements don’t require braces, but multi-line ones do.
  - Example:
    ```r
    x <- c(3, 5)
    if (any(x > 4)) "apples" else "oranges"
    ## [1] "apples"
    ```

- **Vectorized Conditional (`ifelse`)**:
  - Operates element-wise on vectors.
  - Example:
    ```r
    x <- c(3, 5, 1, 7)
    ifelse(x > 4, "apples", "oranges")
    ## [1] "oranges" "apples"  "oranges" "apples"
    ```

- **Loops**:
  - **For Loop**:
    ```r
    for (i in 1:3) print(paste("iteration", i))
    ## [1] "iteration 1"
    ## [1] "iteration 2"
    ## [1] "iteration 3"
    ```
    - Loop variables persist after the loop ends.
  - **While Loop**:
    ```r
    i <- 1
    while (i < 4) { print(i); i <- i + 1 }
    ## [1] 1
    ## [1] 2
    ## [1] 3
    ```

---

#### **3. Functions**
- **Defining Functions**:
  - Syntax:
    ```r
    my_function <- function(arg1, arg2 = default_value) {
      # Function body
      return(value)
    }
    ```
  - Example: Custom `max` function:
    ```r
    my.max <- function(x, na.rm = FALSE) {
      x.max <- -Inf
      for (xx in x) {
        if (is.na(xx)) {
          if (na.rm) next else return(NA)
        }
        if (xx > x.max) x.max <- xx
      }
      x.max
    }
    ```

- **Parameter Binding**:
  - Positional and named arguments can be mixed.
  - Example:
    ```r
    my.max(na.rm = TRUE, x = c(1, NA, 3))
    ## [1] 3
    ```

- **Variable Scoping**:
  - Variables inside functions are local.
  - Use `<<-` for modifying global variables.

---

#### **4. Lazy Evaluation**
- **Definition**:
  - Arguments are evaluated only when needed.
  - Example:
    ```r
    f <- function(x, y = some.function(), z = some.var) {
      if (x == 0) print("DONE")
      if (x == 1) print(y)
      if (x == 2) print(z)
    }
    f(0)  # Does not evaluate y or z
    ## [1] "DONE"
    ```

- **Logical Operators**:
  - `||` and `&&` are short-circuit operators (evaluate left to right, stop when result is determined).
  - Example:
    ```r
    TRUE || never.defined.function()  # No error
    ```

---

#### **5. Traditional Loops vs Vectorized Code**
- **Vectorized Operations**:
  - Faster and more efficient than explicit loops.
  - Example:
    ```r
    x <- numeric(10000000)
    system.time(x[] <- 1)  # Vectorized
    ##    user  system elapsed 
    ##   0.035   0.076   0.112
    system.time(for (i in 1:length(x)) x[i] <- 1)  # Loop
    ##    user  system elapsed 
    ##   0.446   0.000   0.446
    ```

- **`apply()` Function**:
  - Applies a function to rows or columns of a matrix/data frame.
  - Example:
    ```r
    m <- data.frame(A = c(1, 2, 3), B = c(4, 5, 6))
    apply(m, MARGIN = 1, max)  # Row-wise max
    ## [1] 4 5 6
    apply(m, MARGIN = 2, function(x) sum(x^2))  # Column-wise sum of squares
    ##   A   B 
    ##  14  77
    ```

---

#### **6. Summary**
- **Key Takeaways**:
  - Use vectorized operations for efficiency.
  - Write reusable functions with clear parameter handling.
  - Understand lazy evaluation to avoid unexpected errors.
  - Prefer `apply()` and similar functions over explicit loops for matrix/data frame operations.