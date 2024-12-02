#' Format numbers
#'
#' @param x Number.
#' @param digits Number of digits after the decimal.
#' @param pzero Logical value (default = TRUE) for whether to include leading
#' zero numbers less than 1.
#'
#' @return
#' A character string formatting the number with specified number of digits
#' after the decimal.
#' @export
#'
#' @examples
#' format_num(pi, digits = 2)
#' format_num(pi, digits = 4)
format_num <- function(x,
                       digits = 1,
                       pzero = TRUE) {
  # Check arguments
  check_numeric(x)
  check_number_whole(digits, min = 0)

  # Format number
  dplyr::case_when(
    !pzero ~ sub("0\\.", "\\.", formatC(x, digits = digits, format = "f")),
    pzero ~ formatC(x, digits = digits, format = "f")
  )
}


#' Format numbers in scientific notation
#'
#' @param x Number.
#' @param digits Number of digits after the decimal.
#' @param type Type of formatting ("md" = markdown, "latex" = LaTeX).
#'
#' @return
#' A character string of a number in scientific notation formatted in Markdown
#' or LaTeX.
#' @export
#'
#' @examples
#' format_scientific(1111)
#' # Control number of digits after decimal with digits
#' format_scientific(1111, digits = 3)
format_scientific <- function(x,
                              digits = 1,
                              type = "md") {
  # Check arguments
  check_numeric(x)
  check_number_whole(digits, min = 1)
  check_match(type, c("md", "latex"))

  # Format number
  num <- formatC(x, digits = digits, format = "e")
  num <- gsub("e\\+00$", "", num)
  num <- dplyr::case_when(
    identical(type, "md") ~ gsub("e\\+0?(\\d+)", "\u00D710^\\1^", num),
    identical(type, "latex") ~ gsub("e\\+0?(\\d+)$", " \\\\times 10\\^\\{\\1\\}", num),
    .default = num
  )
  num <- dplyr::case_when(
    identical(type, "md") ~ gsub("e\\-0?(\\d+)", "\u00D710^-\\1^", num),
    identical(type, "latex") ~ gsub("e\\-0?(\\d+)$", " \\\\times 10\\^\\{-\\1\\}", num),
    .default = num
  )
  num
}

#' Format character strings with italics and type
#'
#' @param x Character string.
#' @param italics Logical value (default = TRUE) for whether text should be
#' italicized.
#' @param type Type of formatting (`"md"` = markdown, `"latex"` = LaTeX).
#'
#' @return
#' A character string that has either Markdown or LaTeX formatting for italics
#' or not.
#' @export
#'
#' @examples
#' format_chr("Hello world!")
#' # Format in LaTeX syntax
#' format_chr("Hello world!", type = "latex")
#' # Remove italics
#' format_chr("Hello world!", italics = FALSE)
format_chr <- function(x,
                       italics = TRUE,
                       type = "md") {
  # Check arguments
  check_string(x)
  check_bool(italics)
  check_match(type, c("md", "latex"))
  dplyr::case_when(
    italics & type == "md" ~ paste0("_", x, "_"),
    italics & type == "latex" ~ paste0("$", x, "$"),
    !italics ~ x
  )
}


#' Format subscript text
#'
#' @param subscript Character string or NULL.
#' @param type Type of formatting (`"md"` = markdown, `"latex"` = LaTeX).
#'
#' @return
#' A character string that is formatted as subscript for either Markdown or
#' LaTeX.
#' @export
#'
#' @examples
#' format_sub("Hello world!")
#' # Format in LaTeX syntax
#' format_sub("Hello world!", type = "latex")
format_sub <- function(subscript = NULL,
                       type = "md") {
  # Check arguments
  check_string(subscript, allow_null = TRUE)
  check_match(type, c("md", "latex"))
  dplyr::case_when(
    subscript == "" ~ "",
    !is.null(subscript) & type == "md" ~ paste0("~", subscript, "~"),
    !is.null(subscript) & type == "latex" ~ paste0("$_{", subscript, "}$"),
    .default = ""
  )
}
