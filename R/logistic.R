#' Fit Logistic Regression Model
#'
#' This function fits a binary logistic regression model using gradient descent.
#'
#' @param X A numeric matrix of predictor variables (n x p)
#' @param y A numeric vector of binary responses (0 or 1)
#' @param learning_rate Learning rate for gradient descent. Default is 0.01
#' @param max_iter Maximum number of iterations. Default is 1000
#' @param tol Convergence tolerance. Default is 1e-6
#' @param add_intercept If TRUE, adds intercept term. Default is TRUE
#' @return An object of class "my_logistic" with coefficients and diagnostics
#' @export
#' @examples
#' # Generate sample data
#' set.seed(123)
#' X <- matrix(rnorm(200), ncol = 2)
#' y <- rbinom(100, 1, 0.5)
#'
#' # Fit model
#' model <- my_logistic(X, y)
#' print(model$coefficients)
my_logistic <- function(X, y, learning_rate = 0.01, max_iter = 1000,
                        tol = 1e-6, add_intercept = TRUE) {

  # Input validation
  if (!is.matrix(X)) X <- as.matrix(X)
  if (!is.numeric(X)) stop("X must be numeric")
  if (!is.numeric(y) || !all(y %in% c(0, 1))) {
    stop("y must be binary (0 or 1)")
  }
  if (nrow(X) != length(y)) {
    stop("Number of rows in X must equal length of y")
  }

  # Add intercept
  if (add_intercept) {
    X <- cbind(1, X)
  }

  n <- nrow(X)
  p <- ncol(X)
  beta <- rep(0, p)

  prev_ll <- -Inf
  converged <- FALSE

  # Gradient descent
  for (iter in 1:max_iter) {
    # Predicted probabilities
    logits <- X %*% beta
    probs <- 1 / (1 + exp(-logits))

    # Gradient
    gradient <- t(X) %*% (probs - y) / n

    # Update
    beta <- beta - learning_rate * gradient

    # Log-likelihood
    epsilon <- 1e-15
    probs_safe <- pmax(pmin(probs, 1 - epsilon), epsilon)
    ll <- sum(y * log(probs_safe) + (1 - y) * log(1 - probs_safe))

    # Check convergence
    if (abs(ll - prev_ll) < tol) {
      converged <- TRUE
      break
    }
    prev_ll <- ll
  }

  # Name coefficients
  if (add_intercept) {
    names(beta) <- c("(Intercept)", paste0("X", 1:(p-1)))
  } else {
    names(beta) <- paste0("X", 1:p)
  }

  result <- list(
    coefficients = beta,
    converged = converged,
    iterations = iter,
    final_ll = ll,
    X = X,
    y = y,
    add_intercept = add_intercept
  )

  class(result) <- "my_logistic"
  return(result)
}

#' Print method for my_logistic
#' @param x A my_logistic object
#' @param ... Additional arguments
#' @export
print.my_logistic <- function(x, ...) {
  cat("Logistic Regression Model\n\n")
  cat("Coefficients:\n")
  print(x$coefficients)
  cat("\nConverged:", x$converged, "\n")
  cat("Iterations:", x$iterations, "\n")
  invisible(x)
}
