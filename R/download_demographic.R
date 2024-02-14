#' Download demographic dataset
#' 
#' @description
#' This function downloads demographic datasets from the National Population 
#' and Housing Census (CNPV)
#'
#' @param dataset character with the dataset name
#'
#' @examples
#' dem <- download_demographic("DANE_CNPVH_2018_1HD")
#' print(dem)
#'
#' @return \code{data.frame} with downloaded data.
#' @export
download_demographic <- function(dataset) {
  checkmate::assert_character(dataset)
<<<<<<< HEAD
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
retrieve_demographic_dataset <- function(dataset_path) {
  tryCatch(
    {
      dataset <- retrieve_table(dataset_path, sep = ";")
=======
  dataset_path <- retrieve_path(dataset)
  tryCatch(
    {
      demographic_data <- retrieve_table(dataset_path,
        sep = ";"
      )
>>>>>>> 99c2b6ada0fa3818b43934ae355dc01690414e43
    },
    error = function(e) {
      stop("`dataset` not found")
    }
  )
  return(demographic_data)
}
