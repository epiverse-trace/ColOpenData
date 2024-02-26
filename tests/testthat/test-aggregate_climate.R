# Samples to aggregate
mpios <- ColOpenData::download_geospatial("DANE_MGNCNPV_2018_MPIO")

barranquilla <- mpios[which(mpios$MPIO_CDPMP == "08001"), ]
bogota <- mpios[which(mpios$MPIO_CDPMP == "11001"), ]
ibague <- mpios[which(mpios$MPIO_CDPMP == "73001"), ]
medellin <- mpios[which(mpios$MPIO_CDPMP == "05001"), ]
manizales <- mpios[which(mpios$MPIO_CDPMP == "17001"), ]

base_tssm <- download_climate_geom(geometry = barranquilla, 
                                   start_date = "2014-01-01", 
                                   end_date = "2015-04-05", 
                                   tags = "TSSM_CON")
base_bshg <- download_climate_geom(geometry = bogota, 
                                   start_date ="1990-01-01", 
                                   end_date ="1990-05-16", 
                                   tags ="BSHG_CON")
base_tmn <- download_climate_geom(geometry = ibague, 
                                  start_date ="2010-04-01", 
                                  end_date ="2010-10-31", 
                                  tags ="TMN_CON")
base_tmx <- download_climate_geom(geometry = medellin, 
                                  start_date ="2020-04-01", 
                                  end_date ="2020-04-30",
                                  tags ="TMX_CON")
base_ptpm <- download_climate_geom(geometry = manizales, 
                                   start_date ="2020-06-14",
                                   end_date ="2020-10-12", 
                                   tags ="PTPM_CON")

test_that("Aggregation throws errors from frequency", {
  expect_error(aggregate_tssm(base_tssm, "week"))
  expect_error(aggregate_tssm(base_bshg, "day"))
  expect_error(aggregate_tssm(base_tssm[,1:5], "month"))
  
  expect_error(aggregate_bhsg(base_bshg, "week"))
  expect_error(aggregate_bhsg(base_tmn, "day"))
  expect_error(aggregate_bhsg(base_bshg[,1:5], "month"))
  
  expect_error(aggregate_tmn(base_tmn, "day"))
  expect_error(aggregate_tmn(base_tmx, "month"))
  expect_error(aggregate_tmn(base_tmn[,1:5], "month"))
  
  expect_error(aggregate_tmx(base_tmx, "day"))
  expect_error(aggregate_tmx(base_ptpg, "month"))
  expect_error(aggregate_tmx(base_tmx[,1:5], "month"))

  expect_error(aggregate_ptpg(base_ptpg, "day"))
  expect_error(aggregate_ptpg(base_tssm, "month"))
  expect_error(aggregate_ptpg(base_ptpg[,1:5], "month"))
  
})

test_that("Aggregation for dry-bulb temperature works as expected", {
  expect_s3_class(aggregate_tssm(base_tssm, "day"), "data.frame")
  monthly_tssm <- aggregate_tssm(base_tssm, "month")
  expect_identical(monthly_tssm[
    which(monthly_tssm$date == "2015-04-01"),
    "value"
  ][[1]], NA_real_)
  expect_identical(nrow(na.omit(aggregate_tssm(base_tssm, "year"))), 1L)
})

test_that("Aggregation for sunshine duration works as expected", {
  expect_s3_class(aggregate_bshg(base_bshg, "day"), "data.frame")
  expect_identical(nrow(aggregate_bshg(base_bshg, "month")), 35L)

})

test_that("Aggregation for minimum temperature works as expected", {
  expect_s3_class(aggregate_tmn(base_tmn, "month"), "data.frame")
  expect_identical(names(aggregate_tmn(base_tmn, "year")), 
                  c("station", "longitude", "latitude", "date", "tag", "value"))
})

test_that("Aggregation for maximum temperature works as expected", {
  expect_s3_class(aggregate_tmn(base_tmn, "year"), "data.frame")
  monthly_tmn <- aggregate_tmn(base_tmn, "month")
  expect_identical(min(monthly_tmn[which(monthly_tmn$station == 21245040),
                                   "value"]),19.7)
})

test_that("Aggregation for precipitation works as expected", {
  expect_s3_class(aggregate_ptpm(base_ptpm, "month"), "data.frame")
})
