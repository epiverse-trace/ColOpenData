#' Retrieve value from key
#'
#' @description
#' Retrieve value from key included in configuration file.
#'
#' @param key character key.
#'
#' @return character containing associated value.
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
#' @description
#' Demographic and Geospatial datasets are included in the general documentation
#' file. Path is built from information in the general file.
#'
#' @param dataset character with the dataset name.
#'
#' @return character with path to retrieve the dataset from server.
#'
#' @keywords internal
retrieve_path <- function(dataset) {
  checkmate::assert_character(dataset)

  ext <- list(
    geospatial = ".gpkg",
    demographic = ".csv",
    population_projections = ".csv"
  )
  base_path <- retrieve_value_key("base_path")
  all_datasets <- list_datasets()
  dataset_info <- all_datasets[which(all_datasets[["name"]] == dataset), ]
  if (nrow(dataset_info) == 1) {
    group_path <- retrieve_value_key(dataset_info[["group"]])
    category_path <- retrieve_value_key(dataset_info[["category"]])
    dataset_path <- paste0(dataset, ext[[dataset_info[["group"]]]])
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

#' Retrieve climate directory path
#'
#' @description
#' Climate data is retrieved from a general directory. Path is build for said
#' directory.
#'
#' @return character with path to retrieve the dataset from server.
#'
#' @keywords internal
retrieve_climate_path <- function() {
  base_path <- retrieve_value_key("base_path")
  group_path <- retrieve_value_key("climate")
  directory_path <- file.path(base_path, group_path)
  return(directory_path)
}

#' Retrieve dictionary path of named dataset
#'
#' @description
#' Dictionaries are not included in the general documentation file. Therefore,
#' the path is built internally.
#'
#' @param dataset character with the dictionary name.
#'
#' @return character with path to retrieve the dataset.
#'
#' @keywords internal
retrieve_dict_path <- function(dict_name) {
  dict_file <- system.file(
    "extdata",
    dict_name,
    package = "ColOpenData",
    mustWork = TRUE
  )
  return(dict_file)
}

#' Retrieve support dataset path
#'
#' @description
#' Support data is used for internal purposes and they are not included in the
#' general documentation file.
#'
#' @param dataset character with the support dataset name.
#'
#' @return character with path to retrieve the dataset from server.
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
#' @param dataset_path character path to the dataset on server.
#' @param sep separator for table data.
#'
#' @return \code{data.frame} object with downloaded data.
#'
#' @keywords internal
retrieve_table <- function(dataset_path, sep = ";") {
  downloaded_data <- suppressMessages(
    suppressWarnings(
      utils::read.csv2(dataset_path,
        sep = sep,
        header = TRUE,
        colClasses = c(
          codigo_departamento = "character",
          codigo_municipio = "character"
        ),
        fileEncoding = "UTF-8"
      )
    )
  )
  downloaded_data <- as.data.frame(downloaded_data)
  return(downloaded_data)
}

#' Retrieve climate table file from one station
#'
#' @param dataset_path character path to the climate dataset on server.
#' @param start_date character with the first date to consult in the format
#' \code{"YYYY-MM-DD"}. (First available date is \code{"1920-01-01"}).
#' @param end_date character with the last date to consult in the format
#' \code{"YYYY-MM-DD"} (Last available date is \code{"2023-05-31"}).
#'
#' @return \code{data.frame} object with downloaded data filtered for requested
#' dates.
#'
#' @keywords internal
retrieve_climate <- function(dataset_path, start_date, end_date) {
  downloaded_data <- data.frame()
  try(
    {
      station_data <- suppressMessages(
        suppressWarnings(
          utils::read.table(dataset_path,
            sep = "|",
            header = TRUE,
            fileEncoding = "UTF-8",
            numerals = "no.loss"
          )
        )
      )
      names(station_data) <- c("date", "value")
      station_data[["date"]] <- as.POSIXct(station_data[["date"]],
        format = "%Y-%m-%d %H:%M:%S",
        tz = "UTC"
      )
      downloaded_data <- station_data
    },
    silent = TRUE
  )
  return(downloaded_data)
}
