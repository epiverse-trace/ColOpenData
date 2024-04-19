test_that("Support path errors are thrown", {
  expect_error(retrieve_support_path("DANE"))
})
