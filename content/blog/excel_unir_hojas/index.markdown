---
title: Cargar y unir los datos de múltiples hojas de Excel con R
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
    url: 
---



Las hojas de Excel pueden ser cómodas para organizar información, pero no mucho para procesarla o analizarla. Por lo mismo, una de las operaciones iniciales de limpieza de datos suele ser unificar datos que vienen repartidos en varias hojas de Excel. 

En este tutorial vamos a ver cómo se hace paso a paso, enfrentando diversos casos, como que los datos de alguna hoja sean distintos a los de otras.

Usaremos el paquete `readxl` para leer los datos, `dplyr` para manipular y combinar las hojas, y `purrr` para realizar operaciones sobre todas las hojas de forma automática.


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

datos 
```

```
## # A tibble: 16 × 3
##    variable_a variable_b variable_c
##    <chr>           <dbl>      <dbl>
##  1 j              0.0841     -0.339
##  2 z             -0.0351     -0.278
##  3 k             -1.24        0.353
##  4 p              1.32       -0.767
##  5 f              1.06       -0.569
##  6 x              1.27        0.750
##  7 z             -0.0293      0.775
##  8 k             -1.51       -0.415
##  9 c             -1.57       -1.88 
## 10 e             -1.39        0.618
## 11 c              0.924      -1.40 
## 12 q             -1.82        1.26 
## 13 w              1.71        1.62 
## 14 u             -1.08       -1.10 
## 15 y              0.358      -0.141
## 16 b              1.47        0.936
```




## Unir datos desde varias hojas de Excel manualmente

Para unir los datos de varias hojas, podemos repetir la lectura de datos anterior, y luego unirlas con `bind_rows()` de `dplyr`.




``` r
# cargar hojas individualmente
datos_1 <- read_excel("datos_falsos.xlsx", sheet = 1)
datos_2 <- read_excel("datos_falsos.xlsx", sheet = 2)
datos_3 <- read_excel("datos_falsos.xlsx", sheet = 3) 

library(dplyr)

# unir todas las hojas
bind_rows(datos_1, datos_2, datos_3)
```

```
## # A tibble: 52 × 3
##    variable_a variable_b variable_c
##    <chr>           <dbl>      <dbl>
##  1 b              0.0980      0.605
##  2 f             -1.56        0.815
##  3 i              0.245       1.05 
##  4 m              0.178       0.779
##  5 x             -0.587       0.443
##  6 l             -1.27        0.591
##  7 y             -0.317      -0.276
##  8 j              0.0841     -0.339
##  9 z             -0.0351     -0.278
## 10 k             -1.24        0.353
## # ℹ 42 more rows
```



Pero pronto nos damos cuenta de que esto no es sostenible. Si tenemos 20 hojas, o 50, o 100, no podemos estar copiando y pegando el mismo código una y otra vez!

Además ¿qué pasa si las hojas tienen datos inesperados? Por ejemplo, intentemos unir otras hojas del mismo archivo:




``` r
#Se cambian los datos porque no calzan entre las dos columnas el tipo de dato, 
datos_11 <- read_excel("datos_falsos.xlsx", sheet = 11)
datos_12 <- read_excel("datos_falsos.xlsx", sheet = 12)
datos_13 <- read_excel("datos_falsos.xlsx", sheet = 13)

bind_rows(datos_11, datos_12, datos_13)
```

```
## Error in `bind_rows()`:
## ! Can't combine `..1$variable_c` <double> and `..3$variable_c` <character>.
```



¡Obtenemos un error! Al unir varias hojas podemos encontrar que alguna viene con datos incorrectos que impidan la unión. En este caso, según el error vemos que la columna `variable_c` es distinta en una de las hojas.




``` r
waldo::compare(datos_12$variable_c, datos_13$variable_c)
```

```
## `old` is a double vector (0.104654760635383, -0.87864148501293, -0.67300275472249, 1.290359654706, 2.25558071386618, ...)
## `new` is a character vector ('h', 'd', 'w', 'm', 'i', ...)
```



Confirmamos que, en una de las hojas, la columna `c` viene con datos tipo carácter, mientras que en las otras hojas es numérica, por lo que R se niega a hacer la unión.

La solución parche sería corregir los datos en esa hoja específica, y reintentar la unión



``` r
library(dplyr)

datos_13b <- datos_13 |> 
  mutate(variable_c = as.numeric(variable_c))
```

```
## Warning: There was 1 warning in `mutate()`.
## ℹ In argument: `variable_c = as.numeric(variable_c)`.
## Caused by warning:
## ! NAs introduced by coercion
```

``` r
bind_rows(datos_11, datos_12, datos_13b)
```

```
## # A tibble: 51 × 3
##    variable_a variable_b variable_c
##    <chr>           <dbl>      <dbl>
##  1 v               0.227     -0.374
##  2 q               0.299     -1.09 
##  3 k              -1.03       0.117
##  4 m              -0.828      1.24 
##  5 k              -0.475     -0.631
##  6 d               0.448      0.918
##  7 i               0.845     -0.682
##  8 l               0.232      0.885
##  9 r               0.150     -0.652
## 10 w              -0.474     -0.667
## # ℹ 41 more rows
```


Funciona! Pero hay que buscar la manera de replicar esta solución a todas las hojas, porque no siempre podremos ir caso a caso resolviendo!

## Unir datos desde varias hojas de Excel automáticamente

Para realizar este tipo de operaciones que se repiten a lo largo de una serie de elementos (sean hojas de Excel, archivos, columnas, filas, etc), usamos [_loops_ (bucles)](/tags/loops/) para automatizar el proceso.

### Repaso de _loops_ con `purrr::map()`

Antes de seguir avanzando, haremos un repaso de _loops_ con el paquete `{purrr}`. 

En un loop, tenemos una secuencia de algo, a la cual vamos aplicando una operación repetidamente. Se realizan tantas operaciones (pasos) como elementos haya en la secuencia. 

Con las funciones para _loops_ del paquete `{purrr}`, cada paso va agregando los resultados como un elemento de una lista, la cual podemos combinar al final si queremos.

Veamos un ejemplo básico




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

```
## [[1]]
## [1] 10
## 
## [[2]]
## [1] 20
## 
## [[3]]
## [1] 30
## 
## [[4]]
## [1] 40
```



En el ejemplo anterior, iteramos sobre una secuencia de números del 1 al 4. Por cada número, que en cada paso se representa por `.x`, multiplicamos el número por 10 (`.x * 10`), y el resultado de cada paso se guarda como un elemento de una lista.



## Carga de datos desde varias hojas automáticamente

Siguiendo el mismo principio del ejemplo anterior, iteramos por las hojas del 1 al 10, y dentro del _loop_, definimos que se cargue el archivo Excel en la hoja correspondiente a cada número de la secuencia.

Entonces, en el paso 1 se carga la hoja 1, en el paso 2 se carga la hoja 2, y así sucesivamente hasta la hoja 10.

Al final le ponemos `list_rbind()` para que todos los elementos de la lista se unan en un sólo dataframe.




``` r
hojas <- c(1:3)

map(hojas, ~{
  read_excel("datos_falsos.xlsx", sheet = .x) 
  }
) |> list_rbind()
```

```
## # A tibble: 52 × 3
##    variable_a variable_b variable_c
##    <chr>           <dbl>      <dbl>
##  1 b              0.0980      0.605
##  2 f             -1.56        0.815
##  3 i              0.245       1.05 
##  4 m              0.178       0.779
##  5 x             -0.587       0.443
##  6 l             -1.27        0.591
##  7 y             -0.317      -0.276
##  8 j              0.0841     -0.339
##  9 z             -0.0351     -0.278
## 10 k             -1.24        0.353
## # ℹ 42 more rows
```



¡Unimos 3 hojas! Pero ¿qué pasa si ampliamos la cantidad de hojas, en específico al pasar por la hoja 13 que tenía datos incorrectos?




``` r
hojas <- c(1:20)

map(hojas, ~{
  read_excel("datos_falsos.xlsx", sheet = .x) 
  }
) |> list_rbind()
```

```
## Error in `list_rbind()`:
## ! Can't combine `..1$variable_c` <double> and `..13$variable_c` <character>.
```


Como vimos antes, el problema con esta hoja distinta va a evitar que los resultados se unan al final del _loop_. 

Entonces, dentro del _loop_ podemos aplicar la misma corrección que probamos antes. Dentro del loop podemos poner cualquier condicionalidad y operación que necesitemos aplicar por cada paso!




``` r
hojas <- c(1:20)

map(hojas,
    ~{
      read_excel("datos_falsos.xlsx",sheet = .x) |> 
        mutate(variable_c = as.numeric(variable_c))
    }
) |> list_rbind()
```

```
## Warning: There was 1 warning in `mutate()`.
## ℹ In argument: `variable_c = as.numeric(variable_c)`.
## Caused by warning:
## ! NAs introduced by coercion
```

```
## # A tibble: 350 × 3
##    variable_a variable_b variable_c
##    <chr>           <dbl>      <dbl>
##  1 b              0.0980      0.605
##  2 f             -1.56        0.815
##  3 i              0.245       1.05 
##  4 m              0.178       0.779
##  5 x             -0.587       0.443
##  6 l             -1.27        0.591
##  7 y             -0.317      -0.276
##  8 j              0.0841     -0.339
##  9 z             -0.0351     -0.278
## 10 k             -1.24        0.353
## # ℹ 340 more rows
```


En este caso, no hay problema con aplicar la corrección a todas las hojas, porque la corrección no daña las hojas que vienen con datos correctos. 

Con este código cargamos los datos de todas las hojas, aplicando la corrección necesaria para que los datos se puedan unir correctamente, y obtuvimos como resultado una sola tabla con todos los datos hacia abajo!


### Agregar el nombre de la hoja como una variable nueva
Si queremos agregar una columna que indique de qué hoja vienen los datos, usamos la función `excel_sheets()` para obtener los nombres de las hojas:




``` r
# obtener nombres de las hojas
nombres_hojas <- readxl::excel_sheets("datos_falsos.xlsx")
```



Ahora, si extraemos un elemento del vector con nombres de hojas usando su posición, podemos saber cómo se llama dicha hoja:




``` r
# consultar el nombre de una hoja
nombres_hojas[10]
```

```
## [1] "hoja 10"
```



Ahora que sabemos los nombres de las hojas, podemos iterar el loop usando los nombres directamente, y aprovechar de usar el nombre en cada paso para agregar una columna que se llame `hoja`



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

```
## hoja 1
```

```
## hoja 2
```

```
## hoja 3
```

```
## hoja 4
```

```
## hoja 5
```

```
## hoja 6
```

```
## hoja 7
```

```
## hoja 8
```

```
## hoja 9
```

```
## hoja 10
```

```
## hoja 11
```

```
## hoja 12
```

```
## hoja 13
```

```
## Warning: There was 1 warning in `mutate()`.
## ℹ In argument: `variable_c = as.numeric(variable_c)`.
## Caused by warning:
## ! NAs introduced by coercion
```

```
## hoja 14
```

```
## hoja 15
```

```
## hoja 16
```

```
## hoja 17
```

```
## hoja 18
```

```
## hoja 19
```

```
## hoja 20
```

``` r
# obtener 10 filas al azar
slice_sample(datos, n = 10)
```

```
## # A tibble: 10 × 4
##    variable_a variable_b variable_c hoja   
##    <chr>           <dbl>      <dbl> <chr>  
##  1 c               0.165     -0.193 hoja 17
##  2 c               1.21       0.609 hoja 20
##  3 d               2.13      -0.527 hoja 12
##  4 d              -0.424      0.360 hoja 9 
##  5 x               0.106      0.467 hoja 12
##  6 q              -1.39       0.515 hoja 17
##  7 t               0.218      0.606 hoja 18
##  8 e               1.28       2.21  hoja 10
##  9 z               0.189      0.279 hoja 3 
## 10 d               1.12       0.130 hoja 9
```



Otra opción más rudimentaria, pero a veces necesaria, es iterar por la posición de cada hoja, y luego usar esa posición para extraer el nombre de la hoja desde el vector `nombres_hojas`.

Usamos `seq_along()` para obtener un vector de números sucesivos por cada elemento del objeto, e iteramos por el _loop_ siguiendo esos números, y luego dentro del loop referimos el número para obtener el mismo elemento del vector de nombres, y así agregar una columna nueva con el nombre de la hoja:



``` r
datos <- map(
  seq_along(nombres_hojas), # iterar por la posición de cada hoja
  ~{
    message(nombres_hojas[.x]) # decir la hoja al leerla
    
    read_excel("datos_falsos.xlsx",sheet = .x) |> 
      mutate(variable_c = as.numeric(variable_c)) |> 
      mutate(hoja = nombres_hojas[.x]) # agregar nombre de hoja como columna
  }
) |> list_rbind()
```

```
## hoja 1
```

```
## hoja 2
```

```
## hoja 3
```

```
## hoja 4
```

```
## hoja 5
```

```
## hoja 6
```

```
## hoja 7
```

```
## hoja 8
```

```
## hoja 9
```

```
## hoja 10
```

```
## hoja 11
```

```
## hoja 12
```

```
## hoja 13
```

```
## Warning: There was 1 warning in `mutate()`.
## ℹ In argument: `variable_c = as.numeric(variable_c)`.
## Caused by warning:
## ! NAs introduced by coercion
```

```
## hoja 14
```

```
## hoja 15
```

```
## hoja 16
```

```
## hoja 17
```

```
## hoja 18
```

```
## hoja 19
```

```
## hoja 20
```



Ahora que tenemos los datos de todas las hojas unidos en una sola planilla, podemos guardarlos en un nuevo archivo Excel usando la función `write_xlsx()` del paquete `writexl`:




``` r
writexl::write_xlsx(datos, "datos_unidos.xlsx")
```

