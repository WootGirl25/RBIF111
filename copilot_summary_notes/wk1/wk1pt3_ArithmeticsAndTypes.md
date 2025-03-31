WootGirl25: Please analyze the linked txt document. Please make a summary of these notes - the purpose of the summary notes will be to act as a quick refresher of things I have learnt from the full version, I want to be able to come back and read over the summary to revise what I have learnt this week. Highlight all key points in the learning materials and provide examples where appropiate.


GitHub Copilot: ### Summary of Week 1 Notes: Arithmetics and Types in R

#### **1. Overview**
- R can be used interactively as an advanced calculator.
- This section introduces basic expressions, data types, and special values in R.
- Designed for beginners with minimal programming experience.

---

#### **2. Notations**
- **Prompt (`>`):** Indicates R is ready for input.
- **Comments (`#`):** Ignored by R, used for inline explanations.
- Example:
    ```r
    2 + 2  # Adds 2 and 2
    ## [1] 4
    ```
- **Output Format:** Input prefixed with `>`, output follows.

---

#### **3. Using R as a Calculator**
- Perform arithmetic operations:
    ```r
    72 * 84
    ## [1] 6048
    sqrt(18.5)  # Square root
    ## [1] 4.301163
    sin(72 * pi / 180)  # Sine of 72 degrees
    ## [1] 0.9510565
    ```

---

#### **4. Variables**
- Store values using `<-` or `=`:
    ```r
    x <- 2
    y <- 3
    z <- (x + y) * 2
    z
    ## [1] 10
    ```
- Variables are dynamically typed (e.g., can hold numbers, text, etc.).
- Naming rules:
  - Can include letters, digits, and dots (`.`).
  - Case-sensitive (`x` ≠ `X`).

---

#### **5. Sequences and Loops**
- Generate sequences:
    ```r
    1:10
    ## [1] 1 2 3 4 5 6 7 8 9 10
    ```
- Use sequences in loops:
    ```r
    for (i in 1:3) print(i)
    ## [1] 1
    ## [1] 2
    ## [1] 3
    ```
- Concatenate sequences:
    ```r
    c(1, 5, 7, 2)
    ## [1] 1 5 7 2
    ```

---

#### **6. Plotting**
- Basic plotting example:
    ```r
    plot(1:100/pi, sin(1:100/pi), type="b", col=c("red", "green", "blue"), pch=1:5, xlab="x [rad]", ylab="sin(x)")
    ```
- Key concepts:
  - `type="b"`: Plot both points and lines.
  - `col`: Rotate colors.
  - `pch`: Rotate symbols.
  - `xlab`, `ylab`: Axis labels.

---

#### **7. R Data Types**
- **Numeric:** Numbers (e.g., `1`, `5.5`).
- **Character:** Text strings (e.g., `"abc"`).
- **Logical:** `TRUE`, `FALSE`.
- **Complex:** Complex numbers (e.g., `7 + 5i`).
- Use `mode()` to check data type:
    ```r
    mode(1)
    ## [1] "numeric"
    mode("abc")
    ## [1] "character"
    ```

---

#### **8. R Special Values**
- **`Inf`/`-Inf`:** Infinite values (e.g., `1/0`).
- **`NaN`:** Not a number (e.g., `0/0`).
- **`NULL`:** Represents "nothing."
- **`NA`:** Missing value.
- Check for special values:
    ```r
    is.na(NA)  # TRUE
    is.null(NULL)  # TRUE
    is.nan(NaN)  # TRUE
    is.infinite(Inf)  # TRUE
    ```

---

#### **Key Takeaways**
- R is interactive—test commands to understand behavior.
- Use comments and variable names effectively for clarity.
- Explore documentation (e.g., `?plot`) for advanced features.