#' Fit Logistic Regression with C++ Acceleration
#'
#' @param X Predictor matrix
#' @param y Binary response vector
#' @param learning_rate Learning rate, default 0.01
#' @param max_iter Maximum iterations, default 1000
#' @param tol Convergence tolerance, default 1e-6
#' @param add_intercept Add intercept, default TRUE
#' @return A my_logistic object
#' @export
#' @examples
#' X <- matrix(rnorm(200), ncol = 2)
#' y <- rbinom(100, 1, 0.5)
#' model <- my_logistic_cpp(X, y)
my_logistic_cpp <- function(X, y, learning_rate = 0.01, max_iter = 1000,
                            tol = 1e-6, add_intercept = TRUE) {

  if (!is.matrix(X)) X <- as.matrix(X)
  if (!is.numeric(X)) stop("X must be numeric")
  if (!is.numeric(y) || !all(y %in% c(0, 1))) {
    stop("y must be binary (0 or 1)")
  }
  if (nrow(X) != length(y)) {
    stop("Dimensions don't match")
  }

  if (add_intercept) {
    X <- cbind(1, X)
  }

  result_cpp <- logistic_gradient_descent_cpp(X, y, learning_rate, max_iter, tol)

  p <- ncol(X)
  if (add_intercept) {
    names(result_cpp$coefficients) <- c("(Intercept)", paste0("X", 1:(p-1)))
  } else {
    names(result_cpp$coefficients) <- paste0("X", 1:p)
  }

  result <- list(
    coefficients = result_cpp$coefficients,
    converged = result_cpp$converged,
    iterations = result_cpp$iterations,
    final_ll = result_cpp$final_ll,
    X = X,
    y = y,
    add_intercept = add_intercept
  )

  class(result) <- "my_logistic"
  return(result)
}
