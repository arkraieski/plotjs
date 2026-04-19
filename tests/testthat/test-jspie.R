context('jspie')

test_that("jspie() preserves label mode and legend settings", {
  p <- jspie(c(2, 3), labels = c("A", "B"), slice.text = "id", legend.position = "bottom")

  expect_is(p, "jspie")
  expect_equal(p$x$label_mode, "id")
  expect_equal(p$x$legend$position, "bottom")
  expect_false(p$x$donut)
})

test_that("jspie() supports donut charts", {
  p <- jspie(c(2, 3), labels = c("A", "B"), donut = TRUE)

  expect_is(p, "jspie")
  expect_true(p$x$donut)
  expect_error(jspie(c(2, 3), labels = c("A", "B"), donut = NA), "donut must be TRUE or FALSE")
})
