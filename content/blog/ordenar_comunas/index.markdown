---
title: Ordenar las comunas de Chile de norte a sur en R
author: Bastián Olea Herrera
date: '2025-06-25'
slug: []
categories: []
format: 
  hugo-md:
    fig-height: 10
tags:
  - mapas
  - Chile

---



Complementando el [post sobre ordenar regiones de Chile de norte a sur](/blog/ordenar_regiones/), en esta publicación veremos cómo ordenar las comunas del país de norte a sur. Esto puede servirnos para mostrar datos a nivel comunal de una gran cantidad de regiones de una manera más intuitiva, en los casos donde ordenarlas por orden alfabético no entrega mucha información, o cuando queramos mostrar en nuestras visualizaciones o tablas que el factor geográfico incide en el dato principal.

Partamos con una tabla de datos de varias comunas del país. Es necesario que estas comunas cuenten con su [**código único territorial**](https://www.subdere.gov.cl/documentacion/códigos-únicos-territoriales-actualizados-al-06-de-septiembre-2018), el códgo numérico que identifica de manera única a cada región del país. Si tu base de datos no tiene los códigos únicos territoriales, tendrás que realizar una unión entre los nombres de las comunas y los códigos, que [puedes encontrar en `csv` y `rds` en este respositorio.](https://github.com/bastianolea/cut_comunas).




``` r
library(dplyr)

comunas <- tibble::tribble(
                ~nombre_comuna, ~codigo_comuna,
                    "Rancagua",           6101,
                "San Fernando",           6301,
                   "Coyhaique",          11101,
                  "La Pintana",          13112,
                       "Rengo",           6115,
                "Puerto Montt",          10101,
         "San Pedro de la Paz",           8108,
               "Alto Hospicio",           1107,
                     "Chillán",          16101,
                       "Angol",           9201,
                  "Talcahuano",           8110,
                      "Calama",           2201,
                  "Concepción",           8101,
                     "Hualpén",           8112,
                   "La Serena",           4101,
                      "Calera",           5502,
                    "Valdivia",          14101,
                 "Cerro Navia",          13103,
                       "Lampa",          13302,
               "Quinta Normal",          13126,
                  "Huechuraba",          13107,
                     "Linares",           7401,
                        "Tomé",           8111,
                "Viña del Mar",           5109,
                    "Recoleta",          13127,
                   "Talagante",          13601,
                  "Valparaíso",           5101,
                     "Coronel",           8102,
                        "Buin",          13402,
                       "Macul",          13118,
                "Punta Arenas",          12101,
                       "Talca",           7101,
                 "Los Ángeles",           8301,
                 "Puente Alto",          13201,
                     "Copiapó",           3101,
                      "Curicó",           7301,
                    "Coquimbo",           4102,
                   "Melipilla",          13501,
                    "Vitacura",          13132,
                 "Antofagasta",           2101,
                 "Chiguayante",           8103,
                       "Renca",          13128,
                   "Quilicura",          13125,
         "Pedro Aguirre Cerda",          13121,
                      "Ovalle",           4301,
                "San Bernardo",          13401,
                   "Los Andes",           5301,
                 "San Joaquín",          13129,
                      "Colina",          13301,
                    "Quillota",           5501,
                   "Peñalolén",          13122,
            "Estación Central",          13106,
                   "San Ramón",          13131,
                    "Lo Prado",          13117,
                       "Arica",          15101,
                 "San Antonio",           5601,
                   "Cerrillos",          13102,
                    "Santiago",          13101,
                "Lo Barnechea",          13115,
                      "Temuco",           9101,
                  "La Florida",          13110,
                  "San Felipe",           5701,
                       "Ñuñoa",          13120,
                 "La Cisterna",          13109,
                     "Machalí",           6108,
               "Independencia",          13108,
                   "La Granja",          13111,
               "Villa Alemana",           5804,
                  "San Miguel",          13130,
                  "Las Condes",          13114,
                   "Lo Espejo",          13116,
                     "Quilpué",           5801,
                    "Conchalí",          13104,
                    "Peñaflor",          13605,
                   "El Bosque",          13105,
                       "Maipú",          13119,
                    "La Reina",          13113,
                    "Pudahuel",          13124,
                 "Providencia",          13123,
               "Padre Hurtado",          13604,
                     "Iquique",           1101,
                      "Osorno",          10301
         )
```



Puedes copiar y pegar este código para obtener en tu sesión de R la tabla con comunas. Si ejecutamos esta tabla de datos, veremos que las regiones no están ordenadas geográficamente:




``` r
comunas
```

```
## # A tibble: 82 × 2
##    nombre_comuna       codigo_comuna
##    <chr>                       <dbl>
##  1 Rancagua                     6101
##  2 San Fernando                 6301
##  3 Coyhaique                   11101
##  4 La Pintana                  13112
##  5 Rengo                        6115
##  6 Puerto Montt                10101
##  7 San Pedro de la Paz          8108
##  8 Alto Hospicio                1107
##  9 Chillán                     16101
## 10 Angol                        9201
## # ℹ 72 more rows
```



Si hacemos un gráfico con estas comunas, veremos que el orden del eje con las comunas será alfabético, dado que las comunas son una variable de tipo carácter o texto:




``` r
library(ggplot2)

comunas |> 
  ggplot() +
  aes(codigo_comuna, nombre_comuna, fill = codigo_comuna) +
  geom_col() +
  theme_minimal() +
  scale_x_continuous(expand = c(0, 0))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-1.png" width="672" />



Tampoco nos serviría ordenarla por los códigos únicos territoriales, dado que éstos empiezan con el código de las regiones, y [como vimos en el otro post,](/blog/ordenar_regiones/) los códigos regionales no ordenan geográficamente las regiones, y menos a las comunas.

Una forma de **ordenar las comunas de Chile geográficamente de norte a sur** es valiéndonos de la geografía vertical del país. Podemos obtener un mapa de Chile con el paquete `{chilemapas}`, y luego **extraer la latitud** de las comunas, para usarla como variable de ordenamiento de las comunas.

La función `chilemapas::mapa_comunas` de `{chilemapas}` nos entrega un dataframe con los datos geográficos del país a nivel comunal.



``` r
library(dplyr)
library(chilemapas)
```

```
## Loading required package: sf
```

```
## Linking to GEOS 3.13.0, GDAL 3.8.5, PROJ 9.5.1; sf_use_s2() is TRUE
```

```
## La documentacion del paquete y ejemplos de uso se encuentran en https://pacha.dev/chilemapas/.
## Visita https://buymeacoffee.com/pacha/ si deseas donar para contribuir al desarrollo de este software.
```

``` r
# obtener mapa
mapa_chile <- chilemapas::mapa_comunas |> 
  mutate(codigo_comuna = as.numeric(codigo_comuna)) |> 
  select(codigo_comuna, geometry)

mapa_chile
```

```
## # A tibble: 345 × 2
##    codigo_comuna                                                        geometry
##            <dbl>                                              <MULTIPOLYGON [°]>
##  1          1401 (((-68.86081 -21.28512, -68.92172 -21.30035, -68.98939 -21.317…
##  2          1403 (((-68.65113 -19.77188, -68.81182 -19.74362, -68.81575 -19.733…
##  3          1405 (((-68.65113 -19.77188, -68.63545 -19.78062, -68.62511 -19.785…
##  4          1402 (((-69.31789 -19.13651, -69.2717 -19.23735, -69.14291 -19.2967…
##  5          1404 (((-69.39615 -19.06125, -69.40025 -19.06897, -69.40296 -19.071…
##  6          1107 (((-70.1095 -20.35131, -70.12438 -20.31578, -70.10985 -20.2743…
##  7          1101 (((-70.09894 -20.08504, -70.1023 -20.11401, -70.12001 -20.1551…
##  8          2104 (((-68.98863 -25.38016, -68.98731 -25.38411, -68.98696 -25.393…
##  9          2101 (((-70.60654 -23.43054, -70.60175 -23.43515, -70.60133 -23.438…
## 10          2201 (((-67.94302 -22.38175, -67.95564 -22.39233, -67.96315 -22.393…
## # ℹ 335 more rows
```



A partir de este mapa, usamos el paquete `{sf}` para extraer los **centroides** de las comunas, que son el punto central de la geometría de cada polígono. Luego, a partir del centroide podemos obtener la **latitud** de estos puntos, para ver qué tan al norte o sur está cada comuna.



``` r
library(sf)

# extraer latitud desde los polígonos comunales
mapa_chile_latitud <- mapa_chile |> 
  mutate(centroide = st_centroid(geometry),
         longitud = sf::st_coordinates(centroide)[,1],
         latitud = sf::st_coordinates(centroide)[,2])
  
mapa_chile_latitud
```

```
## # A tibble: 345 × 5
##    codigo_comuna                     geometry             centroide longitud
##            <dbl>           <MULTIPOLYGON [°]>           <POINT [°]>    <dbl>
##  1          1401 (((-68.86081 -21.28512, -68… (-69.50811 -20.77126)    -69.5
##  2          1403 (((-68.65113 -19.77188, -68… (-68.84517 -19.35443)    -68.8
##  3          1405 (((-68.65113 -19.77188, -68… (-68.91311 -20.48006)    -68.9
##  4          1402 (((-69.31789 -19.13651, -69… (-69.50102 -19.36999)    -69.5
##  5          1404 (((-69.39615 -19.06125, -69… (-69.66358 -19.60151)    -69.7
##  6          1107 (((-70.1095 -20.35131, -70.… (-70.01261 -20.18971)    -70.0
##  7          1101 (((-70.09894 -20.08504, -70… (-70.04836 -20.92498)    -70.0
##  8          2104 (((-68.98863 -25.38016, -68…  (-69.8618 -25.30966)    -69.9
##  9          2101 (((-70.60654 -23.43054, -70… (-69.40757 -24.27784)    -69.4
## 10          2201 (((-67.94302 -22.38175, -67… (-68.62665 -22.16826)    -68.6
## # ℹ 335 more rows
## # ℹ 1 more variable: latitud <dbl>
```



Con esto podemos simplemente ordenar por latitud y generar un orden numérico del 1 al 345.




``` r
orden_comunas <- mapa_chile_latitud |> 
  arrange(desc(latitud), longitud) |> 
  mutate(orden_comuna = row_number()) |> 
  select(codigo_comuna, orden_comuna)

orden_comunas
```

```
## # A tibble: 345 × 2
##    codigo_comuna orden_comuna
##            <dbl>        <int>
##  1         15202            1
##  2         15201            2
##  3         15101            3
##  4         15102            4
##  5          1403            5
##  6          1402            6
##  7          1404            7
##  8          1107            8
##  9          1405            9
## 10          1401           10
## # ℹ 335 more rows
```


Obtenemos una tabla con los códigos únicos territoriales y la latitud de cada comuna. Ahora podemos unir estas columnas con nuestros datos usando `left_join()`:




``` r
# a los datos originales, agregarle la tabla con el orden de las comunas
comunas_ordenadas <- comunas |> 
  left_join(orden_comunas, join_by(codigo_comuna)) |> 
  # ordenar observaciones
  arrange(orden_comuna)

comunas_ordenadas
```

```
## # A tibble: 82 × 3
##    nombre_comuna codigo_comuna orden_comuna
##    <chr>                 <dbl>        <int>
##  1 Arica                 15101            3
##  2 Alto Hospicio          1107            8
##  3 Iquique                1101           11
##  4 Calama                 2201           15
##  5 Antofagasta            2101           19
##  6 Copiapó                3101           25
##  7 La Serena              4101           32
##  8 Coquimbo               4102           34
##  9 Ovalle                 4301           38
## 10 San Felipe             5701           56
## # ℹ 72 more rows
```



Intentamos nuevamente con el gráfico a ver cómo sale:




``` r
# intento incorrecto de gráfico ordenado
comunas_ordenadas |> 
  arrange(orden_comuna) |> 
  ggplot() +
  aes(x = codigo_comuna,
      y = nombre_comuna, 
      fill = codigo_comuna) +
  geom_col() +
  theme_minimal() +
  guides(fill = guide_none()) +
  scale_x_continuous(expand = c(0, 0))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" width="672" />



Al igual como nos pasó con el [ordenamiento de regiones](/blog/ordenar_regiones/), la variable `nombre_comuna` es una variable de texto (tipo caracter) y que no tiene un orden intrínseco, así que se asume que su orden es alfabético. Por lo tanto, tenemos que darle un orden a esta variable, convirtiéndola a factor con el orden de una segunda variable numérica usando `fct_reorder()`; en otras palabras, darle a `nombre_comuna` el orden que tiene la variable numérica `orden_comuna`:




``` r
library(forcats)

# ordenar variable a partir de una segunda variable numérica
comunas_ordenadas_2 <- comunas_ordenadas |> 
  mutate(nombre_comuna = fct_reorder(nombre_comuna, 
                                     orden_comuna, 
                                     .desc = T)) 
```



Ahora si repetimos el mismo gráfico que antes, vemos que el orden de las comunas ahora sí es geográfico! Arica está arriba y Punta Arenas abajo, como corresponde.




``` r
# crear un gráfico
comunas_ordenadas_2 |> 
  ggplot() +
  aes(x = orden_comuna,
      y = nombre_comuna, 
      fill = orden_comuna) +
  geom_col() +
  theme_minimal() +
  guides(fill = guide_none()) +
  scale_x_continuous(expand = c(0, 0))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-10-1.png" width="672" />



Aparecen visualmente de norte a sur (de arriba a abajo) porque al ordenarlas le pusimos un orden descendiente (`.desc = TRUE`), y ésto es necesario porque generalmente en los gráficos el origen o inicio de los ejes es en 1 y el valor de la variable aumenta a medida que se aleja del origen.
