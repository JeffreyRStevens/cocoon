# Format p-values

`format_p()` inputs numeric vectors of p-values. Cutoffs can be set that
format the values as less than the cutoffs (e.g., p \< 0.001). The
default output is APA formatted, but numbers of digits, cutoffs, leading
zeros, and italics are all customizable.

## Usage

``` r
format_p(
  x,
  digits = 3,
  pzero = FALSE,
  label = "p",
  italics = TRUE,
  type = "md"
)
```

## Arguments

- x:

  Number representing p-value.

- digits:

  Number of digits after the decimal for p-values, ranging between 1-5
  (also controls cutoff for small p-values).

- pzero:

  Logical value (default = FALSE) for whether to include leading zero
  for p-values.

- label:

  Character string for label before p value. Default is p. Set
  `label = ""` to return just the formatted p value with no label or
  operator (`=`, `<`, `>`).

- italics:

  Logical value (default = TRUE) for whether label should be italicized
  (*p*).

- type:

  Type of formatting ("md" = markdown, "latex" = LaTeX).

## Value

A character string that includes *p* and then the p-value formatted in
Markdown or LaTeX. If p-value is below `digits` cutoff, `p < cutoff` is
used.

## Examples

``` r
# Format p-value
format_p(0.001)
#> [1] "_p_ = .001"

# Format p-value vector
format_p(c(0.001, 0.01))
#> [1] "_p_ = .001" "_p_ = .010"

# Round digits for p-values greater than cutoff
format_p(0.111, digits = 2)
#> [1] "_p_ = .11"

# Default cutoff is p < 0.001
format_p(0.0001)
#> [1] "_p_ < .001"

# Set cutoff with digits
format_p(0.0001, digits = 2)
#> [1] "_p_ < .01"

# Include leading zero
format_p(0.001, pzero = TRUE)
#> [1] "_p_ = 0.001"

# Return only Bayes factor value (no label)
format_p(0.001, label = "")
#> [1] ".001"

# Format for LaTeX
format_p(0.001, type = "latex")
#> [1] "$p$ = .001"
```
