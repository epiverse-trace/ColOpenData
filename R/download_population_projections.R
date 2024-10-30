#' Download population projections
#'
#' @description
#' This function downloads population projections and back projections taken
#' from the National Population and Dwelling Census of 2018 (CNPV), adjusted
#' after COVID-19. Available years are different for each spatial level:
#' \itemize{
#' \item \code{"national"}: 1950 - 2070.
#' \item \code{"national"} with sex: 1985 - 2050.
#' \item \code{"department"}: 1985 - 2050.
#' \item \code{"department"} with sex: 1985 - 2050.
#' \item \code{"municipality"}: 1985 - 2035.
#' \item \code{"municipality"} with sex: 1985 - 2035.
#' \item \code{"municipality"} with sex and ethnic groups: 2018 - 2035.
#' }
#' @param spatial_level character with the spatial level to be consulted.
#' Can be either \code{"national"}, \code{"department"} or
#' \code{"municipality"}.
#' @param start_year numeric with the start year to be consulted.
#' @param end_year numeric with the end year to be consulted.
#' @param include_sex logical for including (or not) division by sex. Default
#' is \code{FALSE}.
#' @param include_ethnic logical for including (or not) division by ethnic
#' group (only available for \code{"municipality"}). Default is \code{FALSE}.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' pop_proj <- download_pop_projections("national", 2020, 2030)
#' head(pop_proj)
#'
#' @return \code{data.frame} object with downloaded data.
#'
#' @export
download_pop_projections <- function(spatial_level, start_year, end_year,
                                     include_sex = FALSE,
                                     include_ethnic = FALSE) {
  checkmate::assert_choice(spatial_level, c(
    "national", "department",
    "municipality"
  ))
  checkmate::assert_numeric(start_year)
  checkmate::assert_numeric(end_year)
  checkmate::assert_logical(include_sex)
  checkmate::assert_logical(include_ethnic)
  if (include_ethnic && spatial_level != "municipality") {
    stop("Population projections including ethnic groups are only
            available at the level of municipality")
  }

  all_datasets <- list_datasets("population_projections", "EN")
  pp_datasets <- all_datasets %>%
    dplyr::filter(
      .data[["level"]] == spatial_level,
      grepl("sex", .data[["description"]], fixed = TRUE) == include_sex,
      grepl("ethnic", .data[["description"]], fixed = TRUE) == include_ethnic
    )
  pp_datasets <- pp_datasets %>%
    dplyr::select(dplyr::all_of(c("name", "year"))) %>%
    dplyr::group_by(.data[["year"]]) %>%
    dplyr::mutate(
      start = as.numeric(unlist(strsplit(.data[["year"]],
        "_",
        fixed = TRUE
      ))[1]),
      end = as.numeric(unlist(strsplit(.data[["year"]],
        "_",
        fixed = TRUE
      ))[2])
    ) %>%
    dplyr::ungroup()
  stopifnot(
    "Start date is lower than the minimum available" =
      start_year >= min(pp_datasets[["start"]]),
    "End date is higher than the maximum available" =
      end_year <= max(pp_datasets[["end"]])
  )
  pp_years <- pp_datasets %>%
    dplyr::rowwise() %>%
    dplyr::mutate(year = list(seq(.data[["start"]], .data[["end"]]))) %>%
    tidyr::unnest(cols = c(.data[["year"]])) %>%
    dplyr::select(-dplyr::all_of(c("start", "end")))
  included_years <- seq(start_year, end_year)
  needed_datasets <- unique(pp_years[pp_years[["year"]] %in%
    included_years, "name"])
  population_projections <- list()
  for (dataset in needed_datasets) {
    dataset_path <- retrieve_path(dataset)
    pp_data <- retrieve_table(dataset_path)
    pp_data_filtered <- pp_data %>%
      dplyr::filter(.data[["ano"]] %in%
        included_years)
    population_projections <- rbind(
      population_projections,
      list(pp_data_filtered)
    )
  }
  population_projections <- dplyr::bind_rows(population_projections)
  message(strwrap(
    prefix = "\n", initial = "",
    c(
      "Original data is retrieved from the National Administrative Department of
      Statistics (Departamento Administrativo Nacional de
      Estad\u00edstica - DANE).",
      "Reformatted by package authors.",
      "Stored by Universidad de Los Andes under the Epiverse TRACE iniative."
    )
  ))
  return(population_projections)
}
