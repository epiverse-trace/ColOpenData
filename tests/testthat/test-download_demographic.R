test_that("Download demographic errors are thrown", {
  expect_error(download_demographic("MGNCNPV06"))
  expect_error(download_demographic("DANE_CNPV_2018_Hogares", "TTT"))
})

test_that("Download demographic works", {
  expect_s3_class(download_demographic("DANE_CNPV_2018_Hogares"), "data.frame")
  expect_length(download_demographic("DANE_CNPV_2018_Hogares", "1HD"), 5L)
})
