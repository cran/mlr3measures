% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/binary_tp.R
\name{tp}
\alias{tp}
\title{True Positives}
\usage{
tp(truth, response, positive, ...)
}
\arguments{
\item{truth}{:: \code{factor()}\cr
True (observed) labels.
Must have the exactly same two levels and the same length as \code{response}.}

\item{response}{:: \code{factor()}\cr
Predicted response labels.
Must have the exactly same two levels and the same length as \code{truth}.}

\item{positive}{:: \code{character(1)}\cr
Name of the positive class.}

\item{...}{:: \code{any}\cr
Additional arguments. Currently ignored.}
}
\value{
Performance value as \code{numeric(1)}.
}
\description{
Binary classification measure counting the true positives, i.e. the number of
predictions correctly indicating a positive class label.
}
\section{Meta Information}{

\itemize{
\item Type: \code{"binary"}
\item Range: \eqn{[0, \infty)}{[0, Inf)}
\item Minimize: \code{FALSE}
\item Required prediction: \code{response}
}
}

\examples{
set.seed(1)
lvls = c("a", "b")
truth = factor(sample(lvls, 10, replace = TRUE), levels = lvls)
response = factor(sample(lvls, 10, replace = TRUE), levels = lvls)
tp(truth, response, positive = "a")
}
\references{
\url{https://en.wikipedia.org/wiki/Template:DiagnosticTesting_Diagram}
}
\seealso{
Other Binary Classification Measures: \code{\link{auc}},
  \code{\link{dor}}, \code{\link{fbeta}},
  \code{\link{fdr}}, \code{\link{fnr}}, \code{\link{fn}},
  \code{\link{fomr}}, \code{\link{fpr}}, \code{\link{fp}},
  \code{\link{mcc}}, \code{\link{npv}}, \code{\link{ppv}},
  \code{\link{tnr}}, \code{\link{tn}}, \code{\link{tpr}}
}
\concept{Binary Classification Measures}
\concept{binary_classification_measure}