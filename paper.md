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
date: 2024-03-19
# bibliography: paper.bib
---

# Summary

Collecting survey data online can result in low-quality data. Survey participants may not complete the survey, may complete the survey too quickly or slowly, may not reside in the country they claim, or may use unacceptable screen types. Also, online surveys are plagued by automated bots attempting to complete the surveys while offering worthless data. Researchers collecting online data may want to check their data for these and other potential criteria to exclude problematic data entries. The `excluder` package uses three main function types to mark, check, and exclude data based on seven different exclusion criteria.

# Statement of need

Researchers who conduct online surveys may use [Qualtrics](https://qualtrics.com) or other online systems to collect data from participants. Those participants may be recruited directly via listservs or through third party vendors that connect researchers and participants, such as [Amazon Mechanical Turk](https://www.mturk.com/) and [Prolific](https://prolific.co/). Ensuring good data quality from these participants can be tricky [@Aruguete.etal.2019;@Chmielewski.Kucker.2020;@Gupta.etal.2021;@Eyal.etal.2021]. For instance, while Mechanical Turk in theory screens workers based on location (e.g., if you want to restrict your participant pool to workers in the United States), this is not necessarily represented in the data when participant IP addresses are recorded. Also, automated bots are constantly trying to complete online surveys with worthless data. Therefore, researchers may want to screen their data for certain exclusion criteria.

Finding the tools to screen for IP address location can be difficult, and the `excluder` package simplifies working with exclusion criteria based on data that Qualtrics reports, including geolocation, IP address, duplicate records from the same location, participant screen resolution, participant progress through the survey, and survey completion duration. `excluder` is an R [@RCoreTeam.2021] package based on the `tidyverse` [@Wickham.etal.2019] framework that use three primary functions to (1) mark existing files with new columns that flag data rows meeting exclusion criteria, (2) view the subset of data rows that meet exclusion criteria, and (3) exclude data rows that meet exclusion criteria from the data. In addition, `excluder` helps prepare Qualtrics data for analysis and can deidentify the data by removing columns with potentially identifiable information. Though the functionality focuses on data collected by Qualtrics and imported by the `qualtRics` [@Ginn.Silge.2021] package, it is flexible enough for researchers using any source of online survey data.

# Acknowledgments

I thank [Francine Goh](https://orcid.org/0000-0002-7364-4398) and Billy Lim for comments on an early version of the package, as well as the insightful feedback from rOpenSci staff [Mauro Lepore](https://orcid.org/0000-0002-1986-7988), [Joseph O'Brien](https://orcid.org/0000-0001-9851-5077), and [Julia Silge](https://orcid.org/0000-0002-3671-836X). This work was funded by US National Science Foundation grant NSF-1658837.

# References
