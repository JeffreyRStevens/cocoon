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
