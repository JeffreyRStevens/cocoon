# cocoon 0.2.0

* Add format_stats() methods for `aov()`, `glm()`, `lme4::glmer()`, `lmerTest::glmer()`, `lm()`, `lme4::lmer()`, and `lmerTest::lmer()`

* Add [standalone check functions](https://posit-conf-2024.github.io/programming-r/01-functions-01-advanced.html#standalone-functions-from-rlang) from {rlang}

# cocoon 0.1.0

### NEW FEATURES

* Added `format_stats()` function to apply to accepted statistical objects (correlations, t-tests, Bayes factors). This is a generic function that recognizes the object class and uses the appropriate method, so it supercedes `format_corr()` and `format_ttest()`. `format_bf()` can still be used to format numeric type Bayes factors.
* Added ability to format output from `correlation::correlation()`.

### DOCUMENTATION UPDATES

* Reorder sections in vignette.
* Improve spacing and comments in examples.
* Add alt text to images.

### PACKAGE DEVELOPMENT

* Move string building to internal `build_string()` function.
* Split functions into separate format_stats, format_statvalues, and format_summary scripts


# cocoon 0.0.1

* Initial release of `{cocoon}`.
