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
#' @param frequency character with the aggregation frequency. (\code{"day"},
#' \code{"week"}, \code{"month"} or \code{"year"})
#' @param tags character containing climate tags to consult
#' @param aggregate logical for data aggregation, if \code{FALSE}, returns the
#' data from each individual station in the area. (Default = \code{TRUE})
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
download_climate <- function(code, start_date, end_date, frequency, tags,
                             aggregate = TRUE) {
  checkmate::assert_character(code)

  if (nchar(code) == 5) {
    mpios <- download_geospatial("DANE_MGN_2018_MPIO")
    area <- mpios[which(mpios$MPIO_CDPMP == code), "MPIO_CDPMP"]
  } else if (nchar(code) == 2) {
    dptos <- download_geospatial("DANE_MGN_2018_DPTO")
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
    tags = tags,
    aggregate = aggregate
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
#' @param frequency character with the aggregation frequency. (\code{"day"},
#' \code{"week"}, \code{"month"} or \code{"year"})
#' @param tags character containing climate tags to consult
#' @param aggregate logical for data aggregation, if \code{FALSE}, returns the
#' data from each individual station in the area. (Default = \code{TRUE})
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
                                  tags, aggregate = TRUE) {
  checkmate::assert_class(geometry, "sf")

  stations_roi <- stations_in_roi(geometry)
  stations <- stations_roi$codigo
  climate_geom <- download_climate_stations(
    stations = stations,
    start_date = start_date,
    end_date = end_date,
    frequency = frequency,
    tags = tags,
    aggregate = aggregate
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
#' @param frequency character with the aggregation frequency. (\code{"day"},
#' \code{"week"}, \code{"month"} or \code{"year"})
#' @param tags character containing climate tags to consult
#' @param aggregate logical for data aggregation, if \code{FALSE}, returns the
#' data from each individual station in the area. (Default = \code{TRUE})
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
                                      frequency, tags,
                                      aggregate = TRUE) {
  checkmate::assert_vector(stations)
  checkmate::assert_character(start_date)
  checkmate::assert_character(end_date)
  checkmate::assert_choice(frequency, c("day", "week", "month", "year"))

  if (length(tags) == 1) {
    climate_data <- retrieve_stations_data(
      stations = stations,
      start_date = start_date,
      end_date = end_date,
      frequency = frequency,
      tag = tags,
      aggregate = aggregate
    )
  } else {
    if (aggregate) {
      climate_data <- data.frame()
      for (tag in tags) {
        stations_data <- retrieve_stations_data(
          stations = stations,
          start_date = start_date,
          end_date = end_date,
          frequency = frequency,
          tag = tag,
          aggregate = aggregate
        )
        # If it is the first or a later observation
        if ("date" %in% colnames(climate_data)) {
          climate_data <- merge(climate_data,
            stations_data,
            by.x = "date",
            by.y = "date",
            all.x = TRUE
          )
        } else {
          climate_data <- stations_data
        }
      }
      names(climate_data) <- c("date", tags)
    } else {
      climate_data <- list()
      for (tag in tags) {
        stations_data <- retrieve_stations_data(
          stations = stations,
          start_date = start_date,
          end_date = end_date,
          frequency = frequency,
          tag = tag,
          aggregate = aggregate
        )
        climate_data[[tag]] <- stations_data
      }
    }
  }
  return(climate_data)
}


#' Retrieve data from named stations for a specific tag
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
#' @param frequency character with the aggregation frequency. (\code{"day"},
#' \code{"week"}, \code{"month"} or \code{"year"})
#' @param tag unique character containing climate tags to consult
#' @param aggregate logical for data aggregation, if \code{FALSE}, returns the
#' data from each individual station in the area. (Default = \code{TRUE})
#'
#' @importFrom rlang .data
#' @importFrom magrittr %>%
#'
#' @return \code{data.frame} with observations from the requested stations
#'
#' @keywords internal
retrieve_stations_data <- function(stations, start_date, end_date,
                                   frequency, tag,
                                   aggregate = TRUE) {
  checkmate::assert_vector(stations)
  ideam_tags <- c(
    "TSSM_CON", "THSM_CON", "TMN_CON", "TMX_CON",
    "TSTG_CON", "HR_CAL", "HRHG_CON", "TV_CAL",
    "TPR_CAL", "PTPM_CON", "PTPG_CON", "EVTE_CON", "FA_CON",
    "NB_CON", "RCAM_CON", "BSHG_CON", "VVAG_CON",
    "DVAG_CON", "VVMXAG_CON", "DVMXAG_CON"
  )
  checkmate::assert_choice(tag, ideam_tags)
  checkmate::assert_logical(aggregate)

  path_data <- retrieve_climate_path()
  path_stations <- paste0(tag, "@", stations, ".data")
  date_range <- seq(as.Date(start_date),
    as.Date(end_date),
    by = frequency
  )
  floor_dates <- lubridate::floor_date(date_range,
    unit = frequency
  )
  stations_data <- data.frame(date = floor_dates)
  for (i in seq_along(path_stations)) {
    dataset_path <- file.path(path_data, path_stations[i])
    station <- data.frame(NA)
    tryCatch(
      {
        station <- retrieve_table(dataset_path,
          sep = "|"
        )
      },
      error = function(e) {
      }
    )
    if (length(station) != 1) {
      names(station) <- c("date", "value")
      station$date <- as.POSIXct(station$date,
        format = "%Y-%m-%d %H:%M:%S", tz = "UTC"
      )
      filtered <- station %>%
        dplyr::filter(
          .data$date >= start_date,
          .data$date <= (as.Date(end_date) + 1)
        ) %>%
        summarise(tag, frequency)
      if (all(is.na(filtered))) {
        next
      } else {
        names(filtered) <- c("date", paste("station", stations[i], sep = "_"))
        stations_data <- merge(stations_data, filtered,
          by.x = "date", by.y = "date",
          all.x = TRUE
        )
      }
    }
  }
  if (ncol(stations_data) == 1) {
    stop("There were no records for the given ROI and dates")
  }
  if (aggregate && ncol(stations_data) > 2) {
    stations_data <- aggregate(stations_data, tag)
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
    stop("There are no stations in the given ROI")
  }
  return(stations_in_roi)
}

#' Aggregate stations' data
#'
#' @param stations_data data.frame containing stations' data to aggregate
#' @param tag character with the consulted tag
#'
#' @return \code{data.frame} with only two columns containing the dates and the
#' aggregated observations
#'
#' @keywords internal
aggregate <- function(stations_data, tag) {
  if (ncol(stations_data) == 2) {
    aggregated <- stations_data
    names(aggregated) <- c("date", tag)
  } else {
    if (tag %in% c("PTPM_CON", "PTPG_CON")) {
      aggregated <- as.data.frame(stations_data$date)
      aggregated[tag] <- round(rowSums(stations_data[, -1], na.rm = TRUE), 2)
      names(aggregated) <- c("date", tag)
    } else {
      aggregated <- as.data.frame(stations_data$date)
      aggregated[tag] <- round(rowMeans(stations_data[, -1], na.rm = TRUE), 2)
      names(aggregated) <- c("date", tag)
    }
  }
  return(aggregated)
}

#' Summary and group climate data according to time frequency
#'
#' @param .data \code{data.frame} containing at least one observed column
#' @param tag unique character with the tag consulted
#' @importFrom rlang .data
#'
#' @return \code{data.frame} with grouped observations
#'
#' @keywords internal
summarise <- function(.data, tag, frequency) {
  if (tag %in% c("PTPM_CON", "PTPG_CON")) {
    summarised <- dplyr::mutate(.data,
      date = lubridate::floor_date(.data$date,
        unit = frequency
      )
    ) %>%
      dplyr::group_by(.data$date) %>%
      dplyr::summarise(value = round(sum(.data$value, na.rm = TRUE), 2))
  } else {
    summarised <- dplyr::mutate(.data,
      date = lubridate::floor_date(.data$date,
        unit = frequency
      )
    ) %>%
      dplyr::group_by(.data$date) %>%
      dplyr::summarise(value = round(mean(.data$value, na.rm = TRUE), 2))
  }
  return(summarised)
}
