# Changelog

## cocoon (development version)

## cocoon 0.2.1

CRAN release: 2025-09-07

- Add `exact = TRUE` to
  [`wilcox.test()`](https://rdrr.io/r/stats/wilcox.test.html) in htest
  testing to prevent warning produced in r-devel.

## cocoon 0.2.0

CRAN release: 2025-01-29

- Add format_stats() methods for
  [`aov()`](https://rdrr.io/r/stats/aov.html),
  [`glm()`](https://rdrr.io/r/stats/glm.html),
  [`lme4::glmer()`](https://rdrr.io/pkg/lme4/man/glmer.html),
  `lmerTest::glmer()`, [`lm()`](https://rdrr.io/r/stats/lm.html),
  [`lme4::lmer()`](https://rdrr.io/pkg/lme4/man/lmer.html), and
  [`lmerTest::lmer()`](https://rdrr.io/pkg/lmerTest/man/lmer.html).

- Add [standalone check
  functions](https://posit-conf-2024.github.io/programming-r/01-functions-01-advanced.html#standalone-functions-from-rlang)
  from {rlang}.

## cocoon 0.1.0

CRAN release: 2024-11-05

#### NEW FEATURES

- Added
  [`format_stats()`](https://jeffreyrstevens.github.io/cocoon/reference/format_stats.md)
  function to apply to accepted statistical objects (correlations,
  t-tests, Bayes factors). This is a generic function that recognizes
  the object class and uses the appropriate method, so it supercedes
  [`format_corr()`](https://jeffreyrstevens.github.io/cocoon/reference/format_corr.md)
  and
  [`format_ttest()`](https://jeffreyrstevens.github.io/cocoon/reference/format_ttest.md).
  [`format_bf()`](https://jeffreyrstevens.github.io/cocoon/reference/format_bf.md)
  can still be used to format numeric type Bayes factors.
- Added ability to format output from
  [`correlation::correlation()`](https://easystats.github.io/correlation/reference/correlation.html).

#### DOCUMENTATION UPDATES

- Reorder sections in vignette.
- Improve spacing and comments in examples.
- Add alt text to images.

#### PACKAGE DEVELOPMENT

- Move string building to internal `build_string()` function.
- Split functions into separate format_stats, format_statvalues, and
  format_summary scripts

## cocoon 0.0.1

- Initial release of
  [cocoon](https://github.com/JeffreyRStevens/cocoon).
