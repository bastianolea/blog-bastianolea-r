---
title: 'Tutorial: Mapa de la zona urbana de la Región Metropolitana de Santiago en R'
author: Bastián Olea Herrera
date: 2024-06-12T00:00:00.000Z
categories:
  - Tutoriales
tags:
  - mapas
  - chile
  - gráficos
format: hugo-md
lang: es
editor_options:
  chunk_output_type: inline
---


Este tutorial de R te explicará paso a paso a cómo obtener mapas de todo Chile usando el paquete [`{chilemapas}` desarrollado por Mauricio Vargas](https://github.com/pachadotdev/chilemapas), y hacer gráficos con estos mapas usando `{ggplot2}`.

En la primera parte veremos cómo **obtener los mapas** y cómo **visualizar datos comunales** usando mapas en R.

Luego, nos enfrentaremos a un problema común que se tiene al graficar un mapa de la Región Metropolitana de Santiago, que tiene que ver con la diferencia entre los límites comunales reales de cada comuna y los **límites urbanos** de las comunas. Es la diferencia entre tener un mapa de la RM que abarque sectores rurales como Paine y que llegue hasta Argentina, o un mapa que demarque la zona urbana de Santiago, aproximadamente correspondiente a la zona que atravieza el anillo Vespucio.

Graficando un mapa de la superficie urbana de la Región Metropolitana, obtenemos una figura que es más familiar al habitante promedio de la RM, y que es la que usalmente vemos en la cotidianeidad, en contraste con un mapa geográficamente correcto de todo el territorio abarcado por la región.

### Paquetes

Primero cargamos los paquetes que usaremos en este tutorial:

``` r
# datos
library(dplyr) #manipulación de datos
library(janitor) #limpieza de datos
library(stringr) #manipulación de texto

# mapas
library(chilemapas) #mapas de chile
library(sf) #manipulación de mapas

# gráficos
library(ggplot2) #visualización de datos
library(viridis) #escalas de colores
library(scales) #escalas numéricas

# web scraping
library(rvest) #obtener datos desde páginas de internet
```

### Obtener un mapa regional

Primero, usaremos `{chilemapas}` para obtener los datos geográficos (polígonos o shapes) necesarios para producir un mapa de la Región Metropolitana:

``` r
mapa <- chilemapas::mapa_comunas |> 
  left_join(
    chilemapas::codigos_territoriales |> 
      select(matches("comuna")), 
    by = "codigo_comuna") |> 
  filter(codigo_region=="13")

print(mapa)
```

    # A tibble: 52 × 5
       codigo_comuna codigo_provincia codigo_region                         geometry
       <chr>         <chr>            <chr>                       <MULTIPOLYGON [°]>
     1 13404         134              13            (((-70.61396 -33.73862, -70.609…
     2 13402         134              13            (((-70.61396 -33.73862, -70.623…
     3 13124         131              13            (((-70.75679 -33.38348, -70.780…
     4 13103         131              13            (((-70.72154 -33.43661, -70.724…
     5 13301         133              13            (((-70.37256 -33.10578, -70.376…
     6 13303         133              13            (((-70.72028 -32.95297, -70.723…
     7 13302         133              13            (((-70.79191 -33.17296, -70.783…
     8 13107         131              13            (((-70.59589 -33.33656, -70.590…
     9 13104         131              13            (((-70.68968 -33.36587, -70.682…
    10 13504         135              13            (((-71.27576 -33.40409, -71.263…
    # ℹ 42 more rows
    # ℹ 1 more variable: nombre_comuna <chr>

Podemos ver que obtuvimos un *dataframe* donde cada fila es una comuna, individualizada por su nombre y su código único territorial (`codigo_comuna`).

En esta tabla de datos, la columna `geometry` contiene la información geográfica de cada comuna, lo que permite visualizarlas como un mapa.

Por lo tanto, en cada fila tenemos información geográfica que representa polígonos comunales, donde cada polígono (o conjuto de polígonos) se corresponde con los datos existentes en las demás columnas, que pueden ser información como sus nombres, su población, o cualquier otra.

Podemos visualizar este mapa de manera sencilla, usando `{ggplot2}`:

``` r
mapa |> 
  ggplot() +
  geom_sf(aes(geometry = geometry),
          fill = "grey60", col = "white") +
  theme_void()
```

<img src="index.markdown_strict_files/figure-markdown_strict/region_prueba-1.png" width="768" />

Obtuvimos un mapa básico de todas las comunas de la Región Metropolitana de Santiago.

Ahora, hagamos una prueba para aprender a visualizar datos en la di este mapa. Para esto, crearemos una nueva variable donde algunas comunas tengan valores distintos. Podemos crear la nueva variable a partir de la columna `nombre_comuna`, aunque siempre es preferible hacerlo en base a la columna `codigo_comuna`, dado que los códigos únicos territoriales son identificadores únicos para cada comuna, mientras que los nombres de las comunas son más impredecibles (por ejemplo, pueden venir sin tilde, pueden venir en mayúsculas, o derechamente mal escritos).

Usamos la función `case_when()` para asignar valores ficticios sobre algunas comunas, y los visualizamos en el mapa:

``` r
mapa_datos <- mapa |> 
  # crear una variable para comunas específicas
  mutate(variable = case_when(nombre_comuna == "Paine" ~ "Bacán",
                              nombre_comuna == "Buin" ~ "Penca",
                              nombre_comuna == "La Florida" ~ "Bacán",
                              nombre_comuna == "Cerrillos" ~ "Bacán",
                              nombre_comuna == "Nunoa" ~ "Penca")) |> 
  select(nombre_comuna, codigo_comuna, variable, geometry)

print(mapa_datos)
```

    # A tibble: 52 × 4
       nombre_comuna codigo_comuna variable                                 geometry
       <chr>         <chr>         <chr>                          <MULTIPOLYGON [°]>
     1 Paine         13404         Bacán    (((-70.61396 -33.73862, -70.60917 -33.7…
     2 Buin          13402         Penca    (((-70.61396 -33.73862, -70.62304 -33.7…
     3 Pudahuel      13124         <NA>     (((-70.75679 -33.38348, -70.78087 -33.4…
     4 Cerro Navia   13103         <NA>     (((-70.72154 -33.43661, -70.72426 -33.4…
     5 Colina        13301         <NA>     (((-70.37256 -33.10578, -70.37609 -33.1…
     6 Tiltil        13303         <NA>     (((-70.72028 -32.95297, -70.72329 -32.9…
     7 Lampa         13302         <NA>     (((-70.79191 -33.17296, -70.7833 -33.18…
     8 Huechuraba    13107         <NA>     (((-70.59589 -33.33656, -70.59023 -33.3…
     9 Conchali      13104         <NA>     (((-70.68968 -33.36587, -70.68201 -33.3…
    10 Maria Pinto   13504         <NA>     (((-71.27576 -33.40409, -71.26337 -33.4…
    # ℹ 42 more rows

``` r
# visualizar
mapa_datos |> 
  ggplot() +
  geom_sf(aes(geometry = geometry, 
              fill = variable), #usamos la variable que creamos como relleno de las comunas
          col = "white") +
  theme_void()
```

<img src="index.markdown_strict_files/figure-markdown_strict/region_fill_manual-1.png" width="768" />

Ahora, pasaremos a usar datos reales sobre nuestro mapa comunal. Pero vez de entregarles datos copiados y pegados, obtendremos directamente los datos desde internet, usando el paquete `{rvest}` que sirve para hacer scraping desde páginas web; es decir, descargar datos presentes en sitios de internet para usarlos directamente en R.

``` r
library(rvest)

tabla_comunas <- session("https://es.wikipedia.org/wiki/Anexo:Comunas_de_Chile") |> # sitio web que scrapearemos
  read_html() |> # leemos el contenido del sitio web 
  html_table() # extraemos las tablas del sitio web

datos_comunas <- tabla_comunas[[1]] |> # elegimos la primera tabla obtenida
  clean_names() |> # limpiamos los nombres de la tabla usando {janitor}
  filter(region == "Metropolitana de Santiago") |> 
  # convertir los códigos comunales a texto
  rename(codigo_comuna = 1) |> 
  mutate(codigo_comuna = as.character(codigo_comuna)) |>
  # limpiar variables numéricas para estén disponibles en formato numérico en vez de como texto
  mutate(poblacion2020 = str_remove(poblacion2020, " "), # borrar espacios
         poblacion2020 = as.numeric(poblacion2020)) |>  # transformar texto a numérico
  # corregir superficie
  mutate(superficie_km2 = str_remove(superficie_km2, "\\."), # borrar puntos separadores de miles
         superficie_km2 = str_replace(superficie_km2, ",", "."), # reemplazar comas por puntos
         superficie_km2 = as.numeric(superficie_km2)) |> # transformar texto a numérico
  # corregir densidad
  mutate(densidad_hab_km2 = str_remove_all(densidad_hab_km2, "\\."), # borrar puntos separadores de miles
         densidad_hab_km2 = str_replace(densidad_hab_km2, ",", "."), # reemplazar comas por puntos
         densidad_hab_km2 = as.numeric(densidad_hab_km2)) # transformar texto a numérico

print(datos_comunas)
```

    # A tibble: 52 × 12
       codigo_comuna nombre      x     provincia region superficie_km2 poblacion2020
       <chr>         <chr>       <lgl> <chr>     <chr>           <dbl>         <dbl>
     1 13101         Santiago    NA    Santiago  Metro…            232        503147
     2 13102         Cerrillos   NA    Santiago  Metro…             21         88956
     3 13103         Cerro Navia NA    Santiago  Metro…             11        142465
     4 13104         Conchalí    NA    Santiago  Metro…            107        139195
     5 13105         El Bosque   NA    Santiago  Metro…            142        172000
     6 13106         Estación C… NA    Santiago  Metro…             15        206792
     7 13107         Huechuraba  NA    Santiago  Metro…            448        112528
     8 13108         Independen… NA    Santiago  Metro…              7        142065
     9 13109         La Cisterna NA    Santiago  Metro…             10        100434
    10 13110         La Florida  NA    Santiago  Metro…            702        402433
    # ℹ 42 more rows
    # ℹ 5 more variables: densidad_hab_km2 <dbl>, idh_2005 <chr>, idh_2005_2 <chr>,
    #   latitud <chr>, longitud <chr>

Así quedó el resultado de nuestro web scraping. A continuación, usamos `left_join()` para adjuntar estas columnas nuevas a nuestro data frame que contiene los nombres y códigos de las comunas, además de la geometría o información geográfica de las comunas, usando como columna de unión los códigos comunales:

``` r
mapa_datos_2 <- mapa |> 
  left_join(datos_comunas, by = "codigo_comuna")

glimpse(mapa_datos_2)
```

    Rows: 52
    Columns: 16
    $ codigo_comuna    <chr> "13404", "13402", "13124", "13103", "13301", "13303",…
    $ codigo_provincia <chr> "134", "134", "131", "131", "133", "133", "133", "131…
    $ codigo_region    <chr> "13", "13", "13", "13", "13", "13", "13", "13", "13",…
    $ geometry         <MULTIPOLYGON [°]> MULTIPOLYGON (((-70.61396 -..., MULTIPOL…
    $ nombre_comuna    <chr> "Paine", "Buin", "Pudahuel", "Cerro Navia", "Colina",…
    $ nombre           <chr> "Paine", "Buin", "Pudahuel", "Cerro Navia", "Colina",…
    $ x                <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ provincia        <chr> "Maipo", "Maipo", "Santiago", "Santiago", "Chacabuco"…
    $ region           <chr> "Metropolitana de Santiago", "Metropolitana de Santia…
    $ superficie_km2   <dbl> 820, 214, 197, 11, 9712, 653, 452, 448, 107, 3935, 69…
    $ poblacion2020    <dbl> 82766, 109641, 253139, 142465, 180353, 21477, 126898,…
    $ densidad_hab_km2 <dbl> 1009.0, 512.3, 1284.9, 12951.3, 185.7, 328.0, 280.7, …
    $ idh_2005         <chr> "0.718", "0.731", "0.735", "0.683", "0.726", "0.709",…
    $ idh_2005_2       <chr> "Alto", "Alto", "Alto", "Medio", "Alto", "Alto", "Med…
    $ latitud          <chr> "-33°48'43.2\"", "-33°43'40.8\"", "-33°26'0\"", "-33°…
    $ longitud         <chr> "-70°43'22.8\"", "-70°44'20.4\"", "-70°43'0\"", "-70°…

Lo que hicimos en la operación anterior fue unir dos tablas distintas en base a una variable común que ambas tablas poseen: `codigo_comuna`. De este modo, obtenemos un nuevo data frame que contiene tanto la información geográfica como los datos comunales que necesitamos.

Habiendo hecho esto, ahora podemos crear gráficos comunales usando cualquier variable que queramos, siempre y cuando podamos hacer coincidir los datos con el mapa en base a los códigos comunales o los nombres de comuna.

#### Mapa comunal de población, Región Metropolitana de Santiago, Chile

``` r
mapa_datos_2 |> 
  ggplot() +
  geom_sf(aes(geometry = geometry, fill = poblacion2020),
          col = "white") +
  viridis::scale_fill_viridis(labels = label_number(big.mark = ".", decimal.mark = ",")) +
  theme_void() +
  labs(fill = "Población")
```

<img src="index.markdown_strict_files/figure-markdown_strict/region_fill_continuo-1.png" width="768" />

#### Mapa comunal del índice de desarrollo humano, Región Metropolitana de Santiago, Chile

``` r
mapa_datos_2 |> 
  ggplot() +
  geom_sf(aes(geometry = geometry, 
              fill = idh_2005_2),
          col = "white") +
  scale_fill_manual(breaks = c("Medio", "Alto", "Muy alto"),
                    values = c("Medio" = "olivedrab4", "Alto" = "olivedrab3", "Muy alto" = "olivedrab2")) +
  geom_sf_text(aes(geometry = geometry, label = nombre_comuna), check_overlap = T, size = 2) +
  theme_void() +
  labs(fill = "IDH")
```

    Warning in st_point_on_surface.sfc(sf::st_zm(x)): st_point_on_surface may not
    give correct results for longitude/latitude data

<img src="index.markdown_strict_files/figure-markdown_strict/region_fill_categorico-1.png" width="768" />

Sin embargo, podemos ver que estos mapas no se ajustan perfectamente a la imagen mental que tiene un ciudadano común acerca de cómo se ve la Región Metropolitana. Por ejemplo, vemos cómo la comuna de San José de Maipo abarca una superficie enorme dado que limita en la cordillera de los Andes con Argentina, o que comunas como Lo Barnechea se expanden hacia superficies cordilleranas de gran extensión.

Esto se debe a que ususalmente nos encontramos frente a mapas que representan el "Gran Santiago", es decir, sólo la superficie urbana de las comunas urbanas de la región, omitiendo sectores rurales, cordilleranos o deshabitados.

Por lo tanto, a continuación veremos cómo obtener un mapa urbano de la Región Metropolitana de Santiago.

## Mapa urbano de la región Metropolitana

En los siguientes pasos, pasaremos de un mapa comunal a un mapa comunal urbano; es decir, un mapa que sólo considere la superficie urbana de las comunas, en vez de la superficie total de las comunas.

Usando `{chilemapas}`, podemos obtener un mapa de la Región Metropolitana con un nivel de detalle mayor, que divide internamente las comunas en superficies más pequeñas que sólo corresponden a zonas urbanas:

``` r
# obtener mapa por zonas rural/urbano
mapa_zonas_urbanas <- chilemapas::mapa_zonas |> 
  filter(codigo_region == 13) |> 
  left_join(chilemapas::codigos_territoriales |> 
      select(matches("comuna")))
```

    Joining with `by = join_by(codigo_comuna)`

``` r
# mapa de zonas urbanas
mapa_zonas_urbanas |> 
  ggplot(aes(geometry = geometry)) +
  geom_sf(fill = "grey60", color = "white") +
  theme_void()
```

<img src="index.markdown_strict_files/figure-markdown_strict/region_zonas-1.png" width="768" />

Podemos mejorar esta visualización uniendo las zonas urbanas intra-comunales en sus respectivas comunas, para volver a obtener un mapa comunal, pero que recorta las comunas para que sólo consideren su la superficie urbana de cada una:

``` r
# mapa de zonas urbanas
mapa_zonas_urbanas |> 
  # unir polígonos por comunas
  group_by(nombre_comuna, codigo_comuna) %>% 
  summarise(geometry = st_union(geometry), .groups = "drop") |>
  # visualizar
  ggplot(aes(geometry = geometry)) +
  geom_sf(fill = "grey60", color = "white") +
  theme_void()
```

<img src="index.markdown_strict_files/figure-markdown_strict/region_zonas_comunas-1.png" width="768" />

De inmediato, podemos ver que emerge una figura más familiar de lo que es el *Gran Santiago,* pero ahora tenemos otro problema: el mapa también contiene las zonas urbanas de comunas menos céntricas de la región, tales como Buin, Curacaví, Talagante y otras. Esto se debe a que nuestro mapa aún contiene comunas que no son mayoritariamente urbanas, dado que poseen sectores despoblados o de actividad agrícola, minera u otras, y que por consiguiente dan una apariencia discontinua a nuestro mapa.

Para resolver esto y dejar sólo las comunas urbanas del Gran Santiago, tenemos varias opciones: podemos filtrar específicamente las comunas que queremos, o bien, podemos filtrar en base a privincias, dejando sólo las provincias Santiago y Cordillera.

#### Mapa urbano de la región Metropolitana (comunas exactas)

**Opción 1:** seleccionar específicamente las comunas que queremos incluir:

``` r
comunas_urbanas <- c("Pudahuel", "Cerro Navia", "Conchali", "La Pintana", "El Bosque", 
                     "Estacion Central", "Pedro Aguirre Cerda", "Recoleta", "Independencia", 
                     "La Florida", "Penalolen", "Las Condes", "Lo Barnechea", "Quinta Normal", 
                     "Maipu", "Macul", "Nunoa", "Puente Alto", "Quilicura", "Renca", 
                     "San Bernardo", "San Miguel", "La Granja", "Providencia", "Santiago",
                     "San Joaquin", "Lo Espejo", "La Reina", "San Ramon", "La Cisterna", 
                     "Lo Prado", "Cerrillos", "Vitacura", "Huechuraba",
                     "San Jose de Maipo")

# mapa de sectores urbanos, de comunas urbanas
mapa_zonas_urbanas |> 
  # filtrar comunas urbanas
  filter(nombre_comuna %in% comunas_urbanas) |>
  # unir polígonos por comunas
  group_by(nombre_comuna, codigo_comuna) %>% 
  summarise(geometry = st_union(geometry)) |> 
  # graficar
  ggplot(aes(geometry = geometry)) +
  geom_sf(fill = "grey60", color = "white") +
  theme_void()
```

    `summarise()` has grouped output by 'nombre_comuna'. You can override using the
    `.groups` argument.

<img src="index.markdown_strict_files/figure-markdown_strict/region_urbano_opcion1-1.png" width="768" />

#### Mapa urbano de la región Metropolitana (provincias Santiago y Cordillera)

**Opción 2:** seleccionar las dos provincias que conforman el Gran Santiago, y agregar los ajustes que sean necesarios (incluir San Bernardo, excluir Pirque)

``` r
mapa_zonas_urbanas |> 
  # dejar solo dos provincias, incluir San Bernardo y sacar Pirque
  filter(codigo_provincia %in% c(131, 132) | nombre_comuna == "San Bernardo", nombre_comuna != "Pirque") |>
  # unir polígonos por comunas
  group_by(nombre_comuna, codigo_comuna) %>% 
  summarise(geometry = st_union(geometry)) |> 
  # graficar
  ggplot(aes(geometry = geometry)) +
  geom_sf(fill = "grey60", color = "white") +
  theme_void()
```

    `summarise()` has grouped output by 'nombre_comuna'. You can override using the
    `.groups` argument.

<img src="index.markdown_strict_files/figure-markdown_strict/region_urbano_opcion2-1.png" width="768" />

La decisión que tomes depende de los objetivos del usuario y de tu visualzación, pero dejo ambas aproximaciones a modo de aprendizaje.

Luego de haber seleccionado las comunas urbanas que necesitamos, notamos que aún quedan algunas "islas urbanas" fuera de la zona principal del Gran Santiago. Usualmente vemos los mapas del Gran Santiago como una sola unidad geográfica contínua, sin separaciones ni islas a su alrededor. Por lo tanto, vamos a eliminar estos elementos externos a la superficie urbana contínua de forma manual.

Para identificar los polígonos que queramos remover, podemos visualizar una fracción del mapa y agregar etiquetas para dar con sus códigos geográficos, y así poder excluirlos. Por ejemplo, aquí lo haremos con Pudahuel:

``` r
mapa_zonas_urbanas |>
  filter(nombre_comuna == "Pudahuel") |>
  ggplot(aes(geometry = geometry)) +
  geom_sf(fill = "lightblue", color = "white") +
  geom_sf_text(aes(label = geocodigo), color = "black", size = 3)
```

    Warning in st_point_on_surface.sfc(sf::st_zm(x)): st_point_on_surface may not
    give correct results for longitude/latitude data

<img src="index.markdown_strict_files/figure-markdown_strict/prueba_islas-1.png" width="768" />

Bastaría con anotar los geocódigos para filtrarlos.

Entonces, en el siguiente paso removeremos estas pequeñas zonas urbanas de forma manual para obtener un mapa más contínuo.

``` r
# vector con geocódigos que deseamor remover
islas_urbanas <- c("13124071004", "13124071005", "13124081001", "13124071001", "13124071002", "13124071003", #Pudahuel
                           "13401121001", #San Bernardo
                           "13119131001", #Maipú
                           "13203031000", "13203031001", "13203031002", "13203011001", "13203011002" #San José de Maipo
                           )

# crear nuevo mapa
mapa_urbano <- mapa_zonas_urbanas |> 
  # filtrar solo comunas urbanas
  filter(nombre_comuna %in% comunas_urbanas) |>
  # filtrar islas urbanas
  filter(!geocodigo %in% islas_urbanas) |>
  # unir comunas
  group_by(nombre_comuna, codigo_comuna) %>%
  summarise(geometry = st_union(geometry)) |>
  ungroup()
```

    `summarise()` has grouped output by 'nombre_comuna'. You can override using the
    `.groups` argument.

``` r
  # simplificar bordes del mapa (opcional)
  # mutate(geometry = rmapshaper::ms_simplify(geometry,  keep = 0.4))

# graficar
mapa_urbano |> 
  ggplot(aes(geometry = geometry)) +
  geom_sf(fill = "blueviolet", color = "white") +
  theme_void()
```

<img src="index.markdown_strict_files/figure-markdown_strict/remover_islas-1.png" width="768" />

De esta forma ya logramos graficar un mapa del Gran Santiago mucho más definido y limpio.

Teniendo este mapa, procedemos a visualizar nuestros datos tal como hicimos al principio de este tutorial:

``` r
# volvemos a adjuntar los datos que descargamos usando web scraping, esta vez al mapa nuevo
mapa_urbano_2 <- mapa_urbano |> 
  left_join(datos_comunas, by = "codigo_comuna")

mapa_urbano_2 |> 
  ggplot() +
  geom_sf(aes(geometry = geometry, fill = densidad_hab_km2),
          col = "white") +
  viridis::scale_fill_viridis(labels = label_number(big.mark = ".", decimal.mark = ","),
                              option = "magma") +
  theme_void() +
  labs(fill = "Densidad poblacional")
```

<img src="index.markdown_strict_files/figure-markdown_strict/region_urbana_fill_continuo-1.png" width="768" />

Finalmente, podemos poner nuestro nuevo mapa urbano de la Región Metropolitana de Santiago sobre el mapa de la región completa:

``` r
ggplot() +
  geom_sf(data = mapa,
          aes(geometry = geometry), 
          fill = "grey95", color = "white", linewidth = 0.5) +
  geom_sf(data = mapa_urbano_2,
          aes(geometry = geometry, fill = poblacion2020),
          color = "white", linewidth = 0.2) +
  viridis::scale_fill_viridis(labels = label_number(big.mark = ".", decimal.mark = ","), 
                              option = "mako") +
  theme_void() +
  labs(fill = "Población") +
  guides(fill = guide_colourbar(position = "inside")) +
  theme(legend.position.inside = c(.1, .7),
        legend.key.width = unit(3, "mm"),
        legend.key.height = unit(10, "mm"),
        legend.ticks.length = unit(0.4, "mm"))
```

<img src="index.markdown_strict_files/figure-markdown_strict/region_urbana_fill_continuo_contexto-1.png" width="768" />

``` r
# ggplot() +
#   geom_sf(data = mapa,
#           aes(geometry = geometry), 
#           fill = "grey90", color = "white", linewidth = 0.4) +
#   geom_sf(data = mapa_urbano_2,
#           aes(geometry = geometry, fill = poblacion2020),
#           color = "white", linewidth = 0.2) +
#   coord_sf(xlim = c(-70.95, -70.3), ylim = c(-33.86, -33.13), expand = F) +
#   viridis::scale_fill_viridis(labels = label_number(big.mark = ".", decimal.mark = ","), 
#                               option = "mako") +
#   theme_void() +
#   labs(fill = "Población") +
#   theme(legend.position.inside = c(.5, .08),
#         legend.direction = "horizontal", 
#         legend.key.width = unit(15, "mm"), 
#         legend.key.height = unit(3, "mm"), legend.ticks = element_blank(), legend.title.position = "top")
```

------------------------------------------------------------------------

**Bastián Olea Herrera**

Analista de datos, magíster en Sociología (PUC)

<http://bastian.olea.biz>

[Ver más recursos de aprendizaje de R y visualizadores de datos sociales de código abierto programados en R](%5Bhttps://bastianolea.github.io/shiny_apps/)
