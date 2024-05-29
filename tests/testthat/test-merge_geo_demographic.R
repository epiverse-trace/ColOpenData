test_that("Merge geospational demographic errors are thrown", {
  expect_error(merge_geo_demographic(
    demographic_dataset = "DANE_CNPVH_2018_1HD",
    column = TRUE
  ))
  expect_error(merge_geo_demographic(
    demographic_dataset = "DANE_CNPVH_2018_1HD",
    column = "edad"
  ))
  expect_error(merge_geo_demographic(
    demographic_dataset = "DANE_CN_2018_1HD",
    column = "edad"
  ))
})

test_that("Merge geospational demographic works as expected", {
  expect_s3_class(merge_geo_demographic(
    demographic_dataset = "DANE_CNPVH_2018_1HD",
    column = "condicion"
  ), "data.frame")
  expect_snapshot(merge_geo_demographic(
    demographic_dataset = "DANE_CNPVH_2018_1HM",
    column = "condicion"
  ))
})
