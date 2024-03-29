% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/format_numbers.R
\name{format_sub}
\alias{format_sub}
\title{Format subscript text}
\usage{
format_sub(subscript = NULL, type = "md")
}
\arguments{
\item{subscript}{Character string or NULL}

\item{type}{Type of formatting (\code{"md"} = markdown, \code{"latex"} = LaTeX)}
}
\value{
A character string that is formatted as subscript for either Markdown or
LaTeX.
}
\description{
Format subscript text
}
\examples{
format_sub("Hello world!")
# Format in LaTeX syntax
format_sub("Hello world!", type = "latex")
}
