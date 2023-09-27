#' Download dataset
#'
#' @param dataset dataset code
#'
#' @return dataframe downloaded
#'
#' @export
download <- function(dataset) {
  path <- retrieve_path(dataset)
  data_download <- retrieve_dataset(path)
  return(data_download)
}
