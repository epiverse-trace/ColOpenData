#' Filter MGN data
#'
#' @param .data dataframe containing MGN - CNPV data
#' @param include_geometry boolean to include (or not) the geometry.
#' @param codes vector with municipalities or departments to filter
#' @param columns character vector with columns to filter
#' @importFrom rlang .data
#'
#' @return sf dataframe containing MGN(National Geo statistical Frame) and CNPV
#' (National Population and Living Census) data
#'
#' @export
filter_mgn_cnpv <- function(.data,
                            codes = NULL,
                            columns = NULL,
                            include_geometry = TRUE) {
  checkmate::assert_class(.data, c("sf", "data.frame"))
  checkmate::assert_logical(include_geometry)
  checkmate::assert_choice(columns, colnames(.data), null.ok = TRUE)

  census <- .data
  if (!include_geometry) {
    census <- sf::st_drop_geometry(census)
  }
  if (is.null(columns)) {
    columns <- colnames(census)
  }

  if ("MPIO_CDPMP" %in% colnames(census) ||
    "MPIO_CNMBR" %in% colnames(census)) {
    level <- 2
  } else {
    level <- 1
  }

  if (level == 2) {
    if (is.null(codes)) {
      codes <- census$MPIO_CDPMP
    } else if (is.numeric(codes)) {
      codes <- codes_to_string(codes)
    }
    census <- census %>% dplyr::select(dplyr::all_of(columns))

    filtered_data <- filter_mgn_cnpv_ad2(census, codes, columns)
  } else if (level == 1) {
    if (is.null(codes)) {
      codes <- census$DPTO_CCDGO
    } else if (is.numeric(codes)) {
      codes <- codes_to_string(codes)
    }
    census <- census %>% dplyr::select(dplyr::all_of(columns))

    filtered_data <- filter_mgn_cnpv_ad1(census, codes, columns)
  }
  return(filtered_data)
}

#' Filter department dataset
#'
#' @param census_data MGN - CNPV dataset
#' @param codes Administrative division to include
#' @param columns Columns to include
#'
#' @return filtered dataset for department level
#' @keywords internal
filter_mgn_cnpv_ad1 <- function(census_data,
                                codes, columns) {
  if (all(is.na(suppressWarnings(as.numeric(codes))))) {
    census_data <- census_data %>%
      dplyr::filter(.data$DPTO_CNMBR %in% codes) %>%
      dplyr::select(dplyr::all_of(c("DPTO_CNMBR", columns)))
  } else {
    census_data <- census_data %>%
      dplyr::filter(.data$DPTO_CCDGO %in% codes) %>%
      dplyr::select(dplyr::all_of(c("DPTO_CCDGO", columns)))
  }

  return(census_data)
}

#' Filter municipal dataset
#'
#' @param census_data MGN - CNPV dataset
#' @param codes Administrative division to include
#' @param columns Columns to include
#'
#' @return filtered dataset for municipal level
#' @keywords internal
filter_mgn_cnpv_ad2 <- function(census_data,
                                codes, columns) {
  if (all(is.na(suppressWarnings(as.numeric(codes))))) {
    if (any(codes %in% census_data$MPIO_CNMBR)) {
      census_data <- census_data %>%
        dplyr::filter(.data$MPIO_CNMBR %in% codes) %>%
        dplyr::select(dplyr::all_of(c("MPIO_CNMBR", columns)))
    } else {
      departments <- download("MGNCNPV01")
      included_names <- departments$DPTO_CCDGO[which(
        departments$DPTO_CNMBR %in% codes
      )]
      census_data <- census_data %>%
        dplyr::filter(.data$DPTO_CCDGO %in% included_names) %>%
        dplyr::select(dplyr::all_of(c("DPTO_CCDGO", "MPIO_CNMBR", columns)))
    }
  } else {
    if (min(nchar(codes)) == 2) {
      census_data <- census_data %>%
        dplyr::filter(.data$MPIO_CDPMP %in% codes) %>%
        dplyr::select(dplyr::all_of(c("MPIO_CDPMP", columns)))
    } else {
      census_data <- census_data %>%
        dplyr::filter(.data$DPTO_CCDGO %in% codes) %>%
        dplyr::select(dplyr::all_of(c("DPTO_CCDGO", "MPIO_CDPMP", columns)))
    }
  }
  return(census_data)
}

#' Turn numeric vector of municipality codes into character vector
#'
#' @param codes numeric vector with municipality codes. They need to include the
#' department and the municipality code.
#'
#' @return character vector with municipality codes in standardized code
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
