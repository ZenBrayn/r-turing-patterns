#
# Implementation of Multi-scale Turing Patterns in R
#
# R.Benz, 2018-09-28
#
# Use approach outlined in
# https://softologyblog.wordpress.com/2011/07/05/multi-scale-turing-patterns/
#


default_params <- function() {
  tibble::tibble(
    scale = 1:5,
    act_radius = c(100, 20, 10, 5, 1),
    inhib_radius = c(200, 40, 20, 10, 2),
    small = c(0.05,0.04,0.03,0.02,0.01),
    weight = c(1, 1, 1, 1, 1)
  )
}

turing_pattern <- function(grid_x, grid_y, n_itr, params = default_params(), rand_seed = 12345,
                           display_intr_imgs = FALSE, color_vals = gray.colors(255)) {
  set.seed(rand_seed)

  # Initialize the grid, size grid_x by grid_y, with random numbers between -1 and 1
  tp_grid <- matrix((runif(grid_x * grid_y) * 2) - 1,
                    nrow = grid_x, ncol = grid_y, byrow = TRUE)

  pb <- progress::progress_bar$new(
    format = "  computing [:bar] :percent eta: :eta",
    total = n_itr, clear = FALSE, width = 60)

  for (i in 1:n_itr) {
    pb$tick()

    # Suppressing warnings here because gblur is is noisy!
    vals <- suppressWarnings(params %>%
      dplyr::mutate(activator_mtrx = purrr::map2(act_radius, weight, function(r, w) {
        tp_grid %>% EBImage::gblur(sigma = r, radius = r) * w
      })) %>%
      dplyr::mutate(inhibitor_mtrx = purrr::map2(inhib_radius, weight, function(r, w) {
        tp_grid %>% EBImage::gblur(sigma = r, radius = r) * w
      })) %>%
      dplyr::mutate(variation_mtrx = purrr::map2(activator_mtrx, inhibitor_mtrx, function(a, i) {
        abs(a - i)
      })))

    # Figure out the scale with the min variation for each x, y
    var_mtrx <- simplify2array(vals$variation_mtrx)

    scale_mtrx <- matrix(rep(0, grid_x * grid_y), nrow = grid_x, ncol = grid_y, byrow = TRUE)
    for (x in 1:dim(var_mtrx)[1]) {
      for (y in 1:dim(var_mtrx)[2]) {
        scale_sel <- which(var_mtrx[x,y,] == min(var_mtrx[x,y,]))

        act_sel <- vals$activator_mtrx[[scale_sel]][x,y]
        inh_sel <- vals$inhibitor_mtrx[[scale_sel]][x,y]

        if (act_sel > inh_sel) {
          tp_grid[x, y] <- tp_grid[x, y] + params$small[scale_sel]
        } else {
          tp_grid[x, y] <- tp_grid[x, y] - params$small[scale_sel]
        }
      }
    }

    min_grid <- min(tp_grid)
    max_grid <- max(tp_grid)
    range_grid <- max_grid - min_grid
    tp_grid <- (tp_grid - min_grid) / range_grid * 2 - 1

    # print the interim images?
    if (display_intr_imgs) {
      image(tp_grid, useRaster = TRUE, axes = FALSE, col = color_vals)
    }
  }

  tp_grid
}

save_image <- function(tp_grid, file_name, color_vals = gray.colors(255)) {
  png(file_name, width = ncol(tp_grid), height = nrow(tp_grid))
  par(mar = c(0,0,0,0))
  image(tp_grid, useRaster = TRUE, axes = FALSE, col = color_vals)
  dev.off()
}

