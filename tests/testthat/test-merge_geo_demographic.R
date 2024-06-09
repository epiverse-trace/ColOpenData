test_that("Merge geospational demographic errors are thrown", {
  expect_error(merge_geo_demographic("DANE_CNPVH_2018_1HZ"))
})

test_that("Merge geospational demographic works as expected", {
  expect_snapshot(merge_geo_demographic("DANE_CNPVH_2018_1HD"))
})
