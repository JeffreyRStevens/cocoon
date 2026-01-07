# Format subscript text

Format subscript text

## Usage

``` r
format_sub(subscript = NULL, type = "md")
```

## Arguments

- subscript:

  Character string or NULL.

- type:

  Type of formatting (`"md"` = markdown, `"latex"` = LaTeX).

## Value

A character string that is formatted as subscript for either Markdown or
LaTeX.

## Examples

``` r
format_sub("Hello world!")
#> [1] "~Hello world!~"
# Format in LaTeX syntax
format_sub("Hello world!", type = "latex")
#> [1] "$_{Hello world!}$"
```
