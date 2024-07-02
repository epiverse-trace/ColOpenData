#' Climate aggregation rules
#'
#' @description
#' Climate temporal aggregation rules are provided by the source, and guarantee
#' data quality given missing information. These rules are included in the
#' package to make the download and aggregation process easier for the user. The
#' aggregation is not available for all climate data, and is only available for
#' information under the tags \code{TSSM_CON}, \code{TMN_CON}, \code{TMX_CON},
#' \code{PTPM_CON}, and \code{BSHG_CON}. Internal functions are provided as a
#' set of comprehensible rules to aggregate the data for daily, monthly and
#' annual frequencies.
#'
#' @section Methods:
#' Aggregation can only be performed from the previous level, meaning for
#' monthly aggregation, the data must be already aggregated daily, and for
#' annual aggregation the data must be monthly.
#'
#' @param group \code{data.frame} object with filtered and grouped data.
#'
#' @return numeric value calculated.
#'
#' @keywords internal
daily_tssm <- function(group) {
  if (nrow(group) < 3) {
    value <- NA
  } else if (utils::tail(group[["hour"]], 1) == "18:00:00") {
    value <- round(mean(group[["value"]]), 2)
  } else {
    temp_07 <- group[["value"]][which(group[["hour"]] == "07:00:00")]
    temp_13 <- group[["value"]][which(group[["hour"]] == "13:00:00")]
    temp_19 <- group[["value"]][which(group[["hour"]] == "19:00:00")]
    temp_mean <- (temp_07 + temp_13 + 2 * temp_19) / 4
    value <- round(temp_mean, 2)
  }
  return(value)
}

#' Calculate monthly dry-bulb mean temperature
#'
#' @keywords internal
monthly_tssm <- function(group) {
  if (nrow(group) >= 15) {
    value <- round(mean(group[["value"]], na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate annual dry-bulb mean temperature
#'
#' @keywords internal
annual_tssm <- function(group) {
  if (nrow(group) >= 9) {
    value <- round(max(group[["value"]], na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate monthly maximum temperature
#'
#' @keywords internal
monthly_tmx <- function(group) {
  if (nrow(group) >= 16) {
    value <- round(max(group[["value"]], na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate annual maximum temperature
#'
#' @keywords internal
annual_tmx <- function(group) {
  if (nrow(group) >= 9) {
    value <- round(max(group[["value"]], na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate monthly minimum temperature
#'
#' @keywords internal
monthly_tmn <- function(group) {
  if (nrow(group) >= 16) {
    value <- round(min(group[["value"]], na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate annual minimum temperature
#'
#' @keywords internal
annual_tmn <- function(group) {
  if (nrow(group) >= 9) {
    value <- round(min(group[["value"]], na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate monthly precipitation
#'
#' @keywords internal
monthly_ptpm <- function(group) {
  if (nrow(group) >= 20) {
    value <- round(sum(group[["value"]], na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate annual precipitation
#'
#' @keywords internal
annual_ptpm <- function(group) {
  if (nrow(group) >= 9) {
    value <- round(sum(group[["value"]], na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate daily sunshine duration
#'
#' @keywords internal
daily_bshg <- function(group) {
  if (nrow(group) >= 10) {
    value <- round(sum(group[["value"]], na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate monthly sunshine duration
#'
#' @keywords internal
monthly_bshg <- function(group) {
  if (nrow(group) >= 20) {
    value <- round(sum(group[["value"]], na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}

#' Calculate annual sunshine duration
#'
#' @keywords internal
annual_bshg <- function(group) {
  if (nrow(group) >= 9) {
    value <- round(sum(group[["value"]], na.rm = TRUE), 2)
  } else {
    value <- NA
  }
  return(value)
}
