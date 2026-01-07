# Format character strings with italics and type

Format character strings with italics and type

## Usage

``` r
format_chr(x, italics = TRUE, type = "md")
```

## Arguments

- x:

  Character string.

- italics:

  Logical value (default = TRUE) for whether text should be italicized.

- type:

  Type of formatting (`"md"` = markdown, `"latex"` = LaTeX).

## Value

A character string that has either Markdown or LaTeX formatting for
italics or not.

## Examples

``` r
format_chr("Hello world!")
#> [1] "_Hello world!_"
# Format in LaTeX syntax
format_chr("Hello world!", type = "latex")
#> [1] "$Hello world!$"
# Remove italics
format_chr("Hello world!", italics = FALSE)
#> [1] "Hello world!"
```
