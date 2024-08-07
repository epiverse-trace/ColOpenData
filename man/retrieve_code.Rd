% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/divipola.R
\name{retrieve_code}
\alias{retrieve_code}
\title{Retrieve code}
\usage{
retrieve_code(input_token, fixed_tokens, codes_list)
}
\arguments{
\item{input_token}{Input token to search in fixed tokens.}

\item{fixed_tokens}{Vector of tokens to match against.}

\item{codes_list}{Vector of target codes.}
}
\value{
character containing the matched code.
}
\description{
Retrieve code from list of codes, matching an input token against a list
of fixed tokens.
}
\keyword{internal}
