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
