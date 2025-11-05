#' Predict Method for my_logistic Objects
#'
#' Makes predictions using a fitted logistic regression model.
#'
#' @param object An object of class "my_logistic"
#' @param newdata A numeric matrix of new predictor variables. If NULL, uses training data.
#' @param type Type of prediction: "response" for probabilities or "class" for binary predictions
#' @param threshold Threshold for class prediction. Default is 0.5
#' @param ... Additional arguments (not used)
#' @return A numeric vector of predictions
#' @export
#' @examples
#' # Fit model
#' X <- matrix(rnorm(200), ncol = 2)
#' y <- rbinom(100, 1, 0.5)
#' model <- my_logistic(X, y)
#'
#' # Predict probabilities
#' pred_probs <- predict(model, type = "response")
#'
#' # Predict classes
#' pred_class <- predict(model, type = "class")
predict.my_logistic <- function(object, newdata = NULL, type = "response",
                                threshold = 0.5, ...) {

  # Use training data if newdata is NULL
  if (is.null(newdata)) {
    X_pred <- object$X
  } else {
    # Prepare new data
    if (!is.matrix(newdata)) newdata <- as.matrix(newdata)

    # Check dimensions
    expected_cols <- ncol(object$X) - object$add_intercept
    if (ncol(newdata) != expected_cols) {
      stop(paste("newdata must have", expected_cols, "columns"))
    }

    # Add intercept if needed
    if (object$add_intercept) {
      X_pred <- cbind(1, newdata)
    } else {
      X_pred <- newdata
    }
  }

  # Calculate predicted probabilities
  logits <- X_pred %*% object$coefficients
  probs <- 1 / (1 + exp(-logits))
  probs <- as.vector(probs)

  # Return appropriate predictions
  if (type == "response") {
    return(probs)
  } else if (type == "class") {
    classes <- ifelse(probs >= threshold, 1, 0)
    return(classes)
  } else {
    stop("type must be either 'response' or 'class'")
  }
}
