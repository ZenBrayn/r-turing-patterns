% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/turning_patterns.R
\name{turing_pattern}
\alias{turing_pattern}
\title{Create a Turing Pattern image}
\usage{
turing_pattern(
  grid_x,
  grid_y,
  n_itr = 100,
  params = default_params,
  rand_seed = 12345,
  display_intr_imgs = FALSE,
  color_vals = gray.colors(255)
)
}
\arguments{
\item{grid_x}{size of the output image along the x-dimension}

\item{grid_y}{size of the ouput image along the y-dimension}

\item{n_itr}{number of computation iterations (default: 100)}

\item{params}{parameters for the computation (default: default_params, provided by the package)}

\item{rand_seed}{random seed to start the computation}

\item{display_intr_imgs}{display the image with each computation iteration}

\item{color_vals}{vector of color values for image display}
}
\description{
compute a turing pattern image
}
