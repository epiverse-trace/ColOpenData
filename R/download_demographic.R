#' Download demographic dataset
#' @description
#' Download demographic named dataset from server. This data is obtained from
#' the national census of 2018.
#'
#' @param dataset dataset code
#' @param sheet string to indicate specific sheet
#'
#' @return dataframe downloaded
#' @examples
#' download_demographic("DANE_CNPV_2018_Hogares", "1HD")
#'
#' @export
download_demographic <- function(dataset, sheet = "None") {
  checkmate::assert_character(dataset)
  checkmate::assert_character(sheet)
  path <- retrieve_path(dataset)
  downloaded_data <- retrieve_demographic_dataset(path, sheet)
  return(downloaded_data)
}

#' Retrieve demographic dataset from path
#'
#' @param dataset_path path to the dataset on repository
#' @param sheet string to indicate specific sheet
#'
#' @return consulted dataset
#'
#' @keywords internal
retrieve_demographic_dataset <- function(dataset_path, sheet) {
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
  if (grepl(".xlsx", tolower(dataset_path))) {
    dataset <- retrieve_excel(dataset_path, new_dir_path, new_dir, sheet)
  } else {
    stop("`dataset` not found")
  }
  # nolint end
  return(dataset)
}
