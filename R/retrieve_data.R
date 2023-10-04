# Established path will change when the repository is moved to the final server

#' Retrieve path of named dataset
#'
#' @param dataset_name name of the consulted dataset
#'
#' @return path to retrieve the dataset from server
#'
#' @keywords internal
retrieve_path <- function(dataset) {
  # include all paths and datasets
  config_file <- system.file("config.yaml", 
                                 package = "ColOpenData", 
                                 mustWork = TRUE)
  base_path <- config::get(value = "base_path", file = config_file)
  file_path <- config::get(value = dataset, file = config_file)
  file_path <- paths[which(datasets == dataset)]
  if (rlang::is_empty(file_path)) {
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
  if (grepl(".RDS", dataset_path)) {
    dataset <- readr::read_rds(dataset_path)
  } else if (grepl(".xslx", dataset_path)) {
    dataset <- readxl::read_excel(dataset_path)
  }
  return(dataset)
}

#' Change coordinate system to Magna Sirgas
#'
#' @param .data sf object containing coordinates and established geometry
#'
#' @return sf dataframe with Colombian coordinate reference system
#'
#' @keywords internal
set_magna_sirgas <- function(.data) {
  checkmate::assert_class(.data, c("sf", "data.frame"))
  transformed <- sf::st_transform(.data, 4686)
  return(transformed)
}
