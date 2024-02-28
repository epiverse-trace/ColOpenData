test_that("Download demographic errors are thrown", {
  expect_error(download_demographic("MGNCNPV06"))
})

test_that("Download demographic works", {
  expect_s3_class(download_demographic("DANE_CNPVH_2018_1HD"), "data.frame")
  expect_identical(
    dim(download_demographic("DANE_CNPVH_2018_1HD")),
    c(408L, 5L)
  )
})
