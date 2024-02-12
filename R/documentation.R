#' Download data dictionary for geospatial dataframes
#'
#' @param dataset String indicating dataset code.
#'
#' @return tibble containing data dictionary
#' @examples
#' dictionary("DANE_MGNCNPV_2018_SETU")
#'
#' @export
dictionary <- function(dataset) {
  checkmate::assert_character(dataset)

  dict_path <- paste("DICT", dataset, sep = "_")
  path <- retrieve_path(dict_path)
  downloaded_dict <- retrieve_table(path, ";")
  dict_tibble <- tibble::as_tibble(downloaded_dict)
  return(dict_tibble)
}

#' Download list of available datasets
#'
#' @param module Specific group to be consulted ("demographic", "geospatial",
#' "climate")
#'
#' @return tibble containing listed available datasets
#' @examples
#' list_datasets("geospatial")
#'
#' @export
list_datasets <- function(module = "all") {
  checkmate::assert_character(category)
  checkmate::assert_choice(category, c(
    "all", "demographic", "geospatial",
    "climate"
  ))

  dataset_path <- retrieve_path("documentation")
  listed <- retrieve_table(dataset_path, ";")
  if (category != "all") {
    listed <- listed[listed$category == category, ]
  }
  list_tibble <- tibble::as_tibble(listed)
  return(list_tibble)
}
