test_that("Divipola department code throws errors", {
  expect_error(name_to_code_dep(5678))
  expect_warning(name_to_code_dep("CARTAGO"))
})

test_that("Divipola department code works as expected", {
  expect_identical(
    name_to_code_dep(c("Tolima", "Antioquia")),
    c("73", "05")
  )
  expect_identical(
    name_to_code_dep(c(
      "Santander",
      "NORTE DE SANTANDER",
      "san andres"
    )),
    c("68", "54", "88")
  )
})

test_that("Divipola municipality code throws errors", {
  expect_error(name_to_code_mun(
    c(6787, 13),
    c("Soplaviento", "Cartagena")
  ))
  expect_error(name_to_code_mun(
    c("Bolivar", "Bolivar"),
    c(444, 555)
  ))
  expect_error(name_to_code_mun(
    "Bolivar",
    c("Soplaviento", "Cartagena")
  ))
  expect_warning(name_to_code_mun(
    c("Bolivar", "Panamá"),
    c("Soplaviento", "Cartagena")
  ))
  expect_warning(name_to_code_mun(
    c("Bolivar", "Bolivar"),
    c("S", "Cartagena")
  ))
})

test_that("Divipola municipality code works as expected", {
  expect_identical(
    name_to_code_mun(
      c("Santander", "Antioquia"),
      c("Rionegro", "Rionegro")
    ),
    c("68615", "05615")
  )
  expect_identical(
    name_to_code_mun(
      c("Antioquia", "Antioquia"),
      c(
        "Puerto Berrio",
        "Puerto Triunfo"
      )
    ),
    c("05579", "05591")
  )
})

test_that("Divipola department name throws errors", {
  expect_error(code_to_name_dep(c(73, 05)))
  expect_warning(code_to_name_dep(c(73, "14")))
  expect_warning(code_to_name_dep("04"))
})

test_that("Divipola department name works as expected", {
  expect_identical(code_to_name_dep("05"), "Antioquia")
})

test_that("Divipola municipality name throws errors", {
  expect_error(code_to_name_mun(c(05001, 73001)))
  expect_error(code_to_name_mun(05678, "14"))
  expect_warning(code_to_name_mun(c("05001", "73048")))
  expect_error(code_to_name_dep("04678"))
})

test_that("Divipola municipality name works as expected", {
  expect_identical(code_to_name_mun("05051"), "Arboletes")
})

test_that("Translate divipola department name works as expected", {
  expect_identical(name_to_standard_dep("Bogota"), "Bogotá, D.C.")
})

test_that("Translate divipola municipality name works as expected", {
  expect_identical(name_to_standard_mun(
    "Antioquia", "Sta fe de antioquia"
  ), "Santa Fé de Antioquia")
})
