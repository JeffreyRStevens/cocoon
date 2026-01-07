# Format numbers in scientific notation

Format numbers in scientific notation

## Usage

``` r
format_scientific(x, digits = 1, type = "md")
```

## Arguments

- x:

  Number.

- digits:

  Number of digits after the decimal.

- type:

  Type of formatting ("md" = markdown, "latex" = LaTeX).

## Value

A character string of a number in scientific notation formatted in
Markdown or LaTeX.

## Examples

``` r
format_scientific(1111)
#> [1] "1.1×10^3^"
# Control number of digits after decimal with digits
format_scientific(1111, digits = 3)
#> [1] "1.111×10^3^"
```
