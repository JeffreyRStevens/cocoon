test_that("format_num() rounds properly", {
  suppressMessages(expect_error(
    format_num("xxx"),
    "Input must be a numeric vector"
  ))
  suppressMessages(expect_error(
    format_num(123.456, digits = "xxx"),
    "Argument `digits` must be a non-negative numeric vector"
  ))
  suppressMessages(expect_error(
    format_num(123.456, digits = -1),
    "Argument `digits` must be a non-negative numeric vector"
  ))
  expect_equal(format_num(123.456), "123.5")
  expect_equal(format_num(123.456, digits = 2), "123.46")
})


test_that("format_scientific() works properly", {
  suppressMessages(expect_error(
    format_scientific("xxx"),
    "Input must be a numeric vector"
  ))
  suppressMessages(expect_error(
    format_scientific(123.456, digits = "xxx"),
    "Argument `digits` must be a non-negative numeric vector"
  ))
  suppressMessages(expect_error(
    format_scientific(123.456, digits = -1),
    "Argument `digits` must be a non-negative numeric vector"
  ))
  suppressMessages(expect_error(
    format_bf(123.4567, type = "xxx"),
    "Argument `type` must be 'md' or 'latex'"
  ))
  expect_equal(format_scientific(1000), "1.0×10^3^")
  expect_equal(format_scientific(0.00123), "1.2×10^-3^")
  expect_equal(format_scientific(0.00123, digits = 2), "1.23×10^-3^")
  expect_equal(format_scientific(0.00123, type = "latex"), "1.2 \\times 10^{-3}")
  expect_equal(format_scientific(0.00123, digits = 2, type = "latex"), "1.23 \\times 10^{-3}")
})

test_that("format_chr() formats properly", {
  suppressMessages(expect_error(
    format_chr(3),
    "Input must be a character string"
  ))
  suppressMessages(expect_error(
    format_chr("xxx", italics = "xxx"),
    "Argument `italics` must be TRUE or FALSE"
  ))
  suppressMessages(expect_error(
    format_chr("xxx", type = "xxx"),
    "Argument `type` must be 'md' or 'latex'"
  ))
  expect_equal(format_chr("Hello world!"), "_Hello world!_")
  expect_equal(format_chr("Hello world!", italics = FALSE), "Hello world!")
  expect_equal(format_chr("Hello world!", type = "latex"), "$Hello world!$")
})


test_that("format_sub() formats properly", {
  suppressMessages(expect_error(
    format_sub(3),
    "Input must be a character string"
  ))
  suppressMessages(expect_error(
    format_sub("xxx", type = "xxx"),
    "Argument `type` must be 'md' or 'latex'"
  ))
  expect_equal(format_sub("10"), "~10~")
  expect_equal(format_sub("10", type = "latex"), "$_{10}$")
  expect_equal(format_sub(""), "")
  expect_equal(format_sub(), character(0))
})
