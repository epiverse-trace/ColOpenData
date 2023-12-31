# Region without stations
mpios <- ColOpenData::download_geospatial("DANE_MGNCNPV_2018_MPIO")
oicata <- mpios[which(mpios$MPIO_CDPMP == "15500"), ]
medellin <- mpios[which(mpios$MPIO_CDPMP == "05615"), ]
# Retrieve Working Stations
ibague <- mpios[which(mpios$MPIO_CDPMP == "73001"), ]
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


test_that("Retrieve Working Stations throws errors", {
  expect_error(retrieve_working_stations(
    stations = data.frame(
      a = c("a5555", "p910002", "000011"),
      stringsAsFactors = FALSE
    ),
    start_date = "2010-01-01",
    end_date = "2010-02-10",
    frequency = "day",
    tag = "TSSM_CON"
  ))
  expect_error(retrieve_working_stations(
    stations = stations_names,
    start_date = 2010,
    end_date = "2010-02-10",
    frequency = "day",
    tag = "TSSM_CON"
  ))
  expect_error(retrieve_working_stations(
    stations = stations_names,
    start_date = "2010-01-01",
    end_date = 2010,
    frequency = "day",
    tag = "TSSM_CON"
  ))
  expect_error(retrieve_working_stations(
    stations = stations_names,
    start_date = "2010-01-01",
    end_date = "2010-02-10",
    frequency = "years",
    tag = "TSSM_CON"
  ))
  expect_error(retrieve_working_stations(
    stations = stations_names,
    start_date = "2010-01-01",
    end_date = "2010-02-10",
    frequency = "day",
    tag = "TTMM_CON"
  ))
})

test_that("Retrieve Working Stations works as expected", {
  expect_s3_class(retrieve_working_stations(
    stations = stations_names,
    start_date = "2013-01-01",
    end_date = "2013-02-01",
    frequency = "day",
    tag = "TSSM_CON"
  ), "data.frame")
  expect_length(retrieve_working_stations(
    stations = stations_names,
    start_date = "2013-01-01",
    end_date = "2013-02-01",
    frequency = "day",
    tag = "PTPM_CON"
  ), 16L)
})

# Weather stations
test_that("Weather Stations throws errors", {
  expect_error(weather_stations(
    stations = "bogota",
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "day",
    tags = "PTPM_CON",
    group = TRUE
  ))
  expect_error(weather_stations(
    stations = stations_names,
    start_date = 2010,
    end_date = "2010-12-10",
    frequency = "day",
    tags = "PTPM_CON",
    group = TRUE
  ))
  expect_error(weather_stations(
    stations = stations_names,
    start_date = "2010-12-10",
    end_date = 675,
    frequency = "day",
    tags = "PTPM_CON",
    group = TRUE
  ))
  expect_error(weather_stations(
    stations = stations_names,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "months",
    tags = "PTPM_CON",
    group = TRUE
  ))
  expect_error(weather_stations(
    stations = stations_names,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = "ERR",
    group = TRUE
  ))
  expect_error(weather_stations(
    stations = stations_names,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = "ERR",
    group = TRUE
  ))
})

test_that("Weather Stations works as expected", {
  expect_s3_class(weather_stations(
    stations = stations_names,
    start_date = "2010-10-01",
    end_date = "2011-02-10",
    frequency = "month",
    tags = "TSSM_CON",
    group = TRUE
  ), "data.frame")
  expect_type(weather_stations(
    stations = stations_names,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = c("THSM_CON", "TSSM_CON"),
    group = FALSE
  ), "list")
  expect_s3_class(weather_stations(
    stations = stations_names,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = c("THSM_CON", "TSSM_CON"),
    group = TRUE
  ), "data.frame")
  expect_length(weather_stations(
    stations = stations_names,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = c("THSM_CON", "TSSM_CON"),
    group = TRUE
  ), 3L)
})

test_that("Weather Data throws errors", {
  expect_error(download_weather(
    geometry = "bogota",
    start_date = "2010-01-01",
    end_date = "2010-02-10",
    frequency = "day",
    tags = "TSSM_CON"
  ))
  expect_error(download_weather(
    geometry = ibague,
    start_date = 20100210,
    end_date = "2010-02-10",
    frequency = "day",
    tags = "TSSM_CON"
  ))
  expect_error(download_weather(
    geometry = ibague,
    start_date = "2010-01-01",
    end_date = 20100310,
    frequency = "day",
    tags = "TSSM_CON"
  ))
  expect_error(download_weather(
    geometry = ibague,
    start_date = "2010-01-01",
    end_date = "2010-02-10",
    frequency = "dday",
    tags = "TSSM_CON"
  ))
  expect_error(download_weather(
    geometry = ibague,
    start_date = "2010-01-01",
    end_date = "2010-02-10",
    frequency = "day",
    tags = "TSSM_CONS"
  ))
})

test_that("Weather Stations works as expected", {
  expect_s3_class(download_weather(
    geometry = ibague,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "day",
    tags = "PTPM_CON"
  ), "data.frame")
  expect_length(download_weather(
    geometry = ibague,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "week",
    tags = "PTPM_CON",
    group = TRUE
  ), 2)
  expect_length(download_weather(
    geometry = ibague,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = "EVTE_CON",
    group = TRUE
  ), 2)
  expect_length(download_weather(
    geometry = ibague,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = c("TMN_CON", "HRHG_CON"),
    group = TRUE
  ), 3)
  expect_type(download_weather(
    geometry = ibague,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = c("TMN_CON", "BSHG_CON"),
    group = FALSE
  ), "list")
})

# Weather Stations Mpio
test_that("Weather stations by municipality throws errors", {
  expect_error(download_weather_mpio(
    name = 5001,
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "day",
    tags = "PTPM_CON",
    group = TRUE
  ))
  expect_error(download_weather_mpio(
    name = "05001",
    start_date = 2010,
    end_date = "2010-12-10",
    frequency = "day",
    tags = "PTPM_CON",
    group = TRUE
  ))
  expect_error(download_weather_mpio(
    name = "05001",
    start_date = "2010-10-01",
    end_date = c(199, 10),
    frequency = "day",
    tags = "PTPM_CON",
    group = TRUE
  ))
  expect_error(download_weather_mpio(
    name = "05001",
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "days",
    tags = "PTPM_CON",
    group = TRUE
  ))
  expect_error(download_weather_mpio(
    name = "05001",
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "day",
    tags = "PTPM_CONSS",
    group = TRUE
  ))
})

test_that("Weather Stations works as expected", {
  expect_s3_class(download_weather_mpio(
    name = "05001",
    start_date = "2018-10-01",
    end_date = "2018-11-10",
    frequency = "day",
    tags = "THSM_CON",
    group = FALSE
  ), "data.frame")
  expect_vector(download_weather_mpio(
    name = "05001",
    start_date = "2018-10-01",
    end_date = "2018-11-10",
    frequency = "month",
    tags = "NB_CON",
    group = TRUE
  )[, 2], size = 2)
  expect_identical(dim(download_weather_mpio(
    name = "05001",
    start_date = "2017-01-01",
    end_date = "2019-12-31",
    frequency = "year",
    tags = "TSTG_CON",
    group = TRUE
  ))[1], 3L)
  expect_type(download_weather_mpio(
    name = "11001",
    start_date = "2010-10-01",
    end_date = "2010-12-10",
    frequency = "month",
    tags = c("TMN_CON", "BSHG_CON"),
    group = FALSE
  ), "list")
})
