dataset_1 <- download("MGNCNPV01")
dataset_2 <- download("MGNCNPV02")
test_that("Filter MGN-CNPV errors are thrown", {
  expect_error(filter_mgn_cnpv(
    .data = dataset_1,
    include_geometry = 1
  ))
  expect_error(filter_mgn_cnpv(
    .data = dataset_2,
    codes = c("05", "73"),
    columns = c("1", "THIS")
  ))
  expect_error(filter_mgn_cnpv(
    .data = sf::st_drop_geometry(dataset_1)
  ))
})

test_that("Filter MGN-CNPV works as expected", {
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_1,
      include_geometry = FALSE
    ),
    "data.frame"
  )
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_2,
      include_geometry = FALSE
    ),
    "data.frame"
  )
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_1
    ),
    "data.frame"
  )
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_2
    ),
    "data.frame"
  )
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_1,
      codes = c("CUNDINAMARCA", "META")
    ),
    "data.frame"
  )
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_2,
      codes = c("RIONEGRO", "MARINILLA")
    ),
    "data.frame"
  )
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_1,
      codes = c("73", "70", "81")
    ),
    "data.frame"
  )
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_2,
      codes = c("19821", "76041", "52240")
    ),
    "data.frame"
  )
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_2,
      codes = c("73", "70")
    ),
    "data.frame"
  )
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_2,
      codes = "TOLIMA"
    ),
    "data.frame"
  )
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_1,
      codes = c(5, 73, 18, 19)
    ),
    "data.frame"
  )
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_2,
      codes = 5
    ),
    "data.frame"
  )
  expect_s3_class(
    filter_mgn_cnpv(
      .data = dataset_2,
      codes = c(5001, 5101, 5088, 5091)
    ),
    "data.frame"
  )
})
