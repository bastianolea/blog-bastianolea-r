---
title: Calcular resúmenes de datos con `dplyr::summarize()`
author: Bastián Olea Herrera
date: '2025-11-24'
format:
  hugo-md:
    output-file: index
    output-ext: md
weight: 8
draft: true
series: Introducción a R
slug: []
categories:
  - Tutoriales
tags:
  - dplyr
  - básico
lang: es
excerpt: Prueba
execute:
  error: true
  eval: true
---


En el [tutorial anterior de introducción a `{dplyr}`](../../../../blog/r_introduccion/dplyr_intro/) aprendimos a ordenar, seleccionar, y filtrar datos tabulares. Con estas operaciones básicas deberíamos poder desenvolvernos con tablas de datos.

En esta ocasión, avanzaremos hacia las herramientas que nos permiten **crear datos nuevos** a partir de los datos que ya aprendimos a manejar.

Si queremos tener más control sobre los cálculos de estadísticos descriptivos, podemos usar `{dplyr}`.

Vamos a partir viendo cómo se hace un sólo estadístico descriptivo promedio para una sola variable, y vamos a ir avanzando desde ahí hasta poder aplicar **múltiples estadísticos descriptivos a todas las variables**.

### Calcular promedio con `summarize()`

Si bien `{dplyr}` no tiene una función que lo haga automáticamente como `summary()`, podemos usar la función `summarize()` para calcular **resúmenes estadísticos**. A `summarize()` le damos una función que usaremos para *resumir* los datos a una sola fila.

Por ejemplo, calculemos el **promedio** de una variable:

``` r
library(dplyr)

iris |> 
  summarize(
    promedio = mean(Sepal.Length)
  )
```

      promedio
    1 5.843333

### Calcular promedio de varias variables con `summarize(across())`

Para hacerlo más útil, en vez de calcular para una sola variable, podemos pedirle que calcule el promedio para todas las variables numéricas. Esto lo logramos usando `across()`, que permite aplicar las operaciones a varias columnas a la vez, indicando que queremos aplicar la operación *donde* (`where()`) las variables *sean numéricas* (`is.numeric`).

Entonces, este código calculará el promedio para todas las columnas numéricas del *dataframe*:

``` r
iris |> 
  summarize(             # resumir los datos
    across(              # donde las columnas
      where(is.numeric), # sean numéricas
      ~mean(.x),         # calculando el promedio
      .names = "{col}_promedio") # cambiar el nombre de columnas
  )
```

      Sepal.Length_promedio Sepal.Width_promedio Petal.Length_promedio
    1              5.843333             3.057333                 3.758
      Petal.Width_promedio
    1             1.199333

{{< cursos >}}
{{< cafecito >}}
