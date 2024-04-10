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
#' code_tolima <- divipola_department_code("TOLIMA")
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
    gsub(" ", "", dpts$nombre_departamento,
      fixed = TRUE
    ),
    from = "utf-8",
    to = "ASCII//TRANSLIT"
  )
  dpt_codes <- NULL
  for (dpt in department_name) {
    input_token <- iconv(toupper(gsub(" ", "", dpt, fixed = TRUE)),
      from = "utf-8",
      to = "ASCII//TRANSLIT"
    )
    distances <- as.data.frame(stringdist::afind(
      x = fixed_tokens,
      pattern = input_token,
      method = "jaccard"
    ))
    if (min(distances$distance) > 0.2) {
      stop(dpt, " cannot be found as a department name")
    }
    min_distance_i <- which(distances$distance == min(distances$distance))
    if (length(min_distance_i) == 1) {
      dpt_code <- dpts$codigo_departamento[min_distance_i]
    } else {
      min_location <- distances$location[min_distance_i]
      min_location_i <- min_distance_i[which.min(min_location)]
      dpt_code <- dpts$codigo_departamento[min_location_i]
    }
    dpt_codes <- c(dpt_codes, dpt_code)
  }
  return(dpt_codes)
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
#' code_ibague <- divipola_municipality_code("HUILA", "PITALITO")
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
  dpts <- divipola_department_code(department_name)
  mp_codes <- NULL
  for (i in seq_along(municipality_name)) {
    input_token <- iconv(
      toupper(gsub(" ", "", municipality_name[i],
        fixed = TRUE
      )),
      from = "utf-8",
      to = "ASCII//TRANSLIT"
    )
    dpt_code <- dpts[i]
    filtered_mps <- divipola[which(
      divipola$codigo_departamento == dpt_code
    ), ]
    fixed_tokens <- iconv(
      gsub(" ", "", filtered_mps$nombre_municipio,
        fixed = TRUE
      ),
      from = "utf-8",
      to = "ASCII//TRANSLIT"
    )
    distances <- as.data.frame(stringdist::afind(
      x = fixed_tokens,
      pattern = input_token,
      method = "jaccard"
    ))
    if (min(distances$distance) > 0.2) {
      stop(municipality_name[i], " cannot be found as a municipality name")
    }
    min_distance_i <- which(distances$distance == min(distances$distance))
    if (length(min_distance_i) == 1) {
      mp_code <- filtered_mps$codigo_municipio[min_distance_i]
    } else {
      min_location <- distances$location[min_distance_i]
      min_location_i <- min_distance_i[which.min(min_location)]
      mp_code <- filtered_mps$codigo_municipio[min_location_i]
    }
    mp_codes <- c(mp_codes, mp_code)
  }
  return(mp_codes)
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
#' name_tolima <- divipola_department_name("73")
#'
#' @return character vector with the DIVIPOLA name of the departments
#'
#' @export
divipola_department_name <- function(department_code) {
  checkmate::assert_character(department_code)

  divipola <- divipola_table()
  dpts <- divipola[
    !duplicated(divipola$nombre_departamento),
    c("codigo_departamento", "nombre_departamento")
  ]
  dpt_names <- NULL
  for (code in department_code) {
    dpt_name <- dpts$nombre_departamento[which(
      dpts$codigo_departamento == department_code
    )]
    if (rlang::is_empty(dpt_name)) {
      stop(code, " cannot be found as a department code")
    } else {
      dpt_names <- c(dpt_names, dpt_name)
    }
  }
  return(dpt_names)
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
#' name_ibague <- divipola_municipality_name("73001")
#'
#' @return character vector with the DIVIPOLA name of the municipalities
#'
#' @export
divipola_municipality_name <- function(municipality_code) {
  checkmate::assert_character(municipality_code)

  mps <- divipola_table()
  mp_names <- NULL
  for (code in municipality_code) {
    mp_name <- mps$nombre_municipio[which(
      mps$codigo_municipio == municipality_code
    )]
    if (rlang::is_empty(mp_name)) {
      stop(code, " cannot be found as a municipality code")
    } else {
      mp_names <- c(mp_names, mp_name)
    }
  }
  return(mp_names)
}
