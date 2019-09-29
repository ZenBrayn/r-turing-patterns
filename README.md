# Generate Turing Patterns in R

This R project generates multi-scale Turing Patterns using the algorithm described [here](https://softologyblog.wordpress.com/2011/07/05/multi-scale-turing-patterns/), and as originally detailed in [a paper](http://www.jonathanmccabe.com/Cyclic_Symmetric_Multi-Scale_Turing_Patterns.pdf) by Jonathan McCabe.

## Installation

You can install via GitHub:

```
remotes::install_github("ZenBrayn/r-turing-patterns", dependencies = TRUE)
```

## Examples

This is a basic example that uses the default paramters.

```
library(turingpatterns)

# Size of the grid
grid_x <- 500
grid_y <- 500
# Number of processing iterations
n_itr <- 100

# This might take a while...
tp_grid <- turing_pattern(grid_x, grid_y, n_itr)
# Save out your work
save_image(tp_grid, "ex1.png")
```

![](https://github.com/ZenBrayn/r-turing-patterns/blob/master/ex1.png)

By default, the image is display in gray scale, but you can supply your
own color palette (sequential scales seem to work the best)

```
save_image(tp_grid, "ex2.png", color_values = viridis::viridis(12))
```

![](https://github.com/ZenBrayn/r-turing-patterns/blob/master/ex2.png)

Default parameters are used if not specified in the `turing_pattern` call.
You can get these parameters through the `default_parameters` function, and
modify them (or create the parameters data frame yourself -- just use the same
column names).

```
defaults <- default_params()
tp_grid <- turing_pattern(grid_x, grid_y, n_itr, params = defaults)
```

```
# Make a parameters table from scratch
my_params <- tibble(
  scale = 1:10,
  act_radius = c(200, 150, 100, 75, 50, 25, 10, 5, 2, 1),
  small = seq(0.1, 0.01, by = -0.01),
  weight = 1
)
params$inhib_radius <- params$act_radius * 2

tp_grid <- turing_pattern(grid_x, grid_y, n_itr, params = my_params)
```

Currently, the `turing_pattern` function can take a while to run.  You can see the
iterative output at each step by specifying the follow argument:

```
tp_grid <- turing_pattern(grid_x, grid_y, n_itr, params = my_params, 
                          display_intr_imgs = TRUE, color_vals = viridis::viridis(10))
```

![](https://github.com/ZenBrayn/r-turing-patterns/blob/master/ex3.png)
