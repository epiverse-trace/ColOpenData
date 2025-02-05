#' Match and merge geospatial and demographic datasets
#'
#' @description
#' This function adds the key information of a demographic dataset to a
#' geospatial dataset based on the spatial aggregation level. Since the smallest
#' level of spatial aggregation present in the demographic datasets is
#' municipality, this function can only merge with geospatial datasets that
#' present municipality or department level.
#'
#' @param demographic_dataset character with the demographic dataset name.
#' Please use \code{list_datasets("demographic", "EN")} or
#' \code{list_datasets("demographic", "ES")} to check available datasets.
#' @param simplified logical for indicating if the downloaded spatial data
#' should be a simplified version of the geometries. Simplified versions are
#' lighter but less precise, and are recommended for easier applications like
#' plots. Default is \code{TRUE}.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' \donttest{
#' merged <- merge_geo_demographic("DANE_CNPVV_2018_9VD", TRUE)
#' head(merged)
#' }
#'
#' @return \code{data.frame} object with the merged data.
#' @export
merge_geo_demographic <- function(demographic_dataset, simplified = TRUE) {
  checkmate::assert_character(demographic_dataset)

  datasets <- list_datasets("demographic", "EN")
  selected_dataset <- datasets[datasets[["name"]] == demographic_dataset, ]
  if (nrow(selected_dataset) == 0) {
    stop("`demographic_dataset` cannot be found")
  }
  spatial_level <- selected_dataset[["level"]][1]
  demographic <- download_demographic(demographic_dataset)
  total_col <- names(demographic)[length(names(demographic))]
  column <- names(demographic)[length(names(demographic)) - 1]
  cols_exclude <- c(
    total_col, column, "codigo_departamento", "departamento",
    "codigo_municipio", "municipio", "indice_de_masculinidad",
    "indice_de_feminidad"
  )
  filtered_df <- demographic %>%
    dplyr::filter(rowSums(dplyr::across(
      -dplyr::any_of(cols_exclude),
      ~ !grepl("total", ., fixed = TRUE)
    )) == 0)

  if (spatial_level == "department") {
    to_select <- c("codigo_departamento", column, total_col)
    filtered_df <- filtered_df %>%
      dplyr::filter(.data[["codigo_departamento"]] != "00") %>%
      dplyr::select(dplyr::all_of(to_select)) %>%
      tidyr::pivot_wider(
        names_from = dplyr::all_of(column),
        values_from = dplyr::all_of(total_col)
      )
    geospatial <- suppressMessages(download_geospatial("department",
      simplified = simplified,
      include_cnpv = FALSE
    ))
    merged_data <- merge(geospatial, filtered_df,
      by.x = "codigo_departamento",
      by.y = "codigo_departamento", all.x = TRUE
    )
  } else {
    to_select <- c("codigo_municipio", column, total_col)
    filtered_df <- filtered_df %>%
      dplyr::filter(.data[["codigo_municipio"]] != "00000") %>%
      dplyr::select(dplyr::all_of(to_select)) %>%
      tidyr::pivot_wider(
        names_from = dplyr::all_of(column),
        values_from = dplyr::all_of(total_col)
      )
    geospatial <- suppressMessages(download_geospatial("municipality",
      simplified = simplified,
      include_cnpv = FALSE
    ))
    merged_data <- merge(geospatial, filtered_df,
      by.x = "codigo_municipio",
      by.y = "codigo_municipio", all.x = TRUE
    )
  }
  if (colnames(merged_data)[ncol(merged_data)] == "geometry") {
    sf::st_geometry(merged_data) <- "geom"
  }
  return(merged_data)
}
