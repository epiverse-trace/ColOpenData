# Samples to aggregate
mpios <- ColOpenData::download_geospatial("DANE_MGN_2018_MPIO")

barranquilla <- mpios[which(mpios$MPIO_CDPMP == "08001"), ]
bogota <- mpios[which(mpios$MPIO_CDPMP == "11001"), ]
ibague <- mpios[which(mpios$MPIO_CDPMP == "73001"), ]
medellin <- mpios[which(mpios$MPIO_CDPMP == "05001"), ]
manizales <- mpios[which(mpios$MPIO_CDPMP == "17001"), ]

base_tssm <- download_climate_geom(
  geometry = barranquilla,
  start_date = "2014-01-01",
  end_date = "2015-04-05",
  tag = "TSSM_CON"
)
base_bshg <- download_climate_geom(
  geometry = bogota,
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
  geometry = medellin,
  start_date = "2020-04-01",
  end_date = "2020-04-30",
  tag = "TMX_CON"
)
base_ptpm <- download_climate_geom(
  geometry = manizales,
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
  ][[1]], NA_real_)
  expect_identical(nrow(na.omit(aggregate_climate(base_tssm, "year"))), 1L)
})

test_that("Aggregation for sunshine duration works as expected", {
  expect_s3_class(aggregate_climate(base_bshg, "day"), "data.frame")
  expect_identical(nrow(aggregate_climate(base_bshg, "month")), 35L)
})

test_that("Aggregation for minimum temperature works as expected", {
  expect_s3_class(aggregate_climate(base_tmn, "month"), "data.frame")
  expect_identical(
    names(aggregate_climate(base_tmn, "year")),
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
})
