test_that("Download demographic errors are thrown", {
  # Expect error when introducing a string that does not start with "DANE_CNPV"
  expect_error(download_demographic("MGNCNPV06"))

  # Expect error when dataset does not exist
  expect_error(download_demographic("DANE_CNPVH_2018_1HZ"))

  # Expect error on empty input
  expect_error(download_demographic())
})

test_that("Download demographic works as expected", {
  # Expect specific dataset from a proper request
  expect_snapshot(download_demographic("DANE_CNPVH_2018_1HD"))
})
