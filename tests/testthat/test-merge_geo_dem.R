test_that("Merge geospational demographic errors are thrown", {
  expect_error(merge_geo_dem(
    spatial_level = "dep",
    demographic_dataset = "DANE_CNPVH_2018_1HD",
    column = "condicion"
  ))
  expect_error(merge_geo_dem(
    spatial_level = "department",
    demographic_dataset = "DANE_CNPVH_2018_1HM",
    column = "condicion"
  ))
  expect_error(merge_geo_dem(
    spatial_level = "department",
    demographic_dataset = "DANE_CNPVH_2018_1HD",
    column = "edad"
  ))
  expect_error(merge_geo_dem(
    spatial_level = "department",
    demographic_dataset = "DANE_CN_2018_1HD",
    column = "edad"
  ))
})

test_that("Merge geospational demographic works as expected", {
  expect_s3_class(merge_geo_dem(
    spatial_level = "department",
    demographic_dataset = "DANE_CNPVH_2018_1HD",
    column = "condicion"
  ), "data.frame")
  expect_snapshot(merge_geo_dem(
    spatial_level = "municipality",
    demographic_dataset = "DANE_CNPVH_2018_1HM",
    column = "condicion"
  ))
})
