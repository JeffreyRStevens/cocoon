# cocoon

``` r
library(cocoon)
```

One of the many useful features of the
[`{papaja}`](https://github.com/crsh/papaja) package is the
[`apa_print()`](https://frederikaust.com/papaja_man/reporting.html#statistical-models-and-tests)
function, which takes a statistical object and formats the output to
print the statistical information inline in R Markdown documents. The
`apa_print()` function is an easy way to extract and format this
statistical information for documents following APA style. However, APA
style has some rather strange quirks, and users may want some
flexibility in how their statistics are formatted. Moreover,
`apa_print()` uses LaTeX syntax, which works great for PDFs but
generates images for mathematical symbols when outputting to Word
documents.

The [cocoon](https://github.com/JeffreyRStevens/cocoon) package uses APA
style as the default, but allows more flexible formatting such as
including the leading 0 before numbers with maximum values of 1. All
functions accept a `type` argument that specifies either `"md"` for
Markdown (default) or `"latex"` for LaTeX. This package can format
statistical objects, statistical values, and numbers more generally.

## Formatting statistical objects

Running a statistical test in R typically returns a list with lots of
information about the test, often including things like statistical test
values and p-values. The aim of the
[`format_stats()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.md)
function is to extract and format statistics for a suite of commonly
used statistical objects (correlation and t-tests).

### Chi-squared tests

The
[`format_stats()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.md)
function can input objects returned by the
[`chisq.test()`](https://rdrr.io/r/stats/chisq.test.html) to report and
format the appropriate Chi-squared test statistic, degrees of freedom,
and p-value for both goodness-of-fit tests and tests of independence.

``` r
gof <- chisq.test(c(A = 20, B = 15, C = 25))
toi <- chisq.test(matrix(c(12, 5, 7, 7), ncol = 2))
```

| Code                | Output                  |
|---------------------|-------------------------|
| `format_stats(gof)` | 𝜒²(2) = 2.5, *p* = .287 |
| `format_stats(toi)` | 𝜒²(1) = 0.6, *p* = .423 |

Format the number of digits of coefficients with `digits` and digits of
p-values with `pdigits`. Include the leading zeros for coefficients and
p-values with `pzero = TRUE`. Remove italics with `italics = FALSE`.
With `dfs`, format degrees of freedom as parenthetical (`par`) or
subscripts (`sub`) or remove them (`none`).

| Code                                         | Output                   |
|----------------------------------------------|--------------------------|
| `format_stats(gof)`                          | 𝜒²(2) = 2.5, *p* = .287  |
| `format_stats(gof, digits = 1, pdigits = 2)` | 𝜒²(2) = 2.5, *p* = .29   |
| `format_stats(gof, pzero = TRUE)`            | 𝜒²(2) = 2.5, *p* = 0.287 |
| `format_stats(gof, italics = FALSE)`         | χ²(2) = 2.5, p = .287    |
| `format_stats(gof, dfs = "sub")`             | 𝜒²₂ = 2.5, *p* = .287    |
| `format_stats(gof, dfs = "none")`            | 𝜒² = 2.5, *p* = .287     |

### Correlations

The
[`format_stats()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.md)
function can input objects returned by the
[`cor.test()`](https://rdrr.io/r/stats/cor.test.html) or
[`correlation::correlation()`](https://easystats.github.io/correlation/reference/correlation.html)
function and detects whether the object is from a Pearson, Kendall, or
Spearman correlation. It then reports and formats the appropriate
correlation coefficient and p-value.

Let’s start by creating a few different correlations.

``` r
mpg_disp_corr_pearson <- cor.test(mtcars$mpg, mtcars$disp, method = "pearson")
mpg_disp_corr_spearman <- cor.test(
  mtcars$mpg,
  mtcars$disp,
  method = "spearman",
  exact = FALSE
)
mpg_disp_corr_kendall <- cor.test(
  mtcars$mpg,
  mtcars$disp,
  method = "kendall",
  exact = FALSE
)
```

For Pearson correlations, we get the correlation coefficient and the
confidence intervals. Since Spearman and Kendall correlations are
non-parametric, confidence intervals are not returned. Confidence
intervals can be omitted from Pearson correlations by setting
`full = FALSE`.

| Code                                                | Output                                           |
|-----------------------------------------------------|--------------------------------------------------|
| `format_stats(mpg_disp_corr_pearson)`               | *r* = -.85, 95% CI \[-0.92, -0.71\], *p* \< .001 |
| `format_stats(mpg_disp_corr_pearson, full = FALSE)` | *r* = -.85, *p* \< .001                          |
| `format_stats(mpg_disp_corr_spearman)`              | *ρ* = -.91, *p* \< .001                          |
| `format_stats(mpg_disp_corr_kendall)`               | *τ* = -.77, *p* \< .001                          |

Format the number of digits of coefficients with `digits` and digits of
p-values with `pdigits`. Include the leading zeros for coefficients and
p-values with `pzero = TRUE`. Remove italics with `italics = FALSE`.

| Code                                                           | Output                                             |
|----------------------------------------------------------------|----------------------------------------------------|
| `format_stats(mpg_disp_corr_pearson)`                          | *r* = -.85, 95% CI \[-0.92, -0.71\], *p* \< .001   |
| `format_stats(mpg_disp_corr_pearson, digits = 1, pdigits = 2)` | *r* = -.8, 95% CI \[-0.9, -0.7\], *p* \< .01       |
| `format_stats(mpg_disp_corr_pearson, pzero = TRUE)`            | *r* = -0.85, 95% CI \[-0.92, -0.71\], *p* \< 0.001 |
| `format_stats(mpg_disp_corr_pearson, italics = FALSE)`         | r = -.85, 95% CI \[-0.92, -0.71\], p \< .001       |
| `format_stats(mpg_disp_corr_spearman, italics = FALSE)`        | ρ = -.91, p \< .001                                |
| `format_stats(mpg_disp_corr_kendall, italics = FALSE)`         | τ = -.77, p \< .001                                |

### T-tests

The
[`format_stats()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.md)
function can also input objects returned by the
[`t.test()`](https://rdrr.io/r/stats/t.test.html) or
[`wilcox.test()`](https://rdrr.io/r/stats/wilcox.test.html) functions
and detect whether the object is from a Student’s or Wilcoxon t-test,
including one-sample, independent-sample, and paired-sample versions. It
then reports and formats the mean value (or mean difference), confidence
intervals for mean value/difference, appropriate test statistic, degrees
of freedom (for parametric tests), and p-value.

Let’s start by creating a few different t-tests

``` r
ttest_gear_carb <- t.test(mtcars$gear, mtcars$carb)
ttest_gear_carb_paired <- t.test(mtcars$gear, mtcars$carb, paired = TRUE)
ttest_gear_carb_onesample <- t.test(mtcars$gear, mu = 4)
wtest_gear_carb <- wilcox.test(mtcars$gear, mtcars$carb, exact = FALSE)
wtest_gear_carb_paired <- wilcox.test(
  mtcars$gear,
  mtcars$carb,
  paired = TRUE,
  exact = FALSE
)
wtest_gear_carb_onesample <- wilcox.test(mtcars$gear, mu = 4, exact = FALSE)
```

For Student’s t-tests, we get the mean value or difference and the
confidence intervals. Means and confidence intervals can be omitted by
setting `full = FALSE`.

| Code                                                    | Output                                                      |
|---------------------------------------------------------|-------------------------------------------------------------|
| `format_stats(ttest_gear_carb)`                         | *M* = 0.9, 95% CI \[0.2, 1.5\], *t*(43.4) = 2.8, *p* = .008 |
| `format_stats(ttest_gear_carb_paired)`                  | *M* = 0.9, 95% CI \[0.3, 1.4\], *t*(31) = 3.1, *p* = .004   |
| `format_stats(ttest_gear_carb_onesample)`               | *M* = 3.7, 95% CI \[3.4, 4.0\], *t*(31) = -2.4, *p* = .023  |
| `format_stats(ttest_gear_carb_onesample, full = FALSE)` | *t*(31) = -2.4, *p* = .023                                  |
| `format_stats(wtest_gear_carb)`                         | *W* = 727.5, *p* = .003                                     |
| `format_stats(wtest_gear_carb_paired)`                  | *V* = 267.0, *p* = .004                                     |
| `format_stats(wtest_gear_carb_onesample)`               | *V* = 52.5, *p* = .027                                      |

Format the number of digits of coefficients with `digits` and digits of
p-values with `pdigits`. Include the leading zeros for coefficients and
p-values with `pzero = TRUE`. Remove italics with `italics = FALSE`.
With `dfs`, format degrees of freedom as parenthetical (`par`) or
subscripts (`sub`) or remove them (`none`).

| Code                                                     | Output                                                           |
|----------------------------------------------------------|------------------------------------------------------------------|
| `format_stats(ttest_gear_carb)`                          | *M* = 0.9, 95% CI \[0.2, 1.5\], *t*(43.4) = 2.8, *p* = .008      |
| `format_stats(ttest_gear_carb, digits = 2, pdigits = 2)` | *M* = 0.88, 95% CI \[0.24, 1.51\], *t*(43.40) = 2.79, *p* \< .01 |
| `format_stats(ttest_gear_carb, pzero = TRUE)`            | *M* = 0.9, 95% CI \[0.2, 1.5\], *t*(43.4) = 2.8, *p* = 0.008     |
| `format_stats(ttest_gear_carb, italics = FALSE)`         | M = 0.9, 95% CI \[0.2, 1.5\], t(43.4) = 2.8, p = .008            |
| `format_stats(wtest_gear_carb)`                          | *W* = 727.5, *p* = .003                                          |
| `format_stats(wtest_gear_carb, italics = FALSE)`         | W = 727.5, p = .003                                              |
| `format_stats(ttest_gear_carb, dfs = "sub")`             | *M* = 0.9, 95% CI \[0.2, 1.5\], *t*_(43.4) = 2.8, *p* = .008     |
| `format_stats(ttest_gear_carb, dfs = "none")`            | *M* = 0.9, 95% CI \[0.2, 1.5\], *t* = 2.8, *p* = .008            |

### ANOVAs

The
[`format_stats()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.md)
function can also input objects returned by the
[`aov()`](https://rdrr.io/r/stats/aov.html) function. It then reports
and formats the F statistic, degrees of freedom, and p-value.

Let’s start by creating an ANOVA

``` r
aov_mpg_cyl_hp <- aov(mpg ~ cyl * hp, data = mtcars)
summary(aov_mpg_cyl_hp)
#>             Df Sum Sq Mean Sq F value   Pr(>F)    
#> cyl          1  817.7   817.7  92.472 2.27e-10 ***
#> hp           1   16.4    16.4   1.850   0.1846    
#> cyl:hp       1   44.4    44.4   5.018   0.0332 *  
#> Residuals   28  247.6     8.8                     
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

To use
[`format_stats()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.md)
on ANOVAs, you must pass the `aov` object and a character string
describing which term to extract. Apply
[`summary()`](https://rdrr.io/r/base/summary.html) to your `aov` object
and copy the text of the term you want to extract. Then you can format
the number of digits of coefficients with `digits` and digits of
p-values with `pdigits`. Include the leading zeros for coefficients and
p-values with `pzero = TRUE`. Remove italics with `italics = FALSE`.
With `dfs`, format degrees of freedom as parenthetical (`par`) or
subscripts (`sub`) or remove them (`none`).

| Code                                                                  | Output                          |
|-----------------------------------------------------------------------|---------------------------------|
| `format_stats(aov_mpg_cyl_hp, term = "cyl")`                          | *F*(1, 28) = 92.5, *p* \< .001  |
| `format_stats(aov_mpg_cyl_hp, term = "cyl:hp")`                       | *F*(1, 28) = 5.0, *p* = .033    |
| `format_stats(aov_mpg_cyl_hp, term = "cyl", digits = 2, pdigits = 2)` | *F*(1, 28) = 92.47, *p* \< .01  |
| `format_stats(aov_mpg_cyl_hp, term = "cyl", pzero = TRUE)`            | *F*(1, 28) = 92.5, *p* \< 0.001 |
| `format_stats(aov_mpg_cyl_hp, term = "cyl", italics = FALSE)`         | F(1, 28) = 92.5, p \< .001      |
| `format_stats(aov_mpg_cyl_hp, term = "cyl", dfs = "sub")`             | *F*_(1,28) = 92.5, *p* \< .001  |

### Linear models

The
[`format_stats()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.md)
function can also input objects returned by the
[`lm()`](https://rdrr.io/r/stats/lm.html),
[`glm()`](https://rdrr.io/r/stats/glm.html),
[`lme4::lmer()`](https://rdrr.io/pkg/lme4/man/lmer.html),
[`lmerTest::lmer()`](https://rdrr.io/pkg/lmerTest/man/lmer.html), and
[`lme4::glmer()`](https://rdrr.io/pkg/lme4/man/glmer.html) functions. It
can report overall model statistics (e.g., R-squared, AIC) for
[`lm()`](https://rdrr.io/r/stats/lm.html) and
[`glm()`](https://rdrr.io/r/stats/glm.html) and term-specific statistics
(e.g., coefficients, p-values) for all models.

Let’s start by creating some models:

``` r
lm_mpg_cyl_hp <- lm(mpg ~ cyl * hp, data = mtcars)
summary(lm_mpg_cyl_hp)
#> 
#> Call:
#> lm(formula = mpg ~ cyl * hp, data = mtcars)
#> 
#> Residuals:
#>    Min     1Q Median     3Q    Max 
#> -4.778 -1.969 -0.228  1.403  6.491 
#> 
#> Coefficients:
#>              Estimate Std. Error t value Pr(>|t|)    
#> (Intercept) 50.751207   6.511686   7.794 1.72e-08 ***
#> cyl         -4.119140   0.988229  -4.168 0.000267 ***
#> hp          -0.170680   0.069102  -2.470 0.019870 *  
#> cyl:hp       0.019737   0.008811   2.240 0.033202 *  
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Residual standard error: 2.974 on 28 degrees of freedom
#> Multiple R-squared:  0.7801, Adjusted R-squared:  0.7566 
#> F-statistic: 33.11 on 3 and 28 DF,  p-value: 2.386e-09
glm_am_cyl_hp <- glm(am ~ cyl * hp, data = mtcars, family = binomial)
summary(glm_am_cyl_hp)
#> 
#> Call:
#> glm(formula = am ~ cyl * hp, family = binomial, data = mtcars)
#> 
#> Coefficients:
#>               Estimate Std. Error z value Pr(>|z|)  
#> (Intercept)  6.1841091  4.8991403   1.262   0.2068  
#> cyl         -1.7492046  0.8392287  -2.084   0.0371 *
#> hp           0.0236170  0.0537369   0.439   0.6603  
#> cyl:hp       0.0005349  0.0067365   0.079   0.9367  
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 43.230  on 31  degrees of freedom
#> Residual deviance: 28.619  on 28  degrees of freedom
#> AIC: 36.619
#> 
#> Number of Fisher Scoring iterations: 5
lmer_mpg_cyl_hp <- lme4::lmer(mpg ~ hp + (1 | cyl), data = mtcars)
summary(lmer_mpg_cyl_hp)
#> Linear mixed model fit by REML ['lmerMod']
#> Formula: mpg ~ hp + (1 | cyl)
#>    Data: mtcars
#> 
#> REML criterion at convergence: 173.9
#> 
#> Scaled residuals: 
#>      Min       1Q   Median       3Q      Max 
#> -1.57631 -0.66143  0.04006  0.52583  2.20223 
#> 
#> Random effects:
#>  Groups   Name        Variance Std.Dev.
#>  cyl      (Intercept) 16.184   4.023   
#>  Residual              9.917   3.149   
#> Number of obs: 32, groups:  cyl, 3
#> 
#> Fixed effects:
#>             Estimate Std. Error t value
#> (Intercept) 24.70757    3.13221   7.888
#> hp          -0.03047    0.01459  -2.088
#> 
#> Correlation of Fixed Effects:
#>    (Intr)
#> hp -0.645
glmer_am_cyl_hp <- lme4::glmer(
  am ~ hp + (1 | cyl),
  data = mtcars,
  family = binomial
)
summary(glmer_am_cyl_hp)
#> Generalized linear mixed model fit by maximum likelihood (Laplace
#>   Approximation) [glmerMod]
#>  Family: binomial  ( logit )
#> Formula: am ~ hp + (1 | cyl)
#>    Data: mtcars
#> 
#>       AIC       BIC    logLik -2*log(L)  df.resid 
#>      44.3      48.7     -19.2      38.3        29 
#> 
#> Scaled residuals: 
#>     Min      1Q  Median      3Q     Max 
#> -1.7638 -0.5868 -0.2758  0.6521  1.3884 
#> 
#> Random effects:
#>  Groups Name        Variance Std.Dev.
#>  cyl    (Intercept) 5.786    2.405   
#> Number of obs: 32, groups:  cyl, 3
#> 
#> Fixed effects:
#>             Estimate Std. Error z value Pr(>|z|)
#> (Intercept) -3.46102    2.82069  -1.227    0.220
#> hp           0.02157    0.01659   1.300    0.194
#> 
#> Correlation of Fixed Effects:
#>    (Intr)
#> hp -0.856
lmer_mpg_cyl_hp2 <- lmerTest::lmer(mpg ~ hp + (1 | cyl), data = mtcars)
summary(lmer_mpg_cyl_hp2)
#> Linear mixed model fit by REML. t-tests use Satterthwaite's method [
#> lmerModLmerTest]
#> Formula: mpg ~ hp + (1 | cyl)
#>    Data: mtcars
#> 
#> REML criterion at convergence: 173.9
#> 
#> Scaled residuals: 
#>      Min       1Q   Median       3Q      Max 
#> -1.57631 -0.66143  0.04006  0.52583  2.20223 
#> 
#> Random effects:
#>  Groups   Name        Variance Std.Dev.
#>  cyl      (Intercept) 16.184   4.023   
#>  Residual              9.917   3.149   
#> Number of obs: 32, groups:  cyl, 3
#> 
#> Fixed effects:
#>             Estimate Std. Error       df t value Pr(>|t|)   
#> (Intercept) 24.70757    3.13221  4.28917   7.888  0.00104 **
#> hp          -0.03047    0.01459 28.97571  -2.088  0.04568 * 
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Correlation of Fixed Effects:
#>    (Intr)
#> hp -0.645
```

To extract overall model statistics from
[`format_stats()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.md),
pass the `lm` or `glm` object but omit any terms.

| Code                                        | Output                                         |
|---------------------------------------------|------------------------------------------------|
| `format_stats(lm_mpg_cyl_hp)`               | *R*² = 0.757, *F*(3, 28) = 33.113, *p* \< .001 |
| `format_stats(lm_mpg_cyl_hp, full = FALSE)` | *R*² = 0.757, *p* \< .001                      |
| `format_stats(glm_am_cyl_hp)`               | Deviance = 28.619, *χ*² = 14.611, AIC = 36.619 |
| `format_stats(glm_am_cyl_hp, full = FALSE)` | Deviance = 28.619, AIC = 36.619                |

To extract term-specific statistics, pass the object and a character
string describing which term to extract. Apply
[`summary()`](https://rdrr.io/r/base/summary.html) to your `lm`, `glm`,
`lmer`, or `glmer` object and copy the text of the term you want to
extract. Then you can format the number of digits of coefficients with
`digits` and digits of p-values with `pdigits`. Include the leading
zeros for coefficients and p-values with `pzero = TRUE`. Remove italics
with `italics = FALSE`. With `dfs`, format degrees of freedom as
parenthetical (`par`) or subscripts (`sub`) or remove them (`none`).

| Code                                                                 | Output                                               |
|----------------------------------------------------------------------|------------------------------------------------------|
| `format_stats(lm_mpg_cyl_hp, term = "cyl")`                          | *β* = -4.119, SE = 0.988, *t* = -4.168, *p* \< .001  |
| `format_stats(lm_mpg_cyl_hp, term = "cyl:hp")`                       | *β* = 0.020, SE = 0.009, *t* = 2.240, *p* = .033     |
| `format_stats(glm_am_cyl_hp, term = "cyl")`                          | *β* = -1.749, SE = 0.839, *z* = -2.084, *p* = .037   |
| `format_stats(lmer_mpg_cyl_hp, term = "hp")`                         | *β* = -0.030, SE = 0.015, *t* = -2.088               |
| `format_stats(glmer_am_cyl_hp, term = "hp")`                         | *β* = 0.022, SE = 0.017, *z* = 1.300, *p* = .194     |
| `format_stats(lmer_mpg_cyl_hp2, term = "hp")`                        | *β* = -0.030, SE = 0.015, *t* = -2.088, *p* = .046   |
| `format_stats(lm_mpg_cyl_hp, term = "cyl", digits = 2, pdigits = 2)` | *β* = -4.12, SE = 0.99, *t* = -4.17, *p* \< .01      |
| `format_stats(lm_mpg_cyl_hp, term = "cyl", pzero = TRUE)`            | *β* = -4.119, SE = 0.988, *t* = -4.168, *p* \< 0.001 |
| `format_stats(lm_mpg_cyl_hp, term = "cyl", italics = FALSE)`         | β = -4.119, SE = 0.988, t = -4.168, p \< .001        |
| `format_stats(lm_mpg_cyl_hp, term = "cyl", dfs = "sub")`             | *β* = -4.119, SE = 0.988, *t* = -4.168, *p* \< .001  |

### Bayes factors

The
[`format_stats()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.md)
function can also extract and format Bayes factors from a
`BFBayesFactor` object from the
[`{BayesFactor}`](https://cran.r-project.org/package=BayesFactor)
package. Bayes factors are not as standardized in how they are
formatted. One issue is that Bayes factors can be referenced from either
the alternative hypothesis (H₁) or the null hypothesis (H₀). Also, as a
ratio, digits after the decimal are more important below 1 than above 1.

To respond to the digits issue, the
[`format_stats()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.md)
function controls digits for Bayes factors less than 1 (`digits1`)
separately from those greater than 1 (`digits2`). In fact, the defaults
are different for these two arguments. Further, Bayes factors can be
very large or very small when evidence strongly favors one hypothesis
over another. Therefore, the `cutoff` argument set a threshold above
which (or below 1/cutoff) the returned value is truncated (e.g., BF \>
1000).

``` r
bf_corr <- BayesFactor::correlationBF(mtcars$mpg, mtcars$disp)
bf_ttest <- BayesFactor::ttestBF(mtcars$vs, mtcars$am)
bf_lm <- BayesFactor::lmBF(mpg ~ am, data = mtcars)
```

| Code                                   | Output           |
|----------------------------------------|------------------|
| `format_stats(bf_lm)`                  | *BF*₁₀ = 87.3    |
| `format_stats(bf_lm, digits1 = 2)`     | *BF*₁₀ = 87.30   |
| `format_stats(bf_corr)`                | *BF*₁₀ = 2.7×10⁶ |
| `format_stats(bf_corr, cutoff = 1000)` | *BF*₁₀ \> 1000   |
| `format_stats(bf_ttest)`               | *BF*₁₀ = 0.26    |
| `format_stats(bf_ttest, digits2 = 3)`  | *BF*₁₀ = 0.262   |
| `format_stats(bf_ttest, cutoff = 3)`   | *BF*₁₀ \< 0.33   |

The default label for Bayes factors is *BF*₁₀. The text of the label can
be changed with the `label` argument, where setting `label = ""` omits
the label. Italics can be removed with `italics = FALSE`, and the
subscript can be set to 01 (`subscript = "01"`) or removed
(`subscript = ""`).

| Code                                                                           | Output              |
|--------------------------------------------------------------------------------|---------------------|
| `format_stats(bf_lm)`                                                          | *BF*₁₀ = 87.3       |
| `format_stats(bf_lm, italics = FALSE)`                                         | BF₁₀ = 87.3         |
| `format_stats(bf_lm, subscript = "")`                                          | *BF* = 87.3         |
| `format_stats(bf_lm, label = "Bayes factor", italics = FALSE, subscript = "")` | Bayes factor = 87.3 |
| `format_stats(bf_lm, label = "")`                                              | 87.3                |

## Formatting statistical values

### Central tendency and error

#### Data vectors

Often, we need to include simple descriptive statistics in our
documents, such as measures of central tendency and error.
[cocoon](https://github.com/JeffreyRStevens/cocoon) includes a suite of
functions that can calculate different summary measures of central
tendency (mean or median) and error (confidence interval, standard
error, standard deviation, interquartile range) from a numeric data
vector. With the base function
[`format_summary()`](https://jeffreyrstevens.github.io/cocoon/reference/format_summary.md),
you can specify central tendency with the `summary` argument and error
with the `error` argument. For instance,
`format_summary(vec, summary = "mean", error = "se")` calculates mean
and standard error.

[cocoon](https://github.com/JeffreyRStevens/cocoon) includes a number of
wrapper functions that cover common measures of central tendency and
error including:

- [`format_meanci()`](https://jeffreyrstevens.github.io/cocoon/reference/format_summary.md)
- [`format_meanse()`](https://jeffreyrstevens.github.io/cocoon/reference/format_summary.md)
- [`format_meansd()`](https://jeffreyrstevens.github.io/cocoon/reference/format_summary.md)
- [`format_medianiqr()`](https://jeffreyrstevens.github.io/cocoon/reference/format_summary.md)

And if you don’t want to include error, use
[`format_mean()`](https://jeffreyrstevens.github.io/cocoon/reference/format_summary.md)
or
[`format_median()`](https://jeffreyrstevens.github.io/cocoon/reference/format_summary.md).

| Code                                       | Output                            |
|--------------------------------------------|-----------------------------------|
| `format_summary(mtcars$mpg, error = "ci")` | *M* = 20.1, 95% CI \[17.9, 22.3\] |
| `format_meanci(mtcars$mpg)`                | *M* = 20.1, 95% CI \[17.9, 22.3\] |
| `format_medianiqr(mtcars$mpg)`             | *Mdn* = 19.2 (*IQR* = 7.4)        |
| `format_mean(mtcars$mpg)`                  | *M* = 20.1                        |

#### Pre-calculated summaries

In addition to calculating values directly from the vectors, these
functions can format already-calculated measures. So if you already have
your mean and error calculated, just pass the vector of central
tendency, lower error limit, and upper error limit to the `values`
argument to format them. For instance,
`format_meanci(values = c(12.5, 11.2, 13.7))` produces *M* = 12.5, 95%
CI \[11.2, 13.7\]. Make sure you pass the arguments in this order, as
the function checks whether the send argument is less than or equal to
the first and the third is greater than or equal to the first.

#### Formatting output

These functions can control many aspects of formatting for the values
and labels of summary statistics. Digits after the decimal are
controlled with `digits` (default is 1). The `tendlabel` argument
defines whether the default abbreviation is used (“M” or “Mdn”), the
full word (“Mean” or “Median”), or no label is provided. Each of these
can be italicized or not with the `italics` argument, subscripts can be
included with the `subscript` argument, and units added with the `units`
argument.

| Code                                          | Output         |
|-----------------------------------------------|----------------|
| `format_mean(mtcars$mpg)`                     | *M* = 20.1     |
| `format_mean(mtcars$mpg, tendlabel = "word")` | *Mean* = 20.1  |
| `format_mean(mtcars$mpg, tendlabel = "none")` | 20.1           |
| `format_mean(mtcars$mpg, italics = FALSE)`    | M = 20.1       |
| `format_mean(mtcars$mpg, subscript = "A")`    | *M*_(A) = 20.1 |
| `format_mean(mtcars$mpg, units = "m")`        | *M* = 20.1 m   |

Error can be displayed in a number of different ways. Setting the
`display` argument to `"limits"` (default) includes upper and lower
limits in brackets. If intervals rather than limits are preferred, they
can be appended after the mean/median with ± using `"pm"` or in
parentheses with `"par"`. Error is not displayed if `display = "none"`.
The presence of the error label is controlled by the logical argument
`errorlabel`. When set to `FALSE`, no error label is included. For
confidence intervals, the `cilevel` argument takes a numeric scalar from
0-1 to define the confidence level.

| Code                                            | Output                            |
|-------------------------------------------------|-----------------------------------|
| `format_meanci(mtcars$mpg)`                     | *M* = 20.1, 95% CI \[17.9, 22.3\] |
| `format_meanci(mtcars$mpg, display = "pm")`     | *M* = 20.1 ± 2.2                  |
| `format_meanci(mtcars$mpg, display = "par")`    | *M* = 20.1 (95% CI = 2.2)         |
| `format_meanci(mtcars$mpg, display = "none")`   | *M* = 20.1                        |
| `format_meanci(mtcars$mpg, errorlabel = FALSE)` | *M* = 20.1, \[17.9, 22.3\]        |
| `format_meanci(mtcars$mpg, cilevel = 0.90)`     | *M* = 20.1, 90% CI \[18.3, 21.9\] |

### P-values

P-values are pretty easy to format with
[`format_p()`](https://jeffreyrstevens.github.io/cocoon/reference/format_p.md).
The `digits` argument controls the number of digits after the decimal,
and if the value is lower, `p <` is used. Unfortunately, APA style
involves lopping off the leading zero in p-values, but setting
`pzero = TRUE` turns off this silly setting. The p-value label is
controlled by `label`, where the user can specify the exact label text.
By default, this is a lower case, italicized *p*. Non-italicized can be
defined with `italics = FALSE`. P-value labels can be omitted by setting
`label = ""`.

| Code                               | Output      |
|------------------------------------|-------------|
| `format_p(0.001)`                  | *p* = .001  |
| `format_p(0.001, digits = 2)`      | *p* \< .01  |
| `format_p(0.321, digits = 2)`      | *p* = .32   |
| `format_p(0.001, pzero = TRUE)`    | *p* = 0.001 |
| `format_p(0.001, label = "P")`     | *P* = .001  |
| `format_p(0.001, italics = FALSE)` | p = .001    |
| `format_p(0.001, label = "")`      | .001        |

### Bayes factors

Though the
[`format_stats()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.md)
function extracts and formats Bayes factors from the
[`{BayesFactor}`](https://cran.r-project.org/package=BayesFactor)
package, sometimes you may have Bayes factors from other sources. The
[`format_bf()`](https://jeffreyrstevens.github.io/cocoon/reference/format_bf.md)
function formats Bayes factors from numeric values (either single scalar
elements or vectors).

| Code                                                                       | Output                          |
|----------------------------------------------------------------------------|---------------------------------|
| `format_bf(4321)`                                                          | *BF*₁₀ = 4.3×10³                |
| `format_bf(4321, digits1 = 2)`                                             | *BF*₁₀ = 4.32×10³               |
| `format_bf(4321, cutoff = 1000)`                                           | *BF*₁₀ \> 1000                  |
| `format_bf(0.04321)`                                                       | *BF*₁₀ = 0.04                   |
| `format_bf(0.04321, digits2 = 3)`                                          | *BF*₁₀ = 0.043                  |
| `format_bf(0.04321, cutoff = 10)`                                          | *BF*₁₀ \< 0.10                  |
| `format_bf(4321, italics = FALSE)`                                         | BF₁₀ = 4.3×10³                  |
| `format_bf(4321, subscript = "")`                                          | *BF* = 4.3×10³                  |
| `format_bf(4321, label = "Bayes factor", italics = FALSE, subscript = "")` | Bayes factor = 4.3×10³          |
| `format_bf(4321, label = "")`                                              | 4.3×10³                         |
| `format_bf(c(4321, 0.04321))`                                              | *BF*₁₀ = 4.3×10³, *BF*₁₀ = 0.04 |

## Formatting numbers

In addition to formatting specific statistics, this package can format
numbers more generally. The
[`format_num()`](https://jeffreyrstevens.github.io/cocoon/reference/format_num.md)
function controls general formatting of numbers of digits with `digits`
and the presence of the leading zero with `pzero`.

| Code                                | Output |
|-------------------------------------|--------|
| `format_num(0.1234)`                | 0.1    |
| `format_num(0.1234, digits = 2)`    | 0.12   |
| `format_num(0.1234, pzero = FALSE)` | .1     |

For large or small values, using scientific notation may be a more
useful way to format the numbers. The
[`format_scientific()`](https://jeffreyrstevens.github.io/cocoon/reference/format_scientific.md)
function converts to scientific notation, again offering control of the
number of `digits` as well as whether output `type` is Markdown or
LaTeX.

| Code                                          | Output    |
|-----------------------------------------------|-----------|
| `format_scientific(1234)`                     | 1.2×10³   |
| `format_scientific(0.0000001234)`             | 1.2×10⁻⁷  |
| `format_scientific(0.0000001234, digits = 2)` | 1.23×10⁻⁷ |
