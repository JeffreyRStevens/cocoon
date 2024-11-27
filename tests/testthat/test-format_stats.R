test_that("unavailable format_stats() methods are aborted", {
  suppressMessages(expect_error(
    format_stats(123),
    'Numerics are not supported by'
  ))
  suppressMessages(expect_error(
    format_stats("xxx"),
    'Character strings are not supported by'
  ))
  suppressMessages(expect_error(
    format_stats(df),
    'Data frames are not supported by'
  ))
  suppressMessages(expect_error(
    format_stats(TRUE),
    'Objects of class'
  ))
  suppressMessages(expect_error(
    format_stats(test_chisq),
    'Objects of method'
  ))

})


test_that("format_stats() works properly for accepted objects", {
  expect_no_error(format_stats(test_ttest))
  expect_no_error(format_stats(test_corr))
  expect_no_error(format_stats(test_easycorr))
  expect_no_error(format_stats(test_easycorr2))
  expect_no_error(format_stats(test_easycorr3))
  expect_no_error(format_stats(test_aov, "a"))
  expect_no_error(format_stats(test_bf))
})


test_that("htest correlations are validated properly", {
  suppressMessages(expect_error(
    format_stats(test_corr, digits = "xxx"),
    '`digits` must be a whole number or `NULL`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, digits = -1),
    '`digits` must be a whole number larger than or equal to 0 or `NULL`, not the number -1'
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, digits = 1.5),
    '`digits` must be a whole number or `NULL`, not the number 1.5'
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, pdigits = "xxx"),
    '`pdigits` must be a whole number, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, pdigits = 0),
    '`pdigits` must be a whole number between 1 and 5, not the number 0'
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, pdigits = 7),
    '`pdigits` must be a whole number between 1 and 5, not the number 7'
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


test_that("correlation correlations are validated properly", {
  suppressMessages(expect_error(
    format_stats(test_easycorr, digits = "xxx"),
    '`digits` must be a whole number or `NULL`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, digits = -1),
    '`digits` must be a whole number larger than or equal to 0 or `NULL`, not the number -1'
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, digits = 1.5),
    '`digits` must be a whole number or `NULL`, not the number 1.5'
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, pdigits = "xxx"),
    '`pdigits` must be a whole number, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, pdigits = 0),
    '`pdigits` must be a whole number between 1 and 5, not the number 0'
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, pdigits = 7),
    '`pdigits` must be a whole number between 1 and 5, not the number 7'
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
    '`digits` must be a whole number larger than or equal to 0 or `NULL`, not the number -1'
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, digits = 1.5),
    '`digits` must be a whole number or `NULL`, not the number 1.5'
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, pdigits = "xxx"),
    '`pdigits` must be a whole number, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, pdigits = 0),
    '`pdigits` must be a whole number between 1 and 5, not the number 0'
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, pdigits = 7),
    '`pdigits` must be a whole number between 1 and 5, not the number 7'
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


test_that("aov ANOVAs are validated properly", {
  suppressMessages(expect_error(
    format_stats(test_aov),
    '`term` must be a character vector, not absent'
  ))
  suppressMessages(expect_error(
    format_stats(test_aov, term = "c", digits = "xxx"),
    '`digits` must be a whole number or `NULL`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_aov, term = "c", digits = -1),
    '`digits` must be a whole number larger than or equal to 0 or `NULL`, not the number -1'
  ))
  suppressMessages(expect_error(
    format_stats(test_aov, term = "c", digits = 1.5),
    '`digits` must be a whole number or `NULL`, not the number 1.5'
  ))
  suppressMessages(expect_error(
    format_stats(test_aov, term = "c", pdigits = "xxx"),
    '`pdigits` must be a whole number, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_aov, term = "c", pdigits = 0),
    '`pdigits` must be a whole number between 1 and 5, not the number 0'
  ))
  suppressMessages(expect_error(
    format_stats(test_aov, term = "c", pdigits = 7),
    '`pdigits` must be a whole number between 1 and 5, not the number 7'
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
  expect_equal(format_stats(test_aov, "a", dfs = "sub"), "_F_~1, 8~ = 0.1, _p_ = .748")
  expect_equal(format_stats(test_aov, "a", dfs = "none"), "_F_ = 0.1, _p_ = .748")
  expect_equal(format_stats(test_aov, "a", type = "latex"), "$F$(1, 8) = 0.1, $p$ = .748")
  expect_equal(format_stats(test_aov, "a", type = "latex", dfs = "sub"), "$F$$_{1, 8}$ = 0.1, $p$ = .748")
})


test_that("format_stats.BFBayesFactor() validates arguments properly", {
  suppressMessages(expect_error(
    format_stats(test_bf, digits1 = "xxx"),
    '`digits1` must be a whole number or `NULL`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_bf, digits1 = -1),
    '`digits1` must be a whole number larger than or equal to 0 or `NULL`, not the number -1'
  ))
  suppressMessages(expect_error(
    format_stats(test_bf, digits2 = "xxx"),
    '`digits2` must be a whole number or `NULL`, not the string "xxx"'
  ))
  suppressMessages(expect_error(
    format_stats(test_bf, digits2 = -1),
    '`digits2` must be a whole number larger than or equal to 0 or `NULL`, not the number -1'
  ))
  suppressMessages(expect_error(
    format_stats(test_bf, cutoff = 0.5),
    '`cutoff` must be a number larger than or equal to 1 or `NULL`, not the number 0.5'
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

