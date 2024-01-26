test_that("Dictionary errors are thrown", {
  expect_error(dictionary("DANE_MGNCNPV_2018"))
  expect_error(dictionary(4))
})

test_that("Dictionary works as expected", {
  expect_s3_class(dictionary("DANE_MGNCNPV_2018_DPTO"), "data.frame")
})
