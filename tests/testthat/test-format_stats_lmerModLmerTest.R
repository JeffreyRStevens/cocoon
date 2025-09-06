test_that("lmerTest linear mixed models are validated properly", {
  suppressMessages(expect_error(
    format_stats(test_lmer2),
    "`term` must be a character vector, not `NULL`"
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer2, term = "d"),
    "Argument `term` not found in model terms"
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer2, term = "c", digits = "xxx"),
    '`digits` must be a whole number or `NULL`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer2, term = "c", digits = -1),
    "`digits` must be a whole number larger than or equal to 0 or `NULL`, not the number -1"
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer2, term = "c", digits = 1.5),
    "`digits` must be a whole number or `NULL`, not the number 1.5"
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer2, term = "c", pdigits = "xxx"),
    '`pdigits` must be a whole number, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer2, term = "c", pdigits = 0),
    "`pdigits` must be a whole number between 1 and 5, not the number 0"
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer2, term = "c", pdigits = 7),
    "`pdigits` must be a whole number between 1 and 5, not the number 7"
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer2, term = "c", pzero = "xxx"),
    '`pzero` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer2, term = "c", full = "xxx"),
    '`full` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer2, term = "c", italics = "xxx"),
    '`italics` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer2, term = "c", type = "xxx"),
    '`type` must be "md" or "latex", not the string "xxx"'
  ))
})


test_that("formatting lm linear models works properly", {
  expect_equal(format_stats(test_lmer2, "a"), "_β_ = -0.103, SE = 0.310, _t_ = -0.333, _p_ = .748")
  expect_equal(format_stats(test_lmer2, "a", digits = 2), "_β_ = -0.10, SE = 0.31, _t_ = -0.33, _p_ = .748")
  expect_equal(format_stats(test_lmer2, "a", pdigits = 2), "_β_ = -0.103, SE = 0.310, _t_ = -0.333, _p_ = .75")
  expect_equal(format_stats(test_lmer2, "a", pzero = TRUE), "_β_ = -0.103, SE = 0.310, _t_ = -0.333, _p_ = 0.748")
  expect_equal(format_stats(test_lmer2, "a", full = FALSE), "_β_ = -0.103, _p_ = .748")
  expect_equal(format_stats(test_lmer2, "a", italics = FALSE), "β = -0.103, SE = 0.310, t = -0.333, p = .748")
  expect_equal(format_stats(test_lmer2, "a", type = "latex"), "$\\beta$ = -0.103, SE = 0.310, $t$ = -0.333, $p$ = .748")
})
