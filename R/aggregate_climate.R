#' Aggregate climate data for different frequencies
#'
#' @description
#' Aggregate time series downloaded data from specific tags to day, month or
#' year. Only observations under the tags \code{TSSM_CON}, \code{TMN_CON},
#' \code{TMX_CON}, \code{PTPM_CON}, and \code{BSHG_CON} can be aggregated,
#' since are the ones where methodology for aggregation is explicitly provided
#' from the source.
#'
#' @param .data \code{data.frame} obtained from download functions. Can only
#' include observations under the same tag.
#' @param frequency character with the aggregation frequency. (\code{"day"},
#'  \code{"month"} or \code{"year"})
#'
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' aggregate_tssm(tssm, "day")
#' }
#'
#' @return \code{data.frame} with the aggregated data for specific frequency
#'
#' @export
aggregate_climate <- function(.data, frequency) {
  checkmate::assert_choice(frequency, c("day", "month", "year"))
  checkmate::assert_names(names(.data), must.include = c(
    "station", "longitude", "latitude",
    "date", "hour", "tag", "value"
  ))
  tag <- unique(.data$tag)
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

  evaluated <- aggregation_functions[[tag]]

  if (frequency == "day") {
    if (!is.null(evaluated$day)) {
      aggregated_data <- aggregate_daily(.data, evaluated$day)
    } else {
      aggregated_data <- .data
      warning(evaluated$warning_msg)
    }
  } else if (frequency == "month") {
    if (!is.null(evaluated$day)) {
      aggregated_data <- aggregate_daily(.data, evaluated$day) %>%
        aggregate_monthly(evaluated$month)
    } else {
      aggregated_data <- aggregate_monthly(.data, evaluated$month)
    }
  } else {
    if (!is.null(evaluated$day)) {
      aggregated_data <- aggregate_daily(.data, evaluated$day) %>%
        aggregate_monthly(evaluated$month) %>%
        aggregate_annual(evaluated$year)
    } else {
      aggregated_data <- aggregate_monthly(.data, evaluated$month) %>%
        aggregate_annual(evaluated$year)
    }
  }

  return(aggregated_data)
}

#' Calculate daily aggregate of climate data
#'
#' @param hourly_data \code{data.frame} with hourly aggregated data
#' @param FUN Function to use for aggregation
#'
#' @return \code{data.frame} with daily aggregated data
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
#' @return \code{data.frame} with monthly aggregated data
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
#' @return \code{data.frame} with annual aggregated data
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
