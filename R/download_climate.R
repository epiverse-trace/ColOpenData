#' Download climate from named geometry (municipality or department)
#'
#' @description
#' Download climate data from stations contained in a municipality or
#' department. This data is retrieved from local meteorological stations
#' provided by IDEAM
#'
#' @param code character with the DIVIPOLA code for the area (2 digits for
#' departments and 5 digits for municipalities)
#' @param start_date character with the first date to consult in the format
#' \code{"YYYY-MM-DD"}
#' @param end_date character with the last date to consult in the format
#' \code{"YYYY-MM-DD"} (Last available date is \code{"2023-05-31"})
#' @param tag character containing climate tag to consult
#'
#' @examples
#' tssm <- download_climate("17001", "2021-11-14", "2021-11-20", "TSSM_CON")
#' head(tssm)
#'
#' @return \code{data.frame} object with observations from the stations in the
#' area
#'
#' @export
download_climate <- function(code, start_date, end_date, tag) {
  checkmate::assert_character(code)

  if (nchar(code) == 5) {
    # Municipalities have a five digit code
    mpios <- suppressMessages(download_geospatial("municipality",
      include_cnpv = FALSE
    ))
    filtered_area <- mpios[
      which(mpios$codigo_municipio == code),
      "codigo_municipio"
    ]
  } else if (nchar(code) == 2) {
    # Departments have a two digit code
    dptos <- suppressMessages(download_geospatial("department",
      include_cnpv = FALSE
    ))
    filtered_area <- dptos[
      which(dptos$codigo_departamento == code),
      "codigo_departamento"
    ]
  } else {
    stop("`code` must be either five digits for municipalities or two
            digits for departments")
  }
  if (nrow(filtered_area) == 0) {
    stop("`code` cannot be found")
  }
  climate <- download_climate_geom(
    geometry = filtered_area,
    start_date = start_date,
    end_date = end_date,
    tag = tag
  )
  return(climate)
}

#' Download climate data from geometry
#'
#' @description
#' Download climate data from stations contained in a Region of Interest
#' (ROI/geometry). This data is retrieved from local meteorological stations
#' provided by IDEAM
#'
#' @param geometry \code{sf} object containing the geometry for a given ROI.
#' The geometry can be either a \code{POLYGON} or \code{MULTIPOLYGON}
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
#' head(tssm)
#'
#' @return \code{data.frame} object with observations from the stations in the
#' area
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
#' Download climate data from IDEAM stations by individual codes.This data is
#' retrieved from local meteorological stations provided by IDEAM
#'
#' @param stations \code{data.frame} containing the stations' codes and
#' location
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
#' head(tssm)
#'
#' @return \code{data.frame} object with observations from the stations in the
#' area
#'
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
  start_date <- as.POSIXct(start_date,
    format = "%Y-%m-%d",
    tz = "UTC"
  )
  end_date <- as.POSIXct(end_date,
    format = "%Y-%m-%d",
    tz = "UTC"
  )
  stopifnot(
    "`end_date` must greater than `start_date`" =
      start_date <= end_date,
    "Dates are not in the expected format ('YYYY-MM-DD')" =
      !anyNA(c(start_date, end_date))
  )

  # Check that consulted tag exists
  checkmate::assert_character(tag, len = 1L)
  tag <- toupper(tag)
  ideam_tags <- c(
    "TSSM_CON", "THSM_CON", "TMN_CON", "TMX_CON",
    "TSTG_CON", "HR_CAL", "HRHG_CON", "TV_CAL",
    "TPR_CAL", "PTPM_CON", "PTPG_CON", "EVTE_CON",
    "FA_CON", "NB_CON", "RCAM_CON", "BSHG_CON",
    "VVAG_CON", "DVAG_CON", "VVMXAG_CON", "DVMXAG_CON"
  )
  checkmate::assert_choice(tag, ideam_tags)

  path_data <- retrieve_climate_path()
  path_stations <- paste0(tag, "@", stations$codigo, ".data")
  climate_data <- data.frame()
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
        climate_data <- rbind(climate_data, station_obs)
      }
    }
  }
  # If none of the stations provided data
  if (nrow(climate_data) == 0) {
    stop("There is no available information for the requested dates")
  }
  message(strwrap(
    prefix = "\n", initial = "",
    c(
      "Original data is retrieved from the Institute of Hydrology, Meteorology
      and Environmental Studies (Instituto de Hidrolog\u00eda,
      Meteorolog\u00eda y Estudios Ambientales - IDEAM).",
      "Reformatted by package authors.",
      "Stored by Universidad de Los Andes under the Epiverse TRACE iniative."
    )
  ))

  return(climate_data)
}

#' Stations in region of interest
#'
#' @description
#' Download and filter climate stations contained inside a region of interest
#' (ROI)
#'
#' @param geometry \code{sf} object containing the geometry for a given ROI.
#' The geometry can be either a \code{POLYGON} or \code{MULTIPOLYGON}
#'
#' @examples
#' lat <- c(5.166278, 5.166278, 4.982247, 4.982247, 5.166278)
#' lon <- c(-75.678072, -75.327859, -75.327859, -75.678072, -75.678072)
#' polygon <- sf::st_polygon(x = list(cbind(lon, lat)))
#' geometry <- sf::st_sfc(polygon)
#' roi <- sf::st_as_sf(geometry)
#' stations <- stations_in_roi(roi)
#' head(stations)
#'
#' @return \code{data.frame} object with the stations contained inside the
#' consulted geometry
#'
#' @export
stations_in_roi <- function(geometry) {
  checkmate::assert_class(geometry, "sf")

  crs <- sf::st_crs(geometry)
  data_path <- retrieve_support_path("IDEAM_STATIONS_2023_MAY")
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
