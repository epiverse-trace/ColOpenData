# Merge geospatial and demographic works as expected

    Code
      merge_geo_demographic("DANE_CNPVH_2018_1HD")
    Message
      ColOpenData provides open data derived from Departamento Administrativo
      Nacional de Estadística (DANE), and Instituto de Hidrología,
      Meteorología y Estudios Ambientales (IDEAM) but with modifications for
      specific functional needs. These changes may alter the structure,
      format, or content, meaning the data does not reflect the official
      dataset. The package is developed independently, with no endorsement or
      involvement from these institutions or any Colombian government body.
      The authors of ColOpenData are not liable for how users utilize the
      data, and users areresponsible for any outcomes from their use or
      analysis of the data.
      Stored by Universidad de Los Andes under the Epiverse TRACE iniative.
    Output
      Simple feature collection with 33 features and 9 fields
      Geometry type: MULTIPOLYGON
      Dimension:     XY
      Bounding box:  xmin: -81.73562 ymin: -4.229407 xmax: -66.84722 ymax: 13.3945
      Geodetic CRS:  WGS 84
      First 10 features:
         codigo_departamento departamento version        area    latitud  longitud
      1                   05    Antioquia    2018 62804708983  6.9227964 -75.56499
      2                   08    Atlántico    2018  3315752105 10.6770095 -74.96522
      3                   11 Bogotá, D.C.    2018  1622852605  4.3161077 -74.18107
      4                   13      Bolívar    2018 26719196397  8.7452708 -74.50864
      5                   15       Boyacá    2018 23138048132  5.7766072 -73.10207
      6                   17       Caldas    2018  7425221672  5.3420663 -75.30688
      7                   18      Caquetá    2018 90103008160  0.7985562 -73.95947
      8                   19        Cauca    2018 31242914793  2.3968339 -76.82423
      9                   20        Cesar    2018 22562344407  9.5366599 -73.51783
      10                  23      Córdoba    2018 25086546966  8.3585498 -75.79201
         total_hogares hogares_con_menores_de_15_anos total_menores_de_15_anos
      1        1983566                         778216                  1173475
      2         625123                         328051                   556253
      3        2514482                         927769                  1331282
      4         542694                         290370                   513311
      5         381868                         158874                   252952
      6         309680                         114765                   169983
      7         116166                          59067                    99985
      8         432493                         194630                   306779
      9         316717                         178781                   325361
      10        466615                         242715                   421017
                                   geom
      1  MULTIPOLYGON (((-74.83058 8...
      2  MULTIPOLYGON (((-74.91077 1...
      3  MULTIPOLYGON (((-74.15067 4...
      4  MULTIPOLYGON (((-76.17318 9...
      5  MULTIPOLYGON (((-72.04767 7...
      6  MULTIPOLYGON (((-74.66496 5...
      7  MULTIPOLYGON (((-73.66003 1...
      8  MULTIPOLYGON (((-76.05542 3...
      9  MULTIPOLYGON (((-72.90075 1...
      10 MULTIPOLYGON (((-75.70005 9...

