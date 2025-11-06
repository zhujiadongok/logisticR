test_that("my_logistic_cpp produces similar results to R", {
  set.seed(789)
  n <- 200
  X <- matrix(rnorm(n * 2), ncol = 2)
  y <- rbinom(n, 1, 0.5)

  model_r <- my_logistic(X, y, learning_rate = 0.1, max_iter = 2000)
  model_cpp <- my_logistic_cpp(X, y, learning_rate = 0.1, max_iter = 2000)

  # Coefficients should match
  expect_equal(model_r$coefficients, model_cpp$coefficients, tolerance = 0.01)
  expect_equal(model_r$converged, model_cpp$converged)
})

test_that("my_logistic_cpp handles input validation", {
  X <- matrix(rnorm(100), ncol = 2)
  y <- rbinom(60, 1, 0.5)

  expect_error(my_logistic_cpp(X, y), "Dimensions")
})

test_that("cpp version converges properly", {
  set.seed(456)
  n <- 300
  X <- matrix(rnorm(n * 3), ncol = 3)
  y <- rbinom(n, 1, 0.5)

  model <- my_logistic_cpp(X, y, learning_rate = 0.1, max_iter = 5000)

  expect_true(model$converged)
  expect_s3_class(model, "my_logistic")
  expect_equal(length(model$coefficients), 4)
})

test_that("cpp version works with predict", {
  set.seed(123)
  n <- 100
  X <- matrix(rnorm(n * 2), ncol = 2)
  y <- rbinom(n, 1, 0.5)

  model <- my_logistic_cpp(X, y, learning_rate = 0.1)
  pred <- predict(model, type = "response")

  expect_equal(length(pred), n)
  expect_true(all(pred >= 0 & pred <= 1))
})
