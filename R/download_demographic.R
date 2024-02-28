#' Download demographic dataset
#'
#' @description
#' This function downloads demographic datasets from the National Population
#' and Dwelling Census (CNPV)
#'
#' @param dataset character with the dataset name
#'
#' @examples
#' house_under_15 <- download_demographic("DANE_CNPVH_2018_1HD")
#'
#' @return \code{data.frame} with downloaded data.
#' @export
download_demographic <- function(dataset) {
  checkmate::assert_character(dataset)

  dataset_path <- retrieve_path(dataset)
  tryCatch(
    {
      demographic_data <- retrieve_table(dataset_path)
    },
    error = function(e) {
      stop("`dataset` not found")
    }
  )
  return(demographic_data)
}
