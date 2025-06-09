---
title: Cargar archivos csv más rápido en R con Arrow
author: Bastián Olea Herrera
date: '2025-02-12'
format: hugo-md
slug: []
categories: []
tags:
  - consejos
  - datos
  - optimización
execute:
  eval: true
---


Los archivos `csv` (*comma-separated values,* valores separados por comas) suelen ser el formato más básico para guardar datos. Los beneficios que tienen los csv con respecto a compatibilidad y accesibilidad son a su vez la causa de sus desventajas: son más pesados porque sus datos no se guardan comprimidos, y suelen ser **más lentos de cargar**, porque los datos no vienen codificados de una forma optimizada.

Sin embargo, usualmente grandes bases de datos son guardadas en archivos csv, con varios millones de filas, lo que puede hacer que la carga de un archivo dure entre varios segundos a **minutos**.

Hagamos una comparación cargando un archivo csv de 2,5 GB[^1], con más de 16 millones de filas y 12 columnas, por medio de 3 funciones: `read.csv()` de R base, `read_csv` de [{readr}](https://readr.tidyverse.org), y `read_csv_arrow` de [{arrow}](https://arrow.apache.org/docs/r/).

``` r
library(readr)
library(arrow)
library(tictoc) # para medir el tiempo que tardan

archivo <- "~/Downloads/Beneficiarios Fonasa 2023.csv" # ruta de la base
```

## 1. `read.csv()`

Esta función viene por defecto en R, y es la que peor desempeño tiene, además de cargar los datos en un dataframe tradicional en lugar de un [tibble](https://tibble.tidyverse.org):

``` r
tic()
datos <- read.csv(archivo, encoding = "latin1")
toc()
```

    48.875 sec elapsed

La carga del archivo demora casi un minuto con este método por defecto.

## 2. `readr::read_csv()`

El paquete {readr} es muy versátil para leer y escribir datos con un desempeño aceptable y una sintaxis consistente:

``` r
tic()
datos <- readr::read_csv(archivo,
                         locale = locale(encoding = "latin1"),
                         show_col_types = F)
toc()
```

    25.183 sec elapsed

Usando este método de carga, obtenemos resultados casi tres veces más rápido que con el método de R por defecto! Además, obtenemos los datos en un cómodo y moderno `tibble`. Pero todavía puede ser más rápido...

## 3. `arrow::read_csv_arrow()`

Los desarrolladores de la [tecnología Arrow](https://arrow.apache.org), principalmente conocida por el excelente [formato de datos columnares `.parquet`](https://arrow.apache.org/docs/r/articles/arrow.html#reading-and-writing-data) (que supera a cualquier otro en velocidad de lectura y eficiencia de almacenamiento), ofrecen una [función optimizada](https://arrow.apache.org/docs/r/reference/read_delim_arrow.html) para la lectura de archivos csv:

``` r
tic()
datos <- arrow::read_csv_arrow(archivo,
                               read_options = csv_read_options(encoding = "latin1"))
toc()
```

    8.094 sec elapsed

¡Sólo 7 segundos! Confirmamos que el paquete {arrow} ofrece un lector optimizado de archivos csv que supera en velocidad a cualquier otro que podamos usar en R.

## Conclusiones

Realicemos un *benchmark* para contar con los datos claros sobre el veredicto final:

``` r
resultado <- bench::mark(check = FALSE, iterations = 1,
                         base = read.csv(archivo, encoding = "latin1"),
                         readr = readr::read_csv(archivo, locale = locale(encoding = "latin1"), show_col_types = F),
                         arrow = arrow::read_csv_arrow(archivo, read_options = csv_read_options(encoding = "latin1")),
)
resultado
```

    # A tibble: 3 × 6
      expression      min   median `itr/sec` mem_alloc `gc/sec`
      <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
    1 base            47s      47s    0.0213    5.71GB    0.170
    2 readr         32.1s    32.1s    0.0311    1.45GB    0    
    3 arrow         12.6s    12.6s    0.0791  123.83MB    0    

En el resultado final de este experimento, cargar un archivo csv con `arrow::read_csv_arrow()` resulta casi el doble de rápido que cargarlo con `readr::read_csv()`, y más de cinco veces más rápido que cargarlo con el típico `read.csv()`!

Si revisamos la columna `mem_alloc`, también podemos confirmar que, además de ser más rápido, ocupa muchísima menos memoria para llevar a cabo la carga: mientras R base consume casi 6 GB de memoria, Arrow lo logra con ~120 MB!

En el análisis de datos, si bien la conveniencia es un factor primordial (código más sencillo, legible y fácil de escribir nos permite generar resultados mucho más rápido), siempre es posible replantearnos la forma en que trabajamos para pensar alternativas más optimizadas y veloces, si es que el volumen de datos con los que trabajamos lo amerita.

[^1]: Se trata de una base de datos de beneficiarios del Fondo Nacional de Salud de Chile (Fonasa), disponible [en su sitio web de datos abiertos](https://datosabiertos.fonasa.cl/dimensiones-beneficiarios/). Una versión agregada de los datos está [disponible en mi GitHub.](https://github.com/bastianolea/fonasa_beneficiarios?tab=readme-ov-file)
