---
title: 'Cálculos multiprocesador en R con `{furrr}`'
author: Bastián Olea Herrera
format: hugo-md
date: 2024-09-05T00:00:00.000Z
tags:
  - procesamiento de datos
lang: es
excerpt: >-
  Si tienes que trabajar con bases de datos muy grandes, puedes acelerar el
  cálculo usando todos los procesadores de tu computador con tan sólo un par de
  líneas, usando `{purrr}` y `{furrr}`.
---


Si tienes que trabajar con bases de datos muy grandes, puedes acelerar el cálculo usando todos los procesadores de tu computador con tan sólo un par de líneas, usando `{purrr}` y `{furrr}`.

``` r
library (dplyr) 

# cálculo normal, un solo procesador
datos |>
  count (id, palabra)

# cálculo multiprocesador
library(furrr)
plan(multisession,workers=8) # procesadores a usar

datos |> 
  # crear variable con 8 niveles de igual cantidad de filas
  mutate (grupos = (row_number ()-1) %/% (n()/8)) |>
  # separar el dataframe en una lista con un dataframe por grupo
  group_split (grupos) |>
  # calcular multiprocesador, un grupo por procesador
  future_map(~count(.x, id, palabra)) |>
  # volver a unir resultados en un solo dataframe
  list_rbind()
```
