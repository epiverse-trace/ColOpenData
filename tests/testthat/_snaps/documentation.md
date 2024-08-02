# List datasets works as expected

    Code
      list_datasets(module = "geospatial", language = "EN")
    Output
      # A tibble: 9 x 7
        name                 group      source year  level        category description
        <chr>                <chr>      <chr>  <chr> <chr>        <chr>    <chr>      
      1 DANE_MGN_2018_DPTO   geospatial DANE   2018  department   maps     Geographic~
      2 DANE_MGN_2018_MPIO   geospatial DANE   2018  municipality maps     Geographic~
      3 DANE_MGN_2018_MPIOCL geospatial DANE   2018  municipalit~ maps     Geographic~
      4 DANE_MGN_2018_SETU   geospatial DANE   2018  urban_sector maps     Geographic~
      5 DANE_MGN_2018_SETR   geospatial DANE   2018  rural_sector maps     Geographic~
      6 DANE_MGN_2018_SECU   geospatial DANE   2018  urban_secti~ maps     Geographic~
      7 DANE_MGN_2018_SECR   geospatial DANE   2018  rural_secti~ maps     Geographic~
      8 DANE_MGN_2018_MZN    geospatial DANE   2018  block        maps     Geographic~
      9 DANE_MGN_2018_ZU     geospatial DANE   2023  urban_zone   maps     Geographic~

# Dictionary works as expected

    Code
      geospatial_dictionary(spatial_level = "mpio", language = "EN")
    Output
      # A tibble: 88 x 4
         variable                 type         length description                     
         <chr>                    <chr>         <dbl> <chr>                           
       1 codigo_departamento      Text              2 Department code                 
       2 codigo_municipio_sin_con Text              3 Municipality code               
       3 municipio                Text            250 Municipality name               
       4 codigo_municipio         Text              5 Concatenated municipality code  
       5 version                  Long Integer     NA Year of the geographic informat~
       6 area                     Double           NA Municipality area in square met~
       7 latitud                  Double           NA Centroid latitude coordinate of~
       8 longitud                 Double           NA Centroid latitude coordinate of~
       9 encuestas                Double           NA Number of surveys CNPV 2018     
      10 enc_etnico               Double           NA Number of surveys that reported~
      # i 78 more rows

# Climate tags works as expected

    Code
      get_climate_tags(language = "ES")
    Output
           etiqueta                                   variable
      1    TSSM_CON                Temperatura seca (ambiente)
      2    THSM_CON                         Temperatura humeda
      3     TMN_CON                         Temperatura minima
      4     TMX_CON                         Temperatura maxima
      5    TSTG_CON Temperatura seca (ambiente) del termografo
      6      HR_CAL                           Humedad relativa
      7    HRHG_CON            Humedad relativa del hidrografo
      8      TV_CAL                           Tension de vapor
      9     TPR_CAL                             Punto de rocio
      10   PTPM_CON                              Precipitacion
      11   PTPG_CON                              Precipitacion
      12   EVTE_CON                                Evaporacion
      13     FA_CON                       Fenomeno atmosferico
      14     NB_CON                                  Nubosidad
      15   RCAM_CON                       Recorrido del viento
      16   BSHG_CON                               Brillo solar
      17   VVAG_CON                       Velocidad del viento
      18   DVAG_CON                       Direccion del viento
      19 VVMXAG_CON                Velocidad maxima del viento
      20 DVMXAG_CON                Direccion maxima del viento
                                      frecuencia
      1  Horaria (07:00, 13:00, 18:00 y/o 19:00)
      2  Horaria (07:00, 13:00, 18:00 y/o 19:00)
      3                                   Diaria
      4                                   Diaria
      5                       Horaria (24 horas)
      6  Horaria (07:00, 13:00, 18:00 y/o 19:00)
      7                       Horaria (24 horas)
      8  Horaria (07:00, 13:00, 18:00 y/o 19:00)
      9  Horaria (07:00, 13:00, 18:00 y/o 19:00)
      10                                  Diaria
      11                      Horaria (24 horas)
      12                                  Diaria
      13 Horaria (07:00, 13:00, 18:00 y/o 19:00)
      14 Horaria (07:00, 13:00, 18:00 y/o 19:00)
      15                                  Diaria
      16                      Horaria (14 horas)
      17                      Horaria (24 horas)
      18                      Horaria (24 horas)
      19                                  Diaria
      20                                  Diaria

# Lookup works as expected with different parameters

    Code
      look_up(keywords = c("school", "age"), logic = "and", language = "EN")
    Output
      # A tibble: 2 x 7
        name                  group       source year  level      category description
        <chr>                 <chr>       <chr>  <chr> <chr>      <chr>    <chr>      
      1 DANE_CNPVPD_2018_18PD demographic DANE   2018  department persons~ Census pop~
      2 DANE_CNPVPD_2018_18PM demographic DANE   2018  municipal~ persons~ Census pop~

