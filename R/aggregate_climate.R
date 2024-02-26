#' Aggregate dry-bulb temperature data for different frequencies
#'
#' @description
#' Calculate the mean of downloaded hourly dry-bulb temperature data to day,
#' month and year
#'
#' @param .data \code{data.frame} obtained from download functions
#' @param frequency character with the aggregation frequency. (\code{"day"},
#'  \code{"month"} or \code{"year"})
#'
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' aggregate_tssm(.data, "day")
#' }
#'
#' @return \code{data.frame} with the aggregated data
#'
#' @export
aggregate_tssm <- function(.data, frequency) {
  checkmate::assert_choice(frequency, c("day", "month", "year"), null.ok = TRUE)
  checkmate::assert_names(names(.data), must.include = c(
    "station", "longitude", "latitude",
    "date", "hour", "tag", "value"
  ))
  checkmate::assert_set_equal(names(table(.data$tag)), "TSSM_CON")

  aggregated_day <- dplyr::group_by(
    .data, .data$station,
    .data$longitude, .data$latitude, .data$date, .data$tag
  ) %>%
    dplyr::do(data.frame(value = daily_tssm(.data)))
  if (frequency == "day") {
    aggregated_tssm <- aggregated_day
  } else {
    aggregated_month <- aggregated_day %>%
      dplyr::mutate(
        month = format(as.Date(.data$date), "%m"),
        year = format(as.Date(.data$date), "%Y")
      ) %>%
      dplyr::group_by(
        .data$station, .data$longitude, .data$latitude,
        .data$tag, .data$year, .data$month
      ) %>%
      dplyr::do(data.frame(value = monthly_tssm(.data))) %>%
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
    if (frequency == "month") {
      aggregated_tssm <- aggregated_month
    } else {
      aggregated_year <- aggregated_month %>%
        dplyr::mutate(year = format(as.Date(.data$date), "%Y")) %>%
        dplyr::group_by(
          .data$station, .data$longitude, .data$latitude,
          .data$tag, .data$year
        ) %>%
        dplyr::do(data.frame(value = annual_tssm(.data))) %>%
        dplyr::mutate(date = as.Date(paste(.data$year, "01", "01", sep = "-"),
          format = "%Y-%m-%d"
        )) %>%
        dplyr::ungroup() %>%
        dplyr::select(
          "station", "longitude", "latitude",
          "date", "tag", "value"
        )
      aggregated_tssm <- aggregated_year
    }
  }
  return(aggregated_tssm)
}

#' Aggregate minimum temperature data for different frequencies
#'
#' @description
#' Calculate the minimum of downloaded minimum temperature data to day, month
#' and year
#'
#' @param .data \code{data.frame} obtained from download functions
#' @param frequency character with the aggregation frequency. (
#'  \code{"month"} or \code{"year"})
#'
#' @importFrom rlang .data
#'
#' @return \code{data.frame} with the aggregated data
#'
#' @examples
#' \dontrun{
#' aggregate_tmn(.data, "day")
#' }
#' @export
aggregate_tmn <- function(.data, frequency) {
  checkmate::assert_choice(frequency, c("month", "year"), null.ok = TRUE)
  checkmate::assert_names(names(.data), must.include = c(
    "station", "longitude", "latitude",
    "date", "hour", "tag", "value"
  ))
  checkmate::assert_set_equal(names(table(.data$tag)), "TMN_CON")

  aggregated_day <- .data
    aggregated_month <- aggregated_day %>%
      dplyr::mutate(
        month = format(as.Date(.data$date), "%m"),
        year = format(as.Date(.data$date), "%Y")
      ) %>%
      dplyr::group_by(
        .data$station, .data$longitude, .data$latitude,
        .data$tag, .data$year, .data$month
      ) %>%
      dplyr::do(data.frame(value = monthly_tmn(.data))) %>%
      dplyr::mutate(date = as.Date(
        paste(.data$year,
          .data$month, "01",
          sep = "-"
        ),
        format = "%Y-%m-%d"
      )) %>%
      dplyr::ungroup() %>%
      dplyr::select(
        "station", "longitude", "latitude",
        "date", "tag", "value"
      )
    if (frequency == "month") {
      agregated_tmn <- aggregated_month
    } else {
      aggregated_year <- aggregated_month %>%
        dplyr::mutate(year = format(as.Date(.data$date), "%Y")) %>%
        dplyr::group_by(
          .data$station, .data$longitude, .data$latitude,
          .data$tag, .data$year
        ) %>%
        dplyr::do(data.frame(value = annual_tmn(.data))) %>%
        dplyr::mutate(date = as.Date(paste(.data$year, "01", "01", sep = "-"),
          format = "%Y-%m-%d"
        )) %>%
        dplyr::ungroup() %>%
        dplyr::select(
          "station", "longitude", "latitude",
          "date", "tag", "value"
        )
      agregated_tmn <- aggregated_year
    }
  return(agregated_tmn)
}

#' Aggregate maximum temperature data for different frequencies
#'
#' @description
#' Calculate the maximum of downloaded maximum temperature data to day, month
#' and year
#'
#' @param .data \code{data.frame} obtained from download functions
#' @param frequency character with the aggregation frequency. (
#'  \code{"month"} or \code{"year"})
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' aggregate_tmx(.data, "day")
#' }
#'
#' @return \code{data.frame} with the aggregated data
#'
#' @export
aggregate_tmx <- function(.data, frequency) {
  checkmate::assert_choice(frequency, c("month", "year"), null.ok = TRUE)
  checkmate::assert_names(names(.data), must.include = c(
    "station", "longitude", "latitude",
    "date", "hour", "tag", "value"
  ))
  checkmate::assert_set_equal(names(table(.data$tag)), "TMX_CON")

  aggregated_day <- .data
    aggregated_month <- aggregated_day %>%
      dplyr::mutate(
        month = format(as.Date(.data$date), "%m"),
        year = format(as.Date(.data$date), "%Y")
      ) %>%
      dplyr::group_by(
        .data$station, .data$longitude, .data$latitude, .data$tag,
        .data$year, .data$month
      ) %>%
      dplyr::do(data.frame(value = monthly_tmx(.data))) %>%
      dplyr::mutate(date = as.Date(
        paste(.data$year, .data$month, "01",
          sep = "-"
        ),
        format = "%Y-%m-%d"
      )) %>%
      dplyr::ungroup() %>%
      dplyr::select(
        "station", "longitude", "latitude",
        "date", "tag", "value"
      )
    if (frequency == "month") {
      agregated_tmx <- aggregated_month
    } else {
      aggregated_year <- aggregated_month %>%
        dplyr::mutate(year = format(as.Date(.data$date), "%Y")) %>%
        dplyr::group_by(
          .data$station, .data$longitude, .data$latitude,
          .data$tag, .data$year
        ) %>%
        dplyr::do(data.frame(value = annual_tmx(.data))) %>%
        dplyr::mutate(date = as.Date(paste(.data$year, "01", "01", sep = "-"),
          format = "%Y-%m-%d"
        )) %>%
        dplyr::ungroup() %>%
        dplyr::select(
          "station", "longitude", "latitude",
          "date", "tag", "value"
        )
      agregated_tmx <- aggregated_year
    }
  return(agregated_tmx)
}

#' Aggregate precipitation data for different frequencies
#'
#' @description
#' Calculate the aggregate of downloaded precipitation data to day, month
#' and year
#'
#' @param .data \code{data.frame} obtained from download functions
#' @param frequency character with the aggregation frequency. (\code{"day"},
#'  \code{"month"} or \code{"year"})
#'
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' aggregate_ptpm(.data, "day")
#' }
#'
#' @return \code{data.frame} with the aggregated data
#'
#' @export
aggregate_ptpm <- function(.data, frequency) {
  checkmate::assert_choice(frequency, c("month", "year"), null.ok = TRUE)
  checkmate::assert_names(names(.data), must.include = c(
    "station", "longitude", "latitude",
    "date", "hour", "tag", "value"
  ))
  checkmate::assert_set_equal(names(table(.data$tag)), "PTPM_CON")

  aggregated_day <- .data
    aggregated_month <- aggregated_day %>%
      dplyr::mutate(
        month = format(as.Date(date), "%m"),
        year = format(as.Date(date), "%Y")
      ) %>%
      dplyr::group_by(
        .data$station, .data$longitude, .data$latitude, .data$tag,
        .data$year, .data$month
      ) %>%
      dplyr::do(data.frame(value = monthly_ptpm(.data))) %>%
      dplyr::mutate(date = as.Date(
        paste(.data$year, .data$month, "01",
          sep = "-"
        ),
        format = "%Y-%m-%d"
      )) %>%
      dplyr::ungroup() %>%
      dplyr::select(
        "station", "longitude", "latitude",
        "date", "tag", "value"
      )
    if (frequency == "month") {
      agregated_ptpm <- aggregated_month
    } else {
      aggregated_year <- aggregated_month %>%
        dplyr::mutate(year = format(as.Date(.data$date), "%Y")) %>%
        dplyr::group_by(
          .data$station, .data$longitude, .data$latitude,
          .data$tag, .data$year
        ) %>%
        dplyr::do(data.frame(value = annual_ptpm(.data))) %>%
        dplyr::mutate(date = as.Date(paste(.data$year, "01", "01", sep = "-"),
          format = "%Y-%m-%d"
        )) %>%
        dplyr::ungroup() %>%
        dplyr::select(
          "station", "longitude", "latitude",
          "date", "tag", "value"
        )
      agregated_ptpm <- aggregated_year
    }
  return(agregated_ptpm)
}

#' Aggregate sunshine duration data for different frequencies
#'
#' @description
#' Calculate the aggregate of downloaded sunshine duration data to day, month
#' and year
#'
#' @param .data \code{data.frame} obtained from download functions
#' @param frequency character with the aggregation frequency. (\code{"day"},
#'  \code{"month"} or \code{"year"})
#'
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' aggregate_bshg(.data, "day")
#' }
#'
#' @return \code{data.frame} with the aggregated data
#'
#' @export
aggregate_bshg <- function(.data, frequency) {
  checkmate::assert_choice(frequency, c("day", "month", "year"), null.ok = TRUE)
  checkmate::assert_names(names(.data), must.include = c(
    "station", "longitude", "latitude",
    "date", "hour", "tag", "value"
  ))
  checkmate::assert_set_equal(names(table(.data$tag)), "BSHG_CON")

  aggregated_day <- dplyr::group_by(
    .data, .data$station,
    .data$longitude, .data$latitude, .data$date, .data$tag
  ) %>%
    dplyr::do(data.frame(value = daily_bshg(.data)))
  if (frequency == "day") {
    aggregated_bshg <- aggregated_day
  } else {
    aggregated_month <- aggregated_day %>%
      dplyr::mutate(
        month = format(as.Date(.data$date), "%m"),
        year = format(as.Date(.data$date), "%Y")
      ) %>%
      dplyr::group_by(
        .data$station, .data$longitude, .data$latitude, .data$tag,
        .data$year, .data$month
      ) %>%
      dplyr::do(data.frame(value = monthly_bshg(.data))) %>%
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
    if (frequency == "month") {
      aggregated_bshg <- aggregated_month
    } else {
      aggregated_year <- aggregated_month %>%
        dplyr::mutate(year = format(as.Date(.data$date), "%Y")) %>%
        dplyr::group_by(
          .data$station, .data$longitude, .data$latitude,
          .data$tag, .data$year
        ) %>%
        dplyr::do(data.frame(value = annual_bshg(.data))) %>%
        dplyr::mutate(date = as.Date(paste(.data$year, "01", "01", sep = "-"),
          format = "%Y-%m-%d"
        )) %>%
        dplyr::ungroup() %>%
        dplyr::select(
          "station", "longitude", "latitude",
          "date", "tag", "value"
        )
      aggregated_bshg <- aggregated_year
    }
  }
  return(aggregated_bshg)
}

#' Calculate daily dry-bulb mean temperature
#'
#' @param group \code{data.frame} with filtered and grouped data for the day
#'
#' @return numeric value calculated
#'
#' @keywords internal
daily_tssm <- function(group) {
  if (nrow(group) < 3) {
    value <- NA
  } else if (utils::tail(group$hour, 1) == "18:00:00") {
    value <- round(mean(group$value), 2)
  } else {
    temp_07 <- group$value[group$hour == "07:00:00"]
    temp_13 <- group$value[group$hour == "13:00:00"]
    temp_19 <- group$value[group$hour == "19:00:00"]
    temp_mean <- (temp_07 + temp_13 + 2 * temp_19) / 4
    value <- round(temp_mean, 2)
  }
  return(value)
}

#' Calculate monthly dry-bulb mean temperature
#'
#' @param group \code{data.frame} with filtered and grouped data for the month
#'
#' @return numeric value calculated
#'
#' @keywords internal
monthly_tssm <- function(group) {
  if (nrow(group) >= 15) {
    value <- round(mean(group$value, na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate annual dry-bulb mean temperature
#'
#' @param group \code{data.frame} with filtered and grouped data for the year
#'
#' @return numeric value calculated
#'
#' @keywords internal
annual_tssm <- function(group) {
  if (nrow(group) >= 9) {
    value <- round(max(group$value, na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate monthly maximum temperature
#'
#' @param group \code{data.frame} with filtered and grouped data for the month
#'
#' @return numeric value calculated
#'
#' @keywords internal
monthly_tmx <- function(group) {
  if (nrow(group) >= 16) {
    value <- round(max(group$value, na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate annual maximum temperature
#'
#' @param group \code{data.frame} with filtered and grouped data for the year
#'
#' @return numeric value calculated
#'
#' @keywords internal
annual_tmx <- function(group) {
  if (nrow(group) >= 9) {
    value <- round(max(group$value, na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate monthly minimum temperature
#'
#' @param group \code{data.frame} with filtered and grouped data for the month
#'
#' @return numeric value calculated
#'
#' @keywords internal
monthly_tmn <- function(group) {
  if (nrow(group) >= 16) {
    value <- round(max(group$value, na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate annual minimum temperature
#'
#' @param group \code{data.frame} with filtered and grouped data for the year
#'
#' @return numeric value calculated
#'
#' @keywords internal
annual_tmn <- function(group) {
  if (nrow(group) >= 9) {
    value <- round(max(group$value, na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate monthly precipitation
#'
#' @param group \code{data.frame} with filtered and grouped data for the month
#'
#' @return numeric value calculated
#'
#' @keywords internal
monthly_ptpm <- function(group) {
  if (nrow(group) >= 20) {
    value <- round(sum(group$value, na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate annual precipitation
#'
#' @param group \code{data.frame} with filtered and grouped data for the year
#'
#' @return numeric value calculated
#'
#' @keywords internal
annual_ptpm <- function(group) {
  if (nrow(group) >= 9) {
    value <- round(sum(group$value, na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate daily sunshine duration
#'
#' @param group \code{data.frame} with filtered and grouped data for the day
#'
#' @return numeric value calculated
#'
#' @keywords internal
daily_bshg <- function(group) {
  if (nrow(group) >= 10) {
    value <- round(sum(group$value, na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate monthly sunshine duration
#'
#' @param group \code{data.frame} with filtered and grouped data for the month
#'
#' @return numeric value calculated
#'
#' @keywords internal
monthly_bshg <- function(group) {
  if (nrow(group) >= 20) {
    value <- round(sum(group$value, na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate annual sunshine duration
#'
#' @param group \code{data.frame} with filtered and grouped data for the year
#'
#' @return numeric value calculated
#'
#' @keywords internal
annual_bshg <- function(group) {
  if (nrow(group) >= 9) {
    value <- round(sum(group$value, na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}
