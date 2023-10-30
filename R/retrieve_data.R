# Established path will change when the repository is moved to the final server

#' Retrieve path of named dataset
#'
#' @description
#' Retrieve included datasets path, to download them later.
#' @param dataset name of the consulted dataset
#'
#' @return path to retrieve the dataset from server
#'
#' @keywords internal
retrieve_path <- function(dataset) {
  config_file <- system.file("extdata", "config.yaml",
    package = "ColOpenData",
    mustWork = TRUE
  )
  base_path <- config::get(value = "base_path", file = config_file)
  relative_path <- config::get(value = dataset, file = config_file)
  file_path <- paste0(base_path, relative_path)
  if (rlang::is_empty(relative_path)) {
    stop("`dataset` is not available")
  }
  return(file_path)
}

#' Retrieve dataset from path
#'
#' @param dataset_path path to the dataset on repository
#'
#' @return consulted dataset
#'
#' @keywords internal
retrieve_dataset <- function(dataset_path) {
  ext_path <- system.file("extdata",
    package = "ColOpenData",
    mustWork = TRUE
  )
  #nolint start: nonportable_path_linter
  new_dir <- rev(unlist(strsplit(dataset_path, "[/.]")))[2]
  new_dir_path <- file.path(ext_path, new_dir)
  if (file.exists(new_dir_path)) {
    unlink(new_dir_path, recursive = TRUE)
  }
  dir.create(new_dir_path)
  if (grepl(".zip", tolower(dataset_path))) {
    new_file_path <- file.path(new_dir_path, new_dir)
    httr::GET(url = dataset_path, httr::write_disk(new_file_path))
    utils::unzip(new_file_path, exdir = new_dir_path)
    unlink(new_file_path, recursive = TRUE)
    import_dir <- list.files(new_dir_path)
    dataset <- sf::st_read(file.path(new_dir_path, import_dir))
    unlink(new_dir_path, recursive = TRUE)
  } else if (grepl(".xlsx", tolower(dataset_path))) {
    new_file_path <- file.path(new_dir_path, new_dir)
    httr::GET(url = dataset_path, httr::write_disk(new_file_path))
    dataset <- readxl::read_excel(new_file_path)
    unlink(new_dir_path, recursive = TRUE)
  } else {
    stop("`dataset` not found")
  }
  #nolint end
  return(dataset)
}

#' Change coordinate system to Magna Sirgas
#'
#' @description
#' Allows the user to set the Coordinate Reference System to local
#' (Magna Sirgas)
#'
#' @param .data sf object containing coordinates and established geometry
#'
#' @return sf dataframe with Colombian coordinate reference system
#'
#' @examples
#' \dontrun{
#' set_magna_sirgas(MGNCNPV_MUN_2018)
#' }
#'
#' @export
set_magna_sirgas <- function(.data) {
  checkmate::assert_class(.data, c("sf", "data.frame"))
  transformed <- sf::st_transform(.data, 4686)
  return(transformed)
}
