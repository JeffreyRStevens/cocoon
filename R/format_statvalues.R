
#' Format correlation statistics
#'
#' @encoding UTF-8
#' @description
#' `r lifecycle::badge("superseded")`
#'
#' With `format_corr()` you can format correlation statistics generated from
#' [cor.test()] output.
#' This is now an internal function superceded by [format_stats()], which we
#' recommend using instead.
#'
#' @inheritParams format_stats.htest
#'
#' @return
#' A character string of statistical information formatted in Markdown or LaTeX.
#' @export
#'
#' @family functions for printing statistical objects
#'
#' @examples
#' # format_stats(cor.test(mtcars$mpg, mtcars$cyl))
format_corr <- function(x,
                        digits,
                        pdigits,
                        pzero,
                        full,
                        italics,
                        type,
                        ...) {
  # Check input type
  stopifnot("Input must be a correlation object." =
              (inherits(x, what = "htest") && grepl("correlation", x$method)) |
              inherits(x, what = "easycorrelation"))

  # Validate arguments
  stopifnot("Input must be a correlation object." =
              inherits(x, what = "htest") && grepl("correlation", x$method))
  check_number_whole(digits, min = 0, allow_null = TRUE)
  check_number_whole(pdigits, min = 1, max = 5)
  check_bool(pzero)
  check_bool(full)
  check_bool(italics)
  check_string(type)
  check_match(type, c("md", "latex"))

  # Format numbers
  corr_method <- dplyr::case_when(
    grepl("Pearson", x$method) ~ "pearson",
    grepl("Kendall", x$method) ~ "kendall",
    grepl("Spearman", x$method) ~ "spearman"
  )
  stat_value <- format_num(x$estimate, digits = digits, pzero = pzero)
  if (corr_method == "pearson") {
    cis <- format_num(x$conf.int, digits = digits)
  } else {
    cis <- NULL
    full <- FALSE
  }
  pvalue <- format_p(x$p.value,
                     digits = pdigits, pzero = pzero,
                     italics = italics, type = type
  )

  # Build label
  stat_label <- dplyr::case_when(
    !italics & identical(corr_method, "pearson") ~
      "r",
    !italics & identical(corr_method, "spearman") & identical(type, "md") ~
      "\u03C1",
    !italics & identical(corr_method, "spearman") & identical(type, "latex") ~
      "\\textrho",
    !italics & identical(corr_method, "kendall") & identical(type, "md") ~
      "\u03C4",
    !italics & identical(corr_method, "kendall") & identical(type, "latex") ~
      "\\texttau",
    identical(corr_method, "pearson") ~
      format_chr("r", italics = italics, type = type),
    identical(corr_method, "kendall") & identical(type, "md") ~
      format_chr("\u03C4", italics = italics, type = type),
    identical(corr_method, "kendall") & identical(type, "latex") ~
      format_chr("\\rho", italics = italics, type = type),
    identical(corr_method, "spearman") & identical(type, "md") ~
      format_chr("\u03C1", italics = italics, type = type),
    identical(corr_method, "spearman") & identical(type, "latex") ~
      format_chr("\\tau", italics = italics, type = type)
  )

  # Create statistics string
  build_string(cis = cis,
               stat_label = stat_label,
               stat_value = stat_value,
               pvalue = pvalue,
               full = full)
}


#' Format t-test statistics
#'
#' @description
#' `r lifecycle::badge("superseded")`
#'
#' With `format_ttest()` you can format t-tests generated from [t.test()] and
#' [wilcox.test()] output.
#' This is now an internal function superceded by [format_stats()], which we
#' recommend using instead.
#'
#' @inheritParams format_stats.htest
#'
#' @return
#' A character string of statistical information formatted in Markdown or LaTeX.
#' @export
#'
#' @family functions for printing statistical objects
#'
#' @examples
#' format_stats(t.test(formula = mtcars$mpg ~ mtcars$vs))
format_ttest <- function(x,
                         digits,
                         pdigits,
                         pzero,
                         full,
                         italics,
                         dfs,
                         mean,
                         type) {
  # Format numbers
  ttest_method <- dplyr::case_when(
    grepl("t-test", x$method) ~ "student",
    grepl("Wilcoxon", x$method) ~ "wilcoxon"
  )

  if (ttest_method == "student") { # format data for Student's t-test
    if (length(x$estimate) == 2) {
      mean_value <- format_num(x$estimate[1] - x$estimate[2], digits = digits)
    } else if (length(x$estimate) == 1) {
      mean_value <- format_num(x$estimate, digits = digits)
    }
    cis <- format_num(x$conf.int, digits = digits)
    df <- dplyr::case_when(round(x$parameter, 1) == round(x$parameter) ~
                             format_num(x$parameter, digits = 0),
                           .default = format_num(x$parameter, digits = digits)
    )
    statlab <- "t"
  } else { # format data for Wilcoxon tests
    full <- FALSE
    dfs <- "none"
    df <- ""
    statlab <- attr(x$statistic, "name")
  }
  stat_value <- format_num(x$statistic, digits = digits)
  pvalue <- format_p(x$p.value,
                     digits = pdigits, pzero = pzero,
                     italics = italics, type = type
  )

  # Build label
  stat_label <- dplyr::case_when(
    !italics ~ paste0(statlab),
    identical(type, "md") ~ paste0("_", statlab, "_"),
    identical(type, "latex") ~ paste0("$", statlab, "$")
  )
  stat_label <- dplyr::case_when(identical(dfs, "par") ~
                                   paste0(stat_label, "(", df, ")"),
                                 identical(dfs, "sub") & identical(type, "md") ~
                                   paste0(stat_label, "~", df, "~"),
                                 identical(dfs, "sub") & identical(type, "latex") ~
                                   paste0(stat_label, "$_{", df, "}$"),
                                 .default = stat_label
  )[1]

  # Create statistics string
  if (full) {
    mean_label <- dplyr::case_when(
      identical(mean, "abbr") ~
        paste0(format_chr("M", italics = italics, type = type), " = "),
      identical(mean, "word") ~
        paste0(format_chr("Mean", italics = italics, type = type), " = ")
    )
  } else {
    mean_label <- mean_value <- cis <- NULL
  }

  build_string(mean_label = mean_label,
               mean_value = mean_value,
               cis = cis,
               stat_label = stat_label,
               stat_value = stat_value,
               pvalue = pvalue,
               full = full)

}

#' Format Bayes factors
#'
#' @description
#' `format_bf()` can input either a
#' [{BayesFactor}](https://cran.r-project.org/package=BayesFactor)
#' object or a vector of Bayes factor values. By default, this function rounds
#' Bayes factors greater than 1 to one decimal place and Bayes factors less
#' than 1 to two decimal places. Values greater than 1000 or less than 1/1000
#' are formatted using scientific notation. Cutoffs can be set that format the
#' values as greater than or less than the cutoffs (e.g., BF > 1000 or
#' BF < 0.001). Numbers of digits, cutoffs, italics, and label subscripts are
#' all customizable.
#'
#' @inheritParams format_stats.BFBayesFactor
#'
#' @return
#' A character string that includes label (by default _BF_~10~) and then the
#' Bayes factor formatted in Markdown or LaTeX. If Bayes factor is above or
#' below `cutoff`, `_BF_~10~ > <cutoff>` or `_BF_~10~ < 1 / <cutoff>` is used.
#' @export
#'
#' @family functions for printing statistical objects
#'
#' @examples
#' # Format BFBayesfactor objects from {BayesFactor} package
#' format_bf(BayesFactor::lmBF(mpg ~ am, data = mtcars))
#'
#' # Format Bayes factors > 1
#' format_bf(12.4444)
#'
#' # Bayes factors > 1000 will use scientific notation
#' format_bf(1244.44)
#'
#' # Control digits for Bayes factors > 1 with digits1
#' format_bf(1244.44, digits1 = 3)
#'
#' # Control cutoff for output
#' format_bf(1244.44, cutoff = 10000)
#'
#' # Format Bayes factors < 1
#' format_bf(0.111)
#'
#' # Bayes factors < 0.001 will use scientific notation
#' format_bf(0.0001)
#'
#' # Control digits for Bayes factors < 1 with digits2
#' format_bf(0.111, digits2 = 3)
#'
#' # Control cutoff for output
#' format_bf(0.001, cutoff = 100)
#'
#' # Return only Bayes factor value (no label)
#' format_bf(12.4444, label = "")
#'
#' # Format for LaTeX
#' format_bf(12.4444, type = "latex")
format_bf <- function(x,
                      digits1 = 1,
                      digits2 = 2,
                      cutoff = NULL,
                      label = "BF",
                      italics = TRUE,
                      subscript = "10",
                      type = "md") {
  # Check input type
  if (is.numeric(x)) {
    bf <- x
  } else if (inherits(x, what = "BFBayesFactor")) {
    bf <- BayesFactor::extractBF(x)$bf
  } else {
    stop("Input is not numeric or of class BFBayesFactor.")
  }

  # Validate arguments
  check_number_whole(digits1, min = 0, allow_null = TRUE)
  check_number_whole(digits2, min = 0, allow_null = TRUE)
  check_number_decimal(cutoff, min = 1, allow_null = TRUE)
  check_bool(italics)
  check_string(subscript)
  check_string(type)
  check_match(type, c("md", "latex"))

  # Build label
  if (label != "") {
    bf_lab <- paste0(format_chr(label, italics = italics, type = type),
                     format_sub(subscript, type = type))
    operator <- " = "
  } else {
    bf_lab <- ""
    operator <- ""
  }

  # Format Bayes factor
  if (is.null(cutoff)) {
    bf_value <- dplyr::case_when(
      bf >= 1000 ~ format_scientific(bf, digits = digits1, type = type),
      bf <= 1 / 10^digits2 ~ format_scientific(bf, digits = digits1, type = type),
      bf >= 1 ~ format_num(bf, digits = digits1),
      bf < 1 ~ format_num(bf, digits = digits2)
    )
  } else {
    bf_value <- dplyr::case_when(
      bf >= cutoff ~ format_num(cutoff, digits = 0),
      bf <= 1 / cutoff & format_num(1 / cutoff, digits = digits2) ==
        format_num(0, digits = digits2) ~
        sub("0$", "1", format_num(1 / cutoff, digits = 3)),
      bf <= 1 / cutoff ~ format_num(1 / cutoff, digits = digits2),
      bf <= 1 / 10^digits2 ~ as.character(1 / 10^digits2),
      bf >= 1 & bf <= cutoff ~ format_num(bf, digits = digits1),
      bf < 1 & bf >= 1 / cutoff ~ format_num(bf, digits = digits2)
    )
    operator <- dplyr::case_when(
      bf > cutoff ~ " > ",
      bf < 1 / cutoff ~ " < ",
      bf < 1 / 1 / 10^digits2 ~ " < ",
      .default = operator
    )
  }
  paste0(bf_lab, operator, bf_value)
}


#' Format p-values
#'
#' @description
#' `format_p()` inputs numeric vectors of p-values. Cutoffs can be set that
#' format the values as less than the cutoffs (e.g., p < 0.001). The default
#' output is APA formatted, but numbers of digits, cutoffs, leading zeros, and
#' italics are all customizable.
#'
#' @param x Number representing p-value.
#' @param digits Number of digits after the decimal for p-values, ranging
#' between 1-5 (also controls cutoff for small p-values).
#' @param pzero Logical value (default = FALSE) for whether to include leading
#' zero for p-values.
#' @param label Character string for label before p value. Default is p.
#' Set `label = ""` to return just the formatted p value with no
#' label or operator (`=`, `<`, `>`).
#' @param italics Logical value (default = TRUE) for whether label should be
#' italicized (_p_).
#' @param type Type of formatting ("md" = markdown, "latex" = LaTeX).
#'
#' @return
#' A character string that includes _p_ and then the p-value formatted in
#' Markdown or LaTeX. If p-value is below `digits` cutoff, `p < cutoff` is
#' used.
#' @export
#'
#' @examples
#' # Format p-value
#' format_p(0.001)
#'
#' # Format p-value vector
#' format_p(c(0.001, 0.01))
#'
#' # Round digits for p-values greater than cutoff
#' format_p(0.111, digits = 2)
#'
#' # Default cutoff is p < 0.001
#' format_p(0.0001)
#'
#' # Set cutoff with digits
#' format_p(0.0001, digits = 2)
#'
#' # Include leading zero
#' format_p(0.001, pzero = TRUE)
#'
#' # Return only Bayes factor value (no label)
#' format_p(0.001, label = "")
#'
#' # Format for LaTeX
#' format_p(0.001, type = "latex")
format_p <- function(x,
                     digits = 3,
                     pzero = FALSE,
                     label = "p",
                     italics = TRUE,
                     type = "md") {
  # Check arguments
  check_numeric(x)
  check_number_whole(digits, min = 1, max = 5, allow_null = TRUE)
  check_bool(pzero)
  check_bool(italics)
  check_string(type)
  check_match(type, c("md", "latex"))

  # Build label
  if (label != "") {
    p_lab <- paste0(format_chr(label, italics = italics, type = type))
    operator <- " = "
  } else {
    p_lab <- ""
    operator <- ""
  }
  # Build label
  ## Determine if using = or <
  cutoff <- as.numeric(paste0("1e-", digits))
  operator <- ifelse(label != "" & x < cutoff, " < ", operator)
  ## Format pvalue
  pvalue <- dplyr::case_when(
    x < cutoff & pzero ~
      as.character(as.numeric(paste0("1e-", digits))),
    x < cutoff & !pzero ~
      sub("0\\.", "\\.", as.character(as.numeric(paste0("1e-", digits)))),
    x >= cutoff & pzero ~
      format_num(x, digits = digits),
    x >= cutoff & !pzero ~
      sub("0\\.", "\\.", format_num(x, digits = digits))
  )
  paste0(p_lab, operator, pvalue)
}


