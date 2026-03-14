
context('plotjs.default')

mtcars <- mtcars




test_that("plotjs.default creates an htmlwidget", {

  p <- plotjs(mtcars$hp, mtcars$qsec)

  expect_is(p, "plotjsScatter")
  expect_is(p, "htmlwidget")
  expect_equal(p$x$data$plot_type, "scatter")
})




test_that("plotjs.default works with an R built-in color name for col", {

  c <- plotjs(mtcars$hp, mtcars$mpg, col = "chartreuse")

  expect_is(c, "plotjsScatter")
  expect_is(c, "htmlwidget")
  expect_equal(c$x$data$col_hex, "#7FFF00")
})

mtcars$cyl <- as.factor(mtcars$cyl)



test_that("coloring by group works in plotjs()",{

  g <- plotjs(mtcars$hp, mtcars$mpg, col.group = mtcars$cyl)

  expect_is(g, "plotjsScatter")
  expect_is(g, "htmlwidget")
  expect_equal(g$x$data$legend$text, "mtcars$cyl")
  expect_equal(names(g$x$data$grouped_data$x), levels(mtcars$cyl))

})

test_that("plotjs() throws an invalid color error",{
  expect_error(plotjs(x = mtcars$mpg, y = mtcars$qsec, col = "fakecolor"), "Invalid colors")
})


test_that("plotjs() works with a list of color names", {
  mtcars$cyl <- as.factor(mtcars$cyl)
  cg <- plotjs(mtcars$disp, mtcars$mpg, col.group = mtcars$cyl, col = c("blue", "red", "black"))

  expect_is(cg, "plotjsScatter")
  expect_is(cg, "htmlwidget")
  expect_equal(cg$x$data$col_hex, c("#0000FF", "#FF0000", "#000000"))
})

test_that("plotjs() forwards zoom and grouped payload fields", {
  z <- plotjs(mtcars$disp, mtcars$mpg, col.group = mtcars$cyl, zoom = FALSE, legend.position = "bottom")

  expect_false(z$x$data$zoom)
  expect_equal(z$x$data$legend$position, "bottom")
  expect_equal(z$x$data$group_names, levels(mtcars$cyl))
})

context("plotjs.lm")

test_that("plotjs.lm() creates an html widget",{
  lm.SR <- lm(sr ~ pop15 + pop75 + dpi + ddpi, data = LifeCycleSavings)
  l <- plotjs(lm.SR)

  expect_is(l, "plotjsScatter")
  expect_is(l, "htmlwidget")
  }
)


context("plotjs.function")

test_that("plotjs.function() works",{
  q <- plotjs(qnorm)

  expect_is(q, "plotjsScatter")
  expect_is(q, "htmlwidget")
})

test_that("plotjspie() preserves label mode and legend settings", {
  p <- plotjspie(c(2, 3), labels = c("A", "B"), slice.text = "id", legend.position = "bottom")

  expect_is(p, "plotjspie")
  expect_equal(p$x$label_mode, "id")
  expect_equal(p$x$legend$position, "bottom")
  expect_false(p$x$donut)
})

test_that("plotjspie() supports donut charts", {
  p <- plotjspie(c(2, 3), labels = c("A", "B"), donut = TRUE)

  expect_is(p, "plotjspie")
  expect_true(p$x$donut)
  expect_error(plotjspie(c(2, 3), labels = c("A", "B"), donut = NA), "donut must be TRUE or FALSE")
})
