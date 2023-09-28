#' Filter MGN data
#'
#' @param .data dataframe containing MGN - CNPV data
#' @param include_geometry boolean to include (or not) the geometry.
#' @param ad character vector with municipalities to filter
#' @param columns character vector with columns to filter
#'
#' @return sf dataframe containing MGN(National Geo statistical Frame) and CNPV
#' (National Population and Living Census) data
#'
#' @export
filter_mgn_cnpv <- function(.data,
                            ad = NULL,
                            columns = NULL,
                            include_geometry = TRUE) {
  checkmate::assert_class(.data, c("sf", "data.frame"))
  checkmate::assert_logical(include_geometry)
  checkmate::assert_character(columns, null.ok = TRUE)
  checkmate::assert_choice(columns, colnames(.data), null.ok = TRUE)

  census <- .data
  if (is.null(columns)) {
    columns <- colnames(census)
  }

  if ("MPIO_CDPMP" %in% colnames(census) ||
    "MPIO_CNMBR" %in% colnames(census)) {
    level <- 2
  } else {
    level <- 1
  }

  if (!include_geometry) {
    census <- sf::st_drop_geometry(census)
  }

  if (level == 2) {
    if (is.null(ad)) {
      ad <- census$MPIO_CDPMP
    } else if (is.numeric(ad)) {
      ad <- codes_to_string(ad)
    }
    census <- census %>% select(all_of(columns))

    filtered_data <- filter_mgn_cnpv_ad2(census, ad)
  } else if (level == 1) {
    if (is.null(ad)) {
      ad <- census$DPTO_CCDGO
    } else if (is.numeric(ad)) {
      ad <- codes_to_string(ad)
    }
    census <- census %>% select(all_of(columns))

    filtered_data <- filter_mgn_cnpv_ad1(census, ad)
  }
  return(census)
}

filter_mgn_cnpv_ad1 <- function(census_data,
                                ad) {
  if (!all(is.na(as.numeric(ad)))) {
    census_data <- census_data %>%
      dplyr::filter(.data$DPTO_CNMBR %in% ad) %>%
      dplyr::select(all_of(c("DPTO_CNMBR", columns)))
  } else {
    census_data <- census_data %>%
      dplyr::filter(.data$DPTO_CCDGO %in% ad) %>%
      dplyr::select(all_of(c("DPTO_CCDGO", columns)))
  }
  
  return(census_data)
}

filter_mgn_cnpv_ad2 <- function(census_data,
                                ad) {
  if (!all(is.na(as.numeric(ad)))) {
    if (any(ad %in% census_data$MPIO_CNMBR)) {
      census_data <- census_data %>%
        dplyr::filter(.data$MPIO_CNMBR %in% ad) %>%
        dplyr::select(all_of(c("MPIO_CNMBR", columns)))
    } else {
      census_data <- census_data %>%
        dplyr::filter(.data$DPTO_CNMBR %in% ad) %>%
        dplyr::select(all_of(c("DPTO_CNMBR", "MPIO_CNMBR", columns)))
    }
  } else {
    if (min(nchar(ad)) == 2) {
      census_data <- census_data %>%
        dplyr::filter(.data$MPIO_CDPMP %in% ad) %>%
        dplyr::select(all_of(c("MPIO_CDPMP", columns)))
    } else {
      census_data <- census_data %>%
        dplyr::filter(.data$DPTO_CCDGO %in% ad) %>%
        dplyr::select(all_of(c("DPTO_CCDGO", "MPIO_CDPMP", columns)))
    }
  }
  return(census_data)
}

#' Turn numeric vector of municipality codes into character vector
#'
#' @param codes numeric vector with municipality codes. They need to include the
#' department and the municipality code.
#'
#' @return character vector with municipality codes in standarized 5 digit code
#' @keywords internal
codes_to_string <- function(codes) {
  checkmate::assert_numeric(codes)

  if (min(nchar(codes)) == 4) {
    codes_str <- sapply(
      codes,
      function(i) {
        ifelse(nchar(i) == 4,
          paste0("0", i),
          paste0(i)
        )
      }
    )
  } else {
    codes_str <- sapply(
      codes,
      function(i) {
        ifelse(nchar(i) == 1,
          paste0("0", i),
          paste0(i)
        )
      }
    )
  }
  return(codes_str)
}
