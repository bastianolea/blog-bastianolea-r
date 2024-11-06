---
title: Comparar el rendimiento expresiones en R
author: Bastián Olea Herrera
format: hugo-md
date: 2024-11-05T00:00:00.000Z
tags:
  - consejos
  - procesamiento de datos
lang: es
excerpt: >-
  Para comparar el rendimiento de distintas expresiones en R, realizamos un
  _benchmark,_ al cual le entregamos las expresiones que queremos comparar, y
  nos entregará un detalle de su velocidad de ejecución. Así podemos optar por
  una de las operaciones en base a su mejor rendimiento.
---


Al programar algo, siempre existen varias formas de lograr un mismo objetivo. Un criterio para elegir una forma por sobre otra puede ser el rendimiento: si hay dos formas de hacer algo, elegir la forma que se ejecute más rápido.[^1]

Para comparar el rendimiento de distintas expresiones en R, realizamos un *benchmark,* al cual le entregamos las expresiones que queremos comparar, y nos entregará un detalle de su velocidad de ejecución, consumo de memoria, y otros.

Como ejemplo, crearemos un dataframe de 100 millones de filas, con dos variables.

``` r
library(dplyr)

# crear datos
datos <- tibble(var1 = runif(n = 1e8),
                var2 = runif(n = 1e8))

datos
```

    # A tibble: 100,000,000 × 2
         var1  var2
        <dbl> <dbl>
     1 0.0725 0.628
     2 0.664  0.358
     3 0.169  0.119
     4 0.0369 0.879
     5 0.708  0.546
     6 0.607  0.835
     7 0.955  0.839
     8 0.198  0.197
     9 0.564  0.456
    10 0.788  0.960
    # ℹ 99,999,990 more rows

Pongámonos en el caso de que queremos filtrar este dataframe, y en consideración de su gran tamaño, queremos ver la forma más veloz de filtrarlo. Para ello, comparamos la evaluación de un filtro con `{dplyr}`, y otro con `{base}` (las funciones por defecto de R, que usualmente son más rápidas).

Usamos la función `bench::mark`, a la cual le entregamos las expresiones con un nombre para distinguirlas, y le definimos los argumentos `check = FALSE` para que ignore diferencias en el resultado e `iterations` para especificar la cantidad de veces que queremos hacer las comparaciones (con más iteraciones nos aseguramos que el desempeño sea *normal* y no influenciado por factores externos de nuestro computador).

``` r
# comparar ejecución
bench::mark(check = FALSE, iterations = 5,
            "dplyr" = datos |> filter(var1 > var2),
            "base" = datos[datos$var1 > datos$var2, ]
)
```

    # A tibble: 2 × 6
      expression      min   median `itr/sec` mem_alloc `gc/sec`
      <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
    1 dplyr         453ms    467ms      2.13    2.42GB     2.98
    2 base          331ms    339ms      2.92     1.3GB     1.17

En la comparación vemos que `dplyr::filter()` es aproximadamente 100 milisegundos más lento que un filtro realizado con `{base}`, pero además usa casi 1GB más de memoria. También entrega datos como las iteraciones por segundo, es decir, las veces que se ejecutaría cada operación por segundo. Todas estas métricas nos podrían ayudar a decidir una opción por sobre otra.

[^1]: mi opinión personal es que, entre valorar tiempo de ejecución (que algo corra más rápido) y tiempo de desarrollo (lo que te cuesta escribirlo/entenderlo), el tiempo de desarrollo (es decir, tu tiempo como humano o trabajador) es más valioso que tener a un procesador trabajando por más tiempo. En ese sentido, usualmente considero que es mejor la opción que sea más fácil de programar, y también más fácil de leer e interpretar. Sin embargo, hay casos donde la velocidad puede primar, como es el caso de aplicaciones interactivas (donde la espera se la traspasas a tus usuarios/as), o en cálculos con cantidades grandes de datos, donde cada centésima de segundo de ejecución se puede multiplicar por millones.
