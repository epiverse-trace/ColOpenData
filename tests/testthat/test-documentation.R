test_that("List datasets errors are thrown", {
  expect_error(list_datasets(category = "dem"))
})

test_that("List datasets works as expected", {
  expect_snapshot(list_datasets("geospatial"))
})

test_that("Dictionary errors are thrown", {
  expect_error(dictionary("DANE_MGN_2018"))
  expect_error(dictionary(4))
})

test_that("Dictionary works as expected", {
  expect_snapshot(dictionary("DANE_MGN_2018_DPTO"))
})
