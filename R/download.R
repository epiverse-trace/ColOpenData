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
  checkmate::assert_character(dataset)
  config_file <- system.file("extdata", "config.yaml",
    package = "ColOpenData",
    mustWork = TRUE
  )
  base_path <- config::get(
    value = "base_path",
    file = config_file
  )
  file_path <- config::get(
    value = dataset,
    file = config_file
  )
  if (rlang::is_empty(file_path)) {
    stop("`dataset` is not available")
  }
  dataset_path <- paste0(base_path, file_path)
  return(dataset_path)
}

#' Retrieve zip file
#'
#' @param dataset_path Path to dataset on repository
#' @param dataset Dataset name to download
#'
#' @return dataset
#' @keywords internal
retrieve_zip <- function(dataset_path, dataset) {
  ext_path <- system.file("extdata",
    package = "ColOpenData",
    mustWork = TRUE
  )
  # nolint start: nonportable_path_linter
  directory <- file.path(ext_path, dataset)
  if (file.exists(directory)) {
    unlink(directory,
      recursive = TRUE
    )
  }
  dir.create(directory)
  temp_file <- file.path(directory, dataset)
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
#' @param dataset_path path to the dataset on repository
#' @param sep separator for table data
#'
#' @return dataset
#' @keywords internal
retrieve_table <- function(dataset_path, sep) {
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
