#' Retrieve DIVIPOLA table
#'
#' @description
#' Retrieve DIVIPOLA table including departments and municipalities
#'
#' @examples
#' divipola <- divipola_table()
#'
#' @return \code{data.frame} object with DIVIPOLA table
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
#' Retrieve departments' DIVIPOLA codes from their names
#'
#' @param department_name character vector with the names of the departments
#'
#' @examples
#' dptos <- c("TOLIMA", "HUILA", "AMAZONAS")
#' codes <- divipola_department_code(dptos)
#'
#' @return character vector with the DIVIPOLA codes of the departments
#'
#' @export
divipola_department_code <- function(department_name) {
  checkmate::assert_character(department_name)

  divipola <- divipola_table()
  dpts <- divipola[
    !duplicated(divipola$nombre_departamento),
    c("codigo_departamento", "nombre_departamento")
  ]
  fixed_tokens <- iconv(
    dpts$nombre_departamento,
    from = "utf-8",
    to = "ASCII//TRANSLIT"
  )
  departments_codes <- NULL
  for (dpt in department_name) {
    input_token <- iconv(toupper(dpt),
      from = "UTF-8",
      to = "ASCII//TRANSLIT"
    )
    distances <- as.data.frame(stringdist::afind(
      x = fixed_tokens,
      pattern = input_token,
      method = "cosine",
      window = max(8, nchar(input_token), na.rm = TRUE)
    ))
    min_distance_i <- which(distances$distance == min(distances$distance))
    if (length(min_distance_i) == 1) {
      dpt_code <- dpts$codigo_departamento[min_distance_i]
    } else {
      min_location <- distances$location[min_distance_i]
      min_location_i <- min_distance_i[which.min(min_location)]
      dpt_code <- dpts$codigo_departamento[min_location_i]
    }
    if (min(distances$distance) > 0.11) {
      warning(dpt, " cannot be found as a department name")
      departments_codes <- c(departments_codes, NA)
    } else {
      departments_codes <- c(departments_codes, dpt_code)
    }
  }
  return(departments_codes)
}

#' Retrieve municipalities' DIVIPOLA codes from names
#'
#' @description
#' Retrieve municipalities' DIVIPOLA codes from their names. Since there are
#' municipalities with the same names in different departments, the input must
#' include a two vectors of the same length: one for the departments and one for
#' the municipalities
#'
#' @param department_name character vector with the names of the
#' departments containing the municipalities
#' @param municipality_name character vector with the names of the
#' municipalities
#'
#' @examples
#' dptos <- c("HUILA", "ANTIOQUIA")
#' mpios <- c("PITALITO", "TURBO")
#' codes <- divipola_municipality_code(dptos, mpios)
#'
#' @return character vector with the DIVIPOLA codes of the municipalities
#'
#' @export
divipola_municipality_code <- function(department_name, municipality_name) {
  checkmate::assert_character(department_name)
  checkmate::assert_character(municipality_name)
  stopifnot("`department_name` and `municipality_name` must be the same
            length" = length(department_name) == length(municipality_name))

  divipola <- divipola_table()
  dpts <- suppressWarnings(divipola_department_code(department_name))
  municipalities_codes <- NULL
  for (i in seq_along(municipality_name)) {
    input_token <- iconv(
      toupper(municipality_name[i]),
      from = "utf-8",
      to = "ASCII//TRANSLIT"
    )
    dpt_code <- dpts[i]
    if (is.na(dpt_code)) {
      warning(department_name[i], " cannot be found as a department name")
      municipalities_codes <- c(municipalities_codes, NA)
      next
    }
    filtered_mps <- divipola[which(
      divipola$codigo_departamento == dpt_code
    ), ]
    fixed_tokens <- iconv(
      filtered_mps$nombre_municipio,
      from = "utf-8",
      to = "ASCII//TRANSLIT"
    )
    distances <- as.data.frame(stringdist::afind(
      x = fixed_tokens,
      pattern = input_token,
      method = "cosine",
      window = max(8, nchar(input_token), na.rm = TRUE)
    ))
    min_distance_i <- which(distances$distance == min(distances$distance))
    if (length(min_distance_i) == 1) {
      mp_code <- filtered_mps$codigo_municipio[min_distance_i]
    } else {
      min_location <- distances$location[min_distance_i]
      min_location_i <- min_distance_i[which.min(min_location)]
      mp_code <- filtered_mps$codigo_municipio[min_location_i]
    }
    if (min(distances$distance) > 0.11) {
      warning(municipality_name[i], " cannot be found as a municipality name")
      municipalities_codes <- c(municipalities_codes, NA)
    } else {
      municipalities_codes <- c(municipalities_codes, mp_code)
    }
  }
  return(municipalities_codes)
}

#' Retrieve departments' DIVIPOLA names from codes
#'
#' @description
#' Retrieve departments' DIVIPOLA official names from their DIVIPOLA codes
#'
#' @param department_code character vector with the DIVIPOLA codes of the
#' departments
#'
#' @examples
#' dptos <- c("73", "05", "11")
#' names <- divipola_department_name(dptos)
#'
#' @return character vector with the DIVIPOLA name of the departments
#'
#' @export
divipola_department_name <- function(department_code) {
  checkmate::assert_character(department_code, n.chars = 2)

  divipola <- divipola_table()
  dpts <- divipola[
    !duplicated(divipola$nombre_departamento),
    c("codigo_departamento", "nombre_departamento")
  ]
  departments_names <- NULL
  for (code in department_code) {
    dpt_name <- dpts$nombre_departamento[which(
      dpts$codigo_departamento == code
    )]
    if (rlang::is_empty(dpt_name)) {
      warning(code, " cannot be found as a department code")
      departments_names <- c(departments_names, NA)
    } else {
      departments_names <- c(departments_names, dpt_name)
    }
  }
  return(departments_names)
}

#' Retrieve municipalities' DIVIPOLA names from codes
#'
#' @description
#' Retrieve municipalities' DIVIPOLA official names from their DIVIPOLA codes
#'
#' @param municipality_code character vector with the DIVIPOLA codes of the
#' municipalities
#'
#' @examples
#' mpios <- c("73001", "11001", "05615")
#' names <- divipola_municipality_name(mpios)
#'
#' @return character vector with the DIVIPOLA name of the municipalities
#'
#' @export
divipola_municipality_name <- function(municipality_code) {
  checkmate::assert_character(municipality_code, n.chars = 5)

  mps <- divipola_table()
  municipalities_names <- NULL
  for (code in municipality_code) {
    mp_name <- mps$nombre_municipio[which(
      mps$codigo_municipio == code
    )]
    if (rlang::is_empty(mp_name)) {
      warning(code, " cannot be found as a municipality code")
      municipalities_names <- c(municipalities_names, NA)
    } else {
      municipalities_names <- c(municipalities_names, mp_name)
    }
  }
  return(municipalities_names)
}
