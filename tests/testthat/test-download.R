test_that("Download errors are thrown", {
  expect_error(download("MGNCNPV06"))
  expect_error(download("MGNCNPV06"))
})

test_that("Test that download works", {
  expect_s3_class(download("MGNCNPV01"), c("sf", "data.frame"))
})
