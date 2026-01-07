# Format Bayes factors

This method formats Bayes factors from the
{[BayesFactor](https://cran.r-project.org/package=BayesFactor)} package.
By default, this function rounds Bayes factors greater than 1 to one
decimal place and Bayes factors less than 1 to two decimal places.
Values greater than 1000 or less than 1/1000 are formatted using
scientific notation. Cutoffs can be set that format the values as
greater than or less than the cutoffs (e.g., BF \> 1000 or BF \< 0.001).
Numbers of digits, cutoffs, italics, and label subscripts are all
customizable.

## Usage

``` r
# S3 method for class 'BFBayesFactor'
format_stats(
  x,
  digits1 = 1,
  digits2 = 2,
  cutoff = NULL,
  label = "BF",
  italics = TRUE,
  subscript = "10",
  type = "md",
  ...
)
```

## Arguments

- x:

  BayesFactor object or vector of numeric Bayes factor values.

- digits1:

  Number of digits after the decimal for Bayes factors \> 1.

- digits2:

  Number of digits after the decimal for Bayes factors \< 1.

- cutoff:

  Cutoff for using `_BF_~10~ > <cutoff>` or `_BF_~10~ < 1 / <cutoff>`
  (value must be \> 1).

- label:

  Character string for label before Bayes factor. Default is BF. Set
  `label = ""` to return just the formatted Bayes factor value with no
  label or operator (`=`, `<`, `>`).

- italics:

  Logical value (default = TRUE) for whether label should be italicized
  (*BF* or BF).

- subscript:

  Subscript to include with *BF* label (`"10"`, `"01"`, or `""` for no
  subscript).

- type:

  Type of formatting (`"md"` = markdown, `"latex"` = LaTeX).

- ...:

  Additional arguments passed to methods.

## Value

A character string of statistical information formatted in Markdown or
LaTeX.

## See also

Other functions for printing statistical objects:
[`format_bf()`](https://jeffreyrstevens.github.io/cocoon/reference/format_bf.md),
[`format_chisq()`](https://jeffreyrstevens.github.io/cocoon/reference/format_chisq.md),
[`format_corr()`](https://jeffreyrstevens.github.io/cocoon/reference/format_corr.md),
[`format_stats()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.md),
[`format_stats.aov()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.aov.md),
[`format_stats.easycorrelation()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.easycorrelation.md),
[`format_stats.htest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.htest.md),
[`format_stats.lm()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.lm.md),
[`format_stats.lmerModLmerTest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.lmerModLmerTest.md),
[`format_stats.merMod()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.merMod.md),
[`format_ttest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_ttest.md)

## Examples

``` r
# Prepare statistical object
test_bf <- BayesFactor::ttestBF(mtcars$vs, mtcars$am)

# Format Bayes factor
format_stats(test_bf)
#> [1] "_BF_~10~ = 0.26"

# Control cutoff for output
format_stats(test_bf, cutoff = 3)
#> [1] "_BF_~10~ < 0.33"

# Change digits, remove italics and subscript
format_stats(test_bf, digits2 = 1, italics = FALSE, subscript = "")
#> [1] "BF = 0.3"

# Return only Bayes factor value (no label)
format_stats(test_bf, label = "")
#> [1] "0.26"

# Format for LaTeX
format_stats(test_bf, type = "latex")
#> [1] "$BF$$_{10}$ = 0.26"
```
