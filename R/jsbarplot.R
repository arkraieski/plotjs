#' plotjs Bar Plots
#'
#' Creates a bar plot using 'Chart.js'.
#'
#' @param heights a vector of values describing the bars that make up the plot.
#' @param names.arg a vector of names to be plotted below each bar.
#' @param col a character string with the color for bars. This can be either a hex value or the name of an R built-in color.
#' @param main a main title for the plot.
#' @param ylab a label for the y axis.
#' @param width width of the widget to create for the plot. The default is NULL, which results in automatic resizing based on the plot's container.
#' @param height height of the widget to create for the plot. The default is NULL, which results in automatic resizing based on the plot's container.
#' @param elementId Use an explicit element ID for the widget, rather than an automatically generated one.
#' @param ... arguments passed from methods.
#' @import htmlwidgets
#'
#' @export
jsbarplot <- function(heights, names.arg = NULL, col = NULL, main = NULL, ylab = NULL,
                      width = NULL, height = NULL, elementId = NULL, ...) {

  if (!is.vector(heights) || !is.numeric(heights)) {
    stop("heights must be a numeric vector")
  }

  if (!is.null(names.arg) && length(names.arg) != length(heights)) {
    stop("heights and names.arg must be the same length")
  }

  if (!is.null(names.arg) && !is.character(names.arg)) {
    stop("names.arg must be NULL or a character vector")
  }

  if (!is.null(col)) {
    if (!grepl("^#(?:[0-9a-fA-F]{3}){1,2}$", col)) {
      r_colors <- colors()
      if (col %in% r_colors) colhex <- col2hex(col) else stop("Invalid color in col")
    } else {
      colhex <- col
    }
  } else {
    colhex <- NULL
  }

  x <- list(
    height = heights,
    categories = names.arg,
    col = colhex,
    main = main,
    ylab = ylab
  )

  htmlwidgets::createWidget(
    name = "jsbarplot",
    x,
    width = width,
    height = height,
    package = "plotjs",
    elementId = elementId,
    sizingPolicy = plotjsSizingPolicy()
  )
}

#' Factor Variable Bar Plots
#'
#' This function implements a bar plot method for \code{factor} arguments to the \code{\link{plotjs}} generic function. Bar heights will be counts for the factor levels.
#'
#' @param x a factor.
#' @param ylab a label for the y axis.
#' @param ... arguments passed to \code{\link{jsbarplot}}.
#' @method plotjs factor
#' @export
#' @seealso \code{\link[plotjs:jsbarplot]{jsbarplot()}}
#' @examples
#' mtcars <- mtcars
#' mtcars$cyl <- as.factor(mtcars$cyl)
#' plotjs(mtcars$cyl)
plotjs.factor <- function(x, ylab = "Count", ...) {
  h <- as.vector(table(x))
  jsbarplot(heights = h, names.arg = levels(x), ylab = ylab, ...)
}

#' Shiny bindings for jsbarplot
#'
#' Output and render functions for using jsbarplot within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a jsbarplot
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name jsbarplot-shiny
#'
#' @export
jsbarplotOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "jsbarplot", width, height, package = "plotjs")
}

#' @rdname jsbarplot-shiny
#' @export
renderJsbarplot <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  }
  htmlwidgets::shinyRenderWidget(expr, jsbarplotOutput, env, quoted = TRUE)
}
