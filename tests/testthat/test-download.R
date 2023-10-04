test_that("Download errors are thrown", {
  expect_error(download("MGNCNPV06"))
  expect_error(download("MGNCNPV_06"))
})

test_that("Test that download works", {
  expect_s3_class(download("MGNCNPV_DPTO_2018"), c("sf", "data.frame"))
})
