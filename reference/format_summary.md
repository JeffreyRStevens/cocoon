# Calculate and format summary statistics of central tendency and error

`format_summary()` is a general function that allows you to either
automatically calculate mean/median and a measure of error from a data
vector or specify already calculated a mean/median and either an error
interval or error limits. Error measures include confidence intervals,
standard deviation, and standard error of the mean. Each of those has a
specific function that formats means and those error measures using APA
(7th edition) style. So `format_meanci()`, `format_meansd()`,
`format_meanse()`, and `format_medianiqr()` are wrappers around
`format_summary()` for specific error measures with a default style. To
just format the mean or median with no error, use `format_mean()` or
`format_median()`. All measures ignore NAs.

## Usage

``` r
format_summary(
  x = NULL,
  tendency = "mean",
  error = "ci",
  values = NULL,
  digits = 1,
  tendlabel = "abbr",
  italics = TRUE,
  subscript = NULL,
  units = NULL,
  display = "limits",
  cilevel = 0.95,
  errorlabel = TRUE,
  type = "md"
)

format_mean(
  x = NULL,
  tendency = "mean",
  values = NULL,
  digits = 1,
  tendlabel = "abbr",
  italics = TRUE,
  subscript = NULL,
  units = NULL,
  display = "none",
  type = "md"
)

format_meanci(
  x = NULL,
  tendency = "mean",
  error = "ci",
  values = NULL,
  digits = 1,
  tendlabel = "abbr",
  italics = TRUE,
  subscript = NULL,
  units = NULL,
  display = "limits",
  cilevel = 0.95,
  errorlabel = TRUE,
  type = "md"
)

format_meanse(
  x = NULL,
  tendency = "mean",
  error = "se",
  values = NULL,
  digits = 1,
  tendlabel = "abbr",
  italics = TRUE,
  subscript = NULL,
  units = NULL,
  display = "par",
  errorlabel = TRUE,
  type = "md"
)

format_meansd(
  x = NULL,
  tendency = "mean",
  error = "sd",
  values = NULL,
  digits = 1,
  tendlabel = "abbr",
  italics = TRUE,
  subscript = NULL,
  units = NULL,
  display = "par",
  errorlabel = TRUE,
  type = "md"
)

format_median(
  x = NULL,
  tendency = "median",
  values = NULL,
  digits = 1,
  tendlabel = "abbr",
  italics = TRUE,
  subscript = NULL,
  units = NULL,
  display = "none",
  type = "md"
)

format_medianiqr(
  x = NULL,
  tendency = "median",
  error = "iqr",
  values = NULL,
  digits = 1,
  tendlabel = "abbr",
  italics = TRUE,
  subscript = NULL,
  units = NULL,
  display = "par",
  errorlabel = TRUE,
  type = "md"
)
```

## Arguments

- x:

  Numeric vector of data to calculate mean and error.

- tendency:

  Character vector specifying measure of central tendency ("mean" =
  mean, "median" = median).

- error:

  Character vector specifying error type ("ci" = confidence interval,
  "se" = standard error of the mean, "sd" = standard deviation, "iqr" =
  interquartile range).

- values:

  Numeric vector of mean and interval or mean and lower and upper
  limits.

- digits:

  Number of digits after the decimal for means and error.

- tendlabel:

  Formatting for tendency label ("abbr" = M, "word" = Mean, "none" = no
  label).

- italics:

  Logical value (default = TRUE) for whether mean label should be
  italicized.

- subscript:

  Character string to include as subscript with mean label.

- units:

  Character string that gives units to include after mean value.

- display:

  Character vector specifying how to display error ("limits" = \[lower
  limit, upper limit\], "pm" = ±interval, "par" = (interval), "none" =
  do not display error).

- cilevel:

  Numeric scalar from 0-1 defining confidence level (defaults to 0.95).

- errorlabel:

  Logical value (default = TRUE) for whether error label (e.g., 95% CI)
  should be included.

- type:

  Type of formatting ("md" = markdown, "latex" = LaTeX).

## Value

A character string of mean and error formatted in Markdown or LaTeX. To
return only the mean (no error), set `display = "none"`.

## Examples

``` r
# Print mean and 95% confidence limits for fuel efficiency
format_meanci(mtcars$mpg)
#> [1] "_M_ = 20.1, 95% CI [17.9, 22.3]"

# Print mean and standard deviation
format_meansd(mtcars$mpg)
#> [1] "_M_ = 20.1 (_SD_ = 6.0)"

# Print mean and standard error of the mean
format_meanse(mtcars$mpg)
#> [1] "_M_ = 20.1 (_SE_ = 1.1)"

# Print mean
format_mean(mtcars$mpg)
#> [1] "_M_ = 20.1"

# Print mean and 95% confidence limits with no label for "95% CI"
format_meanci(mtcars$mpg, errorlabel = FALSE)
#> [1] "_M_ = 20.1,  [17.9, 22.3]"

# Print mean and standard error of the mean as plus/minus interval
format_meanse(mtcars$mpg, error = "se", display = "pm")
#> [1] "_M_ = 20.1 ± 1.1"

# Print mean and 90% confidence limits with units
format_meanci(mtcars$mpg, units = "cm", cilevel = 0.9)
#> [1] "_M_ = 20.1 cm, 90% CI [18.3, 21.9]"

# Print three-digit mean with subscript in LaTeX
format_summary(mtcars$mpg, digits = 3, subscript = "control", display = "none", type = "latex")
#> [1] "$M$$_{control}$ = 20.091"
```
