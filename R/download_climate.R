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
#' @param tag character containing climate tag to consult
#'
#' @examples
#' tssm <- download_climate("17001", "2021-11-14", "2021-11-20", "TSSM_CON")
#'
#' @return data.frame with observations from the stations in the area
#'
#' @export
download_climate <- function(code, start_date, end_date, tag) {
  checkmate::assert_character(code)

  if (nchar(code) == 5) {
    # Municipalities have a five digit code
    mpios <- download_geospatial("DANE_MGN_2018_MPIO")
    area <- mpios[which(mpios$MPIO_CDPMP == code), "MPIO_CDPMP"]
  } else if (nchar(code) == 2) {
    # Departments have a two digit code
    dptos <- download_geospatial("DANE_MGN_2018_DPTO")
    area <- dptos[which(dptos$DPTO_CCDGO == code), "DPTO_CCDGO"]
  } else {
    stop("`code` must be either five digits for municipalities or two
            digits for departments")
  }
  if (nrow(area) == 0) {
    # If code cannot be found in DIVIPOLA
    stop("`code` cannot be found")
  }
  climate <- download_climate_geom(
    geometry = area,
    start_date = start_date,
    end_date = end_date,
    tag = tag
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
#' @param tag character containing climate tag to consult
#'
#' @examples
#' lat <- c(5.166278, 5.166278, 4.982247, 4.982247, 5.166278)
#' lon <- c(-75.678072, -75.327859, -75.327859, -75.678072, -75.678072)
#' polygon <- sf::st_polygon(x = list(cbind(lon, lat)))
#' geometry <- sf::st_sfc(polygon)
#' roi <- sf::st_as_sf(geometry)
#' tssm <- download_climate_geom(roi, "2021-11-14", "2021-11-20", "TSSM_CON")
#'
#' @return \code{data.frame} with observations from the stations in the area
#'
#' @export
download_climate_geom <- function(geometry, start_date, end_date,
                                  tag) {
  checkmate::assert_class(geometry, "sf")

  stations <- stations_in_roi(geometry)
  climate_geom <- download_climate_stations(
    stations = stations,
    start_date = start_date,
    end_date = end_date,
    tag = tag
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
#' @param tag character containing climate tag to consult
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @examples
#' lat <- c(5.166278, 5.166278, 4.982247, 4.982247, 5.166278)
#' lon <- c(-75.678072, -75.327859, -75.327859, -75.678072, -75.678072)
#' polygon <- sf::st_polygon(x = list(cbind(lon, lat)))
#' geometry <- sf::st_sfc(polygon)
#' roi <- sf::st_as_sf(geometry)
#' stations <- stations_in_roi(roi)
#' tssm <- download_climate_stations(
#'   stations, "2021-11-14", "2021-11-20", "TSSM_CON"
#' )
#'
#' @return \code{data.frame} with observations from the requested stations
#' @export
download_climate_stations <- function(stations, start_date, end_date, tag) {
  # Check stations minimum data
  checkmate::assert_data_frame(stations)
  checkmate::assert_subset(
    c("codigo", "longitud", "latitud"),
    names(stations)
  )

  # Check dates formats and that the end date is greater than the start date
  checkmate::assert_character(start_date)
  checkmate::assert_character(end_date)
  tryCatch(
    {
      start_date <- as.POSIXct(start_date,
        format = "%Y-%m-%d",
        tz = "UTC"
      )
      end_date <- as.POSIXct(end_date,
        format = "%Y-%m-%d",
        tz = "UTC"
      )
    },
    error = function(e) {
      stop("Dates are not in the right format")
    }
  )
  stopifnot(
    "`end_date` must greater than `start_date`" =
      start_date <= end_date
  )

  # Check that consulted tag exists
  checkmate::assert_character(tag, len = 1L)
  ideam_tags <- c(
    "TSSM_CON", "THSM_CON", "TMN_CON", "TMX_CON",
    "TSTG_CON", "HR_CAL", "HRHG_CON", "TV_CAL",
    "TPR_CAL", "PTPM_CON", "PTPG_CON", "EVTE_CON",
    "FA_CON", "NB_CON", "RCAM_CON", "BSHG_CON",
    "VVAG_CON", "DVAG_CON", "VVMXAG_CON", "DVMXAG_CON"
  )
  checkmate::assert_choice(tag, ideam_tags)

  path_data <- retrieve_path("IDEAM_CLIMATE_2023_MAY")
  path_stations <- paste0(tag, "@", stations$codigo, ".data")
  stations_data <- data.frame()
  for (i in seq_along(path_stations)) {
    dataset_path <- file.path(path_data, path_stations[i])
    downloaded_station <- retrieve_climate(dataset_path)
    # If path exists and data can be downloaded
    if (!rlang::is_empty(downloaded_station)) {
      station_filtered <- downloaded_station %>%
        dplyr::filter(
          .data$date >= start_date,
          .data$date <= end_date + 1
        )
      n_obs <- nrow(station_filtered)
      # If there is available data in the requested date range
      if (n_obs > 0) {
        station_obs <- data.frame(
          station = rep(stations$codigo[i], n_obs),
          longitude = rep(stations$longitud[i], n_obs),
          latitude = rep(stations$latitud[i], n_obs),
          date = format(station_filtered$date, "%Y-%m-%d"),
          hour = format(station_filtered$date, "%H:%M:%S"),
          tag = rep(tag, n_obs),
          value = station_filtered$value,
          stringsAsFactors = FALSE
        )
        stations_data <- rbind(stations_data, station_obs)
      }
    }
  }
  # If none of the stations provided data
  if (nrow(stations_data) == 0) {
    stop("There is no available information available for these dates")
  }
  return(stations_data)
}

#' Stations in region of interest
#'
#' @description
#' Download and filter climate stations inside a region of interest (ROI)
#'
#' @param geometry \code{sf} geometry containing the geometry for a given ROI.
#' This geometry can be either a \code{POLYGON} or \code{MULTIPOLYGON}
#'
#' @examples
#' lat <- c(5.166278, 5.166278, 4.982247, 4.982247, 5.166278)
#' lon <- c(-75.678072, -75.327859, -75.327859, -75.678072, -75.678072)
#' polygon <- sf::st_polygon(x = list(cbind(lon, lat)))
#' geometry <- sf::st_sfc(polygon)
#' roi <- sf::st_as_sf(geometry)
#' stations <- stations_in_roi(roi)
#'
#' @return \code{data.frame} with the stations inside the consulted geometry
#'
#' @export
stations_in_roi <- function(geometry) {
  checkmate::assert_class(geometry, "sf")

  crs <- sf::st_crs(geometry)
  data_path <- retrieve_path("IDEAM_STATIONS_2023_MAY")
  stations <- retrieve_table(data_path, ",")
  geo_stations <- sf::st_as_sf(stations,
    coords = c("longitud", "latitud"),
    remove = FALSE
  )
  geo_stations <- sf::st_set_crs(
    geo_stations,
    crs
  )
  intersections <- sf::st_within(geo_stations,
    geometry,
    sparse = FALSE
  )
  stations_in_roi <- geo_stations[which(intersections), ]
  if (nrow(stations_in_roi) == 0) {
    stop("There are no stations in the specified ROI")
  }
  return(stations_in_roi)
}
