test_that("Merge geospatial and demographic errors are thrown", {
  skip_on_cran()

  # Expect error when demographic_dataset does not exist
  expect_error(merge_geo_demographic("DANE_CNPVH_2018_1HZ"))
})

test_that("Merge geospatial and demographic works as expected", {
  skip_on_cran()

  # Expect specific dataset from a proper request
  expect_snapshot(merge_geo_demographic("DANE_CNPVH_2018_1HD"))
})
