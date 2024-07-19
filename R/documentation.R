#' Download data dictionaries
#'
#' @description
#' Retrieve geospatial data dictionaries to understand internal tags and named
#' columns. Dictionaries are available in English and Spanish.
#' 
#' 
#' @param language language of the dictionary variables (\code{"EN"},
#' \code{"ES"}. Default is \code{"ES"}.
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
#'
#' @examples
#' dict <- geospatial_dictionary("EN", "setu")
#' head(dict)
#'
#' @return \code{data.frame} object with geospatial data dictionary.
#'
#' @export
geospatial_dictionary <- function(language = "ES", spatial_level) {
  dataset <- retrieve_geospatial_name(spatial_level)
  file <- sprintf("DICT_%s", dataset)
  path <- retrieve_dict_path("geospatial_dictionaries.rda")
  load(path)
  obj_name <- ls()
  to_remove <- c("path", "dataset", "file", "spatial_level", "language")
  final_name <- setdiff(obj_name, to_remove)
  object <- get(final_name)
  specific <- object[[language]][[file]]
  return(specific)
}

#' List climate (IDEAM) tags
#'
#' @description
#' Retrieve available climate tags to be consulted. The list is only available
#' in Spanish.
#'
#' @examples
#' dict <- get_climate_tags()
#' head(dict)
#'
#' @return \code{data.frame} object with available tags.
#'
#' @export
get_climate_tags <- function() {
  path <- retrieve_dict_path("climate_tags.rda")
  load(path)
  obj_name <- ls()[ls() != "path"]
  return(get(obj_name))
}

#' Download list of available datasets
#'
#' @description
#' List all available datasets by name, including group, source, year, level,
#' category and description.
#'
#' @param language language of all variables (\code{"EN"}, \code{"ES"}.
#' Default is \code{"ES"}.
#' @param module character with module to be consulted (\code{"demographic"},
#' \code{"geospatial"}, \code{"climate"}). Default is \code{"all"}.
#'
#' @examples
#' list <- list_datasets("EN", "geospatial")
#' head(list)
#'
#' @return \code{data.frame} object with the available datasets.
#'
#' @export
list_datasets <- function(language = "ES", module = "all") {
  checkmate::assert_character(module)
  checkmate::assert_character(language)
  checkmate::assert_choice(module, c(
    "all", "demographic", "geospatial",
    "climate", "population_projections"
  ))
  checkmate::assert_choice(language, c(
    "ES", "EN"
  ))
  path <- retrieve_dict_path("datasets_list.rda")
  load(path)
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
  } else {
    stop("Invalid language parameter. Please provide 'ES' or 'EN'.")
  }
  return(file)
}

#' Filter list of available datasets based on keywords given by the user
#'
#' @description
#' List available datasets containing user-specified keywords in their
#' descriptions.
#'
#' @param module character with module to be consulted (\code{"demographic"},
#' \code{"geospatial"}, \code{"climate"}). Default is \code{"all"}.
#' @param language language of the keywords (\code{"EN"}, \code{"ES"}. 
#' Default is \code{"EN"}.
#' @param keywords character or vector of characters to be look up in the
#' description.
#' @param logic A character string specifying the matching logic.
#' Can be either \code{"or"} or \code{"and"}. Default is \code{"or"}:
#' \itemize{
#' \item \code{logic = "or"}: Matches rows containing at least one of the
#' specified keywords in their descriptions.
#' \item \code{logic = "and"}: Matches rows containing all of the specified
#' keywords in their descriptions.
#'  }
#'
#' @examples
#' found <- look_up("demographic", "EN", c("sex", "age"), "and")
#' head(found)
#'
#' @return \code{data.frame} object with the available datasets.
#'
#' @export
look_up <- function(module = "all", language = "EN", keywords, logic = "or") {
  checkmate::assert_character(module)
  checkmate::assert_character(keywords)
  checkmate::assert_character(logic)
  checkmate::assert_choice(
    module,
    c("all", "demographic", "geospatial", "climate")
  )
  listed <- list_datasets(language, module)
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
    } else {
      stop("Invalid logic parameter. Please provide 'or' or 'and'.")
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
    } else {
      stop("Invalid logic parameter. Please provide 'or' or 'and'.")
    }
  } else {
    stop("Invalid language parameter. Please provide 'ES' or 'EN'.")
  }

  if (nrow(found) == 0) {
    stop("Cannot find datasets with the consulted keywords")
  }

  return(found)
}
