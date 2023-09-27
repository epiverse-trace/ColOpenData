dataset_1 <- download("MGNCNPV01")
dataset_2 <- download("MGNCNPV02")
test_that("Filter MGN-CNPV errors are thrown", {
  expect_error(filter_mgn_cnpv(
    .data = dataset_1,
    level = 4
  ))
  expect_error(filter_mgn_cnpv(
    .data = dataset_1,
    include_geometry = 1
  ))
  expect_error(filter_mgn_cnpv(
    .data = dataset_1,
    level = 1,
    ad = c("73001", "05001")
  ))
  expect_error(filter_mgn_cnpv(.data = dataset_1))
  expect_error(filter_mgn_cnpv(
    .data = dataset_1,
    level = 1,
    ad = c("05", "73"),
    columns = c("1", "2")
  ))
  expect_error(filter_mgn_cnpv(
    .data = dataset_2,
    level = 2,
    ad = c("05", "73"),
    columns = c("1", "THIS")
  ))
})

test_that("Filter MGN-CNPV works as expected", {
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_1,
      level = 1,
      include_geometry = FALSE
    ),
    "data.frame"
  )
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_2,
      level = 2,
      include_geometry = FALSE
    ),
    "data.frame"
  )
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_1,
      level = 1
    ),
    "data.frame"
  )
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_2,
      level = 2
    ),
    "data.frame"
  )
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_1,
      level = 1,
      ad = c("CUNDINAMARCA", "META")
    ),
    "data.frame"
  )
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_2,
      level = 2,
      ad = c("RIONEGRO", "MARINILLA")
    ),
    "data.frame"
  )
})
