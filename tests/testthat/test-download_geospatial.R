test_that("Download geospatial errors are thrown", {
  expect_error(download_geospatial())
  expect_error(download_geospatial("MGNCNPV06"))
  expect_error(download_geospatial("DANE_MGN_2019_MPIO"))
  expect_error(download_geospatial(
    dataset = "DANE_MGN_2018_DPTO",
    include_geom = FALSE,
    include_cnpv = FALSE
  ))
})

test_that("Download geospatial works as expected", {
  expect_snapshot(download_geospatial(
    dataset = "DANE_MGN_2018_DPTO",
    include_geom = TRUE,
    include_cnpv = FALSE
  ))
})

test_that("Download geospatial works as expected with different parameters", {
  expect_snapshot(download_geospatial(
    dataset = "DANE_MGN_2018_DPTO",
    include_geom = FALSE,
    include_cnpv = TRUE
  ))
})
