test_that("Divipola department code throws errors", {
  # Expect error when department_name is not a character
  expect_error(name_to_code_dep(5678))

  # Expect error when department_name does not exist
  expect_warning(name_to_code_dep("CARTAGO"))
})

test_that("Divipola department code works as expected", {
  # Expect specific vector from a proper request using multiple cases and
  # including border scenarios ("Santander" and "Norte de Santander" have
  # similar strings. "San Andres" is a frequent way to call the department while
  # the official name is much much longer)
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
  # Expect error when department_name is not a character
  expect_error(name_to_code_mun(
    c(6787, 13),
    c("Soplaviento", "Cartagena")
  ))

  # Expect error when municipality_name is not a character
  expect_error(name_to_code_mun(
    c("Bolivar", "Bolivar"),
    c(444, 555)
  ))

  # Expect warning when one of the input pairs ("Bolivar", "Soplaviento")
  # is correct and the other one is not ("Panama", "Cartagena"), since Panama is
  # not a department of Colombia
  expect_warning(name_to_code_mun(
    c("Bolivar", "Panamá"),
    c("Soplaviento", "Cartagena")
  ))

  # Expect warning when one of the input pairs ("Bolivar", "Cartagena") is
  # correct and the other one is not ("Bolivar", "S"), since S is not a
  # municipality in Bolivar
  expect_warning(name_to_code_mun(
    c("Bolivar", "Bolivar"),
    c("S", "Cartagena")
  ))
})

test_that("Divipola municipality code works as expected", {
  # Expect specific vector from a proper request including municipalities with
  # same name in different departments (This is quite common in Colombia)
  expect_identical(
    name_to_code_mun(
      c("Santander", "Antioquia"),
      c("Rionegro", "Rionegro")
    ),
    c("68615", "05615")
  )

  # Expect specific vector from a proper request when there are multiple
  # municipalities from the same department
  expect_identical(
    name_to_code_mun(
      "Antioquia",
      c(
        "Puerto Berrio",
        "Puerto Triunfo"
      )
    ),
    c("05579", "05591")
  )
})

test_that("Divipola department name throws errors", {
  # Expect error when department_code is not a character
  expect_error(code_to_name_dep(c(73, 05)))

  # Expect warning when some of the elements in department_code are not a
  # character
  expect_warning(code_to_name_dep(c(73, "14")))

  # Expect warning when the department code does not exist
  expect_warning(code_to_name_dep("04"))
})

test_that("Divipola department name works as expected", {
  # Expect specific vector from a proper request
  expect_identical(code_to_name_dep("05"), "Antioquia")
})

test_that("Divipola municipality and department name throws errors", {
  # Expect error when department_code and municipality_code are not a character
  expect_error(code_to_name_mun(c(05001, 73001)))

  # Expect error when only one of the arguments is not a character
  expect_error(code_to_name_mun(05678, "14"))

  # Expect warning when only one of the arguments is not a real municipality
  # code
  expect_warning(code_to_name_mun(c("05001", "73048")))
})

test_that("Divipola municipality name works as expected", {
  # Expect specific vector from a proper request
  expect_identical(code_to_name_mun("05051"), "Arboletes")
})

test_that("Translate divipola department name works as expected", {
  # Expect specific vector from a proper request
  expect_identical(name_to_standard_dep("Bogota"), "Bogotá, D.C.")
})

test_that("Translate divipola municipality name works as expected", {
  # Expect specific vector from a proper request with a border scenario
  # (Shortened municipality name, which is frequently used)
  expect_identical(name_to_standard_mun(
    "Antioquia", "Sta fe de antioquia"
  ), "Santa Fé de Antioquia")
})
