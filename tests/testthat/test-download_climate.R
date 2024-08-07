# Region without stations
lat_1 <- c(5.644531, 5.644531, 5.59963, 5.59963, 5.644531)
lon_1 <- c(-73.30733, -73.28177, -73.28177, -73.30733, -73.30733)
polygon_1 <- sf::st_polygon(x = list(cbind(lon_1, lat_1))) %>% sf::st_sfc()
no_stations_area <- sf::st_as_sf(polygon_1)

# Region with stations
lat_2 <- c(4.172817, 4.172817, 4.136050, 4.136050, 4.172817)
lon_2 <- c(-74.749121, -74.686169, -74.686169, -74.749121, -74.749121)
polygon_2 <- sf::st_polygon(x = list(cbind(lon_2, lat_2))) %>% sf::st_sfc()
apicala <- sf::st_as_sf(polygon_2)

# Retrieve existing stations
stations_test <- stations_in_roi(apicala)

## Stations in ROI
test_that("Stations in ROI throws errors", {
  # Expect error when geometry is not an sf data.frame
  expect_error(stations_in_roi("geometry"))

  # Expect error when the introduced region contains no stations
  expect_error(stations_in_roi(no_stations_area))
})

test_that("Stations in ROI works as expected", {
  # Expect specific dataset on request
  expect_snapshot(stations_test)
})

## Climate data from stations
test_that("Climate Stations throws errors", {
  # Expect error when stations is not a data.frame
  expect_error(download_climate_stations(
    stations = "bogota",
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    tag = "PTPM_CON"
  ))

  # Expect error when start_date is not a character
  expect_error(download_climate_stations(
    stations = stations_test,
    start_date = 2010,
    end_date = "2010-12-10",
    tag = "PTPM_CON"
  ))

  # Expect error when end_date is not a character
  expect_error(download_climate_stations(
    stations = stations_test,
    start_date = "2010-12-10",
    end_date = 675,
    tag = "PTPM_CON"
  ))

  # Expect error when tag does not exist
  expect_error(download_climate_stations(
    stations = stations_test,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    tag = "PTPM_CONS"
  ))

  # Expect error when end_date is lower than start_date
  expect_error(download_climate_stations(
    stations = stations_test,
    start_date = "2013-10-01",
    end_date = "2010-12-10",
    tag = "NB_CON"
  ))

  # Expect error when start_date is not a character that can be formatted as
  # "YYY-MM-DD"
  expect_error(download_climate_stations(
    stations = stations_test,
    start_date = "10-10",
    end_date = "2010-12-10",
    tag = "PTPM_CON"
  ))

  # Expect error when there is no data available for the given dates
  expect_error(download_climate_stations(
    stations = stations_test,
    start_date = "1900-01-10",
    end_date = "1900-01-13",
    tag = "PTPM_CON"
  ))
})

test_that("Climate Stations works as expected", {
  # Expect specific dataset on request
  expect_snapshot(download_climate_stations(
    stations = stations_test,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    tag = "PTPM_CON"
  ))
})

## Climate data from geometry
test_that("Climate data from geometry throws errors", {
  # Expect error when geometry is not an sf data.frame
  expect_error(download_climate_geom(
    geometry = "bogota",
    start_date = "2010-01-01",
    end_date = "2010-02-10",
    tag = "PTPM_CON"
  ))
})

test_that("Climate data from geometry works as expected", {
  # Expect specific dataset on request
  expect_snapshot(download_climate_geom(
    geometry = apicala,
    start_date = "2010-10-01",
    end_date = "2010-11-10",
    tag = "PTPM_CON"
  ))
})

## Climate Stations from municipality (mpio)
test_that("Climate data from code throws errors", {
  # Expect error when code is not a character
  expect_error(download_climate(
    code = 73148,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    tag = "PTPM_CON"
  ))

  # Expect error when code is not 2 (department) or 5 (municipality) characters
  # long
  expect_error(download_climate(
    code = "730001",
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    tag = "PTPM_CON"
  ))

  # Expect error when code does not exist in DIVIPOLA codes
  expect_error(download_climate(
    code = "04",
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    tag = "PTPM_CON"
  ))
})

test_that("Climate data from code works as expected", {
  # Expect specific dataset from a proper request
  expect_snapshot(download_climate(
    code = "73148",
    start_date = "2018-10-01",
    end_date = "2018-11-10",
    tag = "PTPM_CON"
  ))
})
