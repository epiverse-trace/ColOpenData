test_that("Download geospatial errors are thrown", {
  expect_error(download_geospatial("MGNCNPV06"))
  expect_error(download_geospatial())
})

test_that("Download geospatial works", {
  expect_s3_class(
    download_geospatial("DANE_MGNCNPV_2018_DPTO"),
    c("sf", "data.frame")
  )
  expect_length(download_geospatial("DANE_MGNCNPV_2018_MPIO"), 91L)
})
