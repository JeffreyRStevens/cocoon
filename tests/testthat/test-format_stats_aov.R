
test_that("aov ANOVAs are validated properly", {
  suppressMessages(expect_error(
    format_stats(test_aov),
    "`term` must be a character vector, not absent"
  ))
  suppressMessages(expect_error(
    format_stats(test_aov, term = "d"),
    "Argument `term` not found in model terms"
  ))
  suppressMessages(expect_error(
    format_stats(test_aov, term = "c", digits = "xxx"),
    '`digits` must be a whole number or `NULL`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_aov, term = "c", digits = -1),
    "`digits` must be a whole number larger than or equal to 0 or `NULL`, not the number -1"
  ))
  suppressMessages(expect_error(
    format_stats(test_aov, term = "c", digits = 1.5),
    "`digits` must be a whole number or `NULL`, not the number 1.5"
  ))
  suppressMessages(expect_error(
    format_stats(test_aov, term = "c", pdigits = "xxx"),
    '`pdigits` must be a whole number, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_aov, term = "c", pdigits = 0),
    "`pdigits` must be a whole number between 1 and 5, not the number 0"
  ))
  suppressMessages(expect_error(
    format_stats(test_aov, term = "c", pdigits = 7),
    "`pdigits` must be a whole number between 1 and 5, not the number 7"
  ))
  suppressMessages(expect_error(
    format_stats(test_aov, term = "c", pzero = "xxx"),
    '`pzero` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_aov, term = "c", italics = "xxx"),
    '`italics` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_aov, term = "c", dfs = "xxx"),
    '`dfs` must be "par", "sub", or "none", not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_aov, term = "c", type = "xxx"),
    '`type` must be "md" or "latex", not the string "xxx"'
  ))
})


test_that("formatting ANOVAs works properly", {
  expect_equal(format_stats(test_aov, "a"), "_F_(1, 8) = 0.1, _p_ = .748")
  expect_equal(format_stats(test_aov, "a", digits = 2), "_F_(1, 8) = 0.11, _p_ = .748")
  expect_equal(format_stats(test_aov, "a", pdigits = 2), "_F_(1, 8) = 0.1, _p_ = .75")
  expect_equal(format_stats(test_aov, "a", pzero = TRUE), "_F_(1, 8) = 0.1, _p_ = 0.748")
  expect_equal(format_stats(test_aov, "a", italics = FALSE), "F(1, 8) = 0.1, p = .748")
  expect_equal(format_stats(test_aov, "a", dfs = "sub"), "_F_~1,8~ = 0.1, _p_ = .748")
  expect_equal(format_stats(test_aov, "a", dfs = "none"), "_F_ = 0.1, _p_ = .748")
  expect_equal(format_stats(test_aov, "a", type = "latex"), "$F$(1, 8) = 0.1, $p$ = .748")
  expect_equal(format_stats(test_aov, "a", type = "latex", dfs = "sub"), "$F$$_{1,8}$ = 0.1, $p$ = .748")
})
