#' Retrieve data from the 2018 National Population and Living Census
#'
#' @param mun character vector containing the DIVIPOLA official codes or the
#' municipalities names. Default is "all"
#' @param include_geometry boolean stating either to include or not the spatial
#' geometry
#' @param columns character vector indicating which columns are meant to be
#' included in the consultation
#'
#' @importFrom rlang .data
#'
#' @return a data.frame containing the consulted municipalities and desired
#' columns
#'
#' @examples
#' \dontrun{
#' get_mgn_cnpv_mun()
#' }
#'
#' @export
get_mgn_cnpv_mun <- function(mun = "all", include_geometry = TRUE,
                             columns = "all") {
  checkmate::assert_class(mun, "character")
  checkmate::assert_class(columns, "character")

  mgn_path <- retrieve_path("MGNCNPV02")
  census <- retrieve_dataset(mgn_path)
  if (!include_geometry) {
    census <- sf::st_drop_geometry(census)
  }
  # check column names
  if (columns != "all" && !all(columns %in% colnames(census))) {
    stop("Specified column names are not included in the MGN-CNPV dataset")
  } else if (columns == "all") {
    columns <- colnames(census)
  }

  if (all(mun %in% census$MPIO_CDPMP)) {
    census <- census %>%
      dplyr::filter(.data$MPIO_CDPMP %in% mun) %>%
      dplyr::select(dplyr::all_of(c("MPIO_CDPMP", columns)))
  } else if (all(mun %in% census$MPIO_CNMBR)) {
    census <- census %>%
      dplyr::filter(.data$MPIO_CNMBR %in% mun) %>%
      dplyr::select(dplyr::all_of(c(
        "MPIO_CNMBR",
        columns
      )))
  } else if (all(mun == "all")) {
    census <- census %>% dplyr::select(dplyr::all_of(c(
      "MPIO_CDPMP",
      columns
    )))
  } else {
    stop("Some municipalities could not be found, please check your input")
  }

  return(census)
}
