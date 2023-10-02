#' Download dataset
#'
#' @param dataset dataset code
#'
#' @return dataframe downloaded
#' @examples
#' download("MGNCPV01")
#' 
#' @export
download <- function(dataset) {
  path <- retrieve_path(dataset)
  downloaded_data <- retrieve_dataset(path)
  return(downloaded_data)
}
