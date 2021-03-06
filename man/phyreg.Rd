% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/phyreg.R
\name{phyreg}
\alias{phyreg}
\title{Internal function for phyloregPar}
\usage{
phyreg(Grps, Data = NULL, Y = NULL, XX, frmla, n, choice, method, Pbasis,
  Pval.Cutoff, ...)
}
\arguments{
\item{Grps}{list of groups. see \code{\link{getGroups}}}

\item{Data}{data matrix. Rows are parts and columns are samples}

\item{XX}{independent variable}

\item{frmla}{formula for glm}

\item{n}{total number of taxa in Data}

\item{choice}{objective function allowing parallelization of residual variance calculations}

\item{method}{method for amalgamating groups}

\item{Pbasis}{coming soon}

\item{...}{optional inputs for glm}
}
\description{
Internal function for phyloregPar
}

