test_that("Divipola department code throws errors", {
  expect_error(divipola_department_code(5678))
  expect_warning(divipola_department_code("CARTAGO"))
})

test_that("Divipola department code works as expected", {
  expect_identical(
    divipola_department_code(c("Tolima", "Antioquia")),
    c("73", "05")
  )
  expect_identical(
    divipola_department_code(c(
      "Santander",
      "NORTE DE SANTANDER",
      "san andres"
    )),
    c("68", "54", "88")
  )
})

test_that("Divipola municipality code throws errors", {
  expect_error(divipola_municipality_code(
    c(6787, 13),
    c("Soplaviento", "Cartagena")
  ))
  expect_error(divipola_municipality_code(
    c("Bolivar", "Bolivar"),
    c(444, 555)
  ))
  expect_error(divipola_municipality_code(
    "Bolivar",
    c("Soplaviento", "Cartagena")
  ))
  expect_warning(divipola_municipality_code(
    c("Bolivar", "Panamá"),
    c("Soplaviento", "Cartagena")
  ))
  expect_warning(divipola_municipality_code(
    c("Bolivar", "Bolivar"),
    c("S", "Cartagena")
  ))
})

test_that("Divipola municipality code works as expected", {
  expect_identical(
    divipola_municipality_code(
      c("Santander", "Antioquia"),
      c("Rionegro", "Rionegro")
    ),
    c("68615", "05615")
  )
  expect_identical(
    divipola_municipality_code(
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
  expect_error(divipola_department_name(c(73, 05)))
  expect_warning(divipola_department_name(c(73, "14")))
  expect_warning(divipola_department_name("04"))
})

test_that("Divipola department name works as expected", {
  expect_identical(divipola_department_name("05"), "Antioquia")
})

test_that("Divipola municipality name throws errors", {
  expect_error(divipola_municipality_name(c(05001, 73001)))
  expect_error(divipola_municipality_name(05678, "14"))
  expect_warning(divipola_municipality_name(c("05001", "73048")))
  expect_error(divipola_department_name("04678"))
})

test_that("Divipola municipality name works as expected", {
  expect_identical(divipola_municipality_name("05051"), "Arboletes")
})

test_that("Translate divipola department name works as expected", {
  expect_identical(trans_divipola_department("Bogota"), "Bogotá, D.C.")
})

test_that("Translate divipola municipality name works as expected", {
  expect_identical(trans_divipola_municipality(
    c("Antioquia"), c("Sta fe de antioquia")
  ), "Santa Fé de Antioquia")
})
