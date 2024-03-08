#' Download demographic dataset
#'
#' @description
#' This function downloads demographic datasets from the National Population
#' and Dwelling Census (CNPV) and Population Projections
#'
#' @param dataset character with the demographic dataset name
#'
#' @examples
#' house_under_15 <- download_demographic("DANE_CNPVH_2018_1HD")
#'
#' @return \code{data.frame} object with downloaded data
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
  message("Original data is provided by the National Administrative Department of Statistics (DANE).\n",
          "Reformatted by the package authors.\n",
          "Stored and redistributed by Universidad de Los Andes under the Epiverse TRACE iniative.")
  return(demographic_data)
}
