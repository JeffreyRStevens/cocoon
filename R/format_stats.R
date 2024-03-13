#' Format correlation statistics
#'
#' @encoding UTF-8
#' @description
#' With `format_corr()` you can format correlation statistics generated from
#' `cor.test()` output. This detects whether the object is from a Pearson,
#' Spearman, or Kendall correlation and reports the appropriate correlation
#' label (r, \eqn{\tau}, \eqn{\rho}). The default output is APA formatted, but numbers of digits,
#' leading zeros, the presence of confidence intervals, and italics are all
#' customizable.
#'
#' @param x Correlation object
#' @param digits Number of digits after the decimal for means, confidence
#' intervals, and correlation coefficients
#' @param pdigits Number of digits after the decimal for p-values, ranging
#' between 1-5 (also controls cutoff for small p-values)
#' @param pzero Logical value (default = FALSE) for whether to include
#' leading zero for p-values
#' @param ci Logical value (default = TRUE) for whether to print
#' 95% confidence intervals
#' @param italics Logical value (default = TRUE) for whether _p_ label should be
#' italicized
#' @param type Type of formatting ("md" = markdown, "latex" = LaTeX)
#'
#' @return
#' A character string of statistical information formatted in Markdown or LaTeX.
#' @export
#'
#' @family functions for printing statistical objects
#'
#' @examples
#' # Prepare data
#' mtcars_corr <- cor.test(mtcars$mpg, mtcars$disp)
#' # Print statistics
#' format_corr(mtcars_corr)
#' # Change digits
#' format_corr(mtcars_corr, digits = 3)
#' # Change cutoff digits for p-value
#' format_corr(mtcars_corr, pdigits = 2)
#' # Add leading zero to p-value and don't print confidence intervals
#' format_corr(mtcars_corr, pzero = TRUE, ci = FALSE)
format_corr <- function(x,
                        digits = 2,
                        pdigits = 3,
                        pzero = FALSE,
                        ci = TRUE,
                        italics = TRUE,
                        type = "md") {
  # Check arguments
  stopifnot("Input must be a correlation object." = inherits(x, what = "htest") && grepl("correlation", x$method))
  stopifnot("Argument `digits` must be a non-negative numeric vector." = is.numeric(digits))
  stopifnot("Argument `digits` must be a non-negative numeric vector." = digits >= 0)
  stopifnot("Argument `pdigits` must be a numeric between 1 and 5." = is.numeric(pdigits))
  stopifnot("Argument `pdigits` must be a numeric between 1 and 5." = pdigits > 0)
  stopifnot("Argument `pdigits` must be a numeric between 1 and 5." = pdigits < 6)
  stopifnot("Argument `pzero` must be TRUE or FALSE." = is.logical(pzero))
  stopifnot("Argument `ci` must be TRUE or FALSE." = is.logical(ci))
  stopifnot("Argument `italics` must be TRUE or FALSE." = is.logical(italics))
  stopifnot("Argument `type` must be 'md' or 'latex'." = type %in% c("md", "latex"))

  # Format numbers
  corr_method <- dplyr::case_when(
    grepl("Pearson", x$method) ~ "pearson",
    grepl("Kendall", x$method) ~ "kendall",
    grepl("Spearman", x$method) ~ "spearman"
  )
  corr <- format_num(x$estimate, digits = digits, pzero = pzero)
  if (corr_method == "pearson") {
    cis <- format_num(x$conf.int, digits = digits)
  } else {
    cis <- NULL
    ci <- FALSE
  }
  pvalue <- format_p(x$p.value,
    digits = pdigits, pzero = pzero,
    italics = italics, type = type
  )

  # Build label
  r_lab <- dplyr::case_when(
    !italics & identical(corr_method, "pearson") ~ paste0("r"),
    !italics & identical(corr_method, "spearman") & identical(type, "md") ~ paste0("\u03C1"),
    !italics & identical(corr_method, "spearman") & identical(type, "latex") ~ paste0("\\rho"),
    !italics & identical(corr_method, "kendall") & identical(type, "md") ~ paste0("\u03C4"),
    !italics & identical(corr_method, "kendall") & identical(type, "latex") ~ paste0("\\tau"),
    identical(corr_method, "pearson") ~ paste0(format_chr("r", italics = italics, type = type)),
    identical(corr_method, "kendall") ~ paste0(format_chr("\u03C4", italics = italics, type = type)),
    identical(corr_method, "spearman") ~ paste0(format_chr("\u03C1", italics = italics, type = type)),
  )

  # Create statistics string
  full_lab <- dplyr::case_when(
    ci & corr_method == "pearson" ~ paste0(r_lab, " = ", corr, ", 95% CI [", cis[1], ", ", cis[2], "], ", pvalue),
    !ci ~ paste0(r_lab, " = ", corr, ", ", pvalue)
  )
  return(full_lab)
}


#' Format t-test statistics
#'
#' @description
#' With `format_ttest()` you can format t-tests generated from `t.test()` and
#' `wilcox.test()` output. The default output is APA formatted, but numbers of
#' digits, leading zeros, the presence of means and confidence intervals,
#' italics, degrees of freedom, and mean labels are all customizable.
#'
#' @param x t-test object
#' @param digits Number of digits after the decimal for means, confidence
#' intervals, and t-statistics
#' @param pdigits Number of digits after the decimal for p-values, ranging
#' between 1-5 (also controls cutoff for small p-values)
#' @param pzero Logical value (default = FALSE) for whether to include
#' leading zero for p-values
#' @param full Logical value (default = TRUE) for whether to include means
#' and confidence intervals or just t-statistic and p-value
#' @param italics Logical value (default = TRUE) for whether _p_ label should be
#' italicized
#' @param dfs Formatting for degrees of freedom ("par" = parenthetical,
#' "sub" = subscript, "none" = do not print degrees of freedom)
#' @param mean Formatting for mean label ("abbr" = M, "word" = Mean)
#' @param type Type of formatting ("md" = markdown, "latex" = LaTeX)
#'
#' @return
#' A character string of statistical information formatted in Markdown or LaTeX.
#' @export
#'
#' @family functions for printing statistical objects
#'
#' @examples
#' # Prepare data
#' mtcars_tt <- t.test(formula = mtcars$mpg ~ mtcars$vs)
#' # Print statistics
#' format_ttest(mtcars_tt)
#' # Change digits
#' format_ttest(mtcars_tt, digits = 2)
#' # Change cutoff digits for p-value
#' format_ttest(mtcars_tt, pdigits = 2)
#' # Add leading zero to p-value and don't print confidence intervals
#' format_ttest(mtcars_tt, pzero = TRUE, full = FALSE)
format_ttest <- function(x,
                         digits = 1,
                         pdigits = 3,
                         pzero = FALSE,
                         full = TRUE,
                         italics = TRUE,
                         dfs = "par",
                         mean = "abbr",
                         type = "md") {
  # Check arguments
  stopifnot("Input must be a correlation object." = inherits(x, what = "htest") && (grepl("t-test", x$method) | grepl("Wilcoxon", x$method)))
  stopifnot("Argument `digits` must be a non-negative numeric vector." = is.numeric(digits))
  stopifnot("Argument `digits` must be a non-negative numeric vector." = digits >= 0)
  stopifnot("Argument `pdigits` must be a numeric between 1 and 5." = is.numeric(pdigits))
  stopifnot("Argument `pdigits` must be a numeric between 1 and 5." = pdigits > 0)
  stopifnot("Argument `pdigits` must be a numeric between 1 and 5." = pdigits < 6)
  stopifnot("Argument `pzero` must be TRUE or FALSE." = is.logical(pzero))
  stopifnot("Argument `full` must be TRUE or FALSE." = is.logical(full))
  stopifnot("Argument `italics` must be TRUE or FALSE." = is.logical(italics))
  stopifnot("Argument `dfs` must be 'par', 'sub', or 'none'." = dfs %in% c("par", "sub", "none"))
  stopifnot("Argument `mean` must be 'abbr' or 'word'." = mean %in% c("abbr", "word"))
  stopifnot("Argument `type` must be 'md' or 'latex'." = type %in% c("md", "latex"))

  # Format numbers
  ttest_method <- dplyr::case_when(
    grepl("t-test", x$method) ~ "student",
    grepl("Wilcoxon", x$method) ~ "wilcoxon"
  )

  if (ttest_method == "student") { # format data for Student's t-test
    if (length(x$estimate) == 2) {
      mean_val <- format_num(x$estimate[1] - x$estimate[2], digits = digits)
    } else if (length(x$estimate) == 1) {
      mean_val <- format_num(x$estimate, digits = digits)
    }
    cis <- format_num(x$conf.int, digits = digits)
    df <- dplyr::case_when(round(x$parameter, 1) == round(x$parameter) ~ format_num(x$parameter, digits = 0),
      .default = format_num(x$parameter, digits = digits)
    )
    statlab <- "t"
  } else { # format data for Wilcoxon tests
    full <- FALSE
    dfs <- "none"
    df <- ""
    statlab <- attr(x$statistic, "name")
  }
  tstat <- format_num(x$statistic, digits = digits)
  pvalue <- format_p(x$p.value,
    digits = pdigits, pzero = pzero,
    italics = italics, type = type
  )

  # Build label
  t_lab <- dplyr::case_when(
    !italics ~ paste0(statlab),
    identical(type, "md") ~ paste0("_", statlab, "_"),
    identical(type, "latex") ~ paste0("$", statlab, "$")
  )
  tlab <- dplyr::case_when(identical(dfs, "par") ~ paste0(t_lab, "(", df, ")"),
    identical(dfs, "sub") & identical(type, "md") ~ paste0(t_lab, "~", df, "~"),
    identical(dfs, "sub") & identical(type, "latex") ~ paste0(t_lab, "$_{", df, "}$"),
    .default = t_lab
  )[1]

  # Create statistics string
  if (full) {
    mean_lab <- dplyr::case_when(
      identical(mean, "abbr") ~ paste0(format_chr("M", italics = italics, type = type), " = "),
      identical(mean, "word") ~ paste0(format_chr("Mean", italics = italics, type = type), " = ")
    )
    paste0(mean_lab, mean_val, ", 95% CI [", cis[1], ", ", cis[2], "], ", tlab, " = ", tstat, ", ", pvalue)
  } else {
    paste0(tlab, " = ", tstat, ", ", pvalue)
  }
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
#' # Format Bayes factors > 1
#' format_bf(12.4444)
#' # Bayes factors > 1000 will use scientific notation
#' format_bf(1244.44)
#' # Control digits for Bayes factors > 1 with digits1
#' format_bf(1244.44, digits1 = 3)
#' # Control cutoff for output
#' format_bf(1244.44, cutoff = 10000)
#' # Format Bayes factors < 1
#' format_bf(0.111)
#' # Bayes factors < 0.001 will use scientific notation
#' format_bf(0.0001)
#' # Control digits for Bayes factors < 1 with digits2
#' format_bf(0.111, digits2 = 3)
#' # Control cutoff for output
#' format_bf(0.001, cutoff = 100)
#' # Return only Bayes factor value (no label)
#' format_bf(12.4444, label = "")
format_bf <- function(x,
                      digits1 = 1,
                      digits2 = 2,
                      cutoff = NULL,
                      label = "BF",
                      italics = TRUE,
                      subscript = "10",
                      type = "md") {
  # Check arguments
  if (is.numeric(x)) {
    bf <- x
  } else if (inherits(x, what = "BFBayesFactor")) {
    bf <- BayesFactor::extractBF(x)$bf
  } else {
    stop("Input is not numeric or of class BFBayesFactor.")
  }
  stopifnot("Argument `digits1` must be a non-negative numeric vector." = is.numeric(digits1))
  stopifnot("Argument `digits1` must be a non-negative numeric vector." = digits1 >= 0)
  stopifnot("Argument `digits2` must be a non-negative numeric vector." = is.numeric(digits2))
  stopifnot("Argument `digits2` must be a non-negative numeric vector." = digits2 >= 0)
  stopifnot("Argument `cutoff` must be a numeric vector greater than 1 or NULL." = (is.numeric(cutoff) & cutoff > 1) | is.null(cutoff))
  stopifnot("Argument `italics` must be TRUE or FALSE." = is.logical(italics))
  stopifnot("Argument `subscript` must be a character string (usually '10', '01', or '')." = is.character(subscript))
  stopifnot("Argument `type` must be 'md' or 'latex'." = type %in% c("md", "latex"))

  # Build label
  if (label != "") {
    bf_lab <- paste0(format_chr(label, italics = italics, type = type), format_sub(subscript, type = type))
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
      bf >= cutoff ~ as.character(cutoff),
      bf <= 1 / cutoff ~ as.character(1 / cutoff),
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
#' @param x Number representing p-value
#' @param digits Number of digits after the decimal for p-values, ranging
#' between 1-5 (also controls cutoff for small p-values)
#' @param pzero Logical value (default = FALSE) for whether to include leading
#' zero for p-values
#' @param label Character string for label before p value. Default is p.
#' Set `label = ""` to return just the formatted p value with no
#' label or operator (`=`, `<`, `>`)
#' @param italics Logical value (default = TRUE) for whether label should be
#' italicized (_p_)
#' @param type Type of formatting ("md" = markdown, "latex" = LaTeX)
#'
#' @return
#' A character string that includes _p_ and then the p-value formatted in
#' Markdown or LaTeX. If p-value is below `digits` cutoff, `p < cutoff` is
#' used.
#' @export
#'
#' @examples
#' format_p(0.001)
#' # Round digits for p-values greater than cutoff
#' format_p(0.111, digits = 2)
#' # Default cutoff is p < 0.001
#' format_p(0.0001)
#' # Set cutoff with digits
#' format_p(0.0001, digits = 2)
#' # Include leading zero
#' format_p(0.001, pzero = TRUE)
#' # Return only Bayes factor value (no label)
#' format_p(0.001, label = "")
format_p <- function(x,
                     digits = 3,
                     pzero = FALSE,
                     label = "p",
                     italics = TRUE,
                     type = "md") {
  # Check arguments
  stopifnot("Input must be a numeric vector." = is.numeric(x))
  stopifnot("Argument `digits` must be a numeric between 1 and 5." = is.numeric(digits))
  stopifnot("Argument `digits` must be a numeric between 1 and 5." = digits > 0)
  stopifnot("Argument `digits` must be a numeric between 1 and 5." = digits < 6)
  stopifnot("Argument `pzero` must be TRUE or FALSE." = is.logical(pzero))
  stopifnot("Argument `italics` must be TRUE or FALSE." = is.logical(italics))
  stopifnot("Argument `type` must be 'md' or 'latex'." = type %in% c("md", "latex"))

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
    x < cutoff & pzero ~ as.character(as.numeric(paste0("1e-", digits))),
    x < cutoff & !pzero ~ sub("0\\.", "\\.", as.character(as.numeric(paste0("1e-", digits)))),
    x >= cutoff & pzero ~ format_num(x, digits = digits),
    x >= cutoff & !pzero ~ sub("0\\.", "\\.", format_num(x, digits = digits))
  )
  paste0(p_lab, operator, pvalue)
}


#' Calculate and format summary statistics of central tendency and error
#'
#' `format_summary()` is a general function that allows you to either
#' automatically calculate mean/median and a measure of error from a data vector
#' or specify already calculated a mean/median and either an error interval or
#' error limits. Error measures include confidence intervals, standard
#' deviation, and standard error of the mean. Each of those has a specific
#' function that formats means and those error measures using APA (7th edition)
#' style. So `format_meanci()`, `format_meansd()`, `format_meanse()`, and
#' `format_medianiqr()` are wrappers around `format_summary()` for specific
#' error measures with a default style. To just format the mean or median with
#' no error, use `format_mean()` or `format_median()`. All measures ignore NAs.
#'
#' @param x Numeric vector of data to calculate mean and error
#' @param tendency Character vector specifying measure of central
#' tendency ("mean" = mean, "median" = median)
#' @param error Character vector specifying error type ("ci" = confidence
#' interval, "se" = standard error of the mean, "sd" = standard deviation, "iqr"
#' = interquartile range)
#' @param values Numeric vector of mean and interval or mean and lower and upper
#' limits
#' @param digits Number of digits after the decimal for means and error
#' @param tendlabel Formatting for tendency label ("abbr" = M, "word" = Mean,
#' "none" = no label)
#' @param italics Logical value (default = TRUE) for whether mean label should
#' be italicized
#' @param subscript Character string to include as subscript with mean label
#' @param units Character string that gives units to include after mean value
#' @param display Character vector specifying how to display error ("limits" =
#' \[lower limit, upper limit\], "pm" = ±interval, "par" = (interval), "none" =
#' do not display error)
#' @param cilevel Numeric scalar from 0-1 defining confidence level
#' (defaults to 0.95)
#' @param errorlabel Logical value (default = TRUE) for whether error label (e.g., 95% CI) should be
#' included
#' @param type Type of formatting ("md" = markdown, "latex" = LaTeX)
#'
#' @return A character string of mean and error formatted in Markdown or LaTeX.
#' To return only the mean (no error), set `display = "none"`.
#' @export
#'
#' @examples
#' # Print mean and 95% confidence limits for fuel efficiency
#' format_meanci(mtcars$mpg)
#' # Print mean and standard deviation
#' format_meansd(mtcars$mpg)
#' # Print mean and standard error of the mean
#' format_meanse(mtcars$mpg)
#' # Print mean
#' format_mean(mtcars$mpg)
#' # Print mean and 95% confidence limits with no label for "95% CI"
#' format_meanci(mtcars$mpg, errorlabel = FALSE)
#' # Print mean and standard error of the mean as plus/minus interval
#' format_meanse(mtcars$mpg, error = "se", display = "pm")
#' # Print mean and 90% confidence limits with units
#' format_meanci(mtcars$mpg, units = "cm", cilevel = 0.9)
#' # Print three-digit mean with subscript in LaTeX
#' format_summary(mtcars$mpg, digits = 3, subscript = "control", display = "none", type = "latex")
format_summary <- function(x = NULL,
                           tendency = "mean",
                           error = "ci",
                           values = NULL,
                           digits = 1,
                           tendlabel = "abbr",
                           italics = TRUE,
                           subscript = NULL,
                           units = NULL,
                           display = "limits",
                           cilevel = 0.95,
                           errorlabel = TRUE,
                           type = "md") {
  # Check arguments
  if (!is.null(x)) {
    stopifnot("Argument `x` must be a numeric vector." = is.numeric(x))
    stopifnot('Specify `tendency` as "mean" or "median".' = tendency %in% c("mean", "median"))
    stopifnot('Specify `error` as "ci", "sd", "se", or "iqr".' = error %in% c("ci", "sd", "se", "iqr"))
    xtendency <- dplyr::case_when(
      identical(tendency, "mean") ~ mean(x, na.rm = TRUE),
      identical(tendency, "median") ~ median(x, na.rm = TRUE)
    )
    xn <- sum(!is.na(x))
    stopifnot("Less than two non-missing values in vector, so no confidence interval can be computed." = xn > 1)
    xlimit <- 1 - (1 - cilevel) / 2
    xsd <- stats::sd(x, na.rm = TRUE)
    xse <- xsd / sqrt(xn)
    xci <- stats::qt(xlimit, df = (xn - 1)) * xse
    xiqr <- stats::IQR(x)
    xlower <- dplyr::case_when(
      identical(error, "ci") ~ xtendency - xci,
      identical(error, "sd") ~ xtendency - xsd,
      identical(error, "se") ~ xtendency - xse,
      identical(error, "iqr") ~ xtendency - xiqr
    )
    xupper <- dplyr::case_when(
      identical(error, "ci") ~ xtendency + xci,
      identical(error, "sd") ~ xtendency + xsd,
      identical(error, "se") ~ xtendency + xse,
      identical(error, "iqr") ~ xtendency + xiqr
    )
    xinterval <- xtendency - xlower
  } else if (!is.null(values)) {
    stopifnot("Argument `values` must be a numeric vector." = is.numeric(values))
    stopifnot("Argument `values` must be a vector with two or three elements." = length(values) %in% c(2, 3))
    if (length(values) == 2) {
      xtendency <- values[1]
      xinterval <- values[2]
      xlower <- xtendency - xinterval
      xupper <- xtendency + xinterval
    } else {
      stopifnot("Argument `values` must include the mean followed by the lower CI limit then the upper CI limit." = values[1] >= values[2] & values[1] <= values[3])
      xtendency <- values[1]
      xlower <- values[2]
      xupper <- values[3]
      xinterval <- xtendency - xlower
    }
  } else {
    stop("You must include either the `x` or `values` argument.")
  }
  stopifnot('Specify `tendlabel` as "abbr", "word", or "none".' = tendlabel %in% c("abbr", "word", "none"))
  stopifnot("The `units` argument must be a character vector or NULL" = is.character(units) | is.null(units))
  stopifnot('Specify `display` as "limits", "pm", "par", or "none".' = display %in% c("limits", "pm", "par", "none"))

  # Build mean
  # subname <- ifelse(!is.null(subscript), subscript, "")
  unit <- dplyr::case_when(
    !is.null(units) ~ paste0(" ", units),
    .default = ""
  )
  mean_lab <- dplyr::case_when(
    identical(tendlabel, "none") ~ "",
    identical(tendency, "mean") & identical(tendlabel, "abbr") ~
      paste0(format_chr("M", italics = italics, type = type), format_sub(subscript, type = type), " = "),
    identical(tendency, "mean") & identical(tendlabel, "word") ~
      paste0(format_chr("Mean", italics = italics, type = type), format_sub(subscript, type = type), " = "),
    identical(tendency, "median") & identical(tendlabel, "abbr") ~
      paste0(format_chr("Mdn", italics = italics, type = type), format_sub(subscript, type = type), " = "),
    identical(tendency, "median") & identical(tendlabel, "word") ~
      paste0(format_chr("Median", italics = italics, type = type), format_sub(subscript, type = type), " = ")
  )
  full_mean <- paste0(mean_lab, format_num(xtendency, digits = digits), unit)

  # Add error
  error_lab <- dplyr::case_when(
    !errorlabel ~ "",
    identical(error, "ci") ~ paste0(cilevel * 100, "% CI"),
    identical(error, "sd") ~ paste0(format_chr("SD", italics = italics, type = type)),
    identical(error, "se") ~ paste0(format_chr("SE", italics = italics, type = type)),
    identical(error, "iqr") ~ paste0(format_chr("IQR", italics = italics, type = type))
  )
  full_error <- dplyr::case_when(
    identical(display, "limits") ~ paste0(", ", error_lab, " [", format_num(xlower, digits = digits), ", ", format_num(xupper, digits = digits), "]"),
    identical(display, "pm") ~ paste0(" \u00b1 ", format_num(xinterval, digits = digits)),
    identical(display, "par") ~ paste0(" ", "(", error_lab, " = ", format_num(xinterval, digits = digits), ")"),
    .default = ""
  )
  paste0(full_mean, full_error)
}

#' @rdname format_summary
#' @export
format_mean <- function(x = NULL,
                        tendency = "mean",
                        values = NULL,
                        digits = 1,
                        tendlabel = "abbr",
                        italics = TRUE,
                        subscript = NULL,
                        units = NULL,
                        display = "none",
                        type = "md") {
  format_summary(x = x, tendency = tendency, values = values, digits = digits, tendlabel = tendlabel, italics = italics, subscript = subscript, units = units, display = display, type = type)
}

#' @rdname format_summary
#' @export
format_meanci <- function(x = NULL,
                          tendency = "mean",
                          error = "ci",
                          values = NULL,
                          digits = 1,
                          tendlabel = "abbr",
                          italics = TRUE,
                          subscript = NULL,
                          units = NULL,
                          display = "limits",
                          cilevel = 0.95,
                          errorlabel = TRUE,
                          type = "md") {
  format_summary(x = x, tendency = tendency, error = error, values = values, digits = digits, tendlabel = tendlabel, italics = italics, subscript = subscript, units = units, display = display, cilevel = cilevel, errorlabel = errorlabel, type = type)
}

#' @rdname format_summary
#' @export
format_meanse <- function(x = NULL,
                          tendency = "mean",
                          error = "se",
                          values = NULL,
                          digits = 1,
                          tendlabel = "abbr",
                          italics = TRUE,
                          subscript = NULL,
                          units = NULL,
                          display = "par",
                          errorlabel = TRUE,
                          type = "md") {
  format_summary(x = x, tendency = tendency, error = error, values = values, digits = digits, tendlabel = tendlabel, italics = italics, subscript = subscript, units = units, display = display, errorlabel = errorlabel, type = type)
}

#' @rdname format_summary
#' @export
format_meansd <- function(x = NULL,
                          tendency = "mean",
                          error = "sd",
                          values = NULL,
                          digits = 1,
                          tendlabel = "abbr",
                          italics = TRUE,
                          subscript = NULL,
                          units = NULL,
                          display = "par",
                          errorlabel = TRUE,
                          type = "md") {
  format_summary(x = x, tendency = tendency, error = error, values = values, digits = digits, tendlabel = tendlabel, italics = italics, subscript = subscript, units = units, display = display, errorlabel = errorlabel, type = type)
}

#' @rdname format_summary
#' @export
format_median <- function(x = NULL,
                          tendency = "median",
                          values = NULL,
                          digits = 1,
                          tendlabel = "abbr",
                          italics = TRUE,
                          subscript = NULL,
                          units = NULL,
                          display = "none",
                          type = "md") {
  format_summary(x = x, tendency = tendency, values = values, digits = digits, tendlabel = tendlabel, italics = italics, subscript = subscript, units = units, display = display, type = type)
}

#' @rdname format_summary
#' @export
format_medianiqr <- function(x = NULL,
                             tendency = "median",
                             error = "iqr",
                             values = NULL,
                             digits = 1,
                             tendlabel = "abbr",
                             italics = TRUE,
                             subscript = NULL,
                             units = NULL,
                             display = "par",
                             errorlabel = TRUE,
                             type = "md") {
  format_summary(x = x, tendency = tendency, error = error, values = values, digits = digits, tendlabel = tendlabel, italics = italics, subscript = subscript, units = units, display = display, errorlabel = errorlabel, type = type)
}
