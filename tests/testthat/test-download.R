test_that("Download errors are thrown", {
  expect_error(download("MGNCNPV06"))
  expect_error(download("MGNCNPV_06"))
})

test_that("Test that download works", {
  expect_s3_class(download("DANE_2018_CNPV_Hogares"), c("data.frame"))
})
