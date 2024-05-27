#' Match and merge geospatial and demographic datasets
#'
#' @description
#' This function downloads a demographic and a geospatial dataset, does a
#' pivot to the demographic dataset based on a column of interest and merges
#' with a geospatial dataset according to the level of the demographic dataset.
#' Since the smallest level of spatial aggregation present in the demographic
#' datasets is municipality, this functions can only match with the municipality
#' and department code of geospatial datasets.
#'
#' @param demographic_dataset character with the demographic dataset name.
#' Please use \code{list_datasets("demographic")} to check available datasets
#' @param column character with the column we are interested in. It depends on
#' the demographic dataset, so it is important to have checked the dataset
#' beforehand
#'
#' @return \code{data.frame} object with the merged data
#'
#' @examples
#' census_file <- "DANE_CNPVV_2018_9VD"
#' merged <- merge_geo_demographic(census_file, "tipo_de_servicio_sanitario")
#'
#' @export
merge_geo_demographic <- function(demographic_dataset, column) {
  checkmate::assert_character(demographic_dataset)
  checkmate::assert_character(column)

  datasets <- list_datasets("demographic")
  selected_dataset <- datasets[datasets$name == demographic_dataset, ]
  if (nrow(selected_dataset) == 0) {
    stop("`demographic_dataset` cannot be found")
  }
  spatial_level <- selected_dataset$level[1]
  cen <- download_demographic(demographic_dataset)
  if (!column %in% colnames(cen)) {
    stop("Column of interest provided is not part of the demographic dataset.
         Plase select another column.")
  }
  total_col <- names(cen)[length(names(cen))]
  cols_exclude <- c(
    total_col, column, "codigo_departamento", "departamento",
    "codigo_municipio", "municipio", "indice_de_masculinidad",
    "indice_de_feminidad"
  )
  filtered_df <- cen %>%
    dplyr::filter(rowSums(dplyr::across(
      -dplyr::any_of(cols_exclude),
      ~ !grepl("total", ., fixed = TRUE)
    )) == 0)

  if (spatial_level == "department") {
    to_select <- c("codigo_departamento", column, total_col)
    filtered_df <- filtered_df %>%
      dplyr::filter(.data$codigo_departamento != "00") %>%
      dplyr::select(dplyr::all_of(to_select)) %>%
      tidyr::pivot_wider(
        names_from = dplyr::all_of(column),
        values_from = dplyr::all_of(total_col)
      )
    geo_dpto <- suppressMessages(download_geospatial("department",
      include_cnpv = FALSE
    ))
    merged_data <- merge(geo_dpto, filtered_df,
      by.x = "codigo_departamento",
      by.y = "codigo_departamento", all.x = TRUE
    )
  } else {
    to_select <- c("codigo_municipio", column, total_col)
    filtered_df <- filtered_df %>%
      dplyr::filter(.data$codigo_municipio != "00000") %>%
      dplyr::select(dplyr::all_of(to_select)) %>%
      tidyr::pivot_wider(
        names_from = dplyr::all_of(column),
        values_from = dplyr::all_of(total_col)
      )
    geo_mpio <- suppressMessages(download_geospatial("municipality",
      include_cnpv = FALSE
    ))
    merged_data <- merge(geo_mpio, filtered_df,
      by.x = "codigo_municipio",
      by.y = "codigo_municipio", all.x = TRUE
    )
  }
  return(merged_data)
}
