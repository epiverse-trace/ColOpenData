# Region without stations
lat_1 <- c(5.644531, 5.644531, 5.59963, 5.59963, 5.644531)
lon_1 <- c(-73.30733, -73.28177, -73.28177, -73.30733, -73.30733)
polygon_1 <- sf::st_polygon(x = list(cbind(lon_1, lat_1))) %>% sf::st_sfc()
no_stations_area <- sf::st_as_sf(polygon_1)

# Region with stations
lat_2 <- c(4.700691, 4.700691, 4.256457, 4.256457, 4.700691)
lon_2 <- c(-75.5221, -74.96571, -74.96571, -75.5221, -75.5221)
polygon_2 <- sf::st_polygon(x = list(cbind(lon_2, lat_2))) %>% sf::st_sfc()
ibague <- sf::st_as_sf(polygon_2)

# Retrieve existing stations
stations_test <- stations_in_roi(ibague)

# Stations in ROI
test_that("Stations in ROI throws errors", {
  expect_error(stations_in_roi("geometry"))
  expect_error(stations_in_roi(no_stations_area))
})

test_that("Stations in ROI works as expected", {
  expect_snapshot(stations_test)
  expect_s3_class(stations_in_roi(ibague), "data.frame")
})

# Climate stations
test_that("Climate Stations throws errors", {
  expect_error(download_climate_stations(
    stations = "bogota",
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    tag = "PTPM_CON"
  ))
  expect_error(download_climate_stations(
    stations = stations_test,
    start_date = 2010,
    end_date = "2010-12-10",
    tag = "PTPM_CON"
  ))
  expect_error(download_climate_stations(
    stations = stations_test,
    start_date = "2010-12-10",
    end_date = 675,
    tag = "PTPM_CON"
  ))
  expect_error(download_climate_stations(
    stations = stations_test,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    tag = "PTPM_CONS"
  ))
  expect_error(download_climate_stations(
    stations = stations_test,
    start_date = "2013-10-01",
    end_date = "2010-12-10",
    tag = "NB_CON"
  ))
  expect_error(download_climate_stations(
    stations = "bogota",
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    tag = "PTPM_CON"
  ))
  expect_error(download_climate_stations(
    stations = stations_test,
    start_date = "10-10",
    end_date = "2010-12-10",
    tag = "TSSM_CON"
  ))
  expect_error(download_climate_stations(
    stations = stations_test,
    start_date = "1900-01-10",
    end_date = "1900-01-13",
    tag = "TSSM_CON"
  ))
})

test_that("Climate Stations works as expected", {
  expect_snapshot(download_climate_stations(
    stations = stations_test,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    tag = "PTPM_CON"
  ))
})

# Climate data from geometry
test_that("Climate data from geometry throws errors", {
  expect_error(download_climate_geom(
    geometry = "bogota",
    start_date = "2010-01-01",
    end_date = "2010-02-10",
    tag = "TSSM_CON"
  ))
})

test_that("Climate data from geometry works as expected", {
  expect_snapshot(download_climate_geom(
    geometry = ibague,
    start_date = "2010-10-01",
    end_date = "2010-11-10",
    tag = "PTPM_CON"
  ))
  expect_identical(colnames(download_climate_geom(
    geometry = ibague,
    start_date = "2020-01-01",
    end_date = "2020-02-10",
    tag = "TMN_CON"
  )), c(
    "station", "longitude", "latitude", "date",
    "hour", "tag", "value"
  ))
})

# Climate Stations Mpio
test_that("Climate data from code throws errors", {
  expect_error(download_climate(
    code = 73001,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    tag = "PTPM_CON"
  ))
  expect_error(download_climate(
    code = "730001",
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    tag = "PTPM_CON"
  ))
  expect_error(download_climate(
    code = "04",
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    tag = "PTPM_CON"
  ))
})

test_that("Climate data from code works as expected", {
  expect_snapshot(download_climate(
    code = "05001",
    start_date = "2018-10-01",
    end_date = "2018-11-10",
    tag = "THSM_CON"
  ))
})
