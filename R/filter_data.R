
#' Filter MGN data
#'
#' @param .data dataframe containing MGN - CNPV data
#' @param level numeric, either 1 for department or 2 for municipality level
#' @param filter list containing administrative divisions to be included and
#' columns to select from dataframe
#' @param include_geometry boolean to include (or not) the geometry.
#'
#' @return sf dataframe containing MGN(National Geo statistical Frame) and CNPV
#' (National Population and Living Census) data
#'
#' @export
filter_mgn_cnpv <- function(.data,
                            level,
                            filter = list(AD = "all", columns = "all"),
                            include_geometry = TRUE) {
  checkmate::assert_class(.data, c("sf", "data.frame"))
  checkmate::assert_choice(level, c(1, 2))
  checkmate::assert_list(filter)
  checkmate::assert_logical(include_geometry)
  
  if (is.null(filter$columns)) {
    columns <- "all"
  } else {
    columns <- filter$columns
  }
  
  if (is.null(filter$AD)) {
    rows <- "all"
  } else {
    rows <- filter$AD
  }
  
  census <- .data
  if (!include_geometry) {
    census <- sf::st_drop_geometry(census)
  }
  if (level == 2) {
    # check column names
    if (columns != "all" && !all(columns %in% colnames(census))) {
      stop("Specified column names are not included in the MGNCNPV02 dataset")
    } else if (columns == "all") {
      columns <- colnames(census)
    }
    if (all(rows %in% census$MPIO_CDPMP)) {
      census <- census %>%
        dplyr::filter(.data$MPIO_CDPMP %in% rows) %>%
        dplyr::select(dplyr::all_of(c(
          "MPIO_CDPMP", columns)))
    } else if (all(rows %in% census$MPIO_CNMBR)) {
      census <- census %>%
        dplyr::filter(.data$MPIO_CNMBR %in% rows) %>%
        dplyr::select(dplyr::all_of(c(
          "MPIO_CNMBR", columns)))
    } else if (all(rows == "all")) {
      census <- census %>% dplyr::select(dplyr::all_of(c(
        "MPIO_CDPMP", columns)))
    } else {
      stop("Some municipalities could not be found, please check your input")
    }
  } else if (level == 1) {
    # check column names
    if (columns != "all" && !all(columns %in% colnames(census))) {
      stop("Specified column names are not included in the MGNCNPV01 dataset")
    } else if (columns == "all") {
      columns <- colnames(census)
    }
    
    if (all(rows %in% census$DPTO_CCDGO)) {
      census <- census %>%
        dplyr::filter(.data$DPTO_CCDGO %in% rows) %>%
        dplyr::select(dplyr::all_of(c(
          "DPTO_CCDGO", columns)))
    } else if (all(rows %in% census$DPTO_CNMBR)) {
      census <- census %>%
        dplyr::filter(.data$DPTO_CNMBR %in% rows) %>%
        dplyr::select(dplyr::all_of(c(
          "DPTO_CNMBR", columns)))
    } else if (all(rows == "all")) {
      census <- census %>% dplyr::select(dplyr::all_of(c(
        "DPTO_CCDGO", columns)))
    } else {
      stop("Some departments could not be found, please check your input")
    }
  }
  return(census)
}
