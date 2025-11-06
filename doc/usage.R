## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 5
)

## ----eval=FALSE---------------------------------------------------------------
# devtools::install_github("zhujiadongok/logisticR")

## -----------------------------------------------------------------------------
library(logisticR)
library(ggplot2)

# Generate sample data
set.seed(123)
n <- 300
X <- matrix(rnorm(n * 2), ncol = 2)
true_beta <- c(-0.5, 1.0, -1.5)
logits <- cbind(1, X) %*% true_beta
probs <- 1 / (1 + exp(-logits))
y <- rbinom(n, 1, probs)

# Fit model
model <- my_logistic(X, y, learning_rate = 0.1, max_iter = 2000)
print(model)
summary(model)

## -----------------------------------------------------------------------------
# Predict probabilities
pred_probs <- predict(model, type = "response")
head(pred_probs)

# Predict classes
pred_class <- predict(model, type = "class")
table(Predicted = pred_class, Actual = y)

## -----------------------------------------------------------------------------
data(credit_data)
head(credit_data)

# Prepare data
X_credit <- as.matrix(credit_data[, c("age", "income", "debt_ratio")])
y_credit <- credit_data$default

# Fit model
credit_model <- my_logistic(X_credit, y_credit, learning_rate = 0.01, max_iter = 3000)
summary(credit_model)

# Predictions
credit_pred <- predict(credit_model, type = "class")
confusion <- table(Predicted = credit_pred, Actual = y_credit)
confusion

# Accuracy
accuracy <- sum(diag(confusion)) / sum(confusion)
cat("Accuracy:", round(accuracy, 4), "\n")

## -----------------------------------------------------------------------------
# Fit using our package
model_ours <- my_logistic(X, y, learning_rate = 0.1, max_iter = 2000)

# Fit using glm
glm_model <- glm(y ~ X, family = binomial(link = "logit"))

# Compare coefficients
comparison <- data.frame(
  logisticR = coef(model_ours),
  glm = coef(glm_model),
  difference = abs(coef(model_ours) - coef(glm_model))
)
print(comparison)

# Check if approximately equal
all.equal(coef(model_ours), coef(glm_model), tolerance = 0.01)

## -----------------------------------------------------------------------------
library(bench)

# Benchmark on moderate-sized data
set.seed(456)
n_bench <- 1000
X_bench <- matrix(rnorm(n_bench * 3), ncol = 3)
y_bench <- rbinom(n_bench, 1, 0.5)

benchmark_results <- mark(
  logisticR = my_logistic(X_bench, y_bench, learning_rate = 0.1, max_iter = 1000),
  glm = glm(y_bench ~ X_bench, family = binomial(link = "logit")),
  check = FALSE,
  iterations = 10
)

print(benchmark_results[, c("expression", "median", "mem_alloc")])

## -----------------------------------------------------------------------------
# Fit using C++ version
set.seed(123)
model_cpp <- my_logistic_cpp(X, y, learning_rate = 0.1, max_iter = 2000)

# Compare with R version
model_r <- my_logistic(X, y, learning_rate = 0.1, max_iter = 2000)

# Verify coefficients match
all.equal(coef(model_r), coef(model_cpp), tolerance = 0.001)

## -----------------------------------------------------------------------------
# Larger dataset for meaningful comparison
set.seed(789)
n_large <- 2000
X_large <- matrix(rnorm(n_large * 5), ncol = 5)
y_large <- rbinom(n_large, 1, 0.5)

speed_comparison <- mark(
  R_version = my_logistic(X_large, y_large, learning_rate = 0.1, max_iter = 300),
  Cpp_version = my_logistic_cpp(X_large, y_large, learning_rate = 0.1, max_iter = 300),
  check = FALSE,
  iterations = 5
)

print(speed_comparison[, c("expression", "median", "mem_alloc")])

# Calculate speedup
speedup <- as.numeric(speed_comparison$median[1]) / as.numeric(speed_comparison$median[2])
cat("\nC++ speedup:", round(speedup, 2), "x faster\n")

## -----------------------------------------------------------------------------
perf_data_cpp <- data.frame(
  Method = c("R", "C++"),
  Time = as.numeric(speed_comparison$median)
)

ggplot(perf_data_cpp, aes(x = Method, y = Time, fill = Method)) +
  geom_bar(stat = "identity") +
  labs(title = "Performance Comparison: R vs C++",
       y = "Median Time (seconds)",
       x = "Implementation") +
  theme_minimal() +
  theme(legend.position = "none")

## -----------------------------------------------------------------------------
library(ggplot2)

perf_data <- data.frame(
  Method = c("logisticR", "glm"),
  Time = as.numeric(benchmark_results$median)
)

ggplot(perf_data, aes(x = Method, y = Time, fill = Method)) +
  geom_bar(stat = "identity") +
  labs(title = "Performance Comparison",
       y = "Median Time (seconds)",
       x = "Method") +
  theme_minimal() +
  theme(legend.position = "none")

## -----------------------------------------------------------------------------
sessionInfo()

