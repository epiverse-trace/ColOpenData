#' Retrieve weather data by municipality name
#' @description
#' Retrieve weather stations with observed data in a given municipality.
#'
#' @param name string of the DIVIPOLA code for a given municipality
#' @param start_date starting date in format "YYYY-MM-DD"
#' @param end_date end date in format "YYYY-MM-DD"
#' @param frequency aggregation frequency. Can be "day", "week","month" or
#' "year"
#' @param tags character containing tags to analyze
#' @param plot if TRUE, plot the individual stations that contain data
#' @param group if TRUE, returns only one observation from the mean of the
#' stations consulted
#' @examples
#' \dontrun{
#' download_weather_mpio("11001", "2021-11-14", "2021-11-30", "day", "TSSM_CON")
#' }
#'
#' @return data.frame with the observed data for the given municipality
download_weather_mpio <- function(name, start_date, end_date, frequency, tags,
                                  plot = FALSE, group = FALSE) {
  checkmate::assert_character(name)

  mpios <- ColOpenData::download_geospatial("DANE_MGNCNPV_2018_MPIO")
  mpio <- mpios[which(mpios$MPIO_CDPMP == name), ]
  weather_stations <- download_weather(
    mpio, start_date, end_date,
    frequency, tags, plot, group
  )
  return(weather_stations)
}

#' Retrieve weather data from stations in geometry
#' @description
#' Retrieve weather stations with observed data in a given geometry.
#'
#' @param geometry sf object containing a geometry (polygon or multipolygon)
#' @param start_date starting date in format "YYYY-MM-DD"
#' @param end_date end date in format "YYYY-MM-DD"
#' @param frequency aggregation frequency. Can be "day", "week","month" or
#' "year"
#' @param tags character containing tags to analyze
#' @param plot if TRUE, plot the individual stations that contain data
#' @param group if TRUE, returns only one observation from the mean of the
#' stations consulted
#'
#' @examples
#' \dontrun{
#' download_weather(geometry, "2021-11-14", "2021-11-30", "day", "TSSM_CON")
#' }
#'
#' @return data.frame with the observed data for the given geometry
#' @export
download_weather <- function(geometry, start_date, end_date, frequency,
                             tags, plot = FALSE, group = FALSE) {
  checkmate::assert_class(geometry, "sf")
  checkmate::assert_character(start_date)
  checkmate::assert_character(end_date)
  checkmate::assert_choice(frequency, c("day", "week", "month", "year"))
  ideam_tags <- c(
    "TSSM_CON", "THSM_CON", "TMN_CON", "TMX_CON",
    "TSTG_CON", "HR_CAL", "HRHG_CON", "TV_CAL",
    "TPR_CAL", "PTPM_CON", "EVTE_CON", "FA_CON",
    "NB_CON", "RCAM_CON", "BSHG_CON", "VVAG_CON",
    "DVAG_CON", "VVMXAG_CON", "DVMXAG_CON"
  )
  for (tag in tags) {
    checkmate::assert_choice(tag, ideam_tags)
  }

  stations_roi <- stations_in_roi(geometry)
  stations <- stations_roi$codigo
  weather_stations <- weather_stations(
    stations, start_date, end_date,
    frequency, tags, plot, group
  )
  return(weather_stations)
}

#' Retrieve weather from stations
#' @description
#' Retrieve weather stations with observed data in a given geometry.
#' @param stations vector containing the stations codes
#' @param start_date starting date in format "YYYY-MM-DD"
#' @param end_date end date in format "YYYY-MM-DD"
#' @param frequency aggregation frequency. Can be "day", "week","month" or
#' "year"
#' @param tags character containing tags to analyze
#' @param plot if TRUE, plot the individual stations that contain data
#' @param group if TRUE, returns only one observation from the mean of the
#' stations consulted
#'
#' @examples
#' \dontrun{
#' weather_stations(stations, "2021-11-14", "2021-11-30", "day", "TSSM_CON")
#' }
#'
#' @return data.frame with the observed data for the given geometry
#' @export
weather_stations <- function(stations, start_date, end_date,
                             frequency, tags, plot = FALSE,
                             group = FALSE) {
  checkmate::assert_vector(stations)
  checkmate::assert_character(start_date)
  checkmate::assert_character(end_date)
  checkmate::assert_choice(frequency, c("day", "week", "month", "year"))
  ideam_tags <- c(
    "TSSM_CON", "THSM_CON", "TMN_CON", "TMX_CON",
    "TSTG_CON", "HR_CAL", "HRHG_CON", "TV_CAL",
    "TPR_CAL", "PTPM_CON", "EVTE_CON", "FA_CON",
    "NB_CON", "RCAM_CON", "BSHG_CON", "VVAG_CON",
    "DVAG_CON", "VVMXAG_CON", "DVMXAG_CON"
  )
  if (length(tags) == 1) {
    stations_data <- retrieve_working_stations(
      stations, start_date, end_date,
      frequency, tags, plot, group
    )
  } else {
    if (group) {
      stations_data <- data.frame()
      for (tag in tags) {
        checkmate::assert_choice(tag, ideam_tags)
        working_stations <- retrieve_working_stations(
          stations, start_date, end_date,
          frequency, tag, plot, group
        )
        if ("dates" %in% colnames(stations_data)) {
          stations_data <- merge(stations_data, working_stations,
            by.x = "dates", by.y = "dates", all.x = TRUE
          )
        } else {
          stations_data <- working_stations
        }
      }
    } else {
      stations_data <- list()
      for (tag in tags) {
        checkmate::assert_choice(tag, ideam_tags)
        working_stations <- retrieve_working_stations(
          stations, start_date, end_date,
          frequency, tag, plot, group
        )
        stations_data[[tag]] <- working_stations
      }
    }
  }
  return(stations_data)
}

#' Retrieve stations that took measurements in the given dates
#' @description
#' Retrieves, from a list of stations, the ones that contain observations for
#' the given tag in specified dates. Might include stations that are no longer
#' working.
#'
#' @param stations vector containing the stations codes
#' @param start_date starting date in format "YYYY-MM-DD"
#' @param end_date end date in format "YYYY-MM-DD"
#' @param frequency aggregation frequency. Can be "day", "week","month" or
#' "year"
#' @param tag character containing tag to analyze
#' @param plot if TRUE, plot the individual stations that contain data
#' @param group if TRUE, returns only one observation from the mean of the
#'
#' @importFrom rlang .data
#'
#' @return data.frame containing the observed data for the given stations
#' @keywords internal
retrieve_working_stations <- function(stations, start_date, end_date,
                                      frequency, tag, plot = FALSE,
                                      group = FALSE) {
  checkmate::assert_vector(stations)
  checkmate::assert_character(start_date)
  checkmate::assert_character(end_date)
  checkmate::assert_choice(frequency, c("day", "week", "month", "year"))
  ideam_tags <- c(
    "TSSM_CON", "THSM_CON", "TMN_CON", "TMX_CON",
    "TSTG_CON", "HR_CAL", "HRHG_CON", "TV_CAL",
    "TPR_CAL", "PTPM_CON", "EVTE_CON", "FA_CON",
    "NB_CON", "RCAM_CON", "BSHG_CON", "VVAG_CON",
    "DVAG_CON", "VVMXAG_CON", "DVMXAG_CON"
  )
  checkmate::assert_choice(tag, ideam_tags)

  config_file <- system.file("extdata", "config.yaml",
    package = "ColOpenData",
    mustWork = TRUE
  )
  base_path <- config::get(value = "base_path", file = config_file)
  # nolint start: nonportable_path_linter
  relative_path <- file.path(base_path, "IDEAM_WEATHER_2023_MAY")
  # nolint end
  paths_stations <- paste0(tag, "@", stations, ".data")
  dates <- seq(as.Date(start_date), as.Date(end_date), by = frequency)
  floor_dates <- lubridate::floor_date(dates, unit = frequency)
  output <- data.frame(dates = floor_dates)
  for (i in seq_along(paths_stations)) {
    # nolint start: nonportable_path_linter
    dataset_path <- file.path(relative_path, paths_stations[i])
    # nolint end
    response <- httr::GET(url = dataset_path)
    content <- httr::content(response, as = "text", encoding = "utf-8")
    temp_data <- readr::read_delim(content,
      delim = "|", escape_double = FALSE, trim_ws = TRUE,
      show_col_types = FALSE
    )
    if (length(temp_data) != 1) {
      temp_data$Fecha <- as.POSIXct(temp_data$Fecha,
        format = "%Y-%m-%d %H:%M:%S", tz = "UTC"
      )
      filtered <- temp_data %>%
        dplyr::filter(
          .data$Fecha >= start_date,
          .data$Fecha <= (as.Date(end_date) + 1)
        )
      if (frequency == "week") {
        filtered <- filtered %>%
          dplyr::mutate(
            week = lubridate::floor_date(.data$Fecha, unit = "week")
          ) %>%
          dplyr::group_by(.data$week) %>%
          dplyr::summarise(value = round(mean(.data$Valor), 2))
      } else if (frequency == "month") {
        filtered <- filtered %>%
          dplyr::mutate(
            month = lubridate::floor_date(.data$Fecha, unit = "month")
          ) %>%
          dplyr::group_by(.data$month) %>%
          dplyr::summarise(value = round(mean(.data$Valor), 2))
      } else if (frequency == "year") {
        filtered <- filtered %>%
          dplyr::mutate(
            year = lubridate::floor_date(.data$Fecha, unit = "year")
          ) %>%
          dplyr::group_by(.data$year) %>%
          dplyr::summarise(value = round(mean(.data$Valor), 2))
      } else {
        filtered <- filtered %>%
          dplyr::group_by(as.Date(.data$Fecha)) %>%
          dplyr::summarise(value = round(mean(.data$Valor), 2))
      }
      if (all(is.na(filtered))) {
        next
      }
      names(filtered) <- c("dates", paste("station", stations[i], sep = "_"))
      output <- merge(output, filtered,
        by.x = "dates", by.y = "dates",
        all.x = TRUE
      )
    }
  }
  if (ncol(output) == 1) {
    stop("There were no records for the given ROI and dates")
  }

  if (group && ncol(output) > 2) {
    output <- group_stations(output, tag)
  }
  if (plot) {
    plot_stations(output, tag)
  }
  return(output)
}

#' Stations in region of interest
#' @description
#' Retrieves the stations contained inside a given geometry
#'
#' @param geometry sf object containing a geometry (polygon or multipolygon)
#'
#' @examples
#' \dontrun{
#' stations_in_roy(geometry)
#' }
#'
#' @return data.frame with the stations inside the consulted geometry
#' @export
stations_in_roi <- function(geometry) {
  checkmate::assert_class(geometry, "sf")
  crs <- sf::st_crs(geometry)

  config_file <- system.file("extdata", "config.yaml",
    package = "ColOpenData",
    mustWork = TRUE
  )
  base_path <- config::get(value = "base_path", file = config_file)
  # nolint start: nonportable_path_linter
  relative_path <- file.path(base_path, "IDEAM_STATIONS_2023_MAY.csv")
  # nolint end
  response <- httr::GET(relative_path)
  content <- httr::content(response, as = "text", encoding = "utf-8")
  IDEAM_stations <- suppressWarnings(readr::read_delim(content,
    delim = ",", escape_double = FALSE, trim_ws = TRUE,
    show_col_types = FALSE
  ))

  geo_stations <- sf::st_as_sf(IDEAM_stations,
    coords = c("longitude", "latitude"),
    remove = FALSE
  )
  geo_stations <- sf::st_set_crs(geo_stations, crs)
  intersections <- sf::st_within(geo_stations, geometry, sparse = FALSE)

  filtered_stations <- geo_stations[which(intersections), ]
  if (nrow(filtered_stations) == 0) {
    stop("There are no stations in the given ROI")
  }
  return(filtered_stations)
}

#' Group stations
#' @description
#' Groups stations by the mean of the observations
#'
#' @param stations_df data.frame containing stations to group
#' @param tag string with the tag consulted
#'
#' @return a data.frame with only two columns containing the dates and the
#' grouped observations
#' @keywords internal
group_stations <- function(stations_df, tag) {
  if (ncol(stations_df) == 2) {
    output <- stations_df
    names(output) <- c("dates", tag)
  } else {
    output <- as.data.frame(stations_df$dates)
    output[tag] <- round(rowMeans(stations_df[, -1], na.rm = TRUE), 2)
    names(output) <- c("dates", tag)
  }
  return(output)
}

#' Plot stations
#' @description
#' Plot weather stations if required
#'
#' @param stations_df data.frame with stations containing observations for each
#' date
#' @param tag string with the tag consulted
#'
#' @keywords internal
plot_stations <- function(stations_df, tag) {
  # plot max 10
  cols <- min(ncol(stations_df) - 1, 10)
  if (cols > 10) {
    warning("Only first 10 stations are plotted")
  }
  if (cols > 1) {
    plots <- list()
    for (i in range(1, cols)) {
      y_name <- names(stations_df)[i + 1]
      x_name <- "dates"
      plots[[i]] <- ggplot2::ggplot(
        data = stations_df,
        ggplot2::aes_string(
          x = x_name,
          y = y_name
        )
      ) +
        ggplot2::geom_line() +
        ggplot2::xlab("DATE") +
        ggplot2::ylab(tag) +
        ggplot2::ggtitle(y_name) +
        ggplot2::ylim(range(stations_df[, i + 1], na.rm = TRUE)) +
        ggplot2::theme_bw()
    }
    plot_stations <- cowplot::plot_grid(plotlist = plots)
  } else {
    y_name <- names(stations_df)[2]
    x_name <- "DATE"
    plot_stations <- ggplot2::ggplot(
      data = stations_df,
      ggplot2::aes_string(
        x = x_name,
        y = y_name
      )
    ) +
      ggplot2::geom_line() +
      ggplot2::xlab("Date") +
      ggplot2::ylab(tag) +
      ggplot2::ggtitle(y_name) +
      ggplot2::ylim(range(stations_df[, 2], na.rm = TRUE)) +
      ggplot2::theme_bw()
  }
  graphics::plot(plot_stations)
}
