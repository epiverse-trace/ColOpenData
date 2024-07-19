test_that("List datasets errors are thrown", {
  # Expect error when category does not exist
  expect_error(list_datasets(language = "EN", module = "dem"))

  # Expect error when language does not exist
  expect_error(list_datasets(language = "FR", module = "demographic"))
})

test_that("List datasets works as expected", {
  # Expect specific dataset from a proper request
  expect_snapshot(list_datasets(language = "EN", module = "geospatial"))
})

test_that("Dictionary errors are thrown", {
  # Expect error when spatial_level does not exist
  expect_error(geospatial_dictionary("EN", "DANE_MGN_2018_MPIO"))

  # Expect error when language does not exist
  expect_error(geospatial_dictionary("IT", "DANE_MGN_2018_MPIO"))
})

test_that("Dictionary works as expected", {
  # Expect specific dataset from a proper request
  expect_snapshot(geospatial_dictionary("EN", "mpio"))
})

test_that("Climate tags works as expected", {
  # Expect specific dataset from a proper request (no arguments for this
  # function)
  expect_snapshot(get_climate_tags())
})

test_that("Lookup errors are thrown", {
  # Expect error when keywords is not a character
  expect_error(look_up(keywords = 0L))

  # Expect error when keywords are not found in any dataset
  expect_error(look_up(keywords = "dog"))

  # Expect error when logic is TRUE or FALSE (as presented in documentation, it
  # will respond to "and" / "or")
  expect_error(look_up(keywords = "households", logic = TRUE))
  expect_error(look_up(keywords = "households", logic = "nor"))

  # Expect error when module does not exist
  expect_error(look_up(module = "population", keywords = "households"))

  # Expect error when language does not exist
  expect_error(look_up(language = "PT"))
})

test_that("Lookup works as expected", {
  # Expect that output has a data.frame structure for a proper request
  expect_s3_class(look_up(language = "EN", keywords = "school", logic = "or"), "data.frame")

  # Expect specific dataset from a proper request
  expect_snapshot(look_up(language = "EN", keywords = c("school", "age"), logic = "and"))
})
