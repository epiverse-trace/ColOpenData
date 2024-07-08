# List datasets works as expected

    Code
      list_datasets("geospatial")
    Output
                        name      group source year              level category
      1   DANE_MGN_2018_DPTO geospatial   DANE 2018         department     maps
      2   DANE_MGN_2018_MPIO geospatial   DANE 2018       municipality     maps
      3 DANE_MGN_2018_MPIOCL geospatial   DANE 2018 municipality_class     maps
      4   DANE_MGN_2018_SETU geospatial   DANE 2018       urban_sector     maps
      5   DANE_MGN_2018_SETR geospatial   DANE 2018       rural_sector     maps
      6   DANE_MGN_2018_SECU geospatial   DANE 2018      urban_section     maps
      7   DANE_MGN_2018_SECR geospatial   DANE 2018      rural_section     maps
      8    DANE_MGN_2018_MZN geospatial   DANE 2018              block     maps
      9     DANE_MGN_2018_ZU geospatial   DANE 2023         urban_zone     maps
                                                                                      description
      1              Geographical and summarised census data from 2018 at the level of department
      2            Geographical and summarised census data from 2018 at the level of municipality
      3 Geographical and summarised census data from 2018 at the level of municipality with class
      4            Geographical and summarised census data from 2018 at the level of urban sector
      5            Geographical and summarised census data from 2018 at the level of rural sector
      6           Geographical and summarised census data from 2018 at the level of urban section
      7           Geographical and summarised census data from 2018 at the level of rural section
      8                   Geographical and summarised census data from 2018 at the level of block
      9              Geographical and summarised census data from 2018 at the level of urban zone

# Dictionary works as expected

    Code
      geospatial_dictionary("mpio")
    Output
                          variable         tipo longitud
      1        codigo_departamento         Text        2
      2   codigo_municipio_sin_con         Text        3
      3                  municipio         Text      250
      4           codigo_municipio         Text        5
      5                    version Long Integer       NA
      6                       area       Double       NA
      7                    latitud       Double       NA
      8                   longitud       Double       NA
      9                  encuestas       Double       NA
      10                enc_etnico       Double       NA
      11             enc_no_etnico       Double       NA
      12    enc_resguardo_indigena       Double       NA
      13          enc_comun_negras       Double       NA
      14        enc_area_protegida       Double       NA
      15     enc_area_no_protegida       Double       NA
      16               un_vivienda       Double       NA
      17                  un_mixto       Double       NA
      18                 un_no_res       Double       NA
      19                    un_lea       Double       NA
      20 un_mixto_no_res_industria       Double       NA
      21  un_mixto_no_res_comercio       Double       NA
      22 un_mixto_no_res_servicios       Double       NA
      23      un_mixto_no_res_agro       Double       NA
      24  un_mixto_no_res_sin_info       Double       NA
      25       un_no_res_industria       Double       NA
      26        un_no_res_comercio       Double       NA
      27       un_no_res_servicios       Double       NA
      28            un_no_res_agro       Double       NA
      29   un_no_res_institucional       Double       NA
      30            un_no_res_lote       Double       NA
      31          un_no_res_parque       Double       NA
      32          un_no_res_minero       Double       NA
      33      un_no_res_proteccion       Double       NA
      34     u_no_res_construccion       Double       NA
      35         u_no_res_sin_info       Double       NA
      36                 viviendas       Double       NA
      37                  viv_casa       Double       NA
      38           viv_apartamento       Double       NA
      39                viv_cuarto       Double       NA
      40         viv_trad_indigena       Double       NA
      41           viv_trad_etnica       Double       NA
      42                  viv_otro       Double       NA
      43      viv_ocupado_personas       Double       NA
      44  viv_ocupado_sin_personas       Double       NA
      45              viv_temporal       Double       NA
      46            viv_desocupado       Double       NA
      47                   hogares       Double       NA
      48               viv_energia       Double       NA
      49           viv_sin_energia       Double       NA
      50     viv_energia_estrato_1       Double       NA
      51     viv_energia_estrato_2       Double       NA
      52     viv_energia_estrato_3       Double       NA
      53     viv_energia_estrato_4       Double       NA
      54     viv_energia_estrato_5       Double       NA
      55     viv_energia_estrato_6       Double       NA
      56   viv_energia_sin_estrato       Double       NA
      57             viv_acueducto       Double       NA
      58         viv_sin_acueducto       Double       NA
      59        viv_alcantarillado       Double       NA
      60    viv_sin_alcantarillado       Double       NA
      61                   viv_gas       Double       NA
      62               viv_sin_gas       Double       NA
      63          viv_sin_info_gas       Double       NA
      64           viv_rec_basuras       Double       NA
      65       viv_sin_rec_basuras       Double       NA
      66              viv_internet       Double       NA
      67          viv_sin_internet       Double       NA
      68     viv_sin_info_internet       Double       NA
      69                  personas       Double       NA
      70                  per_leas       Double       NA
      71  per_hogares_particulares       Double       NA
      72                   hombres       Double       NA
      73                   mujeres       Double       NA
      74                 per_0_a_9       Double       NA
      75               per_10_a_19       Double       NA
      76               per_20_a_29       Double       NA
      77               per_30_a_39       Double       NA
      78               per_40_a_49       Double       NA
      79               per_50_a_59       Double       NA
      80               per_60_a_69       Double       NA
      81               per_70_a_79       Double       NA
      82                per_80_mas       Double       NA
      83           per_ed_primaria       Double       NA
      84         per_ed_secundaria       Double       NA
      85           per_ed_superior       Double       NA
      86           per_ed_posgrado       Double       NA
      87      per_ed_sin_educacion       Double       NA
      88           per_ed_sin_info       Double       NA
                                                                                                               descripcion
      1                                                                                            Código del departamento
      2                                                                                 Código que identifica al municipio
      3                                                                                               Nombre del municipio
      4                                                                     Código concatenado que identifica al municipio
      5                                                                                   Año de la información geográfica
      6                      Área del municipio en metros cuadrados  (Sistema de coordenadas planas MAGNA_Colombia_Bogota)
      7                                                                      Coordenada de latitud centroide del municipio
      8                                                                     Coordenada de longitud centroide del municipio
      9                                                                                    Cantidad de Encuestas CNPV 2018
      10                                                   Cantidad de encuestas que reportaron estar en territorio étnico
      11                                                Cantidad de encuestas que reportaron no estar en territorio étnico
      12                                Cantidad de encuestas que reportaron estar en territorio étnico Resguardo indígena
      13        Cantidad de encuestas que reportaron estar en territorio étnico Territorio colectivo de comunidades negras
      14                                                    Cantidad de encuestas que reportaron estar en áreas protegidas
      15                                                 Cantidad de encuestas que reportaron no estar en áreas protegidas
      16                                                                               Conteo de unidades con uso vivienda
      17                                                                                  Conteo de unidades con uso mixto
      18                                                                         Conteo de unidades con uso no residencial
      19                                                                                    Conteo de unidades con uso LEA
      20                                                        Conteo de unidades mixtas con uso no residencial industria
      21                                                         Conteo de unidades mixtas con uso no residencial comercio
      22                                                        Conteo de unidades mixtas con uso no residencial servicios
      23                           Conteo de unidades mixtas con uso no residencial agropecuario, agroindustrial, forestal
      24                                                  Conteo de unidades mixtas con uso no residencial sin información
      25                                                             Conteo de unidades no residénciales con uso Industria
      26                                                              Conteo de unidades no residénciales con uso Comercio
      27                                                             Conteo de unidades no residénciales con uso Servicios
      28                                Conteo de unidades no residénciales con uso Agropecuario, Agroindustrial, Forestal
      29                                                         Conteo de unidades no residénciales con uso Institucional
      30                                        Conteo de unidades no residénciales con uso Lote (Unidad sin construcción)
      31                                                     Conteo de unidades no residénciales con uso Parque/Zona Verde
      32                                                     Conteo de unidades no residénciales con uso Minero-Energético
      33                                     Conteo de unidades no residénciales con uso Protección/Conservación ambiental
      34                                                       Conteo de unidades no residénciales con uso En Construcción
      35                                                       Conteo de unidades no residénciales con uso Sin información
      36                                                                                               Conteo de viviendas
      37                                                                                     Conteo de viviendas tipo Casa
      38                                                                              Conteo de viviendas tipo Apartamento
      39                                                                                   Conteo de viviendas tipo cuarto
      40                                                            Conteo de viviendas tipo Vivienda tradicional Indígena
      41                               Conteo de viviendas tipo Vivienda tradicional étnica (Afrocolombiana, Isleña, Rrom)
      42               Conteo de viviendas tipo Otro (contenedor, carpa, embarcación, vagón, cueva, refugio natural, etc.)
      43                                                                Conteo de viviendas Ocupada con personas presentes
      44                                                       Conteo de viviendas Ocupada con todas las personas ausentes
      45                                            Conteo de viviendas Vivienda  temporal (para vacaciones, trabajo etc.)
      46                                                                                    Conteo de viviendas Desocupada
      47                                                                                                 Conteo de hogares
      48                                                                         Conteo de viviendas con energía eléctrica
      49                                                                         Conteo de viviendas sin energía eléctrica
      50                            Conteo de viviendas que reportan recibir facturación de energía eléctrica en Estrato 1
      51                            Conteo de viviendas que reportan recibir facturación de energía eléctrica en Estrato 2
      52                            Conteo de viviendas que reportan recibir facturación de energía eléctrica en Estrato 3
      53                            Conteo de viviendas que reportan recibir facturación de energía eléctrica en Estrato 4
      54                            Conteo de viviendas que reportan recibir facturación de energía eléctrica en Estrato 5
      55                            Conteo de viviendas que reportan recibir facturación de energía eléctrica en Estrato 6
      56           Conteo de viviendas que reportan recibir facturación de energía eléctrica en No sabe o no tiene estrato
      57                                                                     Conteo de viviendas con servicio de acueducto
      58                                                                     Conteo de viviendas sin servicio de acueducto
      59                                                                Conteo de viviendas con servicio de alcantarillado
      60                                                                Conteo de viviendas sin servicio de alcantarillado
      61                                           Conteo de viviendas con servicio de gas natural conectado a red pública
      62                                           Conteo de viviendas sin servicio de gas natural conectado a red pública
      63                            Conteo de viviendas sin información de servicio de gas natural conectado a red pública
      64                                                        Conteo de viviendas con servicio de recolección de basuras
      65                                                        Conteo de viviendas sin servicio de recolección de basuras
      66                                                                      Conteo de viviendas con servicio de internet
      67                                                                      Conteo de viviendas sin servicio de internet
      68                                                       Conteo de viviendas sin información de servicio de internet
      69                                                                                                Número de personas
      70                                                                                        Conteo de personas en LEAS
      71                                                                        Conteo de personas en hogares particulares
      72                                                                                                 Conteo de hombres
      73                                                                                                 Conteo de mujeres
      74                                                                               Conteo de personas entre 0 - 9 años
      75                                                                             Conteo de personas entre 10 - 19 años
      76                                                                             Conteo de personas entre 20 - 29 años
      77                                                                             Conteo de personas entre 30 - 39 años
      78                                                                             Conteo de personas entre 40 - 49 años
      79                                                                             Conteo de personas entre 50 - 59 años
      80                                                                             Conteo de personas entre 60 - 69 años
      81                                                                             Conteo de personas entre 70 - 79 años
      82                                                                           Conteo de personas entre 80  y más años
      83 Conteo de personas donde el nivel educativo del último año alcanzado es Preescolar - Pre jardín Y Básica primaria
      84                   Conteo de personas donde el nivel educativo del último año alcanzado es Básica secundaria 3...6
      85          Conteo de personas donde el nivel educativo del último año alcanzado es Técnica profesional 1 año  7...9
      86  Conteo de personas donde el nivel educativo del último año alcanzado es Especialización 1 año…maestría doctorado
      87                                   Conteo de personas donde el nivel educativo del último año alcanzado es Ninguno
      88                           Conteo de personas donde el nivel educativo del último año alcanzado es Sin información
                                                                                categoria_original
      1                                                                                       <NA>
      2                                                                                       <NA>
      3                                                                                       <NA>
      4                                                                                       <NA>
      5                                                                                       <NA>
      6                                                                                       <NA>
      7                                                                                       <NA>
      8                                                                                       <NA>
      9                                                                                       <NA>
      10                                                                                      <NA>
      11                                                                                      <NA>
      12                                                                        Resguardo Indígena
      13                                                                                      TCCN
      14                                                                            Área protegida
      15                                                                                      <NA>
      16                                                                                  Vivienda
      17 Mixto (Espacio independiente y separado que combina vivienda con otro uso no residencial)
      18     Unidad NO Residencial (Espacio independiente y separado con uso diferente a vivienda)
      19                                                       Lugar especial de alojamiento (LEA)
      20                                                                                 Industria
      21                                                                                  Comercio
      22                                                                                 Servicios
      23                                                    Agropecuario, Agroindustrial, Forestal
      24                                                                           Sin información
      25                                                                                 Industria
      26                                                                                  Comercio
      27                                                                                 Servicios
      28                                                    Agropecuario, Agroindustrial, Forestal
      29                                                                             Institucional
      30                                                            Lote (Unidad sin construcción)
      31                                                                         Parque/Zona Verde
      32                                                                         Minero-Energético
      33                                                         Protección/Conservación ambiental
      34                                                                           En Construcción
      35                                                                           Sin información
      36                                                                                      <NA>
      37                                                                                      Casa
      38                                                                               Apartamento
      39                                                                               Tipo cuarto
      40                                                             Vivienda tradicional Indígena
      41                                Vivienda tradicional étnica (Afrocolombiana, Isleña, Rrom)
      42                Otro (contenedor, carpa, embarcación, vagón, cueva, refugio natural, etc.)
      43                                                            Ocupada con personas presentes
      44                                                   Ocupada con todas las personas ausentes
      45                                        Vivienda  temporal (para vacaciones, trabajo etc.)
      46                                                                                Desocupada
      47                                                                                      <NA>
      48                                                                                        Si
      49                                                                                        No
      50                                                                                 Estrato 1
      51                                                                                 Estrato 2
      52                                                                                 Estrato 3
      53                                                                                 Estrato 4
      54                                                                                 Estrato 5
      55                                                                                 Estrato 6
      56                                                                No sabe o no tiene estrato
      57                                                                                        Si
      58                                                                                        No
      59                                                                                        Si
      60                                                                                        No
      61                                                                                        Si
      62                                                                                        No
      63                                                                           Sin información
      64                                                                                        Si
      65                                                                                        No
      66                                                                                        Si
      67                                                                                        No
      68                                                                           Sin información
      69                                                                                      <NA>
      70                                                                                      <NA>
      71                                                                                      <NA>
      72                                                                                    Hombre
      73                                                                                     Mujer
      74                                                                                0 - 9 años
      75                                                                              10 - 19 años
      76                                                                              20 - 29 años
      77                                                                              30 - 39 años
      78                                                                              40 - 49 años
      79                                                                              50 - 59 años
      80                                                                              60 - 69 años
      81                                                                              70 - 79 años
      82                                                                            80  y más años
      83                                                   Preescolar - PrejardinBásica primaria 1
      84                                          Básica secundaria 6Media técnica 10Normalista 10
      85                             Técnica profesional 1 añoTecnológica 1 añoUniversitario 1 año
      86                                        Especialización 1 añoMaestria 1 añoDoctorado 1 año
      87                                                                                   Ninguno
      88                                                                           Sin información

# Climate tags works as expected

    Code
      get_climate_tags()
    Output
           etiqueta                                   variable
      1    TSSM_CON                Temperatura seca (ambiente)
      2    THSM_CON                         Temperatura húmeda
      3     TMN_CON                         Temperatura mínima
      4     TMX_CON                         Temperatura máxima
      5    TSTG_CON Temperatura seca (ambiente) del termógrafo
      6      HR_CAL                           Humedad relativa
      7    HRHG_CON            Humedad relativa del hidrógrafo
      8      TV_CAL                           Tensión de vapor
      9     TPR_CAL                             Punto de rocío
      10   PTPM_CON                              Precipitación
      11   PTPG_CON                              Precipitación
      12   EVTE_CON                                Evaporación
      13     FA_CON                       Fenómeno atmosférico
      14     NB_CON                                  Nubosidad
      15   RCAM_CON                       Recorrido del viento
      16   BSHG_CON                               Brillo solar
      17   VVAG_CON                       Velocidad del viento
      18   DVAG_CON                       Dirección del viento
      19 VVMXAG_CON                Velocidad máxima del viento
      20 DVMXAG_CON                Dirección máxima del viento
                                      frecuencia
      1  Horaria (07:00, 13:00, 18:00 y/o 19:00)
      2  Horaria (07:00, 13:00, 18:00 y/o 19:00)
      3                                   Diaria
      4                                   Diaria
      5                       Horaria (24 horas)
      6  Horaria (07:00, 13:00, 18:00 y/o 19:00)
      7                        Horaria (24 horas
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

# Lookup works as expected

    Code
      look_up(keywords = c("school", "age"), logic = "and")
    Output
                          name       group source year        level
      49 DANE_CNPVPD_2018_18PD demographic   DANE 2018   department
      50 DANE_CNPVPD_2018_18PM demographic   DANE 2018 municipality
                    category
      49 persons_demographic
      50 persons_demographic
                                                                                                                                                  description
      49 Census population aged 5 years and over, registered in particular households, by school attendance, according to department, area, age group and sex
      50         Census population aged 5 years and over, registered in particular households, by school attendance, by municipality, area, age group and sex

