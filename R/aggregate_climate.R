#' Aggregate dry-bulb temperature data for different frequencies
#'
#' @description
#' Calculate the mean of downloaded hourly dry-bulb temperature data to day,
#' month and year
#'
#' @param climate_data \code{data.frame} obtained from download functions
#' @param frequency character with the aggregation frequency. (\code{"day"},
#'  \code{"month"} or \code{"year"})
#'
#' @examples
#' \dontrun{
#' aggregate_tssm(climate_data, "day")
#' }
#'
#' @return \code{data.frame} with the aggregated data
#' 
#' @export
aggregate_tssm <- function(climate_data, frequency) {
  checkmate::assert_choice(frequency, c("day", "month", "year"), null.ok = TRUE)

  aggregated_day <- climate_data %>%
    dplyr::group_by(station, longitude, latitude, date, tag) %>%
    dplyr::do(data.frame(value = daily_tssm(.)))
  if (frequency == "day") {
    aggregated_tssm <- aggregated_day
  } else {
    aggregated_month <- aggregated_day %>%
      dplyr::mutate(
        month = format(as.Date(date), "%m"),
        year = format(as.Date(date), "%Y")
      ) %>%
      dplyr::group_by(station, longitude, latitude, tag, year, month) %>%
      dplyr::do(data.frame(value = monthly_tssm(.))) %>%
      dplyr::mutate(date = as.Date(paste(year, month, "01", sep = "-"),
        format = "%Y-%m-%d"
      )) %>%
      dplyr::ungroup() %>%
      dplyr::select(station, longitude, latitude, date, tag, value)
    if (frequency == "month") {
      aggregated_tssm <- aggregated_month
    } else {
      aggregated_year <- aggregated_month %>%
        dplyr::mutate(year = format(as.Date(date), "%Y")) %>%
        dplyr::group_by(station, longitude, latitude, tag, year) %>%
        dplyr::do(data.frame(value = annual_tssm(.))) %>%
        dplyr::mutate(date = as.Date(paste(year, "01", "01", sep = "-"),
          format = "%Y-%m-%d"
        )) %>%
        dplyr::ungroup() %>%
        dplyr::select(station, longitude, latitude, date, tag, value)
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
#' @param climate_data \code{data.frame} obtained from download functions
#' @param frequency character with the aggregation frequency. (\code{"day"},
#'  \code{"month"} or \code{"year"})
#'
#' @return \code{data.frame} with the aggregated data
#'
#' @examples
#' \dontrun{
#' aggregate_tmn(climate_data, "day")
#' }
#' @export
aggregate_tmn <- function(climate_data, frequency) {
  checkmate::assert_choice(frequency, c("day", "month", "year"), null.ok = TRUE)

  aggregated_day <- climate_data
  if (frequency == "day") {
    agregated_tmn <- aggregated_day
  } else {
    aggregated_month <- aggregated_day %>%
      dplyr::mutate(
        month = format(as.Date(date), "%m"),
        year = format(as.Date(date), "%Y")
      ) %>%
      dplyr::group_by(station, longitude, latitude, tag, year, month) %>%
      dplyr::do(data.frame(value = monthly_tmn(.))) %>%
      dplyr::mutate(date = as.Date(paste(year, month, "01", sep = "-"),
        format = "%Y-%m-%d"
      )) %>%
      dplyr::ungroup() %>%
      dplyr::select(station, longitude, latitude, date, tag, value)
    if (frequency == "month") {
      agregated_tmn <- aggregated_month
    } else {
      aggregated_year <- aggregated_month %>%
        dplyr::mutate(year = format(as.Date(date), "%Y")) %>%
        dplyr::group_by(station, longitude, latitude, tag, year) %>%
        dplyr::do(data.frame(value = annual_tmn(.))) %>%
        dplyr::mutate(date = as.Date(paste(year, "01", "01", sep = "-"),
          format = "%Y-%m-%d"
        )) %>%
        dplyr::ungroup() %>%
        dplyr::select(station, longitude, latitude, date, tag, value)
      agregated_tmn <- aggregated_year
    }
  }
  return(agregated_tmn)
}

#' Aggregate maximum temperature data for different frequencies
#'
#' @description
#' Calculate the maximum of downloaded maximum temperature data to day, month
#' and year
#'
#' @param climate_data \code{data.frame} obtained from download functions
#' @param frequency character with the aggregation frequency. (\code{"day"},
#'  \code{"month"} or \code{"year"})
#'
#' @examples
#' \dontrun{
#' aggregate_tmx(climate_data, "day")
#' }
#' 
#' @return \code{data.frame} with the aggregated data
#'
#' @export
aggregate_tmx <- function(climate_data, frequency) {
  checkmate::assert_choice(frequency, c("day", "month", "year"), null.ok = TRUE)

  aggregated_day <- climate_data
  if (frequency == "day") {
    agregated_tmx <- aggregated_day
  } else {
    aggregated_month <- aggregated_day %>%
      dplyr::mutate(
        month = format(as.Date(date), "%m"),
        year = format(as.Date(date), "%Y")
      ) %>%
      dplyr::group_by(station, longitude, latitude, tag, year, month) %>%
      dplyr::do(data.frame(value = monthly_tmx(.))) %>%
      dplyr::mutate(date = as.Date(paste(year, month, "01", sep = "-"),
        format = "%Y-%m-%d"
      )) %>%
      dplyr::ungroup() %>%
      dplyr::select(station, longitude, latitude, date, tag, value)
    if (frequency == "month") {
      agregated_tmx <- aggregated_month
    } else {
      aggregated_year <- aggregated_month %>%
        dplyr::mutate(year = format(as.Date(date), "%Y")) %>%
        dplyr::group_by(station, longitude, latitude, tag, year) %>%
        dplyr::do(data.frame(value = annual_tmx(.))) %>%
        dplyr::mutate(date = as.Date(paste(year, "01", "01", sep = "-"),
          format = "%Y-%m-%d"
        )) %>%
        dplyr::ungroup() %>%
        dplyr::select(station, longitude, latitude, date, tag, value)
      agregated_tmx <- aggregated_year
    }
  }
  return(agregated_tmx)
}

#' Aggregate precipitation data for different frequencies
#'
#' @description
#' Calculate the aggregate of downloaded precipitation data to day, month
#' and year
#'
#' @param climate_data \code{data.frame} obtained from download functions
#' @param frequency character with the aggregation frequency. (\code{"day"},
#'  \code{"month"} or \code{"year"})
#'
#' @examples
#' \dontrun{
#' aggregate_ptpg(climate_data, "day")
#' }
#'
#' @return \code{data.frame} with the aggregated data
#' 
#' @export
aggregate_ptpg <- function(climate_data, frequency) {
  checkmate::assert_choice(frequency, c("day", "month", "year"), null.ok = TRUE)

  aggregated_day <- climate_data
  if (frequency == "day") {
    agregated_ptpg <- aggregated_day
  } else {
    aggregated_month <- aggregated_day %>%
      dplyr::mutate(
        month = format(as.Date(date), "%m"),
        year = format(as.Date(date), "%Y")
      ) %>%
      dplyr::group_by(station, longitude, latitude, tag, year, month) %>%
      dplyr::do(data.frame(value = monthly_ptpg(.))) %>%
      dplyr::mutate(date = as.Date(paste(year, month, "01", sep = "-"),
        format = "%Y-%m-%d"
      )) %>%
      dplyr::ungroup() %>%
      dplyr::select(station, longitude, latitude, date, tag, value)
    if (frequency == "month") {
      agregated_ptpg <- aggregated_month
    } else {
      aggregated_year <- aggregated_month %>%
        dplyr::mutate(year = format(as.Date(date), "%Y")) %>%
        dplyr::group_by(station, longitude, latitude, tag, year) %>%
        dplyr::do(data.frame(value = annual_ptpg(.))) %>%
        dplyr::mutate(date = as.Date(paste(year, "01", "01", sep = "-"),
          format = "%Y-%m-%d"
        )) %>%
        dplyr::ungroup() %>%
        dplyr::select(station, longitude, latitude, date, tag, value)
      agregated_ptpg <- aggregated_year
    }
  }
  return(agregated_ptpg)
}

#' Aggregate sunshine duration data for different frequencies
#'
#' @description
#' Calculate the aggregate of downloaded sunshine duration data to day, month
#' and year
#'
#' @param climate_data \code{data.frame} obtained from download functions
#' @param frequency character with the aggregation frequency. (\code{"day"},
#'  \code{"month"} or \code{"year"})
#'
#' @examples
#' \dontrun{
#' aggregate_bhsg(climate_data, "day")
#' }
#'
#' @return \code{data.frame} with the aggregated data
#' 
#' @export
aggregate_bhsg <- function(climate_data, frequency) {
  checkmate::assert_choice(frequency, c("day", "month", "year"), null.ok = TRUE)

  aggregated_day <- climate_data %>%
    dplyr::group_by(station, longitude, latitude, date, tag) %>%
    dplyr::do(data.frame(value = daily_sunshine_duration(.)))
  if (frequency == "day") {
    aggregated_bhsg <- aggregated_day
  } else {
    aggregated_month <- aggregated_day %>%
      dplyr::mutate(
        month = format(as.Date(date), "%m"),
        year = format(as.Date(date), "%Y")
      ) %>%
      dplyr::group_by(station, longitude, latitude, tag, year, month) %>%
      dplyr::do(data.frame(value = monthly_bhsg(.))) %>%
      dplyr::mutate(date = as.Date(paste(year, month, "01", sep = "-"),
        format = "%Y-%m-%d"
      )) %>%
      dplyr::ungroup() %>%
      dplyr::select(station, longitude, latitude, date, tag, value)
    if (frequency == "month") {
      aggregated_bhsg <- aggregated_month
    } else {
      aggregated_year <- aggregated_month %>%
        dplyr::mutate(year = format(as.Date(date), "%Y")) %>%
        dplyr::group_by(station, longitude, latitude, tag, year) %>%
        dplyr::do(data.frame(value = annual_bhsg(.))) %>%
        dplyr::mutate(date = as.Date(paste(year, "01", "01", sep = "-"),
          format = "%Y-%m-%d"
        )) %>%
        dplyr::ungroup() %>%
        dplyr::select(station, longitude, latitude, date, tag, value)
      aggregated_bhsg <- aggregated_year
    }
  }
  return(aggregated_bhsg)
}

#' Calculate daily tssm
#'
#' @param group \code{data.frame} with filtered and grouped data for the day
#'
#' @return numeric value calculated
#'
#' @keywords internal
daily_tssm <- function(group) {
  if (nrow(group) < 3) {
    value <- NA
  } else if (tail(group$hour, 1) == "18:00:00") {
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

#' Calculate monthly tssm
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

#' Calculate annual tssm
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

#' Calculate monthly tmx
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

#' Calculate annual tmx
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

#' Calculate monthly tmn
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

#' Calculate annual tmn
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

#' Calculate monthly ptpg
#'
#' @param group \code{data.frame} with filtered and grouped data for the month
#'
#' @return numeric value calculated
#'
#' @keywords internal
monthly_ptpg <- function(group) {
  if (nrow(group) >= 20) {
    value <- round(sum(group$value, na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate annual ptpg
#'
#' @param group \code{data.frame} with filtered and grouped data for the year
#'
#' @return numeric value calculated
#'
#' @keywords internal
annual_ptpg <- function(group) {
  if (nrow(group) >= 9) {
    value <- round(sum(group$value, na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate daily bhsg
#'
#' @param group \code{data.frame} with filtered and grouped data for the day
#'
#' @return numeric value calculated
#'
#' @keywords internal
daily_bhsg <- function(group) {
  if (nrow(group) >= 10) {
    value <- round(sum(group$value, na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate monthly bhsg
#'
#' @param group \code{data.frame} with filtered and grouped data for the month
#'
#' @return numeric value calculated
#'
#' @keywords internal
monthly_bhsg <- function(group) {
  if (nrow(group) >= 20) {
    value <- round(sum(group$value, na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate annual bhsg
#'
#' @param group \code{data.frame} with filtered and grouped data for the year
#'
#' @return numeric value calculated
#'
#' @keywords internal
annual_bhsg <- function(group) {
  if (nrow(group) >= 9) {
    value <- round(sum(group$value, na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}
