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
      1  DPTO_CCDGO         Text        2
      2  DPTO_CNMBR         Text      250
      3     VERSION Long Integer       NA
      4        AREA       Double       NA
      5     LATITUD       Double       NA
      6    LONGITUD       Double       NA
      7  STCTNENCUE       Double       NA
      8   STP3_1_SI       Double       NA
      9   STP3_2_NO       Double       NA
      10   STP3A_RI       Double       NA
      11  STP3B_TCN       Double       NA
      12  STP4_1_SI       Double       NA
      13  STP4_2_NO       Double       NA
      14 STP9_1_USO       Double       NA
      15 STP9_2_USO       Double       NA
      16 STP9_3_USO       Double       NA
      17 STP9_4_USO       Double       NA
      18 STP9_2_1_M       Double       NA
      19 STP9_2_2_M       Double       NA
      20 STP9_2_3_M       Double       NA
      21 STP9_2_4_M       Double       NA
      22 STP9_2_9_M       Double       NA
      23 STP9_3_1_N       Double       NA
      24 STP9_3_2_N       Double       NA
      25 STP9_3_3_N       Double       NA
      26 STP9_3_4_N       Double       NA
      27 STP9_3_5_N       Double       NA
      28 STP9_3_6_N       Double       NA
      29 STP9_3_7_N       Double       NA
      30 STP9_3_8_N       Double       NA
      31 STP9_3_9_N       Double       NA
      32  STP9_3_10       Double       NA
      33  STP9_3_99       Double       NA
      34 STVIVIENDA       Double       NA
      35 STP14_1_TI       Double       NA
      36 STP14_2_TI       Double       NA
      37 STP14_3_TI       Double       NA
      38 STP14_4_TI       Double       NA
      39 STP14_5_TI       Double       NA
      40 STP14_6_TI       Double       NA
      41 STP15_1_OC       Double       NA
      42 STP15_2_OC       Double       NA
      43 STP15_3_OC       Double       NA
      44 STP15_4_OC       Double       NA
      45  TSP16_HOG       Double       NA
      46 STP19_EC_1       Double       NA
      47 STP19_ES_2       Double       NA
      48 STP19_EE_1       Double       NA
      49 STP19_EE_2       Double       NA
      50 STP19_EE_3       Double       NA
      51 STP19_EE_4       Double       NA
      52 STP19_EE_5       Double       NA
      53 STP19_EE_6       Double       NA
      54 STP19_EE_9       Double       NA
      55 STP19_ACU1       Double       NA
      56 STP19_ACU2       Double       NA
      57 STP19_ALC1       Double       NA
      58 STP19_ALC2       Double       NA
      59 STP19_GAS1       Double       NA
      60 STP19_GAS2       Double       NA
      61 STP19_GAS9       Double       NA
      62 STP19_REC1       Double       NA
      63 STP19_REC2       Double       NA
      64 STP19_INT1       Double       NA
      65 STP19_INT2       Double       NA
      66 STP19_INT9       Double       NA
      67 STP27_PERS       Double       NA
      68 STPERSON_L       Double       NA
      69 STPERSON_S       Double       NA
      70 STP32_1_SE       Double       NA
      71 STP32_2_SE       Double       NA
      72 STP34_1_ED       Double       NA
      73 STP34_2_ED       Double       NA
      74 STP34_3_ED       Double       NA
      75 STP34_4_ED       Double       NA
      76 STP34_5_ED       Double       NA
      77 STP34_6_ED       Double       NA
      78 STP34_7_ED       Double       NA
      79 STP34_8_ED       Double       NA
      80 STP34_9_ED       Double       NA
      81 STP51_PRIM       Double       NA
      82 STP51_SECU       Double       NA
      83 STP51_SUPE       Double       NA
      84 STP51_POST       Double       NA
      85 STP51_13_E       Double       NA
      86 STP51_99_E       Double       NA
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

