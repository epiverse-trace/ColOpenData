#' Download dataset
#'
#' @param dataset dataset code
#'
#' @return dataframe downloaded
#' @examples
#' download("MGNCNPV_DPTO_2018")
#'
#' @export
download <- function(dataset) {
  path <- retrieve_path(dataset)
  downloaded_data <- retrieve_dataset(path)
  if (grep("DPDPP", dataset)) {
    downloaded_data <- clean_ddp_pp(downloaded_data)
  }
  return(downloaded_data)
}

#' Clean and pivot population projection data
#'
#' @description
#' This function provides the needed structure to pivot population projection
#' from the original format, making easier to access and subset.
#'
#' @param dataset data.frame of population projections to subset
#'
#' @return data.frame of pivoted and cleaned population projection data
#' @examples
#' \dontrun{
#' clean_dpd_pp
#' }
#' @keywords internal
clean_ddp_pp <- function(dataset) {
  pp_prep <- na.omit(dataset)
  max_col <- ncol(pp_prep)
  min_col <- 5
  if ("DPMP" %in% colnames(pp_prep)) {
    min_col <- 7
  }

  pp_prep_filtered <- pp_prep %>% tidyr::pivot_longer(
    cols = seq(min_col, max_col),
    names_to = "SEXO_EDAD",
    values_to = "CONTEO"
  )
  pp_prep_filtered <- pp_prep_filtered %>% dplyr::mutate(
    SEXO = unlist(stringr::str_split(SEXO_EDAD, "_", simplify = T))[, 1],
    EDAD = unlist(stringr::str_split(SEXO_EDAD, "_", simplify = T))[, 2]
  )
  if ("DPMP" %in% colnames(pp_g_f)) {
    pp_out <- pp_prep_filtered %>% dplyr::select(c(
      "DP", "DPNOM", "MPIO", "DPMP", "AÑO",
      "ÁREA GEOGRÁFICA", "SEXO", "EDAD",
      "CONTEO"
    ))
  } else {
    pp_out <- pp_prep_filtered %>% dplyr::select(c(
      "DP", "DPNOM", "AÑO", "ÁREA GEOGRÁFICA",
      "SEXO", "EDAD", "CONTEO"
    ))
  }
  return(pp_out)
}
