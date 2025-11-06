# logisticR

<!-- badges: start -->
[![R-CMD-check](https://github.com/zhujiadongok/logisticR/workflows/R-CMD-check/badge.svg)](https://github.com/zhujiadongok/logisticR/actions)
[![Codecov test coverage](https://codecov.io/gh/zhujiadongok/logisticR/branch/main/graph/badge.svg)](https://codecov.io/gh/zhujiadongok/logisticR?branch=main)
<!-- badges: end -->


An efficient R package for binary logistic regression using gradient descent.

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
- Easy-to-use predict and summary methods
- Sample credit default dataset included
- Comprehensive unit tests (15 tests, 100% pass rate)
- Detailed vignette with benchmarks

## Example with Credit Data
```r
data(credit_data)
X <- as.matrix(credit_data[, c("age", "income", "debt_ratio")])
y <- credit_data$default

model <- my_logistic(X, y)
summary(model)
```

## Documentation

- View help: `?my_logistic`
- Run examples: `example(my_logistic)`
- Read vignette: `vignette("usage", package = "logisticR")`

## Comparison with glm()

Our implementation produces results very similar to R built-in glm():
```r
model_ours <- my_logistic(X, y)
model_glm <- glm(y ~ X, family = binomial)

all.equal(coef(model_ours), coef(model_glm), tolerance = 0.01)
# TRUE
```

## Author

Jiadong Student  
University of Michigan  
BIOSTAT 625 - Fall 2025

## License

MIT
