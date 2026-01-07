# Format linear model statistics

This method formats (generalized) linear model statistics from the class
`lm` or `glm`. If no term is specified, overall model statistics are
returned. For linear models (`lm` objects), this includes the R-squared,
F statistic, and p-value. For generalized linear models (`glm` objects),
this includes deviance and AIC. The default output is APA formatted, but
this function allows control over numbers of digits, leading zeros,
italics, degrees of freedom, and output format of Markdown or LaTeX.

## Usage

``` r
# S3 method for class 'lm'
format_stats(
  x,
  term = NULL,
  digits = 3,
  pdigits = 3,
  pzero = FALSE,
  full = TRUE,
  italics = TRUE,
  dfs = "par",
  type = "md",
  ...
)
```

## Arguments

- x:

  An `lm` or `glm` object from
  [`stats::lm()`](https://rdrr.io/r/stats/lm.html) or
  [`stats::glm()`](https://rdrr.io/r/stats/glm.html).

- term:

  Character string for row name of term to extract statistics for. This
  must be the exact string returned in the
  [`summary()`](https://rdrr.io/r/base/summary.html) output from the
  `lm` or `glm` object.

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
[`format_stats.aov()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.aov.md),
[`format_stats.easycorrelation()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.easycorrelation.md),
[`format_stats.htest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.htest.md),
[`format_stats.lmerModLmerTest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.lmerModLmerTest.md),
[`format_stats.merMod()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.merMod.md),
[`format_ttest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_ttest.md)

## Examples

``` r
test_lm <- lm(mpg ~ cyl * hp, data = mtcars)
test_glm <- glm(am ~ cyl * hp, data = mtcars, family = binomial)

# Format linear model overall statistics
format_stats(test_lm)
#> [1] "_R_^2^ = 0.757, _F_(3, 28) = 33.113, _p_ < .001"

# Format linear model term statistics
format_stats(test_lm, term = "cyl")
#> [1] "_β_ = -4.119, SE = 0.988, _t_ = -4.168, _p_ < .001"

# Format generalized linear model overall statistics
format_stats(test_glm)
#> [1] "Deviance = 28.619, _χ_^2^ = 14.611, AIC = 36.619"

# Format generalized linear model term statistics
format_stats(test_glm, term = "cyl")
#> [1] "_β_ = -1.749, SE = 0.839, _z_ = -2.084, _p_ = .037"

# Remove italics and make degrees of freedom subscripts
format_stats(test_lm, term = "cyl", italics = FALSE, dfs = "sub")
#> [1] "β = -4.119, SE = 0.988, t = -4.168, p < .001"

# Change digits and add leading zero to p-value
format_stats(test_lm, term = "hp", digits = 3, pdigits = 4, pzero = TRUE)
#> [1] "_β_ = -0.171, SE = 0.069, _t_ = -2.470, _p_ = 0.0199"

# Format for LaTeX
format_stats(test_lm, term = "hp", type = "latex")
#> [1] "$\\beta$ = -0.171, SE = 0.069, $t$ = -2.470, $p$ = .020"
```
