df <- data.frame(a = 1:10, b = 2:11, c = c(1, 8, 3, 7, 8, 2, 4, 1, 4, 5))
test_corr <- cor.test(df$a, df$b)
test_corr2 <- cor.test(df$a, df$c)
test_ttest1 <- t.test(df$a, mu = 5)
test_ttest <- t.test(df$a, df$b)
test_ttest2 <- t.test(df$a, c(df$b, 120))
test_ttest3 <- suppressWarnings(wilcox.test(df$a, mu = 5))
test_ttest4 <- suppressWarnings(wilcox.test(df$a, df$b))
test_ttest5 <- suppressWarnings(wilcox.test(df$a, c(df$b, 120)))

test_that("formatting correlations works properly", {
  # suppressMessages(expect_error(
  #   format_stats("xxx"),
  #   "Input must be a correlation object"
  # ))
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


test_that("formatting t-tests works properly", {
  # suppressMessages(expect_error(
  #   format_stats("xxx"),
  #   "Input must be a correlation object"
  # ))
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

test_that("format_bf() works properly", {
  suppressMessages(expect_error(
    format_bf("0.0012"),
    "Input is not numeric or of class BFBayesFactor"
  ))
  suppressMessages(expect_error(
    format_bf(test_corr),
    "Input is not numeric or of class BFBayesFactor"
  ))
  suppressMessages(expect_error(
    format_bf(123.4567, digits1 = "xxx"),
    "Argument `digits1` must be a non-negative numeric vector"
  ))
  suppressMessages(expect_error(
    format_bf(123.4567, digits1 = -1),
    "Argument `digits1` must be a non-negative numeric vector"
  ))
  suppressMessages(expect_error(
    format_bf(123.4567, digits2 = "xxx"),
    "Argument `digits2` must be a non-negative numeric vector"
  ))
  suppressMessages(expect_error(
    format_bf(123.4567, digits2 = -1),
    "Argument `digits2` must be a non-negative numeric vector"
  ))
  suppressMessages(expect_error(
    format_bf(123.4567, cutoff = 0.5),
    "Argument `cutoff` must be a numeric vector greater than 1 or NULL"
  ))
  suppressMessages(expect_error(
    format_bf(123.4567, cutoff = "xxx"),
    "Argument `cutoff` must be a numeric vector greater than 1 or NULL"
  ))
  suppressMessages(expect_error(
    format_bf(123.4567, italics = "xxx"),
    "Argument `italics` must be TRUE or FALSE"
  ))
  suppressMessages(expect_error(
    format_bf(123.4567, type = "xxx"),
    "Argument `type` must be 'md' or 'latex'"
  ))
  expect_equal(format_bf(123.4567), "_BF_~10~ = 123.5")
  expect_equal(format_bf(123.4567, digits1 = 2), "_BF_~10~ = 123.46")
  expect_equal(format_bf(1234.567), "_BF_~10~ = 1.2×10^3^")
  expect_equal(format_bf(1234.567, cutoff = 1000), "_BF_~10~ > 1000")
  expect_equal(format_bf(123.4567, cutoff = 1000), "_BF_~10~ = 123.5")
  expect_equal(format_bf(0.1234), "_BF_~10~ = 0.12")
  expect_equal(format_bf(0.001234, cutoff = 100), "_BF_~10~ < 0.01")
  expect_equal(format_bf(0.1234, cutoff = 1000), "_BF_~10~ = 0.12")
  expect_equal(format_bf(0.1234, digits2 = 3), "_BF_~10~ = 0.123")
  expect_equal(format_bf(0.001234, digits2 = 2, cutoff = 1000), "_BF_~10~ < 0.01")
  expect_equal(format_bf(10^c(-3:4)), c("_BF_~10~ = 1.0×10^-3^", "_BF_~10~ = 1.0×10^-2^", "_BF_~10~ = 0.10", "_BF_~10~ = 1.0", "_BF_~10~ = 10.0", "_BF_~10~ = 100.0", "_BF_~10~ = 1.0×10^3^", "_BF_~10~ = 1.0×10^4^"))
  expect_equal(format_bf(10^c(-3:4), digits2 = 2, cutoff = 1000), c("_BF_~10~ < 0.001", "_BF_~10~ = 0.01", "_BF_~10~ = 0.10", "_BF_~10~ = 1.0", "_BF_~10~ = 10.0", "_BF_~10~ = 100.0", "_BF_~10~ = 1000", "_BF_~10~ > 1000"))
  expect_equal(format_bf(0.1234, italics = FALSE), "BF~10~ = 0.12")
  expect_equal(format_bf(0.1234, subscript = "01"), "_BF_~01~ = 0.12")
  expect_equal(format_bf(0.1234, subscript = ""), "_BF_ = 0.12")
  expect_equal(format_bf(0.1234, type = "latex"), "$BF$$_{10}$ = 0.12")
  expect_equal(format_bf(0.1234, type = "latex", italics = FALSE), "BF$_{10}$ = 0.12")
  expect_equal(format_bf(0.1234, label = "bf"), "_bf_~10~ = 0.12")
  expect_equal(format_bf(0.1234, label = ""), "0.12")
  skip_on_cran()
  df <- data.frame(a = 1:10, b = c(1, 3, 2, 4, 6, 5, 7, 8, 10, 9))
  test_corrbf <- BayesFactor::correlationBF(df$a, df$b)
  expect_equal(format_bf(test_corrbf), "_BF_~10~ = 123.3")
})

test_that("format_p() works properly", {
  suppressMessages(expect_error(
    format_p("xxx"),
    "Input must be a numeric vector"
  ))
  suppressMessages(expect_error(
    format_p(0.0012, digits = "xxx"),
    "Argument `digits` must be a numeric between 1 and 5"
  ))
  suppressMessages(expect_error(
    format_p(0.0012, digits = 0),
    "Argument `digits` must be a numeric between 1 and 5"
  ))
  suppressMessages(expect_error(
    format_p(0.0012, digits = 7),
    "Argument `digits` must be a numeric between 1 and 5"
  ))
  suppressMessages(expect_error(
    format_p(0.0012, pzero = "xxx"),
    "Argument `pzero` must be TRUE or FALSE"
  ))
  suppressMessages(expect_error(
    format_p(0.0012, italics = "xxx"),
    "Argument `italics` must be TRUE or FALSE"
  ))
  suppressMessages(expect_error(
    format_p(0.0012, type = "xxx"),
    "Argument `type` must be 'md' or 'latex'"
  ))
  expect_equal(format_p(0.0012), "_p_ = .001")
  expect_equal(format_p(0.0012, digits = 2), "_p_ < .01")
  expect_equal(format_p(0.0012, pzero = TRUE), "_p_ = 0.001")
  expect_equal(format_p(0.0012, italics = FALSE), "p = .001")
  expect_equal(format_p(0.0012, type = "latex"), "$p$ = .001")
  expect_equal(format_p(0.0012, label = "P"), "_P_ = .001")
  expect_equal(format_p(0.0012, label = ""), ".001")
})

test_that("format_summary() works properly", {
  suppressMessages(expect_error(
    format_summary(x = "xxx"),
    "Argument `x` must be a numeric vector"
  ))
  suppressMessages(expect_error(
    format_summary(error = "xxx"),
    "You must include either the `x` or `values` argument"
  ))
  suppressMessages(expect_error(
    format_summary(x = 1:3, error = "xxx"),
    'Specify `error` as "ci", "sd", "se", or "iqr"'
  ))
  suppressMessages(expect_error(
    format_summary(values = "xxx"),
    "Argument `values` must be a numeric vector"
  ))
  suppressMessages(expect_error(
    format_summary(values = 1:4),
    "Argument `values` must be a vector with two or three elements"
  ))
  suppressMessages(expect_error(
    format_summary(values = c(2, 4, 1)),
    "Argument `values` must include the mean followed by the lower CI limit then the upper CI limit"
  ))
  suppressMessages(expect_error(
    format_summary(x = 1:3, tendlabel = "xxx"),
    'Specify `tendlabel` as "abbr", "word", or "none"'
  ))
  suppressMessages(expect_error(
    format_summary(x = 1:3, units = 2),
    "The `units` argument must be a character vector or NULL"
  ))
  suppressMessages(expect_error(
    format_summary(x = 1:3, display = "xxx"),
    'Specify `display` as "limits", "pm", "par", or "none"'
  ))
  expect_equal(format_summary(x = 1:10), "_M_ = 5.5, 95% CI [3.3, 7.7]")
  expect_equal(format_summary(values = c(5.5, 1.2)), "_M_ = 5.5, 95% CI [4.3, 6.7]")
  expect_equal(format_summary(values = c(5.5, 1.2, 7.4)), "_M_ = 5.5, 95% CI [1.2, 7.4]")
  expect_equal(format_summary(x = 1:10, error = "sd"), "_M_ = 5.5, _SD_ [2.5, 8.5]")
  expect_equal(format_summary(x = 1:10, error = "se"), "_M_ = 5.5, _SE_ [4.5, 6.5]")
  expect_equal(format_summary(x = 1:10, digits = 2), "_M_ = 5.50, 95% CI [3.33, 7.67]")
  expect_equal(format_summary(x = 1:10, tendlabel = "word"), "_Mean_ = 5.5, 95% CI [3.3, 7.7]")
  expect_equal(format_summary(x = 1:10, tendlabel = "none"), "5.5, 95% CI [3.3, 7.7]")
  expect_equal(format_summary(x = 1:10, italics = FALSE), "M = 5.5, 95% CI [3.3, 7.7]")
  expect_equal(format_summary(x = 1:10, subscript = "test"), "_M_~test~ = 5.5, 95% CI [3.3, 7.7]")
  expect_equal(format_summary(x = 1:10, units = "cm"), "_M_ = 5.5 cm, 95% CI [3.3, 7.7]")
  expect_equal(format_summary(x = 1:10, display = "pm"), "_M_ = 5.5 ± 2.2")
  expect_equal(format_summary(x = 1:10, display = "par"), "_M_ = 5.5 (95% CI = 2.2)")
  expect_equal(format_summary(x = 1:10, cilevel = 0.9), "_M_ = 5.5, 90% CI [3.7, 7.3]")
  expect_equal(format_summary(x = 1:10, errorlabel = FALSE), "_M_ = 5.5,  [3.3, 7.7]")
  expect_equal(format_summary(x = 1:10, type = "latex"), "$M$ = 5.5, 95% CI [3.3, 7.7]")
  expect_equal(format_mean(x = 1:10), "_M_ = 5.5")
  expect_equal(format_median(x = 1:10), "_Mdn_ = 5.5")
  expect_equal(format_meanci(x = 1:10), "_M_ = 5.5, 95% CI [3.3, 7.7]")
  expect_equal(format_meansd(x = 1:10), "_M_ = 5.5 (_SD_ = 3.0)")
  expect_equal(format_meanse(x = 1:10), "_M_ = 5.5 (_SE_ = 1.0)")
  expect_equal(format_medianiqr(x = 1:10), "_Mdn_ = 5.5 (_IQR_ = 4.5)")
})
