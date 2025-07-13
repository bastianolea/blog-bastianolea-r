---
title: Introducción al manejo de datos con {dplyr}
author: Bastián Olea Herrera
date: '2025-02-15'
format:
  hugo-md:
    output-file: index
    output-ext: md
weight: 7
draft: false
series: Introducción a R
slug: []
categories:
  - Tutoriales
tags:
  - dplyr
  - consejos
  - datos
lang: es
excerpt: >-
  Luego de haber aprendido las funcionalidades básicas del lenguaje y R, y
  habernos familiarizado con herramientas un poco más avanzadas de la
  programación en este lenguaje, ahora podemos aplicar estos aprendizajes a los
  datos. Aprenderemos a explorar, comprender, y navegar tablas de datos, tanto
  en la forma nativa de trabajar con R, como con la ayuda del paquete {dplyr}.
execute:
  error: true
  eval: true
editor_options:
  chunk_output_type: console
---


Luego de haber aprendido las funcionalidades básicas del lenguaje y R, y habernos familiarizado con herramientas un poco más avanzadas de la programación en este lenguaje, ahora podemos aplicar estos aprendizajes a los datos. Aprenderemos a explorar, comprender, y navegar tablas de datos, tanto en la forma nativa de trabajar con R, como con la ayuda del paquete {dplyr}.

## {dplyr}

<img src = dplyr.png style = "float: left; max-width: 128px; margin-right: 20px;">

La herramienta que utilizaremos para explorar, manipular, y transformar datos será [el paquete `{dplyr}`](https://dplyr.tidyverse.org/articles/dplyr.html). Este paquete, parte central del [conjunto *Tidyverse* de herramientas para el análisis de datos con R](https://www.tidyverse.org), es uno de los más usados por la comunidad de R por su facilidad de uso.

Se caracteriza porque casi todas sus funciones son escritas por medio de *verbos*, lo que hace que su sintaxis sea muy legible, ya que cada función se corresponde con una acción que estamos realizando sobre nuestros datos.

##### Nota sobre el uso de {dplyr}

Probablemente el 98% de las cosas que necesitemos hacer con tablas de datos en R puedan hacerse por medio de {dplyr} y otros paquetes adyacentes a él. En mi opinión esto es bueno, porque creo que {dplyr} hace todo más sencillo, ordenado y fácil de interpretar. Sin embargo, creo que también es importante entender cómo se realizan las operaciones básicas sobre los datos con R base. Esto porque un entendimiento ---aunque sea básico--- de R base nos va a ayudar a comprender mejor el funcionamiento del lenguaje, y nos puede sacar de posibles problemas que encontremos. Es por esto que en este tutorial iremos viendo cómo realizar las operaciones básicas de manipulación de datos primero con R base y luego con {dplyr}.

### Instalación

Para usar el paquete `{dplyr}`, así como cualquier otro paquete de R que no venga instalado por defecto, tenemos que instalarlo desde internet. La instalación de los paquetes en R se facilita por la función `install.packages()`, que se conecta a un servidor centralizado donde todos los paquetes son revisados y verificados manualmente por revisores humanos, para garantizar que sean seguros de usar y funcionales.

Instalamos `{dplyr}` con el siguiente comando:

``` r
install.packages("dplyr")
```

Así como cuando instalamos una aplicación en nuestro celular o computador, solamente necesitamos instalar el paquete una vez. Pero cuando queramos usar el paquete, debemos **cargarlo**, que sería equivalente a abrir una aplicación ya instalada en tu celular o computador.

Para cargar un paquete se utiliza la función `library()`:

``` r
library("dplyr")
```


    Attaching package: 'dplyr'

    The following objects are masked from 'package:stats':

        filter, lag

    The following objects are masked from 'package:base':

        intersect, setdiff, setequal, union

Después de cargar un paquete puede ser que aparezcan mensajes en la consola, pero en general podemos ignorarlos.

## Datos

Las tablas de datos, también conocidas como *dataframes*, son formas de almacenar información por medio de filas y columnas. Usualmente, las filas corresponden a observaciones, y las columnas corresponden a variables, pero no siempre esto se cumple. Otra característica de las tablas o *dataframes* es que son rectangulares: todas las columnas tienen la misma cantidad de filas.

Usemos {dplyr} para tener nuestra primera aproximación a los datos en tablas construyendo una tabla. Cómo planteamos en el primer tutorial, las tablas de datos en R son construidas a partir de vectores, o dicho de otra forma, las columnas de las tablas son vectores.

### Crear una tabla

Creemos unos vectores y luego hagamos una tabla a partir de ellos:

``` r
animal <- c("gato", "paloma", "rana", "pollo", "mapache", "serpiente")

tipo <- c("mamífero", "ave", "anfibio", "ave", "mamífero", "reptil")

patas <- c(4, 2, 4, 2, 4, 0)
```

Creamos tres vectores, que serán las columnas de nuestra tabla. Confirmemos que tienen el mismo largo:

``` r
# confirmar que los tres casos se cumplen
all(length(animal) == 6,
    length(tipo) == 6,
    length(patas) == 6)
```

    [1] TRUE

Ahora, usemos los vectores para crear una tabla con {dplyr}:

``` r
# crear una tabla con los vectores
tabla <- tibble(animal,
                tipo,
                patas)

tabla
```

    # A tibble: 6 × 3
      animal    tipo     patas
      <chr>     <chr>    <dbl>
    1 gato      mamífero     4
    2 paloma    ave          2
    3 rana      anfibio      4
    4 pollo     ave          2
    5 mapache   mamífero     4
    6 serpiente reptil       0

Esta es la salida en la consola que tienen los *dataframes* creados con {dplyr}. En ella, podemos ver en la primera fila de texto en largo y ancho de la tabla (número de filas y columnas). Luego vemos los **nombres** de las tres columnas, y debajo de ellos vemos el **tipo** de cada columna (caracter, caracter y numérico). Las siguientes filas corresponden a los datos mismos de la tabla.

### Explorar una tabla

Exploremos un poco las características de una tabla o *dataframe*:

``` r
class(tabla)
```

    [1] "tbl_df"     "tbl"        "data.frame"

Las tablas creadas con {dplyr} son de la clase `"tbl_df"`, que hace referencia a *tibble,* el tipo específico de tablas de datos de este paquete, que son más amigables y fáciles de leer.

``` r
length(tabla)
```

    [1] 3

Se consultamos el largo del objeto con `length()`, obtenemos el número de columnas. Si queremos saber el número de filas, usamos `nrow()`:

``` r
nrow(tabla)
```

    [1] 6

Si queremos saber los nombres de las columnas de una tabla, podemos usar `names()`, o bien, la función `glimpse()`, que nos entrega un conveniente *vistazo* de los datos de nuestra tabla:

``` r
names(tabla)
```

    [1] "animal" "tipo"   "patas" 

``` r
glimpse(tabla)
```

    Rows: 6
    Columns: 3
    $ animal <chr> "gato", "paloma", "rana", "pollo", "mapache", "serpiente"
    $ tipo   <chr> "mamífero", "ave", "anfibio", "ave", "mamífero", "reptil"
    $ patas  <dbl> 4, 2, 4, 2, 4, 0

### Seleccionar datos

Recordemos que podemos extraer subconjuntos de los vectores usando los corchetes `[]`:

``` r
animal[5]
```

    [1] "mapache"

``` r
animal[4:5]
```

    [1] "pollo"   "mapache"

``` r
animal[c(1, 2, 4)]
```

    [1] "gato"   "paloma" "pollo" 

Con los vectores es sencillo, porque un vector es una unidad de datos unidimensional, donde con un número podemos seleccionar cualquiera de los elementos contenidos en el vector.

Las tablas de datos no son unidimensionales, sino **bidimensionales**, dado que tienen filas y columnas. Entonces, para poder extraer elementos de distintas posiciones de una tabla, dentro de los corchetes habrá que indicar sus filas y/o columnas. Tenemos que indicar ya no sólo uno, sino dos argumentos: el primero refiere a las **filas**, y el segundo a las **columnas**.

``` r
tabla[2, 3]
```

    # A tibble: 1 × 1
      patas
      <dbl>
    1     2

En este caso, extrajimos la observación que se encuentra en la fila `2` y en la columna `3`.

#### Filas

Para extraer una fila de una tabla, dentro de los corchetes debemos indicar la posición de la fila, separado por una coma, y dejar en blanco el segundo argumento, que sería la selección de columnas.

``` r
tabla[1, ]
```

    # A tibble: 1 × 3
      animal tipo     patas
      <chr>  <chr>    <dbl>
    1 gato   mamífero     4

Indicando sólo el número de fila `1` y dejando en blanco la ubicación de la columna, seleccionamos la fila 1 entera.

También podemos usar la función `slice()` para extraer una fila de una tabla:

``` r
slice(tabla, 5)
```

    # A tibble: 1 × 3
      animal  tipo     patas
      <chr>   <chr>    <dbl>
    1 mapache mamífero     4

Si queremos extraer la última fila de una tabla, podemos combinar `slice()` con la función `nrow()` que nos entrega la cantidad de filas de una tabla, resultando en extraer la fila que corresponde con el número de filas; es decir, la última:

``` r
slice(tabla, nrow(tabla))
```

    # A tibble: 1 × 3
      animal    tipo   patas
      <chr>     <chr>  <dbl>
    1 serpiente reptil     0

#### Columnas

Para extraer una columna, debemos indicar su posición en el segundo argumento dentro de los corchetes, dejando el primero vacío:

``` r
tabla[, 1]
```

    # A tibble: 6 × 1
      animal   
      <chr>    
    1 gato     
    2 paloma   
    3 rana     
    4 pollo    
    5 mapache  
    6 serpiente

También podemos indicar el nombre de la columna, entre comillas, para seleccionarla:

``` r
tabla[, "animal"]
```

    # A tibble: 6 × 1
      animal   
      <chr>    
    1 gato     
    2 paloma   
    3 rana     
    4 pollo    
    5 mapache  
    6 serpiente

Puede para ser extraño dejar la coma por sí sola dentro del corchete, así que en su lugar podemos usar la función `select()` para seleccionar columnas:

``` r
select(tabla, 1)
```

    # A tibble: 6 × 1
      animal   
      <chr>    
    1 gato     
    2 paloma   
    3 rana     
    4 pollo    
    5 mapache  
    6 serpiente

``` r
select(tabla, "tipo")
```

    # A tibble: 6 × 1
      tipo    
      <chr>   
    1 mamífero
    2 ave     
    3 anfibio 
    4 ave     
    5 mamífero
    6 reptil  

Otra forma de extraer una columna de una tabla de datos es *abrir* la tabla usando el operador `$`. Al escribir el nombre de la tabla de datos seguido del operador `$`, RStudio sugerirá los nombres de las columnas para que puedas extraerlas:

{{< imagen "dplyr_1.png" >}}

``` r
tabla$animal
```

    [1] "gato"      "paloma"    "rana"      "pollo"     "mapache"   "serpiente"

A usar el operador `$` para extraer columnas, se obtiene el vector que se usó para crear la columna, así que recibimos los datos en forma de vector.

La misma extracción de una columna como vector puede hacerse con la función `pull()` de {dplyr}, donde se entrega la tabla y la columna, y se obtiene la columna como vector:

``` r
pull(tabla, animal)
```

    [1] "gato"      "paloma"    "rana"      "pollo"     "mapache"   "serpiente"

### Crear columnas

Si queremos agregar una nueva columna a nuestro *dataframe*, tenemos que hacer una mezcla entre la extracción de columnas con el operador `$` y la asignación de nuevos objetos:

Si intentamos extraer una columna que no existe, recibimos un error:

``` r
tabla$habitat
```

    Warning: Unknown or uninitialised column: `habitat`.

    NULL

Sin embargo, si creamos un vector encima de esta columna que aún no existe, ésta se crea:

``` r
tabla$habitat <- c("urbano", "urbano", "rural", "rural", "urbano", "rural")

tabla
```

    # A tibble: 6 × 4
      animal    tipo     patas habitat
      <chr>     <chr>    <dbl> <chr>  
    1 gato      mamífero     4 urbano 
    2 paloma    ave          2 urbano 
    3 rana      anfibio      4 rural  
    4 pollo     ave          2 rural  
    5 mapache   mamífero     4 urbano 
    6 serpiente reptil       0 rural  

En otras palabras, para crear una nueva columna simplemente especificamos su nombre como parte de la tabla existente, y asignamos los datos que queremos que se contengan en esta nueva columna.

Otra forma de crear columnas es con la función `mutate()`, que nos permite crear o modificar columnas existentes:

``` r
mutate(tabla, cola = c("sí", "sí", "no", "no", "sí", "toda"))
```

    # A tibble: 6 × 5
      animal    tipo     patas habitat cola 
      <chr>     <chr>    <dbl> <chr>   <chr>
    1 gato      mamífero     4 urbano  sí   
    2 paloma    ave          2 urbano  sí   
    3 rana      anfibio      4 rural   no   
    4 pollo     ave          2 rural   no   
    5 mapache   mamífero     4 urbano  sí   
    6 serpiente reptil       0 rural   toda 

La diferencia es que con `mutate()` solamente estamos previsualizando el cambio, dado que no hemos asignado nada. Si queremos que la columna realmente se guarde en el *dataframe*, debemos asignar el resultado a un objeto nuevo, o sobreescribir el actual:

``` r
# sobreescribir la tabla con la columna nueva
tabla <- mutate(tabla, cola = c("sí", "sí", "no", "no", "sí", "toda"))
```

### Filtrar datos

Una de las tareas más recurrentes que vamos a hacer con tablas de datos, sobre todo cuando son muy grandes, es filtrar la información. El filtrado de datos funciona a partir de **comparaciones**, dado que al filtrar estamos especificando un criterio que deben cumplir los valores para mantenerse en la tabla, y todos los valores que no cumplan este criterio serán removidos.

Entonces, para filtrar datos, escribimos una comparación que coincida (retorne `TRUE`) con los valores que deseamos recibir.

Supongamos que queremos ver solamente las observaciones donde el valor de la variable `patas` sea mayor que 2. Primero, planteemos la comparación:

``` r
# extraer los valores de la columna `patas`
tabla$patas 
```

    [1] 4 2 4 2 4 0

``` r
# comparar los valores con el número 2
tabla$patas > 2
```

    [1]  TRUE FALSE  TRUE FALSE  TRUE FALSE

A partir de las comparaciones, recibimos una secuencia de valores lógicos (`TRUE`/`FALSE`) que indican si cada elemento del vector cumplió o no con la comparación planteada. Entonces, en principio, queremos mantener solamente las observaciones que retornaron `TRUE`.

Recordemos que para filtrar filas de una tabla, dentro de los corchetes especificamos en la primera posición las filas que queremos extraer.

``` r
tabla[1, ]
```

    # A tibble: 1 × 5
      animal tipo     patas habitat cola 
      <chr>  <chr>    <dbl> <chr>   <chr>
    1 gato   mamífero     4 urbano  sí   

Esto, sumado a lo anterior, son los principios que usaremos para filtrar las filas de una tabla de datos:

``` r
tabla[tabla$patas > 2, ]
```

    # A tibble: 3 × 5
      animal  tipo     patas habitat cola 
      <chr>   <chr>    <dbl> <chr>   <chr>
    1 gato    mamífero     4 urbano  sí   
    2 rana    anfibio      4 rural   no   
    3 mapache mamífero     4 urbano  sí   

Usamos la comparación que retorna verdaderos y falsos dentro de los corchetes para seleccionar las filas de la tabla. Entonces, como el vector de la comparación entre el mismo largo que las filas de la tabla, en cada posición de la comparación que se obtuvo `TRUE`, se muestra la fila correspondiente, y si se obtuvo `FALSE`, se omite.

Otros ejemplos de filtrado:

``` r
tabla$animal == "mapache"
```

    [1] FALSE FALSE FALSE FALSE  TRUE FALSE

``` r
tabla[tabla$animal == "mapache", ]
```

    # A tibble: 1 × 5
      animal  tipo     patas habitat cola 
      <chr>   <chr>    <dbl> <chr>   <chr>
    1 mapache mamífero     4 urbano  sí   

Una segunda opción es usar la función `subset()` de R base para filtrar tablas:

``` r
subset(tabla, patas < 3)
```

    # A tibble: 3 × 5
      animal    tipo   patas habitat cola 
      <chr>     <chr>  <dbl> <chr>   <chr>
    1 paloma    ave        2 urbano  sí   
    2 pollo     ave        2 rural   no   
    3 serpiente reptil     0 rural   toda 

``` r
subset(tabla, animal == "pollo")
```

    # A tibble: 1 × 5
      animal tipo  patas habitat cola 
      <chr>  <chr> <dbl> <chr>   <chr>
    1 pollo  ave       2 rural   no   

La alternativa de {dplyr}, `filter()`, es similar a `subset()`, pero tiene otras conveniencias que aprenderemos más adelante:

``` r
filter(tabla, tipo != "ave")
```

    # A tibble: 4 × 5
      animal    tipo     patas habitat cola 
      <chr>     <chr>    <dbl> <chr>   <chr>
    1 gato      mamífero     4 urbano  sí   
    2 rana      anfibio      4 rural   no   
    3 mapache   mamífero     4 urbano  sí   
    4 serpiente reptil       0 rural   toda 

``` r
filter(tabla, animal %in% c("mapache", "gato"))
```

    # A tibble: 2 × 5
      animal  tipo     patas habitat cola 
      <chr>   <chr>    <dbl> <chr>   <chr>
    1 gato    mamífero     4 urbano  sí   
    2 mapache mamífero     4 urbano  sí   

### Renombrar columnas

Para cambiar el nombre de una de las columnas, hay varias formas.

Una forma, quizás más rudimentaria, sería crear una columna nueva con el nombre que deseamos, a partir de una columna existente, para luego eliminar la columna original:

``` r
# columna original
tabla$habitat
```

    [1] "urbano" "urbano" "rural"  "rural"  "urbano" "rural" 

``` r
# crear columna nueva a partir de la original
tabla$zona <- tabla$habitat

# eliminar la columna original
tabla$habitat <- NULL

# revisar cambios
names(tabla)
```

    [1] "animal" "tipo"   "patas"  "cola"   "zona"  

Éste procedimiento es similar al que vimos para crear nuevas columnas, ya que implica crear una columna que no existe aún (`zona`), a partir de un valor, en este caso, una columna de la misma tabla (`tabla$habitat`). De esta forma, duplicamos la columna, para luego **eliminar** la columna original al asignarle el valor nulo, `NULL`.

Otra forma de renombrar columnas, aunque un poco confusa, es usando la función `names()`, que nos entrega los nombres de las columnas:

``` r
# obtener columnas
names(tabla)
```

    [1] "animal" "tipo"   "patas"  "cola"   "zona"  

Al obtener los nombres de las columnas, realizamos una selección de la columna que queremos, usando los corchetes. Luego habría que asignar el nombre nuevo a la columna que sleeccionamos:

``` r
# seleccionar columna a renombrar
names(tabla)[names(tabla) == "patas"]
```

    [1] "patas"

``` r
# asignar nuevo nombre a la columna seleccionada
names(tabla)[names(tabla) == "patas"] <- "piernas"

# ver cambios
names(tabla)
```

    [1] "animal"  "tipo"    "piernas" "cola"    "zona"   

Finalmente, la alternativa que entrega {dplyr} para renombrar columnas es la función `rename()`, a la cual se le entrega la tabla, y luego se le entrega el nombre nuevo de la columna, el signo `=` y el nombre original:

``` r
tabla <- rename(tabla, nombre = animal)

# ver cambios
names(tabla)
```

    [1] "nombre"  "tipo"    "piernas" "cola"    "zona"   

### Ordenar observaciones

Otra operación común con tallas de datos es ordenar una tabla según una variable numérica, para que las observaciones estén en orden decreciente o ascendente.

Primero, si queremos ordenar un vector, podemos usar la función `sort()` para obtener los valores del vector de menor a mayor:

``` r
sort(tabla$piernas)
```

    [1] 0 2 2 4 4 4

En cierto sentido, ordenar una tabla es la misma operación que extraer filas de una tabla, solamente extraemos las filas de la tabla en el orden que deseamos. Por ejemplo:

``` r
tabla
```

    # A tibble: 6 × 5
      nombre    tipo     piernas cola  zona  
      <chr>     <chr>      <dbl> <chr> <chr> 
    1 gato      mamífero       4 sí    urbano
    2 paloma    ave            2 sí    urbano
    3 rana      anfibio        4 no    rural 
    4 pollo     ave            2 no    rural 
    5 mapache   mamífero       4 sí    urbano
    6 serpiente reptil         0 toda  rural 

``` r
# extraer filas de la tabla en un orden específico
tabla[c(6, 4, 4), ]
```

    # A tibble: 3 × 5
      nombre    tipo   piernas cola  zona 
      <chr>     <chr>    <dbl> <chr> <chr>
    1 serpiente reptil       0 toda  rural
    2 pollo     ave          2 no    rural
    3 pollo     ave          2 no    rural

En este ejemplo, extrajimos tres filas de la tabla, pero la extracción que hacemos es específicamente de la fila que tiene valor 0 en la variable `piernas`, y luego las dos filas que tienen valor 2.

Como memos, en este caso no nos serviría la función `sort()`. Porque para ordenar una tabla no necesitamos los *valores ordenados* del vector, sino las **posiciones** de los valores del vector ordenadas de manera que podamos mover las filas de una tabla. Para eso nos sirve la función `order()`:

``` r
# posiciones de los elementos ordenados
order(tabla$piernas)
```

    [1] 6 2 4 1 3 5

Esta función si no se entrega la posición de los elementos del vector o de la columna en el orden de menor a mayor, y con estas posiciones podemos reordenar las filas de la tabla:

``` r
# ordenar de menor a mayor
tabla[order(tabla$piernas), ]
```

    # A tibble: 6 × 5
      nombre    tipo     piernas cola  zona  
      <chr>     <chr>      <dbl> <chr> <chr> 
    1 serpiente reptil         0 toda  rural 
    2 paloma    ave            2 sí    urbano
    3 pollo     ave            2 no    rural 
    4 gato      mamífero       4 sí    urbano
    5 rana      anfibio        4 no    rural 
    6 mapache   mamífero       4 sí    urbano

``` r
# ordenar de mayor a menor
tabla[order(tabla$piernas, decreasing = TRUE), ]
```

    # A tibble: 6 × 5
      nombre    tipo     piernas cola  zona  
      <chr>     <chr>      <dbl> <chr> <chr> 
    1 gato      mamífero       4 sí    urbano
    2 rana      anfibio        4 no    rural 
    3 mapache   mamífero       4 sí    urbano
    4 paloma    ave            2 sí    urbano
    5 pollo     ave            2 no    rural 
    6 serpiente reptil         0 toda  rural 

La función `arrange()` de {dplyr} nos permite ordenar una tabla tan sólo entregándole la columna por la cual queremos ordenar:

``` r
arrange(tabla, piernas)
```

    # A tibble: 6 × 5
      nombre    tipo     piernas cola  zona  
      <chr>     <chr>      <dbl> <chr> <chr> 
    1 serpiente reptil         0 toda  rural 
    2 paloma    ave            2 sí    urbano
    3 pollo     ave            2 no    rural 
    4 gato      mamífero       4 sí    urbano
    5 rana      anfibio        4 no    rural 
    6 mapache   mamífero       4 sí    urbano

¡Mucho más sencillo! Si deseamos ordenar en orden descendiente (mayor a menor), debemos meter la columna dentro de la función `desc()` (por *descending*):

``` r
arrange(tabla, desc(piernas))
```

    # A tibble: 6 × 5
      nombre    tipo     piernas cola  zona  
      <chr>     <chr>      <dbl> <chr> <chr> 
    1 gato      mamífero       4 sí    urbano
    2 rana      anfibio        4 no    rural 
    3 mapache   mamífero       4 sí    urbano
    4 paloma    ave            2 sí    urbano
    5 pollo     ave            2 no    rural 
    6 serpiente reptil         0 toda  rural 

## Bonus

### Crear tablas manualmente

Si queremos crear una tabla de datos de prueba, para explorar estos aprendizajes, o bien porque nuestros datos son muy poquitos, podemos usar la función `tribble()` para escribir la tabla como si la estuviéramos haciendo en una aplicación de planillas de cálculo:

``` r
tribble(~días,    ~n, ~caso,
        "jueves",  0,  1,
        "viernes", 4,  0,
        "sábado",  2,  1,
        )
```

    # A tibble: 3 × 3
      días        n  caso
      <chr>   <dbl> <dbl>
    1 jueves      0     1
    2 viernes     4     0
    3 sábado      2     1

Simplemente escribe los nombres de las columnas con una colita de chancho antes (`~`) en la primera fila, y hacia abajo puedes ir rellenando los valores de cada columna.

------------------------------------------------------------------------

En ese tutorial nuevamente aprendimos herramientas básicas de R, esta vez orientadas a trabajar con datos en forma de tabla. Para esto, combinamos varios de los aprendizajes anteriores que habíamos aplicado a vectores, para reutilizarlos en esta nueva forma de organizar la información. Con los conocimientos obtenidos hasta ahora, ya sería posible llevar a cabo la mayor parte de las operaciones necesarias para la exploración de datos!

Ahora puedes pasar a los siguientes tutoriales, donde practicaremos estos aprendizajes en conjunto de datos reales: con [datos de proyecciones de población provenientes del Censo](../../../../blog/r_introduccion/tutorial_dplyr_censo/), y con [datos de un catastro de asentamientos de viviendas rudimentarias](../../../../blog/r_introduccion/tutorial_dplyr_campamentos/)

{{< cafecito >}}
{{< cursos >}}
