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

#' Retrieve excel file
#'
#' @param dataset_path path to the dataset on repository
#' @param new_dir_path path to the created directory
#' @param new_dir directory to store data
#' @param sheet string to indicate specific sheet
#'
#' @return dataset
#' @keywords internal
retrieve_excel <- function(dataset_path, new_dir_path, new_dir, sheet) {
  new_file_path <- file.path(new_dir_path, new_dir)
  httr::GET(url = dataset_path, httr::write_disk(new_file_path))
  print(new_file_path)
  if (sheet == "None") {
    dataset <- readxl::read_excel(new_file_path)
  } else {
    dataset <- readxl::read_excel(new_file_path, sheet = sheet)
  }
  unlink(new_dir_path, recursive = TRUE)
  dataset <- as.data.frame(dataset)
  return(dataset)
}

#' Retrieve zip file
#'
#' @param dataset_path path to the dataset on repository
#' @param new_dir_path path to the created directory
#' @param new_dir directory to store data
#'
#' @return dataset
#' @keywords internal
retrieve_zip <- function(dataset_path, new_dir_path, new_dir) {
  new_file_path <- file.path(new_dir_path, new_dir)
  httr::GET(url = dataset_path, httr::write_disk(new_file_path))
  utils::unzip(new_file_path, exdir = new_dir_path)
  unlink(new_file_path, recursive = TRUE)
  import_dir <- list.files(new_dir_path)
  dataset <- sf::st_read(file.path(new_dir_path, import_dir))
  unlink(new_dir_path, recursive = TRUE)
  return(dataset)
}

#' Retrieve csv file
#'
#' @param dataset_path path to the dataset on repository
#' @param new_dir_path path to the created directory
#' @param new_dir directory to store data
#' @param sep separator for csv data
#'
#' @return dataset
#' @keywords internal
retrieve_csv <- function(dataset_path, new_dir_path, new_dir, sep) {
  new_file_path <- file.path(new_dir_path, new_dir)
  httr::GET(url = dataset_path, httr::write_disk(new_file_path))
  print(new_file_path)
  dataset <- utils::read.csv(new_file_path, header = TRUE, sep = sep)
  unlink(new_dir_path, recursive = TRUE)
  dataset <- as.data.frame(dataset)
  return(dataset)
}
