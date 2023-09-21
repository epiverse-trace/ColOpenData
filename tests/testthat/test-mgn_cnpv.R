test_that("Census consultation errors are thrown", {
  expect_error(get_mgn_cnpv_mun(mun = c(73001, 05001)))
  expect_error(get_mgn_cnpv_mun(columns = c("STP27_PERS", "STP28_PERS")))
  expect_error(get_mgn_cnpv_mun(
    mun = c("73001", "05001"),
    columns = c(STP27_PERS)
  ))
})
