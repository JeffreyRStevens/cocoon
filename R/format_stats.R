
#' Format statistical results
#'
#' A generic function that takes objects from various statistical methods to
#' create formatted character strings to insert into R Markdown or Quarto
#' documents. Currently, the generic function works with the following objects:
#' 1. `htest` objects of correlations, t-tests, and Wilcoxon tests
#' 1. correlations from the
#' \{[correlation](https://cran.r-project.org/package=correlation)\} package.
#' 1. `aov` objects for ANOVAs
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
