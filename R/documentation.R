#' Download data dictionary for geospatial data
#'
#' @param dataset character with the dataset name
#'
#' @return \code{tibble} with data dictionary
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
#' @param module character with module to be consulted (\code{"demographic"},
#' \code{"geospatial"}, \code{"climate"})
#'
#' @return \code{tibble} with the available datasets
#' @examples
#' list_datasets("geospatial")
#'
#' @export
list_datasets <- function(module = "all") {
  checkmate::assert_character(module)
  checkmate::assert_choice(module, c(
    "all", "demographic", "geospatial",
    "climate"
  ))

  config_file <- system.file("extdata",
    "config.yaml",
    package = "ColOpenData",
    mustWork = TRUE
  )
  base_path <- retrieve_value_key("base_path")
  documentation_path <- retrieve_value_key("documentation")
  # nolint start: nonportable_path_linter
  documentation <- file.path(base_path, documentation_path)
  # nolint end
  listed <- retrieve_table(documentation)
  if (module != "all") {
    listed <- listed[listed$group == module, ]
  }
  list_tibble <- tibble::as_tibble(listed)
  return(list_tibble)
}
