# Sample regions for test
mpios <- ColOpenData::download_geospatial("DANE_MGNCNPV_2018_MPIO")
# Region without stations
oicata <- mpios[which(mpios$MPIO_CDPMP == "15500"), ]
# Regions with stations
medellin <- mpios[which(mpios$MPIO_CDPMP == "05615"), ]
ibague <- mpios[which(mpios$MPIO_CDPMP == "73001"), ]
# Retrieve existing stations
stations_test <- stations_in_roi(ibague)
stations_names <- stations_test$codigo

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
  expect_error(retrieve_climate_data(
    stations = "bogota",
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "day",
    tags = "PTPM_CON",
    aggregate = TRUE
  ))
  expect_error(retrieve_climate_data(
    stations = stations_names,
    start_date = 2010,
    end_date = "2010-12-10",
    frequency = "day",
    tags = "PTPM_CON",
    aggregate = TRUE
  ))
  expect_error(retrieve_climate_data(
    stations = stations_names,
    start_date = "2010-12-10",
    end_date = 675,
    frequency = "day",
    tags = "PTPM_CON",
    aggregate = TRUE
  ))
  expect_error(climate_stations(
    stations = stations_names,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "months",
    tags = "PTPM_CON",
    aggregate = TRUE
  ))
  expect_error(retrieve_climate_data(
    stations = stations_names,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = "ERR",
    aggregate = TRUE
  ))
  expect_error(retrieve_climate_data(
    stations = stations_names,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = c("TSSM_CON", "ERR"),
    aggregate = TRUE
  ))
  expect_error(retrieve_climate_data(
    stations = stations_names,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = "TSSM_CON",
    aggregate = "TRUE"
  ))
})

test_that("Climate Stations works as expected", {
  expect_s3_class(retrieve_climate_data(
    stations = stations_names,
    start_date = "2010-10-01",
    end_date = "2011-02-10",
    frequency = "month",
    tags = "TSSM_CON",
    aggregate = TRUE
  ), "data.frame")
  expect_type(retrieve_climate_data(
    stations = stations_names,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = c("THSM_CON", "TSSM_CON"),
    aggregate = FALSE
  ), "list")
  expect_s3_class(retrieve_climate_data(
    stations = stations_names,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = c("THSM_CON", "TSSM_CON"),
    aggregate = TRUE
  ), "data.frame")
  expect_length(retrieve_climate_data(
    stations = stations_names,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = c("THSM_CON", "TSSM_CON"),
    aggregate = TRUE
  ), 3L)
})

test_that("Climate data from geometry throws errors", {
  expect_error(download_climate_geom(
    geometry = "bogota",
    start_date = "2010-01-01",
    end_date = "2010-02-10",
    frequency = "day",
    tags = "TSSM_CON"
  ))
})

test_that("Climate data from geometry works as expected", {
  expect_s3_class(download_climate_geom(
    geometry = ibague,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "day",
    tags = "PTPM_CON"
  ), "data.frame")
  expect_length(download_climate_geom(
    geometry = ibague,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "week",
    tags = "PTPM_CON",
    aggregate = TRUE
  ), 2)
  expect_length(download_climate_geom(
    geometry = ibague,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = "EVTE_CON",
    aggregate = TRUE
  ), 2)
  expect_length(download_climate_geom(
    geometry = ibague,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = c("TMN_CON", "HRHG_CON"),
    aggregate = TRUE
  ), 3)
  expect_type(download_climate_geom(
    geometry = ibague,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = c("TMN_CON", "BSHG_CON"),
    aggregate = FALSE
  ), "list")
})

# Climate Stations Mpio
test_that("Climate data from code throws errors", {
  expect_error(download_climate(
    code = 73001,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "day",
    tags = "PTPM_CON",
    aggregate = TRUE
  ))
})

test_that("Climate data from code works as expected", {
  expect_s3_class(download_climate(
    code = "05001",
    start_date = "2018-10-01",
    end_date = "2018-11-10",
    frequency = "day",
    tags = "THSM_CON",
    aggregate = FALSE
  ), "data.frame")
  expect_vector(download_climate(
    code = "05001",
    start_date = "2018-10-01",
    end_date = "2018-11-10",
    frequency = "month",
    tags = "NB_CON",
    aggregate = TRUE
  )[, 2], size = 2)
  expect_identical(dim(download_climate(
    code = "05001",
    start_date = "2017-01-01",
    end_date = "2019-12-31",
    frequency = "year",
    tags = "TSTG_CON",
    aggregate = TRUE
  ))[1], 3L)
  expect_type(download_climate(
    code = "11001",
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = c("TMN_CON", "BSHG_CON"),
    aggregate = FALSE
  ), "list")
})