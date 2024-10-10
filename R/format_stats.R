
#' Format statistical results
#'
#' A generic function that takes objects from various statistical methods to
#' create formatted character strings to insert into R Markdown or Quarto
#' documents. Currently, the generic function works with the following objects:
#' 1. `htest` objects of correlations, t-tests, and Wilcoxon tests
#' 1. correlations from the
#' \{[correlation](https://cran.r-project.org/package=correlation)\} package.
#' 1. Bayes factors from the
#' \{[BayesFactor](https://cran.r-project.org/package=BayesFactor)\} package.
#' The function invokes specific methods that depend on the class of the
#' first argument.
#'
#' @param x Statistical object.
#' @param ... Additional arguments passed to methods. For method-specific
#' arguments, see [format_stats.htest()] for htest correlations, t-tests,
#' and Wilcoxon tests and [format_stats.BFBayesFactor()] for Bayes factors from
#' the \{[BayesFactor](https://cran.r-project.org/package=BayesFactor)\} package.
#'
#' @return
#' A character string of statistical information formatted in Markdown or LaTeX.
#' @export
#'
#' @family functions for printing statistical objects
#'
#' @examples
#' # Format cor.test() object
#' format_stats(cor.test(mtcars$mpg, mtcars$cyl))
#'
#' # Format correlation::correlation() object
#' format_stats(correlation::correlation(data = mtcars, select = "mpg", select2 = "cyl"))
#'
#' # Format t.test() object
#' format_stats(t.test(mtcars$vs, mtcars$am))
#'
#' # Format BFBayesFactor object from {BayesFactor} package
#' format_stats(BayesFactor::ttestBF(mtcars$vs, mtcars$am))
format_stats <- function(x, ...) {
  UseMethod("format_stats", x)
}

#' @method format_stats default
#' @export
format_stats.default <- function(x, ...) {
  if (inherits(x, "numeric")) {
    stop(
      "Numerics are not supported by `format_stats()`.",
      "\n See `format_num()`, `format_bf()`, `format_p()`, or `format_summary()` for formatting numerics."
      , call. = FALSE
    )
  } else if (inherits(x, "character")) {
    stop(
      "Character strings are not supported by `format_stats()`.",
      call. = FALSE
    )
  } else if (inherits(x, "data.frame")) {
    stop(
      "Data frames are not supported by `format_stats()`.",
      call. = FALSE
    )
  } else {
    stop(
      "Objects of class '",
      class(x),
      "' are currently not supported (no method defined).",
      "\n Visit https://github.com/JeffreyRStevens/cocoon/issues to request support for this class.",
      call. = FALSE
    )
  }
}

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
#' @param x An `htest` object
#' @param digits Number of digits after the decimal for means, confidence
#' intervals, and test statistics
#' @param pdigits Number of digits after the decimal for p-values, ranging
#' between 1-5 (also controls cutoff for small p-values)
#' @param pzero Logical value (default = FALSE) for whether to include
#' leading zero for p-values
#' @param full Logical value (default = TRUE) for whether to include means
#' and confidence intervals or just test statistic and p-value
#' @param italics Logical value (default = TRUE) for whether _p_ label should be
#' italicized
#' @param dfs Formatting for degrees of freedom ("par" = parenthetical,
#' "sub" = subscript, "none" = do not print degrees of freedom)
#' @param mean Formatting for mean label ("abbr" = M, "word" = Mean)
#' @param type Type of formatting ("md" = markdown, "latex" = LaTeX)
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
  if (!is.null(digits)) {
    stopifnot("Argument `digits` must be a non-negative numeric vector." = is.numeric(digits))
    stopifnot("Argument `digits` must be a non-negative numeric vector." = digits >= 0)
  }
  stopifnot("Argument `pdigits` must be a numeric between 1 and 5." = is.numeric(pdigits))
  stopifnot("Argument `pdigits` must be a numeric between 1 and 5." = pdigits > 0)
  stopifnot("Argument `pdigits` must be a numeric between 1 and 5." = pdigits < 6)
  stopifnot("Argument `pzero` must be TRUE or FALSE." = is.logical(pzero))
  stopifnot("Argument `full` must be TRUE or FALSE." = is.logical(full))
  stopifnot("Argument `italics` must be TRUE or FALSE." = is.logical(italics))
  stopifnot("Argument `dfs` must be 'par', 'sub', or 'none'." = dfs %in% c("par", "sub", "none"))
  stopifnot("Argument `mean` must be 'abbr' or 'word'." = mean %in% c("abbr", "word"))
  stopifnot("Argument `type` must be 'md' or 'latex'." = type %in% c("md", "latex"))

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
  } else if (grepl("t-test", x$method) | grepl("Wilcoxon", x$method)) {
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
  if (!is.null(digits)) {
    stopifnot("Argument `digits` must be a non-negative numeric vector." = is.numeric(digits))
    stopifnot("Argument `digits` must be a non-negative numeric vector." = digits >= 0)
  }
  stopifnot("Argument `pdigits` must be a numeric between 1 and 5." = is.numeric(pdigits))
  stopifnot("Argument `pdigits` must be a numeric between 1 and 5." = pdigits > 0)
  stopifnot("Argument `pdigits` must be a numeric between 1 and 5." = pdigits < 6)
  stopifnot("Argument `pzero` must be TRUE or FALSE." = is.logical(pzero))
  stopifnot("Argument `full` must be TRUE or FALSE." = is.logical(full))
  stopifnot("Argument `italics` must be TRUE or FALSE." = is.logical(italics))
  stopifnot("Argument `type` must be 'md' or 'latex'." = type %in% c("md", "latex"))

  if ("r" %in% names(x)) {
    method <- "Pearson correlation"
  } else if ("rho" %in% names(x)) {
    method <- "Spearman correlation"
    x$r <- x$rho
  }  else if ("tau" %in% names(x)) {
    method <- "Kendall correlation"
    x$r <- x$tau
  } else {
    stop("Correlation method is not Pearson, Spearman, or Kendall.")
  }

  y <- list(statistic = x$t,
            parameter = x$df_error,
            p.value = x$p,
            estimate = x$r,
            data.name = paste0(x$Parameter1, " and ", x$Parameter2),
            method = method,
            conf.int = c(x$CI_low, x$CI_high))
  class(y) <- "htest"
  format_corr(y,
              digits = digits,
              pdigits = pdigits,
              pzero = pzero,
              full = full,
              italics = italics,
              type = type)
}

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
#' @param x BayesFactor object or vector of numeric Bayes factor values
#' @param digits1 Number of digits after the decimal for Bayes factors > 1
#' @param digits2 Number of digits after the decimal for Bayes factors < 1
#' @param cutoff Cutoff for using `_BF_~10~ > <cutoff>` or
#' `_BF_~10~ < 1 / <cutoff>` (value must be > 1)
#' @param label Character string for label before Bayes factor. Default is BF.
#' Set `label = ""` to return just the formatted Bayes factor value with no
#' label or operator (`=`, `<`, `>`)
#' @param italics Logical value (default = TRUE) for whether label should be
#' italicized (_BF_ or BF)
#' @param subscript Subscript to include with _BF_ label (`"10"`, `"01"`, or
#' `""` for no subscript)
#' @param type Type of formatting (`"md"` = markdown, `"latex"` = LaTeX)
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
