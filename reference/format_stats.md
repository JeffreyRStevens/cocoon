# Format statistical results

A generic function that takes objects from various statistical methods
to create formatted character strings to insert into R Markdown or
Quarto documents. Currently, the generic function works with the
following objects:

1.  `htest` objects of correlations, t-tests, and Wilcoxon tests

2.  correlations from the
    {[correlation](https://cran.r-project.org/package=correlation)}
    package.

3.  `aov` objects for ANOVAs

4.  Bayes factors from the
    {[BayesFactor](https://cran.r-project.org/package=BayesFactor)}
    package. The function invokes specific methods that depend on the
    class of the first argument.

## Usage

``` r
format_stats(x, ...)
```

## Arguments

- x:

  Statistical object.

- ...:

  Additional arguments passed to methods. For method-specific arguments,
  see
  [`format_stats.htest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.htest.md)
  for htest correlations, t-tests, and Wilcoxon tests,
  [`format_stats.easycorrelation()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.easycorrelation.md)
  for easycorrelation correlations,
  [`format_stats.lm()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.lm.md)
  for linear models,
  [`format_stats.merMod()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.merMod.md)
  and
  [`format_stats.lmerModLmerTest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.lmerModLmerTest.md)
  for linear mixed models, and
  [`format_stats.BFBayesFactor()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.BFBayesFactor.md)
  for Bayes factors from the
  {[BayesFactor](https://cran.r-project.org/package=BayesFactor)}
  package.

## Value

A character string of statistical information formatted in Markdown or
LaTeX.

## See also

Other functions for printing statistical objects:
[`format_bf()`](https://jeffreyrstevens.github.io/cocoon/reference/format_bf.md),
[`format_chisq()`](https://jeffreyrstevens.github.io/cocoon/reference/format_chisq.md),
[`format_corr()`](https://jeffreyrstevens.github.io/cocoon/reference/format_corr.md),
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
# Format cor.test() object
format_stats(cor.test(mtcars$mpg, mtcars$cyl))
#> [1] "_r_ = -.85, 95% CI [-0.93, -0.72], _p_ < .001"

# Format correlation::correlation() object
format_stats(correlation::correlation(data = mtcars, select = "mpg", select2 = "cyl"))
#> [1] "_r_ = -.85, 95% CI [-0.93, -0.72], _p_ < .001"

# Format t.test() object
format_stats(t.test(mtcars$vs, mtcars$am))
#> [1] "_M_ = 0.0, 95% CI [-0.2, 0.3], _t_(62) = 0.2, _p_ = .804"

# Format aov() object
format_stats(aov(mpg ~ cyl * hp, data = mtcars), term = "cyl")
#> [1] "_F_(1, 28) = 92.5, _p_ < .001"

# Format lm() or glm() object
format_stats(lm(mpg ~ cyl * hp, data = mtcars), term = "cyl")
#> [1] "_β_ = -4.119, SE = 0.988, _t_ = -4.168, _p_ < .001"
format_stats(glm(am ~ cyl * hp, data = mtcars, family = binomial), term = "cyl")
#> [1] "_β_ = -1.749, SE = 0.839, _z_ = -2.084, _p_ = .037"

# Format lme4::lmer() or lme4::glmer() object
format_stats(lme4::lmer(mpg ~ hp + (1 | cyl), data = mtcars), term = "hp")
#> [1] "_β_ = -0.030, SE = 0.015, _t_ = -2.088"
format_stats(lme4::glmer(am ~ hp + (1 | cyl), data = mtcars, family = binomial), term = "hp")
#> [1] "_β_ = 0.022, SE = 0.017, _z_ = 1.300, _p_ = .194"

# Format lmerTest::lmer() object
format_stats(lmerTest::lmer(mpg ~ hp + (1 | cyl), data = mtcars), term = "hp")
#> [1] "_β_ = -0.030, SE = 0.015, _t_ = -2.088, _p_ = .046"

# Format BFBayesFactor object from {BayesFactor} package
format_stats(BayesFactor::ttestBF(mtcars$vs, mtcars$am))
#> [1] "_BF_~10~ = 0.26"
```
