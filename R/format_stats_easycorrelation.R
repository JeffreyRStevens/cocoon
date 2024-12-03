#' Format correlation statistics
#'
#' @description
#' This functions formats correlation statistics generated from the
#' \{[correlation](https://cran.r-project.org/package=correlation)\} package.
#' This detects whether the object is from a Pearson, Spearman, or Kendall
#' correlation and reports the appropriate correlation label
#' (r, \eqn{\tau}, \eqn{\rho}). The default output is APA formatted, but
#' numbers of digits, leading zeros, the presence of confidence intervals,
#' and italics are all customizable.

#' @inheritParams format_stats.htest
#'
#' @return
#' A character string of statistical information formatted in Markdown or LaTeX.
#'
#' @method format_stats easycorrelation
#' @family functions for printing statistical objects

#' @export
#'
#' @examples
#' # Prepare statistical objects
#' test_corr <- correlation::correlation(mtcars, select = "mpg", select2 = "disp")
#' test_corr2 <- correlation::correlation(mtcars, select = "mpg", select2 = "disp", method = "kendall")
#'
#' # Format correlation
#' format_stats(test_corr)
#'
#' # Remove confidence intervals and italics
#' format_stats(test_corr, full = FALSE, italics = FALSE)
#'
#' # Change digits and add leading zero to p-value
#' format_stats(test_corr, digits = 3, pdigits = 4, pzero = TRUE)
#'
#' # Format Kendall's tau for LaTeX
#' format_stats(test_corr2, type = "latex")
format_stats.easycorrelation <- function(x,
                                         digits = 2,
                                         pdigits = 3,
                                         pzero = FALSE,
                                         full = TRUE,
                                         italics = TRUE,
                                         type = "md",
                                         ...) {
  # Validate arguments
  check_number_whole(digits, min = 0, allow_null = TRUE)
  check_number_whole(pdigits, min = 1, max = 5)
  check_bool(pzero)
  check_bool(full)
  check_bool(italics)
  check_string(type)
  check_match(type, c("md", "latex"))

  if ("r" %in% names(x)) {
    method <- "Pearson correlation"
  } else if ("rho" %in% names(x)) {
    method <- "Spearman correlation"
    x$r <- x$rho
  } else if ("tau" %in% names(x)) {
    method <- "Kendall correlation"
    x$r <- x$tau
  } else {
    stop("Correlation method is not Pearson, Spearman, or Kendall.")
  }

  y <- list(
    statistic = x$t,
    parameter = x$df_error,
    p.value = x$p,
    estimate = x$r,
    data.name = paste0(x$Parameter1, " and ", x$Parameter2),
    method = method,
    conf.int = c(x$CI_low, x$CI_high)
  )
  class(y) <- "htest"
  format_corr(y,
    digits = digits,
    pdigits = pdigits,
    pzero = pzero,
    full = full,
    italics = italics,
    type = type
  )
}
