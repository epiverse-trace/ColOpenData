% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_climate.R
\name{download_climate_geom}
\alias{download_climate_geom}
\title{Download climate data from geometry}
\usage{
download_climate_geom(geometry, start_date, end_date, tag)
}
\arguments{
\item{geometry}{\code{sf} object containing the geometry for a given ROI.
The geometry can be either a \code{POLYGON} or \code{MULTIPOLYGON}}

\item{start_date}{character with the first date to consult in the format
\code{"YYYY-MM-DD"}}

\item{end_date}{character with the last date to consult in the format
\code{"YYYY-MM-DD"} (Last available date is \code{"2023-05-31"})}

\item{tag}{character containing climate tag to consult}
}
\value{
\code{data.frame} object with observations from the stations in the
area
}
\description{
Download climate data from stations contained in a Region of Interest
(ROI/geometry). This data is retrieved from local meteorological stations
provided by IDEAM
}
\examples{
lat <- c(5.166278, 5.166278, 4.982247, 4.982247, 5.166278)
lon <- c(-75.678072, -75.327859, -75.327859, -75.678072, -75.678072)
polygon <- sf::st_polygon(x = list(cbind(lon, lat)))
geometry <- sf::st_sfc(polygon)
roi <- sf::st_as_sf(geometry)
tssm <- download_climate_geom(roi, "2021-11-14", "2021-11-20", "TSSM_CON")
head(tssm)

}
