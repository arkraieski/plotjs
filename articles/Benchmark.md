# Benchmark

## Introduction

The vignette benchmarks `plotjs` against various other plotting systems
for R, namely `plotly`. Two basic plots will be used for this benchmark,
a basic scatter plot and a grouped line plot. I am uncertain if
JavaScript execution time is counted by `microbenchmark`. Even if we
assume it isn’t, the benchmark results are informative because it’s
always better if the R process gets tied up for less time per plot.
First, let’s load the visualization packages to compare:

``` r
library(plotjs)
library(plotly)
#> Loading required package: ggplot2
#> 
#> Attaching package: 'plotly'
#> The following object is masked from 'package:ggplot2':
#> 
#>     last_plot
#> The following object is masked from 'package:stats':
#> 
#>     filter
#> The following object is masked from 'package:graphics':
#> 
#>     layout
library(ggplot2)
```

## Scatter Plot

First, we will benchmark the creation of simple scatter plots using data
from the `gapminder` package. To begin, we will define functions to
create similar scatterplots using each of the packages to be compared.
The plots themselves are not important but are shown to demonstrate that
they work and produce roughly similar plots.

``` r
library(gapminder)

gapminder <- gapminder

plot_base <- function(x){
  
  plot(x = x$gdpPercap, y = x$lifeExp)
}

plot_base(gapminder)
```

![](Benchmark_files/figure-html/unnamed-chunk-3-1.png)

``` r
plot_plotjs <- function(x){
 
  plotjs(x = x$gdpPercap, y = x$lifeExp, sci.x = TRUE)
}
plot_plotjs(gapminder)
```

``` r
plot_plotly <- function(x){
  plot_ly(data = x, x = ~gdpPercap, y = ~lifeExp, type = "scatter")
}
plot_plotly(gapminder)
#> No scatter mode specifed:
#>   Setting the mode to markers
#>   Read more about this attribute -> https://plotly.com/r/reference/#scatter-mode
```

``` r
plot_ggplotly <- function(x){
  g <- ggplot(x, aes(x = gdpPercap, y = lifeExp)) + geom_point() + theme_minimal()
  ggplotly(g)
}
plot_ggplotly(gapminder)
```

``` r
plot_ggplot <- function(x){
  ggplot(x, aes(x = gdpPercap, y = lifeExp)) + geom_point() + theme_minimal()
}
plot_ggplot(gapminder)
```

![](Benchmark_files/figure-html/unnamed-chunk-7-1.png)

Now, these functions are benchmarked:

``` r
library(microbenchmark)
m <- microbenchmark(base = plot_base(gapminder),
               plotjs = plot_plotjs(gapminder),
               plotly = plot_plotly(gapminder),
               ggplotly = plot_ggplotly(gapminder),
               ggplot = plot_ggplot(gapminder),
               unit = "ms",
               times = 50)
```

``` r
m
#> Unit: milliseconds
#>      expr        min         lq        mean      median         uq        max
#>      base  24.614765  62.237660  61.7726746  62.4728685  62.587963  64.839523
#>    plotjs   0.082674   0.128670   0.2647491   0.1434425   0.171991   4.416476
#>    plotly   0.423420   0.469235   0.6258670   0.6114305   0.699594   2.433949
#>  ggplotly 174.098464 179.797473 189.7293642 189.9314875 198.640855 213.025151
#>    ggplot  36.483560  39.897667  45.4818918  42.7325440  45.545550 173.364496
#>  neval
#>     50
#>     50
#>     50
#>     50
#>     50
```

On my main development machine, plotjs was the quickest by an order of
magnitude. This can vary, but `plotly` is roughly 20 times slower, and
[`ggplotly()`](https://rdrr.io/pkg/plotly/man/ggplotly.html) is hundreds
of times slower. However, `plotly` was still quick enough that the
performance difference with `plotjs` would be imperceptible to users.

``` r
plot(m)
```

![](Benchmark_files/figure-html/unnamed-chunk-10-1.png)

Let’s look at kernel density plots of the time distributions for
`plotjs` and `plotly`.

``` r
density_plotjs <- density(m$time[m$expr == "plotjs"])
plotjs(density_plotjs)
```

``` r
density_plotly <- density(m$time[m$expr == "plotly"])
plotjs(density_plotly)
```

Let’s use a two-sample Wilcoxon test to compare the means of execution
time for plotjs and plotly. A t-test would not be suitable because we
cannot assume normality. The null hypothesis is that `plotjs` and
`plotly` will have the same mean execution time for these scatter plots.

``` r
w <- wilcox.test(m$time[m$expr == "plotjs"],
                 m$time[m$expr == "plotly"],
                 alternative = "less",
                 paired = FALSE)
w
#> 
#>  Wilcoxon rank sum test with continuity correction
#> 
#> data:  m$time[m$expr == "plotjs"] and m$time[m$expr == "plotly"]
#> W = 99, p-value = 1.084e-15
#> alternative hypothesis: true location shift is less than 0
```

Can we reject the null hypothesis?

``` r
ifelse(w$p.value < .05, "yes", "no")
#> [1] "yes"
```

## Grouped Line plots

Making line plots colored by group is a common plotting task that could
potentially expose some slowness in `plotjs`. We will make line plots of
the total GDP by continent by year. First, we must summarize the data
and define functions for making this lineplot with various packages.

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
gdp_cont <- gapminder %>%
  mutate(gdp = pop * gdpPercap) %>%
  group_by(continent, year) %>%
  summarize(total_gdp = sum(gdp))
#> `summarise()` has regrouped the output.
#> ℹ Summaries were computed grouped by continent and year.
#> ℹ Output is grouped by continent.
#> ℹ Use `summarise(.groups = "drop_last")` to silence this message.
#> ℹ Use `summarise(.by = c(continent, year))` for per-operation grouping
#>   (`?dplyr::dplyr_by`) instead.

plot_title <- "Total GDP by Continent 1952 - 2007"
```

``` r
plotjs_line <- function(x){
  plotjs(x$year, x$total_gdp, col.group = x$continent, sci.y = TRUE, 
         type = "l", main = plot_title, xlab = "Year", ylab = "GDP",
         legend.title = "Continent")
}

plotjs_line(gdp_cont)
```

``` r
ggplot_line <- function(x){
  ggplot(x, aes(x = year, y = total_gdp, col = continent, group = continent)) +
    geom_line() +
    theme_minimal() +
    labs(title = plot_title, x = "Year", y = "GDP")
}
ggplot_line(gdp_cont)
```

![](Benchmark_files/figure-html/unnamed-chunk-17-1.png)

``` r
ggplotly_line <- function(x){
  p <- ggplot(x, aes(x = year, y = total_gdp, col = continent)) +
    geom_line() +
    theme_minimal() +
    labs(title = plot_title, x = "Year", y = "GDP")
  ggplotly(p)
}

ggplotly_line(gdp_cont)
```

``` r
plotly_line <- function(x){
  plot_ly(data = x, x = ~year, y = ~total_gdp, split = ~continent,
          type = "scatter", color  = ~continent, mode = "lines")
}
plotly_line(gdp_cont)
```

Now let’s benchmark these line plot functions:

``` r
m2 <- microbenchmark(plotjs = plotjs_line(gdp_cont),
                     ggplotly = ggplotly_line(gdp_cont),
                     plotly = plotly_line(gdp_cont),
                     ggplot = ggplot_line(gdp_cont),
                     unit = "ms",
                     times = 50)
```

``` r
m2
#> Unit: milliseconds
#>      expr        min         lq        mean      median         uq        max
#>    plotjs   0.463314   0.532764   0.6301261   0.5986465   0.642979   2.652176
#>  ggplotly 179.573004 184.641246 192.8545299 189.3589645 193.147010 338.611483
#>    plotly   0.380349   0.457312   0.6396228   0.5213670   0.642929   3.929829
#>    ggplot  36.597703  38.241108  40.5238499  40.0043715  41.981022  48.433326
#>  neval
#>     50
#>     50
#>     50
#>     50
```

``` r
plot(m2)
```

![](Benchmark_files/figure-html/unnamed-chunk-22-1.png)

Let’s perform the same test as before:

``` r
w2 <- wilcox.test(m2$time[m2$expr == "plotjs"],
                 m2$time[m2$expr == "plotly"],
                 alternative = "less",
                 paired = FALSE)
w2
#> 
#>  Wilcoxon rank sum test with continuity correction
#> 
#> data:  m2$time[m2$expr == "plotjs"] and m2$time[m2$expr == "plotly"]
#> W = 1601, p-value = 0.9923
#> alternative hypothesis: true location shift is less than 0
```

Can we reject the null hypothesis that plotjs and plotly have the same
mean?

``` r
ifelse(w2$p.value < .05, "yes", "no")
#> [1] "no"
```

## Conclusions

Although benchmark results will vary on different systems, the results
on my development machine indicate that plotjs is faster than plotly
(and others) for both the scatter plot and grouped line plot tested.
Although statistically significant, the difference in performance
between plotjs and plotly would almost certainly never be perceptible to
users.

Both plotjs and direct use of plotly potentially offer perceptible
performance improvements over using
[`ggplotly()`](https://rdrr.io/pkg/plotly/man/ggplotly.html) to generate
interactive visualizations. Shiny developers may find this information
useful.
