#' Retrieve DIVIPOLA table
#'
#' @description
#' Retrieve DIVIPOLA table including departments and municipalities. DIVIPOLA
#' codification includes individual codes for each department and municipality
#' following the political and administrative division.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' divipola <- divipola_table()
#'
#' @return \code{data.frame} object with DIVIPOLA table.
#'
#' @export
divipola_table <- function() {
  dataset_path <- retrieve_support_path("DIVIPOLA")
  divipola_table <- retrieve_table(dataset_path)
  return(divipola_table)
}

#' Retrieve departments' DIVIPOLA codes from names
#'
#' @description
#' Retrieve departments' DIVIPOLA codes from their names.
#'
#' @param department_name character vector with the names of the departments.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' dptos <- c("Tolima", "Huila", "Amazonas")
#' name_to_code_dep(dptos)
#'
#' @return character vector with the DIVIPOLA codes of the departments.
#'
#' @export
name_to_code_dep <- function(department_name) {
  checkmate::assert_character(department_name)

  divipola <- divipola_table()
  dptos <- divipola[
    !duplicated(divipola[["departamento"]]),
    c("codigo_departamento", "departamento")
  ]
  fixed_tokens <- iconv(
    tolower(dptos[["departamento"]]),
    from = "utf-8",
    to = "ASCII//TRANSLIT"
  )
  input_tokens <- iconv(
    tolower(department_name),
    from = "UTF-8",
    to = "ASCII//TRANSLIT"
  )
  codes_list <- dptos[["codigo_departamento"]]
  department_code <- rep_len(NA, length(department_name))
  for (i in seq_along(department_name)) {
    input_token <- input_tokens[i]
    dpto_code <- retrieve_code(input_token, fixed_tokens, codes_list)
    if (is.na(dpto_code)) {
      warning(department_name[i], " cannot be found as a department name")
    } else {
      department_code[i] <- dpto_code
    }
  }
  return(department_code)
}

#' Retrieve municipalities' DIVIPOLA codes from names
#'
#' @description
#' Retrieve municipalities' DIVIPOLA codes from their names. Since there are
#' municipalities with the same names in different departments, the input must
#' include two vectors: one for the departments and one for the municipalities
#' in said departments. If only one department is provided, it will try to
#' match all municipalities in the second vector inside that department.
#' Otherwise, the vectors must be the same length.
#'
#' @param department_name character vector with the names of the
#' departments containing the municipalities.
#' @param municipality_name character vector with the names of the
#' municipalities.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' dptos <- c("Huila", "Antioquia")
#' mpios <- c("Pitalito", "Turbo")
#' name_to_code_mun(dptos, mpios)
#'
#' @return character vector with the DIVIPOLA codes of the municipalities.
#'
#' @export
name_to_code_mun <- function(department_name, municipality_name) {
  checkmate::assert_character(department_name)
  checkmate::assert_character(municipality_name)

  # If there is only one department and more than one municipality as input, the
  # function will try to match all municipalities to the department
  if (length(department_name) == 1 && length(municipality_name) > 1) {
    department_name <- rep(department_name, length(municipality_name))
  }
  stopifnot("`department_name` and `municipality_name` must be the same
            length" = length(department_name) == length(municipality_name))

  divipola <- divipola_table()
  dptos <- name_to_code_dep(department_name)
  input_tokens <- iconv(
    tolower(municipality_name),
    from = "utf-8",
    to = "ASCII//TRANSLIT"
  )
  municipality_code <- rep_len(NA, length(department_name))
  for (i in seq_along(municipality_name)) {
    dpto_code <- dptos[i]
    if (is.na(dpto_code)) {
      next
    } else {
      filtered_mpios <- divipola[divipola[["codigo_departamento"]] ==
        dpto_code, ]
      fixed_tokens <- iconv(
        tolower(filtered_mpios[["municipio"]]),
        from = "utf-8",
        to = "ASCII//TRANSLIT"
      )
      input_token <- input_tokens[i]
      codes_list <- filtered_mpios[["codigo_municipio"]]
      mpio_code <- retrieve_code(input_token, fixed_tokens, codes_list)
      if (is.na(mpio_code)) {
        warning(
          municipality_name[i],
          " cannot be found as a municipality name in the department ",
          department_name[i]
        )
      } else {
        municipality_code[i] <- mpio_code
      }
    }
  }
  return(municipality_code)
}

#' Retrieve code
#'
#' @description
#' Retrieve code from list of codes, matching an input token against a list
#' of fixed tokens.
#'
#' @param input_token Input token to search in fixed tokens.
#' @param fixed_tokens Vector of tokens to match against.
#' @param codes_list Vector of target codes.
#'
#' @return character containing the matched code.
#'
#' @keywords internal
retrieve_code <- function(input_token, fixed_tokens, codes_list) {
  distances <- stringdist::afind(
    x = fixed_tokens,
    pattern = input_token,
    method = "cosine",
    window = max(8, nchar(input_token), na.rm = TRUE)
  )
  if (min(distances[["distance"]]) > 0.11) {
    code <- NA
  } else {
    min_distance_i <- which(distances[["distance"]] ==
      min(distances[["distance"]]))
    if (length(min_distance_i) == 1) {
      code <- codes_list[min_distance_i]
    } else {
      min_location <- distances[["location"]][min_distance_i]
      min_location_i <- min_distance_i[which.min(min_location)]
      code <- codes_list[min_location_i]
    }
  }
  return(code)
}

#' Retrieve departments' DIVIPOLA names from codes
#'
#' @description
#' Retrieve departments' DIVIPOLA official names from their DIVIPOLA codes.
#'
#' @param department_code character vector with the DIVIPOLA codes of the
#' departments.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' dptos <- c("73", "05", "11")
#' code_to_name_dep(dptos)
#'
#' @return character vector with the DIVIPOLA name of the departments.
#'
#' @export
code_to_name_dep <- function(department_code) {
  checkmate::assert_character(department_code, n.chars = 2)

  divipola <- divipola_table()
  dptos <- divipola[
    !duplicated(divipola[["departamento"]]),
    c("codigo_departamento", "departamento")
  ]
  inds <- match(department_code, dptos[["codigo_departamento"]])
  departments_names <- ifelse(is.na(inds), NA, dptos[["departamento"]][inds])
  if (anyNA(inds)) {
    warning(
      toString(department_code[is.na(inds)]),
      " cannot be found as department(s) code(s)"
    )
  }
  return(departments_names)
}

#' Retrieve municipalities' DIVIPOLA names from codes
#'
#' @description
#' Retrieve municipalities' DIVIPOLA official names from their DIVIPOLA codes.
#'
#' @param municipality_code character vector with the DIVIPOLA codes of the
#' municipalities.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' mpios <- c("73001", "11001", "05615")
#' code_to_name_mun(mpios)
#'
#' @return character vector with the DIVIPOLA name of the municipalities.
#'
#' @export
code_to_name_mun <- function(municipality_code) {
  checkmate::assert_character(municipality_code, n.chars = 5)

  mpios <- divipola_table()
  inds <- match(municipality_code, mpios[["codigo_municipio"]])
  if (anyNA(inds)) {
    warning(
      toString(municipality_code[is.na(inds)]),
      " cannot be found as municipality(ies) code(s)"
    )
  }
  municipalties_names <- ifelse(is.na(inds), NA, mpios[["municipio"]][inds])
  return(municipalties_names)
}

#' Translate department names to  official departments' DIVIPOLA names
#'
#' @description
#' Department names are usually manually input, which leads to multiple errors
#' and lack of standardization. This functions translates department names to
#' their respective official names from DIVIPOLA.
#'
#' @param department_name character vector with the names to be translated.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' dptos <- c("Bogota DC", "San Andres")
#' name_to_standard_dep(dptos)
#'
#' @return character vector with the DIVIPOLA name of the departments.
#'
#' @export
name_to_standard_dep <- function(department_name) {
  divipola_codes <- name_to_code_dep(department_name)
  divipola_names <- code_to_name_dep(divipola_codes)
  return(divipola_names)
}

#' Translate municipality names to  official municipalities' DIVIPOLA names
#'
#' @description
#' Municipality names are usually manually input, which leads to multiple errors
#' and lack of standardization. This functions translates municipality names to
#' their respective official names from DIVIPOLA.
#'
#' @param department_name character vector with the names of the
#' departments containing the municipalities.
#' @param municipality_name character vector with the names to be translated.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' dptos <- c("Bogota", "Tolima")
#' mpios <- c("Bogota DC", "CarmendeApicala")
#' name_to_standard_mun(dptos, mpios)
#'
#' @return character vector with the DIVIPOLA name of the municipalities.
#'
#' @export
name_to_standard_mun <- function(department_name, municipality_name) {
  divipola_codes <- name_to_code_mun(
    department_name,
    municipality_name
  )
  divipola_names <- code_to_name_mun(divipola_codes)
  return(divipola_names)
}
