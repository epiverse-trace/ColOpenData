#' Download geospatial dataset
#'
#' @description
#' This function downloads geospatial datasets from the Geostatistical National
#' Framework (MGN) at different levels of aggregation. These datasets include a
#' summarized version of the National Population and Dwelling Census (CNPV)
#' 
#' @param dataset character with the dataset name
#'
#' @examples
#' dptos <- download_geospatial("DANE_MGNCNPV_2018_DPTO")
#' print(dptos)
#'
#' @return \code{sf} \code{data.frame} object with structures' details and 
#' geometries
#' 
#' @export
download_geospatial <- function(dataset) {
  checkmate::assert_character(dataset)

  dataset_path <- retrieve_path(dataset)
  tryCatch(
    {
      geospatial_data <- retrieve_zip(
        dataset_path,
        dataset
      )
    },
    error = function(e) {
      stop("`dataset` not found")
    }
  )
  return(geospatial_data)
}
