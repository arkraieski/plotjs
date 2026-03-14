# Factor Variable Bar Plots

This function implements a bar plot method for `factor` arguments to the
[`plotjs`](plotjs.md) generic function. Bar heights will be counts for
the factor levels.

## Usage

``` r
# S3 method for class 'factor'
plotjs(x, ylab = "Count", ...)
```

## Arguments

- x:

  a factor.

- ylab:

  a label for the y axis.

- ...:

  arguments passed to [`plotjsbarplot`](plotjsbarplot.md).

## See also

[`plotjsbarplot()`](plotjsbarplot.md)

## Examples

``` r
mtcars <- mtcars
mtcars$cyl <- as.factor(mtcars$cyl)
plotjs(mtcars$cyl)

{"x":{"height":[11,7,14],"categories":["4","6","8"],"col":null,"main":null,"ylab":"Count"},"evals":[],"jsHooks":[]}
```
