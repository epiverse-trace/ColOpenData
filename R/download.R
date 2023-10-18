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
  return(downloaded_data)
}

#' Clean and pivot population projection data
#'
#' @description
#' This function provides the needed structure to pivot population projection
#' to longer format, making easier to access and subset.
#'
#' @param dataset data.frame of population projections to subset
#'
#' @return data.frame of pivoted and cleaned population projection data
#' @examples
#' \dontrun{
#' clean_dpd_pp(data)
#' }
#' @keywords internal
clean_dpd_pp <- function(dataset) {
  pp_prep <- stats::na.omit(dataset)
  max_col <- ncol(pp_prep)
  min_col <- 5
  if ("DPMP" %in% colnames(pp_prep)) {
    min_col <- 7
  }
  pp_prep <- janitor::clean_names(pp_prep)
  pp_prep_filtered <- pp_prep %>% tidyr::pivot_longer(
    cols = seq(min_col, max_col),
    names_to = "sexo_edad",
    values_to = "conteo"
  )
  pp_prep_filtered <- pp_prep_filtered %>% dplyr::mutate(
    sexo = unlist(stringr::str_split(.data$sexo_edad,
      stringr::fixed("_"),
      simplify = TRUE
    ))[, 1],
    edad = unlist(stringr::str_split(.data$sexo_edad,
      stringr::fixed("_"),
      simplify = TRUE
    ))[, 2]
  )
  if ("DPMP" %in% colnames(pp_prep_filtered)) {
    pp_out <- pp_prep_filtered %>% dplyr::select(janitor::make_clean_names(c(
      "DP", "DPNOM", "MPIO", "DPMP", "ANO",
      "AREA GEOGRAFICA", "SEXO", "EDAD",
      "CONTEO"
    )))
  } else {
    pp_out <- pp_prep_filtered %>% dplyr::select(janitor::make_clean_names(c(
      "DP", "DPNOM", "ANO", "AREA GEOGRAFICA",
      "SEXO", "EDAD", "CONTEO"
    )))
  }
  colnames(pp_out) <- toupper(colnames(pp_out))
  return(pp_out)
}
