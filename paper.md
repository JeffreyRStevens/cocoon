---
title: 'cocoon: An R package for extracting, formatting, and printing statistical output'
tags:
  - R
  - formatting
  - LaTeX
  - Markdown
  - statistical objects
authors:
  - name: Jeffrey R. Stevens
    orcid: 0000-0003-2375-1360
    affiliation: 1
affiliations:
 - name: Department of Psychology, Center for Brain, Biology & Behavior, University of Nebraska-Lincoln
   index: 1
date: "2024-10-11"
bibliography: paper.bib
output:
  html_document:
    keep_md: yes
---

# Summary

Formatting statistics from R statistical objects can be troublesome. One must first find, extract, and include the relevant statistical values, format the values properly with leading zeros and appropriate rounding, and format the statistical labels to match norms or style guides. Doing this with inline code can be messy and hard to read with mulitple functions working in tandem to complete the formatting. Existing packages can extract and format statistics, but they often return output formatted for specific style guides and lack flexibility to precisely control the formatting in other ways. The `{cocoon}` package allows for flexible formatting of statistical objects, statistical values, and numbers more generally to allow users to easily embed statistical information in their reproducible research documents.


# Statement of need

Converting the output of statistical software into a format that can be communicated in documents and presentations can be complicated. Researchers must extract the relevant information from the statistical output then format it in a way to clearly communicate it. Literate programming [@Knuth.1992] involves interweaving code snippets into text, embedding the output of the code to be inserted into the text. A key advantage of literate programming is that the analyses can be reproducible [@Marwick.etal.2018a; @Stodden.etal.2018]. When readers can access the analysis code and see where it is embedded in the text, they are able to directly reproduce the analyses to verify accuracy and explore other possibilities.

In the R community, the `{knitr}` package [@Xie.2014; @Xie.2015] allows users to embed R code into R Markdown and Quarto documents. However, statistical objects in R are often complicated nested lists that can make it difficult to extract the relevant statistics and values that authors want to report in their documents. Functions have been created that extract commonly used values from statistical objects and return them formatted in a way that can be inserted in inline code. For instance, in the `{papaja}` package [@Aust.Barth.2023], the `apa_print()` function can be applied to a range of statistical objects such as correlations and t-tests to extract test statistics, means, confidence intervals, degrees of freedom, and p-values and return character strings that can be embedded in documents to communicate the statistics.

In the field of psychology, a number of packages have been developed to extract and return common statistics for integration in documents [e.g., `{apa}` @Gromer.2023; `{insight}` @Ludecke.etal.2019; `{papaja}` @Aust.Barth.2023]. A key limitation of these packages though, is that they tend to only format statistics using the American Psychological Association (APA) Style Guide. This means that the formatting is very specific in how statistics are presented. For instance, APA style requires that the leading zero before values that can only range between -1 and 1 must be removed. So correlations and p-values do not have a leading zero (e.g., _r_ = -.15, _p_ = .05). Many scientific journals and other outlets of research have different style guides. The existing packages for formatting statistics are relatively inflexible in how those statistics are formatted. Moreover, some of those packages output only LaTeX-formatted statistics. Though this is fine for producing PDF documents, LaTeX syntax produces undesirable symbols and mathematical objects when producing HTML and Word documents. Thus, the existing statistical formatting packages lack flexibility in how statistics are formatted and output.

The aim of the `{cocoon}` package is to provide functions that flexibly format statistical output in a way that can be inserted into R Markdown or Quarto documents. The `{cocoon}` package uses APA style as the default, but it allows more flexible formatting of which statistics are included, how the labels are formatted, and how the values are formatted. All functions also output Markdown syntax by default but can be modified to output LaTeX syntax.

The `{cocoon}` package includes a number of functions to format different kinds of inputs. The `format_stats()` generic function applies methods for specific object classes to extract relevant statistics. For instance, applying `format_stats()` to an object returned by `cor.test()` will extract correlation coefficients, confidence intervals, and p-values from the object and generate a character string than can be embedded inline in an R Markdown or Quarto document (e.g., _r_ = -.85, 95% CI [-0.93, -0.72], _p_ < .001). In addition, other functions can be applied directly to numeric values themselves to format them appropriately. For example, the `format_bf()` function can take a numeric value representing a Bayes factor and prepend it will a label and equals sign (e.g., _BF_~10~ = 12.3). The `format_summary()` functions can either calculate summary statistics from a data vector or directly format a vector of central tendency and upper and lower error bounds (e.g., _M_ = 20.1, 95% CI [17.9, 22.3] OR _M_ = 12.6, 95% CI [12.5, 12.6]).


The suite of functions in `{cocoon}` allows users to control numbers of digits, leading zeros, cutoff minima/maxima, the presence of means, confidence intervals, and degrees of freedom, statistical labels, italics, and output format (Markdown or LaTeX). These options give users control over the formatting of their statistics, thereby facilitating a flexible, consistent way of communicating their statistics.


# References