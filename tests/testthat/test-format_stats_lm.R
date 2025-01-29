
test_that("lm linear regessions are validated properly", {
  suppressMessages(expect_error(
    format_stats(test_lm, term = "d"),
    "Argument `term` not found in model terms"
  ))
  suppressMessages(expect_error(
    format_stats(test_lm, term = "c", digits = "xxx"),
    '`digits` must be a whole number or `NULL`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_lm, term = "c", digits = -1),
    "`digits` must be a whole number larger than or equal to 0 or `NULL`, not the number -1"
  ))
  suppressMessages(expect_error(
    format_stats(test_lm, term = "c", digits = 1.5),
    "`digits` must be a whole number or `NULL`, not the number 1.5"
  ))
  suppressMessages(expect_error(
    format_stats(test_lm, term = "c", pdigits = "xxx"),
    '`pdigits` must be a whole number, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_lm, term = "c", pdigits = 0),
    "`pdigits` must be a whole number between 1 and 5, not the number 0"
  ))
  suppressMessages(expect_error(
    format_stats(test_lm, term = "c", pdigits = 7),
    "`pdigits` must be a whole number between 1 and 5, not the number 7"
  ))
  suppressMessages(expect_error(
    format_stats(test_lm, term = "c", pzero = "xxx"),
    '`pzero` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_lm, term = "c", full = "xxx"),
    '`full` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_lm, term = "c", italics = "xxx"),
    '`italics` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_lm, term = "c", type = "xxx"),
    '`type` must be "md" or "latex", not the string "xxx"'
  ))
})


test_that("formatting lm linear models works properly", {
  expect_equal(format_stats(test_lm), "_R_^2^ = -0.110, _F_(1, 8) = 0.111, _p_ = .748")
  expect_equal(format_stats(test_lm, full = FALSE), "_R_^2^ = -0.110, _p_ = .748")
  expect_equal(format_stats(test_lm, "a"), "_β_ = -0.103, SE = 0.310, _t_ = -0.333, _p_ = .748")
  expect_equal(format_stats(test_lm, "a", digits = 2), "_β_ = -0.10, SE = 0.31, _t_ = -0.33, _p_ = .748")
  expect_equal(format_stats(test_lm, "a", pdigits = 2), "_β_ = -0.103, SE = 0.310, _t_ = -0.333, _p_ = .75")
  expect_equal(format_stats(test_lm, "a", pzero = TRUE), "_β_ = -0.103, SE = 0.310, _t_ = -0.333, _p_ = 0.748")
  expect_equal(format_stats(test_lm, "a", full = FALSE), "_β_ = -0.103, _p_ = .748")
  expect_equal(format_stats(test_lm, "a", italics = FALSE), "β = -0.103, SE = 0.310, t = -0.333, p = .748")
  expect_equal(format_stats(test_lm, "a", type = "latex"), "$\\beta$ = -0.103, SE = 0.310, $t$ = -0.333, $p$ = .748")
  expect_equal(format_stats(test_lm, "a", type = "latex", dfs = "sub"), "$\\beta$ = -0.103, SE = 0.310, $t$ = -0.333, $p$ = .748")
})

test_that("formatting glm linear models works properly", {
  expect_equal(format_stats(test_glm), "Deviance = 13.410, _χ_^2^ = 0.051, AIC = 17.410")
  expect_equal(format_stats(test_glm, full = FALSE), "Deviance = 13.410, AIC = 17.410")
  expect_equal(format_stats(test_glm, "a"), "_β_ = 0.051, SE = 0.226, _z_ = 0.224, _p_ = .822")
  expect_equal(format_stats(test_glm, "a", digits = 2), "_β_ = 0.05, SE = 0.23, _z_ = 0.22, _p_ = .822")
  expect_equal(format_stats(test_glm, "a", pdigits = 2), "_β_ = 0.051, SE = 0.226, _z_ = 0.224, _p_ = .82")
  expect_equal(format_stats(test_glm, "a", pzero = TRUE), "_β_ = 0.051, SE = 0.226, _z_ = 0.224, _p_ = 0.822")
  expect_equal(format_stats(test_glm, "a", full = FALSE), "_β_ = 0.051, _p_ = .822")
  expect_equal(format_stats(test_glm, "a", italics = FALSE), "β = 0.051, SE = 0.226, z = 0.224, p = .822")
  expect_equal(format_stats(test_glm, "a", type = "latex"), "$\\beta$ = 0.051, SE = 0.226, $z$ = 0.224, $p$ = .822")
  expect_equal(format_stats(test_glm, "a", type = "latex", dfs = "sub"), "$\\beta$ = 0.051, SE = 0.226, $z$ = 0.224, $p$ = .822")
})
