---
title: Gráficos para identificar datos outliers o anómalos en R
author: Bastián Olea Herrera
date: '2025-06-18'
slug: []
categories: []
format:
  hugo-md:
    output-file: "index"
    output-ext: "md"
tags:
  - limpieza de datos
  - ggplot2
  - gráficos
  - visualización de datos
  - estadística
excerpt: Los datos anómalos o _outliers_ son datos que se alejan considerablemente de los demás. Crearemos un dataset simulando datos outliers y luego mostraremos algunas formas de visualizarlos en `{ggplot2}`, incluyendo un gráfico interactivo con `{ggiraph}` donde podemos poner el cursor sobre las observaciones del gráfico para obtener más información.
---

<link href="{{< blogdown/postref >}}index_files/htmltools-fill/fill.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/htmlwidgets/htmlwidgets.js"></script>
<script src="{{< blogdown/postref >}}index_files/d3-bundle/d3-bundle.min.js"></script>
<script src="{{< blogdown/postref >}}index_files/d3-lasso/d3-lasso.min.js"></script>
<script src="{{< blogdown/postref >}}index_files/save-svg-as-png/save-svg-as-png.min.js"></script>
<script src="{{< blogdown/postref >}}index_files/flatbush/flatbush.min.js"></script>
<link href="{{< blogdown/postref >}}index_files/ggiraphjs/ggiraphjs.min.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/ggiraphjs/ggiraphjs.min.js"></script>
<script src="{{< blogdown/postref >}}index_files/girafe-binding/girafe.js"></script>

Los datos anómalos o *outliers* son datos que se alejan considerablemente de los demás. Estos datos pueden resultar problemáticos para ciertos análisis, pueden ser indicio de errores en la recolección o limpieza de datos, o pueden requerir que tomemos ciertas decisiones para corregirlos o excluirlos.

En este post crearemos un dataset con datos outliers y luego mostraremos algunas formas de visualizarlos [en `{ggplot2}`](/tags/ggplot2/) para tomar decisiones al respecto. Al final crearemos un gráfico interactivo [con `{ggiraph}`](https://davidgohel.github.io/ggiraph/) que permita poner el cursor sobre las observaciones para obtener más información.

------------------------------------------------------------------------

Primero creemos un conjunto de datos que contenga números al azar, 90 números entre 1 y 100, y 10 números más grandes, para que sean nuestros outliers simulados:

``` r
library(dplyr)
library(ggplot2)

set.seed(1993)

valor <- c(sample(1:100, size = 90), # números al azar
           sample(120:190, size = 10)) # outliers
```

Obtenemos un vector con los dos conjuntos de números al azar.

Con la función `tibble()` convertimos el vector en una columna de un dataframe nuevo, y usando nuevamente `sample()` crearemos dos columnas con palabras al azar para complementar estos datos simulados:

``` r
datos <- tibble(valor) |> 
  # procesar por fila
  rowwise() |> 
  # por fila, elegir tres sílabas al azar y unirlas en un texto
  mutate(nombre = sample(c("ma", "pa", "che", "cha"), 3, F) |> paste(collapse = "")) |> 
  # desagrupar y creat otra columna que distribuya los datos en tres grupos
  ungroup() |>
  mutate(grupo = sample(c("ma", "pa", "che"), n(), T))

datos
```

    ## # A tibble: 100 × 3
    ##    valor nombre   grupo
    ##    <int> <chr>    <chr>
    ##  1    45 chapache pa   
    ##  2    95 chechapa ma   
    ##  3    83 chamapa  ma   
    ##  4    92 mapache  pa   
    ##  5    40 chamache che  
    ##  6    42 pachama  pa   
    ##  7    75 mapacha  che  
    ##  8    65 machepa  che  
    ##  9    55 chachema che  
    ## 10    18 chapama  che  
    ## # ℹ 90 more rows

Para identificar los *outliers*, utilizaremos el criterio del rango intercuartílico. El rango intercuartílico es el rango de los datos entre el primer y tercer cuartil (el percentil 25 y el percentil 75; es decir, la diferencia entre el dato ubicado en el 75% mayor y el 25% mayor de la distribución de los datos). Luego, este valor se multiplica por 1,5, y se suma al valor del tercer cuartil (percentil 75), de modo que se identifiquen como *outliers* los datos que sean mayores al tercer cuartil más 1,5 veces el rango intercuartílico.

``` r
datos_outliers <- datos |> 
  mutate(umbral = quantile(valor, 0.75) + 1.5 * IQR(valor))
```

Esto nos dará una cifra que operará como el umbral respecto del cual, si un valor es mayor a esta cifra, se clasificará como outlier. Es conveniente calcular este umbral dentro del dataframe, porque si queremos calcular outliers desagregados por otra variable, simplemente mantenemos la fórmula y agregamos antes un `group_by()` para realizar el cálculo por grupos.

Crearemos una columna que simplemente nos diga si los valores son mayores o menores al umbral:

``` r
datos_outliers <- datos_outliers |> 
  mutate(outlier = valor >= umbral)

datos_outliers
```

    ## # A tibble: 100 × 5
    ##    valor nombre   grupo umbral outlier
    ##    <int> <chr>    <chr>  <dbl> <lgl>  
    ##  1    45 chapache pa       167 FALSE  
    ##  2    95 chechapa ma       167 FALSE  
    ##  3    83 chamapa  ma       167 FALSE  
    ##  4    92 mapache  pa       167 FALSE  
    ##  5    40 chamache che      167 FALSE  
    ##  6    42 pachama  pa       167 FALSE  
    ##  7    75 mapacha  che      167 FALSE  
    ##  8    65 machepa  che      167 FALSE  
    ##  9    55 chachema che      167 FALSE  
    ## 10    18 chapama  che      167 FALSE  
    ## # ℹ 90 more rows

Obtenemos la variable `outlier` con `TRUE` si es outlier, y `FALSE` si no lo es.

Ahora vamos a visualizar estos datos con el paquete `{ggplot2}`. Si necesitas una introducción a esta librería de visualización de datos, [te recomiendo revisar este tutorial](/blog/r_introduccion/tutorial_visualizacion_ggplot/), donde explicamos en mayor detalle varias de estas visualizaciones.

## Gráfico de cajas o *boxplot*

El *boxplot* es una visualización que en su mismo diseño incluye la opción de mostrar los outliers, así que se trata de la opción natural para este tipo de visualizaciones exploratorias. Así que con esto concluye este tutorial. Bromita 🥰

``` r
datos_outliers |> 
  ggplot() +
  aes(x = valor, y = 1) +
  # gráfico de boxplot
  geom_boxplot(alpha = 0.4, fill = "black", 
               outlier.color = "#F94C6A", outlier.size = 4, outlier.alpha = 0.7) + # configuración de outliers
  # temas
  theme_minimal() +
  scale_y_continuous(expand = expansion(c(0.5, 0.5))) # aumentar margen del eje vertical
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" width="768" />

En un *boxplot*, los puntos al extremo de la caja representan los casos anómalos.

Pero la gracia de este tutorial es entrenar nuestras capacidades de visualización de datos, así que veamos otras formas de visualizarlos:

## Gráfico de puntos

Una forma sencilla de visualizar outliers sería simplemente visualizar las observaciones del dataser como puntos, coloreando los puntos si son outliers.

``` r
datos_outliers |> 
  ggplot() +
  aes(x = valor, y = 1, color = outlier) +
  # gráfico de puntos
  geom_point(size = 4, alpha = 0.6) +
  # escala de colores
  scale_color_manual(values = c("black", "#F94C6A")) +
  # temas
  theme_minimal() +
  # ocultar leyenda
  guides(color = guide_none(),
         y =  guide_none())
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-6-1.png" width="1152" />

### Puntos con dispersión

Como existe una concentración densa en parte de la distribución, podemos usar la función `geom_jitter()` para que los puntos se dispersen verticalmente (`width = 0`, porque si se dispersan horizontalmente se ubicarían incorrectamente con respecto a su valor)

``` r
datos_outliers |> 
  ggplot() +
  aes(x = valor, y = 1, color = outlier) +
  # gráfico de puntos con dispersión
  geom_jitter(size = 4, alpha = 0.6, width = 0) +
  scale_color_manual(values = c("black", "#F94C6A")) +
  theme_minimal() +
  guides(color = guide_none(),
         y =  guide_none())
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-7-1.png" width="672" />

## Gráfico de violín

El gráfico de violín también nos permite observar la distribución de los datos, pero por sí solo no nos muestra las observaciones exactas, por lo que no entrega información certera sobre los outliers, sino que nos da indicios de que la distribución de los datos tiene *colas* que podrían contener outliers.

``` r
datos_outliers |> 
  ggplot() +
  aes(x = valor, y = 1) +
  # gráfico de violín
  geom_violin(fill = "black", alpha = 0.4) +
  theme_minimal() +
  guides(y =  guide_none()) # ocultar eje y
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" width="672" />

## Combinar visualizaciones

Una buena opción es combinar las visualizaciones anteriores en una sola. De fondo podemos poner la distribución de los datos con `geom_violin()`, y encima poner los puntos de las observaciones; para las observaciones normales podemos usar `geom_jitter()` para dispersar los datos, y para los outliers, como son poquitos, `geom_point()` para que se ubiquen en concordancia con la distribución del violín.

``` r
grafico_outliers <- datos_outliers |> 
  ggplot() +
  aes(x = valor, y = 1, color = outlier) +
  # gráfico de violín
  geom_violin(aes(y = 1, x = valor), 
              inherit.aes = F,
              alpha = 0.2, lwd = 0.1, fill = "black") +
  # puntos para los outliers
  geom_point(data = ~filter(.x, outlier), # sólo para observaciones que son outlier
             size = 4, alpha = 0.6) +
  # puntos dispersados para el resto de los datos
  geom_jitter(data = ~filter(.x, !outlier), # sólo para observaciones que no son outlier
              size = 4, alpha = 0.6) +
  # escala de colores
  scale_color_manual(values = c("black", "#F94C6A")) +
  # temas
  theme_minimal() +
  theme(axis.title = element_blank()) +
  guides(color = guide_none(),
         y =  guide_none()) +
  scale_y_continuous(expand = expansion(c(0.2, 0.2))) # aumentar margen del eje vertical

grafico_outliers
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-9-1.png" width="672" />

Para combinar estas visualizaciones, aprovechamos la capacidad de `{ggplot2}` de especificar los datos que se usan en cada capa o geometría de la visualización por medio del argumento `data`. Normalmente, el argumento `data` se rellena por defecto con los datos que entregamos a la función `ggplot()`, pero si especificamos el argumento podemos hacer que cada capa use datos completamente distintos. En nuestro caso, no queremos datos distintos, sino **aplicar filtros a los datos de cada capa**, lo que se logra con `data = ~filter(.x, ...)`[^1], donde `...` sería el filtro que necesitemos. En la visualización anterior, queremos que `geom_point()` sólo muestre los datos que son `outlier == FALSE`, y que `geom_jitter()` sólo muestre los datos que son `outlier == TRUE`[^2].

``` r
data = ~filter(.x, outlier)
```

### Etiquetas de texto

Al identificar outliers, una buena opción es mostrar etiquetas de texto para estos casos con `geom_text()`. De este modo podemos identificar exactamente a qué observaciones corresponden las anomalías. En el caso de que fueran muchas etiquetas, podemos usar `geom_text_repel()` para que las etiquetas se muevan si es que caen encima de otras.

``` r
library(ggrepel)

grafico_outliers <- grafico_outliers + 
  # agregar texto al gráfico anterior
  ggrepel::geom_text_repel(data = ~filter(.x, outlier), # sólo para observaciones que son outlier
                  aes(label = nombre), # variable con el texto a mostrar
                  fontface = "bold", size = 4, point.padding = 4, angle = 90, hjust = 0) 

grafico_outliers
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-11-1.png" width="672" />

Ahora sabemos que *mapacha, pachache, chepama* y *chachema* son outliers 🤨

### Dividir por grupos

Otra forma de afinar el análisis es separar la visualización en los valores de la variable de agrupación que tengamos con `facet_wrap()`. En este caso, como la variable `grupo` tiene 3 valores posibles, se multiplica la visualización por tres.

``` r
grafico_outliers <- grafico_outliers +
  # separar gráfico en facetas según la variable grupo
  facet_wrap(~grupo, ncol = 1, scales = "fixed") +
  theme(strip.text = element_text(face = "bold")) # título de facetas en negrita

grafico_outliers
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-12-1.png" width="672" />

## Gráfico interactivo

Para mejorar la exploración de los datos podemos convertir fácilmente cualquier gráfico de `{ggplot2}` en gráficos interactivos gracias [al paquete `{ggiraph}`](https://davidgohel.github.io/ggiraph/). Principalmente, lo que agregaremos son *tooltips* o cajas emergentes que aparecerán cuando se pose el cursor sobre un punto del gráfico y que muestren información extra.

Con `{ggiraph}` solamente se requieren cambios mínimos para volver interactivo caulquier gráfico. Entre ellos es agregar `_interactive` a las funciones que crean las geometrías del gráfico:

- Pasar de `geom_point()` a `geom_point_interactive()`
- Pasar de `geom_jitter()` a `geom_jitter_interactive()`

Habiendo hecho este cambio, dentro de las geometrías `geom_x_interactive()` podemos definir la estética `tooltip` dentro de `aes()` para especificar el contenido que aparecerá cuando se ponga el cursor sobre los elementos del gráfico. En este caso, haremos que los *tooltips* muestren el nombre de la observación y su valor, y la palabra *outlier* si corresponde.

Copiamos el código anterior y hacemos los cambios apropiados al gráfico:

``` r
library(ggiraph)

grafico_outliers_interactivo <- datos_outliers |> 
  ggplot() +
  aes(x = valor, y = 1, color = outlier) +
  geom_violin(aes(y = 1, x = valor), 
              inherit.aes = F,
              alpha = 0.2, lwd = 0.1, fill = "black") +
  # puntos para los outliers
  ggiraph::geom_point_interactive(data = ~filter(.x, outlier), 
                         aes(tooltip = paste("outlier: ", valor, sep = "")), # texto "outlier" con el valor
                         size = 4, alpha = 0.6) +
  # puntos dispersados para el resto de los datos
  ggiraph::geom_jitter_interactive(data = ~filter(.x, !outlier), 
                          aes(tooltip = paste(nombre, ": ", valor, sep = "")), # nombre de observación y valor
                          size = 4, alpha = 0.6) +
  ggrepel::geom_text_repel(data = ~filter(.x, outlier),
                  aes(label = nombre),
                  fontface = "bold", size = 4, point.padding = 4, angle = 90, hjust = 0) +
  scale_color_manual(values = c("black", "#F94C6A")) +
  theme_minimal() +
  theme(axis.title = element_blank()) +
  guides(color = guide_none(),
         y =  guide_none()) +
  scale_y_continuous(expand = expansion(c(0.2, 0.2))) # aumentar margen del eje vertical
```

Finalmente, para permitir la interactividad del gráfico, debemos generarlo con la función `girafe()`, la cual recibe el objeto con el gráfico además de varias opciones para personalizar la visualización:

``` r
girafe(ggobj = grafico_outliers_interactivo, 
       # dimensiones del gráfico
       width_svg = 9, height_svg = 4,
       # opciones para los tooltips
       options = list(
         # ocultar barra de opciones
         opts_toolbar(hidden = "selection", saveaspng = FALSE),
         # personalizar la apariencia del tooltip
         opts_tooltip(opacity = 0.7, use_fill = TRUE,
                      css = "font-family: sans-serif; font-size: 70%; color: white; padding: 4px; border-radius: 5px;"))
       )
```

<div class="girafe html-widget html-fill-item" id="htmlwidget-1" style="width:672px;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-1">{"x":{"html":"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='ggiraph-svg' role='graphics-document' id='svg_bff9353b_d885_4f92_a062_30421004b968' viewBox='0 0 648 288'>\n <defs id='svg_bff9353b_d885_4f92_a062_30421004b968_defs'>\n  <clipPath id='svg_bff9353b_d885_4f92_a062_30421004b968_c1'>\n   <rect x='0' y='0' width='648' height='288'/>\n  <\/clipPath>\n  <clipPath id='svg_bff9353b_d885_4f92_a062_30421004b968_c2'>\n   <rect x='5.48' y='5.48' width='637.04' height='263.85'/>\n  <\/clipPath>\n <\/defs>\n <g id='svg_bff9353b_d885_4f92_a062_30421004b968_rootg' class='ggiraph-svg-rootg'>\n  <g clip-path='url(#svg_bff9353b_d885_4f92_a062_30421004b968_c1)'>\n   <rect x='0' y='0' width='648' height='288' fill='#FFFFFF' fill-opacity='1' stroke='#FFFFFF' stroke-opacity='1' stroke-width='0.75' stroke-linejoin='round' stroke-linecap='round' class='ggiraph-svg-bg'/>\n  <\/g>\n  <g clip-path='url(#svg_bff9353b_d885_4f92_a062_30421004b968_c2)'>\n   <polyline points='5.48,221.17 642.52,221.17' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.53' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='5.48,137.41 642.52,137.41' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.53' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='5.48,53.64 642.52,53.64' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.53' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='108.37,269.33 108.37,5.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.53' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='262.39,269.33 262.39,5.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.53' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='416.41,269.33 416.41,5.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.53' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='570.44,269.33 570.44,5.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.53' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='5.48,263.05 642.52,263.05' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='1.07' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='5.48,179.29 642.52,179.29' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='1.07' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='5.48,95.52 642.52,95.52' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='1.07' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='5.48,11.76 642.52,11.76' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='1.07' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='31.36,269.33 31.36,5.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='1.07' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='185.38,269.33 185.38,5.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='1.07' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='339.40,269.33 339.40,5.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='1.07' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='493.43,269.33 493.43,5.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='1.07' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polygon points='34.44,179.21 35.57,180.12 36.70,181.03 37.84,181.95 38.97,182.86 40.10,183.78 41.24,184.69 42.37,185.61 43.50,186.52 44.64,187.43 45.77,188.35 46.90,189.25 48.04,190.16 49.17,191.06 50.30,191.96 51.44,192.86 52.57,193.75 53.70,194.63 54.84,195.51 55.97,196.38 57.10,197.25 58.24,198.10 59.37,198.95 60.50,199.80 61.64,200.63 62.77,201.46 63.90,202.27 65.04,203.08 66.17,203.88 67.30,204.67 68.44,205.44 69.57,206.21 70.70,206.96 71.84,207.71 72.97,208.44 74.10,209.17 75.24,209.88 76.37,210.57 77.50,211.26 78.64,211.94 79.77,212.60 80.90,213.25 82.04,213.89 83.17,214.51 84.30,215.13 85.44,215.72 86.57,216.31 87.70,216.89 88.84,217.45 89.97,218.00 91.10,218.53 92.24,219.06 93.37,219.57 94.50,220.06 95.64,220.55 96.77,221.02 97.90,221.49 99.04,221.94 100.17,222.37 101.30,222.80 102.44,223.21 103.57,223.61 104.70,224.00 105.84,224.37 106.97,224.74 108.10,225.10 109.24,225.44 110.37,225.77 111.50,226.09 112.64,226.40 113.77,226.70 114.90,226.99 116.04,227.27 117.17,227.54 118.30,227.79 119.44,228.04 120.57,228.28 121.70,228.51 122.84,228.73 123.97,228.94 125.10,229.14 126.24,229.33 127.37,229.51 128.50,229.69 129.64,229.85 130.77,230.01 131.90,230.16 133.04,230.30 134.17,230.43 135.30,230.55 136.43,230.67 137.57,230.78 138.70,230.88 139.83,230.98 140.97,231.07 142.10,231.15 143.23,231.22 144.37,231.29 145.50,231.35 146.63,231.41 147.77,231.45 148.90,231.50 150.03,231.53 151.17,231.56 152.30,231.59 153.43,231.61 154.57,231.62 155.70,231.63 156.83,231.64 157.97,231.64 159.10,231.63 160.23,231.62 161.37,231.61 162.50,231.59 163.63,231.57 164.77,231.54 165.90,231.51 167.03,231.48 168.17,231.44 169.30,231.40 170.43,231.35 171.57,231.30 172.70,231.25 173.83,231.20 174.97,231.14 176.10,231.08 177.23,231.02 178.37,230.96 179.50,230.89 180.63,230.82 181.77,230.75 182.90,230.68 184.03,230.61 185.17,230.53 186.30,230.46 187.43,230.38 188.57,230.30 189.70,230.22 190.83,230.14 191.97,230.06 193.10,229.97 194.23,229.89 195.37,229.81 196.50,229.72 197.63,229.64 198.77,229.55 199.90,229.47 201.03,229.38 202.17,229.29 203.30,229.21 204.43,229.12 205.57,229.04 206.70,228.95 207.83,228.87 208.97,228.78 210.10,228.70 211.23,228.61 212.37,228.53 213.50,228.45 214.63,228.37 215.77,228.28 216.90,228.20 218.03,228.12 219.17,228.04 220.30,227.96 221.43,227.88 222.57,227.81 223.70,227.73 224.83,227.65 225.97,227.57 227.10,227.50 228.23,227.42 229.37,227.34 230.50,227.27 231.63,227.19 232.77,227.12 233.90,227.04 235.03,226.97 236.17,226.89 237.30,226.81 238.43,226.74 239.57,226.66 240.70,226.58 241.83,226.50 242.97,226.42 244.10,226.34 245.23,226.25 246.37,226.17 247.50,226.08 248.63,225.99 249.77,225.90 250.90,225.81 252.03,225.71 253.17,225.61 254.30,225.50 255.43,225.40 256.57,225.29 257.70,225.17 258.83,225.05 259.97,224.92 261.10,224.79 262.23,224.66 263.37,224.51 264.50,224.37 265.63,224.21 266.77,224.05 267.90,223.88 269.03,223.70 270.17,223.52 271.30,223.32 272.43,223.12 273.57,222.91 274.70,222.68 275.83,222.45 276.97,222.21 278.10,221.96 279.23,221.70 280.37,221.42 281.50,221.14 282.63,220.84 283.77,220.53 284.90,220.21 286.03,219.87 287.17,219.52 288.30,219.16 289.43,218.78 290.57,218.39 291.70,217.99 292.83,217.57 293.97,217.14 295.10,216.69 296.23,216.22 297.37,215.75 298.50,215.25 299.63,214.75 300.77,214.22 301.90,213.68 303.03,213.13 304.17,212.56 305.30,211.98 306.43,211.38 307.57,210.76 308.70,210.13 309.83,209.49 310.97,208.83 312.10,208.16 313.23,207.47 314.37,206.77 315.50,206.05 316.63,205.32 317.77,204.58 318.90,203.83 320.03,203.06 321.17,202.29 322.30,201.49 323.43,200.69 324.57,199.88 325.70,199.06 326.83,198.23 327.97,197.39 329.10,196.55 330.23,195.69 331.37,194.83 332.50,193.96 333.63,193.09 334.77,192.21 335.90,191.33 337.03,190.44 338.17,189.55 339.30,188.66 340.43,187.76 341.57,186.87 342.70,185.97 343.83,185.08 344.97,184.18 346.10,183.29 347.23,182.40 348.37,181.51 349.50,180.63 350.63,179.75 351.77,178.88 352.90,178.01 354.03,177.15 355.17,176.30 356.30,175.46 357.43,174.62 358.57,173.79 359.70,172.97 360.83,172.17 361.97,171.37 363.10,170.59 364.23,169.81 365.37,169.05 366.50,168.30 367.63,167.57 368.77,166.84 369.90,166.14 371.03,165.44 372.17,164.76 373.30,164.10 374.43,163.45 375.57,162.82 376.70,162.20 377.83,161.60 378.97,161.01 380.10,160.44 381.23,159.89 382.37,159.35 383.50,158.83 384.63,158.32 385.77,157.83 386.90,157.36 388.03,156.91 389.17,156.46 390.30,156.05 391.43,155.64 392.57,155.25 393.70,154.88 394.83,154.51 395.97,154.17 397.10,153.84 398.23,153.53 399.37,153.23 400.50,152.95 401.63,152.68 402.77,152.43 403.90,152.18 405.03,151.96 406.17,151.74 407.30,151.54 408.43,151.36 409.57,151.18 410.70,151.01 411.83,150.86 412.97,150.72 414.10,150.59 415.23,150.47 416.37,150.36 417.50,150.26 418.63,150.16 419.77,150.08 420.90,150.01 422.03,149.94 423.17,149.89 424.30,149.83 425.43,149.79 426.57,149.75 427.70,149.72 428.83,149.70 429.97,149.68 431.10,149.67 432.23,149.66 433.37,149.66 434.50,149.66 435.63,149.66 436.77,149.67 437.90,149.68 439.03,149.70 440.17,149.72 441.30,149.74 442.43,149.76 443.57,149.79 444.70,149.82 445.83,149.85 446.97,149.88 448.10,149.91 449.23,149.94 450.37,149.98 451.50,150.01 452.63,150.05 453.77,150.09 454.90,150.12 456.03,150.16 457.17,150.20 458.30,150.23 459.43,150.27 460.57,150.30 461.70,150.34 462.83,150.37 463.97,150.41 465.10,150.44 466.23,150.48 467.37,150.51 468.50,150.54 469.63,150.57 470.77,150.60 471.90,150.63 473.03,150.65 474.17,150.68 475.30,150.70 476.43,150.73 477.57,150.75 478.70,150.77 479.83,150.80 480.97,150.82 482.10,150.83 483.23,150.85 484.37,150.87 485.50,150.89 486.63,150.90 487.77,150.91 488.90,150.93 490.03,150.94 491.17,150.95 492.30,150.96 493.43,150.97 494.57,150.98 495.70,150.99 496.83,151.00 497.97,151.00 499.10,151.01 500.23,151.02 501.37,151.02 502.50,151.03 503.63,151.03 504.77,151.03 505.90,151.04 507.03,151.04 508.17,151.04 509.30,151.04 510.43,151.04 511.57,151.04 512.70,151.04 513.83,151.04 514.96,151.04 516.10,151.04 517.23,151.04 518.36,151.03 519.50,151.03 520.63,151.03 521.76,151.02 522.90,151.02 524.03,151.01 525.16,151.01 526.30,151.00 527.43,151.00 528.56,150.99 529.70,150.98 530.83,150.97 531.96,150.96 533.10,150.95 534.23,150.94 535.36,150.93 536.50,150.92 537.63,150.91 538.76,150.89 539.90,150.88 541.03,150.86 542.16,150.85 543.30,150.83 544.43,150.81 545.56,150.79 546.70,150.77 547.83,150.75 548.96,150.73 550.10,150.70 551.23,150.68 552.36,150.65 553.50,150.62 554.63,150.59 555.76,150.56 556.90,150.53 558.03,150.50 559.16,150.46 560.30,150.42 561.43,150.38 562.56,150.34 563.70,150.30 564.83,150.26 565.96,150.21 567.10,150.17 568.23,150.12 569.36,150.07 570.50,150.01 571.63,149.96 572.76,149.90 573.90,149.84 575.03,149.78 576.16,149.72 577.30,149.65 578.43,149.59 579.56,149.52 580.70,149.45 581.83,149.38 582.96,149.30 584.10,149.22 585.23,149.14 586.36,149.06 587.50,148.98 588.63,148.89 589.76,148.81 590.90,148.72 592.03,148.62 593.16,148.53 594.30,148.43 595.43,148.34 596.56,148.24 597.70,148.13 598.83,148.03 599.96,147.92 601.10,147.81 602.23,147.70 603.36,147.59 604.50,147.48 605.63,147.36 606.76,147.24 607.90,147.12 609.03,147.00 610.16,146.88 611.30,146.76 612.43,146.63 613.56,146.50 613.56,128.31 612.43,128.18 611.30,128.05 610.16,127.93 609.03,127.81 607.90,127.69 606.76,127.57 605.63,127.45 604.50,127.33 603.36,127.22 602.23,127.11 601.10,127.00 599.96,126.89 598.83,126.78 597.70,126.68 596.56,126.57 595.43,126.47 594.30,126.38 593.16,126.28 592.03,126.19 590.90,126.09 589.76,126.00 588.63,125.92 587.50,125.83 586.36,125.75 585.23,125.67 584.10,125.59 582.96,125.51 581.83,125.43 580.70,125.36 579.56,125.29 578.43,125.22 577.30,125.16 576.16,125.09 575.03,125.03 573.90,124.97 572.76,124.91 571.63,124.85 570.50,124.80 569.36,124.74 568.23,124.69 567.10,124.64 565.96,124.60 564.83,124.55 563.70,124.51 562.56,124.47 561.43,124.43 560.30,124.39 559.16,124.35 558.03,124.31 556.90,124.28 555.76,124.25 554.63,124.22 553.50,124.19 552.36,124.16 551.23,124.13 550.10,124.11 548.96,124.08 547.83,124.06 546.70,124.04 545.56,124.02 544.43,124.00 543.30,123.98 542.16,123.96 541.03,123.95 539.90,123.93 538.76,123.92 537.63,123.90 536.50,123.89 535.36,123.88 534.23,123.87 533.10,123.86 531.96,123.85 530.83,123.84 529.70,123.83 528.56,123.82 527.43,123.81 526.30,123.81 525.16,123.80 524.03,123.80 522.90,123.79 521.76,123.79 520.63,123.78 519.50,123.78 518.36,123.78 517.23,123.77 516.10,123.77 514.96,123.77 513.83,123.77 512.70,123.77 511.57,123.77 510.43,123.77 509.30,123.77 508.17,123.77 507.03,123.77 505.90,123.77 504.77,123.78 503.63,123.78 502.50,123.78 501.37,123.79 500.23,123.79 499.10,123.80 497.97,123.81 496.83,123.81 495.70,123.82 494.57,123.83 493.43,123.84 492.30,123.85 491.17,123.86 490.03,123.87 488.90,123.88 487.77,123.90 486.63,123.91 485.50,123.92 484.37,123.94 483.23,123.96 482.10,123.98 480.97,123.99 479.83,124.01 478.70,124.04 477.57,124.06 476.43,124.08 475.30,124.11 474.17,124.13 473.03,124.16 471.90,124.18 470.77,124.21 469.63,124.24 468.50,124.27 467.37,124.30 466.23,124.33 465.10,124.37 463.97,124.40 462.83,124.44 461.70,124.47 460.57,124.51 459.43,124.54 458.30,124.58 457.17,124.61 456.03,124.65 454.90,124.69 453.77,124.72 452.63,124.76 451.50,124.80 450.37,124.83 449.23,124.87 448.10,124.90 446.97,124.93 445.83,124.96 444.70,124.99 443.57,125.02 442.43,125.05 441.30,125.07 440.17,125.09 439.03,125.11 437.90,125.13 436.77,125.14 435.63,125.15 434.50,125.15 433.37,125.15 432.23,125.15 431.10,125.14 429.97,125.13 428.83,125.11 427.70,125.09 426.57,125.06 425.43,125.02 424.30,124.98 423.17,124.93 422.03,124.87 420.90,124.80 419.77,124.73 418.63,124.65 417.50,124.55 416.37,124.45 415.23,124.34 414.10,124.22 412.97,124.09 411.83,123.95 410.70,123.80 409.57,123.63 408.43,123.45 407.30,123.27 406.17,123.07 405.03,122.85 403.90,122.63 402.77,122.38 401.63,122.13 400.50,121.86 399.37,121.58 398.23,121.28 397.10,120.97 395.97,120.64 394.83,120.30 393.70,119.93 392.57,119.56 391.43,119.17 390.30,118.76 389.17,118.35 388.03,117.90 386.90,117.45 385.77,116.98 384.63,116.49 383.50,115.98 382.37,115.46 381.23,114.92 380.10,114.37 378.97,113.80 377.83,113.21 376.70,112.61 375.57,111.99 374.43,111.36 373.30,110.71 372.17,110.05 371.03,109.37 369.90,108.67 368.77,107.97 367.63,107.24 366.50,106.51 365.37,105.76 364.23,105.00 363.10,104.22 361.97,103.44 360.83,102.64 359.70,101.84 358.57,101.02 357.43,100.19 356.30,99.35 355.17,98.51 354.03,97.66 352.90,96.80 351.77,95.93 350.63,95.06 349.50,94.18 348.37,93.30 347.23,92.41 346.10,91.52 344.97,90.63 343.83,89.73 342.70,88.84 341.57,87.94 340.43,87.05 339.30,86.15 338.17,85.26 337.03,84.37 335.90,83.48 334.77,82.60 333.63,81.72 332.50,80.85 331.37,79.98 330.23,79.12 329.10,78.26 327.97,77.42 326.83,76.58 325.70,75.75 324.57,74.93 323.43,74.12 322.30,73.32 321.17,72.52 320.03,71.75 318.90,70.98 317.77,70.23 316.63,69.49 315.50,68.76 314.37,68.04 313.23,67.34 312.10,66.65 310.97,65.98 309.83,65.32 308.70,64.68 307.57,64.05 306.43,63.43 305.30,62.83 304.17,62.25 303.03,61.68 301.90,61.13 300.77,60.59 299.63,60.06 298.50,59.56 297.37,59.06 296.23,58.59 295.10,58.12 293.97,57.67 292.83,57.24 291.70,56.82 290.57,56.42 289.43,56.03 288.30,55.65 287.17,55.29 286.03,54.94 284.90,54.60 283.77,54.28 282.63,53.97 281.50,53.67 280.37,53.39 279.23,53.11 278.10,52.85 276.97,52.60 275.83,52.36 274.70,52.13 273.57,51.90 272.43,51.69 271.30,51.49 270.17,51.29 269.03,51.11 267.90,50.93 266.77,50.76 265.63,50.60 264.50,50.44 263.37,50.30 262.23,50.15 261.10,50.02 259.97,49.89 258.83,49.76 257.70,49.64 256.57,49.52 255.43,49.41 254.30,49.31 253.17,49.20 252.03,49.10 250.90,49.00 249.77,48.91 248.63,48.82 247.50,48.73 246.37,48.64 245.23,48.56 244.10,48.47 242.97,48.39 241.83,48.31 240.70,48.23 239.57,48.15 238.43,48.07 237.30,48.00 236.17,47.92 235.03,47.84 233.90,47.77 232.77,47.69 231.63,47.62 230.50,47.54 229.37,47.47 228.23,47.39 227.10,47.31 225.97,47.24 224.83,47.16 223.70,47.08 222.57,47.00 221.43,46.93 220.30,46.85 219.17,46.77 218.03,46.69 216.90,46.61 215.77,46.53 214.63,46.44 213.50,46.36 212.37,46.28 211.23,46.20 210.10,46.11 208.97,46.03 207.83,45.94 206.70,45.86 205.57,45.77 204.43,45.69 203.30,45.60 202.17,45.52 201.03,45.43 199.90,45.34 198.77,45.26 197.63,45.17 196.50,45.09 195.37,45.00 194.23,44.92 193.10,44.84 191.97,44.75 190.83,44.67 189.70,44.59 188.57,44.51 187.43,44.43 186.30,44.35 185.17,44.28 184.03,44.20 182.90,44.13 181.77,44.06 180.63,43.99 179.50,43.92 178.37,43.85 177.23,43.79 176.10,43.73 174.97,43.67 173.83,43.61 172.70,43.56 171.57,43.51 170.43,43.46 169.30,43.41 168.17,43.37 167.03,43.33 165.90,43.30 164.77,43.27 163.63,43.24 162.50,43.22 161.37,43.20 160.23,43.19 159.10,43.18 157.97,43.17 156.83,43.17 155.70,43.18 154.57,43.19 153.43,43.20 152.30,43.22 151.17,43.25 150.03,43.28 148.90,43.31 147.77,43.36 146.63,43.40 145.50,43.46 144.37,43.52 143.23,43.59 142.10,43.66 140.97,43.74 139.83,43.83 138.70,43.93 137.57,44.03 136.43,44.14 135.30,44.26 134.17,44.38 133.04,44.51 131.90,44.65 130.77,44.80 129.64,44.96 128.50,45.12 127.37,45.30 126.24,45.48 125.10,45.67 123.97,45.87 122.84,46.08 121.70,46.30 120.57,46.53 119.44,46.77 118.30,47.02 117.17,47.27 116.04,47.54 114.90,47.82 113.77,48.11 112.64,48.41 111.50,48.72 110.37,49.04 109.24,49.37 108.10,49.71 106.97,50.07 105.84,50.44 104.70,50.81 103.57,51.20 102.44,51.60 101.30,52.01 100.17,52.44 99.04,52.87 97.90,53.33 96.77,53.79 95.64,54.26 94.50,54.75 93.37,55.24 92.24,55.75 91.10,56.28 89.97,56.81 88.84,57.36 87.70,57.92 86.57,58.50 85.44,59.09 84.30,59.68 83.17,60.30 82.04,60.92 80.90,61.56 79.77,62.21 78.64,62.87 77.50,63.55 76.37,64.24 75.24,64.93 74.10,65.64 72.97,66.37 71.84,67.10 70.70,67.85 69.57,68.60 68.44,69.37 67.30,70.15 66.17,70.93 65.04,71.73 63.90,72.54 62.77,73.35 61.64,74.18 60.50,75.01 59.37,75.86 58.24,76.71 57.10,77.56 55.97,78.43 54.84,79.30 53.70,80.18 52.57,81.06 51.44,81.95 50.30,82.85 49.17,83.75 48.04,84.65 46.90,85.56 45.77,86.46 44.64,87.38 43.50,88.29 42.37,89.20 41.24,90.12 40.10,91.03 38.97,91.95 37.84,92.86 36.70,93.78 35.57,94.69 34.44,95.60 34.44,179.21' fill='#000000' fill-opacity='0.2' stroke='#333333' stroke-opacity='1' stroke-width='0.21' stroke-linejoin='round' stroke-linecap='butt'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e1' cx='607.4' cy='137.41' r='3.47pt' fill='#F94C6A' fill-opacity='0.6' stroke='#F94C6A' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='outlier: 187'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e2' cx='570.44' cy='137.41' r='3.47pt' fill='#F94C6A' fill-opacity='0.6' stroke='#F94C6A' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='outlier: 175'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e3' cx='548.87' cy='137.41' r='3.47pt' fill='#F94C6A' fill-opacity='0.6' stroke='#F94C6A' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='outlier: 168'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e4' cx='613.56' cy='137.41' r='3.47pt' fill='#F94C6A' fill-opacity='0.6' stroke='#F94C6A' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='outlier: 189'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e5' cx='169.56' cy='190.48' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chapache: 45'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e6' cx='322.9' cy='103.26' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chechapa: 95'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e7' cx='286.87' cy='132.93' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chamapa: 83'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e8' cx='314.17' cy='220.19' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='mapache: 92'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e9' cx='153.47' cy='71.17' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chamache: 40'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e10' cx='161.64' cy='115.36' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='pachama: 42'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e11' cx='261.94' cy='117.61' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='mapacha: 75'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e12' cx='231.47' cy='77.39' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='machepa: 65'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e13' cx='200.19' cy='172.64' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chachema: 55'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e14' cx='87.62' cy='170.98' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chapama: 18'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e15' cx='321.97' cy='94.27' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='pamache: 94'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e16' cx='311.7' cy='197.39' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chepama: 91'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e17' cx='192.15' cy='206.37' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chamapa: 52'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e18' cx='218.56' cy='92.39' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='machapa: 61'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e19' cx='277.1' cy='207.4' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='pachema: 80'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e20' cx='127.22' cy='54.67' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chemacha: 31'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e21' cx='121.18' cy='140.81' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chechama: 29'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e22' cx='98.83' cy='179.66' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chapama: 22'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e23' cx='175.9' cy='198.83' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='pachama: 47'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e24' cx='178.75' cy='140.19' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='pachama: 48'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e25' cx='216.06' cy='89.5' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='pamacha: 60'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e26' cx='172.07' cy='122.72' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chepama: 46'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e27' cx='139.16' cy='167.35' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chechapa: 35'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e28' cx='241.38' cy='140.2' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chamapa: 68'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e29' cx='96.42' cy='124.81' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='pamache: 21'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e30' cx='237.41' cy='171.38' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chemacha: 67'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e31' cx='295.13' cy='162.2' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chamache: 86'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e32' cx='34.96' cy='92.68' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chemapa: 1'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e33' cx='246.03' cy='130.88' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chepama: 70'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e34' cx='264.52' cy='132.85' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chechapa: 76'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e35' cx='135.93' cy='202.17' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='mapacha: 34'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e36' cx='124.81' cy='216.91' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chamache: 30'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e37' cx='294' cy='62.53' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chechapa: 85'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e38' cx='183.43' cy='55.85' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='machache: 49'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e39' cx='133.74' cy='150.23' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chechama: 33'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e40' cx='102.85' cy='178.71' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='pachema: 23'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e41' cx='162.65' cy='175.05' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chapama: 43'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e42' cx='116.54' cy='211.69' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='pamache: 28'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e43' cx='254.26' cy='139.88' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chamache: 72'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e44' cx='338.69' cy='103.38' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='pachama: 100'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e45' cx='317.77' cy='185.2' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chapama: 93'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e46' cx='208.92' cy='170.45' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='machepa: 58'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e47' cx='110.37' cy='150.6' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chemapa: 26'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e48' cx='234.19' cy='85.12' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='machepa: 66'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e49' cx='290.42' cy='210.98' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='mapache: 84'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e50' cx='256.27' cy='141.28' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='mapacha: 73'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e51' cx='148.73' cy='156.46' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chemapa: 38'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e52' cx='326.34' cy='143.91' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chepacha: 96'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e53' cx='269.59' cy='175.69' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chepacha: 77'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e54' cx='74.8' cy='164.96' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chemapa: 14'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e55' cx='336.5' cy='209.4' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='mapacha: 99'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e56' cx='43.17' cy='211.03' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chapama: 4'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e57' cx='333.15' cy='132.3' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='machache: 98'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e58' cx='309.06' cy='88.34' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chemapa: 90'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e59' cx='156.94' cy='211.17' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chechama: 41'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e60' cx='68.1' cy='179.21' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chapache: 12'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e61' cx='281.11' cy='199.82' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='machecha: 81'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e62' cx='197.24' cy='109.66' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='machecha: 54'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e63' cx='203.08' cy='151.64' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='pachema: 56'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e64' cx='185.54' cy='110.04' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='pachecha: 50'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e65' cx='77.69' cy='132.22' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='machapa: 15'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e66' cx='226.58' cy='155' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chepacha: 63'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e67' cx='90.48' cy='192.51' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chapama: 19'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e68' cx='59.41' cy='71.44' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='pachache: 9'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e69' cx='49.39' cy='66.1' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='machecha: 6'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e70' cx='62.4' cy='170.21' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='machepa: 10'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e71' cx='223.22' cy='215.03' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='machache: 62'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e72' cx='71.33' cy='55.46' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chechapa: 13'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e73' cx='141.53' cy='137.54' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chachepa: 36'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e74' cx='80.35' cy='164.65' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='pamache: 16'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e75' cx='194.34' cy='190.99' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chechapa: 53'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e76' cx='106.41' cy='219.71' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chamapa: 24'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e77' cx='229.62' cy='195.8' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chemacha: 64'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e78' cx='330.05' cy='67.54' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chepama: 97'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e79' cx='150.44' cy='206.62' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='mapacha: 39'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e80' cx='56.42' cy='137.09' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chemacha: 8'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e81' cx='298.61' cy='161.14' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='pachecha: 87'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e82' cx='212.03' cy='131.16' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chapache: 59'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e83' cx='146.14' cy='206.45' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='machecha: 37'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e84' cx='274.34' cy='97.27' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chamache: 79'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e85' cx='303.08' cy='83.91' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chamache: 88'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e86' cx='92.55' cy='84.21' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chechama: 20'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e87' cx='64.18' cy='61.92' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chapama: 11'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e88' cx='243.01' cy='157.46' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chechama: 69'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e89' cx='304.49' cy='182.56' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chamapa: 89'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e90' cx='113.42' cy='192.83' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='pamache: 27'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e91' cx='130.1' cy='139.26' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chechapa: 32'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e92' cx='45.72' cy='166.33' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='pamacha: 5'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e93' cx='283.68' cy='183.82' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chepacha: 82'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e94' cx='166.71' cy='84.27' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='mapache: 44'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e95' cx='537.57' cy='183.91' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chapache: 164'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e96' cx='505.08' cy='109.2' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='pachama: 154'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e97' cx='474.18' cy='163.99' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chechama: 144'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e98' cx='415.7' cy='198.46' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chepama: 125'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e99' cx='442.08' cy='106.96' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='chemapa: 133'/>\n   <circle id='svg_bff9353b_d885_4f92_a062_30421004b968_e100' cx='469.62' cy='212.09' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='machepa: 142'/>\n   <text transform='translate(603.05,130.72) rotate(-90.00)' font-size='8.54pt' font-weight='bold' font-family='Helvetica' fill='#F94C6A' fill-opacity='1'>chepama<\/text>\n   <text transform='translate(570.60,130.38) rotate(-90.00)' font-size='8.54pt' font-weight='bold' font-family='Helvetica' fill='#F94C6A' fill-opacity='1'>pachache<\/text>\n   <text transform='translate(548.70,130.69) rotate(-90.00)' font-size='8.54pt' font-weight='bold' font-family='Helvetica' fill='#F94C6A' fill-opacity='1'>mapacha<\/text>\n   <text transform='translate(619.08,130.36) rotate(-90.00)' font-size='8.54pt' font-weight='bold' font-family='Helvetica' fill='#F94C6A' fill-opacity='1'>chachema<\/text>\n  <\/g>\n  <g clip-path='url(#svg_bff9353b_d885_4f92_a062_30421004b968_c1)'>\n   <text x='28.91' y='280.57' font-size='6.6pt' font-family='Helvetica' fill='#4D4D4D' fill-opacity='1'>0<\/text>\n   <text x='180.48' y='280.57' font-size='6.6pt' font-family='Helvetica' fill='#4D4D4D' fill-opacity='1'>50<\/text>\n   <text x='332.06' y='280.57' font-size='6.6pt' font-family='Helvetica' fill='#4D4D4D' fill-opacity='1'>100<\/text>\n   <text x='486.08' y='280.57' font-size='6.6pt' font-family='Helvetica' fill='#4D4D4D' fill-opacity='1'>150<\/text>\n  <\/g>\n <\/g>\n<\/svg>","js":null,"uid":"svg_bff9353b_d885_4f92_a062_30421004b968","ratio":2.25,"settings":{"tooltip":{"css":".tooltip_SVGID_ { font-family: sans-serif; font-size: 70%; color: white; padding: 4px; border-radius: 5px; ; position:absolute;pointer-events:none;z-index:999;}","placement":"doc","opacity":0.7,"offx":10,"offy":0,"use_cursor_pos":true,"use_fill":true,"use_stroke":false,"delay_over":200,"delay_out":500},"hover":{"css":".hover_data_SVGID_ { fill:orange;stroke:black;cursor:pointer; }\ntext.hover_data_SVGID_ { stroke:none;fill:orange; }\ncircle.hover_data_SVGID_ { fill:orange;stroke:black; }\nline.hover_data_SVGID_, polyline.hover_data_SVGID_ { fill:none;stroke:orange; }\nrect.hover_data_SVGID_, polygon.hover_data_SVGID_, path.hover_data_SVGID_ { fill:orange;stroke:none; }\nimage.hover_data_SVGID_ { stroke:orange; }","reactive":true,"nearest_distance":null},"hover_inv":{"css":""},"hover_key":{"css":".hover_key_SVGID_ { fill:orange;stroke:black;cursor:pointer; }\ntext.hover_key_SVGID_ { stroke:none;fill:orange; }\ncircle.hover_key_SVGID_ { fill:orange;stroke:black; }\nline.hover_key_SVGID_, polyline.hover_key_SVGID_ { fill:none;stroke:orange; }\nrect.hover_key_SVGID_, polygon.hover_key_SVGID_, path.hover_key_SVGID_ { fill:orange;stroke:none; }\nimage.hover_key_SVGID_ { stroke:orange; }","reactive":true},"hover_theme":{"css":".hover_theme_SVGID_ { fill:orange;stroke:black;cursor:pointer; }\ntext.hover_theme_SVGID_ { stroke:none;fill:orange; }\ncircle.hover_theme_SVGID_ { fill:orange;stroke:black; }\nline.hover_theme_SVGID_, polyline.hover_theme_SVGID_ { fill:none;stroke:orange; }\nrect.hover_theme_SVGID_, polygon.hover_theme_SVGID_, path.hover_theme_SVGID_ { fill:orange;stroke:none; }\nimage.hover_theme_SVGID_ { stroke:orange; }","reactive":true},"select":{"css":".select_data_SVGID_ { fill:red;stroke:black;cursor:pointer; }\ntext.select_data_SVGID_ { stroke:none;fill:red; }\ncircle.select_data_SVGID_ { fill:red;stroke:black; }\nline.select_data_SVGID_, polyline.select_data_SVGID_ { fill:none;stroke:red; }\nrect.select_data_SVGID_, polygon.select_data_SVGID_, path.select_data_SVGID_ { fill:red;stroke:none; }\nimage.select_data_SVGID_ { stroke:red; }","type":"multiple","only_shiny":true,"selected":[]},"select_inv":{"css":""},"select_key":{"css":".select_key_SVGID_ { fill:red;stroke:black;cursor:pointer; }\ntext.select_key_SVGID_ { stroke:none;fill:red; }\ncircle.select_key_SVGID_ { fill:red;stroke:black; }\nline.select_key_SVGID_, polyline.select_key_SVGID_ { fill:none;stroke:red; }\nrect.select_key_SVGID_, polygon.select_key_SVGID_, path.select_key_SVGID_ { fill:red;stroke:none; }\nimage.select_key_SVGID_ { stroke:red; }","type":"single","only_shiny":true,"selected":[]},"select_theme":{"css":".select_theme_SVGID_ { fill:red;stroke:black;cursor:pointer; }\ntext.select_theme_SVGID_ { stroke:none;fill:red; }\ncircle.select_theme_SVGID_ { fill:red;stroke:black; }\nline.select_theme_SVGID_, polyline.select_theme_SVGID_ { fill:none;stroke:red; }\nrect.select_theme_SVGID_, polygon.select_theme_SVGID_, path.select_theme_SVGID_ { fill:red;stroke:none; }\nimage.select_theme_SVGID_ { stroke:red; }","type":"single","only_shiny":true,"selected":[]},"zoom":{"min":1,"max":1,"duration":300},"toolbar":{"position":"topright","pngname":"diagram","tooltips":null,"fixed":false,"hidden":["selection","saveaspng"],"delay_over":200,"delay_out":500},"sizing":{"rescale":true,"width":1}}},"evals":[],"jsHooks":[]}</script>

Toca o posa el cursor sobre un punto para ver la información extra! ¿Puedes encontrar el punto que dice *pamache*? 🦝

------------------------------------------------------------------------

{{< cafecito >}}

[^1]: Esto funciona porque, al anteponer la colita de chancho (`~`) a la función, creamos una *función lambda* que reciba los datos directamente sin tener que especificar el nombre del objeto (conveniente, por ejemplo, si pasaste directo de modificar los datos a hacer el gráfico sin crear un objeto intermedio).

[^2]: En R, decir `variable == TRUE` es lo mismo que decir simplemente `variable`, porque `variable` *es* `TRUE`; o sea que puedes hacer `filter(variable)` en vez de `filter(variable == TRUE)`, y de la misma forma, `filter(!variable)` en vez de `filter(variable == FALSE)`.
