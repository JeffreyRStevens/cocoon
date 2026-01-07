# Format ANOVA statistics

This method formats analysis of variance (ANOVA) statistics from the
class `aov`. The default output is APA formatted, but this function
allows control over numbers of digits, leading zeros, italics, degrees
of freedom, and output format of Markdown or LaTeX.

## Usage

``` r
# S3 method for class 'aov'
format_stats(
  x,
  term,
  digits = 1,
  pdigits = 3,
  pzero = FALSE,
  italics = TRUE,
  dfs = "par",
  type = "md",
  ...
)
```

## Arguments

- x:

  An `aov` object from
  [`stats::aov()`](https://rdrr.io/r/stats/aov.html).

- term:

  Character string for row name of term to extract statistics for. This
  must be the exact string returned in the
  [`summary()`](https://rdrr.io/r/base/summary.html) output from the
  `aov` object.

- digits:

  Number of digits after the decimal for means, confidence intervals,
  and test statistics.

- pdigits:

  Number of digits after the decimal for p-values, ranging between 1-5
  (also controls cutoff for small p-values).

- pzero:

  Logical value (default = FALSE) for whether to include leading zero
  for p-values.

- italics:

  Logical value (default = TRUE) for whether *p* label should be
  italicized.

- dfs:

  Formatting for degrees of freedom ("par" = parenthetical, "sub" =
  subscript, "none" = do not print degrees of freedom).

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
[`format_stats.easycorrelation()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.easycorrelation.md),
[`format_stats.htest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.htest.md),
[`format_stats.lm()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.lm.md),
[`format_stats.lmerModLmerTest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.lmerModLmerTest.md),
[`format_stats.merMod()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.merMod.md),
[`format_ttest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_ttest.md)

## Examples

``` r
test_aov <- aov(mpg ~ cyl * hp, data = mtcars)

# Format ANOVA
format_stats(test_aov, term = "cyl")
#> [1] "_F_(1, 28) = 92.5, _p_ < .001"

# Remove italics and make degrees of freedom subscripts
format_stats(test_aov, term = "cyl", italics = FALSE, dfs = "sub")
#> [1] "F~1,28~ = 92.5, p < .001"

# Change digits and add leading zero to p-value
format_stats(test_aov, term = "hp", digits = 3, pdigits = 4, pzero = TRUE)
#> [1] "_F_(1, 28) = 1.850, _p_ = 0.1846"

# Format for LaTeX
format_stats(test_aov, term = "hp", type = "latex")
#> [1] "$F$(1, 28) = 1.9, $p$ = .185"
```
