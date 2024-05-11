#' Match and merge geospatial and demographic datasets
#'
#' @description
#' This function downloads a demographic and a geospatial dataset, does a
#' pivot to the demographic dataset based on a column of interest and merges
#' with a geospatial dataset (with \code{include_cnpv} as \code{FALSE}.
#' Since the smallest level of spatial aggregation present in the demographic
#' datasets is municipality, this functions can only match with the municipality
#' and department code of geospatial datasets.
#'
#' @param spatial_level character with the level of spatial aggregation to be used.
#' \code{"department"} or \code{"municipality"}
#' @param dem_dataset character with the demographic dataset name
#' @param column character with the column we are interested in. It depends on
#' the demographic dataset, so it is important to have checked it before
#'
#' @return \code{data.frame} object with the merged data
#'
#' @examples
#' merged <- merge_geo_dem(
#'   "department", "DANE_CNPVPD_2018_4PD",
#'   "relacion_o_parentesco_con_el_jefe_a_del_hogar"
#' )
#'
#' @export
merge_geo_dem <- function(spatial_level, dem_dataset, column) {
  datasets <- list_datasets("demographic")
  selected_dataset <- datasets[datasets$name == dem_dataset, ]
  level_selected <- selected_dataset$level
  if (spatial_level != level_selected) {
    stop("Spatial level provided does not match spatial level of the
         demographic dataset.
         Please select a new dataset or change the spatial level.")
  }
  dem <- download_demographic(dem_dataset)
  if (column %in% colnames(dem) == FALSE) {
    stop("Column of interest provided is not part of the demographic dataset.
         Plase select another column.")
  }
  total_col <- names(dem)[length(names(dem))]
  cols_exclude <- c(
    total_col, column, "codigo_departamento", "departamento",
    "codigo_municipio", "municipio", "indice_de_masculinidad",
    "indice_de_feminidad"
  )
  filtered_df <- dem %>%
    filter(rowSums(dplyr::across(-any_of(cols_exclude), ~ !grepl("total", .))) == 0)

  if (spatial_level == "department") {
    filtered_df <- filtered_df %>%
      filter(get("codigo_departamento") != "00") %>%
      select(c(codigo_departamento, column, total_col)) %>%
      pivot_wider(names_from = column, values_from = total_col)
    geo_dpto <- download_geospatial("DANE_MGN_2018_DPTO", include_cnpv = F)
    merged_df <- merge(geo_dpto, filtered_df,
      by.x = "DPTO_CCDGO",
      by.y = "codigo_departamento", all.x = TRUE
    ) %>%
      mutate(DPTO_CNMBR = stringr::str_to_title(DPTO_CNMBR))
  } else if (spatial_level == "municipality") {
    filtered_df <- filtered_df %>%
      filter(get("codigo_municipio") != "00000") %>%
      select(c(codigo_municipio, column, total_col)) %>%
      pivot_wider(names_from = column, values_from = total_col)

    geo_mpio <- download_geospatial("DANE_MGN_2018_MPIO", include_cnpv = F)
    merged_df <- merge(geo_mpio, filtered_df,
      by.x = "MPIO_CDPMP",
      by.y = "codigo_municipio", all.x = TRUE
    ) %>%
      mutate(MPIO_CNMBR = stringr::str_to_title(MPIO_CNMBR))
  } else {
    stop("Invalid spatial level parameter.
         Please provide 'department' or 'municipality'.")
  }
  names(merged_df) <- tolower(names(merged_df))
  return(merged_df)
}
