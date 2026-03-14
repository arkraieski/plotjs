# plotjs Bar Plots

Creates a bar plot using 'Chart.js'.

## Usage

``` r
plotjsbarplot(
  heights,
  names.arg = NULL,
  col = NULL,
  main = NULL,
  ylab = NULL,
  width = NULL,
  height = NULL,
  elementId = NULL,
  ...
)
```

## Arguments

- heights:

  a vector of values describing the bars that make up the plot.

- names.arg:

  a vector of names to be plotted below each bar.

- col:

  a character string with the color for bars. This can be either a hex
  value or the name of an R built-in color.

- main:

  a main title for the plot.

- ylab:

  a label for the y axis.

- width:

  width of the widget to create for the plot. The default is NULL, which
  results in automatic resizing based on the plot's container.

- height:

  height of the widget to create for the plot. The default is NULL,
  which results in automatic resizing based on the plot's container.

- elementId:

  Use an explicit element ID for the widget, rather than an
  automatically generated one.

- ...:

  arguments passed from methods.
