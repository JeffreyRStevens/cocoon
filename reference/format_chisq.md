# Format Chi-squared statistics

This is an internal function called by
[`format_stats()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.md),
which we recommend using instead.

## Usage

``` r
format_chisq(
  x,
  digits = 1,
  pdigits = 3,
  pzero = FALSE,
  italics = TRUE,
  dfs = "par",
  type = "md"
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

- italics:

  Logical value (default = TRUE) for whether *p* label should be
  italicized.

- dfs:

  Formatting for degrees of freedom ("par" = parenthetical, "sub" =
  subscript, "none" = do not print degrees of freedom).

- type:

  Type of formatting ("md" = markdown, "latex" = LaTeX).

## Value

A character string of statistical information formatted in Markdown or
LaTeX.

## See also

Other functions for printing statistical objects:
[`format_bf()`](https://jeffreyrstevens.github.io/cocoon/reference/format_bf.md),
[`format_corr()`](https://jeffreyrstevens.github.io/cocoon/reference/format_corr.md),
[`format_stats()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.md),
[`format_stats.BFBayesFactor()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.BFBayesFactor.md),
[`format_stats.aov()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.aov.md),
[`format_stats.easycorrelation()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.easycorrelation.md),
[`format_stats.htest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.htest.md),
[`format_stats.lm()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.lm.md),
[`format_stats.lmerModLmerTest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.lmerModLmerTest.md),
[`format_stats.merMod()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.merMod.md),
[`format_ttest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_ttest.md)

## Examples

``` r
format_stats(chisq.test(matrix(c(12, 5, 7, 7), ncol = 2)))
#> [1] "𝜒²(1) = 0.6, _p_ = .423"
```
