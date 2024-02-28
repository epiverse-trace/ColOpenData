test_that("Download geospatial errors are thrown", {
  expect_error(download_geospatial("MGNCNPV06"))
  expect_error(download_geospatial())
})

test_that("Download geospatial works", {
  expect_s3_class(
    download_geospatial("DANE_MGN_2018_DPTO", T, T),
    c("sf", "data.frame")
  )
  expect_identical(
    dim(download_geospatial("DANE_MGN_2018_MPIO", T, T)),
    c(1122L, 91L)
  )
})
