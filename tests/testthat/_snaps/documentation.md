# List datasets works as expected

    Code
      list_datasets("geospatial")
    Output
                        name      group source year         level category
      1   DANE_MGN_2018_DPTO geospatial   DANE 2018    department     maps
      2   DANE_MGN_2018_MPIO geospatial   DANE 2018  municipality     maps
      3 DANE_MGN_2018_MPIOCL geospatial   DANE 2018  municipality     maps
      4   DANE_MGN_2018_SETU geospatial   DANE 2018  urban_sector     maps
      5   DANE_MGN_2018_SETR geospatial   DANE 2018  rural_sector     maps
      6   DANE_MGN_2018_SECU geospatial   DANE 2018 urban_section     maps
      7   DANE_MGN_2018_SECR geospatial   DANE 2018 rural_section     maps
      8    DANE_MGN_2018_MZN geospatial   DANE 2018         block     maps
      9     DANE_MGN_2018_ZU geospatial   DANE 2023    urban_zone     maps
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
      dictionary("DANE_MGN_2018_DPTO")
    Output
                          variable         tipo longitud
      1        codigo_departamento         Text        2
      2               departamento         Text      250
      3                    version Long Integer       NA
      4                       area       Double       NA
      5                    latitud       Double       NA
      6                   longitud       Double       NA
      7                  encuestas       Double       NA
      8                 enc_etnico       Double       NA
      9              enc_no_etnico       Double       NA
      10    enc_resguardo_indigena       Double       NA
      11          enc_comun_negras       Double       NA
      12        enc_area_protegida       Double       NA
      13     enc_area_no_protegida       Double       NA
      14               un_vivienda       Double       NA
      15                  un_mixto       Double       NA
      16                 un_no_res       Double       NA
      17                    un_lea       Double       NA
      18 un_mixto_no_res_industria       Double       NA
      19  un_mixto_no_res_comercio       Double       NA
      20 un_mixto_no_res_servicios       Double       NA
      21      un_mixto_no_res_agro       Double       NA
      22  un_mixto_no_res_sin_info       Double       NA
      23       un_no_res_industria       Double       NA
      24        un_no_res_comercio       Double       NA
      25       un_no_res_servicios       Double       NA
      26            un_no_res_agro       Double       NA
      27   un_no_res_institucional       Double       NA
      28            un_no_res_lote       Double       NA
      29          un_no_res_parque       Double       NA
      30          un_no_res_minero       Double       NA
      31      un_no_res_proteccion       Double       NA
      32     u_no_res_construccion       Double       NA
      33         u_no_res_sin_info       Double       NA
      34                 viviendas       Double       NA
      35                  viv_casa       Double       NA
      36           viv_apartamento       Double       NA
      37                viv_cuarto       Double       NA
      38         viv_trad_indigena       Double       NA
      39           viv_trad_etnica       Double       NA
      40                  viv_otro       Double       NA
      41      viv_ocupado_personas       Double       NA
      42  viv_ocupado_sin_personas       Double       NA
      43              viv_temporal       Double       NA
      44            viv_desocupado       Double       NA
      45                   hogares       Double       NA
      46               viv_energia       Double       NA
      47           viv_sin_energia       Double       NA
      48     viv_energia_estrato_1       Double       NA
      49     viv_energia_estrato_2       Double       NA
      50     viv_energia_estrato_3       Double       NA
      51     viv_energia_estrato_4       Double       NA
      52     viv_energia_estrato_5       Double       NA
      53     viv_energia_estrato_6       Double       NA
      54   viv_energia_sin_estrato       Double       NA
      55             viv_acueducto       Double       NA
      56         viv_sin_acueducto       Double       NA
      57        viv_alcantarillado       Double       NA
      58    viv_sin_alcantarillado       Double       NA
      59                   viv_gas       Double       NA
      60               viv_sin_gas       Double       NA
      61          viv_sin_info_gas       Double       NA
      62           viv_rec_basuras       Double       NA
      63       viv_sin_rec_basuras       Double       NA
      64              viv_internet       Double       NA
      65          viv_sin_internet       Double       NA
      66     viv_sin_info_internet       Double       NA
      67                  personas       Double       NA
      68                  per_leas       Double       NA
      69  per_hogares_particulares       Double       NA
      70                   hombres       Double       NA
      71                   mujeres       Double       NA
      72                 per_0_a_9       Double       NA
      73               per_10_a_19       Double       NA
      74               per_20_a_29       Double       NA
      75               per_30_a_39       Double       NA
      76               per_40_a_49       Double       NA
      77               per_50_a_59       Double       NA
      78               per_60_a_69       Double       NA
      79               per_70_a_79       Double       NA
      80                per_80_mas       Double       NA
      81           per_ed_primaria       Double       NA
      82         per_ed_secundaria       Double       NA
      83           per_ed_superior       Double       NA
      84           per_ed_posgrado       Double       NA
      85      per_ed_sin_educacion       Double       NA
      86           per_ed_sin_info       Double       NA
                                                                                                               descripcion
      1                                                                                            Código del departamento
      2                                                                                            Nombre del departamento
      3                                                              Año de la vigencia de la información del departamento
      4                    Área del departamento en metros cuadrados (Sistema de coordenadas planas MAGNA_Colombia_Bogota)
      5                                                                   Coordenada de latitud centroide del departamento
      6                                                                  Coordenada de longitud centroide del departamento
      7                                                                                    Cantidad de Encuestas CNPV 2018
      8                                                    Cantidad de encuestas que reportaron estar en territorio étnico
      9                                                 Cantidad de encuestas que reportaron no estar en territorio étnico
      10                                Cantidad de encuestas que reportaron estar en territorio étnico Resguardo indígena
      11        Cantidad de encuestas que reportaron estar en territorio étnico Territorio colectivo de comunidades negras
      12                                                    Cantidad de encuestas que reportaron estar en áreas protegidas
      13                                                 Cantidad de encuestas que reportaron no estar en áreas protegidas
      14                                                                               Conteo de unidades con uso vivienda
      15                                                                                  Conteo de unidades con uso mixto
      16                                                                         Conteo de unidades con uso no residencial
      17                                                                                    Conteo de unidades con uso LEA
      18                                                        Conteo de unidades mixtas con uso no residencial industria
      19                                                         Conteo de unidades mixtas con uso no residencial comercio
      20                                                        Conteo de unidades mixtas con uso no residencial servicios
      21                           Conteo de unidades mixtas con uso no residencial agropecuario, agroindustrial, forestal
      22                                                  Conteo de unidades mixtas con uso no residencial sin información
      23                                                             Conteo de unidades no residénciales con uso Industria
      24                                                              Conteo de unidades no residénciales con uso Comercio
      25                                                             Conteo de unidades no residénciales con uso Servicios
      26                                Conteo de unidades no residénciales con uso Agropecuario, Agroindustrial, Forestal
      27                                                         Conteo de unidades no residénciales con uso Institucional
      28                                        Conteo de unidades no residénciales con uso Lote (Unidad sin construcción)
      29                                                     Conteo de unidades no residénciales con uso Parque/Zona Verde
      30                                                     Conteo de unidades no residénciales con uso Minero-Energético
      31                                     Conteo de unidades no residénciales con uso Protección/Conservación ambiental
      32                                                       Conteo de unidades no residénciales con uso En Construcción
      33                                                       Conteo de unidades no residénciales con uso Sin información
      34                                                                                               Conteo de viviendas
      35                                                                                     Conteo de viviendas tipo Casa
      36                                                                              Conteo de viviendas tipo Apartamento
      37                                                                                   Conteo de viviendas tipo cuarto
      38                                                            Conteo de viviendas tipo Vivienda tradicional Indígena
      39                               Conteo de viviendas tipo Vivienda tradicional étnica (Afrocolombiana, Isleña, Rrom)
      40               Conteo de viviendas tipo Otro (contenedor, carpa, embarcación, vagón, cueva, refugio natural, etc.)
      41                                                                Conteo de viviendas Ocupada con personas presentes
      42                                                       Conteo de viviendas Ocupada con todas las personas ausentes
      43                                            Conteo de viviendas Vivienda  temporal (para vacaciones, trabajo etc.)
      44                                                                                    Conteo de viviendas Desocupada
      45                                                                                                 Conteo de hogares
      46                                                                         Conteo de viviendas con energía eléctrica
      47                                                                         Conteo de viviendas sin energía eléctrica
      48                            Conteo de viviendas que reportan recibir facturación de energía eléctrica en Estrato 1
      49                            Conteo de viviendas que reportan recibir facturación de energía eléctrica en Estrato 2
      50                            Conteo de viviendas que reportan recibir facturación de energía eléctrica en Estrato 3
      51                            Conteo de viviendas que reportan recibir facturación de energía eléctrica en Estrato 4
      52                            Conteo de viviendas que reportan recibir facturación de energía eléctrica en Estrato 5
      53                            Conteo de viviendas que reportan recibir facturación de energía eléctrica en Estrato 6
      54           Conteo de viviendas que reportan recibir facturación de energía eléctrica en No sabe o no tiene estrato
      55                                                                     Conteo de viviendas con servicio de acueducto
      56                                                                     Conteo de viviendas sin servicio de acueducto
      57                                                                Conteo de viviendas con servicio de alcantarillado
      58                                                                Conteo de viviendas sin servicio de alcantarillado
      59                                           Conteo de viviendas con servicio de gas natural conectado a red pública
      60                                           Conteo de viviendas sin servicio de gas natural conectado a red pública
      61                            Conteo de viviendas sin información de servicio de gas natural conectado a red pública
      62                                                        Conteo de viviendas con servicio de recolección de basuras
      63                                                        Conteo de viviendas sin servicio de recolección de basuras
      64                                                                      Conteo de viviendas con servicio de internet
      65                                                                      Conteo de viviendas sin servicio de internet
      66                                                       Conteo de viviendas sin información de servicio de internet
      67                                                                                                Número de personas
      68                                                                                        Conteo de personas en LEAS
      69                                                                        Conteo de personas en hogares particulares
      70                                                                                                 Conteo de hombres
      71                                                                                                 Conteo de mujeres
      72                                                                               Conteo de personas entre 0 - 9 años
      73                                                                             Conteo de personas entre 10 - 19 años
      74                                                                             Conteo de personas entre 20 - 29 años
      75                                                                             Conteo de personas entre 30 - 39 años
      76                                                                             Conteo de personas entre 40 - 49 años
      77                                                                             Conteo de personas entre 50 - 59 años
      78                                                                             Conteo de personas entre 60 - 69 años
      79                                                                             Conteo de personas entre 70 - 79 años
      80                                                                           Conteo de personas entre 80  y más años
      81 Conteo de personas donde el nivel educativo del último año alcanzado es Preescolar - Pre jardín Y Básica primaria
      82                   Conteo de personas donde el nivel educativo del último año alcanzado es Básica secundaria 3...6
      83          Conteo de personas donde el nivel educativo del último año alcanzado es Técnica profesional 1 año  7...9
      84  Conteo de personas donde el nivel educativo del último año alcanzado es Especialización 1 año…maestría doctorado
      85                                   Conteo de personas donde el nivel educativo del último año alcanzado es Ninguno
      86                           Conteo de personas donde el nivel educativo del último año alcanzado es Sin información
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
      10                                                                        Resguardo Indígena
      11                                                                                      TCCN
      12                                                                            Área protegida
      13                                                                                      <NA>
      14                                                                                  Vivienda
      15 Mixto (Espacio independiente y separado que combina vivienda con otro uso no residencial)
      16     Unidad NO Residencial (Espacio independiente y separado con uso diferente a vivienda)
      17                                                       Lugar especial de alojamiento (LEA)
      18                                                                                 Industria
      19                                                                                  Comercio
      20                                                                                 Servicios
      21                                                    Agropecuario, Agroindustrial, Forestal
      22                                                                           Sin información
      23                                                                                 Industria
      24                                                                                  Comercio
      25                                                                                 Servicios
      26                                                    Agropecuario, Agroindustrial, Forestal
      27                                                                             Institucional
      28                                                            Lote (Unidad sin construcción)
      29                                                                         Parque/Zona Verde
      30                                                                         Minero-Energético
      31                                                         Protección/Conservación ambiental
      32                                                                           En Construcción
      33                                                                           Sin información
      34                                                                                      <NA>
      35                                                                                      Casa
      36                                                                               Apartamento
      37                                                                               Tipo cuarto
      38                                                             Vivienda tradicional Indígena
      39                                Vivienda tradicional étnica (Afrocolombiana, Isleña, Rrom)
      40                Otro (contenedor, carpa, embarcación, vagón, cueva, refugio natural, etc.)
      41                                                            Ocupada con personas presentes
      42                                                   Ocupada con todas las personas ausentes
      43                                        Vivienda  temporal (para vacaciones, trabajo etc.)
      44                                                                                Desocupada
      45                                                                                      <NA>
      46                                                                                        Si
      47                                                                                        No
      48                                                                                 Estrato 1
      49                                                                                 Estrato 2
      50                                                                                 Estrato 3
      51                                                                                 Estrato 4
      52                                                                                 Estrato 5
      53                                                                                 Estrato 6
      54                                                                No sabe o no tiene estrato
      55                                                                                        Si
      56                                                                                        No
      57                                                                                        Si
      58                                                                                        No
      59                                                                                        Si
      60                                                                                        No
      61                                                                           Sin información
      62                                                                                        Si
      63                                                                                        No
      64                                                                                        Si
      65                                                                                        No
      66                                                                           Sin información
      67                                                                                      <NA>
      68                                                                                      <NA>
      69                                                                                      <NA>
      70                                                                                    Hombre
      71                                                                                     Mujer
      72                                                                                0 - 9 años
      73                                                                              10 - 19 años
      74                                                                              20 - 29 años
      75                                                                              30 - 39 años
      76                                                                              40 - 49 años
      77                                                                              50 - 59 años
      78                                                                              60 - 69 años
      79                                                                              70 - 79 años
      80                                                                            80  y más años
      81                                                   Preescolar - PrejardinBásica primaria 1
      82                                          Básica secundaria 6Media técnica 10Normalista 10
      83                             Técnica profesional 1 añoTecnológica 1 añoUniversitario 1 año
      84                                        Especialización 1 añoMaestria 1 añoDoctorado 1 año
      85                                                                                   Ninguno
      86                                                                           Sin información

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

