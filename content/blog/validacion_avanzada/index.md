---
title: Validación de datos con {testthat} y {pointblank}
author: Bastián Olea Herrera
date: '2025-10-15'
draft: true
slug: []
categories: []
format:
  hugo-md:
    output-file: index
    output-ext: md
tags:
  - procesamiento de datos
  - consejos
  - automatización
excerpt: >-
  La validación de datos sirve para verificar durante el proceso de análisis si
  los datos cumplen con requerimientos de calidad y con tus expectativas, con el
  objetivo de evitar problemas futuros relacionados a datos inesperados,
  incompletos, o erróneos. En este post veremos dos paquetes para validar el
  funcionamiento de tu código y para validar tus datos.
---


En un [post anterior](../../../blog/validacion_basica) hablé sobre cómo hacer validación básica de datos en R. A grandes razgos, se trataba de crear funciones que contengan pruebas simples para validar la calidad de tus datos, tales como revisar cantidad de filas, cantidad de datos perdidos, y otros.

Dado que R es un lenguaje enfocado en el análisis de datos, existen paquetes que nos pueden ayudar con la validación de datos.

En este post veremos [`{testthat}`](https://rstudio.github.io/pointblank/), un paquete que facilita implementar **pruebas unitarias** a tu código para validar su funcionamiento, y [`{pointblank}`](https://rstudio.github.io/pointblank/), un paquete diseñado para **validación de datos**. En unos minutos aprenderás a usar este paquete para garantizar que tus datos cumplen con tus expectativas de calidad.

------------------------------------------------------------------------

***¿Para qué sirve la validación de datos?*** Para que, en cualquier punto de tus procesos de análisis de datos, puedas verificar si los datos vienen como esperas, o revisar si es que traen *sorpresas*. En la validación de datos se crean **pruebas** para, por ejemplo, confirmar que una columna no tenga datos perdidos, que los valores de una columna estén dentro de un rango esperado, etcétera.

Creemos una pequeña tabla para aprender a validar datos:

``` r
library(dplyr)

datos <- tribble(~animal,   ~patas, ~lindura,    ~color,
                 "mapache",    "4",      100,    "gris",
                 "gato",      "80",       90,   "negro",
                 "pollo",      "2",       NA,  "plumas",
                 "rata",  "cuatro",       90, "#CCCCCC")
```

De inmediato podemos ver en esta tabla creada con `tribble()` que hay varios problemas: la columna `patas` viene como caracteres, hay datos perdidos en `lindura`, y hay un color hexadecimal en `color`.

## Validación con `{testthat}`

A pesar de que `{testthat}` se usa en general para el desarrollo de paquetes, y se enfoca a validar que cálculos y métodos estadísticos funcionen como es esperado, se puede usar igual para análisis de datos.

Asumiendo que nuestro proyecto posee varios scripts donde se procesan los datos, la idea general será **crear pruebas para cada script**, y periodicamente ejecutar las pruebas para confirmar que todo esté en orden. Por cada script crearemos un script de pruebas.

Primero necesitamos crear una carpeta para los tests, y scripts con tests para cada script que queramos validar. Podemos hacerlo a mano, o bien crear una carpeta para las pruebas con `fs::dir_create()`, y dentro creamos los scripts que necesitemos con `fs::file_create()`, siguiendo la convención de anteponer `test` a cada script de pruebas.

Si tenemos un script llamado `datos.R`, creamos un script de pruebas llamado `test-datos.R` dentro de la carpeta `tests/`.

Dentro de este script empezamos a diseñar las pruebas unitarias. Las **pruebas unitarias** son pruebas que validan que una unidad específica de código (una función, un cálculo, una transformación de datos) funcione como se espera.

Usamos la función `test_that()` para definir cada prueba, indicando primero el nombre de la prueba. Dentro, usamos funciones como `expect_true()`, `expect_equal()`, `expect_type()`, para declarar que *esperamos* que luego de cierta operación ocurra algo. Por ejemplo: espero que mi tabla tenga una columna determinada, o que cierta columna sea de cierto tipo. Estas son las condiciones que deben cumplirse para que la prueba pase.

Veamos un ejemplo de una prueba:

``` r
library(testthat)
```


    Attaching package: 'testthat'

    The following object is masked from 'package:dplyr':

        matches

``` r
test_that("números iguales",
          expect_equal(4, 4)
)
```

    Test passed 😀

Esta prueba evalúa si dos números son iguales, y se cumple. Veamos la siguiente prueba:

``` r
test_that("números desiguales",
          expect_equal(4, 5)
)
```

    ── Failure: números desiguales ─────────────────────────────────────────────────
    4 not equal to 5.
    1/1 mismatches
    [1] 4 - 5 == -1

    Error:
    ! Test failed

Como la prueba no se cumple, la prueba nos dará un error explicando en dónde está el problema.

Apliquemos pruebas similares a los datos de ejemplo:

``` r
test_that("se cargaron los datos",
          expect_true(exists("datos"))
)
```

    Test passed 🎊

``` r
test_that("suficientes columnas",
          expect_equal(ncol(datos), 4)
)
```

    Test passed 😸

``` r
test_that("columnas tipo texto",
          expect_type(datos$animal, "character")
)
```

    Test passed 🎊

``` r
test_that("columnas tipo texto",
          expect_type(datos$patas, "numeric")
)
```

    ── Failure: columnas tipo texto ────────────────────────────────────────────────
    datos$patas has type 'character', not 'numeric'.

    Error:
    ! Test failed

RStudio detecta que se trata de un script de pruebas unitarias, y aparece el botón *Run Tests* en la parte superior derecha del script.

Cuando ya tengamos nuestras pruebas, podemos usar `test_file("tests/test-script.R")` para ejecutar las pruebas de un script, o `test_dir("tests.R")` para ejecutar todas las pruebas de la carpeta. Estas funciones que llevarán a cabo la validación podemos ejecutarlas desde donde más nos resulte conveniente: desde algún script principal de nuestro proyecto, desde un script `tests.R` específico para ejecutar las pruebas, al final de cada script del proyecto, al final de un script donde ejecutemos todo el procesamiento de nuestro proyecto, o manualmente.

Un script que nos ayude a ejecutar las validaciones sería algo así:

``` r
# ejecutar pruebas
test_file("tests/test-cargar.R")

# ejecutar todas las pruebas en la carpeta
test_dir("tests/")
```

mostrar pantallazo de como sale cuando se ejecutan todas

------------------------------------------------------------------------

Como un test individual

``` r
# retorna TRUE si la validación es exitosa
pointblank::test_col_vals_not_null(datos_2, columns = comuna)

# retorna error si la validación falla, como stopifnot
pointblank::col_vals_not_null(datos_3, comuna)
```

Como un paso en un pipeline que no hace nada si es válido

``` r
datos_3 |> 
  add_row(comuna = NA) |>
  pointblank::col_vals_not_null(comuna)
```

Por medio de un reporte

``` r
library(pointblank)

datos_3 |> 
  add_row(comuna = NA) |>
  pointblank::col_vals_not_null(columns = "comuna")

agente <- create_agent(datos_3)

agente <- agente |>
  col_is_numeric(columns = codigo_comuna) |>
  col_is_character(columns = c(nombre_comuna, nombre_region)) |>
  col_vals_in_set(columns = codigo_region, set = 1:16) |> 
  col_vals_not_null(columns = c(nombre_comuna, nombre_region))

interrogate(agente)
```

``` r
datos_sucios <- datos_3 |> 
  messy::messy(messiness = 0.2)

agente_b <- create_agent(tbl = datos_sucios,
                         actions = action_levels(
                           warn_at = 0.01,
                           stop_at = 0.2
                         ))

agente_b <- agente_b |>
  col_is_numeric(columns = codigo_comuna) |>
  col_is_character(columns = c(nombre_comuna, nombre_region)) |>
  col_vals_in_set(columns = codigo_region, set = 1:16) |> 
  col_vals_not_null(columns = c(nombre_comuna, nombre_region))

interrogate(agente_b)
```

Si no sabes cómo empezar:

``` r
draft_validation(
  tbl = ~ datos_sucios,
  filename = "validación"
)
```

## Recursos

Workshop: https://github.com/rich-iannone/pointblank-workshop
Guía oficial introductoria: https://rstudio.github.io/pointblank/articles/VALID-I.html
