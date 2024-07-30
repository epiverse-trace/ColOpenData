#' Download data dictionaries
#'
#' @description
#' Retrieve geospatial data dictionaries to understand internal tags and named
#' columns. Dictionaries are available in English and Spanish.
#'
#'
#' @param spatial_level character with the spatial level to be consulted:
#' \itemize{
#' \item \code{"DPTO"} or \code{"department"}: Department.
#' \item \code{"MPIO"} or \code{"municipality"}: Municipality.
#' \item \code{"MPIOCL"} or \code{"municipality_class"}: Municipality including
#' class.
#' \item \code{"SETU"} or \code{"urban_sector"}: Urban Sector.
#' \item \code{"SETR"} or \code{"rural_sector"}: Rural Sector.
#' \item \code{"SECU"} or \code{"urban_section"}: Urban Section.
#' \item \code{"SECR"} or \code{"rural_section"}: Rural Section.
#' \item \code{"ZU" } or \code{"urban_zone"}: Urban Zone.
#' \item \code{"MZN"} or \code{"block"}: Block.
#' }
#' @param language language of the dictionary variables (\code{"EN"},
#' \code{"ES"}. Default is \code{"ES"}.
#'
#' @examples
#' dict <- geospatial_dictionary("setu", "EN")
#' head(dict)
#'
#' @return \code{data.frame} object with geospatial data dictionary.
#'
#' @export
geospatial_dictionary <- function(spatial_level, language = "ES") {
  checkmate::assert_character(spatial_level)
  checkmate::assert_character(language)
  checkmate::assert_choice(language, c(
    "ES", "EN"
  ))
  dataset <- retrieve_geospatial_name(spatial_level)
  dict_level <- sprintf("DICT_%s", dataset)
  path <- retrieve_dict_path("geospatial_dictionaries.rda")
  load(path)
  geospatial_dictionaries <- get("geospatial_dictionaries")
  geo_dictionary <- geospatial_dictionaries[[language]][[dict_level]]
  return(geo_dictionary)
}

#' List climate (IDEAM) tags
#'
#' @description
#' Retrieve available climate tags to be consulted. The list is only available
#' in Spanish.
#'
#' @param language language of the tags (\code{"EN"}, \code{"ES"}. Default is
#' \code{"ES"}.
#'
#' @examples
#' dict <- get_climate_tags(language = "ES")
#' head(dict)
#'
#' @return \code{data.frame} object with available tags.
#'
#' @export
get_climate_tags <- function(language = "ES") {
  checkmate::assert_character(language)
  checkmate::assert_choice(language, c("ES", "EN"))
  path <- retrieve_dict_path("climate_tags.rda")
  load(path)
  climate_tags <- get("climate_tags")
  tags <- climate_tags[[language]]
  return(tags)
}

#' Download list of available datasets
#'
#' @description
#' List all available datasets by name, including group, source, year, level,
#' category and description.
#'
#' @param module character with module to be consulted (\code{"demographic"},
#' \code{"geospatial"}, \code{"climate"}). Default is \code{"all"}.
#' @param language language of all variables (\code{"EN"}, \code{"ES"}.
#' Default is \code{"ES"}.
#'
#' @examples
#' list <- list_datasets("geospatial", "EN")
#' head(list)
#'
#' @return \code{data.frame} object with the available datasets.
#'
#' @export
list_datasets <- function(module = "all", language = "ES") {
  checkmate::assert_character(module)
  checkmate::assert_character(language)
  checkmate::assert_choice(module, c(
    "all", "demographic", "geospatial",
    "climate", "population_projections"
  ))
  checkmate::assert_choice(language, c("ES", "EN"))
  path <- retrieve_dict_path("datasets_list.rda")
  load(path)
  datasets_list <- get("datasets_list")
  all_objects <- ls()
  obj_name <- setdiff(
    all_objects,
    c("path", "module", "language")
  )
  object <- get(obj_name)

  if (language == "ES") {
    modules_trans <- list(
      all = "todos",
      demographic = "demografico",
      geospatial = "geoespacial",
      climate = "clima",
      population_projections = "proyecciones_poblacionales"
    )
    module <- modules_trans[[module]]
    file <- object$ES
    if (module != "todos") {
      file <- file[file[["grupo"]] == module, ]
    }
  } else if (language == "EN") {
    file <- object$EN
    if (module != "all") {
      file <- file[file[["group"]] == module, ]
    }
  }
  return(file)
}

#' Filter list of available datasets based on keywords given by the user
#'
#' @description
#' List available datasets containing user-specified keywords in their
#' descriptions.
#'
#' @param keywords character or vector of characters to be look up in the
#' description.
#' @param module character with module to be consulted (\code{"demographic"},
#' \code{"geospatial"}, \code{"climate"}). Default is \code{"all"}.
#' @param logic A character string specifying the matching logic.
#' Can be either \code{"or"} or \code{"and"}. Default is \code{"or"}:
#' \itemize{
#' \item \code{logic = "or"}: Matches rows containing at least one of the
#' specified keywords in their descriptions.
#' \item \code{logic = "and"}: Matches rows containing all of the specified
#' keywords in their descriptions.
#'  }
#' @param language language of the keywords (\code{"EN"}, \code{"ES"}.
#' Default is \code{"EN"}.
#'
#' @examples
#' found <- look_up("demographic", "EN", c("sex", "age"), "and")
#' head(found)
#'
#' @return \code{data.frame} object with the available datasets.
#'
#' @export
look_up <- function(keywords, module = "all", logic = "or", language = "EN") {
  checkmate::assert_character(keywords)
  checkmate::assert_character(module)
  checkmate::assert_character(logic)
  checkmate::assert_character(language)
  checkmate::assert_choice(
    module,
    c("all", "demographic", "geospatial", "climate")
  )
  checkmate::assert_choice(logic, c("or", "and"))
  checkmate::assert_choice(language, c("ES", "EN"))
  listed <- list_datasets(module, language)
  if (language == "ES") {
    if (logic == "or") {
      found <- listed[grep(paste(keywords, collapse = "|"),
        listed[["descripcion"]],
        ignore.case = TRUE
      ), ]
    } else if (logic == "and") {
      found <- listed[rowSums(sapply(keywords,
        grepl,
        listed[["descripcion"]],
        ignore.case = TRUE
      )) == length(keywords), ]
    }
  } else if (language == "EN") {
    if (logic == "or") {
      found <- listed[grep(paste(keywords, collapse = "|"),
        listed[["description"]],
        ignore.case = TRUE
      ), ]
    } else if (logic == "and") {
      found <- listed[rowSums(sapply(keywords,
        grepl,
        listed[["description"]],
        ignore.case = TRUE
      )) == length(keywords), ]
    }
  }
  if (nrow(found) == 0) {
    stop("Cannot find datasets with the consulted keywords")
  }
  return(found)
}
