#' Download demographic dataset
#'
#' @description
#' This function downloads demographic datasets from the National Population
#' and Dwelling Census (CNPV) and Population Projections
#'
#' @param dataset character with the demographic dataset name
#' @param cache logical for local storage. If \code{FALSE}, data is not locally
#' stored, only loaded to the environment in the current session. If 
#' \code{TRUE}, data is downloaded to local folder; if the data was downloaded
#' before, it is loaded from local folder
#'
#' @examples
#' house_under_15 <- download_demographic("DANE_CNPVH_2018_1HD")
#'
#' @return \code{data.frame} object with downloaded data
#' @export
download_demographic <- function(dataset, cache = TRUE) {
  checkmate::assert_character(dataset)
  checkmate::assert_logical(cache)
  stopifnot(
    "`dataset` name format is not correct" =
      (startsWith(dataset, "DANE_CNPV") |
         startsWith(dataset, "DANE_PP"))
  )
  
  local_dataset_path <- retrieve_local_path(dataset)
  dataset_path <- retrieve_path(dataset)
  if(cache && file.exists(local_dataset_path)){
    demographic_data <- retrieve_local_table(local_dataset_path)
  } 
  else if(cache && !file.exists(local_dataset_path)){
    download_file(dataset_path, local_dataset_path)
    demographic_data <- retrieve_local_table(local_dataset_path)
  } 
  else{
    demographic_data <- retrieve_table(dataset_path)
  }
  message(strwrap(
    prefix = "\n", initial = "",
    c(
      "Original data is provided by the National Administrative Department of
    Statistics (DANE).",
      "Reformatted by the package authors.",
      "Stored and redistributed by Universidad de Los Andes under the Epiverse
    TRACE iniative."
    )
  ))
  return(demographic_data)
}
