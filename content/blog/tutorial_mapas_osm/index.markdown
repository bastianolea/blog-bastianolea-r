---
title: "Tutorial: Mapa en `{ggplot2}` con calles desde Open Street Map"
author: "Bastián Olea Herrera"
date: 2024-09-03
categories: ['Tutoriales']
tags: ['mapas', 'chile', 'gráficos']
format: hugo-md
lang: es
---



En este tutorial crearemos un mapa de una región de Chile, y sobre el polígono geográfico aplicaremos otros elementos geográficos como calles, avenidas y carreteras, obtenidos desde Open Street Map (proveedor de mapas online abierto y comunitario). 

Esto puede servir para crear visualizaciones de datos espaciales minimalistas que de todos modos entreguen elementos urbanos de referencia para que les usuaries puedan ubicarse mejor espacialmente.

Usaremos `{dplyr}` para manipular los datos, el paquete `{ggplot2}` para visualización de datos, `{sf}` para tratamiento de elementos espaciales, `{rnaturalearth}` para obtener mapas de cualquier país o región del mundo, y `{osmdata}` para obtener datos estaciales desde Open Street Map (OSM) por medio de su API pública.


### Cargar paquetes




``` r
library(dplyr) #manipulación de datos
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
library(ggplot2) #gráficos
library(sf) #elementos espaciales
```

```
## Linking to GEOS 3.11.0, GDAL 3.5.3, PROJ 9.1.0; sf_use_s2() is TRUE
```

``` r
library(rnaturalearth) #mapas del mundo
library(osmdata) #datos open street map
```

```
## Data (c) OpenStreetMap contributors, ODbL 1.0. https://www.openstreetmap.org/copyright
```



## Obtener mapa de país y de región

El primer paso es obtener un mapa de Chile, a nivel de regiones, usando la función `ne_states()` del paquete `{rnaturalearth}`. Luego filtramos el dataframe resultante para enfocarnos en una sola región del país.




``` r
# obtener mapa pero a nivel de regiones
mapa_1 <- rnaturalearth::ne_states(country = "Chile") |> 
    select(name, name_es, iso_3166_2, code_hasc, geometry)

mapa_2 <- mapa_1 |> 
    filter(name == "Los Lagos")

mapa_2
```

```
## Simple feature collection with 1 feature and 4 fields
## Geometry type: MULTIPOLYGON
## Dimension:     XY
## Bounding box:  xmin: -74.40722 ymin: -44.045 xmax: -71.65926 ymax: -40.27304
## Geodetic CRS:  WGS 84
##        name   name_es iso_3166_2 code_hasc                       geometry
## 1 Los Lagos Los Lagos      CL-LL     CL.LG MULTIPOLYGON (((-71.76926 -...
```



Previsualizamos la región obtenida usando `{ggplot2}`:




``` r
mapa_2 |> 
    ggplot() +
    geom_sf(linewidth = .4,
            color = "grey80", fill = "grey95") +
    theme_classic()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-1.png" width="672" />



Luego realizamos el primer paso para obtener los datos desde Open Street Map, que es definir las coordenadas de la caja delimitadora o _bounding box_ del lugar del que vamos a solicitar datos. Por ejemplo, una ciudad específica. Si bien esto se puede hacer con la función `osmdata::getbb()`, los resultados no siempre coinciden con lo que esperamos (la región o ciudad puede salir más recortada de lo esperado), por lo que preferimos usar directamente la caja del mapa que queremos visualizar, usando `sf::st_bbox()`.




``` r
# obtener perímetro o área abarcada por el mapa
caja <- mapa_2 |> st_bbox()

# opcionalmente, se podría hacer con el nombre del lugar
# area <- getbb("Región de Los Lagos, Chile")

caja
```

```
##      xmin      ymin      xmax      ymax 
## -74.40722 -44.04500 -71.65926 -40.27304
```



## Obtener datos geográficos desde Open Street Map

Teniendo estas coordenadas, se solicitan los datos haciendo un _query_ a la API _Overpass_ de OSM. En esta solicitud se especifica la característica del mapa que se va a obtener, y sus valores; en este caso, queremos obtener las calles de una región, por lo que la _feature_ corresponde a _highway._ Dividimos la query en varias partes, para tener en objetos separados las calles de distintos tamaños (a grandes rasgos: autopistas y avenidas, calles secundarias, y calles interiores).

Considerar que cada query puede tomar un tiempo, dependiendo de la cantidad de datos, y que OSM es un proyecto soportado por voluntarios, por lo que se recomienda no abusar de la API (hacer la mínima cantidad de solicitudes, no hacer muchas solicitudes seguidas, etc.)




``` r
# obtener calles dentro de la caja
calles_grandes <- caja |> 
    opq(timeout = 500) |> 
    add_osm_feature(key = "highway", 
                    value = c("motorway", "primary", "motorway_link", "primary_link")) |> 
    osmdata_sf()

calles_medianas <- caja |> 
    opq(timeout = 500) |> 
    add_osm_feature(key = "highway", 
                    value = c("secondary", "tertiary", "secondary_link", "tertiary_link")) |> 
    osmdata_sf()

calles_chicas <- caja |>
    opq(timeout = 500) |>
    add_osm_feature(key = "highway",
                    value = c("residential", "living_street",
                              "unclassified", "service", "footway")) |>
    osmdata_sf()

calles_grandes
```

```
## Object of class 'osmdata' with:
##                  $bbox : -44.0449981164699,-74.4072159499999,-40.2730445289999,-71.6592646899999
##         $overpass_call : The call submitted to the overpass API
##                  $meta : metadata including timestamp and version numbers
##            $osm_points : 'sf' Simple Features Collection with 34928 points
##             $osm_lines : 'sf' Simple Features Collection with 3580 linestrings
##          $osm_polygons : 'sf' Simple Features Collection with 0 polygons
##        $osm_multilines : NULL
##     $osm_multipolygons : NULL
```



Habiendo obtenido los datos geográficos desde OSM, recibimos objetos que contienen los elementos espaciales. Extraemos las líneas de cada uno de los objetos, para quedarnos sólo con las calles. Opcionalmente, podemos recortar los elementos espaciales obtenidos con la figura del mapa, usando el mapa como figura de recorte para que las líneas de las calles no se salgan de los márgenes del mapa.




``` r
# extraer toda la geometría
calles_grandes_a <- calles_grandes$osm_lines
calles_medianas_a <- calles_medianas$osm_lines
calles_chicas_a <- calles_chicas$osm_lines

# recortar geometría para que calce dentro del polígono del mapa
calles_grandes_b <- st_intersection(calles_grandes$osm_lines, mapa_2)
calles_medianas_b <- st_intersection(calles_medianas$osm_lines, mapa_2)
calles_chicas_b <- st_intersection(calles_chicas$osm_lines, mapa_2)
```



## Visualizar mapa con calles

Finalmente, podemos aplicar las capas obtenidas a nuestro gráfico de `{ggplot2}`. Podemos ajustar la apariencia de cada tipo de calle por separado dado que las ubicamos en capas distintas.




``` r
    ggplot() +
    # capa del país entero (como fondo)
    geom_sf(data = mapa_1, 
            linewidth = .4,
            color = "grey95", fill = "grey98") +
    # capa del mapa de la región
    geom_sf(data = mapa_2,
            linewidth = .4, 
            color = "grey80", fill = "grey95") +
    # capas osm
    geom_sf(data = calles_medianas_b, 
            linewidth = .3, alpha = .3) +
    geom_sf(data = calles_grandes_b, 
            linewidth = .4, alpha = .3) +
    # recortar vista
    coord_sf(xlim = caja[c(1, 3)],
             ylim = c(-42.4, -40.3)) +
    theme_classic()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-7-1.png" width="672" />



Otro ejemplo del mapa visto desde más cerca, incluyendo la capa de calles interiores:




``` r
ggplot() +
    # capa del mapa
    geom_sf(data = mapa_2,
            fill = "grey95") +
    # capas osm
    geom_sf(data = calles_grandes_b, 
            linewidth = .3, alpha = 1) +
    geom_sf(data = calles_medianas_b, 
            linewidth = .3, alpha = .4) +
    geom_sf(data = calles_chicas_b, 
            linewidth = .2, alpha = .2) +
    # recortar vista
    coord_sf(xlim = c(-73.18, -73.09),
             ylim = c(-40.6, -40.55)) +
    theme_classic()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" width="672" />




## Ejemplo

Realizamos el mismo proceso en un solo paso, para otra región del país, mostrando la diferencia entre visualizar un dato al azar con y sin calles.




``` r
# obtener mapa
mapa_rm <- rnaturalearth::ne_states(country = "Chile") |> 
    select(name, geometry) |> 
    # filter(name == "Región Metropolitana de Santiago")
    filter(name == "Maule")
    
# obtener calles
calles_grandes_rm <- st_bbox(mapa_rm) |> 
    opq(timeout = 500) |> 
    add_osm_feature(key = "highway", 
                    value = c("motorway", "primary", "motorway_link", "primary_link")) |> 
    osmdata_sf()

calles_medianas_rm <- st_bbox(mapa_rm) |> 
    opq(timeout = 500) |> 
    add_osm_feature(key = "highway", 
                    value = c("secondary", "tertiary", "secondary_link", "tertiary_link")) |> 
    osmdata_sf()

# puntos para graficar
puntos <- calles_grandes_rm$osm_points |> 
    filter(highway == "stop") |> 
    st_intersection(mapa_rm) |> 
    rowwise() |> 
    mutate(azar = sample(1:10, 1),
           azar = ifelse(azar < 7, 1, azar)) |> 
    ungroup()
```


``` r
# visualizar sin calles
ggplot() +
    geom_sf(data = mapa_rm) +
    geom_sf(data = puntos, 
            aes(size = azar),
            color = "purple3", alpha = .2) +
    scale_size(range = c(3, 10)) +
    theme_classic()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-10-1.png" width="672" />


``` r
# visualizar con calles
ggplot() +
    geom_sf(data = mapa_rm) +
    geom_sf(data = st_intersection(calles_grandes_rm$osm_lines, mapa_rm),
            linewidth = .2, alpha = .7) +
    geom_sf(data = st_intersection(calles_medianas_rm$osm_lines, mapa_rm),
            linewidth = .1, alpha = .3) +
    geom_sf(data = puntos, 
            aes(size = azar),
            color = "purple3", alpha = .2) +
    scale_size(range = c(3, 10)) +
    theme_classic()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-11-1.png" width="672" />





----

**Bastián Olea Herrera**

Analista de datos, magíster en Sociología (PUC)

[https://bastianolea.github.io/shiny_apps/](https://bastianolea.github.io/shiny_apps/)

[https://bastian.olea.biz](https://bastian.olea.biz)

