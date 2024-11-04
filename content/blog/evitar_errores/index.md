---
title: Evitar que un loop se detenga debido a errores
author: Bastián Olea Herrera
format: hugo-md
date: 2024-09-13T00:00:00.000Z
categories:
  - Procesamiento de datos
tags:
  - procesamiento de datos
  - loops
lang: es
excerpt: >-
  ¿Tienes que hacer un loop, pero se detiene porque hay un error en uno de los
  pasos? Usa `try()` para que la ejecución no se detenga, o `tryCatch()` para
  atrapar el error y devolver algo distinto, como un mensaje y un return(NULL)
  para que no afecte el resultado.
---


Usando el paquete `{purrr}` para realizar iteraciones o *loops* en nuestro código, vamos a probar tres escenarios ante los que un loop se detendría debido a un error, y formas de solucionarlo.

``` r
library(purrr)

números <- list(1, 2, 3, "error", 5)
```

En el primer escenario, el loop intenta sumar `100` a un vector de números, pero se encuentra con que uno de los números es un texto, por lo tanto la ejecución se detiene con un error:

``` r
# loop que se detiene por un error
map(números, \(número) {
  message("sumando ", número)
  número + 100
})
```

    sumando 1

    sumando 2

    sumando 3

    sumando error

    Error in `map()`:
    ℹ In index: 4.
    Caused by error in `número + 100`:
    ! non-numeric argument to binary operator

En el segundo escenario, usamos `try()` para que, si ocurre un error, la ejecución no se detenga:

``` r
# loop que se ejecuta a pesar del error, 
# pero introduce datos perdidos
map(números, \(número) {
  message("sumando ", número, " + 100")
  try(número + 100) |> as.numeric()
}) |> 
  unlist()
```

    sumando 1 + 100

    sumando 2 + 100

    sumando 3 + 100

    sumando error + 100

    Error in número + 100 : non-numeric argument to binary operator

    Warning in .f(.x[[i]], ...): NAs introduced by coercion

    sumando 5 + 100

    [1] 101 102 103  NA 105

En el tercer escenario, usamos `tryCatch()`, que nos permite realizar una operación distinta cuando se detecta un error. En este caso, enviar un mensaje personalizado, y retornar un valor distinto en caso de error.

``` r
# loop que se ejecuta a pesar del error, que emite mensaje, 
# y que retorna algo distinto
map(números, \(número) {
  message("sumando ", número, " + 100")
  tryCatch(número + 100,
           error = \(e) {
             message("!!! upsi dupsi en '", número, "'")
             return(NULL)
           })
}) |> 
  unlist()
```

    sumando 1 + 100

    sumando 2 + 100

    sumando 3 + 100

    sumando error + 100

    !!! upsi dupsi en 'error'

    sumando 5 + 100

    [1] 101 102 103 105
