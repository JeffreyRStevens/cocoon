test_that("unavailable format_stats() methods are aborted", {
  suppressMessages(expect_error(
    format_stats(123),
    "Numerics are not supported by"
  ))
  suppressMessages(expect_error(
    format_stats("xxx"),
    "Character strings are not supported by"
  ))
  suppressMessages(expect_error(
    format_stats(df),
    "Data frames are not supported by"
  ))
  suppressMessages(expect_error(
    format_stats(TRUE),
    "Objects of class"
  ))
  suppressMessages(expect_error(
    format_stats(test_chisq),
    "Objects of method"
  ))

})

test_that("htest correlations are validated properly", {
  suppressMessages(expect_error(
    format_stats(test_corr, digits = "xxx"),
    "Argument `digits` must be a non-negative numeric vector"
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, digits = -1),
    "Argument `digits` must be a non-negative numeric vector"
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, pdigits = "xxx"),
    "Argument `pdigits` must be a numeric between 1 and 5"
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, pdigits = 0),
    "Argument `pdigits` must be a numeric between 1 and 5"
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, pdigits = 7),
    "Argument `pdigits` must be a numeric between 1 and 5"
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, pzero = "xxx"),
    "Argument `pzero` must be TRUE or FALSE"
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, full = "xxx"),
    "Argument `full` must be TRUE or FALSE"
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, italics = "xxx"),
    "Argument `italics` must be TRUE or FALSE"
  ))
  suppressMessages(expect_error(
    format_stats(test_corr, type = "xxx"),
    "Argument `type` must be 'md' or 'latex'"
  ))
})

test_that("correlation correlations are validated properly", {
  suppressMessages(expect_error(
    format_stats(test_easycorr, digits = "xxx"),
    "Argument `digits` must be a non-negative numeric vector"
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, digits = -1),
    "Argument `digits` must be a non-negative numeric vector"
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, pdigits = "xxx"),
    "Argument `pdigits` must be a numeric between 1 and 5"
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, pdigits = 0),
    "Argument `pdigits` must be a numeric between 1 and 5"
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, pdigits = 7),
    "Argument `pdigits` must be a numeric between 1 and 5"
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, pzero = "xxx"),
    "Argument `pzero` must be TRUE or FALSE"
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, full = "xxx"),
    "Argument `full` must be TRUE or FALSE"
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, italics = "xxx"),
    "Argument `italics` must be TRUE or FALSE"
  ))
  suppressMessages(expect_error(
    format_stats(test_easycorr, type = "xxx"),
    "Argument `type` must be 'md' or 'latex'"
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
    "Argument `digits` must be a non-negative numeric vector"
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, digits = -1),
    "Argument `digits` must be a non-negative numeric vector"
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, pdigits = "xxx"),
    "Argument `pdigits` must be a numeric between 1 and 5"
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, pdigits = 0),
    "Argument `pdigits` must be a numeric between 1 and 5"
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, pdigits = 7),
    "Argument `pdigits` must be a numeric between 1 and 5"
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, pzero = "xxx"),
    "Argument `pzero` must be TRUE or FALSE"
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, full = "xxx"),
    "Argument `full` must be TRUE or FALSE"
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, italics = "xxx"),
    "Argument `italics` must be TRUE or FALSE"
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, dfs = "xxx"),
    "Argument `dfs` must be 'par', 'sub', or 'none'"
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, mean = "xxx"),
    "Argument `mean` must be 'abbr' or 'word'"
  ))
  suppressMessages(expect_error(
    format_stats(test_ttest, type = "xxx"),
    "Argument `type` must be 'md' or 'latex'"
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

test_that("format_stats() works properly for htest and BayesFactor objects", {
  expect_no_error(format_stats(test_ttest))
  expect_no_error(format_stats(test_corr))
  expect_no_error(format_stats(test_easycorr))
  expect_no_error(format_stats(test_easycorr2))
  expect_no_error(format_stats(test_easycorr3))
  expect_no_error(format_stats(test_bf))
})

test_that("format_stats.BFBayesFactor() validates arguments properly", {
  suppressMessages(expect_error(
    format_stats(test_bf, digits1 = "xxx"),
    "Argument `digits1` must be a non-negative numeric vector"
  ))
  suppressMessages(expect_error(
    format_stats(test_bf, digits1 = -1),
    "Argument `digits1` must be a non-negative numeric vector"
  ))
  suppressMessages(expect_error(
    format_stats(test_bf, digits2 = "xxx"),
    "Argument `digits2` must be a non-negative numeric vector"
  ))
  suppressMessages(expect_error(
    format_stats(test_bf, digits2 = -1),
    "Argument `digits2` must be a non-negative numeric vector"
  ))
  suppressMessages(expect_error(
    format_stats(test_bf, cutoff = 0.5),
    "Argument `cutoff` must be a numeric vector greater than 1 or NULL"
  ))
  suppressMessages(expect_error(
    format_stats(test_bf, cutoff = "xxx"),
    "Argument `cutoff` must be a numeric vector greater than 1 or NULL"
  ))
  suppressMessages(expect_error(
    format_stats(test_bf, italics = "xxx"),
    "Argument `italics` must be TRUE or FALSE"
  ))
  suppressMessages(expect_error(
    format_stats(test_bf, type = "xxx"),
    "Argument `type` must be 'md' or 'latex'"
  ))
})

