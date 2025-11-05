test_that("my_logistic fits correctly", {
  set.seed(123)
  n <- 100
  X <- matrix(rnorm(n * 2), ncol = 2)
  true_beta <- c(-1, 0.5, 1.5)
  logits <- cbind(1, X) %*% true_beta
  probs <- 1 / (1 + exp(-logits))
  y <- rbinom(n, 1, probs)

  # 使用更多迭代次数和更高的学习率
  model <- my_logistic(X, y, learning_rate = 0.1, max_iter = 5000)

  expect_s3_class(model, "my_logistic")
  expect_true(model$converged)
  expect_equal(length(model$coefficients), 3)
})

test_that("my_logistic handles input validation", {
  X <- matrix(rnorm(100), ncol = 2)
  y_wrong_length <- rbinom(60, 1, 0.5)  # 改成明显不同的长度

  # 测试维度不匹配
  expect_error(my_logistic(X, y_wrong_length), "must equal length")

  # 测试 y 不是二元的
  y_invalid <- c(0, 1, 2, rep(0, 47))
  expect_error(my_logistic(X, y_invalid), "binary")
})

test_that("my_logistic works without intercept", {
  set.seed(123)
  n <- 100
  X <- matrix(rnorm(n * 2), ncol = 2)
  true_beta <- c(0.5, 1.5)
  logits <- X %*% true_beta
  probs <- 1 / (1 + exp(-logits))
  y <- rbinom(n, 1, probs)

  model <- my_logistic(X, y, add_intercept = FALSE,
                       learning_rate = 0.1, max_iter = 5000)

  expect_equal(length(model$coefficients), 2)
  expect_false(model$add_intercept)
})

test_that("coefficients are reasonable", {
  set.seed(456)
  n <- 300
  X <- matrix(rnorm(n * 2), ncol = 2)
  true_beta <- c(0, 1, -1)
  logits <- cbind(1, X) %*% true_beta
  probs <- 1 / (1 + exp(-logits))
  y <- rbinom(n, 1, probs)

  model <- my_logistic(X, y, learning_rate = 0.1, max_iter = 5000)

  # 系数应该接近真实值
  expect_true(all(abs(model$coefficients - true_beta) < 0.8))
})
