#' Retrieve value from key
#'
#' @description
#' Retrieve value from key included in configuration file
#'
#' @param key character key
#'
#' @return character containing value
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
  base_path <- retrieve_value_key("base_path")
  all_datasets <- list_datasets()
  dataset_info <- all_datasets[which(all_datasets$name == dataset), ]
  # If dataset exists, build path
  if (nrow(dataset_info) == 1) {
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
  if (rlang::is_empty(directory_path)) {
    stop("`directory` not found")
  }
  return(directory_path)
}

#' Retrieve dictionary path of named dataset
#'
#' @param dataset character with the dictionary name
#'
#' @description
#' Dictionaries are not included in the general documentation file. Therefore,
#' the path is different from regular included files
#'
#' @return character with path to retrieve the dataset from server
#'
#' @keywords internal
retrieve_dict_path <- function(dataset) {
  base_path <- retrieve_value_key("base_path")
  group_path <- retrieve_value_key("dictionaries")
  dataset_path <- sprintf("%s.csv", dataset)
  file_path <- file.path(base_path, group_path, dataset_path)
  if (rlang::is_empty(file_path)) {
    stop("dictionary is not available")
  }
  return(file_path)
}

#' Retrieve support dataset path
#'
#' @param dataset character with the dataset name
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

#' Retrieve table (csv and data) file
#'
#' @param dataset_path character path to the dataset on repository
#' @param sep separator for table data
#'
#' @return dataset
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