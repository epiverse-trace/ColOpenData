
<!-- README.md is generated from README.Rmd. Please edit that file. -->
<!-- The code to render this README is stored in .github/workflows/render-readme.yaml -->
<!-- Variables marked with double curly braces will be transformed beforehand: -->
<!-- `packagename` is extracted from the DESCRIPTION file -->
<!-- `gh_repo` is extracted via a special environment variable in GitHub Actions -->

# ColOpenData 
<!-- <img src="man/figures/logo.svg" align="right" width="120" /> -->

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/license/mit/)
[![R-CMD-check](https://github.com/epiverse-trace/ColOpenData/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/epiverse-trace/ColOpenData/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/epiverse-trace/ColOpenData/branch/main/graph/badge.svg)](https://app.codecov.io/gh/epiverse-trace/ColOpenData?branch=main)
[![lifecycle-concept](https://raw.githubusercontent.com/reconverse/reconverse.github.io/master/images/badge-concept.svg)](https://www.reconverse.org/lifecycle.html#concept)
<!-- badges: end -->

ColOpenData is a package that acquires, standardizes, and wrangles Colombian
socioeconomic, climate and land cover data. It solves the problem of
Colombian data being issued in different web pages and formats by using functions that
allow the user to select the desired database and download it without having to do the
exhausting acquisition process. Also, it allows these datasets to be merged so multiple
operations, such as calculating statistics, can be made, taking into account information
from different datasets.

<!-- This sentence is optional and can be removed -->

ColOpenData is developed at the [Universidad de Los
Andes](https://uniandes.edu.co/) as part of the [Epiverse-TRACE
program](https://data.org/initiatives/epiverse/).

## Installation

You can install the development version of packagetemplate from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("epiverse-trace/ColOpenData")
```

### Lifecycle

This package is currently a *concept*, as defined by the [RECON software
lifecycle](https://www.reconverse.org/lifecycle.html). This means that
essential features and mechanisms are still being developed, and the
package is not ready for use outside of the development team.

### Contributions

Contributions are welcome via [pull
requests](https://github.com/epiverse-trace/ColOpenData/pulls).

### Code of Conduct

Please note that the packagetemplate project is released with a
[Contributor Code of
Conduct](https://github.com/epiverse-trace/.github/blob/main/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.
