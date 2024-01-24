#' Download data dictionary for geospatial dataframes
#'
#' @param dataset String indicating dataset code.
#'
#' @return tibble containing data dictionary
#' @examples
#' data_dictionary("DANE_MGNCNPV_2018_SETU")
#'
#' @export
dictionary <- function(dataset) {
  dict_path <- paste("DICT", dataset, sep = "_")
  checkmate::assert_character(dataset)
  path <- retrieve_path(dict_path)
  downloaded_dict <- retrieve_table(path, ";")
  dict_tibble <- tibble::as_tibble(downloaded_dict)
  return(dict_tibble)
}

#' Download list of available datasets
#'
#' @param group Specific group to be consulted ("demographic", "geospatial",
#' "climate")
#'
#' @return tibble containing listed available datasets
#' @examples
#' list_data("geospatial")
#'
#' @export
list_data <- function(group = "all") {
  checkmate::assert_character(group)
  checkmate::assert_choice(group, c(
    "all", "demographic", "geospatial",
    "climate"
  ))

  dataset_path <- retrieve_path("documentation")
  listed <- retrieve_table(dataset_path, ",")
  if (group != "all") {
    listed <- listed[listed$group == group]
  }
  list_tibble <- tibble::as.tibble(listed)
  return(list_tibble)
}
