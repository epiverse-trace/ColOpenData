% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/divipola.R
\name{divipola_municipality_name}
\alias{divipola_municipality_name}
\title{Retrieve municipalities' DIVIPOLA names from codes}
\usage{
divipola_municipality_name(municipality_code)
}
\arguments{
\item{municipality_code}{character vector with the DIVIPOLA codes of the
municipalities}
}
\value{
character vector with the DIVIPOLA name of the municipalities
}
\description{
Retrieve municipalities' DIVIPOLA official names from their DIVIPOLA codes
}
\examples{
name_ibague <- divipola_municipality_name("73001")

}
