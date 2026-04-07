# Getting Started with plotjs

## Introduction

R is renowned for its graphical capabilities, and base R’s ‘graphics’
package makes it easy and quick to create clean, useful plots. However,
plots created with base graphics are static images and therefore lack
interactive features such as tooltips or zooming.

The plotjs package implements various plotting functions with similar
names, arguments and behavior to their counterparts in base graphics,
except the plots they create are interactive HTML widgets rendered using
the Chart.js charting library. This makes it easy to generate
interactive versions of common plots without the cognitive overhead of
using or learning a plotting package with completely different arguments
and syntax. This vignette will help you get started creating interactive
visualizations with plotjs.

The first step is to install the package:

``` r
# install.packages("devtools")
devtools::install_github("arkraieski/plotjs")
```

## Basic Scatter Plots

The
[`plotjs()`](https://arkraieski.github.io/plotjs/reference/plotjs.md)
function works much like base R’s
[`plot()`](https://rdrr.io/r/graphics/plot.default.html) function. To
create a scatter plot, we simply have to provide two vectors (often from
the same data.frame) for the arguments `x` and `y`. There are many
optional arguments that can be specified, but we’ll get to that later in
this document.

First, let’s create a basic scatter plot using base R as a refresher:

``` r
library(plotjs)
mtcars <- mtcars # R's Motor Trend Cars Dataset

plot(x = mtcars$hp, y = mtcars$qsec)
```

![](plotjs-getting-started_files/figure-html/unnamed-chunk-3-1.png)

Now with
[`plotjs()`](https://arkraieski.github.io/plotjs/reference/plotjs.md):

``` r
plotjs(x = mtcars$hp, y = mtcars$qsec)
```

You can use the mouse wheel to zoom in on this chart, and the points
have tooltips. Importantly, neither this nor the base R plot earlier
have much in the way of
[chartjunk](https://www.edwardtufte.com/bboard/q-and-a-fetch-msg?msg_id=00040Z).

## Title and Axis Labels

Just like with [`plot()`](https://rdrr.io/r/graphics/plot.default.html),
we can specify a plot title and x and y axis labels using the arguments
`main`, `xlab`, and `ylab`, respectively:

``` r
plotjs(x = mtcars$hp, y = mtcars$qsec,
       main = "1/4 Mile Time vs. Horsepower",
       xlab = "HP",
       ylab = "Seconds")
```

## Line plots

Like the base [`plot()`](https://rdrr.io/r/graphics/plot.default.html)
function,
[`plotjs()`](https://arkraieski.github.io/plotjs/reference/plotjs.md)
can also create line plots by setting the `type` argument to “l”
(default is “p” for points). You can also show both points and lines by
setting it to “b”.

``` r
x <- 1:10
y <- x*x

plotjs(x, y, type = "l", zoom = FALSE)
```

## Color

For
[`plotjs()`](https://arkraieski.github.io/plotjs/reference/plotjs.md)
colors for the points can be specified using the `col` argument. Colors
can be given as strings containing a hex value or strings with names of
R built-in colors. You can run
[`grDevices::colors()`](https://rdrr.io/r/grDevices/colors.html) to see
all valid color names.

To color all points the same color, provide a single value for `col`:

``` r
plotjs(x = mtcars$hp, y = mtcars$qsec, col = "red")
```

Points can also be colored by groups in the data. There are two ways of
doing this:

1.  Pass a factor the same length as `x` to the `col.group` argument and
    leave `col` NULL. Points will be grouped by `col.group`, and then
    each group will be assigned a color by Chart.js using its default
    palette.

2.  Pass a factor to `col.group` and vector of colors to use for each
    group to `col`.

First, let’s color a scatter plot by a factor but let Chart.js pick the
colors:

``` r
# convert mtcars$cyl to a factor
mtcars$cyl <- as.factor(paste(mtcars$cyl, "cylinders"))

plotjs(mtcars$hp, mtcars$mpg, col.group = mtcars$cyl, legend.title = "cyl")
```

Now, coloring manually from R:

``` r
plotjs(mtcars$hp, mtcars$mpg, col.group = mtcars$cyl, 
       col = c("red2", "yellow3", "purple"),
       legend.title = "cyl")
```

## Pie charts

Sometimes, your boss might want you to make a pie chart.

plotjs also provides a
[`jspie()`](https://arkraieski.github.io/plotjs/reference/jspie.md)
function that works like the base R `pie` function, albeit with a
simplified set of arguments. `x` is a vector of non-negative numerical
quantities. Names for the pie slices can be given as a character vector
to the `labels` argument. If `x` is a named vector, the names will be
used to label the pie slices (`labels` defaults to `names(x)`).

Here’s an example adapted from the help file for
[`pie()`](https://rdrr.io/r/graphics/pie.html):

``` r
pie.sales <- c(0.12, 0.3, 0.26, 0.16, 0.04, 0.12)
names(pie.sales) <- c("Blueberry", "Cherry",
    "Apple", "Boston Cream", "Other", "Vanilla Cream")
jspie(pie.sales)
```

If you want something a little better, you can also use the `donut`
argument to make a donut chart:

``` r
jspie(pie.sales, donut = TRUE)
```

## S3 methods

Like base’s [`plot()`](https://rdrr.io/r/graphics/plot.default.html),
[`plotjs()`](https://arkraieski.github.io/plotjs/reference/plotjs.md) is
a generic function with S3 methods for various classes of base R
objects. While
[`plotjs()`](https://arkraieski.github.io/plotjs/reference/plotjs.md)
doesn’t have as many methods, this nonetheless provides some useful
shortcuts for making some common plots. To see all available methods,
run:

``` r
methods(plotjs)
#> [1] plotjs.default*  plotjs.density*  plotjs.factor*   plotjs.function*
#> [5] plotjs.lm*      
#> see '?methods' for accessing help and source code
```

So far, we’ve been working with the default method. Each method has help
available. For example, you would run
[`?plotjs.density`](https://arkraieski.github.io/plotjs/reference/plotjs.density.md)
to view the help file for
[`plotjs.density()`](https://arkraieski.github.io/plotjs/reference/plotjs.density.md).

Let’s create a density plot with the Old Faithful geyser data using
[`plotjs.density()`](https://arkraieski.github.io/plotjs/reference/plotjs.density.md).
First, create a “density” object:

``` r
d <- density(faithful$eruptions, bw = "sj")
class(d)
#> [1] "density"
d
#> 
#> Call:
#>  density.default(x = faithful$eruptions, bw = "sj")
#> 
#> Data: faithful$eruptions (272 obs.); Bandwidth 'bw' = 0.14
#> 
#>        x               y            
#>  Min.   :1.180   Min.   :0.0001814  
#>  1st Qu.:2.265   1st Qu.:0.0421820  
#>  Median :3.350   Median :0.1706817  
#>  Mean   :3.350   Mean   :0.2299476  
#>  3rd Qu.:4.435   3rd Qu.:0.4130131  
#>  Max.   :5.520   Max.   :0.5940669
```

Since
[`plotjs()`](https://arkraieski.github.io/plotjs/reference/plotjs.md)
has a method for “density” objects, we can plot this object simply by
passing it to the `x` argument (this method doesn’t need `y`):

``` r
plotjs(d)
```

Compare to the base R version:

``` r
plot(d)
```

![](plotjs-getting-started_files/figure-html/unnamed-chunk-15-1.png)

The plots are very similar aside from some visual differences and
obviously the interactivity of the plotjs version.
[`plotjs()`](https://arkraieski.github.io/plotjs/reference/plotjs.md)
methods are designed to replicate the functionality of their Base R
counterparts.

[`plotjs.function()`](https://arkraieski.github.io/plotjs/reference/plotjs.function.md)
lets us do cool stuff like this:

``` r
plotjs(qnorm) # default range c(0, 1)
```

and this (note use of scientific notation on y-axis):

``` r
plotjs(sin, -pi,  3*pi, col = "orange2", sci.y = TRUE)
```

## Bar charts

This package also provides a
[`jsbarplot()`](https://arkraieski.github.io/plotjs/reference/jsbarplot.md)
function modeled after
[`barplot()`](https://rdrr.io/r/graphics/barplot.html) from base
graphics. Pass a numeric vector describing the heights of the bars to
the `heights` argument. You can also provide a vector of names for the
bars to the argument `names.arg` (otherwise the x-axis will be numbered
sequentially). Here’s a simple, silly example:

``` r
jsbarplot(heights = c(100, 30), names.arg = c("Red Sox", "Yankees"), ylab = "% Awesome",
      main = "Awesomeness of Baseball Teams")
```

You can also use the “shortcut” provided by the
[`plotjs.factor()`](https://arkraieski.github.io/plotjs/reference/plotjs.factor.md)
method to make a bar chart of factor level counts. Simply pass a factor
to the `x` argument:

``` r
# cyl column of mtcars was already converted into a factor earlier in this vignette
plotjs(mtcars$cyl, col = "#FF2800", main = "Cars by Number of Cylinders in mtcars")
```

## Conclusion

By now you should be more than ready to start using plotjs on your own
data. Consult the help pages for details about arguments and methods.
While plotjs doesn’t offer quite the same level of customization as base
graphics, it’s a simple, interactive alternative for many common base
plots.
