#' plotjs Pie Charts
#'
#' Draw an interactive pie chart using 'Chart.js'
#'
#' @param x a vector of non-negative numerical quantities. The values in x are displayed as the areas of pie slices.
#' @param labels character vector giving names for the slices.
#' @param col character vector of colors to be used in filling the slices. Can be a hex value or an R built-in color name.
#' @param slice.text \code{"pct"} to display percentage-formatted values inside pie slices or \code{"id"} to display the slice's name from \code{labels}.
#' @param donut logical; should the chart be rendered as a donut chart instead of a full pie?
#' @param legend.position Position of the legend. Possible values are \code{"right"}, \code{"bottom"}, \code{"inset"}, and \code{"hide"}.
#' @param main a main title for the plot.
#' @param width width of the widget to create for the plot. The default is NULL, which results in automatic resizing based on the plot's container.
#' @param height height of the widget to create for the plot. The default is NULL, which results in automatic resizing based on the plot's container.
#' @param elementId Use an explicit element ID for the widget, rather than an automatically generated one.
#' @param aria.label a character string set as the \code{aria-label} attribute on the chart's canvas element for accessibility.
#' @import htmlwidgets
#' @importFrom grDevices colors
#' @examples
#'
#' pie.sales <- c(0.12, 0.3, 0.26, 0.16, 0.04, 0.12)
#' names(pie.sales) <- c("Blueberry", "Cherry",
#'                     "Apple", "Boston Cream", "Other", "Vanilla Cream")
#' jspie(pie.sales)
#' jspie(pie.sales, col = c("purple", "violetred1", "green3",
#'                      "cornsilk", "cyan", "white"))
#' jspie(pie.sales, donut = TRUE)
#'
#' @export
jspie <- function(x, labels = names(x), col = NULL, slice.text = "pct",
                  donut = FALSE, legend.position = "right", main = NULL,
                  width = NULL, height = NULL, elementId = NULL, aria.label = NULL) {

  if (length(x) != length(labels)) {
    stop("x and labels must be the same length")
  }
  if (!is.null(col)) {
    if (!is.character(col)) {
      stop("col must be a character vector", call. = FALSE)
    }
    if (length(col) != length(x)) {
      stop("col is not same length as x")
    }
    col_hexes <- ifelse(col %in% colors(), col2hex(col), col)
    if (any(!grepl("^#(?:[0-9a-fA-F]{3}){1,2}$", col_hexes))) {
      stop("Invalid colors in col. Run colors() to see all supported color names", call. = FALSE)
    }
  } else {
    col_hexes <- NULL
  }

  if (!(slice.text %in% c("pct", "id"))) {
    stop("labels must be 'pct' or 'id'")
  }

  if (!is.logical(donut) || length(donut) != 1 || is.na(donut)) {
    stop("donut must be TRUE or FALSE", call. = FALSE)
  }

  if (!(legend.position %in% c("bottom", "right", "inset", "hide"))) {
    stop("legend position must be 'right', 'bottom', 'inset', or 'hide'")
  }

  legend <- list(
    position = ifelse(legend.position == "hide", NULL, legend.position),
    hide = legend.position == "hide"
  )

  x <- list(
    labels = labels,
    values = unname(x),
    colors = col_hexes,
    main = main,
    label_mode = slice.text,
    donut = donut,
    legend = legend,
    aria_label = aria.label
  )

  htmlwidgets::createWidget(
    name = "jspie",
    x,
    width = width,
    height = height,
    package = "plotjs",
    elementId = elementId,
    sizingPolicy = plotjsSizingPolicy()
  )
}

#' Shiny bindings for jspie
#'
#' Output and render functions for using jspie within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a jspie
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name jspie-shiny
#'
#' @export
jspieOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "jspie", width, height, package = "plotjs")
}

#' @rdname jspie-shiny
#' @export
renderJspie <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  }
  htmlwidgets::shinyRenderWidget(expr, jspieOutput, env, quoted = TRUE)
}
