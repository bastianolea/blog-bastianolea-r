---
title: 'Copia y pega datos en R con {datapasta}'
author: Bastián Olea Herrera
date: '2025-06-06'
slug: []
categories: []
draft: false
format:
  hugo-md:
    output-file: index
    output-ext: md
tags:
  - consejos
  - datos
editor_options:
  chunk_output_type: console
excerpt: >-
  `{datapasta}` es un paquete para R que te ayuda a copiar y pegar datos desde y
  hacia R. Este paquete convierte tus datos en texto que puedes copiar y pegar
  en otro lado, o editar manualmente. Usa la función `dpasta()` sobre un
  dataframe para hacer que los datos aparezcan como en texto directamente debajo
  de donde la ejecutaste.
---


[`{datapasta}`](https://github.com/MilesMcBain/datapasta) es un paquete para R que te ayuda a copiar y pegar datos desde y hacia R.

Instala `{datapasta}` ejecutando el siguiente código:

``` r
install.packages("datapasta", repos = c(mm = "https://milesmcbain.r-universe.dev", getOption("repos")))
```

## Copiar

`{datapasta}` puede ayudarte a **compartir fácilmente datos**, al convertir tus datos en texto que puedes copiar y pegar en otro lado, o editar manualmente. Usa la función `dpasta()` sobre un dataframe para hacer que los datos aparezcan como en texto directamente debajo de donde la ejecutaste.

Por ejemplo, creemos una tabla pequeña:

``` r
library(dplyr)

tabla <- iris |> 
  slice_sample(n = 5) |> 
  tibble()
```

``` r
tabla
```

    # A tibble: 5 × 5
      Sepal.Length Sepal.Width Petal.Length Petal.Width Species   
             <dbl>       <dbl>        <dbl>       <dbl> <fct>     
    1          6.4         2.8          5.6         2.1 virginica 
    2          6.6         3            4.4         1.4 versicolor
    3          5.9         3            5.1         1.8 virginica 
    4          6.5         3            5.2         2   virginica 
    5          4.4         2.9          1.4         0.2 setosa    

Imagínate que queremos corregir esta tabla, usarla como ejemplo, o compartirla con alguien. Entonces usamos la función `dpasta()`:

``` r
datapasta::dpasta(tabla)
```

¡Magia! Aparecerá el siguiente código en nuestro script:

``` r
tibble::tribble(
     ~Sepal.Length, ~Sepal.Width, ~Petal.Length, ~Petal.Width,     ~Species,
                 6,            3,           4.8,          1.8,  "virginica",
               5.7,          2.9,           4.2,          1.3, "versicolor",
               7.7,          2.8,           6.7,            2,  "virginica",
               6.8,          2.8,           4.8,          1.4, "versicolor",
               4.6,          3.2,           1.4,          0.2,     "setosa"
     )
```

Al ejecutar este código podemos re-crear el dataframe. Es decir, obtenemos los datos como texto que luego podemos usar para crear un nuevo dataframe. Esto tiene varias utilidades:

-   transformar los datos a texto para poder editarlos manualmente (corregir cifras, agregar observaciones)
-   compartir pequeñas tablas con otras personas (adjuntando los datos como texto en un scirpt o correo)
-   corregir manualmente datos pequeños para los que no valdría la pena programar soluciones (por ejemplo, cambiar faltas de ortografía)
-   "guardar" datos en un script para eliminar la dependencia de un archivo externo, sobre todo si se trata de pocos datos (por ejemplo, para crear un diccionario de las variables o libro de códigos)

Este tipo de tablas de datos almacenadas como código se llaman [`tribble`](https://tibble.tidyverse.org/reference/tribble.html), y su gracia es que muestran los datos tal como los veríamos en un dataframe o planilla, con la conveniencia de que podemos editarlos, incluso agregar nuevas filas o columnas si seguimos su sencilla sintaxis.

## Pegar

`{datapasta}` también nos ayuda a *pegar* en R datos que sacamos desde otro sitio, con la función `tribble_paste()`. Usando esta función podemos copiar datos de una tabla de Excel o de una página web y pegarlos como un dataframe en R.

¡Probemos" Selecciona la siguiente tabla[^1] y cópiala:

| País               | PIB (PPP) | PIB (per capita) |
|:-------------------|----------:|-----------------:|
| Brazil             |  4958.122 |            23238 |
| Mexico             |  3395.916 |            25462 |
| Argentina          |  1493.423 |            31379 |
| Colombia           |  1190.795 |            22421 |
| Chile              |   710.195 |            35146 |
| Peru               |   643.052 |            18688 |
| Dominican Republic |   336.082 |            30874 |
| Ecuador            |   300.122 |            16578 |
| Guatemala          |   282.833 |            15633 |
| Venezuela          |   223.984 |             8397 |

``` r
datapasta::tribble_paste()
```

En tu consola aparecerá el código necesario para cargar la tabla copiada en R!

``` r
tibble::tribble(
                    ~PAÍS, ~`PIB.(PPP)`, ~`PIB.(PER.CAPITA)`,
                 "Brazil",     4958.122,              23238L,
                 "Mexico",     3395.916,              25462L,
              "Argentina",     1493.423,              31379L,
               "Colombia",     1190.795,              22421L,
                  "Chile",      710.195,              35146L,
                   "Peru",      643.052,              18688L,
     "Dominican Republic",      336.082,              30874L,
                "Ecuador",      300.122,              16578L,
              "Guatemala",      282.833,              15633L,
              "Venezuela",      223.984,               8397L
     )
```

[^1]: Fuente: [Wikipedia](https://en-m-wikipedia-org.translate.goog/wiki/List_of_Latin_American_and_Caribbean_countries_by_GDP_(PPP))
