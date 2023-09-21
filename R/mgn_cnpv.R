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
#' @export
#'
#' @examples
#' \dontrun{
#' get_mgn_cnpv_mun()
#' }
get_mgn_cnpv_mun <- function(mun = "all", include_geometry = TRUE,
                             columns = "all") {
  checkmate::assert_class(mun, "character")
  checkmate::assert_class(columns, "character")
  # import dataset
  mgn_cnpv <- municipios # WRONG
  if (!include_geometry) {
    census <- sf::st_drop_geometry(mgn_cnpv)
  } else {
    if (sf::st_crs(mgn_cnpv)$epsg != 4686) {
      sf::st_transform(mgn_cnpv, 4686)
    }
    census <- sf::st_make_valid(mgn_cnpv)
  }
  # check column names
  if (columns != "all" && !all(columns %in% colnames(census))) {
    stop("Specified column names are not included in the MGN-CNPV dataset")
  } else if (columns == "all") {
    columns <- colnames(census)
  }

  if (all(mun %in% mgn_cnpv$MPIO_CDPMP)) {
    census_2 <- census %>%
      dplyr::filter(.data$MPIO_CDPMP %in% mun) %>%
      dplyr::select(dplyr::all_of(c("MPIO_CDPMP", columns)))
  } else if (all(mun %in% mgn_cnpv$MPIO_CNMBR)) {
    census_2 <- census %>%
      dplyr::filter(.data$MPIO_CNMBR %in% mun) %>%
      dplyr::select(dplyr::all_of(c("MPIO_CNMBR",
                                    columns)))
  } else if (all(mun == "all")) {
    census_2 <- census %>% dplyr::select(dplyr::all_of(c("MPIO_CDPMP",
                                                         columns)))
  } else {
    stop("Some municipalities could not be found, please check your input")
  }

  return(census_2)
}
