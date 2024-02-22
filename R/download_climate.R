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
#'  @param frequency character with the aggregation frequency. (\code{"day"},
#'  \code{"month"} or \code{"year"})
#'
#' @examples
#' tssm <- download_climate(
#'   "17001", "2021-11-14", "2021-11-20",
#'   "day", "TSSM_CON"
#' )
#' print(tssm)
#'
#' @return data.frame with observations from the stations in the area
#'
#' @export
download_climate <- function(code, start_date, end_date, frequency, tags) {
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
    frequency = frequency,
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
#'  @param frequency character with the aggregation frequency. (\code{"day"},
#'  \code{"month"} or \code{"year"})
#' @param tags character containing climate tags to consult
#'
#' @examples
#' lat <- c(5.166278, 5.166278, 4.982247, 4.982247, 5.166278)
#' lon <- c(-75.678072, -75.327859, -75.327859, -75.678072, -75.678072)
#' polygon <- sf::st_polygon(x = list(cbind(lon, lat)))
#' geometry <- sf::st_sfc(polygon)
#' roi <- sf::st_as_sf(geometry)
#' tssm <- download_climate_geom(
#'   roi, "2021-11-14", "2021-11-20",
#'   "day", "TSSM_CON"
#' )
#' print(tssm)
#'
#' @return \code{data.frame} with observations from the stations in the area
#'
#' @export
download_climate_geom <- function(geometry, start_date, end_date, frequency,
                                  tags) {
  checkmate::assert_class(geometry, "sf")

  stations <- stations_in_roi(geometry)
  climate_geom <- download_climate_stations(
    stations = stations,
    start_date = start_date,
    end_date = end_date,
    frequency = frequency,
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
#' @param stations numeric vector containing the stations' codes
#' @param start_date character with the first date to consult in the format
#' \code{"YYYY-MM-DD"}
#' @param end_date character with the last date to consult in the format
#' \code{"YYYY-MM-DD"} (Last available date is \code{"2023-05-31"})
#'  @param frequency character with the aggregation frequency. (\code{"day"},
#'  \code{"month"} or \code{"year"})
#' @param tags character containing climate tags to consult
#'
#' @examples
#' stations <- c(26155110, 26155170)
#' tssm <- download_climate_stations(
#'   stations, "2021-11-14", "2021-11-20",
#'   "day", "TSSM_CON", TRUE
#' )
#' print(tssm)
#'
#' @return \code{data.frame} with observations from the requested stations
#' @export
download_climate_stations <- function(stations, start_date, end_date,
                                      frequency, tags) {
  checkmate::assert_data_frame(stations)
  checkmate::assert_character(start_date)
  checkmate::assert_character(end_date)
  checkmate::assert_choice(frequency, c("day", "month", "year"))

  if (length(tags) == 1) {
    climate_data <- retrieve_stations_data(
      stations = stations,
      start_date = start_date,
      end_date = end_date,
      frequency = frequency,
      tag = tags
    )
  } else {
      climate_data <- list()
      for (tag in tags) {
        stations_data <- retrieve_stations_data(
          stations = stations,
          start_date = start_date,
          end_date = end_date,
          frequency = frequency,
          tag = tag
        )
        climate_data[[tag]] <- stations_data
      }
  }
  return(climate_data)
}


#' Retrieve data from named stations for a specific tag#'
#'
#' @description
#' Retrieve climate data from a list of stations under the same tag.This data is
#' retrieved from local meteorological stations provided by IDEAM
#' @param stations numeric vector containing the stations' codes
#' @param start_date character with the first date to consult in the format
#' \code{"YYYY-MM-DD"}
#' @param end_date character with the last date to consult in the format
#' \code{"YYYY-MM-DD"} (Last available date is \code{"2023-05-31"})
#'  @param frequency character with the aggregation frequency. (\code{"day"},
#'  \code{"month"} or \code{"year"})
#'  @param tag unique character containing climate tags to consult
#'
#'  @importFrom rlang .data
#'  @importFrom magrittr %>%
#'  @return \code{data.frame} with observations from the requested stations
#'  @keywords internal
retrieve_stations_data <- function(stations, start_date, end_date,
                                   frequency, tag) {
  checkmate::assert_data_frame(stations) # Check for sf?
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
    # nolint start: nonportable_path_linter
    dataset_path <- file.path(path_data, path_stations[i])
    # nolint end

    # Request is different, since datasets might not be available
    base_request <- httr2::request(base_url = dataset_path)
    request <- httr2::req_error(base_request, is_error = \(resp) FALSE)
    response <- httr2::req_perform(request)
    if (httr2::resp_status(response) == 404) { # if not found go to next
      next
    } else {
      content <- httr2::resp_body_string(response)
      station_data <- suppressMessages(
        suppressWarnings(
          readr::read_delim(content,
            delim = "|",
            escape_double = FALSE,
            trim_ws = TRUE,
            show_col_types = FALSE
          )
        )
      )
      names(station_data) <- c("date", "value")
      station_data$date <- as.POSIXct(station_data$date,
        format = "%Y-%m-%d %H:%M:%S",
        tz = "UTC"
      )
      station_filtered <- station_data %>%
        dplyr::filter(
          .data$date >= start_date,
          .data$date <= (as.Date(end_date) + 1)
        )
      if (all(is.na(station_filtered))) {
        next
      } else {
        n_data <- nrow(station_filtered)
        output <- data.frame(
          station = rep(stations$codigo[i], n_data),
          longitude = rep(stations$longitud[i], n_data),
          latitude = rep(stations$latitud[i], n_data),
          date = format(station_filtered$date, "%Y-%m-%d"),
          hour = format(station_filtered$date, "%H-%M-%S"),
          tag = rep(tag, n_data),
          value = station_filtered$value
        )
        stations_data <- rbind(stations_data, output)
      }
    }
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
#' print(stations)
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
    stop("There are no stations in the given ROI")
  }
  return(stations_in_roi)
}
