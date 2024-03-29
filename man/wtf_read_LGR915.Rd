% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_data_functions.R
\name{wtf_read_LGR915}
\alias{wtf_read_LGR915}
\title{Read a LGR 915-0011 data file}
\usage{
wtf_read_LGR915(file, tz = "UTC")
}
\arguments{
\item{file}{Filename to read, character}

\item{tz}{Time zone of the file's time data, character (optional)}
}
\value{
A \code{\link{data.frame}} with the parsed data.
}
\description{
Read a LGR 915-0011 data file
}
\details{
The LGR 915-0011 was an Ultra-Portable Greenhouse Gas Analyzer
made by Los Gatos Research.
}
\examples{
f <- system.file("extdata/LGR-data.csv", package = "whattheflux")
dat <- wtf_read_LGR915(f)
dat <- wtf_read_LGR915(f, tz = "EST") # specify time zone
}
