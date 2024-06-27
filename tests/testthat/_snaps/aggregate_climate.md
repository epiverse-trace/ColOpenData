# Aggregation for sunshine duration works as expected

    Code
      aggregate_climate(base_bshg, "year")
    Output
      # A tibble: 3 x 6
         station longitude latitude   date       tag      value
           <dbl> <chr>     <chr>      <date>     <chr>    <lgl>
      1 27015090 -75.55325 6.31969444 1990-01-01 BSHG_CON NA   
      2 27015210 -75.5     6.28333333 1990-01-01 BSHG_CON NA   
      3 27015330 -75.59    6.22       1990-01-01 BSHG_CON NA   

# Aggregation for precipitation works as expected

    Code
      aggregate_climate(base_ptpm, "year")
    Output
      # A tibble: 19 x 6
          station longitude    latitude   date       tag      value
            <dbl> <chr>        <chr>      <date>     <chr>    <lgl>
       1 21210020 -75.32163889 4.55630556 2020-01-01 PTPM_CON NA   
       2 21210030 -75.30083333 4.51105556 2020-01-01 PTPM_CON NA   
       3 21210080 -75.28994444 4.49427778 2020-01-01 PTPM_CON NA   
       4 21210110 -75.27788889 4.52094444 2020-01-01 PTPM_CON NA   
       5 21210120 -75.23941667 4.49091667 2020-01-01 PTPM_CON NA   
       6 21210140 -75.49686111 4.38375    2020-01-01 PTPM_CON NA   
       7 21210180 -75.40983333 4.5195     2020-01-01 PTPM_CON NA   
       8 21210190 -75.14841667 4.2745     2020-01-01 PTPM_CON NA   
       9 21210200 -75.07344444 4.33513889 2020-01-01 PTPM_CON NA   
      10 21210220 -75.32566667 4.58011111 2020-01-01 PTPM_CON NA   
      11 21210230 -75.20775    4.42972222 2020-01-01 PTPM_CON NA   
      12 21210240 -75.22055556 4.42102778 2020-01-01 PTPM_CON NA   
      13 21210260 -75.38333333 4.63333333 2020-01-01 PTPM_CON NA   
      14 21215130 -75.51858333 4.34138889 2020-01-01 PTPM_CON NA   
      15 21220050 -75.05305556 4.35344444 2020-01-01 PTPM_CON NA   
      16 21240030 -75.07538889 4.54244444 2020-01-01 PTPM_CON NA   
      17 21240070 -75.09       4.6375     2020-01-01 PTPM_CON NA   
      18 21245010 -75.20052222 4.42966667 2020-01-01 PTPM_CON NA   
      19 22050100 -75.09694444 4.65655556 2020-01-01 PTPM_CON NA   

