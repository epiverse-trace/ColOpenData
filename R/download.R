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
  if (rlang::is_empty(key_path)) {
    stop("data is not available")
  }
  return(key_path)
}

#' Retrieve path of named dataset
#'
#' @param dataset character with the dataset name
#' 
#' @description
#' Datasets are included in the general documentation file. Only dictionaries
#' and support files are treated differently and not included in the file.
#'
#' @return character with path to retrieve the dataset from server
#'
#' @keywords internal
retrieve_path <- function(dataset) {
  checkmate::assert_character(dataset)
  
  # nolint start: nonportable_path_linter
  base_path <- retrieve_value_key("base_path")
  if (grepl("DICT", dataset)) {
    group <- "dictionaries"
    group_path <- retrieve_value_key(group)
    ext <- ".csv"
    dataset_path <- paste0(dataset, ext)
    file_path <- file.path(base_path, group_path, dataset_path)
  } else {
    all_datasets <- list_datasets()
    dataset_info <- all_datasets[which(all_datasets$name == dataset), ]
  if (nrow(datasets_info) == 1) {
      group <- dataset_info$group
      group_path <- retrieve_value_key(group)
      if (group == "geospatial") {
        category <- dataset_info$category
        category_path <- retrieve_value_key(category)
        ext <- ".zip"
        dataset_path <- paste0(dataset, ext)
        file_path <- file.path(
          base_path, group_path,
          category_path, dataset_path
        )
      } else if (group == "climate") {
        directory_path <- dataset
        file_path <- file.path(
          base_path, group_path,
          directory_path
        )
      } else if (group == "demographic") {
        category <- dataset_info$category
        category_path <- retrieve_value_key(category)
        ext <- ".csv"
        dataset_path <- paste0(dataset, ext)
        file_path <- file.path(
          base_path, group_path,
          category_path, dataset_path
        )
      } else {
        file_path <- file.path(NULL)
      }
  }     else {
    dataset_path <- retrieve_value_key(dataset)
    file_path <- file.path(base_path, dataset_path)
  } 
    if (rlang::is_empty(file_path)) {
      stop("`dataset` is not available")
    }
  }
  # nolint end
  return(file_path)
}

#' Retrieve zip file
#'
#' @param dataset_path character with the path to dataset on repository
#' @param dataset_name character with the dataset name
#'
#' @return \code{sf} data.frame object with structures' details and geometries
#'
#' @keywords internal
retrieve_zip <- function(dataset_path, dataset_name) {
  ext_path <- system.file("extdata",
    package = "ColOpenData",
    mustWork = TRUE
  )
  # nolint start: nonportable_path_linter
  directory <- file.path(ext_path, dataset_name)
  if (file.exists(directory)) {
    unlink(directory,
      recursive = TRUE
    )
  }
  dir.create(directory)
  temp_file <- file.path(directory, dataset_name)
  request <- httr2::request(base_url = dataset_path)
  response <- httr2::req_perform(request)
  content <- httr2::resp_body_raw(response)
  writeBin(content, con = temp_file)
  utils::unzip(temp_file,
    exdir = directory
  )
  unlink(temp_file,
    recursive = TRUE
  )
  unzipped <- list.files(directory)
  downloaded_data <- sf::st_read(file.path(
    directory,
    unzipped
  ))
  # nolint end
  unlink(directory,
    recursive = TRUE
  )
  return(downloaded_data)
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
