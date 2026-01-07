# Format correlation statistics

**\[superseded\]**

With `format_corr()` you can format correlation statistics generated
from [`cor.test()`](https://rdrr.io/r/stats/cor.test.html) output. This
is now an internal function superceded by
[`format_stats()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.md),
which we recommend using instead.

## Usage

``` r
format_corr(x, digits, pdigits, pzero, full, italics, type, ...)
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
# format_stats(cor.test(mtcars$mpg, mtcars$cyl))
```
