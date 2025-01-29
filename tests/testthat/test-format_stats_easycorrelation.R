
test_that("easycorrelation correlations are validated properly", {
  suppressMessages(expect_error(
    format_stats(test_easycorr, digits = "xxx"),
    '`digits` must be a whole number or `NULL`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, digits = -1),
    "`digits` must be a whole number larger than or equal to 0 or `NULL`, not the number -1"
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, digits = 1.5),
    "`digits` must be a whole number or `NULL`, not the number 1.5"
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, pdigits = "xxx"),
    '`pdigits` must be a whole number, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, pdigits = 0),
    "`pdigits` must be a whole number between 1 and 5, not the number 0"
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, pdigits = 7),
    "`pdigits` must be a whole number between 1 and 5, not the number 7"
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, pzero = "xxx"),
    '`pzero` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, full = "xxx"),
    '`full` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, italics = "xxx"),
    '`italics` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, type = "xxx"),
    '`type` must be "md" or "latex", not the string "xxx"'
  ))
})


test_that("formatting easycorrelations works properly", {
  expect_equal(format_stats(test_easycorr), "_r_ = -.12, 95% CI [-0.70, 0.55], _p_ = .748")
  expect_equal(format_stats(test_easycorr2), "_ρ_ = -.03, _p_ = .933")
  expect_equal(format_stats(test_easycorr3), "_τ_ = .00, _p_ = 1.000")
  expect_equal(format_stats(test_easycorr, digits = 3), "_r_ = -.117, 95% CI [-0.695, 0.553], _p_ = .748")
  expect_equal(format_stats(test_easycorr, pdigits = 2), "_r_ = -.12, 95% CI [-0.70, 0.55], _p_ = .75")
  expect_equal(format_stats(test_easycorr, pzero = TRUE), "_r_ = -0.12, 95% CI [-0.70, 0.55], _p_ = 0.748")
  expect_equal(format_stats(test_easycorr, full = FALSE), "_r_ = -.12, _p_ = .748")
  expect_equal(format_stats(test_easycorr, italics = FALSE), "r = -.12, 95% CI [-0.70, 0.55], p = .748")
  expect_equal(format_stats(test_easycorr, type = "latex"), "$r$ = -.12, 95% CI [-0.70, 0.55], $p$ = .748")
})
