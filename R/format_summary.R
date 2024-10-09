#' Calculate and format summary statistics of central tendency and error
#'
#' `format_summary()` is a general function that allows you to either
#' automatically calculate mean/median and a measure of error from a data vector
#' or specify already calculated a mean/median and either an error interval or
#' error limits. Error measures include confidence intervals, standard
#' deviation, and standard error of the mean. Each of those has a specific
#' function that formats means and those error measures using APA (7th edition)
#' style. So [format_meanci()], [format_meansd()], [format_meanse()], and
#' [format_medianiqr()] are wrappers around [format_summary()] for specific
#' error measures with a default style. To just format the mean or median with
#' no error, use [format_mean()] or [format_median()]. All measures ignore NAs.
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
#'
#' # Print mean and standard deviation
#' format_meansd(mtcars$mpg)
#'
#' # Print mean and standard error of the mean
#' format_meanse(mtcars$mpg)
#'
#' # Print mean
#' format_mean(mtcars$mpg)
#'
#' # Print mean and 95% confidence limits with no label for "95% CI"
#' format_meanci(mtcars$mpg, errorlabel = FALSE)
#'
#' # Print mean and standard error of the mean as plus/minus interval
#' format_meanse(mtcars$mpg, error = "se", display = "pm")
#'
#' # Print mean and 90% confidence limits with units
#' format_meanci(mtcars$mpg, units = "cm", cilevel = 0.9)
#'
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


#' @keywords internal
build_string <- function(mean_label = NULL,
                         mean_value = NULL,
                         cis = NULL,
                         stat_label,
                         stat_value,
                         pvalue,
                         full) {
  dplyr::case_when(full & !is.null(mean_label) & !is.null(mean_value) & !is.null(cis) ~
                     paste0(mean_label, mean_value, ", 95% CI [", cis[1], ", ", cis[2], "], ", stat_label, " = ", stat_value, ", ", pvalue),
                   full & is.null(mean_label) & is.null(mean_value) & !is.null(cis) ~
                     paste0(stat_label, " = ", stat_value, ", 95% CI [", cis[1], ", ", cis[2], "], ", pvalue),
                   !full | (is.null(mean_label) & !is.null(mean_value) & !is.null(cis)) ~
                     paste0(stat_label, " = ", stat_value, ", ", pvalue))
}



