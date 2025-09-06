
test_that("lmer linear mixed models are validated properly", {
  suppressMessages(expect_error(
    format_stats(test_lmer),
    "No general model information is available for this type of model"
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer, term = 1),
    "`term` must be a character vector, not the number 1"
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer, term = "d"),
    "Argument `term` not found in model terms"
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer, term = "c", digits = "xxx"),
    '`digits` must be a whole number or `NULL`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer, term = "c", digits = -1),
    "`digits` must be a whole number larger than or equal to 0 or `NULL`, not the number -1"
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer, term = "c", digits = 1.5),
    "`digits` must be a whole number or `NULL`, not the number 1.5"
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer, term = "c", pdigits = "xxx"),
    '`pdigits` must be a whole number, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer, term = "c", pdigits = 0),
    "`pdigits` must be a whole number between 1 and 5, not the number 0"
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer, term = "c", pdigits = 7),
    "`pdigits` must be a whole number between 1 and 5, not the number 7"
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer, term = "c", pzero = "xxx"),
    '`pzero` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer, term = "c", full = "xxx"),
    '`full` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer, term = "c", italics = "xxx"),
    '`italics` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_lmer, term = "c", type = "xxx"),
    '`type` must be "md" or "latex", not the string "xxx"'
  ))
})


test_that("formatting lm linear models works properly", {
  expect_equal(format_stats(test_lmer, term = "a"), "_β_ = -0.103, SE = 0.310, _t_ = -0.333")
  expect_equal(format_stats(test_lmer, "a", digits = 2), "_β_ = -0.10, SE = 0.31, _t_ = -0.33")
  expect_equal(format_stats(test_lmer, "a", pdigits = 2), "_β_ = -0.103, SE = 0.310, _t_ = -0.333")
  expect_equal(format_stats(test_lmer, "a", pzero = TRUE), "_β_ = -0.103, SE = 0.310, _t_ = -0.333")
  expect_equal(format_stats(test_lmer, "a", full = FALSE), "_β_ = -0.103")
  expect_equal(format_stats(test_lmer, "a", italics = FALSE), "β = -0.103, SE = 0.310, t = -0.333")
  expect_equal(format_stats(test_lmer, "a", type = "latex"), "$\\beta$ = -0.103, SE = 0.310, $t$ = -0.333")
  expect_equal(format_stats(test_lmer, "a", type = "latex", dfs = "sub"), "$\\beta$ = -0.103, SE = 0.310, $t$ = -0.333")
})

test_that("formatting glm linear models works properly", {
  expect_equal(format_stats(test_glmer, "a"), "_β_ = 0.051, SE = 0.226, _z_ = 0.224, _p_ = .822")
  expect_equal(format_stats(test_glmer, "a", digits = 2), "_β_ = 0.05, SE = 0.23, _z_ = 0.22, _p_ = .822")
  expect_equal(format_stats(test_glmer, "a", pdigits = 2), "_β_ = 0.051, SE = 0.226, _z_ = 0.224, _p_ = .82")
  expect_equal(format_stats(test_glmer, "a", pzero = TRUE), "_β_ = 0.051, SE = 0.226, _z_ = 0.224, _p_ = 0.822")
  expect_equal(format_stats(test_glmer, "a", full = FALSE), "_β_ = 0.051, _p_ = .822")
  expect_equal(format_stats(test_glmer, "a", italics = FALSE), "β = 0.051, SE = 0.226, z = 0.224, p = .822")
  expect_equal(format_stats(test_glmer, "a", type = "latex"), "$\\beta$ = 0.051, SE = 0.226, $z$ = 0.224, $p$ = .822")
})
