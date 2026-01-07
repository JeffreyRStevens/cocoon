# Format numbers

Format numbers

## Usage

``` r
format_num(x, digits = 1, pzero = TRUE)
```

## Arguments

- x:

  Number.

- digits:

  Number of digits after the decimal.

- pzero:

  Logical value (default = TRUE) for whether to include leading zero
  numbers less than 1.

## Value

A character string formatting the number with specified number of digits
after the decimal.

## Examples

``` r
format_num(pi, digits = 2)
#> [1] "3.14"
format_num(pi, digits = 4)
#> [1] "3.1416"
```
