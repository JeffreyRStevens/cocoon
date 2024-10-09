test_that("format_bf() validates arguments properly", {
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
})

test_that("format_bf() works properly", {
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

