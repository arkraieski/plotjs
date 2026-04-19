context("jsbarplot")




test_that("jsbarplot() works for a simple example", {
  b <- jsbarplot(c(100, 30), names.arg = c("Red Sox", "Yankees"), ylab = "% Awesome", main = "Awesomeness of Baseball Teams")

  expect_is(b, "jsbarplot")
  expect_is(b, "htmlwidget")
  expect_equal(b$x$categories, c("Red Sox", "Yankees"))
})

test_that("jsbarplot() works with a named color", {
  c <- jsbarplot(c(100, 30), names.arg = c("Red Sox", "Yankees"), ylab = "% Awesome", col = "red", main = "Awesomeness")

  expect_is(c, "jsbarplot")
  expect_is(c, "htmlwidget")
  expect_equal(c$x$col, "#FF0000")
})


test_that("jsbarplot() works with a hex color", {
  h <- jsbarplot(c(100, 30), names.arg = c("Red Sox", "Yankees"), ylab = "% Awesome", col = "#FF2800", main = "Awesomeness")

  expect_is(h, "jsbarplot")
  expect_is(h, "htmlwidget")
})


test_that("you can set the aria-label attribute for jsbarplot", {
  b <- jsbarplot(c(100, 30),
                 names.arg = c("Red Sox", "Yankees"),
                 ylab = "% Awesome",
                 main = "Awesomeness of Baseball Teams",
                 aria.label = "Baseball team awesomeness")

  expect_equal(b$x$aria_label, "Baseball team awesomeness")
})


context("plotjs.factor")

test_that("plotjs.factor works", {
  mtcars <- mtcars
  mtcars$cyl <- as.factor(mtcars$cyl)

  f <- plotjs(mtcars$cyl)

  expect_is(f, "jsbarplot")
  expect_is(f, "htmlwidget")

})

test_that("you can set the aria-label attribute for plotjs.factor", {
  mtcars <- mtcars
  mtcars$cyl <- as.factor(mtcars$cyl)

  f <- plotjs(mtcars$cyl, aria.label = "Number of cylinders")

  expect_equal(f$x$aria_label, "Number of cylinders")
})


