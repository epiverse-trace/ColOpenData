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
  dataset_path <- retrieve_path(dataset)
  tryCatch(
    {
      demographic_data <- retrieve_table(dataset_path,
        sep = ";"
      )
    },
    error = function(e) {
      stop("`dataset` not found")
    }
  )
  return(demographic_data)
}
