# Sample regions for test
mpios <- ColOpenData::download_geospatial("DANE_MGN_2018_MPIO")
# Region without stations
oicata <- mpios[which(mpios$MPIO_CDPMP == "15500"), ]
# Regions with stations
medellin <- mpios[which(mpios$MPIO_CDPMP == "05615"), ]
ibague <- mpios[which(mpios$MPIO_CDPMP == "73001"), ]
# Retrieve existing stations
stations_test <- stations_in_roi(ibague)

# Stations in ROI
test_that("Stations in ROI throws errors", {
  expect_error(stations_in_roi("geometry"))
  expect_error(stations_in_roi(oicata))
})

test_that("Stations in ROI work as expected", {
  expect_s3_class(stations_in_roi(medellin), "data.frame")
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
    stations = stations_test,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    tag = c("TSSM_CON", "PTPM_CON")
  ))
})

test_that("Climate data from geometry throws errors", {
  expect_error(download_climate_geom(
    geometry = "bogota",
    start_date = "2010-01-01",
    end_date = "2010-02-10",
    tag = "TSSM_CON"
  ))
})

test_that("Climate data from geometry works as expected", {
  expect_s3_class(download_climate_geom(
    geometry = ibague,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    tag = "PTPM_CON"
  ), "data.frame")
  expect_length(download_climate_geom(
    geometry = ibague,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    tag = "TSSM_CON"
  ), 7L)
  expect_identical(colnames(download_climate_geom(
    geometry = ibague,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
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
    code = "11111",
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    tag = "PTPM_CON"
  ))
})

test_that("Climate data from code works as expected", {
  expect_s3_class(download_climate(
    code = "05001",
    start_date = "2018-10-01",
    end_date = "2018-11-10",
    tag = "THSM_CON"
  ), "data.frame")
})
