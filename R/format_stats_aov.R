
#' Format ANOVA statistics
#'
#' @description
#' This method formats analysis of variance (ANOVA) statistics from the class
#' `aov`. The default output is APA formatted, but this function allows control
#' over numbers of digits, leading zeros, italics, degrees of freedom,
#' and output format of Markdown or LaTeX.
#'
#' @param x An `aov` object from [stats::aov()].
#' @param term Character string for row name of term to extract statistics for.
#' This must be the exact string returned in the `summary()` output from the
#' `aov` object.
#' @param digits Number of digits after the decimal for means, confidence
#' intervals, and test statistics.
#' @param pdigits Number of digits after the decimal for p-values, ranging
#' between 1-5 (also controls cutoff for small p-values).
#' @param pzero Logical value (default = FALSE) for whether to include
#' leading zero for p-values.
#' @param italics Logical value (default = TRUE) for whether _p_ label should be
#' italicized.
#' @param dfs Formatting for degrees of freedom ("par" = parenthetical,
#' "sub" = subscript, "none" = do not print degrees of freedom).
#' @param type Type of formatting ("md" = markdown, "latex" = LaTeX).
#' @param ... Additional arguments passed to methods.
#'
#' @return
#' A character string of statistical information formatted in Markdown or LaTeX.
#'
#' @method format_stats aov
#' @family functions for printing statistical objects
#' @export
#'
#' @examples
#' test_aov <- aov(mpg ~ cyl * hp, data = mtcars)
#'
#' # Format ANOVA
#' format_stats(test_aov, term = "cyl")
#'
#' # Remove italics and make degrees of freedom subscripts
#' format_stats(test_aov, term = "cyl", italics = FALSE, dfs = "sub")
#'
#' # Change digits and add leading zero to p-value
#' format_stats(test_aov, term = "hp", digits = 3, pdigits = 4, pzero = TRUE)
#'
#' # Format for LaTeX
#' format_stats(test_aov, term = "hp", type = "latex")
format_stats.aov <- function(x,
                             term,
                             digits = 1,
                             pdigits = 3,
                             pzero = FALSE,
                             italics = TRUE,
                             dfs = "par",
                             type = "md",
                             ...) {
  # Validate arguments
  check_character(term)
  check_number_whole(digits, min = 0, allow_null = TRUE)
  check_number_whole(pdigits, min = 1, max = 5)
  check_bool(pzero)
  check_bool(italics)
  check_match(dfs, c("par", "sub", "none"))
  check_string(type)
  check_match(type, c("md", "latex"))

  terms <- attr(x$terms, "term.labels")
  stopifnot("Argument `term` not found in model terms." = term %in% terms)
  term_num <- which(terms == term)

  summ <- summary(x)

  f_stat <- summ[[1]][["F value"]][term_num]
  df1 <- summ[[1]][["Df"]][term_num]
  df2 <- x$df.residual
  p_value <- summ[[1]][["Pr(>F)"]][term_num]

  stat_value <- format_num(f_stat, digits = digits, pzero = TRUE)
  pvalue <- format_p(p_value,
                     digits = pdigits, pzero = pzero,
                     italics = italics, type = type
  )

  # Build label
  statlab <- "F"
  stat_label <- dplyr::case_when(
    !italics ~ paste0(statlab),
    identical(type, "md") ~ paste0("_", statlab, "_"),
    identical(type, "latex") ~ paste0("$", statlab, "$")
  )
  stat_label <- dplyr::case_when(identical(dfs, "par") ~
                                   paste0(stat_label, "(", df1, ", ", df2, ")"),
                                 identical(dfs, "sub") & identical(type, "md") ~
                                   paste0(stat_label, "~", df1, ",", df2, "~"),
                                 identical(dfs, "sub") & identical(type, "latex") ~
                                   paste0(stat_label, "$_{", df1, ",", df2, "}$"),
                                 .default = stat_label
  )[1]

  # Create statistics string
  build_string(mean_label = NULL,
               mean_value = NULL,
               cis = FALSE,
               stat_label = stat_label,
               stat_value = stat_value,
               pvalue = pvalue,
               full = FALSE)
}
