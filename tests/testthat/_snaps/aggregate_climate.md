# Aggregation for sunshine duration works as expected

    Code
      aggregate_climate(base_bshg, "year")
    Output
      # A tibble: 3 x 6
         station longitude latitude date       tag      value
           <dbl>     <dbl>    <dbl> <date>     <chr>    <lgl>
      1 27015090     -75.6     6.32 1990-01-01 BSHG_CON NA   
      2 27015210     -75.5     6.28 1990-01-01 BSHG_CON NA   
      3 27015330     -75.6     6.22 1990-01-01 BSHG_CON NA   

# Aggregation for precipitation works as expected

    Code
      aggregate_climate(base_ptpm, "year")
    Output
      # A tibble: 19 x 6
          station longitude latitude date       tag      value
            <dbl>     <dbl>    <dbl> <date>     <chr>    <lgl>
       1 21210020     -75.3     4.56 2020-01-01 PTPM_CON NA   
       2 21210030     -75.3     4.51 2020-01-01 PTPM_CON NA   
       3 21210080     -75.3     4.49 2020-01-01 PTPM_CON NA   
       4 21210110     -75.3     4.52 2020-01-01 PTPM_CON NA   
       5 21210120     -75.2     4.49 2020-01-01 PTPM_CON NA   
       6 21210140     -75.5     4.38 2020-01-01 PTPM_CON NA   
       7 21210180     -75.4     4.52 2020-01-01 PTPM_CON NA   
       8 21210190     -75.1     4.27 2020-01-01 PTPM_CON NA   
       9 21210200     -75.1     4.34 2020-01-01 PTPM_CON NA   
      10 21210220     -75.3     4.58 2020-01-01 PTPM_CON NA   
      11 21210230     -75.2     4.43 2020-01-01 PTPM_CON NA   
      12 21210240     -75.2     4.42 2020-01-01 PTPM_CON NA   
      13 21210260     -75.4     4.63 2020-01-01 PTPM_CON NA   
      14 21215130     -75.5     4.34 2020-01-01 PTPM_CON NA   
      15 21220050     -75.1     4.35 2020-01-01 PTPM_CON NA   
      16 21240030     -75.1     4.54 2020-01-01 PTPM_CON NA   
      17 21240070     -75.1     4.64 2020-01-01 PTPM_CON NA   
      18 21245010     -75.2     4.43 2020-01-01 PTPM_CON NA   
      19 22050100     -75.1     4.66 2020-01-01 PTPM_CON NA   

