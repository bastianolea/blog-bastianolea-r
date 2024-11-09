---
title: 'Tutorial: introducción a {dplyr} con datos de población'
author: Bastián Olea Herrera
date: '2024-11-08'
draft: false
weight: 4
format: hugo-md
slug: []
categories:
  - Tutoriales
tags:
  - dplyr
excerpt: >-
  Tutorial de introducción al paquete `{dplyr}` para la exploración y análisis
  de datos con R. Está dirigido a principiantes. En este tutorial veremos cómo
  explorar un conjunto de datos sobre población.
---


Este post es una introducción al paquete `{dplyr}` para la exploración y análisis de datos con R. Está dirigido a principiantes de R. <!-- Si es primera vez que usas R, te recomiendo revisar primero [este breve tutorial inicial de R.](/blog/tutorial_r_1/). -->

*En este tutorial veremos:*
- carga de datos de Excel
- seleccionar columnas
- ordenar tablas de datos
- seleccionar filas de una tabla de datos
- filtrar datos

Los datos usados en este tutorial son las [Proyecciones de población para 2024 de Chile](https://www.ine.gob.cl/estadisticas/sociales/demografia-y-vitales/proyecciones-de-poblacion), calculadas por el Instituto Nacional de Estadísticas (INE). La obtención, procesamiento y visualización de estos datos puede encontrarse [en este repositorio,](https://github.com/bastianolea/censo_proyecciones_poblacion) junto a una [aplicación web desarrollada en R para visualizar los datos](https://github.com/bastianolea/censo_proyecciones).

## Instalación de paquetes

Los paquetes son conjuntos de funciones, programas, datos y documentación que sirven para potenciar R. Para poder usarlos, primero hay que instalarlos en nuestro computador usando la función `install.packages()`. Luego de instalarlos, simplemente los cargamos usando `library()`.

``` r
# es necesario instalarlos una sola vez
install.packages("dplyr")
install.packages("readxl")
```

Luego cargamos los paquetes:

``` r
library(dplyr) # manipulación de datos
library(readxl) # carga de archivos Excel
```

`{dplyr}` es un paquete parte del Tidyverse, que se usa para manipular datos a partir de funciones que emulan instrucciones sencillas, como *seleccionar, filtrar,* etc.

## Cargar datos

Antes que nada, debemos descargar el archivo que usaremos para el tutorial: [clic aquí para descargar el archivo Excel `censo_proyeccion_2024.xlsx`](https://raw.githubusercontent.com/bastianolea/censo_proyecciones_poblacion/refs/heads/main/datos_procesados/censo_proyeccion_2024.xlsx)

Importamos los datos que usaremos con la funcion `read_excel()`, cuyo argumento es el nombre del archivo. Asignamos el resultado a un objeto, y así tenemos nuetros datos de Excel cargados en R:

``` r
censo <- read_excel("censo_proyeccion_2024.xlsx") # cargar

censo # ver los datos de dataframe o tabla
```

    # A tibble: 346 × 7
       cut_region region      cut_provincia provincia   cut_comuna comuna  población
            <dbl> <chr>               <dbl> <chr>            <dbl> <chr>       <dbl>
     1          1 Tarapacá               11 Iquique           1101 Iquique    231962
     2          1 Tarapacá               11 Iquique           1107 Alto H…    143294
     3          1 Tarapacá               14 Tamarugal         1401 Pozo A…     18713
     4          1 Tarapacá               14 Tamarugal         1402 Camiña       1374
     5          1 Tarapacá               14 Tamarugal         1403 Colcha…      1558
     6          1 Tarapacá               14 Tamarugal         1404 Huara        3095
     7          1 Tarapacá               14 Tamarugal         1405 Pica         6291
     8          2 Antofagasta            21 Antofagasta       2101 Antofa…    444276
     9          2 Antofagasta            21 Antofagasta       2102 Mejill…     15877
    10          2 Antofagasta            21 Antofagasta       2103 Sierra…      1800
    # ℹ 336 more rows

Para ver más filas del dataframe, usamos la función `print()`:

``` r
print(censo, n = 20)
```

    # A tibble: 346 × 7
       cut_region region      cut_provincia provincia   cut_comuna comuna  población
            <dbl> <chr>               <dbl> <chr>            <dbl> <chr>       <dbl>
     1          1 Tarapacá               11 Iquique           1101 Iquique    231962
     2          1 Tarapacá               11 Iquique           1107 Alto H…    143294
     3          1 Tarapacá               14 Tamarugal         1401 Pozo A…     18713
     4          1 Tarapacá               14 Tamarugal         1402 Camiña       1374
     5          1 Tarapacá               14 Tamarugal         1403 Colcha…      1558
     6          1 Tarapacá               14 Tamarugal         1404 Huara        3095
     7          1 Tarapacá               14 Tamarugal         1405 Pica         6291
     8          2 Antofagasta            21 Antofagasta       2101 Antofa…    444276
     9          2 Antofagasta            21 Antofagasta       2102 Mejill…     15877
    10          2 Antofagasta            21 Antofagasta       2103 Sierra…      1800
    11          2 Antofagasta            21 Antofagasta       2104 Taltal      13967
    12          2 Antofagasta            22 El Loa            2201 Calama     196152
    13          2 Antofagasta            22 El Loa            2202 Ollagüe       269
    14          2 Antofagasta            22 El Loa            2203 San Pe…     11030
    15          2 Antofagasta            23 Tocopilla         2301 Tocopi…     28354
    16          2 Antofagasta            23 Tocopilla         2302 María …      6507
    17          3 Atacama                31 Copiapó           3101 Copiapó    176100
    18          3 Atacama                31 Copiapó           3102 Caldera     19964
    19          3 Atacama                31 Copiapó           3103 Tierra…     14431
    20          3 Atacama                32 Chañaral          3201 Chañar…     13017
    # ℹ 326 more rows

Ahora que tenemos nuestros datos cargados como un objeto en nuestro entorno de R, podemos empezar a manipularlo y explorarlo usando `{dplyr}`.

## Seleccionar columnas

La función `select()` selecciona columnas del dataframe.

``` r
censo |> # comando + shift + M
  select(comuna, población)
```

    # A tibble: 346 × 2
       comuna        población
       <chr>             <dbl>
     1 Iquique          231962
     2 Alto Hospicio    143294
     3 Pozo Almonte      18713
     4 Camiña             1374
     5 Colchane           1558
     6 Huara              3095
     7 Pica               6291
     8 Antofagasta      444276
     9 Mejillones        15877
    10 Sierra Gorda       1800
    # ℹ 336 more rows

El operador `|>` es un conector, y significa que *a este objeto le hago esto otro;* es decir, se lee como si dijera "luego" o "entonces". En este caso: *a `censo` le selecciono `comuna` y `población`.*

Podemos seleccionar negativamente; es decir, excluir ciertas columnas

``` r
censo |> 
  select(-cut_provincia, -cut_comuna, -cut_region)
```

    # A tibble: 346 × 4
       region      provincia   comuna        población
       <chr>       <chr>       <chr>             <dbl>
     1 Tarapacá    Iquique     Iquique          231962
     2 Tarapacá    Iquique     Alto Hospicio    143294
     3 Tarapacá    Tamarugal   Pozo Almonte      18713
     4 Tarapacá    Tamarugal   Camiña             1374
     5 Tarapacá    Tamarugal   Colchane           1558
     6 Tarapacá    Tamarugal   Huara              3095
     7 Tarapacá    Tamarugal   Pica               6291
     8 Antofagasta Antofagasta Antofagasta      444276
     9 Antofagasta Antofagasta Mejillones        15877
    10 Antofagasta Antofagasta Sierra Gorda       1800
    # ℹ 336 more rows

También podemos seleccionar columnas en base a sus nombres parciales:

``` r
censo |> 
  select(-contains("cut"))
```

    # A tibble: 346 × 4
       region      provincia   comuna        población
       <chr>       <chr>       <chr>             <dbl>
     1 Tarapacá    Iquique     Iquique          231962
     2 Tarapacá    Iquique     Alto Hospicio    143294
     3 Tarapacá    Tamarugal   Pozo Almonte      18713
     4 Tarapacá    Tamarugal   Camiña             1374
     5 Tarapacá    Tamarugal   Colchane           1558
     6 Tarapacá    Tamarugal   Huara              3095
     7 Tarapacá    Tamarugal   Pica               6291
     8 Antofagasta Antofagasta Antofagasta      444276
     9 Antofagasta Antofagasta Mejillones        15877
    10 Antofagasta Antofagasta Sierra Gorda       1800
    # ℹ 336 more rows

Selección de columnas por el numero de una columna (su posición):

``` r
censo |> 
  select(1:3, población)
```

    # A tibble: 346 × 4
       cut_region region      cut_provincia población
            <dbl> <chr>               <dbl>     <dbl>
     1          1 Tarapacá               11    231962
     2          1 Tarapacá               11    143294
     3          1 Tarapacá               14     18713
     4          1 Tarapacá               14      1374
     5          1 Tarapacá               14      1558
     6          1 Tarapacá               14      3095
     7          1 Tarapacá               14      6291
     8          2 Antofagasta            21    444276
     9          2 Antofagasta            21     15877
    10          2 Antofagasta            21      1800
    # ℹ 336 more rows

## Ordenar filas

Usamos la función `arrange()` para ordenar las filas de nuestros datos de acuerdo a otra variable:

``` r
censo |>
  arrange(población) |>
  select(comuna, población)
```

    # A tibble: 346 × 2
       comuna        población
       <chr>             <dbl>
     1 Antártica           151
     2 Río Verde           205
     3 Laguna Blanca       248
     4 Ollagüe             269
     5 Timaukel            276
     6 Tortel              585
     7 San Gregorio        651
     8 Primavera           674
     9 O'Higgins           675
    10 General Lagos       801
    # ℹ 336 more rows

Ordenar de mayor a menor:

``` r
censo |> 
  arrange(desc(población)) |> 
  select(region, comuna, población)
```

    # A tibble: 346 × 3
       region                    comuna       población
       <chr>                     <chr>            <dbl>
     1 Metropolitana de Santiago Puente Alto     667904
     2 Metropolitana de Santiago Maipú           586812
     3 Metropolitana de Santiago Santiago        544388
     4 Antofagasta               Antofagasta     444276
     5 Metropolitana de Santiago La Florida      407297
     6 Valparaíso                Viña del Mar    371490
     7 Metropolitana de Santiago San Bernardo    348640
     8 Metropolitana de Santiago Las Condes      343632
     9 Valparaíso                Valparaíso      320816
    10 La Araucanía              Temuco          309696
    # ℹ 336 more rows

Ordenar por dos variables a la vez

``` r
censo |> 
  arrange(region, desc(población)) |> 
  select(region, comuna, población) |> 
  print(n = 20)
```

    # A tibble: 346 × 3
       region             comuna               población
       <chr>              <chr>                    <dbl>
     1 Antofagasta        Antofagasta             444276
     2 Antofagasta        Calama                  196152
     3 Antofagasta        Tocopilla                28354
     4 Antofagasta        Mejillones               15877
     5 Antofagasta        Taltal                   13967
     6 Antofagasta        San Pedro de Atacama     11030
     7 Antofagasta        María Elena               6507
     8 Antofagasta        Sierra Gorda              1800
     9 Antofagasta        Ollagüe                    269
    10 Arica y Parinacota Arica                   257163
    11 Arica y Parinacota Putre                     2569
    12 Arica y Parinacota Camarones                 1246
    13 Arica y Parinacota General Lagos              801
    14 Atacama            Copiapó                 176100
    15 Atacama            Vallenar                 57360
    16 Atacama            Caldera                  19964
    17 Atacama            Tierra Amarilla          14431
    18 Atacama            Diego de Almagro         13909
    19 Atacama            Chañaral                 13017
    20 Atacama            Huasco                   11590
    # ℹ 326 more rows

## Filtrar datos

Con la función `filter()` podemos filtrar nuestro dataframe a partir de una comparación, dejando solamente las filas del dataframe que cumplan con la comparación.

Por ejemplo, dejar sólo las filas donde la comuna sea "Providencia":

``` r
censo |> filter(comuna == "Providencia")
```

    # A tibble: 1 × 7
      cut_region region          cut_provincia provincia cut_comuna comuna población
           <dbl> <chr>                   <dbl> <chr>          <dbl> <chr>      <dbl>
    1         13 Metropolitana …           131 Santiago       13123 Provi…    164009

Excluir las filas donde la columna sea "Alto Hospicio":

``` r
censo |> filter(comuna != "Alto Hospicio")
```

    # A tibble: 345 × 7
       cut_region region      cut_provincia provincia   cut_comuna comuna  población
            <dbl> <chr>               <dbl> <chr>            <dbl> <chr>       <dbl>
     1          1 Tarapacá               11 Iquique           1101 Iquique    231962
     2          1 Tarapacá               14 Tamarugal         1401 Pozo A…     18713
     3          1 Tarapacá               14 Tamarugal         1402 Camiña       1374
     4          1 Tarapacá               14 Tamarugal         1403 Colcha…      1558
     5          1 Tarapacá               14 Tamarugal         1404 Huara        3095
     6          1 Tarapacá               14 Tamarugal         1405 Pica         6291
     7          2 Antofagasta            21 Antofagasta       2101 Antofa…    444276
     8          2 Antofagasta            21 Antofagasta       2102 Mejill…     15877
     9          2 Antofagasta            21 Antofagasta       2103 Sierra…      1800
    10          2 Antofagasta            21 Antofagasta       2104 Taltal      13967
    # ℹ 335 more rows

Dejar sólo las observaciones donde la población sea mayor a un valor:

``` r
censo |> filter(población > 300000)
```

    # A tibble: 10 × 7
       cut_region region         cut_provincia provincia cut_comuna comuna población
            <dbl> <chr>                  <dbl> <chr>          <dbl> <chr>      <dbl>
     1          2 Antofagasta               21 Antofaga…       2101 Antof…    444276
     2          5 Valparaíso                51 Valparaí…       5101 Valpa…    320816
     3          5 Valparaíso                51 Valparaí…       5109 Viña …    371490
     4          9 La Araucanía              91 Cautín          9101 Temuco    309696
     5         13 Metropolitana…           131 Santiago       13101 Santi…    544388
     6         13 Metropolitana…           131 Santiago       13110 La Fl…    407297
     7         13 Metropolitana…           131 Santiago       13114 Las C…    343632
     8         13 Metropolitana…           131 Santiago       13119 Maipú     586812
     9         13 Metropolitana…           132 Cordille…      13201 Puent…    667904
    10         13 Metropolitana…           134 Maipo          13401 San B…    348640

Población menor a 1000, sólo dejar comuna y población, y ordenar de menor a mayor:

``` r
censo |> 
  filter(población < 1000) |> 
  select(comuna, población) |> 
  arrange(población)
```

    # A tibble: 11 × 2
       comuna        población
       <chr>             <dbl>
     1 Antártica           151
     2 Río Verde           205
     3 Laguna Blanca       248
     4 Ollagüe             269
     5 Timaukel            276
     6 Tortel              585
     7 San Gregorio        651
     8 Primavera           674
     9 O'Higgins           675
    10 General Lagos       801
    11 Lago Verde          914

Podemos hacer filtros usando funciones que operen sobre las columnas, por ejemplo, para filtrar las filas donde la población sea igual al mínimo de población:

``` r
censo |> 
  filter(población == min(población)) |> 
  select(region, comuna, provincia, población)
```

    # A tibble: 1 × 4
      region                               comuna    provincia         población
      <chr>                                <chr>     <chr>                 <dbl>
    1 Magallanes y de la Antártica Chilena Antártica Antártica Chilena       151

Un caso más útil sería filtrar los casos donde la población sea mayor o igual al promedio de población:

``` r
censo |> 
  filter(población >= mean(población)) |> 
  select(region, comuna, provincia, población)
```

    # A tibble: 84 × 4
       region      comuna        provincia   población
       <chr>       <chr>         <chr>           <dbl>
     1 Tarapacá    Iquique       Iquique        231962
     2 Tarapacá    Alto Hospicio Iquique        143294
     3 Antofagasta Antofagasta   Antofagasta    444276
     4 Antofagasta Calama        El Loa         196152
     5 Atacama     Copiapó       Copiapó        176100
     6 Coquimbo    La Serena     Elqui          267400
     7 Coquimbo    Coquimbo      Elqui          275644
     8 Coquimbo    Ovalle        Limarí         124401
     9 Valparaíso  Valparaíso    Valparaíso     320816
    10 Valparaíso  Viña del Mar  Valparaíso     371490
    # ℹ 74 more rows

También es posible filtrar usando objetos que creamos con anterioridad:

``` r
min_pob <- 25000
max_pob <- 30000

censo |> 
  filter(población > min_pob,
         población < max_pob) |> 
  select(población, comuna, provincia, region)
```

    # A tibble: 16 × 4
       población comuna     provincia   region                                   
           <dbl> <chr>      <chr>       <chr>                                    
     1     28354 Tocopilla  Tocopilla   Antofagasta                              
     2     29916 Salamanca  Choapa      Coquimbo                                 
     3     27898 La Cruz    Quillota    Valparaíso                               
     4     27065 Cartagena  San Antonio Valparaíso                               
     5     27286 Llaillay   San Felipe  Valparaíso                               
     6     27749 Las Cabras Cachapoal   Libertador General Bernardo O'Higgins    
     7     28552 Mostazal   Cachapoal   Libertador General Bernardo O'Higgins    
     8     26746 Hualqui    Concepción  Biobío                                   
     9     27152 Lebu       Arauco      Biobío                                   
    10     28028 Nacimiento Bíobío      Biobío                                   
    11     25515 Carahue    Cautín      La Araucanía                             
    12     25488 Freire     Cautín      La Araucanía                             
    13     26617 Pitrufquen Cautín      La Araucanía                             
    14     26558 Collipulli Malleco     La Araucanía                             
    15     25218 Aysén      Aysén       Aysén del General Carlos Ibáñez del Campo
    16     29067 Coihueco   Punilla     Ñuble                                    

Del mismo modo, podemos filtrar usando la cifra del promedio de población:

``` r
promedio <- mean(censo$población)

censo |> 
  filter(población > promedio)
```

    # A tibble: 84 × 7
       cut_region region      cut_provincia provincia   cut_comuna comuna  población
            <dbl> <chr>               <dbl> <chr>            <dbl> <chr>       <dbl>
     1          1 Tarapacá               11 Iquique           1101 Iquique    231962
     2          1 Tarapacá               11 Iquique           1107 Alto H…    143294
     3          2 Antofagasta            21 Antofagasta       2101 Antofa…    444276
     4          2 Antofagasta            22 El Loa            2201 Calama     196152
     5          3 Atacama                31 Copiapó           3101 Copiapó    176100
     6          4 Coquimbo               41 Elqui             4101 La Ser…    267400
     7          4 Coquimbo               41 Elqui             4102 Coquim…    275644
     8          4 Coquimbo               43 Limarí            4301 Ovalle     124401
     9          5 Valparaíso             51 Valparaíso        5101 Valpar…    320816
    10          5 Valparaíso             51 Valparaíso        5109 Viña d…    371490
    # ℹ 74 more rows

## Seleccionar filas

Usamos `slice()` para seleccionar filas específicas del dataframe:

``` r
censo |> 
  slice(200:220) # filas del 200 al 220
```

    # A tibble: 21 × 7
       cut_region region       cut_provincia provincia  cut_comuna comuna  población
            <dbl> <chr>                <dbl> <chr>           <dbl> <chr>       <dbl>
     1          9 La Araucanía            92 Malleco          9205 Lonqui…     11109
     2          9 La Araucanía            92 Malleco          9206 Los Sa…      7468
     3          9 La Araucanía            92 Malleco          9207 Lumaco       9916
     4          9 La Araucanía            92 Malleco          9208 Purén       12103
     5          9 La Araucanía            92 Malleco          9209 Renaico     11002
     6          9 La Araucanía            92 Malleco          9210 Traigu…     19260
     7          9 La Araucanía            92 Malleco          9211 Victor…     35554
     8         10 Los Lagos              101 Llanquihue      10101 Puerto…    280955
     9         10 Los Lagos              101 Llanquihue      10102 Calbuco     37626
    10         10 Los Lagos              101 Llanquihue      10103 Cochamó      3947
    # ℹ 11 more rows

También puede servir para seleccionar la fila que tenga el mayor o menos valor en una columna:

``` r
censo |> 
  slice_max(población)
```

    # A tibble: 1 × 7
      cut_region region          cut_provincia provincia cut_comuna comuna población
           <dbl> <chr>                   <dbl> <chr>          <dbl> <chr>      <dbl>
    1         13 Metropolitana …           132 Cordille…      13201 Puent…    667904

``` r
censo |> 
  slice_min(población)
```

    # A tibble: 1 × 7
      cut_region region          cut_provincia provincia cut_comuna comuna población
           <dbl> <chr>                   <dbl> <chr>          <dbl> <chr>      <dbl>
    1         12 Magallanes y d…           122 Antártic…      12202 Antár…       151

Incluso nos puede servir para seleccionar una cantidad de filas elegidas al azar:

``` r
censo |> 
  slice_sample(n = 5) |> 
  select(comuna)
```

    # A tibble: 5 × 1
      comuna       
      <chr>        
    1 Alto Hospicio
    2 Pichilemu    
    3 Machalí      
    4 Santa Cruz   
    5 Curicó       

## Selección de filas por grupos

Haciendo uso de la función `group_by()` podemos realizar operaciones en base a grupos. Esto significa que si agrupamos por región, y luego usamos `slice_max()` para obtener las observaciones con mayor población, el filtro de `slice_max()` se realizará una vez por cada región. Entonces, en vez de solamente obtener la comuna de mayor población del país, obtendremos la comuna con mayor población para cada región.

``` r
censo |> 
  group_by(region) |> 
  slice_max(población) |> 
  select(region, comuna, población)
```

    # A tibble: 16 × 3
    # Groups:   region [16]
       region                                    comuna       población
       <chr>                                     <chr>            <dbl>
     1 Antofagasta                               Antofagasta     444276
     2 Arica y Parinacota                        Arica           257163
     3 Atacama                                   Copiapó         176100
     4 Aysén del General Carlos Ibáñez del Campo Coyhaique        62046
     5 Biobío                                    Concepción      239776
     6 Coquimbo                                  Coquimbo        275644
     7 La Araucanía                              Temuco          309696
     8 Libertador General Bernardo O'Higgins     Rancagua        274407
     9 Los Lagos                                 Puerto Montt    280955
    10 Los Ríos                                  Valdivia        182086
    11 Magallanes y de la Antártica Chilena      Punta Arenas    145713
    12 Maule                                     Talca           242344
    13 Metropolitana de Santiago                 Puente Alto     667904
    14 Tarapacá                                  Iquique         231962
    15 Valparaíso                                Viña del Mar    371490
    16 Ñuble                                     Chillán         204091

Con esto concluye este tutorial inicial para manipular datos con el paquete `{dplyr}`. En siguientes tutoriales iremos usando funciones más complejas y avanzadas! 🫣
