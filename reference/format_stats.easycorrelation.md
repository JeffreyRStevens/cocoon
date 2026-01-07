# Format correlation statistics

This functions formats correlation statistics generated from the
{[correlation](https://cran.r-project.org/package=correlation)} package.
This detects whether the object is from a Pearson, Spearman, or Kendall
correlation and reports the appropriate correlation label (r, \\\tau\\,
\\\rho\\). The default output is APA formatted, but numbers of digits,
leading zeros, the presence of confidence intervals, and italics are all
customizable.

## Usage

``` r
# S3 method for class 'easycorrelation'
format_stats(
  x,
  digits = 2,
  pdigits = 3,
  pzero = FALSE,
  full = TRUE,
  italics = TRUE,
  type = "md",
  ...
)
```

## Arguments

- x:

  An `htest` object from
  [`cor.test()`](https://rdrr.io/r/stats/cor.test.html),
  [`t.test()`](https://rdrr.io/r/stats/t.test.html), or
  [`wilcox.test()`](https://rdrr.io/r/stats/wilcox.test.html).

- digits:

  Number of digits after the decimal for means, confidence intervals,
  and test statistics.

- pdigits:

  Number of digits after the decimal for p-values, ranging between 1-5
  (also controls cutoff for small p-values).

- pzero:

  Logical value (default = FALSE) for whether to include leading zero
  for p-values.

- full:

  Logical value (default = TRUE) for whether to include means and
  confidence intervals or just test statistic and p-value.

- italics:

  Logical value (default = TRUE) for whether *p* label should be
  italicized.

- type:

  Type of formatting ("md" = markdown, "latex" = LaTeX).

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
[`format_stats.BFBayesFactor()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.BFBayesFactor.md),
[`format_stats.aov()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.aov.md),
[`format_stats.htest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.htest.md),
[`format_stats.lm()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.lm.md),
[`format_stats.lmerModLmerTest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.lmerModLmerTest.md),
[`format_stats.merMod()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.merMod.md),
[`format_ttest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_ttest.md)

## Examples

``` r
# Prepare statistical objects
test_corr <- correlation::correlation(mtcars, select = "mpg", select2 = "disp")
test_corr2 <- correlation::correlation(mtcars, select = "mpg", select2 = "disp", method = "kendall")

# Format correlation
format_stats(test_corr)
#> [1] "_r_ = -.85, 95% CI [-0.92, -0.71], _p_ < .001"

# Remove confidence intervals and italics
format_stats(test_corr, full = FALSE, italics = FALSE)
#> [1] "r = -.85, p < .001"

# Change digits and add leading zero to p-value
format_stats(test_corr, digits = 3, pdigits = 4, pzero = TRUE)
#> [1] "_r_ = -0.848, 95% CI [-0.923, -0.708], _p_ < 1e-04"

# Format Kendall's tau for LaTeX
format_stats(test_corr2, type = "latex")
#> [1] "$\\rho$ = -.77, $p$ < .001"
```
