---
title: Conectores o _pipes_
author: Bastián Olea Herrera
date: '2025-11-24'
format:
  hugo-md:
    output-file: index
    output-ext: md
weight: 9
draft: true
series: Introducción a R
categories:
  - Tutoriales
tags:
  - dplyr
lang: es
excerpt: Prueba
execute:
  error: true
  eval: true
---


``` r
datos <- c(4, 6, 3, 7, 8, 6)

mean(datos)
```

    [1] 5.666667

``` r
round(mean(datos))
```

    [1] 6

Redondear el promedio de datos

``` r
library(dplyr)
datos |> mean() |> round()
```

    [1] 6

A datos le calculo el promedio y lo redondeo

``` r
datos
```

    [1] 4 6 3 7 8 6

``` r
# crear tabla de datos de ejemplo con tribble
library(dplyr)

animales <- tibble(animal = c("gato", "ratón", "perro", "pez", "paloma"),
                   color = c("gris", "negro", "blanco", "azul", "gris"),
                   patas = c(4, 4, 4, 0, 2),
                   edad = c(8, 2, 10, 1, 3))
```

``` r
select(animales, animal, patas, edad)
```

``` r
filter(select(animales, animal, patas, edad), patas >= 4)
```

``` r
arrange(filter(select(animales, animal, patas, edad), patas >= 4), edad)
```

``` r
animales2 <- select(animales, animal, patas, edad)
animales3 <- filter(animales2, patas >= 4)
animales4 <- arrange(animales3, edad)
print(animales4)
```

``` r
animales |> 
  select(animal, patas, edad) |> 
  filter(patas >= 4) |> 
  arrange(edad)
```

{{< cursos >}}
{{< cafecito >}}
