#' Retrieve climate data by named geometry (municipality or department)
#' @description
#' Retrieve climate stations with observed data in a named spatial structure
#' (municipality or department). This data is retrieved from local
#' meteorological stations.
#'
#' @param code Character with the DIVIPOLA code for the area.
#' @param start_date Character with the first date to consult in format
#' "YYYY-MM-DD".
#' @param end_date Character with the last date to consult in format
#' "YYYY-MM-DD". Last available date is 2023-05-31.
#' @param frequency Character with the aggregation frequency. Can be
#' "day", "week","month" or "year".
#' @param tags Character containing tags to consult.
#' @param aggregate Boolean for data aggregation, if FALSE, returns the data from
#' each individual station in the municipality.(Default = FALSE).
#' @examples
#' \dontrun{
#' download_climate_mpio("11001", "2021-11-14", "2021-11-30", "day", "TSSM_CON")
#' }
#'
#' @return data.frame with the observed data for the given municipality.
#' @export
download_climate <- function(code, start_date, end_date, frequency, tags,
                             aggregate = FALSE) {
  checkmate::assert_character(code)

  if (nchar(code) == 5) {
    mpios <- ColOpenData::download_geospatial("DANE_MGNCNPV_2018_MPIO")
    area <- mpios[which(mpios$MPIO_CDPMP == code), "MPIO_CDPMP"]
  } else if (nchar(code) == 2) {
    dptos <- ColOpenData::download_geospatial("DANE_MGNCNPV_2018_DPTO")
    area <- dptos[which(dptos$DPTO_CCDGO == code), "DPTO_CCDGO"]
  }
  if (nrow(area) == 0) {
    stop("`code` cannot be found")
  }
  climate <- download_climate_geom(
    area, start_date, end_date,
    frequency, tags, aggregate
  )
  return(climate)
}

#' Retrieve climate data from stations in geometry
#' @description
#' Retrieve climate stations with observed data in a given geometry. This
#' data is retrieved from local meteorological stations.
#'
#' @param geometry sf object containing the geometry for a given ROI. This
#' geometry can be either a POLYGON or MULTIPOLYGON.
#' @param start_date Character with the first date to consult in format
#' "YYYY-MM-DD".
#' @param end_date Character with the last date to consult in format
#' "YYYY-MM-DD". Last available date is 2023/05/31.
#' @param frequency Character with the aggregation frequency. Can be
#' "day", "week","month" or "year".
#' @param tags Character containing tags to consult.
#' @param aggregate Boolean for data aggregation, if FALSE, returns the data from
#' each individual station in ROI.(Default = FALSE).
#'
#' @examples
#' \dontrun{
#' download_climate_geom(geometry, "2021-11-14", "2021-11-30", "day", "TSSM_CON")
#' }
#'
#' @return data.frame with the observed data for the given geometry.
#' @export
download_climate_geom <- function(geometry, start_date, end_date, frequency,
                                  tags, aggregate = FALSE) {
  checkmate::assert_class(geometry, "sf")

  stations_roi <- stations_in_roi(geometry)
  stations <- stations_roi$codigo
  climate_geom <- retrieve_climate_data(
    stations, start_date, end_date,
    frequency, tags, aggregate
  )
  return(climate_geom)
}

#' Retrieve climate from stations
#' @description
#' Retrieve climate stations with observed data in a given geometry. This
#' data is retrieved from local meteorological stations.
#'
#' @param stations Vector containing the stations' codes.
#' @param start_date Character with the first date to consult in format
#' "YYYY-MM-DD".
#' @param end_date Character with the last date to consult in format
#' "YYYY-MM-DD". Last available date is 2023/05/31.
#' @param frequency Character with the aggregation frequency. Can be
#' "day", "week","month" or "year".
#' @param tags Character containing tags to consult.
#' @param aggregate Boolean for data aggregation, if FALSE, returns the data from
#' each individual station in ROI.(Default = FALSE).
#'
#' @examples
#' \dontrun{
#' climate_stations(stations, "2021-11-14", "2021-11-30", "day", "TSSM_CON")
#' }
#'
#' @return data.frame with the observed data for the given geometry.
#' @export
retrieve_climate_data <- function(stations, start_date, end_date,
                                  frequency, tags,
                                  aggregate = FALSE) {
  checkmate::assert_vector(stations)
  checkmate::assert_character(start_date)
  checkmate::assert_character(end_date)
  checkmate::assert_choice(frequency, c("day", "week", "month", "year"))

  if (length(tags) == 1) {
    climate_data <- retrieve_stations_data(
      stations, start_date, end_date,
      frequency, tags, aggregate
    )
  } else {
    if (aggregate) {
      climate_data <- data.frame()
      for (tag in tags) {
        stations_data <- retrieve_stations_data(
          stations, start_date, end_date,
          frequency, tag, aggregate
        )
        # If it is the first or a later observation
        if ("date" %in% colnames(climate_data)) {
          climate_data <- merge(climate_data, stations_data,
            by.x = "date", by.y = "date", all.x = TRUE
          )
        } else {
          climate_data <- stations_data
        }
      }
    } else {
      climate_data <- list()
      for (tag in tags) {
        stations_data <- retrieve_climate_data(
          stations, start_date, end_date,
          frequency, tag, aggregate
        )
        climate_data[[tag]] <- stations_data
      }
    }
  }
  return(climate_data)
}

#' Retrieve data from stations that took measurements in the given dates
#' @description
#' Retrieves, from a list of stations, the ones that contain observations for
#' the given tag in specified dates. Might include stations that are no longer
#' working.
#'
#' @param stations Vector containing the stations' codes.
#' @param start_date Character with the first date to consult in format
#' "YYYY-MM-DD".
#' @param end_date Character with the last date to consult in format
#' "YYYY-MM-DD". Last available date is 2023/05/31.
#' @param frequency Character with the aggregation frequency. Can be
#' "day", "week","month" or "year".
#' @param tag Character containing tag to consult.
#' @param aggregate Boolean for data aggregation, if FALSE, returns the data from
#' each individual station in ROI.(Default = FALSE).
#'
#' @importFrom rlang .data
#' @importFrom magrittr %>%
#'
#' @return data.frame containing the observed data for the given stations.
#' @keywords internal
retrieve_stations_data <- function(stations, start_date, end_date,
                                   frequency, tag,
                                   aggregate = FALSE) {
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

  path_data <- retrieve_path("IDEAM_CLIMATE_2023_MAY")
  path_stations <- paste0(tag, "@", stations, ".data")
  date_range <- seq(as.Date(start_date), as.Date(end_date), by = frequency)
  floor_dates <- lubridate::floor_date(date_range, unit = frequency)
  stations_data <- data.frame(date = floor_dates)
  for (i in seq_along(path_stations)) {
    # nolint start: nonportable_path_linter
    dataset_path <- file.path(path_data, path_stations[i])
    # nolint end
    station <- retrieve_table(dataset_path, sep = "|")
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
      }
      names(filtered) <- c("date", paste("station", stations[i], sep = "_"))
      stations_data <- merge(stations_data, filtered,
        by.x = "date", by.y = "date",
        all.x = TRUE
      )
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
#' @description
#' Retrieves the stations contained inside a given geometry
#'
#' @param geometry sf object containing the geometry for a given ROI. This
#' geometry can be either a POLYGON or MULTIPOLYGON.
#'
#' @examples
#' \dontrun{
#' stations_in_roy(geometry)
#' }
#'
#' @return data.frame with the stations inside the consulted geometry.
#' @export
stations_in_roi <- function(geometry) {
  checkmate::assert_class(geometry, "sf")

  crs <- sf::st_crs(geometry)
  # IDEAM stations are stored directly from www.datos.gov.co
  # and are separated by ","
  data_path <- retrieve_path("IDEAM_STATIONS_2023_MAY")
  stations <- retrieve_table(data_path, ",")
  geo_stations <- sf::st_as_sf(stations,
    coords = c("longitude", "latitude"),
    remove = FALSE
  )
  geo_stations <- sf::st_set_crs(geo_stations, crs)
  intersections <- sf::st_within(geo_stations, geometry, sparse = FALSE)
  stations_in_roi <- geo_stations[which(intersections), ]
  if (nrow(stations_in_roi) == 0) {
    stop("There are no stations in the given ROI")
  }
  return(stations_in_roi)
}

#' Aggregate stations
#' @description
#' Aggregate stations observations.
#'
#' @param stations_df data.frame containing stations to aggregate
#' @param tag string with the tag consulted.
#'
#' @return a data.frame with only two columns containing the dates and the
#' aggregated observations.
#' @keywords internal
aggregate <- function(stations_df, tag) {
  if (ncol(stations_df) == 2) {
    aggregated <- stations_df
    names(aggregated) <- c("date", tag)
  } else {
    if (tag %in% c("PTPM_CON", "PTPG_CON")) {
      aggregated <- as.data.frame(stations_df$date)
      aggregated[tag] <- round(rowSums(stations_df[, -1]), 2)
      names(aggregated) <- c("date", tag)
    } else {
      aggregated <- as.data.frame(stations_df$date)
      aggregated[tag] <- round(rowMeans(stations_df[, -1]), 2)
      names(aggregated) <- c("date", tag)
    }
  }
  return(aggregated)
}

#' Summary and group of climate data according to time frequency
#'
#' @param .data data.frame containing at least one observed column
#' @param tag string with the tag consulted
#' @importFrom rlang .data
#'
#' @return a data.frame with aggregated observations
#'
#' @keywords internal
summarise <- function(.data, tag, frequency) {
  if (tag %in% c("PTPM_CON", "PTPG_CON")) {
    summarised <- dplyr::mutate(.data,
      date = lubridate::floor_date(.data$date, unit = frequency)
    ) %>%
      dplyr::group_by(.data$date) %>%
      dplyr::summarise(value = round(sum(.data$value, na.rm = TRUE), 2))
  } else {
    summarised <- dplyr::mutate(.data,
      date = lubridate::floor_date(.data$date, unit = frequency)
    ) %>%
      dplyr::group_by(.data$date) %>%
      dplyr::summarise(value = round(mean(.data$value, na.rm = TRUE), 2))
  }
  return(summarised)
}
