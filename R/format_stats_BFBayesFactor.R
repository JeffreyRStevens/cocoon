
#' Format Bayes factors
#'
#' This method formats Bayes factors from the
#' \{[BayesFactor](https://cran.r-project.org/package=BayesFactor)\} package.
#' By default, this function rounds Bayes factors greater than 1 to one decimal
#' place and Bayes factors less than 1 to two decimal places. Values greater
#' than 1000 or less than 1/1000 are formatted using scientific notation.
#' Cutoffs can be set that format the values as greater than or less than the
#' cutoffs (e.g., BF > 1000 or BF < 0.001). Numbers of digits, cutoffs,
#' italics, and label subscripts are all customizable.
#'
#' @param x BayesFactor object or vector of numeric Bayes factor values.
#' @param digits1 Number of digits after the decimal for Bayes factors > 1.
#' @param digits2 Number of digits after the decimal for Bayes factors < 1.
#' @param cutoff Cutoff for using `_BF_~10~ > <cutoff>` or
#' `_BF_~10~ < 1 / <cutoff>` (value must be > 1).
#' @param label Character string for label before Bayes factor. Default is BF.
#' Set `label = ""` to return just the formatted Bayes factor value with no
#' label or operator (`=`, `<`, `>`).
#' @param italics Logical value (default = TRUE) for whether label should be
#' italicized (_BF_ or BF).
#' @param subscript Subscript to include with _BF_ label (`"10"`, `"01"`, or
#' `""` for no subscript).
#' @param type Type of formatting (`"md"` = markdown, `"latex"` = LaTeX).
#' @param ... Additional arguments passed to methods.
#'
#'
#' @return
#' A character string of statistical information formatted in Markdown or LaTeX.
#'
#' @method format_stats BFBayesFactor
#' @family functions for printing statistical objects
#' @export
#'
#' @examples
#' # Prepare statistical object
#' test_bf <- BayesFactor::ttestBF(mtcars$vs, mtcars$am)
#'
#' # Format Bayes factor
#' format_stats(test_bf)
#'
#' # Control cutoff for output
#' format_stats(test_bf, cutoff = 3)
#'
#' # Change digits, remove italics and subscript
#' format_stats(test_bf, digits2 = 1, italics = FALSE, subscript = "")
#'
#' # Return only Bayes factor value (no label)
#' format_stats(test_bf, label = "")
#'
#' # Format for LaTeX
#' format_stats(test_bf, type = "latex")
format_stats.BFBayesFactor <- function(x,
                                       digits1 = 1,
                                       digits2 = 2,
                                       cutoff = NULL,
                                       label = "BF",
                                       italics = TRUE,
                                       subscript = "10",
                                       type = "md",
                                       ...) {

  format_bf(x,
            digits1 = digits1,
            digits2 = digits2,
            cutoff = cutoff,
            label = label,
            italics = italics,
            subscript = subscript,
            type = type)
}
