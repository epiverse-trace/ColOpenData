lat <- c(6.373761, 6.373761, 4.256457, 4.256457, 6.373761)
lon <- c(-75.71929, -74.96571, -74.96571, -75.71929, -75.71929)
roi <- sf::st_polygon(x = list(cbind(lon, lat))) %>%
  sf::st_sfc() %>%
  sf::st_as_sf()
stations <- stations_in_roi(roi)

# Filtering stations for faster execution
stations_tssm <- stations[stations$codigo %in% c(27015090, 27015330), ]
stations_bshg <- stations[stations$codigo %in% c(
  27015090, 27015210,
  27015330
), ]
stations_tmn <- stations[stations$codigo %in% c(21245010, 21245040), ]
stations_tmx <- stations[stations$codigo %in% c(21215130, 21245010), ]
stations_ptpm <- stations[stations$codigo %in% c(
  27010770, 27010810, 27011110,
  27011120, 27015090, 26205080,
  27011270, 27015330
), ]

# Base data TSSM (Temperature)
base_tssm <- download_climate_stations(
  stations = stations_tssm,
  start_date = "2014-01-01",
  end_date = "2015-04-05",
  tag = "TSSM_CON"
)

# Base data BSHG (Sunshine duration)
base_bshg <- download_climate_stations(
  stations = stations_bshg,
  start_date = "1990-01-01",
  end_date = "1990-05-16",
  tag = "BSHG_CON"
)

# Base data TMN (Minimum temperature)
base_tmn <- download_climate_stations(
  stations = stations_tmn,
  start_date = "2010-04-01",
  end_date = "2010-10-31",
  tag = "TMN_CON"
)

# Base data TMX (Maximum temperature)
base_tmx <- download_climate_stations(
  stations = stations_tmx,
  start_date = "2020-04-01",
  end_date = "2020-04-30",
  tag = "TMX_CON"
)

# Base data PTPM (Precipitation)
base_ptpm <- download_climate_stations(
  stations = stations_ptpm,
  start_date = "2020-06-14",
  end_date = "2020-10-12",
  tag = "PTPM_CON"
)

test_that("Aggregation throws errors from frequency", {
  # Expect error when frequency is not available
  expect_error(aggregate_climate(base_tssm, "week"))

  # Expect error when climate data.frame is incomplete (missing columns)
  expect_error(aggregate_climate(base_tssm[, 1:5], "month"))

  # Expect warning when data is already in the requested frequency
  expect_warning(aggregate_climate(base_ptpm, "day"))
})

test_that("Aggregation for dry-bulb temperature works as expected", {
  # Expect that output has a data.frame structure from TSSM
  expect_s3_class(aggregate_climate(base_tssm, "day"), "data.frame")

  # Expect that non-addable dates are not aggreegated (climate aggregtion rules)
  month_tssm <- aggregate_climate(base_tssm, "month")
  expect_identical(month_tssm[
    which(month_tssm[["date"]] == "2015-04-01"),
    "value"
  ][[1]], c(NA_real_, NA_real_))

  # Expect that the result of adding long period of time is done right (TSSM)
  expect_identical(nrow(na.omit(aggregate_climate(base_tssm, "year"))), 2L)

  # Expect specific dataset from a proper request
  expect_snapshot(aggregate_climate(base_tssm, "year"))
})

test_that("Aggregation for sunshine duration works as expected", {
  # Expect that output has a data.frame structure for BSHG
  expect_s3_class(aggregate_climate(base_bshg, "day"), "data.frame")

  # Expect that the result of adding long period of time is done right (BSHG)
  expect_identical(nrow(aggregate_climate(base_bshg, "month")), 15L)

  # Expect correct date range
  year_bshg <- aggregate_climate(base_bshg, "year")
  expect_equal(max(year_bshg[["date"]]), as.Date("1990-01-01"))
})

test_that("Aggregation for minimum temperature works as expected", {
  # Expect that output has a data.frame structure for TMN
  expect_s3_class(aggregate_climate(base_tmn, "month"), "data.frame")

  # Expect that the result from climate aggregation has the same structure as
  # climate data
  expect_named(
    aggregate_climate(base_tmn, "year"),
    c("station", "longitude", "latitude", "date", "tag", "value")
  )
})

test_that("Aggregation for maximum temperature works as expected", {
  # Expect that output has a data.frame structure for TMX
  expect_s3_class(aggregate_climate(base_tmx, "year"), "data.frame")

  # Expect specific value for monthly aggregates in TMX
  month_tmx <- aggregate_climate(base_tmx, "month")
  expect_identical(max(month_tmx[
    which(month_tmx[["station"]] == 21245010),
    "value"
  ]), 34.2)
})

test_that("Aggregation for precipitation works as expected", {
  # Expect that output has a data.frame structure for PTPM
  expect_s3_class(aggregate_climate(base_ptpm, "month"), "data.frame")

  # Expect data.frame structure
  expect_equal(dim(aggregate_climate(base_ptpm, "year")), c(8, 6))

  # Expect specific dataset from a proper request
  expect_snapshot(aggregate_climate(base_ptpm, "month"))
})
