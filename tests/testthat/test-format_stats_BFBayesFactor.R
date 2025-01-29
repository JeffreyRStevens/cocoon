
test_that("format_stats.BFBayesFactor() validates arguments properly", {
  suppressMessages(expect_error(
    format_stats(test_bf, digits1 = "xxx"),
    '`digits1` must be a whole number or `NULL`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_bf, digits1 = -1),
    "`digits1` must be a whole number larger than or equal to 0 or `NULL`, not the number -1"
  ))
  suppressMessages(expect_error(
    format_stats(test_bf, digits2 = "xxx"),
    '`digits2` must be a whole number or `NULL`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_bf, digits2 = -1),
    "`digits2` must be a whole number larger than or equal to 0 or `NULL`, not the number -1"
  ))
  suppressMessages(expect_error(
    format_stats(test_bf, cutoff = 0.5),
    "`cutoff` must be a number larger than or equal to 1 or `NULL`, not the number 0.5"
  ))
  suppressMessages(expect_error(
    format_stats(test_bf, cutoff = "xxx"),
    '`cutoff` must be a number or `NULL`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_bf, italics = "xxx"),
    '`italics` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_bf, type = "xxx"),
    '`type` must be "md" or "latex", not the string "xxx"'
  ))
})
