#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

using namespace Rcpp;
using namespace arma;

//' Sigmoid Function (C++)
 //' @param z A numeric vector
 //' @return Sigmoid transformation
 //' @keywords internal
 // [[Rcpp::export]]
 arma::vec sigmoid_cpp(const arma::vec& z) {
   arma::vec result(z.n_elem);
   for (size_t i = 0; i < z.n_elem; i++) {
     if (z(i) >= 0) {
       result(i) = 1.0 / (1.0 + std::exp(-z(i)));
     } else {
       result(i) = std::exp(z(i)) / (1.0 + std::exp(z(i)));
     }
   }
   return result;
 }

 //' Compute Log-Likelihood (C++)
 //' @param y Response vector
 //' @param probs Predicted probabilities
 //' @return Log-likelihood value
 //' @keywords internal
 // [[Rcpp::export]]
 double compute_log_likelihood_cpp(const arma::vec& y, const arma::vec& probs) {
   double epsilon = 1e-15;
   double ll = 0.0;
   for (size_t i = 0; i < y.n_elem; i++) {
     double p = std::max(std::min(probs(i), 1.0 - epsilon), epsilon);
     ll += y(i) * std::log(p) + (1.0 - y(i)) * std::log(1.0 - p);
   }
   return ll;
 }

 //' Logistic Regression with Gradient Descent (C++)
 //' @param X Design matrix
 //' @param y Response vector
 //' @param learning_rate Learning rate
 //' @param max_iter Maximum iterations
 //' @param tol Convergence tolerance
 //' @return List with coefficients and diagnostics
 //' @keywords internal
 // [[Rcpp::export]]
 List logistic_gradient_descent_cpp(const arma::mat& X, const arma::vec& y,
                                    double learning_rate, int max_iter, double tol) {
   int n = X.n_rows;
   int p = X.n_cols;

   arma::vec beta = arma::zeros<arma::vec>(p);
   double prev_ll = -arma::datum::inf;
   bool converged = false;
   int iter;

   for (iter = 1; iter <= max_iter; iter++) {
     arma::vec logits = X * beta;
     arma::vec probs = sigmoid_cpp(logits);
     arma::vec gradient = X.t() * (probs - y) / n;
     beta = beta - learning_rate * gradient;
     double ll = compute_log_likelihood_cpp(y, probs);

     if (std::abs(ll - prev_ll) < tol) {
       converged = true;
       break;
     }
     prev_ll = ll;
   }

   return List::create(
     Named("coefficients") = beta,
     Named("converged") = converged,
     Named("iterations") = iter,
     Named("final_ll") = prev_ll
   );
 }
