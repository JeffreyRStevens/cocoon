
#' Format linear mixed model statistics
#'
#' @description
#' This method formats (generalized) linear mixed model statistics from the
#' class `lmerMod` or `glmerMod` from the
#' \{[lme4](https://cran.r-project.org/package=lme4)\} package.
#' Only fixed effects can be extracted.
#' The default output is APA formatted, but this function allows
#' control over numbers of digits, leading zeros, italics,
#' and output format of Markdown or LaTeX.
#'
#' @param x An `lmerMod` or `glmerMod` object from [lme4::lmer()] or
#' [lme4::glmer()].
#' @param term Character string for row name of term to extract statistics for.
#' This must be the exact string returned in the `summary()` output from the
#' `lmerMod` or `glmerMod` object and can only be fixed effects.
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
#' @param type Type of formatting ("md" = markdown, "latex" = LaTeX).
#' @param ... Additional arguments passed to methods.
#'
#' @return
#' A character string of statistical information formatted in Markdown or LaTeX.
#'
#' @method format_stats merMod
#' @family functions for printing statistical objects
#' @export
#'
#' @examples
#' test_lmer <- lme4::lmer(mpg ~ hp + (1 | cyl), data = mtcars)
#' test_glmer <- lme4::glmer(am ~ hp + (1 | cyl), data = mtcars, family = binomial)
#'
#' # Format linear mixed model term statistics
#' format_stats(test_lmer, term = "hp")
#'
#' # Format generalized linear mixed model term statistics
#' format_stats(test_glmer, term = "hp")
#'
#' # Remove italics
#' format_stats(test_lmer, term = "hp", italics = FALSE)
#'
#' # Change digits and add leading zero to p-value
#' format_stats(test_lmer, term = "hp", digits = 3, pdigits = 4, pzero = TRUE)
#'
#' # Format for LaTeX
#' format_stats(test_lmer, term = "hp", type = "latex")
format_stats.merMod <- function(x,
                                term = NULL,
                                digits = 3,
                                pdigits = 3,
                                pzero = FALSE,
                                full = TRUE,
                                italics = TRUE,
                                type = "md",
                                ...) {
  # Validate arguments
  if (is.null(term)) cli::cli_abort("No general model information is available for this type of model. Enter a term.")
  check_character(term)
  check_number_whole(digits, min = 0, allow_null = TRUE)
  check_number_whole(pdigits, min = 1, max = 5)
  check_bool(pzero)
  check_bool(full)
  check_bool(italics)
  check_string(type)
  check_match(type, c("md", "latex"))

  model_type <- ifelse(inherits(x, "glmerMod"), "glmer", "lmer")
  summ <- summary(x)

  terms <- rownames(summ$coefficients)
  stopifnot("Argument `term` not found in model terms." = term %in% terms)
  term_num <- which(terms == term)

  coeffs <- as.data.frame(summ$coefficients)
  estimate <- coeffs[term_num, "Estimate"]
  se <- coeffs[term_num, "Std. Error"]
  # For linear mixed model
  if (model_type == "lmer") {
    z <- coeffs[term_num, "t value"]
    p_value <- NULL
    z_lab <- "t"
    # For generalized linear mixed model
  } else {
    z <- coeffs[term_num, "z value"]
    p_value <- coeffs[term_num, "Pr(>|z|)"]
    z_lab <- "z"
    pvalue <- format_p(p_value,
                       digits = pdigits, pzero = pzero,
                       italics = italics, type = type
    )
  }

  # Format values
  stat_value <- format_num(estimate, digits = digits, pzero = TRUE)
  se_value <- format_num(se, digits = digits, pzero = TRUE)
  z_value <- format_num(z, digits = digits, pzero = TRUE)

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
  if (full && model_type == "lmer") {
    paste0(stat_label, " = ", stat_value, ", SE = ", se_value, ", ",
           format_chr(z_lab, italics = italics, type = type), " = ", z_value)
  } else if (full && model_type == "glmer") {
    paste0(stat_label, " = ", stat_value, ", SE = ", se_value, ", ",
           format_chr(z_lab, italics = italics, type = type), " = ",
           z_value, ", ", pvalue)
  } else if (!full && model_type == "lmer") {
    paste0(stat_label, " = ", stat_value)
  } else {
    paste0(stat_label, " = ", stat_value, ", ", pvalue)
  }
}
