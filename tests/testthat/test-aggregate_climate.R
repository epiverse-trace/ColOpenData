# Municipality 1
lat_1 <- c(6.373761, 6.373761, 6.163823, 6.163823, 6.373761)
lon_1 <- c(-75.71929, -75.4723, -75.4723, -75.71929, -75.71929)
polygon_1 <- sf::st_polygon(x = list(cbind(lon_1, lat_1))) %>% sf::st_sfc()
medellin <- sf::st_as_sf(polygon_1)

# Municipality 2
lat_2 <- c(4.700691, 4.700691, 4.256457, 4.256457, 4.700691)
lon_2 <- c(-75.5221, -74.96571, -74.96571, -75.5221, -75.5221)
polygon_2 <- sf::st_polygon(x = list(cbind(lon_2, lat_2))) %>% sf::st_sfc()
ibague <- sf::st_as_sf(polygon_2)

base_tssm <- download_climate_geom(
  geometry = medellin,
  start_date = "2014-01-01",
  end_date = "2015-04-05",
  tag = "TSSM_CON"
)
base_bshg <- download_climate_geom(
  geometry = medellin,
  start_date = "1990-01-01",
  end_date = "1990-05-16",
  tag = "BSHG_CON"
)
base_tmn <- download_climate_geom(
  geometry = ibague,
  start_date = "2010-04-01",
  end_date = "2010-10-31",
  tag = "TMN_CON"
)
base_tmx <- download_climate_geom(
  geometry = ibague,
  start_date = "2020-04-01",
  end_date = "2020-04-30",
  tag = "TMX_CON"
)
base_ptpm <- download_climate_geom(
  geometry = ibague,
  start_date = "2020-06-14",
  end_date = "2020-10-12",
  tag = "PTPM_CON"
)

test_that("Aggregation throws errors from frequency", {
  expect_error(aggregate_climate(base_tssm, "week"))
  expect_error(aggregate_climate(base_tssm[, 1:5], "month"))
  expect_warning(aggregate_climate(base_ptpm, "day"))
})

test_that("Aggregation for dry-bulb temperature works as expected", {
  expect_s3_class(aggregate_climate(base_tssm, "day"), "data.frame")
  month_tssm <- aggregate_climate(base_tssm, "month")
  expect_identical(month_tssm[
    which(month_tssm$date == "2015-04-01"),
    "value"
  ][[1]], c(NA_real_, NA_real_))
  expect_identical(nrow(na.omit(aggregate_climate(base_tssm, "year"))), 2L)
})

test_that("Aggregation for sunshine duration works as expected", {
  expect_s3_class(aggregate_climate(base_bshg, "day"), "data.frame")
  expect_identical(nrow(aggregate_climate(base_bshg, "month")), 15L)
  expect_snapshot(aggregate_climate(base_bshg, "year"))
})

test_that("Aggregation for minimum temperature works as expected", {
  expect_s3_class(aggregate_climate(base_tmn, "month"), "data.frame")
  expect_named(
    aggregate_climate(base_tmn, "year"),
    c("station", "longitude", "latitude", "date", "tag", "value")
  )
})

test_that("Aggregation for maximum temperature works as expected", {
  expect_s3_class(aggregate_climate(base_tmn, "year"), "data.frame")
  month_tmn <- aggregate_climate(base_tmn, "month")
  expect_identical(min(month_tmn[
    which(month_tmn$station == 21245040),
    "value"
  ]), 19.7)
})

test_that("Aggregation for precipitation works as expected", {
  expect_s3_class(aggregate_climate(base_ptpm, "month"), "data.frame")
  expect_snapshot(aggregate_climate(base_ptpm, "year"))
})
