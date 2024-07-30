# Aggregation for dry-bulb temperature works as expected

    Code
      aggregate_climate(base_tssm, "year")
    Output
      # A tibble: 4 x 6
         station longitude latitude   date       tag      value
           <dbl> <chr>     <chr>      <date>     <chr>    <dbl>
      1 27015090 -75.55325 6.31969444 2014-01-01 TSSM_CON  24.4
      2 27015090 -75.55325 6.31969444 2015-01-01 TSSM_CON  NA  
      3 27015330 -75.59    6.22       2014-01-01 TSSM_CON  25.0
      4 27015330 -75.59    6.22       2015-01-01 TSSM_CON  NA  

# Aggregation for precipitation works as expected

    Code
      aggregate_climate(base_ptpm, "month")
    Output
      # A tibble: 40 x 6
          station longitude    latitude   date       tag      value
            <dbl> <chr>        <chr>      <date>     <chr>    <dbl>
       1 26205080 -75.70094444 6.34105556 2020-06-01 PTPM_CON   NA 
       2 26205080 -75.70094444 6.34105556 2020-07-01 PTPM_CON  325.
       3 26205080 -75.70094444 6.34105556 2020-08-01 PTPM_CON  147.
       4 26205080 -75.70094444 6.34105556 2020-09-01 PTPM_CON  252.
       5 26205080 -75.70094444 6.34105556 2020-10-01 PTPM_CON   NA 
       6 27010770 -75.70508333 6.17833333 2020-06-01 PTPM_CON   NA 
       7 27010770 -75.70508333 6.17833333 2020-07-01 PTPM_CON  393 
       8 27010770 -75.70508333 6.17833333 2020-08-01 PTPM_CON  292 
       9 27010770 -75.70508333 6.17833333 2020-09-01 PTPM_CON  337 
      10 27010770 -75.70508333 6.17833333 2020-10-01 PTPM_CON   NA 
      # i 30 more rows

