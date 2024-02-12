test_that("Download demographic errors are thrown", {
  expect_error(download_demographic("MGNCNPV06"))
})

test_that("Download demographic works", {
  expect_s3_class(download_demographic("DANE_CNPVH_2018_1HD"), "data.frame")
  expect_length(download_demographic("DANE_CNPVH_2018_1HD"), 5L)
})
