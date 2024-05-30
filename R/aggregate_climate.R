#' Aggregate climate data for different frequencies
#'
#' @description
#' Aggregate time series downloaded climate data to day, month or year.
#' Only observations under the tags \code{TSSM_CON}, \code{TMN_CON},
#' \code{TMX_CON}, \code{PTPM_CON}, and \code{BSHG_CON} can be aggregated,
#' since are the ones where methodology for aggregation is explicitly provided
#' from the source
#'
#' @param climate_data \code{data.frame} obtained from download functions. Only
#' observations under the same tag can be aggregated
#' @param frequency character with the aggregation frequency. (\code{"day"},
#'  \code{"month"} or \code{"year"})
#'
#' @importFrom rlang .data
#'
#' @examples
#' lat <- c(5.166278, 5.166278, 4.982247, 4.982247, 5.166278)
#' lon <- c(-75.678072, -75.327859, -75.327859, -75.678072, -75.678072)
#' polygon <- sf::st_polygon(x = list(cbind(lon, lat)))
#' geometry <- sf::st_sfc(polygon)
#' roi <- sf::st_as_sf(geometry)
#' tssm <- download_climate_geom(roi, "2021-11-14", "2021-11-20", "TSSM_CON")
#' daily_tssm <- aggregate_climate(tssm, "day")
#' head(daily_tssm)
#'
#' @return \code{data.frame} object with the aggregated data
#'
#' @export
aggregate_climate <- function(climate_data, frequency) {
  checkmate::assert_choice(frequency, c("day", "month", "year"))
  checkmate::assert_names(names(climate_data), must.include = c(
    "station", "longitude", "latitude",
    "date", "hour", "tag", "value"
  ))
  tag <- unique(climate_data$tag)
  stopifnot(
    "Aggregation is only possible for individual tags" =
      length(tag) == 1
  )
  checkmate::assert_choice(tag, c(
    "TSSM_CON", "TMN_CON",
    "TMX_CON", "BSHG_CON",
    "PTPM_CON"
  ))

  aggregation_functions <- list(
    TSSM_CON = list(
      day = daily_tssm,
      month = monthly_tssm,
      year = annual_tssm,
      warning_msg = NULL
    ),
    TMN_CON = list(
      day = NULL,
      month = monthly_tmn,
      year = annual_tmn,
      warning_msg = "`TMN_CON` data aggregation is already daily"
    ),
    TMX_CON = list(
      day = NULL,
      month = monthly_tmx,
      year = annual_tmx,
      warning_msg = "`TMX_CON` data aggregation is already daily"
    ),
    PTPM_CON = list(
      day = NULL,
      month = monthly_ptpm,
      year = annual_ptpm,
      warning_msg = "`PTPM_CON` data aggregation is already daily"
    ),
    BSHG_CON = list(
      day = daily_bshg,
      month = monthly_bshg,
      year = annual_bshg,
      warning_msg = NULL
    )
  )
  selected_tag <- aggregation_functions[[tag]]

  if (frequency == "day") {
    if (!is.null(selected_tag$day)) {
      aggregated_data <- aggregate_daily(climate_data, selected_tag$day)
    } else {
      aggregated_data <- climate_data
      warning(selected_tag$warning_msg)
    }
  } else if (frequency == "month") {
    if (!is.null(selected_tag$day)) {
      aggregated_data <- aggregate_daily(climate_data, selected_tag$day) %>%
        aggregate_monthly(selected_tag$month)
    } else {
      aggregated_data <- aggregate_monthly(climate_data, selected_tag$month)
    }
  } else {
    if (!is.null(selected_tag$day)) {
      aggregated_data <- aggregate_daily(climate_data, selected_tag$day) %>%
        aggregate_monthly(selected_tag$month) %>%
        aggregate_annual(selected_tag$year)
    } else {
      aggregated_data <- aggregate_monthly(climate_data, selected_tag$month) %>%
        aggregate_annual(selected_tag$year)
    }
  }

  return(aggregated_data)
}

#' Calculate daily aggregate of climate data
#'
#' @param hourly_data \code{data.frame} with hourly aggregated data
#' @param FUN Function to use for aggregation
#'
#' @return \code{data.frame} object with daily aggregated data
#'
#' @keywords internal
aggregate_daily <- function(hourly_data, FUN) {
  aggregated_day <- dplyr::group_by(
    hourly_data, .data$station,
    .data$longitude, .data$latitude, .data$date, .data$tag
  ) %>%
    dplyr::do(data.frame(value = FUN(.data)))
  return(aggregated_day)
}

#' Calculate monthly aggregate of climate data
#'
#' @param daily_data \code{data.frame} with daily aggregated data
#' @param FUN Function to use for aggregation
#'
#' @return \code{data.frame} object with monthly aggregated data
#'
#' @keywords internal
aggregate_monthly <- function(daily_data, FUN) {
  aggregated_month <- dplyr::mutate(daily_data,
    month = format(as.Date(.data$date), "%m"),
    year = format(as.Date(.data$date), "%Y")
  ) %>%
    dplyr::group_by(
      .data$station, .data$longitude, .data$latitude,
      .data$tag, .data$year, .data$month
    ) %>%
    dplyr::do(data.frame(value = FUN(.data))) %>%
    dplyr::mutate(date = as.Date(
      paste(.data$year, .data$month,
        "01",
        sep = "-"
      ),
      format = "%Y-%m-%d"
    )) %>%
    dplyr::ungroup() %>%
    dplyr::select(
      "station", "longitude", "latitude",
      "date", "tag", "value"
    )
  return(aggregated_month)
}

#' Calculate annual aggregate of climate data
#'
#' @param monthly_data \code{data.frame} with monthly aggregated data
#' @param FUN Function to use for aggregation
#'
#' @return \code{data.frame} object with annual aggregated data
#'
#' @keywords internal
aggregate_annual <- function(monthly_data, FUN) {
  aggregated_year <- dplyr::mutate(monthly_data,
    year = format(as.Date(.data$date), "%Y")
  ) %>%
    dplyr::group_by(
      .data$station, .data$longitude, .data$latitude,
      .data$tag, .data$year
    ) %>%
    dplyr::do(data.frame(value = FUN(.data))) %>%
    dplyr::mutate(date = as.Date(paste(.data$year, "01", "01", sep = "-"),
      format = "%Y-%m-%d"
    )) %>%
    dplyr::ungroup() %>%
    dplyr::select(
      "station", "longitude", "latitude",
      "date", "tag", "value"
    )
  return(aggregated_year)
}
