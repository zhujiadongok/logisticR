# logisticR

<!-- badges: start -->
[![R-CMD-check](https://github.com/zhujiadongok/logisticR/workflows/R-CMD-check/badge.svg)](https://github.com/zhujiadongok/logisticR/actions)
[![Codecov test coverage](https://codecov.io/gh/zhujiadongok/logisticR/branch/main/graph/badge.svg)](https://codecov.io/gh/zhujiadongok/logisticR?branch=main)
<!-- badges: end -->

An efficient R package for binary logistic regression using gradient descent, with optional C++ acceleration via Rcpp.

## Installation
```r
# install.packages("devtools")
devtools::install_github("zhujiadongok/logisticR")
```

## Quick Start
```r
library(logisticR)

# Generate sample data
set.seed(123)
X <- matrix(rnorm(200), ncol = 2)
y <- rbinom(100, 1, 0.5)

# Fit logistic regression
model <- my_logistic(X, y, learning_rate = 0.1)
print(model)

# Make predictions
predictions <- predict(model, type = "response")
classes <- predict(model, type = "class")
```

## Features

- Pure R implementation using gradient descent
- C++ accelerated version via Rcpp (1.18x speedup)
- Easy-to-use S3 methods (print, summary, predict)
- Sample credit default dataset included
- Comprehensive unit tests (23 tests, 100% pass rate)
- Detailed vignette with benchmarks
- CI/CD with GitHub Actions

## C++ Accelerated Version

For improved performance on larger datasets:
```r
# Use C++ version for faster computation
model_cpp <- my_logistic_cpp(X, y, learning_rate = 0.1)

# Same interface, better performance
predictions <- predict(model_cpp, type = "response")
```

**Performance improvement**: 1.18x faster with 99.7% less memory usage (47.8MB → 148.7KB).

## Example with Credit Data
```r
data(credit_data)
head(credit_data)

# Prepare data
X <- as.matrix(credit_data[, c("age", "income", "debt_ratio")])
y <- credit_data$default

# Fit model
model <- my_logistic(X, y)
summary(model)

# Make predictions
pred_class <- predict(model, type = "class")
table(Predicted = pred_class, Actual = y)
```

## Documentation

- **View help**: `?my_logistic`
- **Run examples**: `example(my_logistic)`
- **Read vignette**: `vignette("usage", package = "logisticR")`

## Comparison with glm()

Our implementation produces results very similar to R's built-in `glm()`:
```r
model_ours <- my_logistic(X, y, learning_rate = 0.1, max_iter = 2000)
model_glm <- glm(y ~ X, family = binomial)

# Compare coefficients
all.equal(coef(model_ours), coef(model_glm), tolerance = 0.01)
# [1] TRUE
```

See the [vignette](vignettes/usage.Rmd) for detailed performance comparisons and benchmarks.

## Package Structure

- **R functions**: `my_logistic()`, `my_logistic_cpp()`, `predict()`, `summary()`
- **C++ implementation**: Efficient gradient descent using RcppArmadillo
- **Sample data**: `credit_data` - 500 observations of credit default data
- **Tests**: 23 unit tests covering all functionality
- **Documentation**: Complete help pages and vignette

## Author

Jiadong Zhu  
University of Michigan  
BIOSTAT 625 - Fall 2025

## License

MIT

---

**Citation**: If you use this package, please cite as:
```
Zhu, J. (2025). logisticR: Efficient Logistic Regression Implementation.
R package version 0.1.0. https://github.com/zhujiadongok/logisticR
```
