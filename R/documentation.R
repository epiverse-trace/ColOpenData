#' Download data dictionary for geospatial data
#'
#' @param dataset character with the dataset name
#'
#' @return \code{data.frame} with data dictionary
#' @examples
#' dictionary("DANE_MGN_2018_SETU")
#'
#' @export
dictionary <- function(dataset) {
  checkmate::assert_character(dataset)

  dict_path <- sprintf("DICT_%s", dataset)
  path <- retrieve_path(dict_path)
  dict <- retrieve_table(path, ";")
  return(dict)
}

#' Download list of available datasets
#'
#' @param module character with module to be consulted (\code{"demographic"},
#' \code{"geospatial"}, \code{"climate"})
#'
#' @return \code{data.frame} with the available datasets
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

  base_path <- retrieve_value_key("base_path")
  documentation_path <- retrieve_value_key("documentation")
  documentation <- file.path(base_path, documentation_path)
  listed <- retrieve_table(documentation)
  if (module != "all") {
    listed <- listed[listed$group == module, ]
  }
  return(listed)
}
