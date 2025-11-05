#' Credit Default Dataset
#'
#' A synthetic dataset containing information about credit customers and their
#' default status.
#'
#' @format A data frame with 500 rows and 4 variables:
#' \describe{
#'   \item{age}{Age of the customer in years}
#'   \item{income}{Annual income in dollars}
#'   \item{debt_ratio}{Debt-to-income ratio (0 to 1)}
#'   \item{default}{Binary indicator: 1 = default, 0 = no default}
#' }
#' @examples
#' data(credit_data)
#' head(credit_data)
#' table(credit_data$default)
"credit_data"
