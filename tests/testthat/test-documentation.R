test_that("List datasets errors are thrown", {
  expect_error(list_datasets(category = "dem"))
})

test_that("List datasets works as expected", {
  expect_snapshot(list_datasets("geospatial"))
})

test_that("Dictionary errors are thrown", {
  expect_error(dictionary("DANE_MGN_2018"))
  expect_error(dictionary(4))
  expect_error(dictionary("DANE_CNPVPS_2018_10HM"))
})

test_that("Dictionary works as expected", {
  expect_snapshot(dictionary("DANE_MGN_2018_DPTO"))
})

test_that("Lookup errors are thrown", {
  expect_error(look_up(keywords = 0L))
  expect_error(look_up(keywords = "dog"))
  expect_error(look_up(keywords = "households", logic = TRUE))
  expect_error(look_up(keywords = "households", logic = "nor"))
  expect_error(look_up(module = "population", keywords = "households"))
})

test_that("Lookup works as expected", {
  expect_s3_class(look_up(keywords = "school", logic = "or"), "data.frame")
  expect_snapshot(look_up(keywords = c("school", "age"), logic = "and"))
})
