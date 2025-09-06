
#' Format linear model statistics
#'
#' @description
#' This method formats (generalized) linear model statistics from the class
#' `lm` or `glm`. If no term is specified, overall model statistics are
#' returned. For linear models (`lm` objects), this includes the R-squared,
#' F statistic, and p-value. For generalized linear models (`glm` objects),
#' this includes deviance and AIC.
#' The default output is APA formatted, but this function allows
#' control over numbers of digits, leading zeros, italics, degrees of freedom,
#' and output format of Markdown or LaTeX.
#'
#' @param x An `lm` or `glm` object from [stats::lm()] or [stats::glm()].
#' @param term Character string for row name of term to extract statistics for.
#' This must be the exact string returned in the `summary()` output from the
#' `lm` or `glm` object.
#' @param digits Number of digits after the decimal for test statistics.
#' @param pdigits Number of digits after the decimal for p-values, ranging
#' between 1-5 (also controls cutoff for small p-values).
#' @param pzero Logical value (default = FALSE) for whether to include
#' leading zero for p-values.
#' @param full Logical value (default = TRUE) for whether to include extra
#' info (e.g., standard errors and t-values or z-values for terms)
#' or just test statistic and p-value.
#' @param italics Logical value (default = TRUE) for whether statistics labels
#' should be italicized.
#' @param dfs Formatting for degrees of freedom ("par" = parenthetical,
#' "sub" = subscript, "none" = do not print degrees of freedom).
#' @param type Type of formatting ("md" = markdown, "latex" = LaTeX).
#' @param ... Additional arguments passed to methods.
#'
#' @return
#' A character string of statistical information formatted in Markdown or LaTeX.
#'
#' @method format_stats lm
#' @family functions for printing statistical objects
#' @export
#'
#' @examples
#' test_lm <- lm(mpg ~ cyl * hp, data = mtcars)
#' test_glm <- glm(am ~ cyl * hp, data = mtcars, family = binomial)
#'
#' # Format linear model overall statistics
#' format_stats(test_lm)
#'
#' # Format linear model term statistics
#' format_stats(test_lm, term = "cyl")
#'
#' # Format generalized linear model overall statistics
#' format_stats(test_glm)
#'
#' # Format generalized linear model term statistics
#' format_stats(test_glm, term = "cyl")
#'
#' # Remove italics and make degrees of freedom subscripts
#' format_stats(test_lm, term = "cyl", italics = FALSE, dfs = "sub")
#'
#' # Change digits and add leading zero to p-value
#' format_stats(test_lm, term = "hp", digits = 3, pdigits = 4, pzero = TRUE)
#'
#' # Format for LaTeX
#' format_stats(test_lm, term = "hp", type = "latex")
format_stats.lm <- function(x,
                            term = NULL,
                            digits = 3,
                            pdigits = 3,
                            pzero = FALSE,
                            full = TRUE,
                            italics = TRUE,
                            dfs = "par",
                            type = "md",
                            ...) {
  # Validate arguments
  check_character(term, allow_null = TRUE)
  check_number_whole(digits, min = 0, allow_null = TRUE)
  check_number_whole(pdigits, min = 1, max = 5)
  check_bool(pzero)
  check_bool(full)
  check_bool(italics)
  check_string(type)
  check_match(type, c("md", "latex"))

  model_type <- ifelse(inherits(x, "glm"), "glm", "lm")
  summ <- summary(x)

  # Overall statistics for linear model
  if (is.null(term) && model_type == "lm") {
    r2 <- summ$adj.r.squared
    f <- summ$fstatistic
    f_stat <- f[1]
    df1 <- f[2]
    df2 <- f[3]
    p_value <- stats::pf(f[1], f[2], f[3], lower.tail = FALSE)

    # Build label
    r2_label <- dplyr::case_when(
      italics & identical(type, "md") ~
        paste0(format_chr("R", italics = italics, type = type), "^2^"),
      identical(type, "latex") ~
        paste0(format_chr("R", italics = italics, type = type), "$^{2}$")
    )
    r2_value <- format_num(r2, digits = digits)

    fstatlab <- "F"
    fstat_label <- dplyr::case_when(
      !italics ~ paste0(fstatlab),
      identical(type, "md") ~ paste0("_", fstatlab, "_"),
      identical(type, "latex") ~ paste0("$", fstatlab, "$")
    )
    fstat_label <- dplyr::case_when(identical(dfs, "par") ~
                                      paste0(fstat_label, "(", df1, ", ", df2, ")"),
                                   identical(dfs, "sub") & identical(type, "md") ~
                                     paste0(fstat_label, "~", df1, ",", df2, "~"),
                                   identical(dfs, "sub") & identical(type, "latex") ~
                                     paste0(fstat_label, "$_{", df1, ",", df2, "}$"),
                                   .default = fstat_label
    )[1]
    fstat_value <- format_num(f_stat, digits = digits, pzero = TRUE)
    pvalue <- format_p(p_value,
                       digits = pdigits, pzero = pzero,
                       italics = italics, type = type
    )

    # Create statistics string
    if (full) {
      mean_label <- paste0(r2_label, " = ")
      mean_value <- r2_value
      stat_label <- fstat_label
      stat_value <- fstat_value
      cis <- NULL
    } else {
      stat_label <- r2_label
      stat_value <- r2_value
      mean_label <- mean_value <- cis <- NULL
    }

    build_string(mean_label = mean_label,
                 mean_value = mean_value,
                 cis = cis,
                 stat_label = stat_label,
                 stat_value = stat_value,
                 pvalue = pvalue,
                 full = full)
    # Overall statistics for generalized linear model
  } else if (is.null(term) & model_type == "glm") {
    if (full) {
      stat_label <- dplyr::case_when(
        italics & identical(type, "md") ~
          paste0(format_chr("\u03C7", italics = italics, type = type), "^2^ = "),
        identical(type, "latex") ~
          paste0(format_chr("\\chi", italics = italics, type = type), "$^{2}$ = ")
      )
      paste0("Deviance = ", format_num(summ$deviance, digits = digits),
             ", ", stat_label,
             format_num(summ$null.deviance - summ$deviance, digits = digits),
             ", AIC = ", format_num(summ$aic, digits = digits))
    } else {
      paste0("Deviance = ", format_num(summ$deviance, digits = digits),
             ", AIC = ", format_num(summ$aic, digits = digits))
    }
    # Term-specific statistics for linear and generalized linear models
  } else {
    # For linear model
    if (model_type == "lm") {
      terms <- names(x$coefficients)
      stopifnot("Argument `term` not found in model terms." = term %in% terms)
      term_num <- which(terms == term)

      estimate <- summ$coefficients[term_num]
      se <- summ$coefficients[term_num, "Std. Error"]
      z <- summ$coefficients[term_num, "t value"]
      p_value <- summ$coefficients[term_num, "Pr(>|t|)"]
      z_lab <- "t"
      # For generalized linear model
    } else {
      terms <- rownames(summ$coefficients)
      stopifnot("Argument `term` not found in model terms." = term %in% terms)
      term_num <- which(terms == term)

      estimate <- summ$coefficients[term_num, "Estimate"]
      se <- summ$coefficients[term_num, "Std. Error"]
      z <- summ$coefficients[term_num, "z value"]
      p_value <- summ$coefficients[term_num, "Pr(>|z|)"]
      z_lab <- "z"
    }

    # Format values
    stat_value <- format_num(estimate, digits = digits, pzero = TRUE)
    se_value <- format_num(se, digits = digits, pzero = TRUE)
    z_value <- format_num(z, digits = digits, pzero = TRUE)
    pvalue <- format_p(p_value,
                       digits = pdigits, pzero = pzero,
                       italics = italics, type = type
    )

    # Build label
    stat_label <- dplyr::case_when(
      !italics & identical(type, "md") ~
        "\u03B2",
      !italics & identical(type, "latex") ~
        "\\textbeta",
      italics & identical(type, "md") ~
        format_chr("\u03B2", italics = TRUE, type = "md"),
      italics & identical(type, "latex") ~
        format_chr("\\beta", italics = TRUE, type = "latex")
    )

    # Create statistics string
    if(full) {
      paste0(stat_label, " = ", stat_value, ", SE = ", se_value, ", ",
             format_chr(z_lab, italics = italics, type = type), " = ",
             z_value, ", ", pvalue)
    } else {
      paste0(stat_label, " = ", stat_value, ", ", pvalue)
    }
  }
}
