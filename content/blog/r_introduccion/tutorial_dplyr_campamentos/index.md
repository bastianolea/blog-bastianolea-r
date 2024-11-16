---
title: 'Tutorial: introducción a {dplyr} usando datos de campamentos'
author: Bastián Olea Herrera
date: '2024-11-09'
draft: false
weight: 5
format: hugo-md
slug: []
categories:
  - Tutoriales
tags:
  - dplyr
excerpt: >-
  Tutorial de introducción al paquete `{dplyr}` para la exploración y análisis
  de datos con R. Está dirigido a principiantes. En este tutorial veremos cómo
  explorar un conjunto de datos sociohabitacionales, y a crear nuevas variables.
---


Este post es una introducción al paquete `{dplyr}` para la exploración y análisis de datos con R. Está dirigido a principiantes de R. Si es primera vez que usas R, te recomiendo revisar primero [este breve tutorial inicial de R.](../../../../blog/r_introduccion/r_basico/).

*En este tutorial veremos:*
- carga de datos de Excel
- revisar los datos
- seleccionar columnas
- ordenar tablas de datos
- contar frecuencias
- filtrar datos
- crear variables dicotómicas
- crear variables complejas

Los datos usados en este tutorial corresponden al catastro de campamentos de Chile 2024, del [Centro de Estudios del Ministerio de Vivienda y Urbanismo.](https://geoportal-open-data-minvu-2-minvu.hub.arcgis.com/datasets/MINVU::actualizacion-catastro-campamentos-2024-1/about). El código para obtener, procesar y visualizar los datos [se encuentra en este repositorio de GitHub.](https://github.com/bastianolea/campamentos_chile)

Para empezar, instalamos los paquetes que usaremos en este tutorial (solo se necesita hacer una vez, y sólo si es que no los tienes instalados).

``` r
install.packages("readxl") # cargar datos desde Excel
install.packages("dplyr") # manipulación de datos
```

# Cargar datos

Puedes [descargar el archivo `campamentos_chile_2024.xlsx` que usaremos en este tutorial desde este enlace](https://raw.githubusercontent.com/bastianolea/blog-r/refs/heads/master/content/blog/r_introduccion/tutorial_dplyr_campamentos/campamentos_chile_2024.xlsx). Los datos se obtuvieron desde [este repositorio.](https://github.com/bastianolea/campamentos_chile)

Cargamos los datos desde Excel usando el nombre del archivo como argumento a la función `read_excel()`:

``` r
library(readxl)

datos <- read_excel("campamentos_chile_2024.xlsx")

datos
```

    # A tibble: 1,432 × 12
       nombre     region provincia comuna cut_r cut_p   cut hogares hectareas   area
       <chr>      <chr>  <chr>     <chr>  <chr> <chr> <dbl>   <dbl>     <dbl>  <dbl>
     1 Bellavista Valpa… Valparaí… Valpa… 05    051    5101      29     1.51  10617.
     2 Buena Vis… Valpa… Valparaí… Valpa… 05    051    5101      32     1.67  11707.
     3 Los Flete… Valpa… Valparaí… Valpa… 05    051    5101      56     2.49  17465.
     4 Pueblo Hu… Valpa… Valparaí… Valpa… 05    051    5101      65     4.60  32261.
     5 Villa Ita… Valpa… Valparaí… Valpa… 05    051    5101      33     0.867  6081.
     6 Nueva Esp… Valpa… Valparaí… Valpa… 05    051    5101      17     0.399  2802.
     7 Francisco… Valpa… Valparaí… Valpa… 05    051    5101      24     2.85  19955.
     8 Manuel Ro… Valpa… Valparaí… Valpa… 05    051    5101      21     0.443  3103.
     9 Sofia 35   Valpa… Valparaí… Valpa… 05    051    5101      69     2.68  18819.
    10 Las Viñas… Valpa… Marga Ma… Villa… 05    058    5804      32     1.24   8704.
    # ℹ 1,422 more rows
    # ℹ 2 more variables: observaciones <chr>, año <chr>

Este tipo de objetos tabulares se llaman *dataframes,* específicamente *tibble,* que es un tipo de tabla. Los dataframes son tablas de datos hechas a partir de vectores, donde cada columna es un vector del mismo largo (misma cantidad de elementos). Los dataframes se caracterizan por tener distintas columnas que pueden de distinto tipo: numéricas, caracter (texto), lógico (TRUE/FALSE), fechas, entre otras. Todas las columnas tienen el mismo largo, que es equivalente a la cantidad de filas de la tabla.

Para explorar los datos, usaremos el paquete `{dplyr}`, que nos permite manejar datos con mayor facilidad. `{dplyr}` sirve para manipular datos a partir de funciones que emulan instrucciones sencillas, como *seleccionar, filtrar,* etc.

``` r
library(dplyr)
```

Una particularidad del uso de `{dplyr}` es el uso del operador `|>`, que es operador que nos permite conectar un objeto con una o múltiples operaciones que deseamos realizarle al objeto.

Ejemplo de dos operaciones encadenadas:

``` r
datos |> 
  select(nombre, hogares, hectareas) |> 
  filter(hogares > 60)
```

    # A tibble: 352 × 3
       nombre                              hogares hectareas
       <chr>                                 <dbl>     <dbl>
     1 Pueblo Hundido                           65      4.60
     2 Sofia 35                                 69      2.68
     3 Ampliación Prat-Lomas De Peñablanca     146     15.1 
     4 Violeta Parra                           123     10.7 
     5 Mesana Alto                             128     14.5 
     6 Pampa Ilusión (Sector Las Torres)       195      7.04
     7 Parcela 11                              520     44.0 
     8 Parcela 15                              257     15.4 
     9 Campanillas                              98      6.19
    10 La Isla                                 116      4.51
    # ℹ 342 more rows

El conector significa que *a este objeto le hago esto otro;* es decir, se lee como si dijera "luego" o "entonces". En este caso: *a `datos` le selecciono columnas y le aplico un filtro.*

## Revisar

Ejecutar el nombre del objeto nos permite que sus contenidos aparezcan en la consola de R.

``` r
datos
```

    # A tibble: 1,432 × 12
       nombre     region provincia comuna cut_r cut_p   cut hogares hectareas   area
       <chr>      <chr>  <chr>     <chr>  <chr> <chr> <dbl>   <dbl>     <dbl>  <dbl>
     1 Bellavista Valpa… Valparaí… Valpa… 05    051    5101      29     1.51  10617.
     2 Buena Vis… Valpa… Valparaí… Valpa… 05    051    5101      32     1.67  11707.
     3 Los Flete… Valpa… Valparaí… Valpa… 05    051    5101      56     2.49  17465.
     4 Pueblo Hu… Valpa… Valparaí… Valpa… 05    051    5101      65     4.60  32261.
     5 Villa Ita… Valpa… Valparaí… Valpa… 05    051    5101      33     0.867  6081.
     6 Nueva Esp… Valpa… Valparaí… Valpa… 05    051    5101      17     0.399  2802.
     7 Francisco… Valpa… Valparaí… Valpa… 05    051    5101      24     2.85  19955.
     8 Manuel Ro… Valpa… Valparaí… Valpa… 05    051    5101      21     0.443  3103.
     9 Sofia 35   Valpa… Valparaí… Valpa… 05    051    5101      69     2.68  18819.
    10 Las Viñas… Valpa… Marga Ma… Villa… 05    058    5804      32     1.24   8704.
    # ℹ 1,422 more rows
    # ℹ 2 more variables: observaciones <chr>, año <chr>

Por defecto, la consola nos muestra 10 filas de la tabla. Si queremos ver más filas podemos usar la función `print()`

``` r
datos |> 
  print(n = 20)
```

    # A tibble: 1,432 × 12
       nombre     region provincia comuna cut_r cut_p   cut hogares hectareas   area
       <chr>      <chr>  <chr>     <chr>  <chr> <chr> <dbl>   <dbl>     <dbl>  <dbl>
     1 Bellavista Valpa… Valparaí… Valpa… 05    051    5101      29     1.51  1.06e4
     2 Buena Vis… Valpa… Valparaí… Valpa… 05    051    5101      32     1.67  1.17e4
     3 Los Flete… Valpa… Valparaí… Valpa… 05    051    5101      56     2.49  1.75e4
     4 Pueblo Hu… Valpa… Valparaí… Valpa… 05    051    5101      65     4.60  3.23e4
     5 Villa Ita… Valpa… Valparaí… Valpa… 05    051    5101      33     0.867 6.08e3
     6 Nueva Esp… Valpa… Valparaí… Valpa… 05    051    5101      17     0.399 2.80e3
     7 Francisco… Valpa… Valparaí… Valpa… 05    051    5101      24     2.85  2.00e4
     8 Manuel Ro… Valpa… Valparaí… Valpa… 05    051    5101      21     0.443 3.10e3
     9 Sofia 35   Valpa… Valparaí… Valpa… 05    051    5101      69     2.68  1.88e4
    10 Las Viñas… Valpa… Marga Ma… Villa… 05    058    5804      32     1.24  8.70e3
    11 Lomas De … Valpa… Marga Ma… Villa… 05    058    5804      42     3.97  2.78e4
    12 Manzana 33 Valpa… Marga Ma… Villa… 05    058    5804      37     2.19  1.53e4
    13 Ampliació… Valpa… Marga Ma… Villa… 05    058    5804     146    15.1   1.06e5
    14 Los Artes… Valpa… Valparaí… Viña … 05    051    5109      35     2.00  1.40e4
    15 La Unión … Valpa… Valparaí… Viña … 05    051    5109      20     1.33  9.30e3
    16 John Kenn… Valpa… Valparaí… Valpa… 05    051    5101      48     0.858 6.01e3
    17 Pezoa Vel… Valpa… Valparaí… Valpa… 05    051    5101      22     0.194 1.36e3
    18 Violeta P… Valpa… Valparaí… Valpa… 05    051    5101     123    10.7   7.50e4
    19 Cristo Re… Valpa… Valparaí… Valpa… 05    051    5101      53     0.862 6.04e3
    20 Loma Vist… Valpa… Valparaí… Viña … 05    051    5109      47     1.19  8.34e3
    # ℹ 1,412 more rows
    # ℹ 2 more variables: observaciones <chr>, año <chr>

Las funciones `head()` y `tails()` te muestran las primeras o últimas filas de la tabla, respectivamente. Si la combinas con `print()`, puedes consultar la cantidad que quieras de filas al principio o final de tu tabla.

``` r
# ver últimas 20 filas
datos |> 
  tail(20) |> 
  print(n=Inf)
```

    # A tibble: 20 × 12
       nombre     region provincia comuna cut_r cut_p   cut hogares hectareas   area
       <chr>      <chr>  <chr>     <chr>  <chr> <chr> <dbl>   <dbl>     <dbl>  <dbl>
     1 Longitudi… Valpa… Marga Ma… Villa… 05    058    5804      14     0.681 4.78e3
     2 Comunidad… Valpa… Marga Ma… Villa… 05    058    5804      36     1.28  8.97e3
     3 Nueva Tol… Valpa… Marga Ma… Villa… 05    058    5804      10     0.305 2.14e3
     4 Toma Nuev… Metro… Cordille… Puent… 13    132   13201       0     0     0     
     5 Villa Res… Valpa… San Anto… Carta… 05    056    5601      48     6.15  4.26e4
     6 Sector Lí… La Ar… Malleco   Traig… 09    092    9210      15     2.56  1.58e4
     7 Licantatay Antof… El Loa    Calama 02    022    2201      41     6.27  5.33e4
     8 Nuevo Ama… Antof… El Loa    Calama 02    022    2201      41    47.4   4.03e5
     9 Barrio Tr… Antof… El Loa    Calama 02    022    2201       0    55.3   4.69e5
    10 Calameños… Antof… El Loa    Calama 02    022    2201      91     4.41  3.74e4
    11 Tres Band… Antof… Antofaga… Taltal 02    021    2104       0     2.39  1.94e4
    12 Sauce 3    Valpa… Valparaí… Viña … 05    051    5109       0     3.35  2.35e4
    13 Campament… Antof… Antofaga… Antof… 02    021    2101       0     0.450 3.76e3
    14 Campament… Antof… Tocopilla Tocop… 02    023    2301      27     5.52  4.72e4
    15 Luz Divin… Antof… Antofaga… Antof… 02    021    2101       0     0.934 7.81e3
    16 Villa Esp… Antof… Antofaga… Antof… 02    021    2101       0     0.623 5.20e3
    17 Valle Her… Biobío Arauco    Los A… 08    082    8206      71     8.18  5.14e4
    18 Rucamanque Biobío Concepci… Talca… 08    081    8110     119     5.24  3.37e4
    19 Caleta Co… Antof… Tocopilla Tocop… 02    023    2301       0     5.38  4.56e4
    20 Caleta Co… Antof… Tocopilla Tocop… 02    023    2301       0     1.00  8.52e3
    # ℹ 2 more variables: observaciones <chr>, año <chr>

Una función útil para poder revisar los datos rápidamente de una forma distinta es `glimpse()`, que nos muestra la tabla pero con las columnas hacia abajo y los valores hacia el lado. Es como ver la tabla girada, permitiéndonos ver todas sus columnas, sus formatos, y un ejemplo de las primeras observaciones de cada variable.

``` r
datos |> 
  glimpse()
```

    Rows: 1,432
    Columns: 12
    $ nombre        <chr> "Bellavista", "Buena Vista", "Los Fleteros", "Pueblo Hun…
    $ region        <chr> "Valparaíso", "Valparaíso", "Valparaíso", "Valparaíso", …
    $ provincia     <chr> "Valparaíso", "Valparaíso", "Valparaíso", "Valparaíso", …
    $ comuna        <chr> "Valparaíso", "Valparaíso", "Valparaíso", "Valparaíso", …
    $ cut_r         <chr> "05", "05", "05", "05", "05", "05", "05", "05", "05", "0…
    $ cut_p         <chr> "051", "051", "051", "051", "051", "051", "051", "051", …
    $ cut           <dbl> 5101, 5101, 5101, 5101, 5101, 5101, 5101, 5101, 5101, 58…
    $ hogares       <dbl> 29, 32, 56, 65, 33, 17, 24, 21, 69, 32, 42, 37, 146, 35,…
    $ hectareas     <dbl> 1.5138015, 1.6700459, 2.4914854, 4.6023230, 0.8673470, 0…
    $ area          <dbl> 10617.233, 11707.446, 17465.450, 32261.178, 6080.654, 28…
    $ observaciones <chr> "CAMPAMENTO EN CATASTRO NACIONAL 2022. EXTENSIÓN DE LÍMI…
    $ año           <chr> "CATASTRO_2011", "CATASTRO_2011", "CATASTRO_2011", "CATA…

La función `slice()` permite extraer filas específicas de la tabla, según su posición. Por ejemplo, aquí extraeremos las filas número 1000 al 1010:

``` r
datos |> 
  slice(1000:1010)
```

    # A tibble: 11 × 12
       nombre     region provincia comuna cut_r cut_p   cut hogares hectareas   area
       <chr>      <chr>  <chr>     <chr>  <chr> <chr> <dbl>   <dbl>     <dbl>  <dbl>
     1 Batuco     Metro… Chacabuco Lampa  13    133   13302      84    11.5   7.99e4
     2 Jerusalén  Metro… Chacabuco Lampa  13    133   13302     565    32.1   2.24e5
     3 Borde Rio… Liber… Cachapoal Doñih… 06    061    6105       0    10.5   7.15e4
     4 Toma Vist… Metro… Chacabuco Lampa  13    133   13302     539    14.5   1.01e5
     5 Medialuna… Metro… Chacabuco Lampa  13    133   13302     104     2.23  1.56e4
     6 Puente Li… Liber… Cachapoal Malloa 06    061    6109       0     1.75  1.18e4
     7 Mirador    Metro… Chacabuco Lampa  13    133   13302     117     5.37  3.74e4
     8 Esperando… Liber… Cachapoal Rengo  06    061    6115       0     1.15  7.84e3
     9 Central L… Metro… Chacabuco Lampa  13    133   13302      14     1.79  1.25e4
    10 Los Tronc… Liber… Cachapoal Rengo  06    061    6115       0     0.970 6.59e3
    11 Los Tubos  Metro… Maipo     Buin   13    134   13402      27     0.864 5.95e3
    # ℹ 2 more variables: observaciones <chr>, año <chr>

## Ordenar

Ordenar observaciones en base a una o varias columnas

``` r
datos |> 
  arrange(nombre)
```

    # A tibble: 1,432 × 12
       nombre     region provincia comuna cut_r cut_p   cut hogares hectareas   area
       <chr>      <chr>  <chr>     <chr>  <chr> <chr> <dbl>   <dbl>     <dbl>  <dbl>
     1 05 De Abr… Ataca… Copiapó   Copia… 03    031    3101      27     1.11  8.71e3
     2 10 De Ago… Tarap… Iquique   Alto … 01    011    1107     104     1.63  1.43e4
     3 12 De Feb… Liber… Cachapoal Macha… 06    061    6108      47    12.7   8.64e4
     4 12 De May… Metro… Chacabuco Colina 13    133   13301     148     2.16  1.51e4
     5 12 De Oct… Ataca… Copiapó   Copia… 03    031    3101      12     0.791 6.22e3
     6 13 De Jun… Tarap… Tamarugal Pozo … 01    014    1401       0     0.224 1.96e3
     7 14 de feb… La Ar… Cautín    Temuco 09    091    9101       0     0.635 3.86e3
     8 15 De Feb… Ataca… Copiapó   Copia… 03    031    3101      16     0.499 3.92e3
     9 17 De Mayo Metro… Santiago  Cerro… 13    131   13103     158    15.7   1.09e5
    10 18 De Oct… Valpa… Marga Ma… Villa… 05    058    5804      18     1.15  8.04e3
    # ℹ 1,422 more rows
    # ℹ 2 more variables: observaciones <chr>, año <chr>

``` r
datos |> 
  arrange(desc(hogares))
```

    # A tibble: 1,432 × 12
       nombre     region provincia comuna cut_r cut_p   cut hogares hectareas   area
       <chr>      <chr>  <chr>     <chr>  <chr> <chr> <dbl>   <dbl>     <dbl>  <dbl>
     1 Alto Molle Tarap… Iquique   Alto … 01    011    1107    3390     130.  1.14e6
     2 Manuel Bu… Valpa… Valparaí… Viña … 05    051    5109    1647      90.2 6.33e5
     3 América I… Metro… Santiago  Cerri… 13    131   13102    1550      29.8 2.07e5
     4 Dignidad   Metro… Chacabuco Colina 13    133   13301    1004      15.8 1.10e5
     5 Milla Ant… Metro… Cordille… Puent… 13    132   13201    1001      23.0 1.59e5
     6 Comité de… Antof… Antofaga… Antof… 02    021    2101    1000      14.8 1.24e5
     7 Centinela… Valpa… San Anto… San A… 05    056    5601     833     111.  7.69e5
     8 Vista Her… Valpa… San Anto… Carta… 05    056    5603     789      64.6 4.48e5
     9 Aguas Sal… Valpa… San Anto… San A… 05    056    5601     688      45.1 3.12e5
    10 Felipe Ca… Valpa… Valparaí… Viña … 05    051    5109     669      37.0 2.59e5
    # ℹ 1,422 more rows
    # ℹ 2 more variables: observaciones <chr>, año <chr>

``` r
datos |> 
  arrange(comuna, desc(hogares)) |> 
  select(nombre, comuna, hogares)
```

    # A tibble: 1,432 × 3
       nombre             comuna        hogares
       <chr>              <chr>           <dbl>
     1 Las Quilas II      Aisén              83
     2 Las Avutardas      Aisén              16
     3 CAMINO CEMENTERIO  Aisén               8
     4 Almirante Simpson  Aisén               0
     5 Pueblo Hundido     Alto Biobío        30
     6 Pueblo Hundido     Alto Biobío        13
     7 Sector Pangue      Alto Biobío        10
     8 Alto Molle         Alto Hospicio    3390
     9 Ex Vertedero Norte Alto Hospicio     394
    10 La Pampa 2         Alto Hospicio     347
    # ℹ 1,422 more rows

``` r
datos |> glimpse()
```

    Rows: 1,432
    Columns: 12
    $ nombre        <chr> "Bellavista", "Buena Vista", "Los Fleteros", "Pueblo Hun…
    $ region        <chr> "Valparaíso", "Valparaíso", "Valparaíso", "Valparaíso", …
    $ provincia     <chr> "Valparaíso", "Valparaíso", "Valparaíso", "Valparaíso", …
    $ comuna        <chr> "Valparaíso", "Valparaíso", "Valparaíso", "Valparaíso", …
    $ cut_r         <chr> "05", "05", "05", "05", "05", "05", "05", "05", "05", "0…
    $ cut_p         <chr> "051", "051", "051", "051", "051", "051", "051", "051", …
    $ cut           <dbl> 5101, 5101, 5101, 5101, 5101, 5101, 5101, 5101, 5101, 58…
    $ hogares       <dbl> 29, 32, 56, 65, 33, 17, 24, 21, 69, 32, 42, 37, 146, 35,…
    $ hectareas     <dbl> 1.5138015, 1.6700459, 2.4914854, 4.6023230, 0.8673470, 0…
    $ area          <dbl> 10617.233, 11707.446, 17465.450, 32261.178, 6080.654, 28…
    $ observaciones <chr> "CAMPAMENTO EN CATASTRO NACIONAL 2022. EXTENSIÓN DE LÍMI…
    $ año           <chr> "CATASTRO_2011", "CATASTRO_2011", "CATASTRO_2011", "CATA…

``` r
datos2 <- datos |> 
  select(1:4) |> 
  slice_sample(n = 10)
```

## Seleccionar

Podemos reducir la cantidad de columnas de nuestra tabla usando `select()`. Esto puede servirnos para acotar la exploración de los datos, cuando no necesitamos ver todas las columnas al mismo tiempo.

``` r
datos |> 
  select(nombre, hectareas)
```

    # A tibble: 1,432 × 2
       nombre                  hectareas
       <chr>                       <dbl>
     1 Bellavista                  1.51 
     2 Buena Vista                 1.67 
     3 Los Fleteros                2.49 
     4 Pueblo Hundido              4.60 
     5 Villa Italia Turín          0.867
     6 Nueva Esperanza             0.399
     7 Francisco Vergara           2.85 
     8 Manuel Rodríguez            0.443
     9 Sofia 35                    2.68 
    10 Las Viñas De Irene Frei     1.24 
    # ℹ 1,422 more rows

Ante poniendo un signo menos antes del nombre de una columna podemos excluirla de nuestra tabla.

``` r
datos |> 
  select(-cut, -cut_r, -cut_p)
```

    # A tibble: 1,432 × 9
       nombre   region provincia comuna hogares hectareas   area observaciones año  
       <chr>    <chr>  <chr>     <chr>    <dbl>     <dbl>  <dbl> <chr>         <chr>
     1 Bellavi… Valpa… Valparaí… Valpa…      29     1.51  10617. CAMPAMENTO E… CATA…
     2 Buena V… Valpa… Valparaí… Valpa…      32     1.67  11707. CAMPAMENTO E… CATA…
     3 Los Fle… Valpa… Valparaí… Valpa…      56     2.49  17465. CAMPAMENTO E… CATA…
     4 Pueblo … Valpa… Valparaí… Valpa…      65     4.60  32261. CAMPAMENTO E… CATA…
     5 Villa I… Valpa… Valparaí… Valpa…      33     0.867  6081. CAMPAMENTO E… CATA…
     6 Nueva E… Valpa… Valparaí… Valpa…      17     0.399  2802. CAMPAMENTO E… CATA…
     7 Francis… Valpa… Valparaí… Valpa…      24     2.85  19955. CAMPAMENTO E… CATA…
     8 Manuel … Valpa… Valparaí… Valpa…      21     0.443  3103. CAMPAMENTO E… CATA…
     9 Sofia 35 Valpa… Valparaí… Valpa…      69     2.68  18819. CAMPAMENTO E… CATA…
    10 Las Viñ… Valpa… Marga Ma… Villa…      32     1.24   8704. CAMPAMENTO E… CATA…
    # ℹ 1,422 more rows

Recordemos que, hasta que no asignemos estas operaciones a un nuevo objeto, no estamos modificando nuestros datos realmente, sino que solamente estamos aplicando operaciones sobre los datos de una forma no destructiva, como exploración o a modo de prueba.

La función selecta acepta diversas formas de poder seleccionar o de seleccionar variables en base a sus nombres.

Excluir columnas que incluyan cierto texto dentro de sus nombres:

``` r
datos |> 
  select(-contains("cut"))
```

    # A tibble: 1,432 × 9
       nombre   region provincia comuna hogares hectareas   area observaciones año  
       <chr>    <chr>  <chr>     <chr>    <dbl>     <dbl>  <dbl> <chr>         <chr>
     1 Bellavi… Valpa… Valparaí… Valpa…      29     1.51  10617. CAMPAMENTO E… CATA…
     2 Buena V… Valpa… Valparaí… Valpa…      32     1.67  11707. CAMPAMENTO E… CATA…
     3 Los Fle… Valpa… Valparaí… Valpa…      56     2.49  17465. CAMPAMENTO E… CATA…
     4 Pueblo … Valpa… Valparaí… Valpa…      65     4.60  32261. CAMPAMENTO E… CATA…
     5 Villa I… Valpa… Valparaí… Valpa…      33     0.867  6081. CAMPAMENTO E… CATA…
     6 Nueva E… Valpa… Valparaí… Valpa…      17     0.399  2802. CAMPAMENTO E… CATA…
     7 Francis… Valpa… Valparaí… Valpa…      24     2.85  19955. CAMPAMENTO E… CATA…
     8 Manuel … Valpa… Valparaí… Valpa…      21     0.443  3103. CAMPAMENTO E… CATA…
     9 Sofia 35 Valpa… Valparaí… Valpa…      69     2.68  18819. CAMPAMENTO E… CATA…
    10 Las Viñ… Valpa… Marga Ma… Villa…      32     1.24   8704. CAMPAMENTO E… CATA…
    # ℹ 1,422 more rows

Seleccionar columnas que empiecen con cierto texto:

``` r
datos |> 
  select(starts_with("com"))
```

    # A tibble: 1,432 × 1
       comuna       
       <chr>        
     1 Valparaíso   
     2 Valparaíso   
     3 Valparaíso   
     4 Valparaíso   
     5 Valparaíso   
     6 Valparaíso   
     7 Valparaíso   
     8 Valparaíso   
     9 Valparaíso   
    10 Villa Alemana
    # ℹ 1,422 more rows

Seleccionar comunas que terminen con un texto determinado:

``` r
datos |> 
  select(ends_with("a"))
```

    # A tibble: 1,432 × 3
       provincia   comuna          area
       <chr>       <chr>          <dbl>
     1 Valparaíso  Valparaíso    10617.
     2 Valparaíso  Valparaíso    11707.
     3 Valparaíso  Valparaíso    17465.
     4 Valparaíso  Valparaíso    32261.
     5 Valparaíso  Valparaíso     6081.
     6 Valparaíso  Valparaíso     2802.
     7 Valparaíso  Valparaíso    19955.
     8 Valparaíso  Valparaíso     3103.
     9 Valparaíso  Valparaíso    18819.
    10 Marga Marga Villa Alemana  8704.
    # ℹ 1,422 more rows

También podemos seleccionar columnas de un determinado tipo. En este caso, seleccionamos solamente las variables que sean numéricas:

``` r
datos |> 
  select(where(is.numeric))
```

    # A tibble: 1,432 × 4
         cut hogares hectareas   area
       <dbl>   <dbl>     <dbl>  <dbl>
     1  5101      29     1.51  10617.
     2  5101      32     1.67  11707.
     3  5101      56     2.49  17465.
     4  5101      65     4.60  32261.
     5  5101      33     0.867  6081.
     6  5101      17     0.399  2802.
     7  5101      24     2.85  19955.
     8  5101      21     0.443  3103.
     9  5101      69     2.68  18819.
    10  5804      32     1.24   8704.
    # ℹ 1,422 more rows

## Conteos

La función Count se aplica a una de las variables de nuestros datos, y cuenta la cantidad de observaciones que se corresponden con cada uno de los valores o niveles posibles de la variable. En otras palabras, cuenta la frecuencia de cada categoría de respuesta de la variable.

``` r
datos |> 
  count(region)
```

    # A tibble: 16 × 2
       region                                        n
       <chr>                                     <int>
     1 Antofagasta                                 116
     2 Arica y Parinacota                           14
     3 Atacama                                     121
     4 Aysén del General Carlos Ibáñez del Campo    10
     5 Biobío                                      225
     6 Coquimbo                                     52
     7 La Araucanía                                 70
     8 Libertador General Bernardo O'Higgins        59
     9 Los Lagos                                    67
    10 Los Ríos                                     40
    11 Magallanes y de la Antártica Chilena          3
    12 Maule                                        25
    13 Metropolitana                               168
    14 Tarapacá                                     64
    15 Valparaíso                                  374
    16 Ñuble                                        24

Podemos combinar un conteo de una variable con el ordenamiento de las filas en base al conteo realizado, resultando una tabla ordenada de mayor a menor según las observaciones contadas:

``` r
datos |> 
  count(region) |> 
  arrange(desc(n))
```

    # A tibble: 16 × 2
       region                                        n
       <chr>                                     <int>
     1 Valparaíso                                  374
     2 Biobío                                      225
     3 Metropolitana                               168
     4 Atacama                                     121
     5 Antofagasta                                 116
     6 La Araucanía                                 70
     7 Los Lagos                                    67
     8 Tarapacá                                     64
     9 Libertador General Bernardo O'Higgins        59
    10 Coquimbo                                     52
    11 Los Ríos                                     40
    12 Maule                                        25
    13 Ñuble                                        24
    14 Arica y Parinacota                           14
    15 Aysén del General Carlos Ibáñez del Campo    10
    16 Magallanes y de la Antártica Chilena          3

Naturalmente, es posible realizar conteos por más de una variable, mostrando las combinaciones entre ambas:

``` r
datos |> 
  count(region, comuna) |> 
  arrange(desc(n))
```

    # A tibble: 195 × 3
       region       comuna            n
       <chr>        <chr>         <int>
     1 Valparaíso   Viña del Mar    114
     2 Valparaíso   Valparaíso       99
     3 Antofagasta  Antofagasta      87
     4 Atacama      Copiapó          82
     5 Tarapacá     Alto Hospicio    45
     6 La Araucanía Temuco           41
     7 Biobío       Talcahuano       32
     8 Valparaíso   Quilpué          32
     9 Biobío       Lota             30
    10 Valparaíso   San Antonio      27
    # ℹ 185 more rows

## Filtros

Podemos realizar una comparación sobre una columna del dataframe para filtrar las observaciones (filas), dejando solamente las filas que cumplen con la condición.

Por ejemplo, filtrar solamente los casos donde la cantidad de hogares sea mayor a 80:

``` r
datos |> 
  filter(hogares > 80)
```

    # A tibble: 239 × 12
       nombre     region provincia comuna cut_r cut_p   cut hogares hectareas   area
       <chr>      <chr>  <chr>     <chr>  <chr> <chr> <dbl>   <dbl>     <dbl>  <dbl>
     1 Ampliació… Valpa… Marga Ma… Villa… 05    058    5804     146     15.1  1.06e5
     2 Violeta P… Valpa… Valparaí… Valpa… 05    051    5101     123     10.7  7.50e4
     3 Mesana Al… Valpa… Valparaí… Valpa… 05    051    5101     128     14.5  1.02e5
     4 Pampa Ilu… Valpa… Valparaí… Valpa… 05    051    5101     195      7.04 4.93e4
     5 Parcela 11 Valpa… Valparaí… Viña … 05    051    5109     520     44.0  3.08e5
     6 Parcela 15 Valpa… Valparaí… Viña … 05    051    5109     257     15.4  1.08e5
     7 Campanill… Valpa… Valparaí… Valpa… 05    051    5101      98      6.19 4.34e4
     8 La Isla    Valpa… Valparaí… Valpa… 05    051    5101     116      4.51 3.16e4
     9 Nueva Aur… Valpa… Valparaí… Viña … 05    051    5109      91      7.47 5.24e4
    10 Valle El … Valpa… Valparaí… Viña … 05    051    5109     107      4.04 2.84e4
    # ℹ 229 more rows
    # ℹ 2 more variables: observaciones <chr>, año <chr>

``` r
datos |> 
  filter(region == "Ñuble")
```

    # A tibble: 24 × 12
       nombre     region provincia comuna cut_r cut_p   cut hogares hectareas   area
       <chr>      <chr>  <chr>     <chr>  <chr> <chr> <dbl>   <dbl>     <dbl>  <dbl>
     1 Los Corre… Ñuble  Diguillín Chill… 16    161   16101      13     0.250 1.61e3
     2 Línea Fér… Ñuble  Diguillín Chill… 16    161   16101      35     3.21  2.07e4
     3 Litral Co… Ñuble  Diguillín Chill… 16    161   16101      26     5.33  3.43e4
     4 Los Monte… Ñuble  Diguillín Chill… 16    161   16101      47     5.57  3.59e4
     5 Orilla It… Ñuble  Itata     Porte… 16    162   16205      11     1.41  9.07e3
     6 Pablo Ner… Ñuble  Itata     Quiri… 16    162   16201      39    22.7   1.47e5
     7 Esmeralda… Ñuble  Punilla   San N… 16    163   16305      13     0.232 1.50e3
     8 Santa Lau… Ñuble  Punilla   San N… 16    163   16305      22     8.28  5.34e4
     9 El Esfuer… Ñuble  Diguillín Bulnes 16    161   16102      11     0.632 4.05e3
    10 El Refugio Ñuble  Diguillín Bulnes 16    161   16102      16     1.11  7.10e3
    # ℹ 14 more rows
    # ℹ 2 more variables: observaciones <chr>, año <chr>

Es posible realizar dos o más filtros de forma consecutiva:

``` r
datos |> 
  filter(hogares > 90, 
         hectareas > 30)
```

    # A tibble: 18 × 12
       nombre     region provincia comuna cut_r cut_p   cut hogares hectareas   area
       <chr>      <chr>  <chr>     <chr>  <chr> <chr> <dbl>   <dbl>     <dbl>  <dbl>
     1 Parcela 11 Valpa… Valparaí… Viña … 05    051    5109     520      44.0 3.08e5
     2 Manuel Bu… Valpa… Valparaí… Viña … 05    051    5109    1647      90.2 6.33e5
     3 Reñaca Al… Valpa… Valparaí… Viña … 05    051    5109     663      39.1 2.75e5
     4 Felipe Ca… Valpa… Valparaí… Viña … 05    051    5109     669      37.0 2.59e5
     5 Aguas Sal… Valpa… San Anto… San A… 05    056    5601     688      45.1 3.12e5
     6 Alto Mira… Valpa… San Anto… San A… 05    056    5601     560      47.7 3.30e5
     7 Centinela… Valpa… San Anto… San A… 05    056    5601     833     111.  7.69e5
     8 Rol 9034-1 Valpa… San Anto… San A… 05    056    5601     227      32.1 2.22e5
     9 Vista Her… Valpa… San Anto… Carta… 05    056    5603     789      64.6 4.48e5
    10 El Colora… Valpa… Marga Ma… Limac… 05    058    5802     235      59.1 4.15e5
    11 Mirando l… Tarap… Iquique   Alto … 01    011    1107     164     114.  9.96e5
    12 Alto Molle Tarap… Iquique   Alto … 01    011    1107    3390     130.  1.14e6
    13 El Castaño Biobío Arauco    Curan… 08    082    8205      92      56.2 3.55e5
    14 Ribera De… Metro… Talagante Talag… 13    136   13601     115      37.8 2.61e5
    15 Jerusalén  Metro… Chacabuco Lampa  13    133   13302     565      32.1 2.24e5
    16 Las Minas… Biobío Arauco    Curan… 08    082    8205     100      88.3 5.58e5
    17 Villa El … Biobío Arauco    Curan… 08    082    8205     135     129.  8.16e5
    18 Ex Inia    Coqui… Choapa    Los V… 04    042    4203     315      36.6 2.63e5
    # ℹ 2 more variables: observaciones <chr>, año <chr>

También es posible usar otros operadores dentro de las comparaciones, Tales como el operador *o* `|`, que en este caso nos va a permitir filtrar las observaciones que cumplan con una o con otra condición:

``` r
datos |> 
  filter(hogares > 300 | hectareas > 100)
```

    # A tibble: 33 × 12
       nombre     region provincia comuna cut_r cut_p   cut hogares hectareas   area
       <chr>      <chr>  <chr>     <chr>  <chr> <chr> <dbl>   <dbl>     <dbl>  <dbl>
     1 Parcela 11 Valpa… Valparaí… Viña … 05    051    5109     520      44.0 3.08e5
     2 Manuel Bu… Valpa… Valparaí… Viña … 05    051    5109    1647      90.2 6.33e5
     3 Reñaca Al… Valpa… Valparaí… Viña … 05    051    5109     663      39.1 2.75e5
     4 Felipe Ca… Valpa… Valparaí… Viña … 05    051    5109     669      37.0 2.59e5
     5 Yevide     Valpa… San Feli… San F… 05    057    5701     306      13.4 9.45e4
     6 Aguas Sal… Valpa… San Anto… San A… 05    056    5601     688      45.1 3.12e5
     7 Alto Mira… Valpa… San Anto… San A… 05    056    5601     560      47.7 3.30e5
     8 Centinela… Valpa… San Anto… San A… 05    056    5601     833     111.  7.69e5
     9 Fuerza Gu… Valpa… San Anto… Carta… 05    056    5603     342      16.5 1.14e5
    10 Vista Her… Valpa… San Anto… Carta… 05    056    5603     789      64.6 4.48e5
    # ℹ 23 more rows
    # ℹ 2 more variables: observaciones <chr>, año <chr>

El filtro anterior deja las filas donde los hogares sean mayores a 300, o bien, las hectáreas sean mayores a 100, pudiendo darse el caso de que hayan filas con hogares mayores 300 pero hectáreas menores de 100, o con menos de 300 hogares pero con más de 100 hectáreas.

Aplicando lo aprendido hasta el momento, podemos combinar un filtro con un conteo y un orden, así obtenemos un conteo de campamentos por comuna bajo un primer criterio de filtro, ordenados de mayor a menor:

``` r
datos |>
  filter(hogares > 10) |> 
  count(comuna) |> 
  arrange(desc(n))
```

    # A tibble: 177 × 2
       comuna            n
       <chr>         <int>
     1 Viña del Mar    101
     2 Valparaíso       89
     3 Antofagasta      80
     4 Copiapó          70
     5 Alto Hospicio    42
     6 Temuco           35
     7 Lota             30
     8 Talcahuano       26
     9 San Antonio      22
    10 Lampa            21
    # ℹ 167 more rows

## Crear variables

Hasta ahora, hemos explorado solamente con los datos que vienen directamente desde el archivo que cargamos. A continuación, crearemos nuevas variables a partir de los datos existentes, para potenciar nuestro análisis.

La función `mutate()` crea nuevas variables. Lo primero que se indica dentro de `mutate()` es el nombre de la nueva variable que vamos a crear, después de un signo igual (`=`), y después la operación que creará esta nueva variable.

En este primer ejemplo, crearemos la variable `prueba`, que contendrá un texto en todas las filas.

``` r
datos |>
  select(1:4, hogares) |> 
  mutate(prueba = "hola")
```

    # A tibble: 1,432 × 6
       nombre                  region     provincia   comuna        hogares prueba
       <chr>                   <chr>      <chr>       <chr>           <dbl> <chr> 
     1 Bellavista              Valparaíso Valparaíso  Valparaíso         29 hola  
     2 Buena Vista             Valparaíso Valparaíso  Valparaíso         32 hola  
     3 Los Fleteros            Valparaíso Valparaíso  Valparaíso         56 hola  
     4 Pueblo Hundido          Valparaíso Valparaíso  Valparaíso         65 hola  
     5 Villa Italia Turín      Valparaíso Valparaíso  Valparaíso         33 hola  
     6 Nueva Esperanza         Valparaíso Valparaíso  Valparaíso         17 hola  
     7 Francisco Vergara       Valparaíso Valparaíso  Valparaíso         24 hola  
     8 Manuel Rodríguez        Valparaíso Valparaíso  Valparaíso         21 hola  
     9 Sofia 35                Valparaíso Valparaíso  Valparaíso         69 hola  
    10 Las Viñas De Irene Frei Valparaíso Marga Marga Villa Alemana      32 hola  
    # ℹ 1,422 more rows

Usamos la función `paste()` para crear una nueva variable que contenga un texto, al cual le agregamos la cifra de otra variable. La operación se realizará para cada una de las filas de nuestra tabla, utilizando las cifras que corresponda a la fila en cuestión:

``` r
datos |> 
  select(nombre, hogares) |> 
  mutate(texto = paste("Numero de hogares:", hogares))
```

    # A tibble: 1,432 × 3
       nombre                  hogares texto                
       <chr>                     <dbl> <chr>                
     1 Bellavista                   29 Numero de hogares: 29
     2 Buena Vista                  32 Numero de hogares: 32
     3 Los Fleteros                 56 Numero de hogares: 56
     4 Pueblo Hundido               65 Numero de hogares: 65
     5 Villa Italia Turín           33 Numero de hogares: 33
     6 Nueva Esperanza              17 Numero de hogares: 17
     7 Francisco Vergara            24 Numero de hogares: 24
     8 Manuel Rodríguez             21 Numero de hogares: 21
     9 Sofia 35                     69 Numero de hogares: 69
    10 Las Viñas De Irene Frei      32 Numero de hogares: 32
    # ℹ 1,422 more rows

Es posible usar cualquier función que opere sobre una variable del tipo que corresponda. Por ejemplo, podemos redondear los valores de una variable numérica, y si a esta nueva variable creada le asignamos al mismo nombre de la variable original, la variable original será reemplazada por la versión nueva, con sus datos redondeados.

``` r
datos |> 
  select(nombre, where(is.numeric), -cut) |> 
  mutate(hectareas = round(hectareas, digits = 1),
         area = round(area, digits = 0))
```

    # A tibble: 1,432 × 4
       nombre                  hogares hectareas  area
       <chr>                     <dbl>     <dbl> <dbl>
     1 Bellavista                   29       1.5 10617
     2 Buena Vista                  32       1.7 11707
     3 Los Fleteros                 56       2.5 17465
     4 Pueblo Hundido               65       4.6 32261
     5 Villa Italia Turín           33       0.9  6081
     6 Nueva Esperanza              17       0.4  2802
     7 Francisco Vergara            24       2.8 19955
     8 Manuel Rodríguez             21       0.4  3103
     9 Sofia 35                     69       2.7 18819
    10 Las Viñas De Irene Frei      32       1.2  8704
    # ℹ 1,422 more rows

También podemos crear una nueva variable a partir de un cálculo matemático:

``` r
datos |> 
  select(nombre, where(is.numeric), -cut) |> 
  mutate(densidad = hectareas/hogares)
```

    # A tibble: 1,432 × 5
       nombre                  hogares hectareas   area densidad
       <chr>                     <dbl>     <dbl>  <dbl>    <dbl>
     1 Bellavista                   29     1.51  10617.   0.0522
     2 Buena Vista                  32     1.67  11707.   0.0522
     3 Los Fleteros                 56     2.49  17465.   0.0445
     4 Pueblo Hundido               65     4.60  32261.   0.0708
     5 Villa Italia Turín           33     0.867  6081.   0.0263
     6 Nueva Esperanza              17     0.399  2802.   0.0235
     7 Francisco Vergara            24     2.85  19955.   0.119 
     8 Manuel Rodríguez             21     0.443  3103.   0.0211
     9 Sofia 35                     69     2.68  18819.   0.0389
    10 Las Viñas De Irene Frei      32     1.24   8704.   0.0388
    # ℹ 1,422 more rows

Si creamos una nueva variable en base a una comparación (en este caso, que las hectáreas sean mayores a 2), entonces la nueva variable será de tipo lógico, indicando las observaciones que cumplen con la comparación con `TRUE`, y las que no con `FALSE`.

``` r
datos |> 
  select(nombre, hectareas) |> 
  mutate(prioridad = hectareas > 2)
```

    # A tibble: 1,432 × 3
       nombre                  hectareas prioridad
       <chr>                       <dbl> <lgl>    
     1 Bellavista                  1.51  FALSE    
     2 Buena Vista                 1.67  FALSE    
     3 Los Fleteros                2.49  TRUE     
     4 Pueblo Hundido              4.60  TRUE     
     5 Villa Italia Turín          0.867 FALSE    
     6 Nueva Esperanza             0.399 FALSE    
     7 Francisco Vergara           2.85  TRUE     
     8 Manuel Rodríguez            0.443 FALSE    
     9 Sofia 35                    2.68  TRUE     
    10 Las Viñas De Irene Frei     1.24  FALSE    
    # ℹ 1,422 more rows

Si lo pensamos, ésta es la misma forma mediante la cual funciona la función `filter()`: se establece una comparación, se evalúa si cada una de las filas cumple con la comparación, y finalmente se eliminan las que no cumplen (`FALSE`).

### Variables dicotómicas con `if_else()`

Siguiendo la lógica del ejemplo anterior, podemos usar una función que nos ayude a crear variables en base a si las filas cumplen o no con una o varias condiciones que definamos. A esta operación se llama *if else,* que en español sería *si se cumple, entonces esto, y si no, esto otro.*

Entonces, podemos usar `if_else()` para crear nuevas variables en base a una comparación, pero en vez de retornar verdadero o falso, puede retornar los valores que nosotros le pidamos.

*Ejemplo:*

``` r
plata <- 1000000

plata < 300000
```

    [1] FALSE

``` r
# una comparación normal retorna TRUE o FALSE
```

``` r
# pero en el ifelse, le especificamos primero la comparación,
# luego lo que queremos que retorne si la comparación es TRUE,
# y finalmente lo que queremos que retorne si es false
if_else(plata < 300000, true = "poca", false = "mucha")
```

    [1] "mucha"

``` r
# también se puede escribir obviando el "yes" y "no"
if_else(plata < 300000, "poca", "mucha")
```

    [1] "mucha"

Siguiendo el ejemplo, podemos usar la función dentro de mutate para crear nuestra nueva variable dicotómica:

``` r
datos |>
  select(nombre, hogares) |> 
  mutate(tipo = if_else(hogares > 40, 
                        true = "grande", 
                        false = "chico")
  )
```

    # A tibble: 1,432 × 3
       nombre                  hogares tipo  
       <chr>                     <dbl> <chr> 
     1 Bellavista                   29 chico 
     2 Buena Vista                  32 chico 
     3 Los Fleteros                 56 grande
     4 Pueblo Hundido               65 grande
     5 Villa Italia Turín           33 chico 
     6 Nueva Esperanza              17 chico 
     7 Francisco Vergara            24 chico 
     8 Manuel Rodríguez             21 chico 
     9 Sofia 35                     69 grande
    10 Las Viñas De Irene Frei      32 chico 
    # ℹ 1,422 more rows

*Otro ejemplo:*

``` r
datos |> 
  select(nombre, region, hectareas) |> 
  mutate(prioridad = if_else(hectareas > 2, "alta", "normal")) |> 
  count(region, prioridad)
```

    # A tibble: 31 × 3
       region                                    prioridad     n
       <chr>                                     <chr>     <int>
     1 Antofagasta                               alta         45
     2 Antofagasta                               normal       71
     3 Arica y Parinacota                        alta          8
     4 Arica y Parinacota                        normal        6
     5 Atacama                                   alta         45
     6 Atacama                                   normal       76
     7 Aysén del General Carlos Ibáñez del Campo alta          3
     8 Aysén del General Carlos Ibáñez del Campo normal        7
     9 Biobío                                    alta        128
    10 Biobío                                    normal       97
    # ℹ 21 more rows

Para los siguientes ejemplos, crearemos un nuevo dataframe en base al anterior, pero que contenga nuevas variables creadas mediante operaciones matemáticas:

``` r
datos_2 <- datos |> 
  mutate(densidad_ha = hectareas / hogares,
         area_km = area/1000,
         densidad_km = area_km / hogares)
```

### Variables más complejas con `case_when()`

La función `case_when()` es equivalente a usar varios `if_else()` seguidos, y por lo tanto nos permite crear variables más complejas, que tengan más de dos categorías. Se utiliza poniendo todas las evaluaciones junto al valor que queremos que adopten si es que estas comparaciones son `TRUE`.

Como prueba, vamos a incluir una sola comparación, para ver que le otorga el valor solo a las observaciones correspondientes, y las demás las deja vacías:

``` r
datos_2 |> 
  select(nombre, densidad_km) |> 
  mutate(categoria = case_when(densidad_km < 0.3 ~ "baja"))
```

    # A tibble: 1,432 × 3
       nombre                  densidad_km categoria
       <chr>                         <dbl> <chr>    
     1 Bellavista                    0.366 <NA>     
     2 Buena Vista                   0.366 <NA>     
     3 Los Fleteros                  0.312 <NA>     
     4 Pueblo Hundido                0.496 <NA>     
     5 Villa Italia Turín            0.184 baja     
     6 Nueva Esperanza               0.165 baja     
     7 Francisco Vergara             0.831 <NA>     
     8 Manuel Rodríguez              0.148 baja     
     9 Sofia 35                      0.273 baja     
    10 Las Viñas De Irene Frei       0.272 baja     
    # ℹ 1,422 more rows

El orden en que ponemos las comparaciones será importante, porque se ejecutan en el orden que las escribas, así que una vez que una fila adquiere un valor, la fila deja de ser evaluada en las siguientes comparaciones.

El siguiente ejemplo usa tres comparaciones para abarcar todo el rango de números de la variable `hogares`:

``` r
datos_2 |> 
  select(nombre, hogares) |> 
  mutate(tamaño = case_when(hogares > 60 ~ "grande",
                            hogares > 30 ~ "mediano",
                            hogares <= 30 ~ "chico"))
```

    # A tibble: 1,432 × 3
       nombre                  hogares tamaño 
       <chr>                     <dbl> <chr>  
     1 Bellavista                   29 chico  
     2 Buena Vista                  32 mediano
     3 Los Fleteros                 56 mediano
     4 Pueblo Hundido               65 grande 
     5 Villa Italia Turín           33 mediano
     6 Nueva Esperanza              17 chico  
     7 Francisco Vergara            24 chico  
     8 Manuel Rodríguez             21 chico  
     9 Sofia 35                     69 grande 
    10 Las Viñas De Irene Frei      32 mediano
    # ℹ 1,422 more rows

*Otro ejemplo:*

``` r
datos_2 |> 
  select(nombre, densidad_km) |> 
  mutate(categoria = case_when(densidad_km < 0.3 ~ "baja",
                               densidad_km < 0.6 ~ "media",
                               densidad_km < 0.9 ~ "alta",
                               densidad_km >= 0.9 ~ "muy alta"
  ))
```

    # A tibble: 1,432 × 3
       nombre                  densidad_km categoria
       <chr>                         <dbl> <chr>    
     1 Bellavista                    0.366 media    
     2 Buena Vista                   0.366 media    
     3 Los Fleteros                  0.312 media    
     4 Pueblo Hundido                0.496 media    
     5 Villa Italia Turín            0.184 baja     
     6 Nueva Esperanza               0.165 baja     
     7 Francisco Vergara             0.831 alta     
     8 Manuel Rodríguez              0.148 baja     
     9 Sofia 35                      0.273 baja     
    10 Las Viñas De Irene Frei       0.272 baja     
    # ℹ 1,422 more rows

En el ejemplo anterior, usamos comparaciones que proponen un valor numérico, y coinciden con los valores inferiores al valor que pusimos. Entonces, el orden de asignación de los valores para la nueva variable va de menor a mayor: de 0.3 para abajo, de 0.6 para abajo, de 0.9 para abajo. Lo importante es entender que, una vez que una observación adquiere su etiqueta, las demás comparaciones no la van a sobreescribir. Por ejemplo, si tenemos el valor 0.2, va a ser etiquetado por la comparación *"valores menores a 0.3",* porque es menor a 0.3. Pero cuando se aplique la siguiente comparación, que es *"valores menores a 0.6",* a pesar de que 0.2 también es menor a 0.6, no va a recibir una nueva etiqueta, porque ya obtuvo una en la comparación anterior (menores a 0.3).

Las comparaciones también pueden combinarse para volverse más específicas. En el siguiente ejemplo definiremos no solamente si son menores a un valor, sino que definimos un rango de valores:
- mayores a 0 y menores a 3
- mayores o iguales a 0.3 y menores a 0.6
- etc

Podemos especificar el argumento `.default` para que le otorgue a un valor a "todos los demás"; es decir, a los valores que no coincidieron con ninguna de las condiciones dadas.

``` r
datos_2 |>
  mutate(categoria = case_when(densidad_km > 0 & densidad_km < 0.3 ~ "baja",
                               densidad_km >= 0.3 & densidad_km < 0.6 ~ "media",
                               densidad_km >= 0.6 & densidad_km < 0.9 ~ "alta",
                               .default = "desconocido")) |>
  select(nombre, densidad_km, categoria) |> 
  filter(categoria != "desconocido") |>
  print(n = 15)
```

    # A tibble: 1,066 × 3
       nombre                              densidad_km categoria
       <chr>                                     <dbl> <chr>    
     1 Bellavista                                0.366 media    
     2 Buena Vista                               0.366 media    
     3 Los Fleteros                              0.312 media    
     4 Pueblo Hundido                            0.496 media    
     5 Villa Italia Turín                        0.184 baja     
     6 Nueva Esperanza                           0.165 baja     
     7 Francisco Vergara                         0.831 alta     
     8 Manuel Rodríguez                          0.148 baja     
     9 Sofia 35                                  0.273 baja     
    10 Las Viñas De Irene Frei                   0.272 baja     
    11 Lomas De Bellavista                       0.662 alta     
    12 Manzana 33                                0.414 media    
    13 Ampliación Prat-Lomas De Peñablanca       0.723 alta     
    14 Los Artesanos                             0.401 media    
    15 La Unión - Elías Lafferte                 0.465 media    
    # ℹ 1,051 more rows

Finalmente, `case_when()` nos permite crear cualquier tipo de comparación arbitraria, usando cualquier columna de nuestro dataframe; por ejemplo, en este caso vamos a etiquetar una variable sobre densidad, pero podemos condicionar cierta densidad con una región. En este ejemplo (solo con fines ilustrativos), las observaciones que son de Valparaíso *no* pueden ser categorizadas como altas:

``` r
datos_2 |>
  mutate(categoria = case_when(densidad_km > 0 & densidad_km < 0.3 ~ "baja",
                               densidad_km >= 0.3 & densidad_km < 0.6 ~ "media",
                               region != "Valparaíso" & densidad_km >= 0.6 & densidad_km < 0.9 ~ "alta")) |> 
  select(nombre, region, densidad_km, categoria)
```

    # A tibble: 1,432 × 4
       nombre                  region     densidad_km categoria
       <chr>                   <chr>            <dbl> <chr>    
     1 Bellavista              Valparaíso       0.366 media    
     2 Buena Vista             Valparaíso       0.366 media    
     3 Los Fleteros            Valparaíso       0.312 media    
     4 Pueblo Hundido          Valparaíso       0.496 media    
     5 Villa Italia Turín      Valparaíso       0.184 baja     
     6 Nueva Esperanza         Valparaíso       0.165 baja     
     7 Francisco Vergara       Valparaíso       0.831 <NA>     
     8 Manuel Rodríguez        Valparaíso       0.148 baja     
     9 Sofia 35                Valparaíso       0.273 baja     
    10 Las Viñas De Irene Frei Valparaíso       0.272 baja     
    # ℹ 1,422 more rows

## Pivotar

Creamos una pequeña tabla de conteo de casos a partir de dos variables de agrupación: la región y el tamaño.

``` r
tabla <- datos_2 |> 
  mutate(tamaño = case_when(hogares > 60 ~ "grande",
                            hogares > 30 ~ "mediano",
                            .default = "chico")) |> 
  count(region, tamaño)

tabla
```

    # A tibble: 47 × 3
       region                                    tamaño      n
       <chr>                                     <chr>   <int>
     1 Antofagasta                               chico      42
     2 Antofagasta                               grande     52
     3 Antofagasta                               mediano    22
     4 Arica y Parinacota                        chico       4
     5 Arica y Parinacota                        grande      6
     6 Arica y Parinacota                        mediano     4
     7 Atacama                                   chico      62
     8 Atacama                                   grande     29
     9 Atacama                                   mediano    30
    10 Aysén del General Carlos Ibáñez del Campo chico       7
    # ℹ 37 more rows

En esta tabla, cada fila corresponde a una observación distinta; es decir, cada fila adquiere exactamente sólo un valor posible de cada una de las variables. Al mismo tiempo, cada columna solamente corresponde a una variable específica, y cada celda de la tabla solamente aloja un valor. Por ejemplo, en la primera fila, la *región* es "Antofagasta", el *tamaño* es "chico", y `n` es *42.* A esto se le denomina *formato largo* o *Tidy,* y [es un principio básico de mantener para el análisis de datos.](https://tidyr.tidyverse.org/articles/tidy-data.html#tidy-data)

Sin embargo, al momento de compartir o publicar los datos, estas convenciones sobre ordenamiento de los datos dejan de ser prioridad. Usualmente, en las tablas destinadas para revisar o entregar resultados,
las variables numéricas que están agrupadas por otras variables (*región* y *tamaño,* en nuestro ejemplo) suelen presentarse con cada una de las categorías de agrupación en una columna distinta. Entonces, Antofagasta ya no usaría tres filas, sino una sola fila, pero habrían tres columnas que correspondían al tamaño, chico mediano y grande, cada una de esas celdas es conteniendo el valor numérico correspondiente. Entonces, terminaríamos con un DataFramed donde cada región corresponda a una fila, y en cada fila habrán tres valores, cada uno correspondiendo a la categoría de la variable tamaño correspondiente.

Para realizar esta [transformación de la estructura de los datos,](https://rstudio.github.io/cheatsheets/html/tidyr.html#reshape-data) cargaremos el paquete `{tidyr}`:

``` r
library(tidyr)
```

La operación que necesitamos realizar es pivotar la tabla a un formato ancho. Para esto, definimos que *variable* nos entregará los nombres de las nuevas columnas (en este ejemplo, el *tamaño*), y desde qué variable se sacarán los valores que se ubicarán en cada una de las columnas nuevas:

``` r
tabla_ancha <- tabla |> 
  pivot_wider(names_from = tamaño, 
              values_from = n, 
              values_fill = 0) |> 
  relocate(mediano, .after = chico)

tabla_ancha
```

    # A tibble: 16 × 4
       region                                    chico mediano grande
       <chr>                                     <int>   <int>  <int>
     1 Antofagasta                                  42      22     52
     2 Arica y Parinacota                            4       4      6
     3 Atacama                                      62      30     29
     4 Aysén del General Carlos Ibáñez del Campo     7       2      1
     5 Biobío                                      116      61     48
     6 Coquimbo                                     30      12     10
     7 La Araucanía                                 48      19      3
     8 Libertador General Bernardo O'Higgins        49       6      4
     9 Los Lagos                                    35      17     15
    10 Los Ríos                                     27       6      7
    11 Magallanes y de la Antártica Chilena          0       2      1
    12 Maule                                        22       2      1
    13 Metropolitana                                89      28     51
    14 Tarapacá                                     13      14     37
    15 Valparaíso                                  209      79     86
    16 Ñuble                                        20       3      1

De esta forma, obtenemos una tabla más compacta, que nos permite visualizar los datos de una forma más sencilla.

``` r
library(gt)

gt(tabla_ancha) |> 
  gt::tab_header(title = "Campamentos según tamaño") |>  
  cols_label(region = "Región") |> 
  tab_style(locations = cells_body(region), 
            style = cell_text(style = "italic"))
```

<div id="igplunabid" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#igplunabid table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#igplunabid thead, #igplunabid tbody, #igplunabid tfoot, #igplunabid tr, #igplunabid td, #igplunabid th {
  border-style: none;
}

#igplunabid p {
  margin: 0;
  padding: 0;
}

#igplunabid .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#igplunabid .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#igplunabid .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#igplunabid .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#igplunabid .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#igplunabid .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#igplunabid .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#igplunabid .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#igplunabid .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#igplunabid .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#igplunabid .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#igplunabid .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#igplunabid .gt_spanner_row {
  border-bottom-style: hidden;
}

#igplunabid .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#igplunabid .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#igplunabid .gt_from_md > :first-child {
  margin-top: 0;
}

#igplunabid .gt_from_md > :last-child {
  margin-bottom: 0;
}

#igplunabid .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#igplunabid .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#igplunabid .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#igplunabid .gt_row_group_first td {
  border-top-width: 2px;
}

#igplunabid .gt_row_group_first th {
  border-top-width: 2px;
}

#igplunabid .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#igplunabid .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#igplunabid .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#igplunabid .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#igplunabid .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#igplunabid .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#igplunabid .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#igplunabid .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#igplunabid .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#igplunabid .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#igplunabid .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#igplunabid .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#igplunabid .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#igplunabid .gt_left {
  text-align: left;
}

#igplunabid .gt_center {
  text-align: center;
}

#igplunabid .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#igplunabid .gt_font_normal {
  font-weight: normal;
}

#igplunabid .gt_font_bold {
  font-weight: bold;
}

#igplunabid .gt_font_italic {
  font-style: italic;
}

#igplunabid .gt_super {
  font-size: 65%;
}

#igplunabid .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#igplunabid .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#igplunabid .gt_indent_1 {
  text-indent: 5px;
}

#igplunabid .gt_indent_2 {
  text-indent: 10px;
}

#igplunabid .gt_indent_3 {
  text-indent: 15px;
}

#igplunabid .gt_indent_4 {
  text-indent: 20px;
}

#igplunabid .gt_indent_5 {
  text-indent: 25px;
}

#igplunabid .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#igplunabid div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>

| Campamentos según tamaño                  |       |         |        |
|-------------------------------------------|-------|---------|--------|
| Región                                    | chico | mediano | grande |
| Antofagasta                               | 42    | 22      | 52     |
| Arica y Parinacota                        | 4     | 4       | 6      |
| Atacama                                   | 62    | 30      | 29     |
| Aysén del General Carlos Ibáñez del Campo | 7     | 2       | 1      |
| Biobío                                    | 116   | 61      | 48     |
| Coquimbo                                  | 30    | 12      | 10     |
| La Araucanía                              | 48    | 19      | 3      |
| Libertador General Bernardo O\'Higgins    | 49    | 6       | 4      |
| Los Lagos                                 | 35    | 17      | 15     |
| Los Ríos                                  | 27    | 6       | 7      |
| Magallanes y de la Antártica Chilena      | 0     | 2       | 1      |
| Maule                                     | 22    | 2       | 1      |
| Metropolitana                             | 89    | 28      | 51     |
| Tarapacá                                  | 13    | 14      | 37     |
| Valparaíso                                | 209   | 79      | 86     |
| Ñuble                                     | 20    | 3       | 1      |

</div>

## Guardar en Excel

Guardar una tabla o dataframe de R en formato Excel es tan sencillo como utilizar la función `write_xlsx()` y entregarle el objeto y el nombre del archivo que queremos crear.

``` r
library(writexl)
write_xlsx(tabla_ancha, "tabla_campamentos.xlsx")
```

Con esto concluye este tutorial inicial para manipular datos con el paquete `{dplyr}`. En siguientes tutoriales iremos usando funciones más complejas y avanzadas! 🫣

------------------------------------------------------------------------

Si este tutorial te sirvió, por favor considera hacerme una donación! Cualquier monto me ayuda al menos a poder tomarme un cafecito 🥺

<div style = "height: 18px;">
</div>
<div>
  <div style="display: flex;
  justify-content: center;
  align-items: center;">
    <script type="text/javascript" src="https://cdnjs.buymeacoffee.com/1.0.0/button.prod.min.js" data-name="bmc-button" data-slug="bastimapache" data-color="#FFDD00" data-emoji="☕"  data-font="Cookie" data-text="Regálame un cafecito" data-outline-color="#000000" data-font-color="#000000" data-coffee-color="#ffffff" ></script>
  </div>
</div>
