# Format hypothesis test statistics

This method formats hypothesis test statistics from the class `htest`.
Currently, this includes Chi-squared tests from
[`chisq.test()`](https://rdrr.io/r/stats/chisq.test.html), correlations
from [`cor.test()`](https://rdrr.io/r/stats/cor.test.html), and t-tests
and Wilcoxon tests from
[`t.test()`](https://rdrr.io/r/stats/t.test.html) and
[`wilcox.test()`](https://rdrr.io/r/stats/wilcox.test.html). For
correlations, the function detects whether the object is from a Pearson,
Spearman, or Kendall correlation and reports the appropriate correlation
label (r, \\\tau\\, \\\rho\\). The default output is APA formatted, but
this function allows control over numbers of digits, leading zeros, the
presence of means and confidence intervals, italics, degrees of freedom,
and mean labels, and output format of Markdown or LaTeX.

## Usage

``` r
# S3 method for class 'htest'
format_stats(
  x,
  digits = NULL,
  pdigits = 3,
  pzero = FALSE,
  full = TRUE,
  italics = TRUE,
  dfs = "par",
  mean = "abbr",
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

- dfs:

  Formatting for degrees of freedom ("par" = parenthetical, "sub" =
  subscript, "none" = do not print degrees of freedom).

- mean:

  Formatting for mean label ("abbr" = M, "word" = Mean).

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
[`format_stats.easycorrelation()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.easycorrelation.md),
[`format_stats.lm()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.lm.md),
[`format_stats.lmerModLmerTest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.lmerModLmerTest.md),
[`format_stats.merMod()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.merMod.md),
[`format_ttest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_ttest.md)

## Examples

``` r
# Prepare statistical objects
test_chisq <- chisq.test(c(A = 20, B = 15, C = 25))
test_corr <- cor.test(mtcars$mpg, mtcars$cyl)
test_corr2 <- cor.test(mtcars$mpg, mtcars$cyl, method = "kendall")
#> Warning: Cannot compute exact p-value with ties
test_ttest <- t.test(mtcars$vs, mtcars$am)
test_ttest2 <- wilcox.test(mtcars$vs, mtcars$am)
#> Warning: cannot compute exact p-value with ties

# Format Chi-squared test
format_stats(test_chisq)
#> [1] "𝜒²(2) = 2.5, _p_ = .287"

# Format correlation
format_stats(test_corr)
#> [1] "_r_ = -.85, 95% CI [-0.93, -0.72], _p_ < .001"

# Remove confidence intervals and italics
format_stats(test_corr, full = FALSE, italics = FALSE)
#> [1] "r = -.85, p < .001"

# Change digits and add leading zero to p-value
format_stats(test_corr, digits = 3, pdigits = 4, pzero = TRUE)
#> [1] "_r_ = -0.852, 95% CI [-0.926, -0.716], _p_ < 1e-04"

# Format Kendall's tau
format_stats(test_corr2)
#> [1] "_τ_ = -.80, _p_ < .001"

# Format t-test
format_stats(test_ttest)
#> [1] "_M_ = 0.0, 95% CI [-0.2, 0.3], _t_(62) = 0.2, _p_ = .804"

# Remove mean and confidence interval
format_stats(test_ttest, full = FALSE)
#> [1] "_t_(62) = 0.2, _p_ = .804"

# Remove degrees of freedom and spell out "Mean"
format_stats(test_ttest, dfs = "none", mean = "word")
#> [1] "_Mean_ = 0.0, 95% CI [-0.2, 0.3], _t_ = 0.2, _p_ = .804"

# Format for LaTeX
format_stats(test_ttest2, type = "latex")
#> [1] "$W$ = 528.0, $p$ = .808"
```
