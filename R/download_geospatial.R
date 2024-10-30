#' Download geospatial dataset
#'
#' @description
#' This function downloads geospatial datasets from the National Geostatistical
#' Framework at different levels of spatial aggregation. These datasets
#' include a summarized version of the National Population and Dwelling Census
#' (CNPV) with demographic and socioeconomic information for each spatial unit.
#'
#' @param spatial_level character with the spatial level to be consulted:
#' \itemize{
#' \item \code{"DPTO"} or \code{"department"}: Department.
#' \item \code{"MPIO"} or \code{"municipality"}: Municipality.
#' \item \code{"MPIOCL"} or \code{"municipality_class"}: Municipality including
#' class.
#' \item \code{"SETU"} or \code{"urban_sector"}: Urban Sector.
#' \item \code{"SETR"} or \code{"rural_sector"}: Rural Sector.
#' \item \code{"SECU"} or \code{"urban_section"}: Urban Section.
#' \item \code{"SECR"} or \code{"rural_section"}: Rural Section.
#' \item \code{"ZU" } or \code{"urban_zone"}: Urban Zone.
#' \item \code{"MZN"} or \code{"block"}: Block.
#' }
#' @param simplified logical for indicating if the downloaded spatial data
#' should be a simplified version of the geometries. Simplified versions are
#' lighter but less precise, and are only recommended for easier applications
#' like plots. Default is \code{TRUE}.
#' @param include_geom logical for including (or not) the spatial geometry.
#' Default is \code{TRUE}. If \code{TRUE}, the function will return an
#' \code{"sf"} \code{data.frame}.
#' @param include_cnpv logical for including (or not) CNPV demographic and
#' socioeconomic information. Default is \code{TRUE}.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' \donttest{
#' departments <- download_geospatial("department")
#' head(departments)
#' }
#'
#' @return \code{data.frame} object with downloaded data.
#'
#' @export
download_geospatial <- function(spatial_level, simplified = TRUE,
                                include_geom = TRUE, include_cnpv = TRUE) {
  checkmate::assert_logical(simplified)
  checkmate::assert_logical(include_geom)
  checkmate::assert_logical(include_cnpv)
  stopifnot(
    "At least one of the groups (`geom` and/or `cnpv`)
            must be TRUE" = any(include_geom, include_cnpv)
  )

  dataset <- retrieve_geospatial_name(spatial_level)
  dataset_path <- retrieve_path(dataset)

  if (simplified) {
    dataset_path <- sub("\\.gpkg$", "_SIM.gpkg", dataset_path)
  }
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

#' Retrieve geospatial dataset name for consultation
#'
#' @description
#' Retrieve a geospatial dataset name from the spatial level. Checks the
#' existence of the spatial level and datasets.
#'
#' @param spatial_level character with the spatial level to be consulted.
#'
#' @return character containing the geospatial dataset name. If the input is
#' invalid an error will be thrown.
#'
#' @keywords internal
retrieve_geospatial_name <- function(spatial_level) {
  spatial_level <- tolower(spatial_level)
  checkmate::assert_choice(spatial_level, c(
    "dpto", "mpio", "setu", "setr", "secu", "secr", "mpiocl", "mzn", "zu",
    "department", "municipality", "municipality_class", "urban_sector",
    "rural_sector", "urban_section", "rural_section", "urban_zone", "block"
  ))
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
  all_datasets <- list_datasets("geospatial", "EN")
  geo_dataset <- all_datasets %>%
    dplyr::filter(.data[["level"]] == spatial_level)
  dataset_name <- geo_dataset[["name"]]
  return(dataset_name)
}
