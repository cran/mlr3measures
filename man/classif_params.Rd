% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/roxygen.R
\name{classif_params}
\alias{classif_params}
\title{Classification Parameters}
\arguments{
\item{truth}{(\code{factor()})\cr
True (observed) labels.
Must have the same levels and length as \code{response}.}

\item{response}{(\code{factor()})\cr
Predicted response labels.
Must have the same levels and length as \code{truth}.}

\item{prob}{(\code{matrix()})\cr
Matrix of predicted probabilities, each column is a vector of probabilities for a
specific class label.
Columns must be named with levels of \code{truth}.}

\item{sample_weights}{(\code{numeric()})\cr
Vector of non-negative and finite sample weights.
Must have the same length as \code{truth}.
The vector gets automatically normalized to sum to one.
Defaults to equal sample weights.}

\item{na_value}{(\code{numeric(1)})\cr
Value that should be returned if the measure is not defined for the input
(as described in the note). Default is \code{NaN}.}

\item{...}{(\code{any})\cr
Additional arguments. Currently ignored.}
}
\description{
Classification Parameters
}
\keyword{internal}
