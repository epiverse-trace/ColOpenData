#' Download data dictionary
#'
#' @param dataset String indicating dataset code.
#'
#' @return tibble containing data dictionary
#' @examples
#' data_dictionary("DANE_MGNCNPV_2018_SETU")
#'
#' @export
data_dictionary <- function(dataset) {
  dict_path <- paste("DICT", dataset, sep = "_")
  checkmate::assert_character(dataset)
  path <- retrieve_path(dict_path)
  downloaded_dict <- retrieve_dictionary(path)
  dict_tibble <- tibble::as_tibble(downloaded_dict)
  return(dict_tibble)
}

#' Retrieve dictionary from path
#'
#' @param dataset_path path to the dataset on repository
#'
#' @return consulted dictionary.
#'
#' @keywords internal
retrieve_dictionary <- function(dataset_path) {
  ext_path <- system.file("extdata",
    package = "ColOpenData",
    mustWork = TRUE
  )
  # nolint start: nonportable_path_linter
  new_dir <- rev(unlist(strsplit(dataset_path, "[/.]")))[2]
  new_dir_path <- file.path(ext_path, new_dir)
  if (file.exists(new_dir_path)) {
    unlink(new_dir_path, recursive = TRUE)
  }
  dir.create(new_dir_path)
  if (grepl(".csv", tolower(dataset_path))) {
    dataset <- retrieve_csv(dataset_path, new_dir_path, new_dir, sep = ";")
  } else {
    stop("`dataset` not found")
  }
  # nolint end
  return(dataset)
}
