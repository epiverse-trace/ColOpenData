test_that("Download population projections errors are thrown", {
  # Expect error when spatial_level is incorrect
  expect_error(download_pop_projections(
    spatial_level = "depto",
    start_year = 2010,
    end_year = 2020
  ))
  # Expect error when ethnic is TRUE for a spatial_level different from
  # municipality (Only available for municipality from source)
  expect_error(download_pop_projections(
    spatial_level = "department",
    start_year = 2010,
    end_year = 2020,
    include_ethnic = TRUE
  ))
  # Expect error when start_year is older than minimum available date
  expect_error(download_pop_projections(
    spatial_level = "department",
    start_year = 1900,
    end_year = 2020
  ))
  # Expect error when start_year is older than maximum available date
  expect_error(download_pop_projections(
    spatial_level = "department",
    start_year = 2000,
    end_year = 2096
  ))
})

test_that("Download pop_projections works as expected", {
  # Expect specific dataset from a proper request
  expect_snapshot(download_pop_projections(
    spatial_level = "department",
    start_year = 2010,
    end_year = 2027
  ))
})
