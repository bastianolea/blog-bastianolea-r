---
title: Mapas y visualización de datos geoespaciales en R con {sf}
author: Bastián Olea Herrera
date: '2025-10-22'
draft: false
slug: []
categories:
  - tutoriales
tags:
  - mapas
  - visualización de datos
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: registered
    icon_pack: fas
    name: SF
    url: https://r-spatial.github.io/sf/
execute:
  eval: false
excerpt: >-
  R cuenta con un muy amplio ecosistema de paquetes para datos geoespaciales.
  Uno de los paquetes más importantes es `{sf}`, que permite manipular datos
  espaciales a partir del estándar _simple features_ (características simples),
  ampliamente utilizado en sistemas de información geográfica (SIG/GIS). En esta
  guía iré guardando los comandos que uso frecuentemente para manipular y
  visualizar datos geoespaciales en R. En la medida que voy aprendiendo más
  sobre hacer mapitas, iré actualizando y complementando.
---


{{< imagen "mapa_rm_featured.png" >}}
{{< aviso "⚠️ post en construcción! ⚠️" >}}

R cuenta con un muy amplio [ecosistema](https://github.com/r-spatial/) de paquetes para datos geoespaciales. Uno de los [paquetes más importantes es `{sf}`](https://r-spatial.github.io/sf/), que permite manipular datos espaciales a partir del estándar *simple features* (características simples), ampliamente utilizado en sistemas de información geográfica (SIG/GIS).

En esta guía iré guardando los comandos que uso frecuentemente para **manipular, transformar y visualizar datos geoespaciales** en R. En la medida que voy aprendiendo más sobre hacer mapitas, iré actualizando y complementando.

Lo inicial es instalar `{sf}`:

``` r
install.packages("sf")
```

``` r
library(sf)
library(dplyr)
```

{{< indice >}}

## Carga de datos

{{< boton "Mapoteca Biblioteca del Congreso Nacional" "https://www.bcn.cl/siit/mapas_vectoriales" "fas fa-map">}}

En este enlace podemos descargar un *shapefile* con los límites político-administrativos de Chile, como el titulado *[Division regional: polígonos de las regiones de Chile](https://www.bcn.cl/obtienearchivo?id=repositorio/10221/10398/2/Regiones.zip)*.

Una vez descargado, descomprimimos el archivo (podemos usar `unzip()`) y obtendremos una **carpeta**. Es importante que la carpeta esté en nuestro [proyecto de RStudio](../../../blog/r_introduccion/proyectos/). Personalmente prefiero guardar los *shapes* en su propia carpeta, así que pondré la carpeta del *shape* descargado dentro de `shapes/`

### Cargar *shapes*

``` r
mapa <- read_sf("shapes/Regiones") |> 
  janitor::clean_names()

mapa
```

<!--
### Cargar geoJSON


### Cargar KMZ


::: {.cell}

```{.r .cell-code}
unzip("~/Downloads/Mis lugares.kmz", exdir = "~/Downloads/Mis lugares")

sf::read_sf("~/Downloads/Mis lugares/doc.kml")
```
:::



-->

## Operaciones sobre geometrías

### Calcular centroide

``` r
mapa |> 
  select(region, geometry) |> 
  mutate(centroide = st_centroid(geometry))
```

### Extraer longitud y latitud

``` r
mapa_centroide <- mapa |> 
  select(region, geometry) |> 
  mutate(centroide = st_centroid(geometry))

mapa_centroide |> 
  mutate(lon = st_coordinates(centroide)[,1],
         lat = st_coordinates(centroide)[,2])
```

### Calcular caja de un polígono

Bounding box

``` r
st_bbox(mapa)
```

### Convertir caja a polígono

``` r
caja <- st_bbox(mapa)

caja_poli <- caja |> 
  st_as_sfc() |>
  st_as_sf()

caja_poli
```

### Calcular buffer

``` r
st_buffer()
```

### Crear un cuadrado

Desde una coordenada

``` r
coordenadas <- c(38.29782, -76.51390)

coordenadas |> 
  st_point() |>
  st_sfc() |>
  st_buffer(dist = 30000)  |> 
  st_bbox() |> 
  st_as_sfc() |>
  st_as_sf()
```

<!--
Desde el centroide de un polígono


::: {.cell}

```{.r .cell-code}
mapa |> 
  filter(region == "Región de Antofagasta") |>
  st_centroid() |> 
  st_buffer(dist = 8000) |> 
  st_bbox() |> 
  st_as_sfc() |>
  st_as_sf()
```
:::


-->
<!--
### Calcular superficie o área


::: {.cell}

```{.r .cell-code}
mapa_region_comunas_areas |> 
  st_union() |> 
  st_area() |> 
  units::set_units("km^2")
```
:::


 


### Recortar polígono a coordenadas


::: {.cell}

```{.r .cell-code}
 st_crop(xmin = -74, ymin = -36, xmax = -65, ymax = -30) |> 
```
:::




### Simplificar un polígono


::: {.cell}

```{.r .cell-code}
https://bookdown.org/robinlovelace/geocompr/geometric-operations.html#simplification
st_simplify(dTolerance = 0.01)

rmapshaper::ms_simplify(geometry, keep = 0.8)) 
```
:::




### Extraer líneas internas de un polígono


::: {.cell}

```{.r .cell-code}
ms_innerlines() # deja solo las líneas interiores de un coso
```
:::




## Correcciones


::: {.cell}

```{.r .cell-code}
st_as_sf()
```
:::

::: {.cell}

```{.r .cell-code}
st_make_valid()
```
:::

::: {.cell}

```{.r .cell-code}
st_drop_geometry() 
```
:::




----


## Operaciones agrupadas

### Unir polígonos


::: {.cell}

```{.r .cell-code}
group_by() |> 
st_union()
```
:::


 

## Operaciones entre geometrías

### Recortar un polígono con otro
https://bookdown.org/robinlovelace/geocompr/geometric-operations.html#clipping



::: {.cell}

```{.r .cell-code}
st_intersection()
```
:::


 
### Usar un polígono para eliminar partes de otro


::: {.cell}

```{.r .cell-code}
st_difference()
```
:::


 
 
### unir dos polígonos


::: {.cell}

```{.r .cell-code}
st_union()
```
:::



### Spatial join

### Filter


::: {.cell}

```{.r .cell-code}
https://cengel.github.io/R-spatial/spatialops.html#topological-subsetting-select-polygons-by-location
```
:::





## Coordenadas

### Extraer sistema de coordenadas


::: {.cell}

```{.r .cell-code}
st_crs(comunas_region)
```
:::



### Cambiar coordenadas


::: {.cell}

```{.r .cell-code}
st_transform(crs = st_crs(comunas_region))
```
:::




## Visualización

### Visualizar por capas


::: {.cell}

```{.r .cell-code}
geom_sf()
```
:::




### Texto


::: {.cell}

```{.r .cell-code}
geom_sf_text(data = nombres_areas |> filter(clase_topo == "Comuna"), color = "red", fontface = "bold",
            aes(label = nombre)) + 
```
:::



### Texto con repel
https://github.com/slowkow/ggrepel/issues/111#issuecomment-416853013


::: {.cell}

```{.r .cell-code}
 ggrepel::geom_label_repel(data = comunas_region_conteo_urbanas,
                            aes(label = comuna, geometry = geometry),
                            stat = "sf_coordinates",
                            size = 2, box.padding = 0,
                            min.segment.length = unit(3, "mm"),
                            label.padding = 0.15, label.size = 0
  ) +
```
:::




### Hacer zoom


::: {.cell}

```{.r .cell-code}
#   coord_sf(xlim = c(-70.4, -70.2),
#            ylim = c(-18.7, -18.4),
```
:::



### Dibujar un cuadrado


::: {.cell}

```{.r .cell-code}
#   annotate("rect", fill = NA, color = "black", linewidth = 1,
#            xmin = bbox_area_met[1]-2000, xmax = bbox_area_met[2]+2000,
#            ymin = bbox_area_met[3]+2000, ymax = bbox_area_met[4]-2000)+
```
:::



### Escala de colores para mapa de calor



::: {.cell}

```{.r .cell-code}
 scale_fill_gradient2(
    low = color$bajo, mid = color$medio, high = color$alto,
    midpoint = mean(comunas_region_conteo$n),
    na.value = col_mix(color$fondo, color$principal, 0.1),
    limits = c(0, NA)
    # breaks = cortes
  )
```
:::




### Minimapa
https://dominicroye.github.io/blog/inserted-map/


::: {.cell}

:::



-->

------------------------------------------------------------------------

## Recursos para aprender más

### Apuntes

{{< imagen "sf_cheatsheet_1.jpeg" >}}
{{< imagen "sf_cheatsheet_2.jpeg" >}}

### Libros

-   [Drawing beautiful maps programmatically with R, sf and ggplot2](https://r-spatial.org/r/2018/10/25/ggplot2-sf.html)
-   [Geocomputation with R](https://bookdown.org/robinlovelace/geocompr/)
-   [Spatial Data Science With Applications in R](https://r-spatial.org/book/)
-   [Using Spatial Data with R](https://cengel.github.io/R-spatial/)
