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


test_that("format_stats() works properly for accepted objects", {
  expect_no_error(format_stats(test_ttest))
  expect_no_error(format_stats(test_corr))
  expect_no_error(format_stats(test_easycorr))
  expect_no_error(format_stats(test_easycorr2))
  expect_no_error(format_stats(test_easycorr3))
  expect_no_error(format_stats(test_aov, "a"))
  expect_no_error(format_stats(test_bf))
})
