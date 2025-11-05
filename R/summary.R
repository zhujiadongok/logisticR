#' Summary Method for my_logistic Objects
#'
#' @param object An object of class "my_logistic"
#' @param ... Additional arguments (not used)
#' @export
summary.my_logistic <- function(object, ...) {
  cat("Logistic Regression Model Summary\n")
  cat("=================================\n\n")

  cat("Coefficients:\n")
  coef_df <- data.frame(
    Estimate = object$coefficients
  )
  print(coef_df)

  cat("\n")
  cat("Convergence: ", ifelse(object$converged, "YES", "NO"), "\n", sep = "")
  cat("Iterations: ", object$iterations, "\n", sep = "")
  cat("Final log-likelihood: ", round(object$final_ll, 4), "\n", sep = "")
  cat("Number of observations: ", length(object$y), "\n", sep = "")

  invisible(object)
}
