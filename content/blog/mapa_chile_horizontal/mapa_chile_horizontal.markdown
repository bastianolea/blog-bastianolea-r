---
title: Mapa de Chile Horizontal
author: Bastián Olea Herrera
format:
  hugo-md:
    output-file: "index"
    output-ext: "md"
date: '2025-03-03'
slug: []
categories: []
tags:
  - mapas
---


``` r
library(sf)
```

```
## Linking to GEOS 3.11.0, GDAL 3.5.3, PROJ 9.1.0; sf_use_s2() is TRUE
```

``` r
library(chilemapas)
```

```
## La documentacion del paquete y ejemplos de uso se encuentran en https://pacha.dev/chilemapas/.
## Visita https://buymeacoffee.com/pacha/ si deseas donar para contribuir al desarrollo de este software.
```

``` r
library(ggplot2)
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
# obtener mapa
mapa_region <- chilemapas::generar_regiones() |>
  # agregar etiquetas de nombres
  left_join(chilemapas::codigos_territoriales |> select(nombre_region, codigo_region) |> distinct()) |> 
  # simplificar geometrías
  mutate(geometry = rmapshaper::ms_simplify(geometry, keep = 0.05))
```

```
## Joining with `by = join_by(codigo_region)`
```

``` r
mapa_region
```

```
## Simple feature collection with 16 features and 2 fields
## Geometry type: GEOMETRY
## Dimension:     XY
## Bounding box:  xmin: -109.4499 ymin: -55.90564 xmax: -66.42766 ymax: -17.49778
## Geodetic CRS:  SIRGAS 2000
## # A tibble: 16 × 3
##    codigo_region                                          geometry nombre_region
##  * <chr>                                            <GEOMETRY [°]> <chr>        
##  1 01            POLYGON ((-69.8277 -21.43974, -69.76408 -21.4205… Tarapaca     
##  2 02            POLYGON ((-70.65729 -26.061, -70.61916 -26.061, … Antofagasta  
##  3 03            POLYGON ((-70.65729 -26.061, -70.65284 -26.13138… Atacama      
##  4 04            POLYGON ((-71.49029 -29.18023, -71.43958 -29.253… Coquimbo     
##  5 05            MULTIPOLYGON (((-71.53671 -32.17856, -71.51582 -… Valparaiso   
##  6 06            POLYGON ((-71.35858 -34.82726, -71.28045 -34.791… Libertador G…
##  7 07            POLYGON ((-72.10308 -36.13219, -72.09964 -36.125… Maule        
##  8 08            MULTIPOLYGON (((-71.64118 -38.30825, -71.63324 -… Biobio       
##  9 09            POLYGON ((-73.50881 -38.48375, -73.50329 -38.593… La Araucania 
## 10 10            MULTIPOLYGON (((-74.13783 -42.21779, -74.17136 -… Los Lagos    
## 11 11            MULTIPOLYGON (((-74.42907 -44.89151, -74.45496 -… Aysen del Ge…
## 12 12            MULTIPOLYGON (((-73.96809 -48.71665, -74.03006 -… Magallanes y…
## 13 13            POLYGON ((-70.47653 -33.86032, -70.47327 -33.862… Metropolitan…
## 14 14            MULTIPOLYGON (((-71.88244 -40.56879, -71.85858 -… Los Rios     
## 15 15            POLYGON ((-68.95687 -18.94477, -68.91604 -18.890… Arica y Pari…
## 16 16            POLYGON ((-72.88606 -36.44326, -72.80998 -36.459… Nuble
```

``` r
mapa_proyectado <- mapa_region |> 
  st_set_geometry(mapa_region$geometry)
# proyección sirgas 2000 (crs 4674)
```


``` r
mapa_proyectado |> 
  ggplot(aes()) +
  geom_sf() +
  guides(fill = guide_none()) +
  coord_sf(xlim = c(-80, -62))
```

<img src="/blog/mapa_chile_horizontal/mapa_chile_horizontal_files/figure-html/unnamed-chunk-3-1.png" width="672" />


``` r
# rotar mapa de Chile ----

# https://gist.github.com/ryanpeek/99c6935ae51429761f5f73cf3b027da2
# rotate function (see here: https://r-spatial.github.io/sf/articles/sf3.html#affine-transformations
# se multiplica la geometría por una matriz de rotación, porque como es un mapa está en espacio euclideano
# https://en.wikipedia.org/wiki/Rotation_matrix
# rotate <- function(a) matrix(c(cos(a), sin(a), -sin(a), cos(a)), 2, 2) #debiese definirse así, pero sale deformado

# 1. Reprojectar a CRS proyectado (EPSG:5361 para Chile)
mapa_proyectado <- st_transform(mapa_region, 5361)

# 2. Matriz de rotación 90° izquierda (sin escalar)
rotacion <- matrix(c(0, -1, 1, 0), 2, 2)

# 3. Aplicar rotación al mapa proyectado
mapa_rotado <- mapa_proyectado |> 
  mutate(geometry = geometry * rotacion)

# Visualizar
mapa_rotado |> 
  ggplot() +
  geom_sf() +
  scale_y_continuous(labels = scales::label_number()) +
  coord_sf(ylim = c(800000, -200000)) +
  labs(title = "Mapa de Chile horizontal",
       subtitle = "A mimir") +
  theme(plot.margin = unit(rep(.2, 4), "cm"))
```

<img src="/blog/mapa_chile_horizontal/mapa_chile_horizontal_files/figure-html/unnamed-chunk-4-1.png" width="672" />

``` r
# Reproyección (EPSG:5361): Transformamos el mapa a un sistema de coordenadas proyectadas (Lambert Conic para Chile), donde las unidades son metros.
# Matriz de rotación pura: Usamos una matriz estándar para rotación de 90° sin escalar (0.85 en tu código original causaba distorsión).
# Aplicar rotación: La rotación se realiza sobre coordenadas métricas, evitando deformaciones.
# Si el mapa aparece desplazado, calcula el centroide y rota alrededor de este usando transformaciones afines. Pero con este código, la proporción y forma del mapa se mantendrán correctas.
```

