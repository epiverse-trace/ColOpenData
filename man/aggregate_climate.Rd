% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/aggregate_climate.R
\name{aggregate_climate}
\alias{aggregate_climate}
\title{Aggregate climate data for different frequencies}
\usage{
aggregate_climate(climate_data, frequency)
}
\arguments{
\item{climate_data}{\code{data.frame} obtained from download functions. Only
observations under the same tag can be aggregated.}

\item{frequency}{character with the aggregation frequency: (\code{"day"},
\code{"month"} or \code{"year"}).}
}
\value{
\code{data.frame} object with the aggregated data.
}
\description{
Aggregate time series downloaded climate data to day, month or year.
Only observations under the tags \code{TSSM_CON}, \code{TMN_CON},
\code{TMX_CON}, \code{PTPM_CON}, and \code{BSHG_CON} can be aggregated,
since are the ones where methodology for aggregation is explicitly provided
by the source.
}
\examples{
\donttest{
lat <- c(4.172817, 4.172817, 4.136050, 4.136050, 4.172817)
lon <- c(-74.749121, -74.686169, -74.686169, -74.749121, -74.749121)
polygon <- sf::st_polygon(x = list(cbind(lon, lat)))
geometry <- sf::st_sfc(polygon)
roi <- sf::st_as_sf(geometry)
ptpm <- download_climate_geom(roi, "2022-11-01", "2022-12-31", "PTPM_CON")
monthly_ptpm <- aggregate_climate(ptpm, "month")
head(monthly_ptpm)
}

}
