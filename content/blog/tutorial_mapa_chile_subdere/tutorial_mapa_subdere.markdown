---
title: Crea un mapa de Chile desde datos geoespaciales oficiales en R
author: Bastián Olea Herrera
date: '2025-10-14'
draft: false
freeze: true
slug: []
categories:
  - tutoriales
tags:
  - mapas
  - ggplot2
  - gráficos
  - ciencias sociales
  - Chile
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: github
    icon_pack: fab
    name: Código
    url: https://gist.github.com/bastianolea/a9e7af5392a31251e33f68ca041e8dd6
  - icon: link
    icon_pack: fas
    name: IDE Subdere
    url: https://ide.subdere.gov.cl
excerpt: En este tutorial aprenderemos a crear mapas de Chile en R usando datos geográficos o _shapes_ oficiales, obtenidos desde la Subsecretaría de Desarrollo Regional y Administrativo (Subdere) y la Biblioteca del Congreso Nacional de Chile. El objetivo será aprender a visualizar mapas desde _shapefiles_ obtenidos de internet, y a procesar datos geográficos más complejos con R, para generar mapas de Chile con polígonos y límites geográficamente correctos.

---




En post anteriores mostré cómo hacer [mapas comunales y regionales de Chile](/blog/tutorial_mapa_chile/) con R, y a hacer [mapas de los territorios urbanos del país](/blog/tutorial_mapa_urbano/).

En este tutorial aprenderemos a crear mapas de Chile en R usando datos geográficos o _shapes_ oficiales de Chile, obtenidos desde la [Subsecretaría de Desarrollo Regional y Administrativo](https://ide.subdere.gov.cl/descargas-con-filtros/) (Subdere) y la [Biblioteca del Congreso Nacional de Chile](https://www.bcn.cl/siit/mapas_vectoriales) (BCN). 

El objetivo será aprender a visualizar mapas desde _shapefiles_ obtenidos de internet, y a procesar datos geográficos más complejos con R, para generar mapas de Chile con polígonos y límites geográficamente correctos.

## Obtener datos geográficos

El primer paso para visualizar mapas es obtener los datos geográficos. Con esto nos referimos a los polígonos (figuras geométricas que usualmente representan territorios), líneas (que pueden representar límites o redes viales) y puntos (que pueden representar ubicaciones como municipios o capitales).

Los datos geográficos suelen venir como _shapes_, que usualmente son carpetas que contienen archivos, principalmente  _shapefiles_ (.shp). 

Los siguientes botones ofrecen descargas directas de los datos que usaremos desde sus fuentes originales, la mayoría de ellos obtenidos desde la [IDE Subdere](https://ide.subdere.gov.cl/descargas-con-filtros/).

----

La **división político-administrativa** contiene los polígonos a nivel comunal, provincial y regional que consituyen el territorio de Chile, y provienen de la Subdere (2023):

{{< boton "Polígonos de división político-administrativa" "https://ide.subdere.gov.cl/descargas/SHP/Limite_DPA_03082023.rar" "fas fa-file-arrow-down">}}


Los **límites comunales** de la división político-administrativa contiene las líneas que limitan las unidades administrativas (comunas) del país, y provienen de la Subdere (2022):

{{< boton "Líneas de límites comunales" "https://ide.subdere.gov.cl/wp-content/uploads/74_limites_dpa_2022.zip" "fas fa-file-arrow-down">}}


Las **ubicaciones de los municipios** marcan con puntos la localización de estas instituciones, y provienen de la Subdere (2022):

{{< boton "Puntos de ubicación de municipios del país" "https://ide.subdere.gov.cl/descargas/SHP/Municipios_15112022.zip" "fas fa-file-arrow-down">}}


La **red vial** es el conjunto de líneas que representan las carreteras y caminos de todo el país, y provienen de la Bibioteca del Congreso Nacional de Chile (BCN):

{{< boton "Líneas de red vial del país" "https://www.bcn.cl/obtienearchivo?id=repositorio/10221/10403/2/Red_Vial.zip" "fas fa-file-arrow-down">}}


Alternativamente, puedes descargar los archivos desde R ejecutando este código:





``` r
dir.create("shapes") # crear carpeta

# descargar
download.file("https://ide.subdere.gov.cl/wp-content/uploads/74_limites_dpa_2022.zip",
              "shapes/74_limites_dpa_2022.zip")

download.file("https://ide.subdere.gov.cl/descargas/SHP/Limite_DPA_03082023.rar",
              "shapes/Limite_DPA_03082023.rar")

download.file("https://ide.subdere.gov.cl/descargas/SHP/Municipios_15112022.zip",
              "shapes/Municipios_15112022.zip")

download.file("https://www.bcn.cl/obtienearchivo?id=repositorio/10221/10403/2/Red_Vial.zip",
              "shapes/Red_Vial.zip")
```




Una vez que descargamos los archivos, debemos descomprimirlos para obtener las carpetas que contienen los _shapes._


## Cargar datos geográficos

Para trabajar con datos geográficos usamos el paquete `{sf}`, abreviación de _simple features_, que es un estándar para manejar datos geoespaciales. Si no tienes instalado el paquete, instálalo con `install.packages("sf")`.

Para leer un archivo geoespacial usamos la función `read_sf()` apuntada a la carpeta que contiene los _shapefiles_:





``` r
library(sf)
library(janitor)

# polígonos de comunas
comunas <- read_sf("shapes/DPA_2023/COMUNAS") |> clean_names()

# límites comunales
limites <- read_sf("shapes/74_limites_dpa_2022") |> clean_names()

# ubicación de municipalidades
municipios <- read_sf("shapes/Municipios_15112022") |> clean_names()

# red vial
calles <- read_sf("shapes/Red_Vial") |> clean_names()
```




Algunos de estos mapas pueden ser muy detallados y/o complejos, por lo que pueden tardarse en cargar[^1].





```
## Linking to GEOS 3.13.0, GDAL 3.8.5, PROJ 9.5.1; sf_use_s2() is TRUE
```

```
## 
## Attaching package: 'janitor'
```

```
## The following objects are masked from 'package:stats':
## 
##     chisq.test, fisher.test
```




Si verificamos la clase de uno de los objetos geográficos cargados, vemos que una de sus clases es `sf`, pero al mismo tiempo `tbl` y `data.frame`:




``` r
class(comunas)
```

```
## [1] "sf"         "tbl_df"     "tbl"        "data.frame"
```




Si lo imprimimos en la consola, confirmamos que los objetos cargados desde los _shapefiles_ son tablas de datos que arriba dicen _Simple feature collection_; es decir, son tablas de datos que además tienen información geográfica.





``` r
comunas
```

```
## Simple feature collection with 345 features and 7 fields
## Geometry type: MULTIPOLYGON
## Dimension:     XY
## Bounding box:  xmin: -109.4549 ymin: -56.53777 xmax: -66.41559 ymax: -17.4984
## Geodetic CRS:  GCS_SIRGAS-Chile
## # A tibble: 345 × 8
##    cut_reg cut_prov cut_com region                   provincia comuna superficie
##    <chr>   <chr>    <chr>   <chr>                    <chr>     <chr>       <dbl>
##  1 11      113      11302   Aysén del General Carlo… Capitán … O'Hig…      7785.
##  2 05      055      05503   Valparaíso               Quillota  Hijue…       268.
##  3 08      083      08308   Biobío                   Biobío    Quila…      1124.
##  4 09      092      09209   La Araucanía             Malleco   Renai…       265.
##  5 09      092      09202   La Araucanía             Malleco   Colli…      1306.
##  6 15      152      15201   Arica y Parinacota       Parinaco… Putre       5890.
##  7 07      071      07110   Maule                    Talca     San R…       263.
##  8 08      083      08311   Biobío                   Biobío    Santa…      1251.
##  9 12      121      12102   Magallanes y de la Antá… Magallan… Lagun…      3568.
## 10 11      113      11303   Aysén del General Carlo… Capitán … Tortel     19991.
## # ℹ 335 more rows
## # ℹ 1 more variable: geometry <MULTIPOLYGON [°]>
```




Estas tablas de datos cuentan con una columna `geometry`, que contiene la información geográfica de los polígonos, puntos y/o líneas de cada observación. A su vez, encima de la tabla de datos vemos información especial, como el tipo de geometría, las dimensiones de la caja (_bounding box_), y el sistema de coordenadas de referencia (_CRS_), que indica el tipo de proyección usada.

## Visualizar mapas
Una vez cargados los _shapes_, simplemente es cosa de aplicarlos por capas a un gráfico de `{ggplot2}`. Las capas de datos geográficos se agregan con `geom_sf()`, y en este caso, que tenemos varios _shapes_, en cada capa habría que definir el objeto correspondiente en el argumento `data`; es decir, cada capa se basa en datos distintos, pero que coinciden en términos de coordenadas. 

Entonces, empezamos un gráfico con `ggplot()`, y luego vamos agregando capas de `geom_sf()`, recordando que el orden en que agreguemos las capas importa: las primeras (más arriba) serán los objetos en el fondo, y las siguientes capas (en sucesivas líneas) se visualizarán encima de las anteriores.






``` r
library(dplyr)
library(ggplot2)

ggplot() +
  # capa de fondo: polígonos de comunas
  geom_sf(data = comunas, aes(fill = region), linewidth = 0) +
  # límites regionales encima de las comunas
  geom_sf(data = limites, color = "peachpuff4", linewidth = 0.2, alpha = 0.8) + 
  # calles
  geom_sf(data = calles |> filter(clase_ruta <= 3), color = "peachpuff4", linewidth = 0.1, alpha = 0.3) +
  # puntos de municipios
  geom_sf(data = municipios, color = "peachpuff4", size = 0.7, alpha = 0.6) + # borde oscuro
  geom_sf(data = municipios, color = "cornsilk1", size = 0.1, alpha = 0.9) + # centro claro
  # recortar Chile continental
  coord_sf(expand = FALSE,
           xlim = c(-76, -66),
           ylim = c(-56.2, -17)) +
  # paleta de colores
  colorspace::scale_fill_discrete_qualitative(
    palette = "Warm", 
    c1 = 40, # intensidad del color
    l1 = 85) + # brillo del color
  theme_minimal() +
  theme(legend.position = "none")
```

{{< imagen "mapa_chile_subdere.jpeg" >}}






A las capas de objetos geográficos le especificamos el sistema de coordenadas con `coord_sf()` para recortar el mapa al territorio continental del país, y [además le pusimos una escala de colores](/blog/colores/#usar-paletas-de-colores-en-ggplot2) cálidos desde el paquete `{colorspace}`, que además tiene la cualidad de poder adaptar la intensidad y brillo de sus colores.

Listo! La gracia de `{sf}` es poder entregar herramientas para cargar cualquier tipo de datos geográficos y habilitar que `{ggplot2}` los pueda graficar sin problemas. A menos que ocurran problemas. Lo cual veremos [en otro post](/tags/mapas/) 😬



[^1]: Al tratarse de mapas oficiales, estos datos geográficos contienen mucho nivel de detalle; usualmente mucho más del necesario para hacer mapas a nivel nacional, donde el nivel de detalle es visualmente imperceptible. Dado que una mayor calidad significa mapas más pesados y por ende procesos más lentos, podemos [simplificar las geometrías](/blog/simplificar_mapas/) con la función `ms_simplify()` del paquete `{rmapshaper}`, como detallamos [en este post.](/blog/simplificar_mapas/) 
