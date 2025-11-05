test_that("predict returns correct dimensions", {
  set.seed(123)
  n <- 100
  X <- matrix(rnorm(n * 2), ncol = 2)
  y <- rbinom(n, 1, 0.5)

  model <- my_logistic(X, y)

  # Test on training data
  pred <- predict(model)
  expect_equal(length(pred), n)
  expect_true(all(pred >= 0 & pred <= 1))

  # Test on new data
  new_X <- matrix(rnorm(20), ncol = 2)
  pred_new <- predict(model, new_X)
  expect_equal(length(pred_new), 10)
})

test_that("predict handles type argument", {
  set.seed(123)
  n <- 100
  X <- matrix(rnorm(n * 2), ncol = 2)
  y <- rbinom(n, 1, 0.5)

  model <- my_logistic(X, y)

  pred_prob <- predict(model, type = "response")
  pred_class <- predict(model, type = "class")

  expect_true(all(pred_prob >= 0 & pred_prob <= 1))
  expect_true(all(pred_class %in% c(0, 1)))
})

test_that("predict validates inputs", {
  set.seed(123)
  X <- matrix(rnorm(100), ncol = 2)
  y <- rbinom(50, 1, 0.5)
  model <- my_logistic(X, y)

  expect_error(predict(model, type = "invalid"))
  expect_error(predict(model, newdata = matrix(rnorm(30), ncol = 3)))
})
