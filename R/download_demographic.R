#' Download demographic dataset
#' @description
#' Download demographic dataset. This data is obtained from the national census
#' of 2018.
#'
#' @param dataset String indicating dataset code.
#'
#' @return data.frame downloaded.
#' @examples
#' download_demographic("DANE_CNPVH_2018_1HD")
#'
#' @export
download_demographic <- function(dataset) {
  checkmate::assert_character(dataset)
  path <- retrieve_path(dataset)
  downloaded_data <- retrieve_demographic_dataset(path)

  return(downloaded_data)
}

#' Retrieve demographic dataset from path
#'
#' @param dataset_path path to the dataset on repository
#' @param sheet string to indicate specific sheet.
#'
#' @return consulted dataset.
#'
#' @keywords internal
retrieve_demographic_dataset <- function(dataset_path, sheet) {
  tryCatch(
    {
      dataset <- retrieve_table(dataset_path, sep = ";")
      dataset <- dataset[, -c(1, 2)] # Remove index (temporary)
    },
    error = function(e) {
      stop("`dataset` not found")
    }
  )
  return(dataset)
}
