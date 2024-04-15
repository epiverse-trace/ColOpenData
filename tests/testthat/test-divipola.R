test_that("Divipola department code throws errors", {
  expect_error(divipola_department_code(5678))
  expect_warning(divipola_department_code("CAARTAGENA"))
})

test_that("Divipola department code works as expected", {
  expect_identical(
    divipola_department_code(c("TOLIMA", "ANTIOQUIA")),
    c("73", "05")
  )
  expect_identical(
    divipola_department_code(c(
      "SANTANDER",
      "NORTE DE SANTANDER",
      "SAN ANDRES"
    )),
    c("68", "54", "88")
  )
})

test_that("Divipola municipality code throws errors", {
  expect_error(divipola_municipality_code(
    c(6787, 13),
    c("SOPLAVIENTO", "CARTAGENA")
  ))
  expect_error(divipola_municipality_code(
    c("BOLIVAR", "BOLIVAR"),
    c(444, 555)
  ))
  expect_error(divipola_municipality_code(
    "BOLIVAR",
    c("SOPLAVIENTO", "CARTAGENA")
  ))
  expect_warning(divipola_municipality_code(
    c("BOLIVAR", "CARTAGENA"),
    c("SOPLAVIENTO", "CARTAGENA")
  ))
  expect_warning(divipola_municipality_code(
    c("BOLIVAR", "BOLIVAR"),
    c("SOPLAVIENTO", "SANTANDER")
  ))
})

test_that("Divipola municipality code works as expected", {
  expect_identical(
    divipola_municipality_code(
      c("SANTANDER", "ANTIOQUIA"),
      c("RIONEGRO", "RIONEGRO")
    ),
    c("68615", "05615")
  )
  expect_identical(
    divipola_municipality_code(
      c("ANTIOQUIA", "ANTIOQUIA"),
      c(
        "PUERTO BERRIO",
        "PUERTO TRIUNFO"
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
  expect_identical(divipola_department_name("05"), "ANTIOQUIA")
})

test_that("Divipola municipality name throws errors", {
  expect_error(divipola_municipality_name(c(05001, 73001)))
  expect_error(divipola_municipality_name(05678, "14"))
  expect_warning(divipola_municipality_name(c("05001", "73048")))
  expect_error(divipola_department_name("04678"))
})

test_that("Divipola municipality name works as expected", {
  expect_identical(divipola_municipality_name("05051"), "ARBOLETES")
})
