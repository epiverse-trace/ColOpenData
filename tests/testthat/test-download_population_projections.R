test_that("Download population projections errors are thrown", {
  expect_error(download_pop_projections(
    spatial_level = "depto",
    start_year = 2010,
    end_year = 2020
  ))
  expect_error(download_pop_projections(
    spatial_level = "department",
    start_year = 2010,
    end_year = 2020,
    include_ethnic = TRUE
  ))
  expect_error(download_pop_projections(
    spatial_level = "department",
    start_year = 1900,
    end_year = 2020
  ))
  expect_error(download_pop_projections(
    spatial_level = "department",
    start_year = 2000,
    end_year = 2096
  ))
})

test_that("Download pop_projections works as expected", {
  expect_snapshot(download_pop_projections(
    spatial_level = "department",
    start_year = 2010,
    end_year = 2027
  ))
})
