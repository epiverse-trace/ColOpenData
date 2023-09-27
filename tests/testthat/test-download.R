test_that("Download errors are thrown", {
  expect_error(download("MGNCNPV06"))
  expect_error(download("MGNCNPV06"))
})

test_that("Test that download works", {
  expect_s3_class(download("MGNCNPV01"), c("sf", "data.frame"))
})


dataset_1 <- download("MGNCNPV01")
dataset_2 <- download("MGNCNPV02")
test_that("Filter MGN-CNPV errors are thrown", {
  expect_error(filter_mgn_cnpv(.data = dataset_1, level = 4))
  expect_error(filter_mgn_cnpv(.data = dataset_1, include_geometry = 1))
  expect_error(filter_mgn_cnpv(.data = dataset_1, level = 1, filter = c("73001", "05001")))
  expect_error(filter_mgn_cnpv(.data = dataset_1))
  expect_error(filter_mgn_cnpv(.data = dataset_1, level = 1, filter = list(
    AD = c("05", "73"),
    columns = c("1")
  )))
  expect_error(filter_mgn_cnpv(.data = dataset_2, level = 2, filter = list(
    AD = c("05", "73"),
    columns = c("1")
  )))
})

test_that("Filter MGN-CNPV works as expected", {
  expect_s3_class(filter_mgn_cnpv(.data = dataset_1, level = 1, include_geometry = FALSE), "data.frame")
})
