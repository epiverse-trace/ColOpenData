test_that("Support path errors are thrown", {
  # Expect error when retrieving a support path that does not exist (internal
  # though)
  expect_error(retrieve_support_path("DANE"))
})
