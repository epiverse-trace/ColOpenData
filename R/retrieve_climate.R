#' Retrieve data from named stations for a specific tag#'
#'
#' @description
#' Retrieve climate data from a list of stations under the same tag.This data is
#' retrieved from local meteorological stations provided by IDEAM
#'
#' @param stations numeric vector containing the stations' codes
#' @param start_date character with the first date to consult in the format
#' \code{"YYYY-MM-DD"}
#' @param end_date character with the last date to consult in the format
#' \code{"YYYY-MM-DD"} (Last available date is \code{"2023-05-31"})
#' @param tag unique character containing climate tags to consult
#'
#' @importFrom rlang .data
#' @importFrom magrittr %>%
#'
#' @return \code{data.frame} with observations from the requested stations
#'
#' @keywords internal
retrieve_stations_data <- function(stations, start_date, end_date, tag) {
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
          .data$date >= as.POSIXct(start_date,
            format = "%Y-%m-%d",
            tz = "UTC"
          ),
          .data$date <= (as.POSIXct(end_date,
            format = "%Y-%m-%d",
            tz = "UTC"
          ) + 1)
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
          hour = format(station_filtered$date, "%H:%M:%S"),
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
