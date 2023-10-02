
<!-- README.md is generated from README.Rmd. Please edit that file. -->
<!-- The code to render this README is stored in .github/workflows/render-readme.yaml -->
<!-- Variables marked with double curly braces will be transformed beforehand: -->
<!-- `packagename` is extracted from the DESCRIPTION file -->
<!-- `gh_repo` is extracted via a special environment variable in GitHub Actions -->

# ColOpenData <img src="man/figures/logo.svg" align="right" width="120" />

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/license/mit/)
[![R-CMD-check](https://github.com/epiverse-trace/ColOpenData/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/epiverse-trace/ColOpenData/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/epiverse-trace/ColOpenData/branch/main/graph/badge.svg)](https://app.codecov.io/gh/epiverse-trace/ColOpenData?branch=main)
[![lifecycle-concept](https://raw.githubusercontent.com/reconverse/reconverse.github.io/master/images/badge-concept.svg)](https://www.reconverse.org/lifecycle.html#concept)
<!-- badges: end -->

ColOpenData is a package that acquires, standardizes, and wrangles
Colombian socioeconomic, climate and land cover data. It solves the
problem of Colombian data being issued in different web pages and
formats by using functions that allow the user to select the desired
database and download it without having to do the exhausting acquisition
process. Also, it allows these datasets to be merged so multiple
operations, such as calculating statistics, can be made, taking into
account information from different datasets.

<!-- This sentence is optional and can be removed -->

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

## Quick start

This example shows how to retrieve census data at a department level in
Colombia including the administrative divisions and spatial data. We
will be using the `MGNCNPV01` dataset to subset a certain region and
calculate the population density on each department of this region.
We’ll also be using some extra packages to transform and plot data.

``` r
library(ColOpenData)
library(sf)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
```

To download the dataset we can use the `download` function as follows

``` r
census <- download("MGNCNPV01")
```

Once downloaded, we can filter the data to subset only the regions of
interest. We will be selecting the departments in the Amazonian region
using the [DIVIPOLA codes](https://www.datos.gov.co/widgets/gdxc-w37w)
of each, and to calculate the population density we’ll select the name,
population and area.

``` r
amazonia <- census %>%
  filter_mgn_cnpv(
    codes = c(91, 18, 19, 94, 95, 50, 52, 86, 97, 99),
    columns = c("DPTO_CNMBR", "STP27_PERS", "AREA"),
    include_geometry = TRUE
  )
```

As the area is stated in {m^2} we’ll transform it to {km^2} and
calculate the density in each department.

``` r
amazonia <- amazonia %>%
  mutate(
    AREA = AREA / 1000000,
    DENSITY = STP27_PERS / AREA
  )
```

Finally, to visualize the data we’ll plot a map with the density.

``` r
ggplot(data = amazonia) +
  geom_sf(mapping = aes(fill = DENSITY)) +
  scale_fill_gradientn(
    colours = brewer.pal(7, "YlOrRd"),
    name = expression("Density [" * People / km^2 * "]")
  ) +
  ggtitle("Population density by square kilometer") +
  theme_bw()
```

<img src="man/figures/README-plot_data-1.png" width="100%" />

### Lifecycle

This package is currently a *concept*, as defined by the [RECON software
lifecycle](https://www.reconverse.org/lifecycle.html). This means that
essential features and mechanisms are still being developed, and the
package is not ready for use outside of the development team.

### Contributions

Contributions are welcome via [pull
requests](https://github.com/ColOpenData/pulls).

### Code of Conduct

Please note that the ColOpenData project is released with a [Contributor
Code of
Conduct](https://github.com/epiverse-trace/.github/blob/main/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.
