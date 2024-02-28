test_that("List datasets errors are thrown", {
  expect_error(list_datasets(category = "dem"))
})

test_that("List datasets works as expected", {
  expect_s3_class(list_datasets("geospatial"), "data.frame")
  expect_identical(list_datasets("climate")[1, 1][[1]], "IDEAM_CLIMATE_2023_MAY")
  expect_length(list_datasets("climate"), 7L)
})

test_that("Dictionary errors are thrown", {
  expect_error(dictionary("DANE_MGN_2018"))
  expect_error(dictionary(4))
})

test_that("Dictionary works as expected", {
  expect_s3_class(dictionary("DANE_MGN_2018_DPTO"), "data.frame")
})
