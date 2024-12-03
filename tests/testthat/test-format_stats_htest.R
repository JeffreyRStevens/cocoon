test_that("htest correlations are validated properly", {
  suppressMessages(expect_error(
    format_stats(test_corr, digits = "xxx"),
    '`digits` must be a whole number or `NULL`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, digits = -1),
    "`digits` must be a whole number larger than or equal to 0 or `NULL`, not the number -1"
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, digits = 1.5),
    "`digits` must be a whole number or `NULL`, not the number 1.5"
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, pdigits = "xxx"),
    '`pdigits` must be a whole number, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, pdigits = 0),
    "`pdigits` must be a whole number between 1 and 5, not the number 0"
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, pdigits = 7),
    "`pdigits` must be a whole number between 1 and 5, not the number 7"
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, pzero = "xxx"),
    '`pzero` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, full = "xxx"),
    '`full` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, italics = "xxx"),
    '`italics` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, type = "xxx"),
    '`type` must be "md" or "latex", not the string "xxx"'
  ))
})


test_that("formatting correlations works properly", {
  expect_equal(format_stats(test_corr), "_r_ = 1.00, 95% CI [1.00, 1.00], _p_ < .001")
  expect_equal(format_stats(test_corr, digits = 3), "_r_ = 1.000, 95% CI [1.000, 1.000], _p_ < .001")
  expect_equal(format_stats(test_corr, pdigits = 2), "_r_ = 1.00, 95% CI [1.00, 1.00], _p_ < .01")
  expect_equal(format_stats(test_corr, pzero = TRUE), "_r_ = 1.00, 95% CI [1.00, 1.00], _p_ < 0.001")
  expect_equal(format_stats(test_corr2), "_r_ = -.12, 95% CI [-0.70, 0.55], _p_ = .748")
  expect_equal(format_stats(test_corr2, pzero = TRUE), "_r_ = -0.12, 95% CI [-0.70, 0.55], _p_ = 0.748")
  expect_equal(format_stats(test_corr, full = FALSE), "_r_ = 1.00, _p_ < .001")
  expect_equal(format_stats(test_corr, italics = FALSE), "r = 1.00, 95% CI [1.00, 1.00], p < .001")
  expect_equal(format_stats(test_corr, type = "latex"), "$r$ = 1.00, 95% CI [1.00, 1.00], $p$ < .001")
  expect_equal(format_stats(cor.test(df$a, df$b, method = "kendall")), "_τ_ = 1.00, _p_ < .001")
  expect_equal(format_stats(cor.test(df$a, df$b, method = "spearman")), "_ρ_ = 1.00, _p_ < .001")
})


test_that("htest t-tests are validated properly", {
  suppressMessages(expect_error(
    format_stats(test_ttest, digits = "xxx"),
    '`digits` must be a whole number or `NULL`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, digits = -1),
    "`digits` must be a whole number larger than or equal to 0 or `NULL`, not the number -1"
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, digits = 1.5),
    "`digits` must be a whole number or `NULL`, not the number 1.5"
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, pdigits = "xxx"),
    '`pdigits` must be a whole number, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, pdigits = 0),
    "`pdigits` must be a whole number between 1 and 5, not the number 0"
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, pdigits = 7),
    "`pdigits` must be a whole number between 1 and 5, not the number 7"
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, pzero = "xxx"),
    '`pzero` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, full = "xxx"),
    '`full` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, italics = "xxx"),
    '`italics` must be `TRUE` or `FALSE`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, dfs = "xxx"),
    '`dfs` must be "par", "sub", or "none", not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, mean = "xxx"),
    '`mean` must be "abbr" or "word", not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, type = "xxx"),
    '`type` must be "md" or "latex", not the string "xxx"'
  ))
})


test_that("formatting t-tests works properly", {
  expect_equal(format_stats(test_ttest1), "_M_ = 5.5, 95% CI [3.3, 7.7], _t_(9) = 0.5, _p_ = .614")
  expect_equal(format_stats(test_ttest), "_M_ = -1.0, 95% CI [-3.8, 1.8], _t_(18) = -0.7, _p_ = .470")
  expect_equal(format_stats(test_ttest2), "_M_ = -11.3, 95% CI [-34.4, 11.8], _t_(10.2) = -1.1, _p_ = .302")
  expect_equal(format_stats(test_ttest, digits = 2), "_M_ = -1.00, 95% CI [-3.84, 1.84], _t_(18) = -0.74, _p_ = .470")
  expect_equal(format_stats(test_ttest, pdigits = 2), "_M_ = -1.0, 95% CI [-3.8, 1.8], _t_(18) = -0.7, _p_ = .47")
  expect_equal(format_stats(test_ttest, pzero = TRUE), "_M_ = -1.0, 95% CI [-3.8, 1.8], _t_(18) = -0.7, _p_ = 0.470")
  expect_equal(format_stats(test_ttest, full = FALSE), "_t_(18) = -0.7, _p_ = .470")
  expect_equal(format_stats(test_ttest, italics = FALSE), "M = -1.0, 95% CI [-3.8, 1.8], t(18) = -0.7, p = .470")
  expect_equal(format_stats(test_ttest, dfs = "sub"), "_M_ = -1.0, 95% CI [-3.8, 1.8], _t_~18~ = -0.7, _p_ = .470")
  expect_equal(format_stats(test_ttest, dfs = "none"), "_M_ = -1.0, 95% CI [-3.8, 1.8], _t_ = -0.7, _p_ = .470")
  expect_equal(format_stats(test_ttest, type = "latex"), "$M$ = -1.0, 95% CI [-3.8, 1.8], $t$(18) = -0.7, $p$ = .470")
  expect_equal(format_stats(test_ttest, type = "latex", dfs = "sub"), "$M$ = -1.0, 95% CI [-3.8, 1.8], $t$$_{18}$ = -0.7, $p$ = .470")
  expect_equal(format_stats(test_ttest, mean = "word"), "_Mean_ = -1.0, 95% CI [-3.8, 1.8], _t_(18) = -0.7, _p_ = .470")
  suppressMessages(expect_equal(format_stats(test_ttest3), "_V_ = 27.0, _p_ = .634"))
  suppressMessages(expect_equal(format_stats(test_ttest4), "_W_ = 40.5, _p_ = .495"))
  suppressMessages(expect_equal(format_stats(test_ttest5), "_W_ = 40.5, _p_ = .323"))
})
