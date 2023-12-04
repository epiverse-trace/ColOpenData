#' Download geospatial dataset
#' @description
#' Download geospatial named dataset from server. This data is merged with a
#' simplified version of the National Census, associating the census with each
#' geospatial structure.
#'
#' @param dataset String indicating dataset code.
#'
#' @return data.frame downloaded data.
#' @examples
#' download_geospatial("DANE_MGNCNPV_2018_DPTO")
#'
#' @export
download_geospatial <- function(dataset) {
  checkmate::assert_character(dataset)
  path <- retrieve_path(dataset)
  downloaded_data <- retrieve_geospatial_dataset(path)
  return(downloaded_data)
}


#' Retrieve geospatial dataset from path
#'
#' @param dataset_path path to the dataset on repository.
#'
#' @return Consulted dataset.
#'
#' @keywords internal
retrieve_geospatial_dataset <- function(dataset_path) {
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
  dataset <- retrieve_zip(dataset_path, new_dir_path, new_dir)
  # nolint end
  return(dataset)
}
