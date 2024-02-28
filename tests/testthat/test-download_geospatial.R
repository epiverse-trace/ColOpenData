test_that("Download geospatial errors are thrown", {
  expect_error(download_geospatial("MGNCNPV06"))
  expect_error(download_geospatial())
  expect_error(download_geospatial(
    dataset = "DANE_MGN_2018_DPTO",
    include_geom = FALSE,
    include_cnpv = FALSE
  ))
})

test_that("Download geospatial works", {
  expect_s3_class(
    download_geospatial(
      dataset = "DANE_MGN_2018_DPTO",
      include_geom = TRUE,
      include_cnpv = TRUE
    ),
    c("sf", "data.frame")
  )
  expect_identical(
    dim(download_geospatial(
      dataset = "DANE_MGN_2018_MPIO",
      include_geom = TRUE,
      include_cnpv = TRUE
    )),
    c(1122L, 91L)
  )
  expect_s3_class(
    download_geospatial(
      dataset = "DANE_MGN_2018_MPIO",
      include_geom = FALSE,
      include_cnpv = TRUE
    ),
    "data.frame"
  )
})
