# The Default plotjs Scatterplot Function

Draw an interactive scatterplot or line plot using 'Chart.js'.

## Usage

``` r
# Default S3 method
plotjs(
  x,
  y,
  type = "p",
  xlim = NULL,
  ylim = NULL,
  main = NULL,
  xlab = NULL,
  ylab = NULL,
  zoom = TRUE,
  col.group = NULL,
  col = NULL,
  legend.title = NULL,
  legend.position = "right",
  sci.x = FALSE,
  sci.y = FALSE,
  ...
)
```

## Arguments

- x:

  the x coordinates for the plot.

- y:

  the y coordinates for the plot.

- type:

  1-character string giving the type of plot desired. The following
  values are possible: "p" for points, "l" for lines, and "b" for both
  points and lines.

- xlim:

  the x limits (x1, x2) of the plot.

- ylim:

  the y limits of the plot.

- main:

  a main title for the plot.

- xlab:

  a label for the x axis, defaults to a description of x.

- ylab:

  a label for the y axis, defaults to a description of y.

- zoom:

  logical; should the zooming feature be enabled for the plot?

- col.group:

  optionally, a factor the same length as `x` by which to group and
  color points.

- col:

  The colors for the lines and points. If `col.group` is specified, this
  can be a vector of colors to use for each group in the data. If
  `NULL`, Chart.js default colors are used.

- legend.title:

  a title for the legend. Defaults to a description of `col.group` if
  not set. You can also use `legend.title = FALSE` to suppress the
  legend title.

- legend.position:

  Position of the plot legend. Possible values are "right", "bottom",
  "inset", and "hide". This is ignored if all points are colored the
  same.

- sci.x:

  logical indicating whether scientific notation should be used for the
  x-axis.

- sci.y:

  logical indicating whether scientific notation should be used for the
  y-axis.

- ...:

  arguments passed to
  [`htmlwidgets::createWidget()`](https://rdrr.io/pkg/htmlwidgets/man/createWidget.html):
  `width`, `height`, and `elementId`. These arguments default to NULL.

## Examples

``` r
data(mtcars)
plotjs(mtcars$hp, mtcars$qsec)

{"x":{"data":{"x":[110,110,93,110,175,105,245,62,95,123,123,180,180,180,205,215,230,66,52,65,97,150,150,245,175,66,91,113,264,175,335,109],"y":[16.46,17.02,18.61,19.44,17.02,20.22,15.84,20,22.9,18.3,18.9,17.4,17.6,18,17.98,17.82,17.42,19.47,18.52,19.9,20.01,16.87,17.3,15.41,17.05,18.9,16.7,16.9,14.5,15.5,14.6,18.6],"plot_type":"scatter","xlim":null,"ylim":null,"title":null,"xlab":"mtcars$hp","ylab":"mtcars$qsec","show_points":true,"zoom":true,"col_hex":null,"group_names":null,"grouped_data":null,"legend":{"text":null,"position":"right","hide":false},"sci_x":false,"sci_y":false}},"evals":[],"jsHooks":[]}plotjs(mtcars$disp, mtcars$hp, main = "Displacement vs. HP in mtcars")

{"x":{"data":{"x":[160,160,108,258,360,225,360,146.7,140.8,167.6,167.6,275.8,275.8,275.8,472,460,440,78.7,75.7,71.09999999999999,120.1,318,304,350,400,79,120.3,95.09999999999999,351,145,301,121],"y":[110,110,93,110,175,105,245,62,95,123,123,180,180,180,205,215,230,66,52,65,97,150,150,245,175,66,91,113,264,175,335,109],"plot_type":"scatter","xlim":null,"ylim":null,"title":"Displacement vs. HP in mtcars","xlab":"mtcars$disp","ylab":"mtcars$hp","show_points":true,"zoom":true,"col_hex":null,"group_names":null,"grouped_data":null,"legend":{"text":null,"position":"right","hide":false},"sci_x":false,"sci_y":false}},"evals":[],"jsHooks":[]}
```
