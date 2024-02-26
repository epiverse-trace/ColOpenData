#' Download climate from named geometry (municipality or department)
#'
#' @description
#' Download climate data from stations contained in a municipality or
#' department. This data is retrieved from local meteorological stations
#' provided by IDEAM
#'
#' @param code character with the DIVIPOLA code for the area
#' @param start_date character with the first date to consult in the format
#' \code{"YYYY-MM-DD"}
#' @param end_date character with the last date to consult in the format
#' \code{"YYYY-MM-DD"} (Last available date is \code{"2023-05-31"})
#' @param tags character containing climate tags to consult
#'
#' @examples
#' tssm <- download_climate("17001", "2021-11-14", "2021-11-20", "TSSM_CON")
#' print(tssm)
#'
#' @return data.frame with observations from the stations in the area
#'
#' @export
download_climate <- function(code, start_date, end_date, tags) {
  checkmate::assert_character(code)

  if (nchar(code) == 5) {
    mpios <- download_geospatial("DANE_MGNCNPV_2018_MPIO")
    area <- mpios[which(mpios$MPIO_CDPMP == code), "MPIO_CDPMP"]
  } else if (nchar(code) == 2) {
    dptos <- download_geospatial("DANE_MGNCNPV_2018_DPTO")
    area <- dptos[which(dptos$DPTO_CCDGO == code), "DPTO_CCDGO"]
  } else {
    stop("`code` cannot be found")
  }
  if (nrow(area) == 0) {
    stop("`code` cannot be found")
  }
  climate <- download_climate_geom(
    geometry = area,
    start_date = start_date,
    end_date = end_date,
    tags = tags
  )
  return(climate)
}

#' Download climate data from geometry
#'
#' @description
#' Download climate data from stations contained in a geometry. This data is
#' retrieved from local meteorological stations provided by IDEAM.
#'
#' @param geometry \code{sf} geometry containing the geometry for a given ROI.
#' This geometry can be either a \code{POLYGON} or \code{MULTIPOLYGON}
#' @param start_date character with the first date to consult in the format
#' \code{"YYYY-MM-DD"}
#' @param end_date character with the last date to consult in the format
#' \code{"YYYY-MM-DD"} (Last available date is \code{"2023-05-31"})
#' @param tags character containing climate tags to consult
#'
#' @examples
#' lat <- c(5.166278, 5.166278, 4.982247, 4.982247, 5.166278)
#' lon <- c(-75.678072, -75.327859, -75.327859, -75.678072, -75.678072)
#' polygon <- sf::st_polygon(x = list(cbind(lon, lat)))
#' geometry <- sf::st_sfc(polygon)
#' roi <- sf::st_as_sf(geometry)
#' tssm <- download_climate_geom(roi, "2021-11-14", "2021-11-20", "TSSM_CON")
#' print(tssm)
#'
#' @return \code{data.frame} with observations from the stations in the area
#'
#' @export
download_climate_geom <- function(geometry, start_date, end_date,
                                  tags) {
  checkmate::assert_class(geometry, "sf")

  stations <- stations_in_roi(geometry)
  climate_geom <- download_climate_stations(
    stations = stations,
    start_date = start_date,
    end_date = end_date,
    tags = tags
  )
  return(climate_geom)
}

#' Download climate data from stations
#'
#' @description
#' Download climate data from named stations.This data is
#' retrieved from local meteorological stations provided by IDEAM.
#'
#' @param stations \code{data.frame} containing the stations' codes. This 
#' \code{data.frame} must be retrieved from the function
#' \code{stations_in_roi()}
#' @param start_date character with the first date to consult in the format
#' \code{"YYYY-MM-DD"}
#' @param end_date character with the last date to consult in the format
#' \code{"YYYY-MM-DD"} (Last available date is \code{"2023-05-31"})
#' @param tags character containing climate tags to consult
#'
#' @examples
#' \dontrun{
#' tssm <- download_climate_stations(
#'   stations, "2021-11-14", "2021-11-20", "TSSM_CON"
#' )
#' print(tssm)
#' }
#'
#' @return \code{data.frame} with observations from the requested stations
#' @export
download_climate_stations <- function(stations, start_date, end_date, tags) {
  checkmate::assert_data_frame(stations)
  checkmate::assert_character(start_date)
  checkmate::assert_character(end_date)

  if (length(tags) == 1) {
    climate_data <- retrieve_stations_data(
      stations = stations,
      start_date = start_date,
      end_date = end_date,
      tag = tags
    )
  } else {
    climate_data <- list()
    for (tag in tags) {
      stations_data <- retrieve_stations_data(
        stations = stations,
        start_date = start_date,
        end_date = end_date,
        tag = tag
      )
      climate_data[[tag]] <- stations_data
    }
  }
  return(climate_data)
}
