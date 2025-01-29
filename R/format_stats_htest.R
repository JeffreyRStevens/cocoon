
#' Format hypothesis test statistics
#'
#' This method formats hypothesis test statistics from the class `htest`.
#' Currently, this includes correlations from [cor.test()] and t-tests and
#' Wilcoxon tests from [t.test()] and [wilcox.test()]. For correlations, the
#' function detects whether the object is from a Pearson,
#' Spearman, or Kendall correlation and reports the appropriate correlation
#' label (r, \eqn{\tau}, \eqn{\rho}). The default output is APA formatted, but
#' this function allows control over numbers of
#' digits, leading zeros, the presence of means and confidence intervals,
#' italics, degrees of freedom, and mean labels, and output format of
#' Markdown or LaTeX.
#'
#' @param x An `htest` object from [cor.test()], [t.test()], or [wilcox.test()].
#' @param digits Number of digits after the decimal for means, confidence
#' intervals, and test statistics.
#' @param pdigits Number of digits after the decimal for p-values, ranging
#' between 1-5 (also controls cutoff for small p-values).
#' @param pzero Logical value (default = FALSE) for whether to include
#' leading zero for p-values.
#' @param full Logical value (default = TRUE) for whether to include means
#' and confidence intervals or just test statistic and p-value.
#' @param italics Logical value (default = TRUE) for whether _p_ label should be
#' italicized.
#' @param dfs Formatting for degrees of freedom ("par" = parenthetical,
#' "sub" = subscript, "none" = do not print degrees of freedom).
#' @param mean Formatting for mean label ("abbr" = M, "word" = Mean).
#' @param type Type of formatting ("md" = markdown, "latex" = LaTeX).
#' @param ... Additional arguments passed to methods.
#'
#' @return
#' A character string of statistical information formatted in Markdown or LaTeX.
#'
#' @method format_stats htest
#' @family functions for printing statistical objects
#' @export
#'
#' @examples
#' # Prepare statistical objects
#' test_corr <- cor.test(mtcars$mpg, mtcars$cyl)
#' test_corr2 <- cor.test(mtcars$mpg, mtcars$cyl, method = "kendall")
#' test_ttest <- t.test(mtcars$vs, mtcars$am)
#' test_ttest2 <- wilcox.test(mtcars$vs, mtcars$am)
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
#' # Format Kendall's tau
#' format_stats(test_corr2)
#'
#' # Format t-test
#'   format_stats(test_ttest)
#'
#' # Remove mean and confidence interval
#' format_stats(test_ttest, full = FALSE)
#'
#' # Remove degrees of freedom and spell out "Mean"
#' format_stats(test_ttest, dfs = "none", mean = "word")
#'
#' # Format for LaTeX
#' format_stats(test_ttest2, type = "latex")
format_stats.htest <- function(x,
                               digits = NULL,
                               pdigits = 3,
                               pzero = FALSE,
                               full = TRUE,
                               italics = TRUE,
                               dfs = "par",
                               mean = "abbr",
                               type = "md",
                               ...) {
  # Validate arguments
  check_number_whole(digits, min = 0, allow_null = TRUE)
  check_number_whole(pdigits, min = 1, max = 5)
  check_bool(pzero)
  check_bool(full)
  check_bool(italics)
  check_match(dfs, c("par", "sub", "none"))
  check_match(mean, c("abbr", "word"))
  check_string(type)
  check_match(type, c("md", "latex"))

  if (grepl("correlation", x$method)) {
    if (is.null(digits)) {
      digits <- 2
    } else {
      digits <- digits
    }
    format_corr(x,
                digits = digits,
                pdigits = pdigits,
                pzero = pzero,
                full = full,
                italics = italics,
                type = type)
  } else if (grepl("t-test", x$method) || grepl("Wilcoxon", x$method)) {
    if (is.null(digits)) {
      digits <- 1
    } else {
      digits <- digits
    }
    format_ttest(x,
                 digits = digits,
                 pdigits = pdigits,
                 pzero = pzero,
                 full = full,
                 italics = italics,
                 dfs = dfs,
                 mean = mean,
                 type = type)
  } else {
    stop(
      "Objects of method '"
      , x$method
      , "' are currently not supported."
      , "\nVisit https://github.com/JeffreyRStevens/cocoon/issues to request support for this method."
      , call. = FALSE
    )
  }
}
