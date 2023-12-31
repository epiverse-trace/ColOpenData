% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_weather.R
\name{weather_stations}
\alias{weather_stations}
\title{Retrieve weather from stations}
\usage{
weather_stations(
  stations,
  start_date,
  end_date,
  frequency,
  tags,
  group = FALSE
)
}
\arguments{
\item{stations}{vector containing the stations codes}

\item{start_date}{starting date in format "YYYY-MM-DD"}

\item{end_date}{end date in format "YYYY-MM-DD"}

\item{frequency}{aggregation frequency. Can be "day", "week","month" or
"year"}

\item{tags}{character containing tags to analyze}

\item{group}{if TRUE, returns only one observation from the mean of the
stations consulted. Default is FALSE}
}
\value{
data.frame with the observed data for the given geometry
}
\description{
Retrieve weather stations with observed data in a given geometry.
}
\examples{
\dontrun{
weather_stations(stations, "2021-11-14", "2021-11-30", "day", "TSSM_CON")
}

}
