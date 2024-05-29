# Merge geospational demographic works as expected

    Code
      merge_geo_demographic(demographic_dataset = "DANE_CNPVH_2018_1HM", column = "condicion")
    Message
      Original data is retrieved from the National Administrative Department
      of Statistics (Departamento Administrativo Nacional de Estadística -
      DANE).
      Reformatted by package authors.
      Stored by Universidad de Los Andes under the Epiverse TRACE iniative.
    Output
      Simple feature collection with 1122 features and 11 fields
      Geometry type: MULTIPOLYGON
      Dimension:     XY
      Bounding box:  xmin: -81.73562 ymin: -4.229406 xmax: -66.84722 ymax: 13.39473
      Geodetic CRS:  WGS 84
      First 10 features:
         codigo_municipio codigo_departamento codigo_municipio_sin_con   municipio
      1             05001                  05                      001    Medellín
      2             05002                  05                      002   Abejorral
      3             05004                  05                      004    Abriaquí
      4             05021                  05                      021  Alejandría
      5             05030                  05                      030       Amagá
      6             05031                  05                      031      Amalfi
      7             05034                  05                      034       Andes
      8             05036                  05                      036 Angelópolis
      9             05038                  05                      038   Angostura
      10            05040                  05                      040       Anorí
         version       area  latitud  longitud total_hogares
      1     2018  374830625 6.257590 -75.61103        815493
      2     2018  507134114 5.803728 -75.43847          6028
      3     2018  296955980 6.627569 -76.08598           776
      4     2018  128932153 6.365534 -75.09060          1384
      5     2018   84132477 6.032922 -75.70800          8884
      6     2018 1209126871 6.977789 -74.98124          6798
      7     2018  402502562 5.623952 -75.92459         12242
      8     2018   81876302 6.121430 -75.71595          1722
      9     2018  338666482 6.861499 -75.35832          3316
      10    2018 1413773904 7.193111 -75.10849          4741
         hogares_con_menores_de_15_anos total_menores_de_15_anos
      1                          283536                   403928
      2                            2278                     3545
      3                             281                      435
      4                             564                      857
      5                            3553                     5017
      6                            3113                     4959
      7                            5030                     7784
      8                             657                     1016
      9                            1615                     2525
      10                           2436                     4120
                               geometry
      1  MULTIPOLYGON (((-75.66974 6...
      2  MULTIPOLYGON (((-75.46938 5...
      3  MULTIPOLYGON (((-76.08351 6...
      4  MULTIPOLYGON (((-75.0332 6....
      5  MULTIPOLYGON (((-75.67587 6...
      6  MULTIPOLYGON (((-74.91836 7...
      7  MULTIPOLYGON (((-75.86822 5...
      8  MULTIPOLYGON (((-75.69149 6...
      9  MULTIPOLYGON (((-75.27173 6...
      10 MULTIPOLYGON (((-74.90935 7...

