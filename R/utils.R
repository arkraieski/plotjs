col2hex <- function(col) {
  rgb_matrix <- grDevices::col2rgb(col)
  grDevices::rgb(
    red = rgb_matrix[1, ],
    green = rgb_matrix[2, ],
    blue = rgb_matrix[3, ],
    maxColorValue = 255
  )
}

plotjsSizingPolicy <- function(padding = 8, browser.fill = TRUE) {
  htmlwidgets::sizingPolicy(
    padding = padding,
    browser.fill = browser.fill
  )
}
