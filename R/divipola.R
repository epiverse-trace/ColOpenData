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
  dptos <- divipola[
    !duplicated(divipola$departamento),
    c("codigo_departamento", "departamento")
  ]
  fixed_tokens <- iconv(
    tolower(dptos$departamento),
    from = "utf-8",
    to = "ASCII//TRANSLIT"
  )
  departments_codes <- NULL
  for (dpto in department_name) {
    input_token <- iconv(tolower(dpto),
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
      dpto_code <- dptos$codigo_departamento[min_distance_i]
    } else {
      min_location <- distances$location[min_distance_i]
      min_location_i <- min_distance_i[which.min(min_location)]
      dpto_code <- dptos$codigo_departamento[min_location_i]
    }
    if (min(distances$distance) > 0.11) {
      warning(dpto, " cannot be found as a department name")
      departments_codes <- c(departments_codes, NA)
    } else {
      departments_codes <- c(departments_codes, dpto_code)
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
  dptos <- suppressWarnings(divipola_department_code(department_name))
  municipalities_codes <- NULL
  for (i in seq_along(municipality_name)) {
    input_token <- iconv(
      tolower(municipality_name[i]),
      from = "utf-8",
      to = "ASCII//TRANSLIT"
    )
    dpto_code <- dptos[i]
    if (is.na(dpto_code)) {
      warning(department_name[i], " cannot be found as a department name")
      municipalities_codes <- c(municipalities_codes, NA)
      next
    }
    filtered_mpios <- divipola[which(
      divipola$codigo_departamento == dpto_code
    ), ]
    fixed_tokens <- iconv(
      tolower(filtered_mpios$municipio),
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
      mpio_code <- filtered_mpios$codigo_municipio[min_distance_i]
    } else {
      min_location <- distances$location[min_distance_i]
      min_location_i <- min_distance_i[which.min(min_location)]
      mpio_code <- filtered_mpios$codigo_municipio[min_location_i]
    }
    if (min(distances$distance) > 0.11) {
      warning(municipality_name[i], " cannot be found as a municipality name")
      municipalities_codes <- c(municipalities_codes, NA)
    } else {
      municipalities_codes <- c(municipalities_codes, mpio_code)
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
  dptos <- divipola[
    !duplicated(divipola$departamento),
    c("codigo_departamento", "departamento")
  ]
  departments_names <- NULL
  for (code in department_code) {
    dpto_name <- dptos$departamento[which(
      dptos$codigo_departamento == code
    )]
    if (rlang::is_empty(dpto_name)) {
      warning(code, " cannot be found as a department code")
      departments_names <- c(departments_names, NA)
    } else {
      departments_names <- c(departments_names, dpto_name)
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

  mpios <- divipola_table()
  municipalities_names <- NULL
  for (code in municipality_code) {
    mpio_name <- mpios$municipio[which(
      mpios$codigo_municipio == code
    )]
    if (rlang::is_empty(mpio_name)) {
      warning(code, " cannot be found as a municipality code")
      municipalities_names <- c(municipalities_names, NA)
    } else {
      municipalities_names <- c(municipalities_names, mpio_name)
    }
  }
  return(municipalities_names)
}
