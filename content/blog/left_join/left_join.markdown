---
title: Unir o cruzar datos con left_join()
author: Bastián Olea Herrera
date: '2025-08-16'
draft: true
format:
  hugo-md:
    output-file: "index"
    output-ext: "md"
slug: []
categories: []
tags:
  - procesamiento de datos
  - limpieza de datos
---



El _left join_ es una de las operaciones básicas del trabajo con datos, en el sentido de que realiza una operación sencilla que a la vez es muy útil. Sirve tanto para limpiar datos como para procesarlos y obtener nuevas relaciones entre ellos.

Un _left join_ realiza unión o combinación entre dos tablas de datos a partir de una variable en común o _llave_ (_key_). En otras palabras, un _left join_ toma dos tablas que tienen datos distintos, pero que a la vez comparten una variable o columna en común, y usa esta variable en común para **unir las observaciones de ambas tablas**.



{{< imagen "left_join_a.png" >}}


{{< bajada "Esquema de una unión entre tablas con _left join_" >}}




En el ejemplo anterior, tenemos dos tablas, ambas con tres variables distintas, pero en ambas tablas tenemos una variable que contiene información equivalente. En la vida real, esto podrían ser nombres de personas, nombres de países, identificadores únicos de personas o instituciones, fechas, etcétera. Esta variable compartida entre las tablas es la **llave** que usaremos para la unión.

Al realiazr la unión con _left join_ obtenemos una nueva tabla que combina las observaciones de ambas, uniendo las filas de la primera tabla (_x_) con las filas de al segunda tabla (_y_) que se correspondan según la llave en común.



{{< imagen "left_join_b.png" >}}


{{< bajada "Esquema del resultado del _left join_" >}}




## Ejemplo de una unión de tablas en R

Para unir dos tablas en R, usamos la función `left_join()` de `{dplyr}`.




``` r
library(dplyr)
```



Primero creemos una tabla de base con datos de ejemplo.




``` r
animales_a <- tibble(animal = c("perro", "gato", "pez"),
                     color = c("gris", "negro", "azul"))
```


| animal | color |
|:------:|:-----:|
| perro  | gris  |
|  gato  | negro |
|  pez   | azul  |



En esa tabla tenemos tres observaciones que corresponden a animales, descritos en la primera columna, y una segunda columna con características de los mismos.

Ahora creemos una segunda tabla, que además de tener la misma columna que describe a los animales, agrega una nueva variable sobre estos animalitos:




``` r
animales_b <- tibble(animal = c("perro", "gato", "pez"),
                     patas = c(4, 3, 0))
```


| animal | patas |
|:------:|:-----:|
| perro  |   4   |
|  gato  |   3   |
|  pez   |   0   |



Dado que ambas tablas comparten la variable `animal`, si hacemos un _left join_ ambas tablas se cruzarán en base a esta variable, resultando en una tabla nueva:




``` r
animales_2 <- left_join(animales_a, animales_b)
```

```
## Joining with `by = join_by(animal)`
```


| animal | color | patas |
|:------:|:-----:|:-----:|
| perro  | gris  |   4   |
|  gato  | negro |   3   |
|  pez   | azul  |   0   |



El resultado de la unión es una nueva tabla que tiene las tres variables únicas obtenidas del cruce de las dos tablas distintas. En este caso, el _left join_ nos permite agregar información sobre una misma unidad de observación proveniente de distintas fuentes.


## Otro ejemplo

Veamos un segundo ejemplo con más filas y más columnas:




``` r
animales_x <- tibble(animal = c("gato", "ratón", "perro", "pez"),
                     color = c("gris", "negro", "blanco", "azul"),
                     tamaño = c(34, 16, 50, 3))
```


| animal | color  | tamaño |
|:------:|:------:|:------:|
|  gato  |  gris  |   34   |
| ratón  | negro  |   16   |
| perro  | blanco |   50   |
|  pez   |  azul  |   3    |


``` r
animales_y <- tibble(animal = c("perro", "gato", "pez"),
                     patas = c(4, 3, 0),
                     edad = c(8, 3, 1))
```


| animal | patas | edad |
|:------:|:-----:|:----:|
| perro  |   4   |  8   |
|  gato  |   3   |  3   |
|  pez   |   0   |  1   |


Las dos tablas que tenemos ahora tienen distinta cantidad de observaciones, y además las observaciones clave (columna `animal`) que se usarán como llave de unión están desordenadas.

En este caso, la primera tabla (`animales_x`) tiene 4 filas, pero la segunda tabla (`animales_y`) tiene menos filas que la primera. En estos casos, el orden de la unión es importante: en un _**left** join_ la primera tabla (o izquierda) es la tabla principal, a la cual se le agregan las columnas de una segunda tabla, en base a las coincidencias de la columna de llave. Por lo tanto, si unimos o cruzamos las tablas poniendo primero la tabla más grande y después la más pequeña, obtendremos casos perdidos por las filas de la primera tabla que no obtuvieron coincidencias en la segunda.




``` r
animales_3 <- left_join(animales_x, animales_y)
```

```
## Joining with `by = join_by(animal)`
```


| animal | color  | tamaño | patas | edad |
|:------:|:------:|:------:|:-----:|:----:|
|  gato  |  gris  |   34   |   3   |  3   |
| ratón  | negro  |   16   |  NA   |  NA  |
| perro  | blanco |   50   |   4   |  8   |
|  pez   |  azul  |   3    |   0   |  1   |



Como podemos ver, obtenemos celdas con `NA` en la observación _ratón_, debido a que en la segunda tabla (`animales_y`) no habían datos sobre este animalito. Una pena 😔

También sería una opción hacer el cruce al revés, poniendo primero la tabla `animales_y` (3 filas) y después `animales_x` (4 filas), con el objetivo de que las observaciones de la tabla `animales_x` complementen las observaciones de `animales_y` donde hayan coincidencias, y descartando los casos que no tienen en común:




``` r
animales_3 <- left_join(animales_y, animales_x)
```

```
## Joining with `by = join_by(animal)`
```


| animal | patas | edad | color  | tamaño |
|:------:|:-----:|:----:|:------:|:------:|
| perro  |   4   |  8   | blanco |   50   |
|  gato  |   3   |  3   |  gris  |   34   |
|  pez   |   0   |  1   |  azul  |   3    |



Ahora no tenemos datos perdidos, porque si bien `animales_x` tenía más observaciones que `animales_y`, `animales_y` contenía todas las observaciones de `animales_x` identificadas por la variable `animal`, lo que podemos confirmar [comparando las diferencias entre ambas columnas con la función `waldo::compare()`](/blog/diferencias):




``` r
library(waldo)

compare(sort(animales_x$animal), 
        sort(animales_y$animal))
```

```
## `old`: "gato" "perro" "pez" "ratón"
## `new`: "gato" "perro" "pez"
```



## Conclusión

Podemos usar `left_join()` para **completar los datos** sobre nuestra unidad de análisis si la información viene diseminada en distintas tablas o archivos. Pero también podemos utilizarla para **complementar datos** desde distintas fuentes, aumentando la información que tenemos sobre las observaciones que estemos estudiando, o bien, para realizar **cruces de información** que nos entreguen coincidencias relevantes. Un caso icónico de _left join_ fue el [estudio realizado por la Contraloría General de la República de Chile](https://www.biobiochile.cl/noticias/nacional/chile/2025/05/20/contraloria-detecta-que-25-mil-funcionarios-publicos-salieron-del-pais-mientras-estaban-con-licencia.shtml), donde se cruzaron dos bases de datos que tenían en común la posibilidad de identificar funcionarios públicos:

> Se trata de un estudio a partir del cruce de información de las salidas del país registradas por la Policía de Investigaciones (PDI), la base de funcionarios públicos y las licencias médicas que se otorgaron entre el 2023 y 2024.


