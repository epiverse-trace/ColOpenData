#' Filter MGN data
#'
#' @param .data dataframe containing MGN - CNPV data
#' @param level numeric, either 1 for department or 2 for municipality level
#' @param include_geometry boolean to include (or not) the geometry.
#' @param ad character vector with municipalities to filter
#' @param columns character vector with columns to filter
#'
#' @return sf dataframe containing MGN(National Geo statistical Frame) and CNPV
#' (National Population and Living Census) data
#'
#' @export
filter_mgn_cnpv <- function(.data,
                            level,
                            ad = NULL,
                            columns = NULL,
                            include_geometry = TRUE) {
  checkmate::assert_class(.data, c("sf", "data.frame"))
  checkmate::assert_choice(level, c(1, 2))
  checkmate::assert_logical(include_geometry)
  checkmate::assert_character(ad, null.ok = TRUE)
  checkmate::assert_character(columns, null.ok = TRUE)

  census <- .data
  if (!include_geometry) {
    census <- sf::st_drop_geometry(census)
  }
  if (!is.null(columns) && !all(columns %in% colnames(census))) {
    stop("Specified column names are not included in the dataset")
  }
  if (level == 2) {
    # check column names
    if (all(ad %in% census$MPIO_CDPMP)) {
      census <- census %>%
        dplyr::filter(.data$MPIO_CDPMP %in% ad) %>%
        dplyr::select(dplyr::all_of(c(
          "MPIO_CDPMP", columns
        )))
    } else if (all(ad %in% census$MPIO_CNMBR)) {
      census <- census %>%
        dplyr::filter(.data$MPIO_CNMBR %in% ad) %>%
        dplyr::select(dplyr::all_of(c(
          "MPIO_CNMBR", columns
        )))
    } else if (is.null(ad)) {
      census <- census %>% dplyr::select(dplyr::all_of(c(
        "MPIO_CDPMP", "MPIO_CNMBR", columns
      )))
    } else {
      stop("Some municipalities could not be found, please check your input")
    }
  } else if (level == 1) {
    if (all(ad %in% census$DPTO_CCDGO)) {
      census <- census %>%
        dplyr::filter(.data$DPTO_CCDGO %in% ad) %>%
        dplyr::select(dplyr::all_of(c(
          "DPTO_CCDGO", columns
        )))
    } else if (all(ad %in% census$DPTO_CNMBR)) {
      census <- census %>%
        dplyr::filter(.data$DPTO_CNMBR %in% ad) %>%
        dplyr::select(dplyr::all_of(c(
          "DPTO_CNMBR", columns
        )))
    } else if (is.null(ad)) {
      census <- census %>% dplyr::select(dplyr::all_of(c(
        "DPTO_CCDGO", "DPTO_CNMBR", columns
      )))
    } else {
      stop("Some departments could not be found, please check your input")
    }
  }
  return(census)
}
