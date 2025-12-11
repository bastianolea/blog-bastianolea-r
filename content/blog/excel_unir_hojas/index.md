---
title: Cargar y unir datos de múltiples hojas de Excel con R
author: Bastián Olea Herrera
date: '2025-12-09'
draft: false
slug: []
categories: []
tags:
  - Excel
  - limpieza de datos
  - datos
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: github
    icon_pack: fab
    name: Código
    url: https://gist.github.com/bastianolea/5c896dab18924a9cc0346fd7570ee28b
excerpt: >-
  Las hojas de Excel pueden ser cómodas para organizar información, pero no
  mucho para procesarla o analizarla. Por lo mismo, una de las operaciones
  iniciales de limpieza de datos suele ser unir datos que vienen repartidos en
  varias hojas de Excel. Veamos cómo se hace paso a paso. Usaremos el paquete
  `{readxl}` para leer los datos, `{dplyr}` para manipular y combinar las hojas,
  y `{purrr}` para realizar operaciones sobre todas las hojas de forma
  automática.
---


Las hojas de Excel pueden ser cómodas para organizar información, pero no mucho para procesarla o analizarla. Por lo mismo, una de las operaciones iniciales de limpieza de datos suele ser **unir datos que vienen repartidos en varias hojas de Excel**.

En este tutorial vamos a ver cómo se hace paso a paso. Usaremos el paquete `{readxl}` para leer los datos, `{dplyr}` para manipular y combinar las hojas, y `{purrr}` para realizar operaciones sobre todas las hojas de forma automática.

## Datos

Como ejemplo, usaremos un archivo de Excel con datos falsos, que puedes descargar a continuación:

{{< boton "Descargar datos falsos" "/blog/excel_unir_hojas/datos_falsos.xlsx" "fas fa-download" >}}
{{< detalles "Ver código para generar los datos falsos" >}}

``` r
library(purrr)
library(dplyr)

nombres_hojas <- paste("hoja", 1:20)

# crear una lista con tablas de datos sintéticos
datos_falsos <- map( # iterar por cada elemento
  set_names(nombres_hojas), # poner nombre a cada elemento
  ~{
    n = sample(5:30, 1) # cantidad de filas al azar
    
    # datos al azar
    datos <- tibble(variable_a  = sample(letters, n, replace = T),
                    variable_b = rnorm(n),
                    variable_c = rnorm(n),
    )
    
    # que una de las tablas sea distinta
    if (.x == "hoja 13") {
      datos <- datos |> 
        mutate(variable_c = sample(letters, n, replace = T))
    }
    
    return(datos)
  }
)

# guardar archivo
writexl::write_xlsx(datos_falsos, "datos_falsos.xlsx")
```

{{< /detalles >}}

Se trata de un archivo con 20 hojas, y tres columnas con datos al azar. La planilla de Excel se ve más o menos así:

{{< imagen "datos_falsos.png" >}}

## Cargar datos desde una hoja de Excel

Para cargar datos desde una hoja específica de un archivo Excel, usamos la función `read_excel()` del paquete `readxl`, definiendo la hoja en el argumento `sheet` (ya sea según su posición o su nombre).

``` r
library(readxl)

datos <- read_excel("datos_falsos.xlsx", sheet = 2)

head(datos)
```

    # A tibble: 6 × 3
      variable_a variable_b variable_c
      <chr>           <dbl>      <dbl>
    1 j              0.0841     -0.339
    2 z             -0.0351     -0.278
    3 k             -1.24        0.353
    4 p              1.32       -0.767
    5 f              1.06       -0.569
    6 x              1.27        0.750

Obtenemos sólo los datos de la hoja especificada. Esta es la base que nos permitirá cargar desde múltiples hojas.

## Unir datos desde varias hojas de Excel manualmente

La forma básica de unir los datos de varias hojas sería repetir la lectura de datos anterior, y luego unir los objetos resultantes con `bind_rows()` de `dplyr`.

{{< info "La función `bind_rows()` une varias tablas con las mismas columnas, apilándolas una debajo de la otra, como una torta 🍰" >}}

``` r
# cargar hojas individualmente
datos_1 <- read_excel("datos_falsos.xlsx", sheet = 1)
datos_2 <- read_excel("datos_falsos.xlsx", sheet = 2)
datos_3 <- read_excel("datos_falsos.xlsx", sheet = 3) 

library(dplyr)

# unir todas las hojas
bind_rows(datos_1, datos_2, datos_3)
```

    # A tibble: 52 × 3
       variable_a variable_b variable_c
       <chr>           <dbl>      <dbl>
     1 b              0.0980      0.605
     2 f             -1.56        0.815
     3 i              0.245       1.05 
     4 m              0.178       0.779
     5 x             -0.587       0.443
     6 l             -1.27        0.591
     7 y             -0.317      -0.276
     8 j              0.0841     -0.339
     9 z             -0.0351     -0.278
    10 k             -1.24        0.353
    # ℹ 42 more rows

Pero pronto nos damos cuenta de que esto **no es sostenible**: si tenemos 20 hojas, o 50, o 100, no podemos estar copiando y pegando el mismo código una y otra vez! Ni menos crear 100 objetos distintos para cada hoja!

{{< info "Cuando repitas código 3 veces, significa que lo correcto sería hacer una función o un loop" >}}

Necesitamos **automatizar** este código para aplicarlo a todas las hojas que queramos.

### Corregir diferencias entre hojas al unirlas

Pero ¿qué pasa si las hojas tienen **datos inesperados**? Intentemos unir otras hojas del mismo archivo:

``` r
#Se cambian los datos porque no calzan entre las dos columnas el tipo de dato, 
datos_11 <- read_excel("datos_falsos.xlsx", sheet = 11)
datos_12 <- read_excel("datos_falsos.xlsx", sheet = 12)
datos_13 <- read_excel("datos_falsos.xlsx", sheet = 13)

bind_rows(datos_11, datos_12, datos_13)
```

    Error in `bind_rows()`:
    ! Can't combine `..1$variable_c` <double> and `..3$variable_c` <character>.

¡Obtenemos un error! No siempre podemos asumir que todo va a salir bien (casi nunca todo sale bien). Al unir varias hojas, si alguna viene con datos incorrectos, la unión con `bind_rows()` **falla**.

En este caso, según el error vemos que la columna `variable_c` es **distinta** en una de las hojas:

``` r
waldo::compare(datos_12$variable_c, datos_13$variable_c)
```

    `old` is a double vector (0.104654760635383, -0.87864148501293, -0.67300275472249, 1.290359654706, 2.25558071386618, ...)
    `new` is a character vector ('h', 'd', 'w', 'm', 'i', ...)

Si [comparamos las columnas con `{waldo}`](../../../blog/waldo/), confirmamos usando que la columna `c` viene con datos tipo carácter en una de las hojas, mientras que en las otras hojas es numérica, por lo que R se niega a hacer la unión.

{{< info "Recordemos que las columnas sólo pueden ser de **un** tipo en R, por lo que no puedes mezclar números con texto en una columna!" >}}

La solución parche sería **corregir los datos** en esa hoja específica, y reintentar la unión:

``` r
library(dplyr)

datos_13b <- datos_13 |> 
  mutate(variable_c = as.numeric(variable_c))
```

    Warning: There was 1 warning in `mutate()`.
    ℹ In argument: `variable_c = as.numeric(variable_c)`.
    Caused by warning:
    ! NAs introduced by coercion

``` r
bind_rows(datos_11, datos_12, datos_13b)
```

    # A tibble: 51 × 3
       variable_a variable_b variable_c
       <chr>           <dbl>      <dbl>
     1 v               0.227     -0.374
     2 q               0.299     -1.09 
     3 k              -1.03       0.117
     4 m              -0.828      1.24 
     5 k              -0.475     -0.631
     6 d               0.448      0.918
     7 i               0.845     -0.682
     8 l               0.232      0.885
     9 r               0.150     -0.652
    10 w              -0.474     -0.667
    # ℹ 41 more rows

¡Funciona!

------------------------------------------------------------------------

Ya vimos cómo cargar y unir varias hojas de Excel, así que ahora veremos cómo **automatizar** este proceso para que funcione con cualquier cantidad de hojas.

## Unir datos desde varias hojas de Excel automáticamente

Para realizar operaciones que se repiten a lo largo de una serie de elementos (sean hojas de Excel, archivos, columnas, filas, etc), usamos [*loops* (bucles)](../../../tags/loops/) para automatizar el proceso.

### Repaso de *loops* con `purrr::map()`

Antes de seguir avanzando, haremos un repaso de *loops* con el paquete `{purrr}`.

{{< info "Un _loop_ o bucle en R es una estructura de control que permite repetir un bloque de código varias veces, iterando sobre una secuencia de elementos" >}}

En un loop, tenemos una **secuencia** de algo, a la cual vamos a **repetirle** una operación. Se realizan tantas operaciones o **pasos** como elementos haya en la secuencia.

Con las funciones para *loops* del paquete `{purrr}`, cada paso va agregando los resultados como un elemento de una lista, la cual podemos combinar al final si queremos.

Veamos un ejemplo básico: tenemos números del 1 al 4, y por cada número, queremos multiplicar por 10, y obtener el resultado.

``` r
# install.packages("purrr") 
library(purrr)

# creamos una secuencia de elementos
hojas <- c(1, 2, 3, 4)

# por cada elemento de la secuencia, repetimos una operación
map(hojas,
    ~{.x * 10}
)
```

    [[1]]
    [1] 10

    [[2]]
    [1] 20

    [[3]]
    [1] 30

    [[4]]
    [1] 40

En el ejemplo anterior, iteramos sobre una **secuencia** de números del 1 al 4. Por cada número, que en cada **paso** se representa por `.x`, multiplicamos el número por 10 (`.x * 10`), y el resultado de cada paso se guarda como un elemento de una **lista**.

{{< info "Una lista en R es un objeto que puede contener varios elementos, los cuales pueden ser de distintos tipos y tamaños" >}}

### *Loop* para cargar hojas

Siguiendo el mismo principio del ejemplo anterior, iteramos por las hojas del 1 al 3, y dentro del *loop*, definimos que se **cargue** el archivo Excel en la hoja correspondiente a cada número de la secuencia.

Entonces, en el paso 1 se carga la hoja 1, en el paso 2 se carga la hoja 2, y así sucesivamente hasta la hoja 10.

Al final le ponemos `list_rbind()` (parecido a `bind_rows()`) para que todos los elementos de la lista se unan en un sólo dataframe., asumiendo que todas las hojas tienen datos compatibles.

``` r
# secuencia de hojas a cargar
hojas <- c(1:3)

# loop
datos <- map(hojas, ~{ # por cada hoja
  read_excel("datos_falsos.xlsx", sheet = .x) # cargar el archivo en la hoja correspondiente
}
)

datos
```

    [[1]]
    # A tibble: 7 × 3
      variable_a variable_b variable_c
      <chr>           <dbl>      <dbl>
    1 b              0.0980      0.605
    2 f             -1.56        0.815
    3 i              0.245       1.05 
    4 m              0.178       0.779
    5 x             -0.587       0.443
    6 l             -1.27        0.591
    7 y             -0.317      -0.276

    [[2]]
    # A tibble: 16 × 3
       variable_a variable_b variable_c
       <chr>           <dbl>      <dbl>
     1 j              0.0841     -0.339
     2 z             -0.0351     -0.278
     3 k             -1.24        0.353
     4 p              1.32       -0.767
     5 f              1.06       -0.569
     6 x              1.27        0.750
     7 z             -0.0293      0.775
     8 k             -1.51       -0.415
     9 c             -1.57       -1.88 
    10 e             -1.39        0.618
    11 c              0.924      -1.40 
    12 q             -1.82        1.26 
    13 w              1.71        1.62 
    14 u             -1.08       -1.10 
    15 y              0.358      -0.141
    16 b              1.47        0.936

    [[3]]
    # A tibble: 29 × 3
       variable_a variable_b variable_c
       <chr>           <dbl>      <dbl>
     1 w              0.235     -0.204 
     2 m             -0.107      0.0811
     3 r             -0.0999    -1.58  
     4 p              0.731     -0.0249
     5 w              0.146     -0.730 
     6 y             -0.160     -1.63  
     7 c              0.915      0.451 
     8 h             -0.144     -1.00  
     9 x              1.14       0.636 
    10 w              0.106     -0.135 
    # ℹ 19 more rows

¡Cargamos 3 hojas! El resultado es una **lista** con tres elementos. Ahora **unimos** el resultado con `list_rbind()` para que quede una sola tabla con el contenido de cada hoja:

``` r
datos |> list_rbind() # unir todo al final
```

    # A tibble: 52 × 3
       variable_a variable_b variable_c
       <chr>           <dbl>      <dbl>
     1 b              0.0980      0.605
     2 f             -1.56        0.815
     3 i              0.245       1.05 
     4 m              0.178       0.779
     5 x             -0.587       0.443
     6 l             -1.27        0.591
     7 y             -0.317      -0.276
     8 j              0.0841     -0.339
     9 z             -0.0351     -0.278
    10 k             -1.24        0.353
    # ℹ 42 more rows

Pero ¿qué pasa si ampliamos la cantidad de hojas, en específico al pasar por la hoja 13 que tenía datos incorrectos?

``` r
# secuencia de hojas a cargar
hojas <- c(1:20)

# loop
map(hojas, ~{
  read_excel("datos_falsos.xlsx", sheet = .x) 
}
) |> list_rbind() # unir todo al final
```

    Error in `list_rbind()`:
    ! Can't combine `..1$variable_c` <double> and `..13$variable_c` <character>.

Error! Como vimos antes, el problema con esta hoja que tenía una columna distinta va a evitar que los resultados se unan al final del *loop*.

Entonces, dentro del *loop* podemos aplicar la misma corrección que probamos antes:

``` r
hojas <- c(1:20)

map(hojas,
    ~{
      read_excel("datos_falsos.xlsx",sheet = .x) |> 
        mutate(variable_c = as.numeric(variable_c)) # corregir columna
    }
) |> list_rbind()
```

    Warning: There was 1 warning in `mutate()`.
    ℹ In argument: `variable_c = as.numeric(variable_c)`.
    Caused by warning:
    ! NAs introduced by coercion

    # A tibble: 350 × 3
       variable_a variable_b variable_c
       <chr>           <dbl>      <dbl>
     1 b              0.0980      0.605
     2 f             -1.56        0.815
     3 i              0.245       1.05 
     4 m              0.178       0.779
     5 x             -0.587       0.443
     6 l             -1.27        0.591
     7 y             -0.317      -0.276
     8 j              0.0841     -0.339
     9 z             -0.0351     -0.278
    10 k             -1.24        0.353
    # ℹ 340 more rows

Con este código **cargamos los datos de todas las hojas, aplicando la corrección necesaria** para que los datos se puedan unir correctamente, y obtuvimos como resultado una sola tabla con todos los datos hacia abajo!

Otra opción más específica (menos extrapolable) sería aplicar la corrección sólo a la hoja que sabemos que tiene el problema, usando una condición `if` dentro del *loop*:

``` r
map(hojas,
    ~{
      datos_hoja <- read_excel("datos_falsos.xlsx",sheet = .x)
      
      if (.x == 13) { # si es la hoja 13
        datos_hoja <- datos_hoja |>
          mutate(variable_c = as.numeric(variable_c)) # corregir columna
      }
      
      return(datos_hoja)
    }
) |> list_rbind()
```

Esta forma de hacerlo es menos reutilizable, pero si te permite una mayor flexibilidad al momento de aplicar correcciones más complejas.

### Agregar el nombre de la hoja como una variable nueva

Si queremos agregar una **columna que indique desde qué hoja vienen los datos**, primero usamos la función `excel_sheets()` para obtener los nombres de las hojas:

``` r
# obtener nombres de las hojas
nombres_hojas <- readxl::excel_sheets("datos_falsos.xlsx")
```

Como se trata de un vector, podemos extraer sus elementos usando su posición, para saber cómo se llama cada hoja:

``` r
# consultar el nombre de una hoja
nombres_hojas[10]
```

    [1] "hoja 10"

Ahora que sabemos los nombres de las hojas, podemos iterar el *loop* usando los nombres directamente (en vez de números), y aprovechar de usar el nombre en cada paso para agregar una columna que se llame `hoja`:

``` r
datos <- map(
  nombres_hojas, # iterar por el nombre de cada hoja
  ~{
    message(.x) # decir la hoja al leerla
    
    read_excel("datos_falsos.xlsx", sheet = .x) |> 
      mutate(variable_c = as.numeric(variable_c)) |> 
      mutate(hoja = .x) # agregar nombre de hoja como columna
  }
) |> list_rbind()
```

    hoja 1

    hoja 2

    hoja 3

    hoja 4

    hoja 5

    hoja 6

    hoja 7

    hoja 8

    hoja 9

    hoja 10

    hoja 11

    hoja 12

    hoja 13

    Warning: There was 1 warning in `mutate()`.
    ℹ In argument: `variable_c = as.numeric(variable_c)`.
    Caused by warning:
    ! NAs introduced by coercion

    hoja 14

    hoja 15

    hoja 16

    hoja 17

    hoja 18

    hoja 19

    hoja 20

``` r
# obtener 10 filas al azar
slice_sample(datos, n = 10)
```

    # A tibble: 10 × 4
       variable_a variable_b variable_c hoja   
       <chr>           <dbl>      <dbl> <chr>  
     1 w             -0.931     NA      hoja 13
     2 c             -1.27      -0.451  hoja 12
     3 w             -0.983     -1.32   hoja 6 
     4 q             -0.655     -2.06   hoja 16
     5 a              0.0417    -0.0949 hoja 10
     6 l              0.636      0.122  hoja 20
     7 j              1.21      -0.671  hoja 11
     8 u             -0.818     -0.133  hoja 4 
     9 e             -0.626      1.74   hoja 9 
    10 n             -0.911     -0.572  hoja 10

Otra opción más rudimentaria, pero a veces necesaria, es iterar por la posición de cada hoja, y luego usar esa posición para extraer el nombre de la hoja desde el vector `nombres_hojas`. Usamos `seq_along()` para obtener un vector de números sucesivos por cada elemento del objeto, e iteramos por el *loop* siguiendo esos números.

{{< info "La función `seq_along()` genera una secuencia de números desde 1 hasta el largo del objeto que le pasemos como argumento. Es equivalente a `1:length(x)`" >}}

Dentro del *loop* referimos el número (`.x`) para obtener el mismo elemento del vector de nombres (`nombres_hojas[.x]`), y así agregar una columna nueva con el nombre de la hoja:

``` r
datos <- map(
  seq_along(nombres_hojas), # iterar por la posición de cada hoja
  ~{
    message(nombres_hojas[.x]) # decir la hoja al leerla
    
    read_excel("datos_falsos.xlsx",sheet = .x) |> # cargar hoja
      mutate(variable_c = as.numeric(variable_c)) |> # corrección
      mutate(hoja = nombres_hojas[.x]) # agregar nombre de hoja como columna
  }
) |> list_rbind()

head(datos)
```

### Guardar archivo resultante

Ahora que tenemos los datos de todas las hojas unidos en una sola planilla, podemos guardarlos en un nuevo archivo Excel usando la función `write_xlsx()` del paquete `writexl`:

``` r
writexl::write_xlsx(datos, "datos_unidos.xlsx")
```

¡Y listo! Hemos aprendido a cargar y unir datos desde múltiples hojas de Excel, enfrentando problemas comunes como datos incompatibles, y automatizando el proceso para cualquier cantidad de hojas.

{{< cafecito >}}
{{< cursos >}}
