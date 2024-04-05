test_that("Download demographic errors are thrown", {
  expect_error(download_demographic("MGNCNPV06"))
  expect_error(download_demographic())
})

test_that("Download demographic works as expected", {
  expect_snapshot(download_demographic("DANE_CNPVH_2018_1HD"))
})
