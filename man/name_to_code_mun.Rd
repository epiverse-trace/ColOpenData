% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/divipola.R
\name{name_to_code_mun}
\alias{name_to_code_mun}
\title{Retrieve municipalities' DIVIPOLA codes from names}
\usage{
name_to_code_mun(department_name, municipality_name)
}
\arguments{
\item{department_name}{character vector with the names of the
departments containing the municipalities}

\item{municipality_name}{character vector with the names of the
municipalities}
}
\value{
character vector with the DIVIPOLA codes of the municipalities
}
\description{
Retrieve municipalities' DIVIPOLA codes from their names. Since there are
municipalities with the same names in different departments, the input must
include a two vectors of the same length: one for the departments and one for
the municipalities
}
\examples{
dptos <- c("HUILA", "ANTIOQUIA")
mpios <- c("PITALITO", "TURBO")
name_to_code_mun(dptos, mpios)

}