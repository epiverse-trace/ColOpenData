# Region without stations
mpios <- ColOpenData::download("DANE_MGNCNPV_2018_MPIO")
mpio_no_stations <- mpios[which(mpios$MPIO_CDPMP == "15500"),]
mpio_stations <- mpios[which(mpios$MPIO_CDPMP == "05001"),]

# Stations in ROI
test_that("Stations in ROI throws errors", {
  expect_error(stations_in_roi("geometry"))
  expect_error(stations_in_roi(mpio_no_stations))
})

test_that("Stations in ROI work as expected", {
  expect_s3_class(stations_in_roi(mpio_stations), "data.frame")
})

# Retrieve Working Stations
bogota <- mpios[which(mpios$MPIO_CDPMP == "11001"),]
stations_test <- stations_in_roi(bogota)
stations_names <- stations_test$codigo

test_that("Retrieve Working Stations throws errors", {
  expect_error(retrieve_working_stations(stations = data.frame(a = "5555"),
                                         start_date = "2010-01-01",
                                         end_date = "2010-02-10",
                                         frequency = "day",
                                         tag = "TSSM_CON"))
  expect_error(retrieve_working_stations(stations = stations_names,
                                         start_date = 2010,
                                         end_date = "2010-02-10",
                                         frequency = "day",
                                         tag = "TSSM_CON"))
  expect_error(retrieve_working_stations(stations = stations_names,
                                         start_date = "2010-01-01",
                                         end_date = 2010,
                                         frequency = "day",
                                         tag = "TSSM_CON"))
  expect_error(retrieve_working_stations(stations = stations_names,
                                         start_date = "2010-01-01",
                                         end_date = "2010-02-10",
                                         frequency = "years",
                                         tag = "TSSM_CON"))
  expect_error(retrieve_working_stations(stations = stations_names,
                                         start_date = "2010-01-01",
                                         end_date = "2010-02-10",
                                         frequency = "day",
                                         tag = "TTMM_CON"))
  expect_error(retrieve_working_stations(stations = c("888", "999"),
                                         start_date = "2010-01-01",
                                         end_date = "2010-02-10",
                                         frequency = "day",
                                         tag = "TSSM_CON"))
})

test_that("Retrieve Working Stations works as expected", {
  expect_s3_class(retrieve_working_stations(stations = stations_names,
                                            start_date = "2013-01-01",
                                            end_date = "2013-02-01",
                                            frequency = "day",
                                            tag = "TSSM_CON"), "data.frame")
  expect_length(retrieve_working_stations(stations = stations_names,
                                          start_date = "2013-01-01",
                                          end_date = "2013-02-01",
                                          frequency = "day",
                                          tag = "PTPM_CON"), 25)
  
})

# Weather stations

test_that("Weather Stations throws errors", {
  expect_error(weather_stations(geometry = "bogota",
                                 start_date = "2010-01-01",
                                 end_date = "2010-02-10",
                                 frequency = "day",
                                 tag = "TSSM_CON"))
  expect_error(weather_stations(geometry = bogota,
                                start_date = 20100210,
                                end_date = "2010-02-10",
                                frequency = "day",
                                tag = "TSSM_CON"))
  expect_error(weather_stations(geometry = bogota,
                                start_date = "2010-01-01",
                                end_date = 20100310,
                                frequency = "day",
                                tag = "TSSM_CON"))
  expect_error(weather_stations(geometry = bogota,
                                start_date = "2010-01-01",
                                end_date = "2010-02-10",
                                frequency = "dday",
                                tag = "TSSM_CON"))
  expect_error(weather_stations(geometry = bogota,
                                start_date = "2010-01-01",
                                end_date = "2010-02-10",
                                frequency = "day",
                                tag = "TSSM_CONS"))
})

test_that("Weather Stations works as expected",{
  expect_s3_class(weather_stations(geometry = bogota,
                                   start_date = "2010-10-01",
                                   end_date = "2010-12-10",
                                   frequency = "day",
                                   tag = "PTPM_CON"), "data.frame")
  expect_length(weather_stations(geometry = bogota,
                                   start_date = "2010-10-01",
                                   end_date = "2010-12-10",
                                   frequency = "day",
                                   tag = "PTPM_CON",
                                   plot = TRUE), 49)
  expect_length(weather_stations(geometry = bogota,
                                   start_date = "2010-10-01",
                                   end_date = "2010-12-10",
                                   frequency = "day",
                                   tag = "PTPM_CON",
                                   plot = TRUE,
                                   group = TRUE), 2)
  expect_length(weather_stations(geometry = bogota,
                                 start_date = "2010-10-01",
                                 end_date = "2010-12-10",
                                 frequency = "week",
                                 tag = "PTPM_CON",
                                 plot = TRUE,
                                 group = TRUE), 2)
  expect_length(weather_stations(geometry = bogota,
                                 start_date = "2010-10-01",
                                 end_date = "2010-12-10",
                                 frequency = "month",
                                 tag = "EVTE_CON",
                                 plot = TRUE,
                                 group = TRUE), 2)
})

# Weather Stations Mpio
test_that("Weather stations by municipality throws errors", {
  expect_error(weather_stations_mpio(name = 5001,
                                     start_date = "2010-10-01",
                                     end_date = "2010-12-10",
                                     frequency = "day",
                                     tag = "PTPM_CON",
                                     plot = TRUE,
                                     group = TRUE))
  expect_error(weather_stations_mpio(name = "05001",
                                     start_date = 2010,
                                     end_date = "2010-12-10",
                                     frequency = "day",
                                     tag = "PTPM_CON",
                                     plot = TRUE,
                                     group = TRUE))
  expect_error(weather_stations_mpio(name = "05001",
                                     start_date = "2010-10-01",
                                     end_date = c(199, 10),
                                     frequency = "day",
                                     tag = "PTPM_CON",
                                     plot = TRUE,
                                     group = TRUE))
  expect_error(weather_stations_mpio(name = "05001",
                                     start_date = "2010-10-01",
                                     end_date = "2010-12-10",
                                     frequency = "days",
                                     tag = "PTPM_CON",
                                     plot = TRUE,
                                     group = TRUE))
  expect_error(weather_stations_mpio(name = "05001",
                                     start_date = "2010-10-01",
                                     end_date = "2010-12-10",
                                     frequency = "day",
                                     tag = "PTPM_CONSS",
                                     plot = TRUE,
                                     group = TRUE))
})

test_that("Weather Stations works as expected",{
  expect_s3_class(weather_stations_mpio(name = "05001",
                                     start_date = "2018-10-01",
                                     end_date = "2018-11-10",
                                     frequency = "day",
                                     tag = "THSM_CON",
                                     plot = TRUE,
                                     group = FALSE), "data.frame")
  expect_gte(weather_stations_mpio(name = "05001",
                                        start_date = "2018-09-01",
                                        end_date = "2018-12-10",
                                        frequency = "week",
                                        tag = "THSM_CON",
                                        plot = TRUE,
                                        group = TRUE)[1,2], 0)
  expect_vector(weather_stations_mpio(name = "05001",
                                       start_date = "2018-10-01",
                                       end_date = "2018-11-10",
                                       frequency = "month",
                                       tag = "NB_CON",
                                       plot = TRUE,
                                       group = TRUE)[,2], size = 2)
  expect_equal(dim(weather_stations_mpio(name = "05001",
                                       start_date = "2017-01-01",
                                       end_date = "2019-12-31",
                                       frequency = "year",
                                       tag = "TSTG_CON",
                                       plot = TRUE,
                                       group = TRUE))[1],3L)

})