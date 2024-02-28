#' Download geospatial dataset
#'
#' @description
#' This function downloads geospatial datasets from the Geostatistical National
#' Framework (MGN) at different levels of aggregation. These datasets include a
#' summarized version of the National Population and Dwelling Census (CNPV)
#'
#' @param dataset character with the dataset name
#' @param geospatial boolean for presenting or not geospatial related columns
#' @param demographic boolean for presenting or not demographic related columns
#'
#' @examples
#' dptos <- download_geospatial("DANE_MGN_2018_DPTO", T, F)
#' print(dptos)
#'
#' @return \code{sf} \code{data.frame} object with structures' details
#'
#' @export
download_geospatial <- function(dataset, geospatial = T, demographic = T) {
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
  final_data <- filter_dataset(geospatial_data, geospatial, demographic)
  return(final_data)
}

filter_dataset <- function(data, geospatial = T, demographic = T) {
  geospatial_vars <- c("AREA", "LATITUD", "LONGITUD", "Shape_Leng", "Shape_Area")
  final_vars <- c("Shape_Leng", "Shape_Area")

  if (geospatial == T & demographic == F) {
    # Find the index of the specific column
    specific_column_index <- which(colnames(data) == "LONGITUD")

    # Select all columns before the specific column
    first_cols <- data[, 1:specific_column_index] %>%
      sf::st_drop_geometry()

    # Concatenate with the specific columns at the end
    final_data <- cbind(first_cols, data[, final_vars])
  } else if (geospatial == F & demographic == T) {
    final_data <- data[, -which(names(data) %in% geospatial_vars)] %>%
      sf::st_drop_geometry()
  } else if (geospatial == T & demographic == T) {
    final_data <- data
  }
  return(final_data)
}
