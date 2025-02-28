---
title: Simplificar la geometría de los polígonos de un mapa en R
author: Bastián Olea Herrera
date: '2025-02-27'
format:
  hugo-md:
    output-file: "index"
    output-ext: "md"
slug: []
categories:
  - ''
tags:
  - mapas
  - visualización de datos
execute:
  message: false
  warning: false
  error: false
excerpt: "Un problema común al visualizar datos georeferenciados o mapas coropléticos (con colores en las zonas geográficas que se corresponden con los datos) yace en que usamos mapas que tienen geometrías o características geográficas mucho más detalladas de lo que necesitamos. Este exceso de detalle puede jugarle en contra a la visualización que estamos intentando crear, ya sea porque dificulta la interpretación, o complejiza visualmente el gráfico. En esta guía aprenderemos a simplificar mapas en R para producir visualizaciones con el nivel apropiado de detalle, y hacer más rápida la generación de mapas."
---



Un problema común al visualizar datos georeferenciados o mapas coropléticos (con colores en las zonas geográficas que se corresponden con los datos) yace en que usamos mapas que tienen geometrías o características geográficas mucho más detalladas de lo que necesitamos. Este exceso de detalle puede jugarle en contra a la visualización que estamos intentando crear, ya sea porque dificulta la interpretación, o complejiza visualmente el gráfico.

Otro problema de trabajar con mapas muy detallados es que la velocidad con la que se generan se ve impactada debido al detalle, lo que resulta inconveniente dado que al visualizar datos usualmente nos encontramos iterando decenas de veces una misma visualización hasta que se vea como queremos. 

Esto puede ocurrir cuando mapas desde Shapes u otras fuentes cuyo objetivo es representar fidedignamente los territorios; pero al visualizar datos generalmente necesitamos visualizaciones que no requieren exactitud milimétrica en sus polígonos. 

Generemos un mapa de regiones de Chile, usando las geometrías del paquete {chilemapas}:




``` r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

``` r
library(sf)
```

```
## Linking to GEOS 3.11.0, GDAL 3.5.3, PROJ 9.1.0; sf_use_s2() is TRUE
```

``` r
library(ggplot2)
library(chilemapas)
```

```
## La documentacion del paquete y ejemplos de uso se encuentran en https://pacha.dev/chilemapas/.
## Visita https://buymeacoffee.com/pacha/ si deseas donar para contribuir al desarrollo de este software.
```


``` r
# generar mapa de regiones
mapa_regiones <- chilemapas::mapa_comunas |> 
  st_set_geometry(chilemapas::mapa_comunas$geometry) |>
  select(codigo_comuna, codigo_region, geometry) |> 
  summarize(geometry = st_union(geometry), .by = codigo_region)

mapa_regiones
```

```
## Simple feature collection with 16 features and 1 field
## Geometry type: GEOMETRY
## Dimension:     XY
## Bounding box:  xmin: -109.4499 ymin: -56.52511 xmax: -66.41617 ymax: -17.49778
## Geodetic CRS:  SIRGAS 2000
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
```

``` r
mapa_regiones |> 
  ggplot() +
  aes() +
  geom_sf()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-2-1.png" width="672" />



Vemos que en la zona sur del país, el detalle del mapa es tal, que los cientos de islas se vuelven en manchas grises debido a sus bordes demasiado detallados.




``` r
mapa_regiones |> 
  ggplot() +
  aes() +
  geom_sf() +
  coord_sf(xlim = c(-80, -65),
           ylim = c(-42, -56))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-1.png" width="672" />



Podemos usar el paquete {rmapshaper} para simplificar las geometrías del mapa, bajando así el nivel de detalle de la visualización resultante:




``` r
mapa_regiones_simple <- mapa_regiones |> 
  # simplificar geometrías
  mutate(geometry = rmapshaper::ms_simplify(geometry, keep = 0.05))

mapa_regiones_simple |> 
  ggplot() +
  aes() +
  geom_sf()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-1.png" width="672" />

``` r
mapa_regiones_simple |> 
  ggplot() +
  aes() +
  geom_sf() +
  coord_sf(xlim = c(-80, -65),
           ylim = c(-42, -56))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-2.png" width="672" />


En la función `ms_simplify()`, el valor del argumento `keep` define la calidad resultante del mapa. Si el valor es menor, el mapa tendrá menos detalle.




``` r
mapa_regiones |> 
  mutate(geometry = rmapshaper::ms_simplify(geometry, keep = 0.01)) |> 
  ggplot() +
  aes() +
  geom_sf() +
  coord_sf(xlim = c(-80, -65),
           ylim = c(-42, -56))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" width="672" />



En la función `ms_simplify()`, el valor del argumento `keep` define la calidad resultante del mapa. Si el valor es menor, el mapa tendrá menos detalle.

En estos tres mapas comparamos las diferencias entre el mapa original, con detalle al `0.1`, y con detalle al `0.05`:



``` r
normal <- mapa_regiones |> 
  # mutate(geometry = rmapshaper::ms_simplify(geometry, keep = 0.1)) |>
  ggplot() +
  aes() +
  geom_sf() +
  coord_sf(xlim = c(-80, -65),
           ylim = c(-42, -56))

medio <- mapa_regiones |> 
  mutate(geometry = rmapshaper::ms_simplify(geometry, keep = 0.1)) |>
  ggplot() +
  aes() +
  geom_sf() +
  coord_sf(xlim = c(-80, -65),
           ylim = c(-42, -56))

bajo <- mapa_regiones |> 
  mutate(geometry = rmapshaper::ms_simplify(geometry, keep = 0.05)) |>
  ggplot() +
  aes() +
  geom_sf() +
  coord_sf(xlim = c(-80, -65),
           ylim = c(-42, -56))

library(patchwork)

normal + medio + bajo
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-6-1.png" width="672" />



Con respecto a la velocidad de generación de los mapas, realizamos una prueba de rendimiento que compare la velocidad de guardado de dos mapas, uno normal y uno simplificado:




``` r
bench::mark(iterations = 20, check = FALSE,
            normal = ggsave(plot = mapa_regiones |> ggplot() + geom_sf(), filename = "a.jpg"),
            simple = ggsave(plot = mapa_regiones_simple |> ggplot() + geom_sf(), filename = "b.jpg")
)
```

```
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
```

```
## Warning: Some expressions had a GC in every iteration; so filtering is
## disabled.
```

```
## # A tibble: 2 × 6
##   expression      min   median `itr/sec` mem_alloc `gc/sec`
##   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
## 1 normal        142ms  146.5ms      6.48   29.33MB     10.0
## 2 simple         73ms   77.4ms     12.8     2.48MB     10.3
```



Según la prueba, el mapa simplificado se genera aproximadamente el doble de rápido.

También podemos compara el uso de memoria de ambos objetos:




``` r
object.size(mapa_regiones) |> print(units = "auto")
```

```
## 2.1 Mb
```

``` r
object.size(mapa_regiones_simple) |> print(units = "auto")
```

```
## 178.2 Kb
```



El mapa simplificado consume un 10% de memoria con respecto al mapa original.


----

Si te interesa el tema de los mapas, en otros tutoriales hemos visto cómo [hacer mapas de Chile con R, tanto comunales como regionales](/blog/tutorial_mapa_chile/), así como también de la [zona urbana de la Región Metropolitana](/blog/tutorial_mapa_urbano/). Además aprendimos cómo agregar [características espaciales como calles y autopistas](/blog/tutorial_mapas_osm/) obtenidas desde Open Street Map. 



{{< cafecito >}}

