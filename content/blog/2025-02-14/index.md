---
title: Rellenar datos perdidos usando datos de otra tabla
author: Bastián Olea Herrera
format: hugo-md
date: '2025-02-14'
slug: []
categories: []
tags:
  - dplyr
  - limpieza de datos
  - datos perdidos
---


¿Te ha pasado que tienes una tabla con datos perdidos, y otra tabla con una columna que coincide con la primera tabla, que además cuenta con datos que quieres usar para rellenar las observaciones perdidas? Antes pensaba que esto se resolvía con `left_join()` y algún ajuste para reemplazar los perdidos con los datos anexados. Pero ayer conocí una función que resuelve este problema de inmediato: `rows_update()`!

``` r
library(dplyr) |> suppressPackageStartupMessages()

tabla_1 <- tibble(ciudad = c("Santiago", "Concepción", "Valparaíso", "Arica"),
                  poblacion = c(7123891, 1036142, 1054253, 221364),
                  temperatura = c(NA, 17.6, NA, 19.2))

tabla_1
```

    # A tibble: 4 × 3
      ciudad     poblacion temperatura
      <chr>          <dbl>       <dbl>
    1 Santiago     7123891        NA  
    2 Concepción   1036142        17.6
    3 Valparaíso   1054253        NA  
    4 Arica         221364        19.2

``` r
tabla_2 <- tibble(ciudad = c("Santiago", "Rancagua", "Concepción", "Arica", "Valparaíso"),
                  temperatura = c(22.8, 14.0, 17.6, 19.2, 17.5))

tabla_2
```

    # A tibble: 5 × 2
      ciudad     temperatura
      <chr>            <dbl>
    1 Santiago          22.8
    2 Rancagua          14  
    3 Concepción        17.6
    4 Arica             19.2
    5 Valparaíso        17.5

En este ejemplo, tenemos dos tablas: la primera tiene una columna con datos perdidos o faltantes, y la segunda tabla, de datos similares, contiene las observaciones que en la primera tabla están faltando.

Una solución sería unir ambas tablas con `left_join()`, lo cual resultaría en dos columnas con el mismo nombre a las que se les agregan las letras `x` e `y` para distinguirlas. Luego habría que usar la función `if_else()` para rellenar las filas que tienen casos perdidos con el posible valor de la segunda columna:

``` r
tablas_unidas <- left_join(tabla_1, 
                           tabla_2,
                           by = "ciudad")

tablas_unidas
```

    # A tibble: 4 × 4
      ciudad     poblacion temperatura.x temperatura.y
      <chr>          <dbl>         <dbl>         <dbl>
    1 Santiago     7123891          NA            22.8
    2 Concepción   1036142          17.6          17.6
    3 Valparaíso   1054253          NA            17.5
    4 Arica         221364          19.2          19.2

``` r
# rellenar usando ifelse()
tablas_unidas |>
  mutate(temperatura.rellenada = if_else(is.na(temperatura.x), 
                                         temperatura.y, 
                                         temperatura.x))
```

    # A tibble: 4 × 5
      ciudad     poblacion temperatura.x temperatura.y temperatura.rellenada
      <chr>          <dbl>         <dbl>         <dbl>                 <dbl>
    1 Santiago     7123891          NA            22.8                  22.8
    2 Concepción   1036142          17.6          17.6                  17.6
    3 Valparaíso   1054253          NA            17.5                  17.5
    4 Arica         221364          19.2          19.2                  19.2

Una segunda solución se lograría usando la función de {dplyr} especializada para estos casos: `coalesce()`, a la cual le entregas dos o más columnas, y utiliza el primer dato no perdido entre ellas para generar la nueva columna. En otras palabras, te permite unir varias columnas en una sola, cuando estas columnas pueden tener un mismo dato pero no tiene certeza en cuál de las columnas se encuentra.

``` r
# rellenar usando coalesce()
tablas_unidas |> 
  mutate(temperatura2 = coalesce(temperatura.x, temperatura.y))
```

    # A tibble: 4 × 5
      ciudad     poblacion temperatura.x temperatura.y temperatura2
      <chr>          <dbl>         <dbl>         <dbl>        <dbl>
    1 Santiago     7123891          NA            22.8         22.8
    2 Concepción   1036142          17.6          17.6         17.6
    3 Valparaíso   1054253          NA            17.5         17.5
    4 Arica         221364          19.2          19.2         19.2

La tercera forma me resulta la más conveniente. La función `rows_update()` funciona casi igual que `left_join()`, pero la unión entre ambas tablas se realiza *encima* de la primera tabla, dado que se asume que ambas tablas comparten una *o varias* columnas con datos, y que solamente queremos rellenar la primera tabla con los datos de la segunda tabla cuando estos estén ausentes en la primera.

``` r
tabla_1 |> 
  rows_update(tabla_2, 
              by = "ciudad", 
              unmatched = "ignore")
```

    # A tibble: 4 × 3
      ciudad     poblacion temperatura
      <chr>          <dbl>       <dbl>
    1 Santiago     7123891        22.8
    2 Concepción   1036142        17.6
    3 Valparaíso   1054253        17.5
    4 Arica         221364        19.2

Usando esta alternativa, nos ahorramos el paso de tener las columnas duplicadas y tenerte resolver la duplicidad manualmente, dado que `rows_update()` se encarga de esto.

La conveniencia es que de esta forma puedes rellenar múltiples columnas al mismo tiempo si es que tu segunda tabla también posee múltiples columnas con datos de reemplazo para la primera tabla. El único inconveniente es que a la segunda tabla no le deben sobrar columnas que no estén presentes en la primera tabla, dado que `rows_update()` está enfocada en el reemplazo de datos sobre una primera tabla, no agregar nuevas columnas, como sería en `left_join()`.

{{< cafecito  >}}
