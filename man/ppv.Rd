% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/binary_ppv.R
\name{ppv}
\alias{ppv}
\alias{precision}
\title{Positive Predictive Value}
\usage{
ppv(truth, response, positive, na_value = NaN, ...)

precision(truth, response, positive, na_value = NaN, ...)
}
\arguments{
\item{truth}{(\code{factor()})\cr
True (observed) labels.
Must have the exactly same two levels and the same length as \code{response}.}

\item{response}{(\code{factor()})\cr
Predicted response labels.
Must have the exactly same two levels and the same length as \code{truth}.}

\item{positive}{(\verb{character(1))}\cr
Name of the positive class.}

\item{na_value}{(\code{numeric(1)})\cr
Value that should be returned if the measure is not defined for the input
(as described in the note). Default is \code{NaN}.}

\item{...}{(\code{any})\cr
Additional arguments. Currently ignored.}
}
\value{
Performance value as \code{numeric(1)}.
}
\description{
Measure to compare true observed labels with predicted
labels
in binary classification tasks.
}
\details{
The Positive Predictive Value is defined as \deqn{
   \frac{\mathrm{TP}}{\mathrm{TP} + \mathrm{FP}}.
}{
   TP / (TP + FP).
}
Also know as "precision".

This measure is undefined if TP + FP = 0.
}
\section{Meta Information}{

\itemize{
\item Type: \code{"binary"}
\item Range: \eqn{[0, 1]}{[0, 1]}
\item Minimize: \code{FALSE}
\item Required prediction: \code{response}
}
}

\examples{
set.seed(1)
lvls = c("a", "b")
truth = factor(sample(lvls, 10, replace = TRUE), levels = lvls)
response = factor(sample(lvls, 10, replace = TRUE), levels = lvls)
ppv(truth, response, positive = "a")
}
\references{
\url{https://en.wikipedia.org/wiki/Template:DiagnosticTesting_Diagram}

Goutte C, Gaussier E (2005).
\dQuote{A Probabilistic Interpretation of Precision,  Recall and F-Score,  with Implication for Evaluation.}
In \emph{Lecture Notes in Computer Science}, 345--359.
\doi{10.1007/978-3-540-31865-1_25}.
}
\seealso{
Other Binary Classification Measures: 
\code{\link{auc}()},
\code{\link{bbrier}()},
\code{\link{dor}()},
\code{\link{fbeta}()},
\code{\link{fdr}()},
\code{\link{fn}()},
\code{\link{fnr}()},
\code{\link{fomr}()},
\code{\link{fp}()},
\code{\link{fpr}()},
\code{\link{gmean}()},
\code{\link{gpr}()},
\code{\link{npv}()},
\code{\link{prauc}()},
\code{\link{tn}()},
\code{\link{tnr}()},
\code{\link{tp}()},
\code{\link{tpr}()}
}
\concept{Binary Classification Measures}
\concept{binary_classification_measure}
