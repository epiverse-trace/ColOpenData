#' Download data dictionaries
#'
#' @description
#' Geospatial and climate datasets contain data dictionaries to understand
#' internal tags and named columns
#'
#' @param dataset character with the dataset name
#'
#' @return \code{data.frame} object with data dictionary
#'
#' @examples
#' dict <- dictionary("DANE_MGN_2018_SETU")
#'
#' @export
dictionary <- function(dataset) {
  checkmate::assert_character(dataset)

  datasets <- list_datasets()
  if (dataset %in% datasets$name) {
    tryCatch(
      {
        dict_path <- sprintf("DICT_%s", dataset)
        path <- retrieve_dict_path(dict_path)
        dict <- retrieve_table(path, ";")
      },
      error = function(e) {
        stop("This dataset does not have (or need) an associated dictionary")
      }
    )
  } else {
    stop("`dataset` not found")
  }
  return(dict)
}

#' Download list of available datasets
#'
#' @description
#' List all available datasets by name, including group, source, year, level,
#' category and description
#'
#' @param module character with module to be consulted (\code{"demographic"},
#' \code{"geospatial"}, \code{"climate"}). Default is \code{"all"}
#'
#' @return \code{data.frame} object with the available datasets
#'
#' @examples
#' list <- list_datasets("geospatial")
#'
#' @export
list_datasets <- function(module = "all") {
  checkmate::assert_character(module)
  checkmate::assert_choice(module, c(
    "all", "demographic", "geospatial",
    "climate", "population_projections"
  ))

  base_path <- retrieve_value_key("base_path")
  documentation_path <- retrieve_value_key("documentation")
  documentation <- file.path(base_path, documentation_path)
  listed <- retrieve_table(documentation)
  if (module != "all") {
    listed <- listed[listed$group == module, ]
  }
  return(listed)
}

#' Filter list of available datasets based on keywords given by the user
#'
#' @description
#' List available datasets containing user-specified keywords in their
#' descriptions
#'
#' @param module character with module to be consulted (\code{"demographic"},
#' \code{"geospatial"}, \code{"climate"}). Default is \code{"all"}
#' @param keywords character or vector of characters to be look up in the
#' description
#' @param logic A character string specifying the matching logic.
#' Can be either \code{"or"} or \code{"and"}. Default is \code{"or"}
#' \itemize{
#' \item \code{logic = "or"}: Matches rows containing at least one of the
#' specified keywords in their descriptions.
#' \item \code{logic = "and"}: Matches rows containing all of the specified
#' keywords in their descriptions.
#'  }
#'
#' @return \code{data.frame} object with the available datasets
#'
#' @examples
#' found <- look_up("demographic", c("sex", "age"), "and")
#'
#' @export
look_up <- function(module = "all", keywords, logic = "or") {
  checkmate::assert_character(module)
  checkmate::assert_character(keywords)
  checkmate::assert_character(logic)
  checkmate::assert_choice(
    module,
    c("all", "demographic", "geospatial", "climate")
  )

  listed <- list_datasets(module)
  if (logic == "or") {
    found <- listed[grep(paste(keywords, collapse = "|"),
      listed$description,
      ignore.case = TRUE
    ), ]
  } else if (logic == "and") {
    found <- listed[rowSums(sapply(keywords,
      grepl,
      listed$description,
      ignore.case = TRUE
    )) == length(keywords), ]
  } else {
    stop("Invalid logic parameter. Please provide 'or' or 'and'.")
  }
  if (nrow(found) == 0) {
    stop("Cannot find datasets with the consulted keywords")
  }
  return(found)
}
