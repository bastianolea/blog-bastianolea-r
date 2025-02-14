---
title: Usando R para trabajar con datos
author: Bastián Olea Herrera
date: '2024-11-16'
format:
  hugo-md:
    output-file: index
    output-ext: md
weight: 5
draft: true
series: Introducción a R
slug: []
categories:
  - Tutoriales
tags:
  - dplyr
lang: es
excerpt: Prueba
execute:
  error: true
---


## Paquetes

``` r
install.packages("dplyr")
```

``` r
library("dplyr")
```


    Attaching package: 'dplyr'

    The following objects are masked from 'package:stats':

        filter, lag

    The following objects are masked from 'package:base':

        intersect, setdiff, setequal, union

``` r
# crear una tabla: opción a
tibble(a = 1:10,
       b = 1:10,
       c = 11:20)
```

    # A tibble: 10 × 3
           a     b     c
       <int> <int> <int>
     1     1     1    11
     2     2     2    12
     3     3     3    13
     4     4     4    14
     5     5     5    15
     6     6     6    16
     7     7     7    17
     8     8     8    18
     9     9     9    19
    10    10    10    20

``` r
# crear una tabla: opción b
tribble(~animal,  ~patas, ~color,
        "perro",   4,     "negro",
        "mapache", 4,     "gris",
        "ganso",   2,     "blanco"
)
```

    # A tibble: 3 × 3
      animal  patas color 
      <chr>   <dbl> <chr> 
    1 perro       4 negro 
    2 mapache     4 gris  
    3 ganso       2 blanco
