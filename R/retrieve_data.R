# Established path will change when the repository is moved to the final server
#' Retrieve path of named dataset
#'
#' @param dataset_name name of the consulted dataset
#'
#' @return path to retrieve the dataset from server
#'
#' @keywords internal
retrieve_path <- function(dataset_name) {
  # include all paths and datasets
  datasets <- c("MGNCNPV01", "MGNCNPV02")
  paths <- c(
    gsub("[\n ]", "", "https://github.com/biomac-lab/data_ColOpenData/blob/main/
      MGN/MGN_CNPV_2018/MGN_NivelDepartamentoIntegrado_CNPV/
      MGN_AMN_DPTOS.RDS?raw=true"),
    gsub("[\n ]", "", "https://github.com/biomac-lab/data_ColOpenData/blob/main/
      MGN/MGN_CNPV_2018/MGN_NivelMunicipioIntegrado_CNPV/
      MGN_AMN_MPIOS.RDS?raw=true")
  )
  file_path <- paths[which(datasets == dataset_name)]
  if (rlang::is_empty(file_path)) {
    stop("`dataset_name` is not available")
  }
  return(file_path)
}

#' Retrieve dataset from path
#'
#' @param dataset_path path to the dataset on repository
#'
#' @return consulted dataset
#'
#' @keywords internal
retrieve_dataset <- function(dataset_path) {
  dataset <- readr::read_rds(dataset_path)
  return(dataset)
}

#' Change coordinate system to Magna Sirgas
#'
#' @param .data sf object containing coordinates and established geometry
#'
#' @return sf dataframe with Colombian coordinate reference system
#'
#' @keywords internal
set_magna_sirgas <- function(.data) {
  checkmate::assert_class(.data, c("sf", "data.frame"))
  transformed <- sf::st_transform(.data, 4686)
  return(transformed)
}
