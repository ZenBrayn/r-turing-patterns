## code to prepare `default_params` dataset

default_params <- tibble::tribble(
  ~scale, ~act_radius, ~inhib_radius, ~small, ~weight,
      1L,        100L,           200L,   0.05,      1L,
      2L,         20L,            40L,   0.04,      1L,
      3L,         10L,            20L,   0.03,      1L,
      4L,          5L,            10L,   0.02,      1L,
      5L,          1L,             2L,   0.01,      1L
  )

usethis::use_data(default_params, overwrite = TRUE)

