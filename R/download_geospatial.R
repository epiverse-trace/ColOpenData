#' Download geospatial dataset
#'
#' @description
#' This function downloads geospatial datasets from the Geostatistical National
#' Framework at different levels of spatial aggregation. These datasets
#' include a summarized version of the National Population and Dwelling Census
#' (CNPV) with demographic and socioeconomic information for each spatial unit.
#'
#' @param spatial_level character with the spatial level to be consulted
#' \itemize{
#' \item \code{"DPTO"} or \code{"department"}: Department
#' \item \code{"MPIO"} or \code{"municipality"}: Municipality
#' \item \code{"MPIOCL"} or \code{"municipality_class"}: Municipality including
#' class
#' \item \code{"SETU"} or \code{"urban_sector"}: Urban Sector
#' \item \code{"SETR"} or \code{"rural_sector"}: Rural Sector
#' \item \code{"SECU"} or \code{"urban_section"}: Urban Section
#' \item \code{"SECR"} or \code{"rural_section"}: Rural Section
#' \item \code{"ZU" } or \code{"urban_zone"}: Urban Zone
#' \item \code{"MZN"} or \code{"block"}: Block
#' }
#' @param include_geom logical for including (or not) the geometry.
#' Default is \code{TRUE}
#' @param include_cnpv logical for including (or not) CNPV demographic and
#' socioeconomic information. Default is \code{TRUE}
#'
#' @examples
#' departments <- download_geospatial("department", TRUE, FALSE)
#' head(departments)
#'
#' @return \code{data.frame} object with downloaded data
#'
#' @export
download_geospatial <- function(spatial_level, include_geom = TRUE,
                                include_cnpv = TRUE) {
  checkmate::assert_logical(include_geom)
  checkmate::assert_logical(include_cnpv)
  spatial_level <- tolower(spatial_level)
  checkmate::assert_choice(tolower(spatial_level), c(
    "dpto", "mpio", "setu", "setr", "secu", "secr", "mpiocl", "mzn", "zu",
    "department", "municipality", "municipality_class", "urban_sector",
    "rural_sector", "urban_section", "rural_section", "urban_zone", "block"
  ))
  stopifnot(
    "At least one of the groups (`geom` and/or `cnpv`)
            must be TRUE" = any(include_geom, include_cnpv)
  )
  if (spatial_level %in% c(
    "dpto", "mpio", "setu", "setr", "secu", "secr", "mpiocl", "mzn", "zu"
  )) {
    levels_trans <- list(
      dpto = "department",
      mpio = "municipality",
      mpiocl = "municipality_class",
      setu = "urban_sector",
      setr = "rural_sector",
      secu = "urban_section",
      secr = "rural_section",
      zu = "urban_zone",
      mzn = "block"
    )
    spatial_level <- levels_trans[[spatial_level]]
  }

  all_datasets <- list_datasets("geospatial")
  geo_dataset <- all_datasets %>%
    dplyr::filter(.data$level == spatial_level)
  dataset <- geo_dataset$name
  dataset_path <- retrieve_path(dataset)
  geospatial_data <- sf::st_read(dataset_path, quiet = TRUE)
  geospatial_vars <- c("area", "latitud", "longitud")
  shape_vars <- c("shape_length", "shape_area")
  if (include_geom && !include_cnpv) {
    last_base_index <- which(colnames(geospatial_data) == "longitud")
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
