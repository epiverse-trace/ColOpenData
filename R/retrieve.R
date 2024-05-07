#' Retrieve value from key
#'
#' @description
#' Retrieve value from key included in configuration file
#'
#' @param key character key
#'
#' @return character containing associated value
#'
#' @keywords internal
retrieve_value_key <- function(key) {
  config_file <- system.file(
    "extdata",
    "config.yaml",
    package = "ColOpenData",
    mustWork = TRUE
  )
  key_path <- config::get(
    value = key,
    file = config_file
  )
  return(key_path)
}

#' Retrieve demographic and geospatial path of named dataset
#'
#' @param dataset character with the dataset name
#'
#' @description
#' Demographic and Geospatial datasets are included in the general documentation
#' file. Path is built from information in the general file
#'
#' @return character with path to retrieve the dataset from server
#'
#' @keywords internal
retrieve_path <- function(dataset) {
  checkmate::assert_character(dataset)

  ext <- list(
    geospatial = ".gpkg",
    demographic = ".csv"
  )
  all_datasets <- list_datasets()
  dataset_info <- all_datasets[which(all_datasets$name == dataset), ]
  if (nrow(dataset_info) == 1) {
    base_path <- retrieve_value_key("base_path")
    group_path <- retrieve_value_key(dataset_info$group)
    category_path <- retrieve_value_key(dataset_info$category)
    dataset_path <- paste0(dataset, ext[[dataset_info$group]])
    file_path <- file.path(
      base_path, group_path,
      category_path, dataset_path
    )
  } else {
    file_path <- file.path(NULL)
  }
  if (rlang::is_empty(file_path)) {
    stop("`dataset` not found")
  }
  return(file_path)
}

#' Retrieve local demographic and geospatial path of named dataset
#'
#' @param dataset character with the dataset name
#'
#' @description
#' Demographic and Geospatial datasets are included in the general documentation
#' file. Path is built from information in the general file and local storage
#' folder
#'
#' @return character with path to retrieve the dataset from local storage
#'
#' @keywords internal
retrieve_local_path <- function(dataset){
  checkmate::assert_character(dataset)
  
  ext <- list(
    geospatial = ".gpkg",
    demographic = ".csv"
  )
  all_datasets <- list_datasets()
  dataset_info <- all_datasets[which(all_datasets$name == dataset), ]
  if (nrow(dataset_info) == 1) {
    cache_dir <- tools::R_user_dir("ColOpenData", "data")
    group_path <- retrieve_value_key(dataset_info$group)
    category_path <- retrieve_value_key(dataset_info$category)
    dataset_path <- paste0(dataset, ext[[dataset_info$group]])
    local_directory <- file.path(
      cache_dir, group_path,
      category_path
    )
    if(!dir.exists(local_directory)){
      dir.create(local_directory,recursive = TRUE)
    }
    file_path <- file.path(local_directory, dataset_path)
  } else {
    file_path <- file.path(NULL)
  }
  if (rlang::is_empty(file_path)) {
    stop("`dataset` not found")
  }
  return(file_path)
}

#' Retrieve climate directory path of named dataset
#'
#' @param dataset character with the dataset name
#'
#' @description
#' Climate data is retrieved from a general directory. Path is build for said
#' directory
#'
#' @return character with path to retrieve the dataset from server
#'
#' @keywords internal
retrieve_climate_path <- function() {
  base_path <- retrieve_value_key("base_path")
  group_path <- retrieve_value_key("climate")
  directory_path <- file.path(base_path, group_path)
  return(directory_path)
}

retrieve_local_climate_path <- function(){
  cache_dir <- tools::R_user_dir("ColOpenData", "data")
  group_path <- retrieve_value_key("climate")
  directory_path <- file.path(cache_dir, group_path)
  if(!dir.exists(directory_path)){
    dir.create(directory_path,recursive = TRUE)
  }
  return(directory_path)
}

#' Retrieve dictionary path of named dataset
#'
#' @param dataset character with the dictionary name
#'
#' @description
#' Dictionaries are not included in the general documentation file. Therefore,
#' the path is built internally
#'
#' @return character with path to retrieve the dataset from server
#'
#' @keywords internal
retrieve_dict_path <- function(dataset) {
  base_path <- retrieve_value_key("base_path")
  group_path <- retrieve_value_key("dictionaries")
  dataset_path <- sprintf("%s.csv", dataset)
  file_path <- file.path(base_path, group_path, dataset_path)
  return(file_path)
}

retrieve_local_dict_path <- function(dataset){
  cache_dir <- tools::R_user_dir("ColOpenData", "data")
  group_path <- retrieve_value_key("dictionaries")
  directory_path <- file.path(cache_dir, group_path)
  if(!dir.exists(directory_path)){
    dir.create(directory_path,recursive = TRUE)
  }
  dataset_path <- sprintf("%s.csv", dataset)
  file_path <- file.path(directory_path, dataset_path)
  return(file_path)
}

#' Retrieve support dataset path
#'
#' @param dataset character with the support dataset name
#'
#' @description
#' Support data is used for internal purposes and they are not included in the
#' general documentation file
#'
#' @return character with path to retrieve the dataset from server
#'
#' @keywords internal
retrieve_support_path <- function(dataset) {
  base_path <- retrieve_value_key("base_path")
  dataset_path <- retrieve_value_key(dataset)
  file_path <- file.path(base_path, dataset_path)
  if (rlang::is_empty(file_path)) {
    stop("`dataset` not found")
  }
  return(file_path)
}

retrieve_local_support_path <- function(dataset){
  cache_dir <- tools::R_user_dir("ColOpenData", "data")
  dataset_path <- retrieve_value_key(dataset)
  file_path <- file.path(cache_dir, dataset_path)
  return(file_path)
}

#' Retrieve table (csv and data) file from server
#'
#' @param dataset_path character path to the dataset on server
#'
#' @param sep separator for table data
#'
#' @return \code{data.frame} object with downloaded data
#'
#' @keywords internal
retrieve_table <- function(dataset_path, sep = ";") {
  request <- httr2::request(base_url = dataset_path)
  response <- httr2::req_perform(request)
  content <- httr2::resp_body_string(response)
  downloaded_data <- suppressMessages(
    suppressWarnings(
      readr::read_delim(content,
        delim = sep,
        escape_double = FALSE,
        trim_ws = TRUE,
        show_col_types = FALSE
      )
    )
  )
  downloaded_data <- as.data.frame(downloaded_data)
  return(downloaded_data)
}

retrieve_local_table <- function(dataset_path, sep = ";"){
  downloaded_data <- suppressWarnings(
    readr::read_delim(dataset_path,
                      delim = ";",
                      escape_double = FALSE,
                      trim_ws = TRUE,
                      show_col_types = FALSE
    )
  )
  demographic_data <- as.data.frame(downloaded_data)
  return(downloaded_data)
}

#' Retrieve climate (.data) file from one station
#'
#' @param dataset_path character path to the climate dataset on server
#' @param start_date character with the first date to consult in the format
#' \code{"YYYY-MM-DD"}
#' @param end_date character with the last date to consult in the format
#' \code{"YYYY-MM-DD"} (Last available date is \code{"2023-05-31"})
#'
#' @return \code{data.frame} object with downloaded data filtered for requested
#' dates
#'
#' @keywords internal
retrieve_climate <- function(dataset_path, start_date, end_date) {
  base_request <- httr2::request(base_url = dataset_path)
  request <- httr2::req_error(base_request, is_error = \(resp) FALSE)
  response <- httr2::req_perform(request)
  downloaded_data <- data.frame()
  if (httr2::resp_status(response) == 200) {
    content <- httr2::resp_body_string(response)
    station_data <- suppressMessages(
      suppressWarnings(
        readr::read_delim(content,
          delim = "|",
          escape_double = FALSE,
          trim_ws = TRUE,
          show_col_types = FALSE
        )
      )
    )
    names(station_data) <- c("date", "value")
    station_data$date <- as.POSIXct(station_data$date,
      format = "%Y-%m-%d %H:%M:%S",
      tz = "UTC"
    )
    downloaded_data <- station_data
  }
  return(downloaded_data)
}

download_file <- function(dataset_path, file_path){
  request <- httr2::request(base_url = dataset_path)
  response <- httr2::req_perform(request, path = file_path)
  message("Dataset downloaded successfully")
}
