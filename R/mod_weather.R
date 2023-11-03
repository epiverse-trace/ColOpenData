

start_date <- "2018-01-01"
end_date <- "2018-03-31"

latitude <- 4.43889 
longitude <- -75.23222 

location <- "73001"

retrieve_weather_modis <- function(location, start_date, end_date){
  #Do location stuff
  mpios <- ColOpenData::download("DANE_MGNCNPV_2018_MPIO")
  bbox <- sf::st_bbox(mpios[mpios$MPIO_CDPMP == location,])
  
  latitude <- (bbox$ymax + bbox$ymin)/2
  longitude <- (bbox$xmax + bbox$xmin)/2
  
  kmH <- ceiling(abs((abs(longitude) - abs(bbox$xmin))) * 111.3)
  kmV <- ceiling(abs((abs(latitude) - abs(bbox$ymin))) * 111)
  
  request <- paste0("https://modis.ornl.gov/rst/api/v1/MOD11A2/dates?latitude=",
                    latitude,"&longitude=",longitude)
  response <- httr::GET(request)
  dates_general <- httr::content(response)
  dates <- unlist(dates_general, recursive = FALSE)
  modis_dates <- unlist(lapply(dates, function(x) x$modis_date))
  calendar_dates <- unlist(lapply(dates, function(x) x$calendar_date))
  
  filtered_calendar_dates <- calendar_dates[which(calendar_dates>= start_date &
                                           calendar_dates <= end_date)]
  filtered_modis_dates <- modis_dates[which(calendar_dates >= start_date &
                                              calendar_dates <= end_date)]
  url <- "https://modis.ornl.gov/rst/api/v1/"
  product <- "MOD11A2"
  band <- "LST_Day_1km"
  data_modis <- data.frame()
  
  for(date in filtered_modis_dates){
    modis_response <- retrieve_modis(url, product, latitude, longitude, band,
                                     date, date, kmV, kmH)
    data_modis <- rbind(data_modis, modis_response$subset)
  }
  
  scale <- as.double(modis_response$scale)
  
  # Change the modis_date columns of lstdata and qcdata into R dates:
  data_modis$modis_date <- as.Date(substring(filtered_modis_dates, 2), '%Y%j')
  
  values <- t(as.data.frame(data_modis$data, colnames = data_modis$modis_date,
                            check.names=FALSE))
  values <- values * scale
  
  results <- data.frame(
    date = data_modis$modis_date, 
    mean = rowMeans(replace(values, values== 0, NA), na.rm=TRUE), 
    sd = apply(replace(values, values== 0, NA), 1, sd, na.rm = TRUE))
  
  return(results)
}


retrieve_modis <- function(url, product, latitude, longitude, band,
                           modis_start_date, modis_end_date, kmV, kmH){
  request <- paste0(
    url, product, "/subset?", "latitude=",latitude, "&longitude=",longitude, 
    "&band=",band, "&startDate=", modis_start_date, "&endDate=", modis_end_date,
    "&kmAboveBelow=",kmV, "&kmLeftRight=",kmH
  )
  response <- httr::GET(request)
  to_json_response <- jsonlite::toJSON(httr::content(response))
  result <- jsonlite::fromJSON(to_json_response)
  return(result)
}
