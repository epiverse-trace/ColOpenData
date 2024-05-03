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
  if(cache && file.exists(local_dataset_path)){
    loaded_data <- suppressWarnings(
      readr::read_delim(local_dataset_path,
                        delim = ";",
                        escape_double = FALSE,
                        trim_ws = TRUE,
                        show_col_types = FALSE
      )
    )
    demographic_data <- as.data.frame(loaded_data)
    } else{
    dataset_path <- retrieve_path(dataset)
    demographic_data <- retrieve_table(dataset_path)
    if(cache){
      write.csv2(demographic_data,
                 local_dataset_path,
                 row.names = FALSE,
                 fileEncoding = "UTF-8")
    }
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
