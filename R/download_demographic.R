#' Download demographic dataset
#'
#' @description
#' This function downloads demographic datasets from the National Population
#' and Dwelling Census (CNPV) of 2018.
#'
#' @param dataset character with the demographic dataset name. Please use
#' \code{list_datasets("demographic", "EN")} or
#' \code{list_datasets("demographic", "ES")} to check available datasets.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' house_under_15 <- download_demographic("DANE_CNPVH_2018_1HD")
#' head(house_under_15)
#'
#' @return \code{data.frame} object with downloaded data.
#'
#' @export
download_demographic <- function(dataset) {
  checkmate::assert_character(dataset)
  stopifnot(
    "`dataset` name format is not correct" =
      (startsWith(dataset, "DANE_CNPV"))
  )

  dataset_path <- retrieve_path(dataset)
  demographic_data <- retrieve_table(dataset_path)
  message(strwrap(
    prefix = "\n", initial = "",
    c(
      "ColOpenData provides open data derived from Departamento Administrativo
      Nacional de Estad\u00edstica (DANE), and Instituto de Hidrolog\u00eda,
      Meteorolog\u00eda y Estudios Ambientales (IDEAM) but with modifications
      for specific functional needs. These changes may alter the structure,
      format, or content, meaning the data does not reflect the official
      dataset. The package is developed independently, with no endorsement or
      involvement from these institutions or any Colombian government body. The
      authors of  ColOpenData are not liable for how users utilize the data,
      and users areresponsible for any outcomes from their use or analysis of
      the data.",
      "Stored by Universidad de Los Andes under the Epiverse TRACE iniative."
    )
  ))
  return(demographic_data)
}
