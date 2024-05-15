#' Download geospatial dataset
#'
#' @description
#' This function downloads geospatial datasets from the Geostatistical National
#' Framework (MGN) at different levels of spatial aggregation. These datasets
#' include a summarized version of the National Population and Dwelling Census
#' (CNPV) with demographic and socioeconomic information.
#'
#' @param dataset character with the geospatial dataset name
#' @param include_geom logical for including (or not) the geometry.
#' Default is \code{TRUE}
#' @param include_cnpv logical for including (or not) CNPV demographic and
#' socioeconomic information. Default is \code{TRUE}
#'
#' @examples
#' departments <- download_geospatial("DANE_MGN_2018_DPTO", TRUE, FALSE)
#'
#' @return \code{data.frame} object with downloaded data
#'
#' @export
download_geospatial <- function(dataset, include_geom = TRUE,
                                include_cnpv = TRUE) {
  checkmate::assert_character(dataset)
  checkmate::assert_logical(include_geom)
  checkmate::assert_logical(include_cnpv)
  stopifnot(
    "At least one of the groups (`geospatial` and/or `demographic`)
            must be TRUE" = any(include_geom, include_cnpv),
    "`dataset` name format is not correct" = startsWith(dataset, "DANE_MGN")
  )

  dataset_path <- retrieve_path(dataset)
  geospatial_data <- sf::st_read(dataset_path, quiet = TRUE)
  geospatial_vars <- c("AREA", "LATITUD", "LONGITUD") # geom included by default
  shape_vars <- c("Shape_Leng", "Shape_Area")
  if (include_geom && !include_cnpv) {
    last_base_index <- which(colnames(geospatial_data) == "LONGITUD")
    geospatial_data <- geospatial_data %>%
      dplyr::select(dplyr::all_of(1:last_base_index))
  } else if (!include_geom && include_cnpv) {
    geospatial_data <- geospatial_data %>%
      dplyr::select(-dplyr::all_of(c(geospatial_vars, shape_vars))) %>%
      sf::st_drop_geometry()
  }
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
  return(geospatial_data)
}
