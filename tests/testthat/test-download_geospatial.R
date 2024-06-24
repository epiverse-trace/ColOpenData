test_that("Download geospatial errors are thrown", {
  # Expect error on empty input
  expect_error(download_geospatial())

  # Expect error when spatial_level doe snot exist
  expect_error(download_geospatial("mpios"))

  # Expect error when both include_geom and include_cnpv are false
  expect_error(download_geospatial(
    spatial_level = "department",
    include_geom = FALSE,
    include_cnpv = FALSE
  ))
})

test_that("Download geospatial works as expected", {
  # Expect specific dataset from a proper request (only with geometry)
  expect_snapshot(download_geospatial(
    spatial_level = "department",
    include_geom = TRUE,
    include_cnpv = FALSE
  ))
})

test_that("Download geospatial works as expected with different parameters", {
  # Expect specific dataset from a proper request (only with census data)
  expect_snapshot(download_geospatial(
    spatial_level = "dpto",
    include_geom = FALSE,
    include_cnpv = TRUE
  ))
})
