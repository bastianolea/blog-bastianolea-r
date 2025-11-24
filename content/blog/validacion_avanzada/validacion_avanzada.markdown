---
title: Validación de datos con {testthat} y {pointblank}
author: Bastián Olea Herrera
date: '2025-10-15'
draft: false
freeze: true
slug: []
categories: []
format:
  hugo-md:
    output-file: "index"
    output-ext: "md"
tags:
  - procesamiento de datos
  - consejos
  - automatización
  - limpieza de datos
links:
  - icon: registered
    icon_pack: fas
    name: pointblank
    url: https://rstudio.github.io/pointblank/
  - icon: registered
    icon_pack: fas
    name: testthat
    url: https://testthat.r-lib.org
  - icon: youtube
    icon_pack: fab
    name: Workshop
    url: https://r-consortium.org/webinars/how-to-use-pointblank-to-understand-validate-and-document-your-data.html
excerpt: La validación de datos sirve para verificar durante el proceso de análisis si los datos cumplen con requerimientos de calidad y con tus expectativas, con el objetivo de evitar problemas futuros relacionados a datos inesperados, incompletos, o erróneos. En este post veremos dos paquetes para validar el funcionamiento de tu código y para validar tus datos. 
---

{{< imagen "pointblank-1.png" >}}




En un [post anterior](/blog/validacion_basica) hablé sobre cómo hacer validación básica de datos en R. A grandes razgos, vimos la utilidad de crear funciones que contengan pruebas simples para validar la calidad de tus datos, tales como revisar cantidad de filas, cantidad de datos perdidos, y otros. 

Dado que R es un lenguaje enfocado en el análisis de datos, existen varios paquetes que nos pueden ayudar con la validación de datos!

En este post veremos [`{testthat}`](https://testthat.r-lib.org), un paquete que facilita implementar **pruebas unitarias** a tu código para validar su funcionamiento, y [`{pointblank}`](https://rstudio.github.io/pointblank/), un paquete diseñado para la **validación de datos** con poderosas capacidades de reportabilidad. En unos minutos aprenderás a usar este paquete para garantizar que tus datos cumplen con tus expectativas de calidad. 


----

_**¿Para qué sirve la validación de datos?**_ Para que, en cualquier punto de tus procesos de análisis de datos, puedas **verificar si los datos cumplen con los criterios de calidad que tú definas**, y así enterarte de si vienen como esperas o si es que traen _sorpresas_. En la validación de datos se crean **pruebas** para, por ejemplo, confirmar que una columna no tenga datos perdidos, que los valores de una columna estén dentro de un rango esperado, etcétera. 

Al crear una serie de pruebas, podemos **automatizar el proceso de validación de datos.** De esta forma, si modificamos nuestro código, o si cambian los datos, **no necesitamos revisar manualmente** que todo esté en orden, sino que **tenemos una especie de protocolo para certificar que los datos son los esperados.** Cada vez que hagamos cambios en el código, podemos ejecutar las pruebas para confirmar que todo sigue funcionando como se espera.



{{< indice >}}




----

## Datos de ejemplo

Creemos una pequeña tabla para aprender a validar datos:




``` r
library(dplyr)

datos <- tribble(~animal,   ~patas, ~lindura,    ~color,
                 "mapache",    "4",      100,    "gris",
                 "gato",      "80",       90,   "negro",
                 "pollo",      "2",       NA,  "plumas",
                 "rata",  "cuatro",       90, "#CCCCCC")
```



De inmediato podemos ver en esta tabla creada con `tribble()` que hay varios problemas: la columna `patas` viene como caracteres, hay datos perdidos en `lindura`, y hay un color hexadecimal en `color`. Pero nos damos cuenta de ésto porque la tabla contiene pocos datos. **Cuando trabajemos con miles o millones de observaciones, se vuelve más difícil detectar este tipo de problemas**. Ahí es cuando la validación de datos nos puede ayudar!

----

## Validación con `{testthat}`

A pesar de que `{testthat}` se usa en general para el desarrollo de paquetes, y se enfoca a validar que cálculos y métodos estadísticos funcionen como es esperado, igual se puede usar para validar en proyectos de análisis de datos.

### Estructura del código

Asumiendo que nuestro proyecto posee varios scripts donde se procesan los datos, la idea general será **crear scripts con pruebas**, y periodicamente ejecutar estos scripts de pruebas para confirmar que todo esté en orden. 

Primero necesitamos crear una carpeta para los tests, y scripts con pruebas para cada script o paso en nuestro flujo de trabajo que queramos validar. Podemos hacerlo a mano, o bien crear una carpeta para las pruebas con `fs::dir_create()`, y dentro creamos los scripts que necesitemos con `fs::file_create()`, siguiendo la convención de anteponer `test-` al nombre de cada script de pruebas.

Se recomienda **crear un script de pruebas por cada script de nuestro proyecto**: si tenemos un script llamado `datos.R`, creamos un script de pruebas llamado `test-datos.R` dentro de la carpeta `tests/`. Dentro de este script empezamos a diseñar las pruebas unitarias. Las **pruebas unitarias** son pruebas que validan que una unidad específica de código (una función, un cálculo, una transformación de datos) funcione como se espera. 

### Crear pruebas unitarias

Usamos la función `test_that()` para definir cada prueba, indicando primero el nombre de la prueba. Dentro, usamos funciones como `expect_true()`, `expect_equal()`, `expect_type()`, para declarar que _esperamos_ que luego de cierta operación ocurra algo. Por ejemplo: espero (`expect`) que mi tabla tenga una columna determinada, o que una columna sea de cierto tipo. Estas son las condiciones que deben cumplirse para que la prueba pase.

Veamos un ejemplo de una prueba:




``` r
library(testthat)
```

```
## 
## Attaching package: 'testthat'
```

```
## The following object is masked from 'package:dplyr':
## 
##     matches
```

``` r
test_that("números iguales",
          expect_equal(4, 4)
)
```

```
## Test passed 🌈
```



Esta prueba evalúa si dos números son iguales (`expect_equal()`), y en este ejemplo se cumple: `{testthat}` nos entrega un emoji de celebración 🎉 Veamos la siguiente prueba:




``` r
test_that("números desiguales",
          expect_equal(4, 5)
)
```

```
## ── Failure: números desiguales ─────────────────────────────────────────────────
## 4 not equal to 5.
## 1/1 mismatches
## [1] 4 - 5 == -1
```

```
## Error:
## ! Test failed
```



Como la prueba no se cumple, porque `4` es distinto a `5`, y la prueba nos dará un error explicando en dónde está el problema.


### Ejemplos de pruebas unitarias para validación de datos

Apliquemos pruebas similares a los datos de ejemplo, dentro de un script que se llame `tests/test-datos.R`, donde cargamos los datos (es importante que el script sea reproducible, ya que no lee los datos desde tu entorno sino que los carga en su propio entorno) y luego hacemos las pruebas:





``` r
# código para que el script de pruebas cargue los datos
# datos <- readr::read_rds("datos.rds") 

# esperamos que exista un objeto llamado "datos"
test_that("se cargaron los datos",
          expect_true(exists("datos"))
)
```

```
## Test passed 🎊
```

``` r
# esperamos que el número de columnas sea 4
test_that("suficientes columnas",
          expect_equal(ncol(datos), 4)
)
```

```
## Test passed 🌈
```

``` r
# esperamos que la columna `animal` sea tipo caracter
test_that("columnas tipo texto",
          expect_type(datos$animal, "character")
)
```

```
## Test passed 😸
```

``` r
# esperamos que la columna `patas` sea tipo numérico
test_that("columnas tipo texto",
          expect_type(datos$patas, "numeric")
)
```

```
## ── Failure: columnas tipo texto ────────────────────────────────────────────────
## datos$patas has type 'character', not 'numeric'.
```

```
## Error:
## ! Test failed
```

``` r
# esperamos que los colores estén dentro de un conjunto determinado
test_that("colores factibles",
          expect_in(datos$color, c("negro", "gris", "blanco", "amarillo", "café"))
)
```

```
## ── Failure: colores factibles ──────────────────────────────────────────────────
## datos$color (`actual`) isn't fully contained within c("negro", "gris", "blanco", "amarillo", "café") (`expected`).
## * Missing from `expected`: "plumas", "#CCCCCC"
## * Present in `expected`:   "negro", "gris", "blanco", "amarillo", "café"
```

```
## Error:
## ! Test failed
```



Una vez que guardamos este script, podemos ejecutar sus pruebas manualmente, o bien podemos usar `test_file("tests/test-script.R")` para **ejecutar todas las pruebas de un script**, o `test_dir("tests.R")` para ejecutar todas las pruebas de la carpeta de pruebas, validando tu proyecto entero de una sola vez. 

A partir de las pruebas que definimos podemos **confirmar que hay problemas** en las columnas `patas` y `color`, ya que no cumplen con las expectativas que definimos en las pruebas.

Podemos ejecutar las funciones que realizan la validación desde donde más nos resulte conveniente: desde algún script principal de nuestro proyecto, desde un script `tests.R` específico para ejecutar las pruebas, al final de cada script del proyecto, al final de un script donde ejecutemos todo el procesamiento de nuestro proyecto, o manualmente. 

#### Uso completo
💡 _Lo que yo haría_ sería algo así como agregar un `test_file()` al final del script de limpieza de datos, que confirme que la limpieza salió bien, en otro script donde procese datos tendría otro `test_file()` con pruebas relacionadas a este paso, etcétera.

Otra opción es guardar los scripts de pruebas en `tests` y ejecutar todos los scripts de pruebas con `test_dir("tests/")`, en cuyo caso `{testthat}` arroja un resumen de los resultados.

También, al guardar un script con pruebas, RStudio se da cuenta y aparece el botón _Run Tests_ en la parte superior derecha del script.

#### Uso simple
Si queremos hacerlo todo más simple, simplemente usemos las funciones `testthat::expect_x()` entremedio del código, de modo que si la prueba falla, arroja error, pero si no falla, no pasa nada. En este sentido, funciona igual que `stopifnot()`, pero para mi resulta mucho más claro (esa función me confunde mucho 😣). Con `expect_x()` declaramos: _esperamos que_ lo siguiente retorne `TRUE`, y si las cosas se dan así, no pasa nada y la vida sigue.




``` r
testthat::expect_equal(n_distinct(iris$Species), 3)
testthat::expect_equal(n_distinct(iris$Species), 4)
```

```
## Error: n_distinct(iris$Species) not equal to 4.
## 1/1 mismatches
## [1] 3 - 4 == -1
```




### Conclusión de `{testthat}` para validación de datos

Con `{testthat}` podemos crear un flujo de trabajo que incluya la validación de datos a nuestros proyectos, con funciones e interfaz amigable que te dan un golpe de dopamina cuando aparece el mensajito verde con el emoji de felicitación. Si bien es ampliamente usado en la comunidad de R, su uso principal _no es_ la validación de datos, por lo que ahora veremos un segundo paquete especialmente diseñado para ello.


----


## Validación de datos con `{pointblank}`

A diferencia de `{testthat}`, [el paquete `{pointblank}`](https://rstudio.github.io/pointblank/articles/pointblank.html) está **diseñado para evaluar la calidad de conjuntos de datos.** Sirve para definir pruebas que validen que los datos cumplen con ciertos estándares, integrando las pruebas en cadenas de comandos unidos por conectores o _pipes_ (`|>` o `%>%`), y se destaca por su capacidad de **crear _agentes_ que generan reportes automáticos de validación de datos.**

Las funciones de validación de `{pointblank}` sirven para integrarlas en _pipelines_. **Si se _pasa_ la prueba, el proceso continúa, pero si la prueba falla, el proceso se detiene y te avisa.** Probemos la validación de algunos aspectos de la [tabla de ejemplo](#datos-de-ejemplo):




``` r
library(pointblank)

datos |> 
  col_is_numeric(lindura) |>
  col_is_character(c(animal, color)) |> 
  col_vals_in_set(animal, set = c("perro", "gato", "sapo", "pollo", "mapache", "pez", "rata"))
```

```
## # A tibble: 4 × 4
##   animal  patas  lindura color  
##   <chr>   <chr>    <dbl> <chr>  
## 1 mapache 4          100 gris   
## 2 gato    80          90 negro  
## 3 pollo   2           NA plumas 
## 4 rata    cuatro      90 #CCCCCC
```



Obtenemos de vuelta la tabla de datos, porque implícitamente las tres pruebas se pasaron correctamente. Es decir, si todo está correcto, seguimos con nuestros procesos.

Probemos qué pasa si incluimos pruebas más estrictas que nuestra humilde tabla no podrá pasar:




``` r
datos |> 
  col_is_numeric(lindura) |>
  col_is_character(c(animal, color)) |> 
  col_vals_in_set(animal, set = c("perro", "gato", "sapo", "pollo", "mapache", "pez", "rata")) |> 
  col_vals_in_set(patas, set = 2:100) |> 
  col_vals_not_null(lindura)
```

```
## Error: Exceedance of failed test units where values in `patas` should have been in the set of `2`, `3`, `4` (and 96 more).
## The `col_vals_in_set()` validation failed beyond the absolute threshold level (1).
## * failure level (1) >= failure threshold (1)
```



Recibimos un aviso que indica un _exceso de test fallidos_, y una explicación de lo que falló. El paquete [ofrece la posibilidad de ajustar o soltar el nivel de dificultad de las pruebas,](https://rstudio.github.io/pointblank/articles/pointblank.html#using-action-levels) por ejemplo, para permitir un cierto porcentaje de problemas, pero avisar si este nivel se supera.

Veamos otro ejemplo de pruebas aplicadas a un _pipeline_: aquí intentamos corregir uno de los problemas con los datos, detectado con una de las pruebas anteriores, y aplicamos nuevamente la prueba para confirmar que quedó bien:




``` r
datos |> 
  # corregir
  mutate(lindura = tidyr::replace_na(lindura, mean(lindura, na.rm = TRUE))) |> 
  # probar
  col_vals_not_null(lindura)
```

```
## # A tibble: 4 × 4
##   animal  patas  lindura color  
##   <chr>   <chr>    <dbl> <chr>  
## 1 mapache 4        100   gris   
## 2 gato    80        90   negro  
## 3 pollo   2         93.3 plumas 
## 4 rata    cuatro    90   #CCCCCC
```


En otras palabras, corregimos los datos e **inmediatamente probamos que la corrección funciona, sin necesidad de revisar manualmente.**

Alternativamente existen variedades de las funciones de validación que empiezan con `test_`, y que retornan `TRUE` o `FALSE` dependiendo de si se cumple o no la prueba. Sirven para usarlas dentro de condicionales `if`, o dentro de funciones `if()` o `ifelse()`. Por ejemplo, puede usarse en un `if` para aplicar una corrección si la prueba no se cumple.


### Reportes de validación de datos

Aparte de las funciones de validación, el verdadero potencial de `{pointblank}` está en la **creación de _agentes_ que generan reportes automáticos de validación de datos.** Por _agentes_ se refieren a un objeto que contiene las pruebas que queremos aplicar a los datos, y que al _interrogarlo_ genera un reporte con los resultados de las pruebas.

Creamos un agente entregándole nuestros datos y opcionalmente el nivel de _acción_, que le indica cuándo actuar sobre los problemas en nuestros datos. Luego, le indicamos al agente las pruebas que queremos realizar. Finalmente, interrogamos al agente para que nos entregue su reporte.




``` r
library(pointblank)

# crear agente
agente <- create_agent(datos, 
                       actions = action_levels(warn_at = 1, stop_at = 2))

# definir pruebas
agente <- agente |>
  col_is_numeric(c(lindura, patas)) |>
  col_is_character(c(animal, color)) |> 
  col_vals_in_set(animal, set = c("perro", "gato", "sapo", "pollo", "mapache", "pez", "rata")) |> 
  col_vals_between(patas, left = 2, right = 4) |> 
  col_vals_not_null(lindura)

# interrogar
interrogate(agente)
```



Recibimos un reporte interactivo que indica la calidad de nuestros datos en base a las pruebas definidas:



{{< imagen "pointblank-1.png" >}}




En el reporte vemos los pasos de validación (las pruebas) hacia abajo en la columna _steps_, y los colores indican si la prueba se pasó (verde), si hubo advertencias (amarillo), o si la prueba falló (rojo). En la columna _units_ se indica las unidades o pruebas individuales aplicadas en cada paso: probar el formato de una columna es una prueba, pero buscar datos perdidos corresponde a una prueba por cada observación de la tabla. 

### Ejemplo de validación de datos sucios

Probemos otro ejemplo con [datos _ensuciados_ gracias al paquete `{messy}`](https://nrennie.rbind.io/blog/introducing-messy-r-package/), que te permite agregar datos perdidos, errores gramaticales, símbolos raros y otras asquerosidades a cualquier conjunto de datos. Ensuciaremos el famoso dataset `iris`:




``` r
iris_sucio <- datasets::iris |> 
  tibble() |> 
  janitor::clean_names() |> 
  messy::messy(messiness = 0.2)

iris_sucio
```

```
## # A tibble: 150 × 5
##    sepal_length sepal_width petal_length petal_width species     
##    <chr>        <chr>       <chr>        <chr>       <chr>       
##  1 "5.1"         <NA>       "1.4"        "0.2 "      "@s)e+tosa" 
##  2  <NA>        "3 "        "1.4"        "0.2"       "set)osa"   
##  3 "4.7 "       "3.2"       "1.3"        "0.2"       "setosa"    
##  4 "4.6"        "3.1"       "1.5 "        <NA>       "setosa"    
##  5 "5"          "3.6"       "1.4"        "0.2"       "se&to*sa"  
##  6 "5.4"        "3.9"       "1.7 "       "0.4"       "seto_sa"   
##  7 "4.6"        "3.4"       "1.4"        "0.3 "      "set%osa"   
##  8 "5"          "3.4"       "1.5"        "0.2 "      "@se^tosa"  
##  9 "4.4"         <NA>       "1.4 "       "0.2"       "setosa"    
## 10 "4.9"        "3.1"       "1.5"        "0.1"       "$s&etos@a "
## # ℹ 140 more rows
```



Luego creamos un agente para validar estos datos:



``` r
agente_iris <- create_agent(iris_sucio,
                         actions = action_levels(warn_at = 0.02, stop_at = 0.5))

agente_iris <- agente_iris |>
  col_is_numeric(columns = everything()) |>
  col_is_character(species) |>
  col_vals_in_set(species, c("virginica", "setosa", "versicolor")) |>
  col_vals_between(sepal_length, 1, 6) |> 
  col_vals_not_null(columns = everything())

interrogate(agente_iris)
```

{{< imagen "pointblank-2-featured.png" >}}




Confirmamos que `{messy}` destruyó a nuestro querido `iris` 😔🕊️


### Crear un plan básico de validación de datos

Si no sabes cómo empezar a validar tus datos, `{pointblank}` te ayuda a crear un plan básico de validación de datos con la función `draft_validation()`, la cual genera un script con pruebas básicas para que lo edites y adaptes a tus necesidades:



``` r
draft_validation(
  tbl = ~datasets::iris,
  filename = "test-iris"
)
```


Este código nos crea un script que contiene 10 pruebas para el dataset en base a sus propios datos y características, y así tenemos material para definir los estándares para el conjunto de datos, y volver a validarlo en el futuro luego de que se apliquen cambios, actualizaciones o correcciones. 

### Conclusiones

Aplicar principios de validación de datos a tus proyectos de análisis de datos te va a ayudar a tener **mayor confianza en tus datos**, dándote certeza de que no hay sorpresas inesperadas entre las miles o millones de observaciones con las que trabajas. También puede **ahorrarte dolores de cabeza**, ya que si los datos cambian y estos cambios se desajustan de tus estándares, te enterarás de inmediato en vez de darte cuenta cuando se eche a perder algún gráfico o tabla más adelante 😅


### Recursos para aprender `{pointblank}`

- [Introducción a `{pointblank}`](https://rstudio.github.io/pointblank/articles/pointblank.html)
- [Guía oficial de `{pointblank}`](https://rstudio.github.io/pointblank/articles/VALID-I.html)
- [Workshop de `{pointblank}` por Richard Iannone](https://github.com/rich-iannone/pointblank-workshop) (requiere clonar el proyecto y generar los reportes Markdown)



{{< cafecito >}}

