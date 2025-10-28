---
title: Mapas y visualización de datos geoespaciales en R con {sf}
author: Bastián Olea Herrera
date: '2025-10-22'
draft: false
freeze: false
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
  cache: false
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
{{< aviso "⚠️ Este tutorial se encuentra en construcción! ⚠️" >}}

R cuenta con un muy amplio [ecosistema](https://github.com/r-spatial/) de paquetes para datos geoespaciales. Uno de los [paquetes más importantes es `{sf}`](https://r-spatial.github.io/sf/), que permite manipular datos espaciales a partir del estándar *simple features* (características simples), ampliamente utilizado en sistemas de información geográfica (SIG/GIS).

En esta guía iré guardando los comandos que uso frecuentemente para **manipular, transformar y visualizar datos geoespaciales** en R. En la medida que voy aprendiendo más sobre hacer mapitas, iré actualizando y complementando.

Lo inicial es instalar `{sf}`:

``` r
install.packages("sf")
```

Y cargarlo junto a `{dplyr}` para empezar a trabajar con datos geoespaciales.

``` r
library(sf)
library(dplyr)
```

**Nota:** para simplificar, en este tutorial voy a ocultar el código de los gráficos, pero siempre estará disponible bajo flechitas que despliegan el código, como la siguiente:

{{< detalles "**Ver código para los gráficos**" >}}

``` r
library(ggplot2)

# tema de colores
thematic::thematic_on(fg = "#553A74",
                      bg = "#EAD2FA",
                      accent = "#9069C0")

theme_set(
  # fondo transparente para mapas
  theme(plot.background = element_rect(fill = "transparent", color = "transparent")) +
    # borrar líneas feas
    theme(axis.ticks = element_blank())
)
```

{{< /detalles >}}

<br>

{{< indice >}}

------------------------------------------------------------------------

## Carga de mapas

Una de las fuentes principales de datos geoespaciales son los *shapefiles*. Pero también existen **paquetes de R que contienen información geoespacial**, para mayor conveniencia. Exploraremos ambas opciones a continuación.

### Cargar mapas de cualquier país

Si no tenemos o no queremos descargar *shapes*, podemos **cargar mapas de cualquier país directo en R** gracias a [`{rnaturalearth}`](http://ropensci.github.io/rnaturalearth/). Con este paquete obtenemos directamente mapas de cualquier país del mundo, incluyendo sus estados o regiones internos, sin necesidad de descargas.

Instala `{rnaturalearth}` si no lo tienes:

``` r
install.packages("rnaturalearth")
```

Puedes insertar el nombre de tu país para seguir con este tutorial usando ejemplos de tu territorio.

``` r
# install.packages("rnaturalearth")
library(rnaturalearth)

pais <- ne_states("Argentina")
# pais <- ne_states("Mexico")
# pais <- ne_states("Colombia")

mapa <- pais |> 
  # seleccionar columnas
  select(pais = admin,
         region = name_es,
         geometry)

mapa
```

    Simple feature collection with 24 features and 2 fields
    Geometry type: MULTIPOLYGON
    Dimension:     XY
    Bounding box:  xmin: -73.57274 ymin: -55.05202 xmax: -53.66155 ymax: -21.78694
    Geodetic CRS:  WGS 84
    First 10 features:
              pais     region                       geometry
    1    Argentina Entre Ríos MULTIPOLYGON (((-58.20011 -...
    12   Argentina      Salta MULTIPOLYGON (((-68.49647 -...
    13   Argentina      Jujuy MULTIPOLYGON (((-67.25133 -...
    741  Argentina    Formosa MULTIPOLYGON (((-62.34136 -...
    746  Argentina   Misiones MULTIPOLYGON (((-54.66497 -...
    749  Argentina      Chaco MULTIPOLYGON (((-58.35127 -...
    750  Argentina Corrientes MULTIPOLYGON (((-58.6042 -2...
    1318 Argentina  Catamarca MULTIPOLYGON (((-68.33776 -...
    1320 Argentina   La Rioja MULTIPOLYGON (((-69.65405 -...
    1321 Argentina   San Juan MULTIPOLYGON (((-69.95766 -...

### Cargar *shapes*

Un *shapefile* es un formato de archivo común para datos geoespaciales, que en realidad consiste en una **carpeta** con archivos relacionados (`.shp`, `.shx`, `.dbf`, entre otros) que juntos representan la geometría y atributos de los objetos geográficos.

Teniendo la carpeta, basta con cargarla con la función `read_sf()`.

{{< detalles "**Ejemplo de descarga y carga de un _shapefile_ de Chile**" >}}

Para aprender, podemos descargar un *shape* y usarlo para practicar. Si no tienes uno a mano, en el siguiente botón podemos bajar un *shapefile* de Chile por regiones, que proviene de la [Mapoteca de la Biblioteca del Congreso Nacional](https://www.bcn.cl/siit/mapas_vectoriales).

{{< boton "Division regional: polígonos de las regiones de Chile" "https://www.bcn.cl/obtienearchivo?id=repositorio/10221/10398/2/Regiones.zip" "fas fa-map">}}

También puedes descargarlo directamente desde R con `download.file()` y luego `unzip()`, [como se indica en este post](../../../blog/mapa_chile_triple/#descargar-mapas).

Una vez descargado, descomprimimos el archivo y obtenemos una **carpeta**. Esta carpeta es nuestro *shapefile*, así que la guardamos dentro de nuestro [proyecto de RStudio](../../../blog/r_introduccion/proyectos/), idealmente dentro de una carpeta donde guardemos nuestros mapas.

``` r
# descargar
download.file("https://www.bcn.cl/obtienearchivo?id=repositorio/10221/10398/2/Regiones.zip",
              "Regiones.zip")

# descomprimir
unzip("Regiones.zip", exdir = "shapes/Regiones")
```

En el siguiente ejemplo, guardamos el *shapefile* en una carpeta `shapes`, y lo cargamos con `read_sf()`.

``` r
mapa <- read_sf("shapes/Regiones") |> 
  janitor::clean_names()

mapa
```

    Simple feature collection with 17 features and 7 fields
    Geometry type: GEOMETRY
    Dimension:     XY
    Bounding box:  xmin: -12183900 ymin: -7554306 xmax: -7393644 ymax: -1978920
    Projected CRS: WGS 84 / Pseudo-Mercator
    # A tibble: 17 × 8
       objectid cir_sena codregion area_km    st_area_sh st_length region           
     *    <dbl>    <int>     <int>   <dbl>         <dbl>     <dbl> <chr>            
     1     1084        1        15  16867.  18868687744.   750530. Región de Arica …
     2     1085        2         1  42285.  48306372203.  1213713. Región de Tarapa…
     3     1086        3         2 126071. 150845155633   2516112. Región de Antofa…
     4     1087       15        12 133053. 358131609833  90498304. Región de Magall…
     5     1088       14        11 106703. 224274263072  41444811. Región de Aysén …
     6     1089        4         3  75661.  96439063562.  2401741. Región de Atacama
     7     1090        5         4  40576.  54980818749.  2065933. Región de Coquim…
     8     1091        6         5  16323.  23014748571.  1679609. Región de Valpar…
     9     1092        7        13  15392.  22252038246.  1064253. Región Metropoli…
    10     1093       13        10  48408.  87718341940.  7874158. Región de Los La…
    11     1094       12        14  18245.  31086613540.  1844423. Región de Los Rí…
    12     1095       11         9  31838.  52215073344.  1501025. Región de La Ara…
    13     1096       10         8  24022.  38176117509.  2097147. Región del Bío-B…
    14     1097       10        16  13104.  20376298459.  1074094. Región de Ñuble  
    15     1098        9         7  30322.  45969426092.  1388328. Región del Maule 
    16     1099        8         6  16349.  24090278437.   984853. Región del Liber…
    17     1100        0         0   3937.   9306245194.   388722. Zona sin demarcar
    # ℹ 1 more variable: geometry <GEOMETRY [m]>

{{< /detalles >}}
{{< aviso "Puedes seguir este tutorial independientemente del mapa que hayas cargado (el _shape_ de Chile, con `rnaturalearth`, u otro _shape_ que tú elijas); lo importante es que cargues un objeto `mapa` que tenga columna `geometry` y `region`." >}}
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

------------------------------------------------------------------------

Como vemos, una vez que cargamos los datos geoespaciales obtenemos una **tabla con características especiales**. Arriba de la tabla vemos una descripción de las características del mapa, el tipo de geometrías, la caja o *bounding box* que enmarca los polígonos, y el sistema de referencia de coordenadas del mapa.

En `{sf}` los datos geoespaciales además contienen una columna `geometry`, que contiene las geometrías (puntos, líneas o polígonos) que definen la forma y ubicación de los elementos geográficos. Vamos a trabajar con esta columna si queremos **modificar la geometría** de los elementos geoespaciales o calcular algo a partir de ellos. **Cada fila de la tabla representa un objeto geográfico** (una región, comuna, país, etc.) y las demás columnas son variables relacionadas al objeto geográfico (población, superficie, nombre, etc.)

<!--
## Glosario

- **Simple features**: estándar para representar datos geoespaciales en forma de tablas con una columna especial de geometría.
- **Shapefile**: formato de archivo común para datos geoespaciales, que en realidad consiste en varios archivos relacionados.
- **Polígono**: forma geométrica que representa áreas en un mapa.

-->

------------------------------------------------------------------------

## Visualización básica de mapas

Para visualizar un mapa con `{sf}` usamos la geometría `geom_sf()` dentro de un gráfico de `{ggplot2}`. Esta función reconoce automáticamente la columna `geometry` del objeto espacial, y dibuja las formas geográficas correspondientes.

``` r
mapa |> 
  ggplot() +
  geom_sf(fill = "#9069C0", 
          color = "#EBD2FA",
          linewidth = 0.1)
```

<img src="mapas_sf.markdown_strict_files/figure-markdown_strict/mapa_basico-1.png" width="768" />

{{< aviso "Si necesitas aprender lo básico de `{ggplot2}` para visualización de datos, [revisa este completo tutorial](/blog/r_introduccion/tutorial_visualizacion_ggplot/)." >}}

------------------------------------------------------------------------

## Operaciones sobre geometrías

Las operaciones sobre geometrías permiten manipular y analizar las formas y ubicaciones de los objetos geográficos. A continuación veremos algunas operaciones comunes que se pueden realizar con el paquete `{sf}` en R.

### Calcular centroide

El centroide es el punto central de un polígono. Calcularlo sirve, por ejemplo, para ubicar una etiqueta de texto sobre un polígono, poner un punto sobre un territorio que crece con respecto a una variable, etc.

``` r
mapa_centroide <- mapa |> 
  select(region, geometry) |> 
  mutate(centroide = st_centroid(geometry))
```

                      region                   centroide
    1             Entre Ríos POINT (-59.20493 -32.03189)
    12                 Salta POINT (-64.80661 -24.28824)
    13                 Jujuy POINT (-65.77985 -23.31783)
    741              Formosa POINT (-59.94839 -24.89604)
    746             Misiones POINT (-54.65212 -26.86956)
    749                Chaco POINT (-60.77109 -26.39039)
    750           Corrientes POINT (-57.79471 -28.76018)
    1318           Catamarca  POINT (-66.99006 -27.3092)
    1320            La Rioja POINT (-67.21371 -29.66235)
    1321            San Juan POINT (-68.88199 -30.82274)
    1323             Mendoza POINT (-68.60826 -34.58944)
    1328             Neuquén POINT (-70.11374 -38.62865)
    1333              Chubut POINT (-68.51499 -43.78523)
    1335           Río Negro POINT (-67.21765 -40.40738)
    1337          Santa Cruz  POINT (-69.8981 -48.76187)
    1339    Tierra del Fuego  POINT (-67.4401 -54.32625)
    1726        Buenos Aires POINT (-60.54573 -36.66279)
    1746        Buenos Aires POINT (-58.45093 -34.64272)
    3852            Santa Fe POINT (-60.93513 -30.66904)
    3853             Tucumán  POINT (-65.36557 -26.9491)
    3854 Santiago del Estero  POINT (-63.2909 -27.71835)
    3855            San Luis POINT (-66.03363 -33.74238)
    3856            La Pampa POINT (-65.44562 -37.12691)
    3857             Córdoba POINT (-63.76859 -32.07319)

<img src="mapas_sf.markdown_strict_files/figure-markdown_strict/mapa_centroide-1.png" width="768" />

{{< detalles "Ver código del gráfico" >}}

``` r
mapa_centroide |> 
  filter(region == mapa$region[3]) |> 
  ggplot() +
  geom_sf(fill = "#9069C0", 
          linewidth = NA) +
  geom_sf(
    aes(geometry = centroide),
    size = 3, alpha = .6) +
  geom_sf_text(
    aes(geometry = centroide),
    label = "centroide", size = 3,
    nudge_y = -20000)
```

{{< /detalles >}}

------------------------------------------------------------------------

### Extraer longitud y latitud

Para obtener las coordenadas (longitud y latitud) de un elemento espacial, necesitamos primero que sea un punto, porque un polígono es una figura compleja que no tiene solamente una latitud y una longitud. Si tenemos un polígono, [primero calculamos el centroide](#calcular-centroide), y luego extraemos las coordenadas con `st_coordinates()`. Como esta función retorna la longitud y latitud de cada punto al mismo tiempo, tenemos que pedirle que entregue la una o la otra usando corchetes.

``` r
mapa_centroide_coordenadas <- mapa_centroide |> 
  mutate(lon = st_coordinates(centroide)[,1],
         lat = st_coordinates(centroide)[,2])
```

                      region       lon       lat
    1             Entre Ríos -59.20493 -32.03189
    12                 Salta -64.80661 -24.28824
    13                 Jujuy -65.77985 -23.31783
    741              Formosa -59.94839 -24.89604
    746             Misiones -54.65212 -26.86956
    749                Chaco -60.77109 -26.39039
    750           Corrientes -57.79471 -28.76018
    1318           Catamarca -66.99006 -27.30920
    1320            La Rioja -67.21371 -29.66235
    1321            San Juan -68.88199 -30.82274
    1323             Mendoza -68.60826 -34.58944
    1328             Neuquén -70.11374 -38.62865
    1333              Chubut -68.51499 -43.78523
    1335           Río Negro -67.21765 -40.40738
    1337          Santa Cruz -69.89810 -48.76187
    1339    Tierra del Fuego -67.44010 -54.32625
    1726        Buenos Aires -60.54573 -36.66279
    1746        Buenos Aires -58.45093 -34.64272
    3852            Santa Fe -60.93513 -30.66904
    3853             Tucumán -65.36557 -26.94910
    3854 Santiago del Estero -63.29090 -27.71835
    3855            San Luis -66.03363 -33.74238
    3856            La Pampa -65.44562 -37.12691
    3857             Córdoba -63.76859 -32.07319

<img src="mapas_sf.markdown_strict_files/figure-markdown_strict/barras_latitud-1.png" width="768" />

{{< detalles "Ver código del gráfico" >}}

``` r
mapa_centroide_coordenadas |> 
  distinct(region, .keep_all = TRUE) |> 
  mutate(region = forcats::fct_reorder(region, lat)) |> # ordenar regiones
  ggplot() +
  aes(lat, region) +
  geom_col(width = 0.7, 
           fill = "#9069C0") +
  geom_text(aes(label = region),
            size = 3, hjust = -0.05, color = "#EAD2FA") +
  scale_y_discrete(labels = NULL) +
  labs(y = NULL, x = "Latitud")
```

{{< /detalles >}}

------------------------------------------------------------------------

### Calcular buffer

Un *buffer* es una zona alrededor de un objeto geográfico, definida por una distancia específica. Calcular un *buffer* es útil para analizar áreas de influencia, proximidad a ciertos puntos o regiones, o para hacer modificiones sobre mapas con fines de visualización.

Con la función `st_buffer()` definimos el espacio en torno a un polígono, especificando en el argumento `dist` la **distancia** del *buffer* en las unidades del sistema de coordenadas del mapa (por ejemplo, metros si el mapa está en UTM), y con `max_cells` podemos controlar la calidad del polígono resultante.

``` r
mapa_buffer <- mapa |> 
  # filtrar una región/polígono
  filter(region == mapa$region[3]) |> 
  # crear buffer
  mutate(buffer = st_buffer(geometry, 
                            dist = 20000,
                            max_cells = 10000))
```

<img src="mapas_sf.markdown_strict_files/figure-markdown_strict/mapa_buffer-1.png" width="768" />

{{< detalles "Ver código del gráfico" >}}

``` r
mapa_buffer |> 
  ggplot() +
  # capa de la región
  geom_sf(aes(geometry = geometry), 
          fill = "#9069C0", linewidth = NA) +
  # capa del buffer
  geom_sf(aes(geometry = buffer), 
          fill = "#9069C0", alpha = 0.5, linewidth = NA)
```

{{< /detalles >}}

------------------------------------------------------------------------

### Calcular caja de un polígono

Con la función `st_bbox()` obtenemos las coordenadas de la caja que envuelve a un polígono o conjunto de polígonos. Esta caja está definida por las coordenadas mínimas y máximas en los ejes *x* (longitud) e *y* (latitud).

``` r
caja <- st_bbox(mapa)

caja
```

         xmin      ymin      xmax      ymax 
    -73.57274 -55.05202 -53.66155 -21.78694 

#### Convertir caja a polígono

Teniendo una caja con sus coordenadas, podemos convertirla a un polígono para aplicarlo sobre (o debajo de) un mapa.

``` r
rectangulo <- caja |> 
  st_as_sfc(crs = st_crs(mapa))
```

<img src="mapas_sf.markdown_strict_files/figure-markdown_strict/unnamed-chunk-19-1.png" width="768" />

{{< detalles "Ver código del gráfico" >}}

``` r
ggplot() +
  # mapa de fondo
  geom_sf(data = mapa,
          fill = "#9069C0", color = "#EBD2FB",
          linewidth = 0.3) +
  # capa con la caja encima
  geom_sf(data = rectangulo,
          fill = "#9069C0", color = "#9069C0", 
          linewidth = 0.8, alpha = 0.4) +
  # tema
  theme(axis.text = element_blank(),
        panel.background = element_blank())
```

{{< /detalles >}}

------------------------------------------------------------------------

### Poner un punto en un mapa

Si queremos poner puntos en posiciones específicas de un mapa, sólo necesitamos crear una tabla con las coordenadas de los puntos y convertir la tabla a `sf` con `st_as_sf()`. Al hacer esto, es necesario especificar el sistema de referencia de coordenadas (CRS) del mapa, para que los puntos se ubiquen correctamente. Hacemos esto extrayendo el CRS del mapa con `st_crs()` y aplicándolo a nuestra nueva tabla `sf`.

``` r
# definir coordenadas
coordenadas <- tibble(longitud = -70, 
                      latitud = -38)

# convertir tabla a sf
punto <- coordenadas |> 
  st_as_sf(coords = c("longitud", "latitud"), 
           crs = st_crs(mapa))
```

<img src="mapas_sf.markdown_strict_files/figure-markdown_strict/unnamed-chunk-22-1.png" width="768" />

{{< detalles "Ver código del gráfico">}}

``` r
ggplot() +
  # mapa de fondo
  geom_sf(data = mapa,
          fill = "#9069C0", color = "#EBD2FB",
          linewidth = 0.3) +
  # capa con el punto
  geom_sf(data = punto,
          size = 3, alpha = .5)
```

{{< /detalles >}}

#### Poner varios puntos en un mapa

Si necesitamos agregar más de un punto, simplemente hacemos una tabla con todos los que necesitemos. Obviamente también podemos especificar otras columnas que podemos usar para etiquetar los puntos, especificar sus colores, y más.

``` r
coordenadas <- tribble(~nombre, ~lon, ~lat, ~n,
                       "A",  -69,  -38,  4,
                       "B",  -65,  -37,  6,
                       "C",  -61,  -36,  9)

puntos <- coordenadas |> 
  # convertir tabla a sf
  st_as_sf(coords = c("lon", "lat"), 
           crs = st_crs(mapa))
```

<img src="mapas_sf.markdown_strict_files/figure-markdown_strict/unnamed-chunk-25-1.png" width="768" />

{{< detalles "Ver código del gráfico">}}

``` r
ggplot() +
  # mapa de fondo
  geom_sf(data = mapa,
          fill = "#9069C0", color = "#EBD2FB",
          linewidth = 0.3) +
  # capa con puntos
  geom_sf(data = puntos,
          aes(size = n),
          alpha = .5) +
  # capa con textos
  geom_sf_label(data = puntos,
                aes(label = nombre),
                size = 3, vjust = -0.8,
                fontface = "bold") +
  # escala de tamaño
  scale_size(range = c(3, 6),
             breaks = scales::breaks_pretty(n = 3)) +
  guides(size = guide_legend(override.aes = list(color = "#9069C0", 
                                                 alpha = 1)))
```

{{< /detalles >}}

------------------------------------------------------------------------

### Crear un cuadrado

Para poner un cuadrado encima de una ubicación del mapa, primero creamos un punto, luego lo [expandimos con un *buffer*](#calcular-buffer), calculamos [la caja que envuelve a dicho punto](#calcular-caja-de-un-polígono), y finalmente convertimos la caja en un polígono `sf`.

``` r
coordenadas <- tibble(longitud = -58, latitud = -38)

punto <- coordenadas |> 
  # convertir tabla a sf
  st_as_sf(coords = c("longitud", "latitud"), 
           crs = st_crs(mapa))

cuadrado <- punto |> 
  st_buffer(dist = 100000) |> # agrandar punto
  st_bbox() |> # crear caja al rededor
  st_as_sfc(crs = st_crs(mapa)) # convertir a sf
```

<img src="mapas_sf.markdown_strict_files/figure-markdown_strict/unnamed-chunk-28-1.png" width="768" />

{{< detalles "Ver código del gráfico">}}

``` r
ggplot() +
  # mapa de fondo
  geom_sf(data = mapa,
          fill = "#9069C0", color = "#EBD2FB",
          linewidth = 0.1) +
  # capa con puntos
  geom_sf(data = cuadrado,
          fill = NA,
          linewidth = 0.7, 
          linejoin = "mitre", #linejoin = "round",
          color = "#402E5A") +
  coord_sf(xlim = c(-72, -56),
           ylim = c(-40, -30))
```

{{< /detalles >}}

Paso a paso, el proceso de crear el punto, agrandarlo, y formarlo en un cuadrado se vería así:

<img src="mapas_sf.markdown_strict_files/figure-markdown_strict/unnamed-chunk-30-1.png" width="768" />

{{< detalles "Ver código del proceso y del gráfico">}}

``` r
punto_grande <- punto |> 
  st_buffer(dist = 100000, max_cells = 10000)

cuadrado <- punto_grande |> 
  st_bbox(crs = st_crs(mapa)) |> 
  st_as_sfc() |> 
  st_as_sf(crs = st_crs(mapa))

ggplot() +
  # mapa de fondo
  geom_sf(data = mapa,
          fill = "#9069C0", color = "#EBD2FB",
          linewidth = 0.1) +
  # capas 
  geom_sf(data = punto, 
          color = "#402E5A", size = 3) +
  geom_sf(data = punto_grande,
          fill = NA, color = "#402E5A", lwd = 0.7) +
  geom_sf(data = cuadrado,
          fill = NA, color = "#402E5A", lwd = 0.7) +
  # acercar mapa
  coord_sf(xlim = c(-61, -55),
           ylim = c(-40, -35.7))
```

{{< /detalles >}}

#### Crear un rectángulo a partir de puntos

Si tenemos varios puntos y necesitamos crear un rectángulo que los contenga a todos, podemos repetir lo anterior pero partiendo de varios puntos a la vez.

``` r
# tabla con coordenadas
coordenadas <- tribble(~nombre, ~lon, ~lat, ~n,
                       "A",  -69,  -38,  4,
                       "B",  -65,  -37,  6,
                       "C",  -61,  -36,  9)

# convertir coordenadas a puntos
puntos <- coordenadas |> 
  # convertir tabla a sf
  st_as_sf(coords = c("lon", "lat"), 
           crs = st_crs(mapa))

# convertir puntos a rectándulo
rectangulo <- puntos |> 
  st_buffer(dist = 80000) |> # ampliar
  st_bbox() |> 
  st_as_sfc(crs = st_crs(mapa))
```

<img src="mapas_sf.markdown_strict_files/figure-markdown_strict/unnamed-chunk-33-1.png" width="768" />

{{< detalles "Ver código del gráfico">}}

``` r
ggplot() +
  # mapa de fondo
  geom_sf(data = mapa,
          fill = "#9069C0", color = "#EBD2FB",
          linewidth = 0.1) +
  # capa con puntos
  geom_sf(data = puntos,
          alpha = .5) +
  geom_sf(data = rectangulo,
          fill = NA, color = "#402E5A", lwd = 0.7)
```

{{< /detalles >}}

------------------------------------------------------------------------

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
{{< aviso "⚠️ Este tutorial se encuentra en construcción ⚠️" >}}

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
