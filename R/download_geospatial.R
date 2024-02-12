#' Download geospatial dataset
#' @description
#' Download geospatial named dataset from server. This data is merged with a
#' simplified version of the National Census, associating the census with each
#' geospatial structure.
#'
#' @param dataset String indicating dataset code.
#'
#' @return data.frame downloaded data.
#' @examples
#' download_geospatial("DANE_MGNCNPV_2018_DPTO")
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
