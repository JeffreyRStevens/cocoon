# Format linear mixed model statistics

This method formats (generalized) linear mixed model statistics from the
class `lmerMod` or `glmerMod` from the
{[lme4](https://cran.r-project.org/package=lme4)} package. Only fixed
effects can be extracted. The default output is APA formatted, but this
function allows control over numbers of digits, leading zeros, italics,
and output format of Markdown or LaTeX.

## Usage

``` r
# S3 method for class 'merMod'
format_stats(
  x,
  term = NULL,
  digits = 3,
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

  An `lmerMod` or `glmerMod` object from
  [`lme4::lmer()`](https://rdrr.io/pkg/lme4/man/lmer.html) or
  [`lme4::glmer()`](https://rdrr.io/pkg/lme4/man/glmer.html).

- term:

  Character string for row name of term to extract statistics for. This
  must be the exact string returned in the
  [`summary()`](https://rdrr.io/r/base/summary.html) output from the
  `lmerMod` or `glmerMod` object and can only be fixed effects.

- digits:

  Number of digits after the decimal for test statistics.

- pdigits:

  Number of digits after the decimal for p-values, ranging between 1-5
  (also controls cutoff for small p-values).

- pzero:

  Logical value (default = FALSE) for whether to include leading zero
  for p-values.

- full:

  Logical value (default = TRUE) for whether to include extra info
  (e.g., standard errors and t-values or z-values for terms) or just
  test statistic and p-value.

- italics:

  Logical value (default = TRUE) for whether statistics labels should be
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
[`format_stats.easycorrelation()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.easycorrelation.md),
[`format_stats.htest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.htest.md),
[`format_stats.lm()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.lm.md),
[`format_stats.lmerModLmerTest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.lmerModLmerTest.md),
[`format_ttest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_ttest.md)

## Examples

``` r
test_lmer <- lme4::lmer(mpg ~ hp + (1 | cyl), data = mtcars)
test_glmer <- lme4::glmer(am ~ hp + (1 | cyl), data = mtcars, family = binomial)

# Format linear mixed model term statistics
format_stats(test_lmer, term = "hp")
#> [1] "_β_ = -0.030, SE = 0.015, _t_ = -2.088"

# Format generalized linear mixed model term statistics
format_stats(test_glmer, term = "hp")
#> [1] "_β_ = 0.022, SE = 0.017, _z_ = 1.300, _p_ = .194"

# Remove italics
format_stats(test_lmer, term = "hp", italics = FALSE)
#> [1] "β = -0.030, SE = 0.015, t = -2.088"

# Change digits and add leading zero to p-value
format_stats(test_lmer, term = "hp", digits = 3, pdigits = 4, pzero = TRUE)
#> [1] "_β_ = -0.030, SE = 0.015, _t_ = -2.088"

# Format for LaTeX
format_stats(test_lmer, term = "hp", type = "latex")
#> [1] "$\\beta$ = -0.030, SE = 0.015, $t$ = -2.088"
```
