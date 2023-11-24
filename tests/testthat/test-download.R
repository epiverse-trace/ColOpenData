test_that("Download errors are thrown", {
  expect_error(download_demographic("MGNCNPV06"))
  expect_error(download_demographic("MGNCNPV_06"))
  expect_warning(download_demographic("DANE_MGNCNPV_2018_DPTO", "A4"))
})

test_that("Test that download works", {
  expect_s3_class(download_demographic("DANE_CNPV_2018_Hogares"), "data.frame")
  expect_s3_class(download_demographic("DANE_MGNCNPV_2018_DPTO"), c("sf", "data.frame"))
  expect_length(download_demographic("DANE_CNPV_2018_Hogares", "1HD"), 5L)
})
