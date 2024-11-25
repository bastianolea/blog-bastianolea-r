---
title: Crea un mapa de Chile y visualiza datos comunales y regionales con mapas en R
author: Bastián Olea Herrera
date: '2024-11-25'
draft: false
format: hugo-md
slug: []
categories:
  - tutoriales
tags:
  - mapas
  - ggplot2
  - gráficos
  - ciencias sociales
editor_options: 
  chunk_output_type: inline
execute: 
  warning: false
  message: false
excerpt: Visualizar datos geográficamente es una herramienta de comunicación y análisis de datos muy potente. En este tutorial te explico cómo obtener mapas comunales y regionales de Chile en R, y cómo crear un gráficos que visualizan variables numéricas en las comunas y regiones del país. En pocos pasos puedes transformar tus datos territoriales en visualizaciones mucho más densas e informativas.
---

Visualizar datos geográficamente es una herramienta de comunicación y análisis de datos muy potente. En este tutorial te explico cómo obtener mapas comunales y regionales de Chile en R, y cómo crear un gráficos que visualizan variables numéricas en las comunas y regiones del país. En pocos pasos puedes transformar tus datos territoriales en visualizaciones mucho más densas e informativas.

Para crear mapas sencillos, donde una variable numérica se visualice en cada unidad territorial por medio de una escala de colores, solamente se necesitan dos cosas: la información geográfica que te permite visualizar el mapa en sí mismo, y los datos que podamos corresponder con las unidades territoriales del mapa.

En este breve tutorial veremos cómo obtener los mapas, como unir los datos al mapa, y cómo generar visualizaciones de estos mapas en R.

``` r
library(chilemapas) # mapas de chile
library(dplyr) # manipulación de datos
library(ggplot2) # visualización de datos
library(scales) # utilidad para visualización de datos
library(sf) # manipulación de datos geográficos
```

## Mapa de Chile por comunas

El paquete [`{chilemapas}`](https://pacha.dev/chilemapas/), desarrollado por [Mauricio Vargas](https://pacha.dev), ofrece una colección de mapas terrestres de Chile con topología simplificada. Simplemente llamando el objeto `mapa_comunas` obtenemos un dataframe con la información geográfica de cada comuna del país.

``` r
mapa_comunas <- chilemapas::mapa_comunas

mapa_comunas
```

    ## # A tibble: 345 × 4
    ##    codigo_comuna codigo_provincia codigo_region                         geometry
    ##    <chr>         <chr>            <chr>                       <MULTIPOLYGON [°]>
    ##  1 01401         014              01            (((-68.86081 -21.28512, -68.921…
    ##  2 01403         014              01            (((-68.65113 -19.77188, -68.811…
    ##  3 01405         014              01            (((-68.65113 -19.77188, -68.635…
    ##  4 01402         014              01            (((-69.31789 -19.13651, -69.271…
    ##  5 01404         014              01            (((-69.39615 -19.06125, -69.400…
    ##  6 01107         011              01            (((-70.1095 -20.35131, -70.1243…
    ##  7 01101         011              01            (((-70.09894 -20.08504, -70.102…
    ##  8 02104         021              02            (((-68.98863 -25.38016, -68.987…
    ##  9 02101         021              02            (((-70.60654 -23.43054, -70.601…
    ## 10 02201         022              02            (((-67.94302 -22.38175, -67.955…
    ## # ℹ 335 more rows

En este dataframe, la columna `geometry` representa los polígonos de cada comuna. Esta información ya es suficiente para visualizar el mapa con R usando `{ggplot2}` y [`{sf}`, un paquete para trabajar con datos espaciales](https://r-spatial.github.io/sf/).

Para visualizar el mapa, primero usamos `sf::st_set_geometry()` para asignar la geometría al dataframe. De este modo, le indicamos a R que estos datos deben graficarse en un mapa con determinadas coordenadas e información sobre proyección.

``` r
grafico_comunas <- mapa_comunas |> 
  st_set_geometry(mapa_comunas$geometry) |> # asignar geometría
  ggplot() + # gráfico
  geom_sf() # capa geométrica

grafico_comunas +
  theme_classic()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-1.png" width="672" />

Dado que Chile tiene islas muy alejadas del territorio continental, como Rapa Nui o Juan Fernández, el mapa queda con mucho espacio en blanco. Podemos recortar las coordenadas de la longitud del mapa (el eje *x* del gráfico) para que el mapa solamente abarque Chile continental:

``` r
grafico_comunas + 
  coord_sf(xlim = c(-77, -65)) +
  theme_classic()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-1.png" width="288" />

## Mapa regional de Chile

Para generar un mapa de regiones, debemos crear las regiones. Esto no es complicado si pensamos que, en el fondo, las regiones son simplemente la unión de las comunas que las componen. El paquete `{sf}` simplifica muchísimo el trabajo con datos geográficos, en este caso la unión de distintos polígonos en uno solo.

Agrupamos las filas del dataframe por la variable `codigo_region`, para que todas las comunas que pertenecen a la misma región estén agrupadas, y usamos `summarize()` junto a la función `sf::st_union()` para que los polígonos de las comunas dentro de cada región se combinen, obteniendo polígonos regionales:

``` r
mapa_regiones <- mapa_comunas |> 
  group_by(codigo_region) |> 
  summarize(geometry = st_union(geometry)) # resumir los datos agrupados uniéndolos

mapa_regiones
```

    ## # A tibble: 16 × 2
    ##    codigo_region                                                        geometry
    ##    <chr>                                                          <GEOMETRY [°]>
    ##  1 01            POLYGON ((-69.93023 -21.4246, -69.92376 -21.42622, -69.91932 -…
    ##  2 02            MULTIPOLYGON (((-68.0676 -24.32856, -67.91698 -24.26902, -67.8…
    ##  3 03            MULTIPOLYGON (((-71.58497 -29.02456, -71.58844 -29.02838, -71.…
    ##  4 04            MULTIPOLYGON (((-70.54551 -31.30742, -70.53877 -31.30074, -70.…
    ##  5 05            MULTIPOLYGON (((-71.33832 -33.45237, -71.33763 -33.44836, -71.…
    ##  6 06            POLYGON ((-71.5477 -34.87458, -71.54211 -34.87581, -71.53566 -…
    ##  7 07            POLYGON ((-70.41724 -35.63022, -70.41108 -35.6302, -70.40146 -…
    ##  8 08            MULTIPOLYGON (((-73.53466 -36.97378, -73.53245 -36.97829, -73.…
    ##  9 09            MULTIPOLYGON (((-73.35306 -38.73343, -73.35396 -38.72799, -73.…
    ## 10 10            MULTIPOLYGON (((-73.1691 -41.87755, -73.16135 -41.87781, -73.1…
    ## 11 11            MULTIPOLYGON (((-75.41754 -48.73857, -75.43249 -48.74372, -75.…
    ## 12 12            MULTIPOLYGON (((-70.35563 -52.94478, -70.34688 -52.93971, -70.…
    ## 13 13            POLYGON ((-70.47405 -33.8624, -70.47327 -33.86269, -70.46068 -…
    ## 14 14            MULTIPOLYGON (((-73.39503 -39.88698, -73.39672 -39.89339, -73.…
    ## 15 15            POLYGON ((-69.07223 -19.02723, -69.06394 -19.02607, -69.04748 …
    ## 16 16            POLYGON ((-72.38553 -36.91169, -72.37685 -36.91617, -72.37034 …

Obtenemos un dataframe con una fila por región, dado que las comunas fueron unidas en polígonos regionales. La columna `geometry` ahora contiene la unión de las comunas que hicimos con la función `st_union()`. Podemos visualizar este nuevo dataframe regional usando `{ggplot2}` y `{sf}`, igual que en el paso anterior:

``` r
grafico_regiones <- mapa_regiones |> 
  st_set_geometry(mapa_regiones$geometry) |> # especificar la geometría del mapa
  ggplot() + # graficar
  geom_sf() + # capa geográfica
  coord_sf(xlim = c(-77, -65)) # recortar coordenadas

grafico_regiones +
  theme_classic()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-6-1.png" width="288" />

Ahora que tenemos nuestros mapas por comunas y por regiones, la idea es poder utilizarlos para visualizar datos en ellos.

## Visualizar datos en el mapa

Para visualizar los datos en un mapa, aplicaremos colores a los distintos polígonos de nuestro mapa, ya sean comunas o regiones. La intensidad del color, o su posición dentro de la escala de color elegida, representará el valor de la variable numérica que queremos visualizar.

La idea de fondo para entender la visualización de datos geográficos por polígonos es entender que los mapas que obtuvimos contienen en cada fila un polígono (la información geográfica para dibujar la comuna o región), y además, en cada fila contienen información que identifica al polígono correspondiente. En nuestro caso, la información de los polígonos corresponde al *código único territorial* de las comunas, y el código de regiones en el caso de las regiones. Éstos son códigos numéricos que identifican cada unidad territorial del país.

La idea es poder agregarle datos a nuestro mapa, de manera que las filas que representan unidades territoriales tengan también columnas con datos sobre dichas unidades territoriales.

Entonces, deberíamos tener nuestro dataframe con el mapa, y otro dataframe donde tengamos los datos que queremos adjuntar al mapa. Si tenemos un mapa de comunas, tenemos que tener los datos por comuna que queremos agregarle al mapa.

### Datos comunales

#### Obtener datos por web scraping

Para visualizar un mapa de datos comunales, primero obtendremos datos comunales desde Wikipedia. Usamos el paquete para hacer un web scraping y obtener una [tabla de datos de las comunas del país.](https://es.wikipedia.org/wiki/Anexo:Comunas_de_Chile)

``` r
library(rvest)

# dirección de wikipedia con tabla de comunas de Chile
url <- "https://es.wikipedia.org/wiki/Anexo:Comunas_de_Chile"

# obtener tabla con datos de comunas con web scraping
tabla <- session(url) |> 
  read_html() |> 
  html_table(convert = FALSE)

tabla[[1]]
```

    ## # A tibble: 346 × 12
    ##    CUT (Código Único Territori…¹ Nombre ``    Provincia Región `Superficie(km²)`
    ##    <chr>                         <chr>  <chr> <chr>     <chr>  <chr>            
    ##  1 15101                         Arica  ""    Arica     Arica… 4.799,4          
    ##  2 15102                         Camar… ""    Arica     Arica… 3.927            
    ##  3 15201                         Putre  ""    Parinaco… Arica… 5.902,5          
    ##  4 15202                         Gener… ""    Parinaco… Arica… 2.244,4          
    ##  5 01101                         Iquiq… ""    Iquique   Tarap… 2.242,1          
    ##  6 01107                         Alto … ""    Iquique   Tarap… 572.9            
    ##  7 01401                         Pozo … ""    Tamarugal Tarap… 13.765,8         
    ##  8 01402                         Camiña ""    Tamarugal Tarap… 2.200,2          
    ##  9 01403                         Colch… ""    Tamarugal Tarap… 4.015,6          
    ## 10 01404                         Huara  ""    Tamarugal Tarap… 10.474,6         
    ## # ℹ 336 more rows
    ## # ℹ abbreviated name: ¹​`CUT (Código Único Territorial)`
    ## # ℹ 6 more variables: Población2020 <chr>, `Densidad(hab./km²)` <chr>,
    ## #   `IDH 2005` <chr>, `IDH 2005` <chr>, Latitud <chr>, Longitud <chr>

Luego obtener los datos, realizamos una pequeña limpieza. Limpiamos los nombres de las variables, seleccionamos las variables que nos interesan, y luego las convertimos apropiadamente a valores numéricos, donde tenemos que eliminar los separadores de miles, y transformar los separadores de decimales a puntos.

``` r
library(janitor)
```

    ## 
    ## Attaching package: 'janitor'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     chisq.test, fisher.test

``` r
library(stringr)

# limpiar datos
datos_comunas <- tabla[[1]] |> 
  clean_names() |> 
  # seleccionar y renombrar columnas
  select(codigo_comuna = cut_codigo_unico_territorial,
         nombre, region, superficie_km2,
         poblacion = poblacion2020) |> 
  # eliminar espacios de la columna de población
  mutate(poblacion = str_remove_all(poblacion, " "),
         poblacion = as.numeric(poblacion)) |> 
  # eliminar los separadores de miles
  mutate(superficie_km2 = str_remove_all(superficie_km2, "\\."),
         # convertir comas a puntos
         superficie_km2 = str_replace(superficie_km2, ",", "."),
         superficie_km2 = as.numeric(superficie_km2))

datos_comunas
```

    ## # A tibble: 346 × 5
    ##    codigo_comuna nombre        region             superficie_km2 poblacion
    ##    <chr>         <chr>         <chr>                       <dbl>     <dbl>
    ##  1 15101         Arica         Arica y Parinacota          4799.    247552
    ##  2 15102         Camarones     Arica y Parinacota          3927       1233
    ##  3 15201         Putre         Arica y Parinacota          5902.      2515
    ##  4 15202         General Lagos Arica y Parinacota          2244.       810
    ##  5 01101         Iquique       Tarapacá                    2242.    223463
    ##  6 01107         Alto Hospicio Tarapacá                    5729     129999
    ##  7 01401         Pozo Almonte  Tarapacá                   13766.     17395
    ##  8 01402         Camiña        Tarapacá                    2200.      1375
    ##  9 01403         Colchane      Tarapacá                    4016.      1583
    ## 10 01404         Huara         Tarapacá                   10475.      3000
    ## # ℹ 336 more rows

Ahora que tenemos una tabla de datos que contiene la columna `codigo_comuna` con el código único territorial de las comunas, podemos unirla al mapa de comunas.

#### Agregar datos a los mapas con `left_join()`

Esta operación de unir dos tablas de datos diferentes, pero que coinciden en una columna en común, se realiza con la función `left_join()`. El principio de `left_join()` es que tenemos dos tablas de datos, y ambas tablas de datos tienen una misma columna, que poseen los mismos valores (en nuestro caso, una columna con las comunas o los códigos únicos territoriales de las comunas). Entonces, ambas tablas se van a unir según la correspondencias de estas columnas en común.

*Ejemplo:*

``` r
tabla_a <- tribble(~animal,   ~favorito, 
                   "gato",    "pescado", 
                   "mapache", "basura",
                   "perro",   "carne")

tabla_b <- tribble(~animal,   ~belleza, ~inteligencia, ~carisma,
                   "gato",    8,        6,             5,
                   "perro",   5,        2,             8,
                   "mapache", 10,       7,             2)

left_join(tabla_a, 
          tabla_b, 
          by = "animal")
```

    ## # A tibble: 3 × 5
    ##   animal  favorito belleza inteligencia carisma
    ##   <chr>   <chr>      <dbl>        <dbl>   <dbl>
    ## 1 gato    pescado        8            6       5
    ## 2 mapache basura        10            7       2
    ## 3 perro   carne          5            2       8

En el ejemplo, tenemos dos tablas, donde las dos tienen una misma columna con los mismos datos, y otras columnas con datos distintos. Usando `left_join()` podemos unir ambas tablas de datos a partir de la columna que tienen en común. Como resultado obtenemos una nueva tabla que tiene todas las columnas.

------------------------------------------------------------------------

Procedemos a unir los datos con el mapa usando `left_join()`, especificando en el argumento `by` que la unión sea a partir de la columna `codigo_comuna`.

``` r
mapa_comunas_2 <- mapa_comunas |> 
  # adjuntar datos al mapa, coincidiendo por columna de código de comunas
  left_join(datos_comunas,
            by = join_by(codigo_comuna)) |> 
  relocate(geometry, .after = 0) # tirar geometría al final

mapa_comunas_2
```

    ## # A tibble: 345 × 8
    ##    codigo_comuna codigo_provincia codigo_region nombre     region superficie_km2
    ##    <chr>         <chr>            <chr>         <chr>      <chr>           <dbl>
    ##  1 01401         014              01            Pozo Almo… Tarap…         13766.
    ##  2 01403         014              01            Colchane   Tarap…          4016.
    ##  3 01405         014              01            Pica       Tarap…          8934.
    ##  4 01402         014              01            Camiña     Tarap…          2200.
    ##  5 01404         014              01            Huara      Tarap…         10475.
    ##  6 01107         011              01            Alto Hosp… Tarap…          5729 
    ##  7 01101         011              01            Iquique    Tarap…          2242.
    ##  8 02104         021              02            Taltal     Antof…         20405.
    ##  9 02101         021              02            Antofagas… Antof…         30718.
    ## 10 02201         022              02            Calama     Antof…         15597.
    ## # ℹ 335 more rows
    ## # ℹ 2 more variables: poblacion <dbl>, geometry <MULTIPOLYGON [°]>

Como resultado, tenemos un nuevo dataframe que además de tener los datos geográficos de las comunas, también tiene nuevas columnas con datos que podemos visualizar.

#### Visualizar datos comunales

Para visualizar datos comunales en un mapa, especificamos la columna de geometría que contiene la información geográfica, y creamos un gráfico de `{ggplot2}`. En este gráfico, especificamos que el relleno de los polígonos (`fill`) se haga a partir de una de las variables numéricas.

Usamos la función `geom_sf()` para agregar una capa de geometría a nuestro gráfico que contenga los polígonos territoriales de las comunas. Luego, definimos un tema, una paleta de colores, y corregimos la escala del eje horizontal.

``` r
mapa_comunas_2 |> 
  st_set_geometry(mapa_comunas_2$geometry) |> # asignar geometría
  ggplot() + # gráfico
  aes(fill = poblacion) +
  geom_sf(linewidth = 0) + # capa geométrica
  theme_classic() +
  scale_fill_distiller(type = "seq", palette = 12, 
                       labels = label_comma(big.mark = ".")) + # colores
  scale_x_continuous(breaks = seq(-76, -65, length.out = 3) |> floor()) + # escala x
  coord_sf(xlim = c(-77, -65)) + # recortar coordenadas
  theme(legend.key.width = unit(3, "mm"))
```

    ## Warning in prettyNum(.Internal(format(x, trim, digits, nsmall, width, 3L, :
    ## 'big.mark' and 'decimal.mark' are both '.', which could be confusing

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-11-1.png" width="288" />

Como resultado obtenemos un mapa coroplético, o mapa de coropletas, que es un mapa donde cada región o polígono está relleno de un color que representa un valor en una escala de una variable.

Acá hacemos otro mapa, usando el mismo código y simplemente cambiando la variable de relleno de los polígonos territoriales:

``` r
mapa_comunas_2 |> 
  st_set_geometry(mapa_comunas_2$geometry) |>
  ggplot() +
  aes(fill = superficie_km2) + # variable de relleno
  geom_sf(linewidth = 0) +
  theme_classic() +
  scale_fill_distiller(type = "seq", palette = 11,
                       labels = label_comma(big.mark = ".")) + 
  scale_x_continuous(breaks = seq(-76, -65, length.out = 3) |> floor()) +
  coord_sf(xlim = c(-77, -65)) + 
  theme(legend.key.width = unit(3, "mm"))
```

    ## Warning in prettyNum(.Internal(format(x, trim, digits, nsmall, width, 3L, :
    ## 'big.mark' and 'decimal.mark' are both '.', which could be confusing

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-12-1.png" width="288" />

#### Mapa de una sola región, por comunas

Si queremos visualizar una sola región del país, subdividida por comunas, tan sencillo como agregar un filtro a los datos que filtre las filas que pertenecen a la región que nos interesa. En este caso, vamos a visualizar la población por comunas de la región del Libertador General Bernardo O’Higgins:

``` r
# filtrar datos
mapa_comunas_filtro <- mapa_comunas_2 |> 
  filter(codigo_region == "06")

# mapa
mapa_comunas_filtro |> 
  st_set_geometry(mapa_comunas_filtro$geometry) |>
  ggplot() +
  aes(fill = poblacion) +
  geom_sf(linewidth = 0.12, color = "white") +
  geom_sf_text(aes(label = comma(poblacion, big.mark = ".")), 
               size = 2, color = "white", check_overlap = T) +
  theme_classic() +
  scale_fill_distiller(type = "seq", palette = 12,
                       labels = label_comma(big.mark = ".")) + 
  theme(legend.key.width = unit(3, "mm")) +
  theme(axis.title = element_blank())
```

    ## Warning in prettyNum(.Internal(format(x, trim, digits, nsmall, width, 3L, :
    ## 'big.mark' and 'decimal.mark' are both '.', which could be confusing

    ## Warning in st_point_on_surface.sfc(sf::st_zm(x)): st_point_on_surface may not
    ## give correct results for longitude/latitude data

    ## Warning in prettyNum(.Internal(format(x, trim, digits, nsmall, width, 3L, :
    ## 'big.mark' and 'decimal.mark' are both '.', which could be confusing

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-13-1.png" width="576" />

En este caso, agregamos también la función `geom_sf_text()` para agregar una capa nuestro gráfico que contiene las cifras para cada comuna. Hay que tener en consideración que poner números o textos sobre mapas suele ser complejo, porque el mapa ya es denso visualmente, y agregarle texto puede hacer que se vuelva ilegible. Hay que tener especial cuidado en resolver situaciones como textos que pasan por encima de bordes en el mapa, que se ubican incorrectamente dentro de los polígonos, o que se sobreponen uno sobre otros debido a que los polígonos se ven muy pequeños dentro del mapa.

------------------------------------------------------------------------

### Datos regionales

#### Obtener datos por web scraping

Para hacer el ejemplo de visualizar datos a nivel regional, nuevamente obtendremos datos a esta escala usando web scraping. Obtendremos una tabla del Producto Interno Bruto regional desde el [sitio web de el Banco Central de Chile.](https://si3.bcentral.cl/Siete/ES/Siete/Cuadro/CAP_CCNN/MN_CCNN76/CCNN2018_PIB_REGIONAL_N/637899740344107786)

``` r
library(rvest)

# dirección del sitio del banco central
url <- "https://si3.bcentral.cl/Siete/ES/Siete/Cuadro/CAP_CCNN/MN_CCNN76/CCNN2018_PIB_REGIONAL_N/637899740344107786"

# obtener tabla con datos de comunas con web scraping
tabla_pib <- session(url) |> 
  read_html() |> 
  html_table(convert = FALSE)
```

Limpiamos los datos seleccionando las columnas que necesitamos, transformando la columna a tipo numérico, y filtrando las filas para quedar solamente con las que corresponden a las regiones de Chile:

``` r
datos_regiones <- tabla_pib [[1]] |> 
  janitor::clean_names() |> 
  select(region = serie, pib = x2023) |> 
  mutate(pib = str_remove_all(pib, "\\."),
         pib = as.numeric(pib)) |> 
  filter(str_detect(region, "Región"))

datos_regiones
```

    ## # A tibble: 16 × 2
    ##    region                                                 pib
    ##    <chr>                                                <dbl>
    ##  1 Región de Arica y Parinacota                          2169
    ##  2 Región de Tarapacá                                    7892
    ##  3 Región de Antofagasta                                31290
    ##  4 Región de Atacama                                     6004
    ##  5 Región de Coquimbo                                    9174
    ##  6 Región de Valparaíso                                 20275
    ##  7 Región Metropolitana de Santiago                    109143
    ##  8 Región del Libertador General Bernardo OHiggins      11910
    ##  9 Región del Maule                                     10348
    ## 10 Región de Ñuble                                       4106
    ## 11 Región del Biobío                                    16731
    ## 12 Región de La Araucanía                                7743
    ## 13 Región de Los Ríos                                    3561
    ## 14 Región de Los Lagos                                   9432
    ## 15 Región de Aysén del General Carlos Ibáñez del Campo   1573
    ## 16 Región de Magallanes y de la Antártica Chilena        2490

#### Crear columna de códigos regionales

Los datos que obtuvimos no contienen una variable con el código único territorial de las regiones, dado que es un dato que está en desuso desde la promulgación de una ley en 2018 que prohíbe el uso de los números en comunicaciones públicas. Sin embargo, en muchas base de datos oficiales se sigue usando la numeración de las regiones, principalmente para evitar problemas de diferencias en los nombres de las regiones, por ejemplo, si contienen o no las palabras *Región de* o *Región del* para cada región, si contienen tildes o no, si contienen abreviaciones o no, si contienen símbolos como *eñes* o apóstrofes, etc. Todos estos problemas son resueltos por el uso de identificador numérico de las regiones.

Como el mapa que obtuvimos con el paquete `{chilemapas}` utiliza el código regional, en el dato frente de nuestros datos crearemos una columna con los mismos códigos regionales, asignados a cada región a partir de la coincidencia con los textos. Por ejemplo, si el texto del nombre de la región contiene la palabra *Arica*, se le asigna el código `15`. Esta forma de asignar los códigos regionales puede ser inexacta, pero es muy sencillo confirmar si es que la asignación de códigos funciona correctamente, y también siempre es posible utilizar [expresiones regulares en `{stringr}`](https://stringr.tidyverse.org/articles/regular-expressions.html) para hacer coincidencias más flexibles, como por ejemplo, coincidir una palabra con un código sin importar si la palabra tiene o no tilde, o está mal escrita.

``` r
datos_regiones_2 <- datos_regiones |> 
  mutate(codigo_region = case_when(
    str_detect(region, "Arica") ~ 15,
    str_detect(region, "Tarapacá") ~ 1,
    str_detect(region, "Antofagasta") ~ 2,
    str_detect(region, "Atacama") ~ 3,
    str_detect(region, "Coquimbo") ~ 4,
    str_detect(region, "Valparaíso") ~ 5,
    str_detect(region, "Metropolitana") ~ 13,
    str_detect(region, "Libertador General") ~ 6,
    str_detect(region, "Maule") ~ 7,
    str_detect(region, "Ñuble") ~ 16,
    str_detect(region, "Biobío") ~ 8,
    str_detect(region, "Araucanía") ~ 9,
    str_detect(region, "Los Ríos") ~ 14,
    str_detect(region, "Los Lagos") ~ 10,
    str_detect(region, "Aysén") ~ 11,
    str_detect(region, "Magallanes") ~ 12
  )) |> 
  rename(nombre_region = region)
```

#### Unir datos con mapa

Luego de crear la variable de códigos regionales, podemos hacer la unión entre ambas tablas de datos, mapas y datos regionales, usando `left_join()`:

``` r
mapa_regiones_2 <- mapa_regiones |> 
  mutate(codigo_region = as.numeric(codigo_region)) |> 
  left_join(datos_regiones_2,
            by = join_by(codigo_region)) |> 
  relocate(geometry, .after = 0) # tirar columna al final

mapa_regiones_2
```

    ## # A tibble: 16 × 4
    ##    codigo_region nombre_region                     pib                  geometry
    ##            <dbl> <chr>                           <dbl>            <GEOMETRY [°]>
    ##  1             1 Región de Tarapacá               7892 POLYGON ((-69.93023 -21.…
    ##  2             2 Región de Antofagasta           31290 MULTIPOLYGON (((-68.0676…
    ##  3             3 Región de Atacama                6004 MULTIPOLYGON (((-71.5849…
    ##  4             4 Región de Coquimbo               9174 MULTIPOLYGON (((-70.5455…
    ##  5             5 Región de Valparaíso            20275 MULTIPOLYGON (((-71.3383…
    ##  6             6 Región del Libertador General…  11910 POLYGON ((-71.5477 -34.8…
    ##  7             7 Región del Maule                10348 POLYGON ((-70.41724 -35.…
    ##  8             8 Región del Biobío               16731 MULTIPOLYGON (((-73.5346…
    ##  9             9 Región de La Araucanía           7743 MULTIPOLYGON (((-73.3530…
    ## 10            10 Región de Los Lagos              9432 MULTIPOLYGON (((-73.1691…
    ## 11            11 Región de Aysén del General C…   1573 MULTIPOLYGON (((-75.4175…
    ## 12            12 Región de Magallanes y de la …   2490 MULTIPOLYGON (((-70.3556…
    ## 13            13 Región Metropolitana de Santi… 109143 POLYGON ((-70.47405 -33.…
    ## 14            14 Región de Los Ríos               3561 MULTIPOLYGON (((-73.3950…
    ## 15            15 Región de Arica y Parinacota     2169 POLYGON ((-69.07223 -19.…
    ## 16            16 Región de Ñuble                  4106 POLYGON ((-72.38553 -36.…

#### Visualizar datos regionales

Finalmente, visualizamos los datos en un mapa regional de la misma forma que lo hicimos con los mapas comunales. Esta vez, el mapa y los datos vienen en una fila por región, con la variable `geometry` que conteniendo la geometría del polígono regional. Por tanto, el código es exactamente el mismo, y solamente cambia el dataframe que usamos para generar el gráfico:

``` r
mapa_regiones_2 |> 
  st_set_geometry(mapa_regiones_2$geometry) |> # asignar geometría
  ggplot() + # gráfico
  aes(fill = pib) +
  geom_sf(linewidth = 0.12, color = "white") + # capa geométrica
  theme_classic() +
  scale_fill_distiller(type = "seq", palette = 18,
                       labels = label_comma(big.mark = ".")) +
  scale_x_continuous(breaks = seq(-76, -65, length.out = 3) |> floor()) +
  coord_sf(expand = F, xlim = c(-77, -65)) + # recortar coordenadas
  theme(legend.key.width = unit(3, "mm"))
```

    ## Warning in prettyNum(.Internal(format(x, trim, digits, nsmall, width, 3L, :
    ## 'big.mark' and 'decimal.mark' are both '.', which could be confusing

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-18-1.png" width="288" />

------------------------------------------------------------------------

Visualizar datos geográficamente es una herramienta de comunicación y análisis de datos muy potente. Personalmente, encuentro que el potencial de la visualización de datos en mapas radica mucho más allá de simplemente mapear una variable a un territorio, sino a crear el incentivo para que la persona que ve el mapa analice el mapa en relación a todo el conjunto de conocimientos que tenemos acerca del espacio que habitamos, sus características sociales, y las desigualdades distribuidas en el territorio.

------------------------------------------------------------------------

Si este tutorial te sirvió, por favor considera hacerme una pequeña donación para poder tomarme un cafecito mientras escribo el siguiente tutorial 🥺

<div style = "height: 18px;">
</div>
<div>
  <div style="display: flex;
  justify-content: center;
  align-items: center;">
    <script type="text/javascript" src="https://cdnjs.buymeacoffee.com/1.0.0/button.prod.min.js" data-name="bmc-button" data-slug="bastimapache" data-color="#FFDD00" data-emoji="☕"  data-font="Cookie" data-text="Regálame un cafecito" data-outline-color="#000000" data-font-color="#000000" data-coffee-color="#ffffff" ></script>
  </div>
