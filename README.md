
<!-- README.md is generated from README.Rmd. Please edit that file. -->
<!-- The code to render this README is stored in .github/workflows/render-readme.yaml -->
<!-- Variables marked with double curly braces will be transformed beforehand: -->
<!-- `packagename` is extracted from the DESCRIPTION file -->
<!-- `gh_repo` is extracted via a special environment variable in GitHub Actions -->

# {{ packagename }} <img src="man/figures/logo.svg" align="right" width="200"/>

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/license/mit/)
[![R-CMD-check](https://github.com/epiverse-trace/ColOpenData/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/epiverse-trace/ColOpenData/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/epiverse-trace/ColOpenData/branch/main/graph/badge.svg)](https://app.codecov.io/gh/epiverse-trace/ColOpenData?branch=main)
[![lifecycle-experimental](https://raw.githubusercontent.com/reconverse/reconverse.github.io/master/images/badge-experimental.svg)](https://www.reconverse.org/lifecycle.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/ColOpenData)](https://CRAN.R-project.org/package=ColOpenData)

<!-- badges: end -->

**ColOpenData** is a package designed to access curated and wrangled
Colombian demographic, geospatial and climate data, retrieved from
various open Colombian data sources. The package addresses the challenge
of scattered Colombian data across multiple web sources by providing
functions that enable users to select and load desired datasets without
the need for extensive data acquisition processes. Additionally, the
tidy data structure offered for demographic and climate data facilitates
analysis and visualization.

ColOpenData is developed at [Universidad de Los
Andes](https://uniandes.edu.co/) as part of the [Epiverse-TRACE
program](https://data.org/initiatives/epiverse/).

## Installation

You can install the development version of ColOpenData from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("epiverse-trace/ColOpenData")
```

## Quick Overview

**ColOpenData** contains data from two public data sources: The National
Administrative Department of Statistics
[(DANE)](https://www.dane.gov.co/index.php/en/), and the Institute of
Hydrology, Meteorology and Environmental Studies
[(IDEAM)](http://www.ideam.gov.co/). The available data is divided in
four categories:

- **Demographic:** Demographic and Socioeconomic data presents
  information from the National Population and Dwelling Census (CNPV)
  of 2018. The CNPV data corresponds to the most recent census available
  to date and the information is presented as an answer to three
  questions: How many are we?, Where are we? and How do we live? Further
  information can be consulted
  [here](https://www.dane.gov.co/index.php/estadisticas-por-tema/demografia-y-poblacion/censo-nacional-de-poblacion-y-vivenda-2018).

- **Geospatial:** This data is retrieved from the National
  Geostatistical Framework (MGN), which includes maps and a summarized
  version of the 2018 census, aggregated to spatial geometries. The data
  is available at different aggregation levels including: Blocks, Urban
  and Rural Sections, Urban and Rural Sectors, Urban Areas,
  Municipalities and Departments. More information is available
  [here](https://www.dane.gov.co/index.php/actualidad-dane/5454-el-dane-actualizo-el-marco-geoestadistico-nacional-a-2018).

- **Climate:** Climate data is recovered from backup information
  provided by IDEAM, containing historical data from the first station
  in the country until May 31st 2023. This backup includes temperature,
  precipitation, sunshine duration, wind direction, among others. More
  information can be found [here](http://www.ideam.gov.co/).

- **Population projections:** Population Projections data contains the
  population projections and back projections from 1950 to 2070,
  considering the post COVID-19 update, which was calculated based on
  the results of CNPV of 2018. Further information can be consulted
  [here](https://www.dane.gov.co/index.php/estadisticas-por-tema/demografia-y-poblacion/proyecciones-de-poblacion).

Documentation and vignettes are available for the modules in the [user
vignettes](https://epiverse-trace.github.io/ColOpenData/).

### Related R Packages

Similar R packages are offered for international communities, allowing
the user to download census, geospatial and climate data.

- [cancensus](https://mountainmath.github.io/cancensus/): Canada
- [censobr](https://ipeagit.github.io/censobr/): Brazil
- [tidycensus](https://walker-data.com/tidycensus/): US
- [geofi](https://ropengov.github.io/geofi/): Finland
- [climate](https://bczernecki.github.io/climate/)

### Lifecycle

This package is currently *experimental*, as defined by the [RECON
software lifecycle](https://www.reconverse.org/lifecycle.html).
Therefore, this is a functional draft and can be tested outside of the
development team. However, it still may change over time.

### Contributions

Contributions are welcome via [pull
requests](https://github.com/ColOpenData/pulls).

### Code of Conduct

Please note that the ColOpenData project is released with a [Contributor
Code of
Conduct](https://github.com/epiverse-trace/.github/blob/main/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.

### Funding

This work is part of the TRACE-LAC research project funded by the
International Research Centre (IDRC) Ottawa, Canada.\[109848-001-\].
