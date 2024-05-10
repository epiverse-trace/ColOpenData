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
  stopifnot(
    "`dataset` name format is not correct" =
      (startsWith(dataset, "DANE_CNPV") |
        startsWith(dataset, "DANE_PP"))
  )

  dataset_path <- retrieve_path(dataset)
  demographic_data <- retrieve_table(dataset_path)
  message(strwrap(
    prefix = "\n", initial = "",
    c(
      "Original data is retrieved from the National Administrative Department of
      Statistics (Departamento Administrativo Nacional de
      Estad\u00edstica - DANE).",
      "Reformatted by package authors.",
      "Stored by Universidad de Los Andes under the Epiverse TRACE iniative."
    )
  ))
  return(demographic_data)
}
