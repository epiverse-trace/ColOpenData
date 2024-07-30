test_that("Merge geospatial and demographic errors are thrown", {
  # Expect error when demographic_dataset does not exist
  expect_error(merge_geo_demographic("DANE_CNPVH_2018_1HZ"))
})

test_that("Merge geospatial and demographic works as expected", {
  # Expect specific dataset from a proper request
  expect_snapshot(merge_geo_demographic("DANE_CNPVH_2018_1HD"))
})

test_that("Merge geospatial and demographic has the correct class", {
  # Expect object to be an sf data.frame
  expect_s3_class(
    merge_geo_demographic("DANE_CNPVH_2018_1HM"),
    c("sf", "data.frame")
  )
})
