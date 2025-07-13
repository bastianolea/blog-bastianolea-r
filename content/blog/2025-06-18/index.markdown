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

En este post **simularemos un dataset** con datos anómalos, y luego mostraremos algunas formas de **visualización de datos anómalos** [en `{ggplot2}`](/tags/ggplot2/) para tomar decisiones al respecto. Al final crearemos un **gráfico interactivo** [con `{ggiraph}`](https://davidgohel.github.io/ggiraph/) que permita poner el cursor sobre las observaciones para obtener más información.

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

Con la función `tibble()` convertimos el vector de números en una columna de un dataframe, y usando nuevamente `sample()` crearemos dos columnas con palabras al azar para complementar estos datos simulados:

``` r
datos <- tibble(valor) |> 
  # procesar datos por fila en vez de por la columna entera (vectorización)
  rowwise() |> 
  # por fila, elegir tres sílabas al azar y unirlas en un sólo texto, que será el "nombre" de las observaciones
  mutate(nombre = sample(c("ma", "pa", "che", "cha"), 3, F) |> paste(collapse = "")) |> 
  # desagrupar y crear otra variable con trres valores posibles, y que por lo tanto distribuya los datos en tres grupos
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

``` r
sample(c("ma", "pa", "che", "cha"), 3, F) |> paste(collapse = "")
```

    ## [1] "mapache"

## Detección de datos anómalos

Para identificar los *outliers*, utilizaremos el criterio del **rango intercuartílico.** El rango intercuartílico se calcula con la función `IQR()` y es el rango de los datos entre el primer y tercer cuartil (el percentil 25 y el percentil 75; es decir, la diferencia entre el dato ubicado en el 75% mayor y el 25% mayor de la distribución de los datos).

En otras palabras, el *IQR* es una cifra que indica qué tanta distancia existe en la “mitad” de tus datos, si los esparcieras todos en una distribución, como aparece en el siguiente gráfico[^1].

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-1.png" width="672" />

Luego, el rango intercuartílico se multiplica por 1,5, y se suma al valor del tercer cuartil (percentil 75), de modo que se identifiquen como *outliers* los datos que sean mayores[^2] al tercer cuartil más 1,5 veces el rango intercuartílico. Puedes calcular cualquier percentil de un vector o columna con la función `quantile(x, .75)`, donde el número identifica al percentil.

Aplicamos el cálculo a la variable `valor`:

``` r
datos_outliers <- datos |> 
  mutate(umbral = quantile(valor, 0.75) + 1.5 * IQR(valor))
```

Esto nos dará una cifra que operará como el **umbral respecto del cual se clasificarán los outliers**. Es conveniente calcular este umbral dentro del dataframe, porque si queremos calcular outliers desagregados por otra variable, simplemente mantenemos la fórmula y agregamos antes un `group_by()` para realizar el cálculo por grupos.

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

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-7-1.png" width="768" />

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

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" width="1152" />

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

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-9-1.png" width="672" />

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

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-10-1.png" width="672" />

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

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-11-1.png" width="672" />

Para combinar estas visualizaciones, aprovechamos la capacidad de `{ggplot2}` de especificar los datos que se usan en cada capa o geometría de la visualización por medio del argumento `data`. Normalmente, el argumento `data` se rellena por defecto con los datos que entregamos a la función `ggplot()`, pero si especificamos el argumento podemos hacer que cada capa use datos completamente distintos. En nuestro caso, no queremos datos distintos, sino **aplicar filtros a los datos de cada capa**, lo que se logra con `data = ~filter(.x, ...)`[^3], donde `...` sería el filtro que necesitemos. En la visualización anterior, queremos que `geom_point()` sólo muestre los datos que son `outlier == FALSE`, y que `geom_jitter()` sólo muestre los datos que son `outlier == TRUE`[^4].

``` r
data = ~filter(.x, outlier)
```

### Etiquetas de texto

Al identificar outliers, una buena opción es mostrar etiquetas de texto para estos casos con `geom_text()`. De este modo podemos identificar exactamente a qué observaciones corresponden las anomalías. En el caso de que fueran muchas etiquetas, podemos usar `geom_text_repel()` [del paquete `{ggrepel}`](https://ggrepel.slowkow.com) para que las etiquetas de texto se acomoden si es que caen encima de otras.

``` r
library(ggrepel)

grafico_outliers <- grafico_outliers + 
  # agregar texto al gráfico anterior
  ggrepel::geom_text_repel(data = ~filter(.x, outlier), # sólo para observaciones que son outlier
                           aes(label = nombre), # variable con el texto a mostrar
                           fontface = "bold", size = 4, point.padding = 4, angle = 90, hjust = 0) 

grafico_outliers
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-13-1.png" width="672" />

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

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-14-1.png" width="672" />

## Gráfico interactivo

Para mejorar la exploración de los datos podemos convertir fácilmente cualquier gráfico de `{ggplot2}` en gráficos interactivos gracias [al paquete `{ggiraph}`](https://davidgohel.github.io/ggiraph/). Principalmente, lo que agregaremos son *tooltips* o cajas emergentes que aparecerán cuando se pose el cursor sobre un punto del gráfico y que muestren información extra.

Con `{ggiraph}` solamente se requieren cambios mínimos para volver interactivo cualquier gráfico. Entre ellos es agregar `_interactive` a las funciones que crean las geometrías del gráfico:

- Pasar de `geom_point()` a `geom_point_interactive()`
- Pasar de `geom_jitter()` a `geom_jitter_interactive()`

Habiendo hecho este cambio, dentro de las geometrías `geom_x_interactive()` ahora podremos definir la estética `tooltip` dentro de `aes()` para que **aparezca contenido cuando se ponga el cursor sobre los elementos del gráfico.** En este caso, haremos que los *tooltips* muestren el nombre de la observación y su valor, y la palabra *outlier* si corresponde. También podemos agregar `html` para dar estilo al texto; por ejemplo, las etiquetas `<b>` para letra negrita.

Si queremos que los puntos del gráfico **se iluminen o cambien de color al poner el cursor encima**, adicionalmente tenemos que definir la estética `data_id` que identifique de forma única los elementos del gráfico (puede servir para hacer que varios se iluminen al mismo tiempo si elijes una variable que no identifique de forma única los valores).

Copiamos el código anterior y hacemos los cambios apropiados al gráfico:

``` r
library(ggiraph)

grafico_outliers_interactivo <- datos_outliers |> 
  ggplot() +
  aes(x = valor, y = 1, color = outlier,
      # variable que identifica de forma única a los elementos del gráfico
      data_id = nombre) + 
  geom_violin(aes(y = 1, x = valor), 
              inherit.aes = F, alpha = 0.2, lwd = 0.1, fill = "black") +
  # puntos para los outliers
  ggiraph::geom_point_interactive(data = ~filter(.x, outlier), 
                                  # texto "outlier" con el valor
                                  aes(tooltip = paste("<b>outlier:</b> ", valor, sep = "")), 
                                  size = 4, alpha = 0.6) +
  # puntos dispersados para el resto de los datos
  ggiraph::geom_jitter_interactive(data = ~filter(.x, !outlier), 
                                   # nombre de observación y valor
                                   aes(tooltip = paste("<b>", nombre, ":</b> ", valor, sep = "")), 
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
         # color al poner el cursor encima
         opts_hover(css = "fill: white; stroke: black;"),
         # personalizar la apariencia del tooltip
         opts_tooltip(opacity = 0.7, use_fill = TRUE,
                      css = "font-family: sans-serif; font-size: 70%; color: white; padding: 4px; border-radius: 5px;"))
)
```

<div class="girafe html-widget html-fill-item" id="htmlwidget-1" style="width:672px;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-1">{"x":{"html":"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='ggiraph-svg' role='graphics-document' id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956' viewBox='0 0 648 288'>\n <defs id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_defs'>\n  <clipPath id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_c1'>\n   <rect x='0' y='0' width='648' height='288'/>\n  <\/clipPath>\n  <clipPath id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_c2'>\n   <rect x='5.48' y='5.48' width='637.04' height='263.85'/>\n  <\/clipPath>\n <\/defs>\n <g id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_rootg' class='ggiraph-svg-rootg'>\n  <g clip-path='url(#svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_c1)'>\n   <rect x='0' y='0' width='648' height='288' fill='#FFFFFF' fill-opacity='1' stroke='#FFFFFF' stroke-opacity='1' stroke-width='0.75' stroke-linejoin='round' stroke-linecap='round' class='ggiraph-svg-bg'/>\n  <\/g>\n  <g clip-path='url(#svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_c2)'>\n   <polyline points='5.48,221.17 642.52,221.17' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.53' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='5.48,137.41 642.52,137.41' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.53' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='5.48,53.64 642.52,53.64' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.53' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='108.69,269.33 108.69,5.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.53' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='262.61,269.33 262.61,5.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.53' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='416.54,269.33 416.54,5.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.53' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='570.47,269.33 570.47,5.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.53' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='5.48,263.05 642.52,263.05' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='1.07' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='5.48,179.29 642.52,179.29' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='1.07' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='5.48,95.52 642.52,95.52' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='1.07' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='5.48,11.76 642.52,11.76' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='1.07' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='31.73,269.33 31.73,5.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='1.07' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='185.65,269.33 185.65,5.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='1.07' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='339.58,269.33 339.58,5.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='1.07' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polyline points='493.50,269.33 493.50,5.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='1.07' stroke-linejoin='round' stroke-linecap='butt'/>\n   <polygon points='34.80,179.21 35.94,180.12 37.07,181.03 38.20,181.95 39.33,182.86 40.47,183.78 41.60,184.69 42.73,185.61 43.87,186.52 45.00,187.43 46.13,188.35 47.26,189.25 48.40,190.16 49.53,191.06 50.66,191.96 51.79,192.86 52.93,193.75 54.06,194.63 55.19,195.51 56.32,196.38 57.46,197.25 58.59,198.10 59.72,198.95 60.85,199.80 61.99,200.63 63.12,201.46 64.25,202.27 65.38,203.08 66.52,203.88 67.65,204.67 68.78,205.44 69.92,206.21 71.05,206.96 72.18,207.71 73.31,208.44 74.45,209.17 75.58,209.88 76.71,210.57 77.84,211.26 78.98,211.94 80.11,212.60 81.24,213.25 82.37,213.89 83.51,214.51 84.64,215.13 85.77,215.72 86.90,216.31 88.04,216.89 89.17,217.45 90.30,218.00 91.43,218.53 92.57,219.06 93.70,219.57 94.83,220.06 95.96,220.55 97.10,221.02 98.23,221.49 99.36,221.94 100.50,222.37 101.63,222.80 102.76,223.21 103.89,223.61 105.03,224.00 106.16,224.37 107.29,224.74 108.42,225.10 109.56,225.44 110.69,225.77 111.82,226.09 112.95,226.40 114.09,226.70 115.22,226.99 116.35,227.27 117.48,227.54 118.62,227.79 119.75,228.04 120.88,228.28 122.01,228.51 123.15,228.73 124.28,228.94 125.41,229.14 126.55,229.33 127.68,229.51 128.81,229.69 129.94,229.85 131.08,230.01 132.21,230.16 133.34,230.30 134.47,230.43 135.61,230.55 136.74,230.67 137.87,230.78 139.00,230.88 140.14,230.98 141.27,231.07 142.40,231.15 143.53,231.22 144.67,231.29 145.80,231.35 146.93,231.41 148.06,231.45 149.20,231.50 150.33,231.53 151.46,231.56 152.60,231.59 153.73,231.61 154.86,231.62 155.99,231.63 157.13,231.64 158.26,231.64 159.39,231.63 160.52,231.62 161.66,231.61 162.79,231.59 163.92,231.57 165.05,231.54 166.19,231.51 167.32,231.48 168.45,231.44 169.58,231.40 170.72,231.35 171.85,231.30 172.98,231.25 174.11,231.20 175.25,231.14 176.38,231.08 177.51,231.02 178.64,230.96 179.78,230.89 180.91,230.82 182.04,230.75 183.18,230.68 184.31,230.61 185.44,230.53 186.57,230.46 187.71,230.38 188.84,230.30 189.97,230.22 191.10,230.14 192.24,230.06 193.37,229.97 194.50,229.89 195.63,229.81 196.77,229.72 197.90,229.64 199.03,229.55 200.16,229.47 201.30,229.38 202.43,229.29 203.56,229.21 204.69,229.12 205.83,229.04 206.96,228.95 208.09,228.87 209.23,228.78 210.36,228.70 211.49,228.61 212.62,228.53 213.76,228.45 214.89,228.37 216.02,228.28 217.15,228.20 218.29,228.12 219.42,228.04 220.55,227.96 221.68,227.88 222.82,227.81 223.95,227.73 225.08,227.65 226.21,227.57 227.35,227.50 228.48,227.42 229.61,227.34 230.74,227.27 231.88,227.19 233.01,227.12 234.14,227.04 235.27,226.97 236.41,226.89 237.54,226.81 238.67,226.74 239.81,226.66 240.94,226.58 242.07,226.50 243.20,226.42 244.34,226.34 245.47,226.25 246.60,226.17 247.73,226.08 248.87,225.99 250.00,225.90 251.13,225.81 252.26,225.71 253.40,225.61 254.53,225.50 255.66,225.40 256.79,225.29 257.93,225.17 259.06,225.05 260.19,224.92 261.32,224.79 262.46,224.66 263.59,224.51 264.72,224.37 265.86,224.21 266.99,224.05 268.12,223.88 269.25,223.70 270.39,223.52 271.52,223.32 272.65,223.12 273.78,222.91 274.92,222.68 276.05,222.45 277.18,222.21 278.31,221.96 279.45,221.70 280.58,221.42 281.71,221.14 282.84,220.84 283.98,220.53 285.11,220.21 286.24,219.87 287.37,219.52 288.51,219.16 289.64,218.78 290.77,218.39 291.91,217.99 293.04,217.57 294.17,217.14 295.30,216.69 296.44,216.22 297.57,215.75 298.70,215.25 299.83,214.75 300.97,214.22 302.10,213.68 303.23,213.13 304.36,212.56 305.50,211.98 306.63,211.38 307.76,210.76 308.89,210.13 310.03,209.49 311.16,208.83 312.29,208.16 313.42,207.47 314.56,206.77 315.69,206.05 316.82,205.32 317.95,204.58 319.09,203.83 320.22,203.06 321.35,202.29 322.49,201.49 323.62,200.69 324.75,199.88 325.88,199.06 327.02,198.23 328.15,197.39 329.28,196.55 330.41,195.69 331.55,194.83 332.68,193.96 333.81,193.09 334.94,192.21 336.08,191.33 337.21,190.44 338.34,189.55 339.47,188.66 340.61,187.76 341.74,186.87 342.87,185.97 344.00,185.08 345.14,184.18 346.27,183.29 347.40,182.40 348.54,181.51 349.67,180.63 350.80,179.75 351.93,178.88 353.07,178.01 354.20,177.15 355.33,176.30 356.46,175.46 357.60,174.62 358.73,173.79 359.86,172.97 360.99,172.17 362.13,171.37 363.26,170.59 364.39,169.81 365.52,169.05 366.66,168.30 367.79,167.57 368.92,166.84 370.05,166.14 371.19,165.44 372.32,164.76 373.45,164.10 374.59,163.45 375.72,162.82 376.85,162.20 377.98,161.60 379.12,161.01 380.25,160.44 381.38,159.89 382.51,159.35 383.65,158.83 384.78,158.32 385.91,157.83 387.04,157.36 388.18,156.91 389.31,156.46 390.44,156.05 391.57,155.64 392.71,155.25 393.84,154.88 394.97,154.51 396.10,154.17 397.24,153.84 398.37,153.53 399.50,153.23 400.63,152.95 401.77,152.68 402.90,152.43 404.03,152.18 405.17,151.96 406.30,151.74 407.43,151.54 408.56,151.36 409.70,151.18 410.83,151.01 411.96,150.86 413.09,150.72 414.23,150.59 415.36,150.47 416.49,150.36 417.62,150.26 418.76,150.16 419.89,150.08 421.02,150.01 422.15,149.94 423.29,149.89 424.42,149.83 425.55,149.79 426.68,149.75 427.82,149.72 428.95,149.70 430.08,149.68 431.22,149.67 432.35,149.66 433.48,149.66 434.61,149.66 435.75,149.66 436.88,149.67 438.01,149.68 439.14,149.70 440.28,149.72 441.41,149.74 442.54,149.76 443.67,149.79 444.81,149.82 445.94,149.85 447.07,149.88 448.20,149.91 449.34,149.94 450.47,149.98 451.60,150.01 452.73,150.05 453.87,150.09 455.00,150.12 456.13,150.16 457.27,150.20 458.40,150.23 459.53,150.27 460.66,150.30 461.80,150.34 462.93,150.37 464.06,150.41 465.19,150.44 466.33,150.48 467.46,150.51 468.59,150.54 469.72,150.57 470.86,150.60 471.99,150.63 473.12,150.65 474.25,150.68 475.39,150.70 476.52,150.73 477.65,150.75 478.78,150.77 479.92,150.80 481.05,150.82 482.18,150.83 483.31,150.85 484.45,150.87 485.58,150.89 486.71,150.90 487.85,150.91 488.98,150.93 490.11,150.94 491.24,150.95 492.38,150.96 493.51,150.97 494.64,150.98 495.77,150.99 496.91,151.00 498.04,151.00 499.17,151.01 500.30,151.02 501.44,151.02 502.57,151.03 503.70,151.03 504.83,151.03 505.97,151.04 507.10,151.04 508.23,151.04 509.36,151.04 510.50,151.04 511.63,151.04 512.76,151.04 513.90,151.04 515.03,151.04 516.16,151.04 517.29,151.04 518.43,151.03 519.56,151.03 520.69,151.03 521.82,151.02 522.96,151.02 524.09,151.01 525.22,151.01 526.35,151.00 527.49,151.00 528.62,150.99 529.75,150.98 530.88,150.97 532.02,150.96 533.15,150.95 534.28,150.94 535.41,150.93 536.55,150.92 537.68,150.91 538.81,150.89 539.94,150.88 541.08,150.86 542.21,150.85 543.34,150.83 544.48,150.81 545.61,150.79 546.74,150.77 547.87,150.75 549.01,150.73 550.14,150.70 551.27,150.68 552.40,150.65 553.54,150.62 554.67,150.59 555.80,150.56 556.93,150.53 558.07,150.50 559.20,150.46 560.33,150.42 561.46,150.38 562.60,150.34 563.73,150.30 564.86,150.26 565.99,150.21 567.13,150.17 568.26,150.12 569.39,150.07 570.53,150.01 571.66,149.96 572.79,149.90 573.92,149.84 575.06,149.78 576.19,149.72 577.32,149.65 578.45,149.59 579.59,149.52 580.72,149.45 581.85,149.38 582.98,149.30 584.12,149.22 585.25,149.14 586.38,149.06 587.51,148.98 588.65,148.89 589.78,148.81 590.91,148.72 592.04,148.62 593.18,148.53 594.31,148.43 595.44,148.34 596.58,148.24 597.71,148.13 598.84,148.03 599.97,147.92 601.11,147.81 602.24,147.70 603.37,147.59 604.50,147.48 605.64,147.36 606.77,147.24 607.90,147.12 609.03,147.00 610.17,146.88 611.30,146.76 612.43,146.63 613.56,146.50 613.56,128.31 612.43,128.18 611.30,128.05 610.17,127.93 609.03,127.81 607.90,127.69 606.77,127.57 605.64,127.45 604.50,127.33 603.37,127.22 602.24,127.11 601.11,127.00 599.97,126.89 598.84,126.78 597.71,126.68 596.58,126.57 595.44,126.47 594.31,126.38 593.18,126.28 592.04,126.19 590.91,126.09 589.78,126.00 588.65,125.92 587.51,125.83 586.38,125.75 585.25,125.67 584.12,125.59 582.98,125.51 581.85,125.43 580.72,125.36 579.59,125.29 578.45,125.22 577.32,125.16 576.19,125.09 575.06,125.03 573.92,124.97 572.79,124.91 571.66,124.85 570.53,124.80 569.39,124.74 568.26,124.69 567.13,124.64 565.99,124.60 564.86,124.55 563.73,124.51 562.60,124.47 561.46,124.43 560.33,124.39 559.20,124.35 558.07,124.31 556.93,124.28 555.80,124.25 554.67,124.22 553.54,124.19 552.40,124.16 551.27,124.13 550.14,124.11 549.01,124.08 547.87,124.06 546.74,124.04 545.61,124.02 544.48,124.00 543.34,123.98 542.21,123.96 541.08,123.95 539.94,123.93 538.81,123.92 537.68,123.90 536.55,123.89 535.41,123.88 534.28,123.87 533.15,123.86 532.02,123.85 530.88,123.84 529.75,123.83 528.62,123.82 527.49,123.81 526.35,123.81 525.22,123.80 524.09,123.80 522.96,123.79 521.82,123.79 520.69,123.78 519.56,123.78 518.43,123.78 517.29,123.77 516.16,123.77 515.03,123.77 513.90,123.77 512.76,123.77 511.63,123.77 510.50,123.77 509.36,123.77 508.23,123.77 507.10,123.77 505.97,123.77 504.83,123.78 503.70,123.78 502.57,123.78 501.44,123.79 500.30,123.79 499.17,123.80 498.04,123.81 496.91,123.81 495.77,123.82 494.64,123.83 493.51,123.84 492.38,123.85 491.24,123.86 490.11,123.87 488.98,123.88 487.85,123.90 486.71,123.91 485.58,123.92 484.45,123.94 483.31,123.96 482.18,123.98 481.05,123.99 479.92,124.01 478.78,124.04 477.65,124.06 476.52,124.08 475.39,124.11 474.25,124.13 473.12,124.16 471.99,124.18 470.86,124.21 469.72,124.24 468.59,124.27 467.46,124.30 466.33,124.33 465.19,124.37 464.06,124.40 462.93,124.44 461.80,124.47 460.66,124.51 459.53,124.54 458.40,124.58 457.27,124.61 456.13,124.65 455.00,124.69 453.87,124.72 452.73,124.76 451.60,124.80 450.47,124.83 449.34,124.87 448.20,124.90 447.07,124.93 445.94,124.96 444.81,124.99 443.67,125.02 442.54,125.05 441.41,125.07 440.28,125.09 439.14,125.11 438.01,125.13 436.88,125.14 435.75,125.15 434.61,125.15 433.48,125.15 432.35,125.15 431.22,125.14 430.08,125.13 428.95,125.11 427.82,125.09 426.68,125.06 425.55,125.02 424.42,124.98 423.29,124.93 422.15,124.87 421.02,124.80 419.89,124.73 418.76,124.65 417.62,124.55 416.49,124.45 415.36,124.34 414.23,124.22 413.09,124.09 411.96,123.95 410.83,123.80 409.70,123.63 408.56,123.45 407.43,123.27 406.30,123.07 405.17,122.85 404.03,122.63 402.90,122.38 401.77,122.13 400.63,121.86 399.50,121.58 398.37,121.28 397.24,120.97 396.10,120.64 394.97,120.30 393.84,119.93 392.71,119.56 391.57,119.17 390.44,118.76 389.31,118.35 388.18,117.90 387.04,117.45 385.91,116.98 384.78,116.49 383.65,115.98 382.51,115.46 381.38,114.92 380.25,114.37 379.12,113.80 377.98,113.21 376.85,112.61 375.72,111.99 374.59,111.36 373.45,110.71 372.32,110.05 371.19,109.37 370.05,108.67 368.92,107.97 367.79,107.24 366.66,106.51 365.52,105.76 364.39,105.00 363.26,104.22 362.13,103.44 360.99,102.64 359.86,101.84 358.73,101.02 357.60,100.19 356.46,99.35 355.33,98.51 354.20,97.66 353.07,96.80 351.93,95.93 350.80,95.06 349.67,94.18 348.54,93.30 347.40,92.41 346.27,91.52 345.14,90.63 344.00,89.73 342.87,88.84 341.74,87.94 340.61,87.05 339.47,86.15 338.34,85.26 337.21,84.37 336.08,83.48 334.94,82.60 333.81,81.72 332.68,80.85 331.55,79.98 330.41,79.12 329.28,78.26 328.15,77.42 327.02,76.58 325.88,75.75 324.75,74.93 323.62,74.12 322.49,73.32 321.35,72.52 320.22,71.75 319.09,70.98 317.95,70.23 316.82,69.49 315.69,68.76 314.56,68.04 313.42,67.34 312.29,66.65 311.16,65.98 310.03,65.32 308.89,64.68 307.76,64.05 306.63,63.43 305.50,62.83 304.36,62.25 303.23,61.68 302.10,61.13 300.97,60.59 299.83,60.06 298.70,59.56 297.57,59.06 296.44,58.59 295.30,58.12 294.17,57.67 293.04,57.24 291.91,56.82 290.77,56.42 289.64,56.03 288.51,55.65 287.37,55.29 286.24,54.94 285.11,54.60 283.98,54.28 282.84,53.97 281.71,53.67 280.58,53.39 279.45,53.11 278.31,52.85 277.18,52.60 276.05,52.36 274.92,52.13 273.78,51.90 272.65,51.69 271.52,51.49 270.39,51.29 269.25,51.11 268.12,50.93 266.99,50.76 265.86,50.60 264.72,50.44 263.59,50.30 262.46,50.15 261.32,50.02 260.19,49.89 259.06,49.76 257.93,49.64 256.79,49.52 255.66,49.41 254.53,49.31 253.40,49.20 252.26,49.10 251.13,49.00 250.00,48.91 248.87,48.82 247.73,48.73 246.60,48.64 245.47,48.56 244.34,48.47 243.20,48.39 242.07,48.31 240.94,48.23 239.81,48.15 238.67,48.07 237.54,48.00 236.41,47.92 235.27,47.84 234.14,47.77 233.01,47.69 231.88,47.62 230.74,47.54 229.61,47.47 228.48,47.39 227.35,47.31 226.21,47.24 225.08,47.16 223.95,47.08 222.82,47.00 221.68,46.93 220.55,46.85 219.42,46.77 218.29,46.69 217.15,46.61 216.02,46.53 214.89,46.44 213.76,46.36 212.62,46.28 211.49,46.20 210.36,46.11 209.23,46.03 208.09,45.94 206.96,45.86 205.83,45.77 204.69,45.69 203.56,45.60 202.43,45.52 201.30,45.43 200.16,45.34 199.03,45.26 197.90,45.17 196.77,45.09 195.63,45.00 194.50,44.92 193.37,44.84 192.24,44.75 191.10,44.67 189.97,44.59 188.84,44.51 187.71,44.43 186.57,44.35 185.44,44.28 184.31,44.20 183.18,44.13 182.04,44.06 180.91,43.99 179.78,43.92 178.64,43.85 177.51,43.79 176.38,43.73 175.25,43.67 174.11,43.61 172.98,43.56 171.85,43.51 170.72,43.46 169.58,43.41 168.45,43.37 167.32,43.33 166.19,43.30 165.05,43.27 163.92,43.24 162.79,43.22 161.66,43.20 160.52,43.19 159.39,43.18 158.26,43.17 157.13,43.17 155.99,43.18 154.86,43.19 153.73,43.20 152.60,43.22 151.46,43.25 150.33,43.28 149.20,43.31 148.06,43.36 146.93,43.40 145.80,43.46 144.67,43.52 143.53,43.59 142.40,43.66 141.27,43.74 140.14,43.83 139.00,43.93 137.87,44.03 136.74,44.14 135.61,44.26 134.47,44.38 133.34,44.51 132.21,44.65 131.08,44.80 129.94,44.96 128.81,45.12 127.68,45.30 126.55,45.48 125.41,45.67 124.28,45.87 123.15,46.08 122.01,46.30 120.88,46.53 119.75,46.77 118.62,47.02 117.48,47.27 116.35,47.54 115.22,47.82 114.09,48.11 112.95,48.41 111.82,48.72 110.69,49.04 109.56,49.37 108.42,49.71 107.29,50.07 106.16,50.44 105.03,50.81 103.89,51.20 102.76,51.60 101.63,52.01 100.50,52.44 99.36,52.87 98.23,53.33 97.10,53.79 95.96,54.26 94.83,54.75 93.70,55.24 92.57,55.75 91.43,56.28 90.30,56.81 89.17,57.36 88.04,57.92 86.90,58.50 85.77,59.09 84.64,59.68 83.51,60.30 82.37,60.92 81.24,61.56 80.11,62.21 78.98,62.87 77.84,63.55 76.71,64.24 75.58,64.93 74.45,65.64 73.31,66.37 72.18,67.10 71.05,67.85 69.92,68.60 68.78,69.37 67.65,70.15 66.52,70.93 65.38,71.73 64.25,72.54 63.12,73.35 61.99,74.18 60.85,75.01 59.72,75.86 58.59,76.71 57.46,77.56 56.32,78.43 55.19,79.30 54.06,80.18 52.93,81.06 51.79,81.95 50.66,82.85 49.53,83.75 48.40,84.65 47.26,85.56 46.13,86.46 45.00,87.38 43.87,88.29 42.73,89.20 41.60,90.12 40.47,91.03 39.33,91.95 38.20,92.86 37.07,93.78 35.94,94.69 34.80,95.60 34.80,179.21' fill='#000000' fill-opacity='0.2' stroke='#333333' stroke-opacity='1' stroke-width='0.21' stroke-linejoin='round' stroke-linecap='butt'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e1' cx='607.41' cy='137.41' r='3.47pt' fill='#F94C6A' fill-opacity='0.6' stroke='#F94C6A' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;outlier:&amp;lt;/b&amp;gt; 187' data-id='chepama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e2' cx='570.47' cy='137.41' r='3.47pt' fill='#F94C6A' fill-opacity='0.6' stroke='#F94C6A' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;outlier:&amp;lt;/b&amp;gt; 175' data-id='pachache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e3' cx='548.92' cy='137.41' r='3.47pt' fill='#F94C6A' fill-opacity='0.6' stroke='#F94C6A' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;outlier:&amp;lt;/b&amp;gt; 168' data-id='mapacha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e4' cx='613.56' cy='137.41' r='3.47pt' fill='#F94C6A' fill-opacity='0.6' stroke='#F94C6A' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;outlier:&amp;lt;/b&amp;gt; 189' data-id='chachema'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e5' cx='170.15' cy='137' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chapache:&amp;lt;/b&amp;gt; 45' data-id='chapache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e6' cx='324.21' cy='182.37' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chechapa:&amp;lt;/b&amp;gt; 95' data-id='chechapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e7' cx='287.6' cy='99.16' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chamapa:&amp;lt;/b&amp;gt; 83' data-id='chamapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e8' cx='314.36' cy='109.82' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;mapache:&amp;lt;/b&amp;gt; 92' data-id='mapache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e9' cx='155.28' cy='110.99' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chamache:&amp;lt;/b&amp;gt; 40' data-id='chamache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e10' cx='161.75' cy='215.47' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;pachama:&amp;lt;/b&amp;gt; 42' data-id='pachama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e11' cx='262.95' cy='59' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;mapacha:&amp;lt;/b&amp;gt; 75' data-id='mapacha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e12' cx='231.93' cy='58.19' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;machepa:&amp;lt;/b&amp;gt; 65' data-id='machepa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e13' cx='199.91' cy='202.95' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chachema:&amp;lt;/b&amp;gt; 55' data-id='chachema'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e14' cx='86.49' cy='149.7' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chapama:&amp;lt;/b&amp;gt; 18' data-id='chapama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e15' cx='321.06' cy='184.59' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;pamache:&amp;lt;/b&amp;gt; 94' data-id='pamache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e16' cx='312.15' cy='216.52' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chepama:&amp;lt;/b&amp;gt; 91' data-id='chepama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e17' cx='190.75' cy='180.82' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chamapa:&amp;lt;/b&amp;gt; 52' data-id='chamapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e18' cx='220.62' cy='53.72' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;machapa:&amp;lt;/b&amp;gt; 61' data-id='machapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e19' cx='278.11' cy='191.37' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;pachema:&amp;lt;/b&amp;gt; 80' data-id='pachema'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e20' cx='126.19' cy='150.69' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chemacha:&amp;lt;/b&amp;gt; 31' data-id='chemacha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e21' cx='121.43' cy='190.22' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chechama:&amp;lt;/b&amp;gt; 29' data-id='chechama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e22' cx='99.44' cy='113.11' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chapama:&amp;lt;/b&amp;gt; 22' data-id='chapama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e23' cx='177.32' cy='185' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;pachama:&amp;lt;/b&amp;gt; 47' data-id='pachama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e24' cx='180.16' cy='110.69' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;pachama:&amp;lt;/b&amp;gt; 48' data-id='pachama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e25' cx='215.99' cy='62.22' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;pamacha:&amp;lt;/b&amp;gt; 60' data-id='pamacha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e26' cx='172.78' cy='157.83' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chepama:&amp;lt;/b&amp;gt; 46' data-id='chepama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e27' cx='140.56' cy='139.79' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chechapa:&amp;lt;/b&amp;gt; 35' data-id='chechapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e28' cx='241.83' cy='113.26' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chamapa:&amp;lt;/b&amp;gt; 68' data-id='chamapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e29' cx='95.53' cy='156.05' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;pamache:&amp;lt;/b&amp;gt; 21' data-id='pamache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e30' cx='237.82' cy='158.5' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chemacha:&amp;lt;/b&amp;gt; 67' data-id='chemacha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e31' cx='297.45' cy='209.52' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chamache:&amp;lt;/b&amp;gt; 86' data-id='chamache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e32' cx='34.44' cy='159.18' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chemapa:&amp;lt;/b&amp;gt; 1' data-id='chemapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e33' cx='247.21' cy='109.96' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chepama:&amp;lt;/b&amp;gt; 70' data-id='chepama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e34' cx='265.73' cy='104.04' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chechapa:&amp;lt;/b&amp;gt; 76' data-id='chechapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e35' cx='137.4' cy='114.87' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;mapacha:&amp;lt;/b&amp;gt; 34' data-id='mapacha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e36' cx='123.75' cy='206.73' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chamache:&amp;lt;/b&amp;gt; 30' data-id='chamache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e37' cx='294.13' cy='217' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chechapa:&amp;lt;/b&amp;gt; 85' data-id='chechapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e38' cx='183.23' cy='92.41' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;machache:&amp;lt;/b&amp;gt; 49' data-id='machache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e39' cx='134.38' cy='220.1' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chechama:&amp;lt;/b&amp;gt; 33' data-id='chechama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e40' cx='102.85' cy='140.02' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;pachema:&amp;lt;/b&amp;gt; 23' data-id='pachema'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e41' cx='164.64' cy='129.69' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chapama:&amp;lt;/b&amp;gt; 43' data-id='chapama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e42' cx='117.28' cy='191.05' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;pamache:&amp;lt;/b&amp;gt; 28' data-id='pamache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e43' cx='252.6' cy='84.69' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chamache:&amp;lt;/b&amp;gt; 72' data-id='chamache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e44' cx='339.67' cy='192.33' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;pachama:&amp;lt;/b&amp;gt; 100' data-id='pachama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e45' cx='317' cy='177.45' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chapama:&amp;lt;/b&amp;gt; 93' data-id='chapama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e46' cx='209.91' cy='107.66' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;machepa:&amp;lt;/b&amp;gt; 58' data-id='machepa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e47' cx='111.54' cy='156.13' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chemapa:&amp;lt;/b&amp;gt; 26' data-id='chemapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e48' cx='233.98' cy='76.49' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;machepa:&amp;lt;/b&amp;gt; 66' data-id='machepa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e49' cx='289.84' cy='140.76' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;mapache:&amp;lt;/b&amp;gt; 84' data-id='mapache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e50' cx='255.31' cy='118.67' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;mapacha:&amp;lt;/b&amp;gt; 73' data-id='mapacha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e51' cx='147.56' cy='156.68' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chemapa:&amp;lt;/b&amp;gt; 38' data-id='chemapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e52' cx='326.12' cy='134.35' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chepacha:&amp;lt;/b&amp;gt; 96' data-id='chepacha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e53' cx='268.5' cy='115.33' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chepacha:&amp;lt;/b&amp;gt; 77' data-id='chepacha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e54' cx='75.9' cy='100.04' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chemapa:&amp;lt;/b&amp;gt; 14' data-id='chemapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e55' cx='336.54' cy='159.49' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;mapacha:&amp;lt;/b&amp;gt; 99' data-id='mapacha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e56' cx='45.07' cy='150.65' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chapama:&amp;lt;/b&amp;gt; 4' data-id='chapama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e57' cx='333.82' cy='58.22' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;machache:&amp;lt;/b&amp;gt; 98' data-id='machache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e58' cx='309.06' cy='117.93' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chemapa:&amp;lt;/b&amp;gt; 90' data-id='chemapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e59' cx='158.08' cy='176.56' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chechama:&amp;lt;/b&amp;gt; 41' data-id='chechama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e60' cx='67.72' cy='75.38' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chapache:&amp;lt;/b&amp;gt; 12' data-id='chapache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e61' cx='280.01' cy='108.86' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;machecha:&amp;lt;/b&amp;gt; 81' data-id='machecha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e62' cx='197.88' cy='116.1' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;machecha:&amp;lt;/b&amp;gt; 54' data-id='machecha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e63' cx='204.5' cy='132.97' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;pachema:&amp;lt;/b&amp;gt; 56' data-id='pachema'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e64' cx='184.49' cy='76.78' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;pachecha:&amp;lt;/b&amp;gt; 50' data-id='pachecha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e65' cx='78.61' cy='181.02' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;machapa:&amp;lt;/b&amp;gt; 15' data-id='machapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e66' cx='225.33' cy='218.18' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chepacha:&amp;lt;/b&amp;gt; 63' data-id='chepacha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e67' cx='91.42' cy='158.58' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chapama:&amp;lt;/b&amp;gt; 19' data-id='chapama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e68' cx='59.39' cy='121.9' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;pachache:&amp;lt;/b&amp;gt; 9' data-id='pachache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e69' cx='50.09' cy='56.8' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;machecha:&amp;lt;/b&amp;gt; 6' data-id='machecha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e70' cx='63.44' cy='106.57' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;machepa:&amp;lt;/b&amp;gt; 10' data-id='machepa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e71' cx='222.58' cy='57.45' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;machache:&amp;lt;/b&amp;gt; 62' data-id='machache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e72' cx='72.35' cy='138' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chechapa:&amp;lt;/b&amp;gt; 13' data-id='chechapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e73' cx='142.09' cy='98.87' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chachepa:&amp;lt;/b&amp;gt; 36' data-id='chachepa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e74' cx='80.16' cy='103.08' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;pamache:&amp;lt;/b&amp;gt; 16' data-id='pamache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e75' cx='194.89' cy='69.22' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chechapa:&amp;lt;/b&amp;gt; 53' data-id='chechapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e76' cx='105.36' cy='153.03' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chamapa:&amp;lt;/b&amp;gt; 24' data-id='chamapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e77' cx='229.07' cy='60.47' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chemacha:&amp;lt;/b&amp;gt; 64' data-id='chemacha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e78' cx='329.7' cy='63.49' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chepama:&amp;lt;/b&amp;gt; 97' data-id='chepama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e79' cx='150.85' cy='197.12' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;mapacha:&amp;lt;/b&amp;gt; 39' data-id='mapacha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e80' cx='55.4' cy='64.24' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chemacha:&amp;lt;/b&amp;gt; 8' data-id='chemacha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e81' cx='298.7' cy='176.13' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;pachecha:&amp;lt;/b&amp;gt; 87' data-id='pachecha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e82' cx='213.45' cy='76.92' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chapache:&amp;lt;/b&amp;gt; 59' data-id='chapache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e83' cx='146.67' cy='211.26' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;machecha:&amp;lt;/b&amp;gt; 37' data-id='machecha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e84' cx='275.38' cy='116.86' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chamache:&amp;lt;/b&amp;gt; 79' data-id='chamache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e85' cx='303.72' cy='64.77' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chamache:&amp;lt;/b&amp;gt; 88' data-id='chamache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e86' cx='92.96' cy='70' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chechama:&amp;lt;/b&amp;gt; 20' data-id='chechama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e87' cx='66.32' cy='172.29' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chapama:&amp;lt;/b&amp;gt; 11' data-id='chapama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e88' cx='243.01' cy='152.06' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chechama:&amp;lt;/b&amp;gt; 69' data-id='chechama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e89' cx='305.72' cy='163.68' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chamapa:&amp;lt;/b&amp;gt; 89' data-id='chamapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e90' cx='113.73' cy='85.96' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;pamache:&amp;lt;/b&amp;gt; 27' data-id='pamache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e91' cx='129.51' cy='103.64' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chechapa:&amp;lt;/b&amp;gt; 32' data-id='chechapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e92' cx='47.6' cy='139.69' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;pamacha:&amp;lt;/b&amp;gt; 5' data-id='pamacha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e93' cx='285.02' cy='96.98' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chepacha:&amp;lt;/b&amp;gt; 82' data-id='chepacha'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e94' cx='168.3' cy='66.24' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;mapache:&amp;lt;/b&amp;gt; 44' data-id='mapache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e95' cx='536.77' cy='104.11' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chapache:&amp;lt;/b&amp;gt; 164' data-id='chapache'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e96' cx='505.17' cy='64.71' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;pachama:&amp;lt;/b&amp;gt; 154' data-id='pachama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e97' cx='476.15' cy='105.87' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chechama:&amp;lt;/b&amp;gt; 144' data-id='chechama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e98' cx='416.25' cy='140.34' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chepama:&amp;lt;/b&amp;gt; 125' data-id='chepama'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e99' cx='441.14' cy='117.9' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;chemapa:&amp;lt;/b&amp;gt; 133' data-id='chemapa'/>\n   <circle id='svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_e100' cx='468.21' cy='204.53' r='3.47pt' fill='#000000' fill-opacity='0.6' stroke='#000000' stroke-opacity='0.6' stroke-width='0.71' stroke-linejoin='round' stroke-linecap='round' title='&amp;lt;b&amp;gt;machepa:&amp;lt;/b&amp;gt; 142' data-id='machepa'/>\n   <text transform='translate(602.02,130.86) rotate(-90.00)' font-size='8.54pt' font-weight='bold' font-family='Helvetica' fill='#F94C6A' fill-opacity='1'>chepama<\/text>\n   <text transform='translate(570.83,130.39) rotate(-90.00)' font-size='8.54pt' font-weight='bold' font-family='Helvetica' fill='#F94C6A' fill-opacity='1'>pachache<\/text>\n   <text transform='translate(548.97,130.70) rotate(-90.00)' font-size='8.54pt' font-weight='bold' font-family='Helvetica' fill='#F94C6A' fill-opacity='1'>mapacha<\/text>\n   <text transform='translate(617.45,130.38) rotate(-90.00)' font-size='8.54pt' font-weight='bold' font-family='Helvetica' fill='#F94C6A' fill-opacity='1'>chachema<\/text>\n  <\/g>\n  <g clip-path='url(#svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956_c1)'>\n   <text x='29.28' y='280.57' font-size='6.6pt' font-family='Helvetica' fill='#4D4D4D' fill-opacity='1'>0<\/text>\n   <text x='180.76' y='280.57' font-size='6.6pt' font-family='Helvetica' fill='#4D4D4D' fill-opacity='1'>50<\/text>\n   <text x='332.23' y='280.57' font-size='6.6pt' font-family='Helvetica' fill='#4D4D4D' fill-opacity='1'>100<\/text>\n   <text x='486.16' y='280.57' font-size='6.6pt' font-family='Helvetica' fill='#4D4D4D' fill-opacity='1'>150<\/text>\n  <\/g>\n <\/g>\n<\/svg>","js":null,"uid":"svg_6f87a4e0_f2a7_4423_ae6d_efde15fe6956","ratio":2.25,"settings":{"tooltip":{"css":".tooltip_SVGID_ { font-family: sans-serif; font-size: 70%; color: white; padding: 4px; border-radius: 5px; ; position:absolute;pointer-events:none;z-index:999;}","placement":"doc","opacity":0.7,"offx":10,"offy":0,"use_cursor_pos":true,"use_fill":true,"use_stroke":false,"delay_over":200,"delay_out":500},"hover":{"css":".hover_data_SVGID_ { fill: white; stroke: black; }","reactive":false,"nearest_distance":null},"hover_inv":{"css":""},"hover_key":{"css":".hover_key_SVGID_ { fill:orange;stroke:black;cursor:pointer; }\ntext.hover_key_SVGID_ { stroke:none;fill:orange; }\ncircle.hover_key_SVGID_ { fill:orange;stroke:black; }\nline.hover_key_SVGID_, polyline.hover_key_SVGID_ { fill:none;stroke:orange; }\nrect.hover_key_SVGID_, polygon.hover_key_SVGID_, path.hover_key_SVGID_ { fill:orange;stroke:none; }\nimage.hover_key_SVGID_ { stroke:orange; }","reactive":true},"hover_theme":{"css":".hover_theme_SVGID_ { fill:orange;stroke:black;cursor:pointer; }\ntext.hover_theme_SVGID_ { stroke:none;fill:orange; }\ncircle.hover_theme_SVGID_ { fill:orange;stroke:black; }\nline.hover_theme_SVGID_, polyline.hover_theme_SVGID_ { fill:none;stroke:orange; }\nrect.hover_theme_SVGID_, polygon.hover_theme_SVGID_, path.hover_theme_SVGID_ { fill:orange;stroke:none; }\nimage.hover_theme_SVGID_ { stroke:orange; }","reactive":true},"select":{"css":".select_data_SVGID_ { fill:red;stroke:black;cursor:pointer; }\ntext.select_data_SVGID_ { stroke:none;fill:red; }\ncircle.select_data_SVGID_ { fill:red;stroke:black; }\nline.select_data_SVGID_, polyline.select_data_SVGID_ { fill:none;stroke:red; }\nrect.select_data_SVGID_, polygon.select_data_SVGID_, path.select_data_SVGID_ { fill:red;stroke:none; }\nimage.select_data_SVGID_ { stroke:red; }","type":"multiple","only_shiny":true,"selected":[]},"select_inv":{"css":""},"select_key":{"css":".select_key_SVGID_ { fill:red;stroke:black;cursor:pointer; }\ntext.select_key_SVGID_ { stroke:none;fill:red; }\ncircle.select_key_SVGID_ { fill:red;stroke:black; }\nline.select_key_SVGID_, polyline.select_key_SVGID_ { fill:none;stroke:red; }\nrect.select_key_SVGID_, polygon.select_key_SVGID_, path.select_key_SVGID_ { fill:red;stroke:none; }\nimage.select_key_SVGID_ { stroke:red; }","type":"single","only_shiny":true,"selected":[]},"select_theme":{"css":".select_theme_SVGID_ { fill:red;stroke:black;cursor:pointer; }\ntext.select_theme_SVGID_ { stroke:none;fill:red; }\ncircle.select_theme_SVGID_ { fill:red;stroke:black; }\nline.select_theme_SVGID_, polyline.select_theme_SVGID_ { fill:none;stroke:red; }\nrect.select_theme_SVGID_, polygon.select_theme_SVGID_, path.select_theme_SVGID_ { fill:red;stroke:none; }\nimage.select_theme_SVGID_ { stroke:red; }","type":"single","only_shiny":true,"selected":[]},"zoom":{"min":1,"max":1,"duration":300},"toolbar":{"position":"topright","pngname":"diagram","tooltips":null,"fixed":false,"hidden":["selection","saveaspng"],"delay_over":200,"delay_out":500},"sizing":{"rescale":true,"width":1}}},"evals":[],"jsHooks":[]}</script>

Toca o posa el cursor sobre un punto para ver la información extra! ¿Puedes encontrar el punto que dice *pamache*? 🦝

------------------------------------------------------------------------

{{< cursos >}}

{{< cafecito >}}

[^1]: El código para este gráfico [está disponible en este Gist.](https://gist.github.com/bastianolea/6f26f302f44fe546bebdd61f6134c4c5)

[^2]: En este ejemplo solamente buscaremos outliers que estén *por sobre* la distribución de los datos, pero si queremos buscar datos outliers *por debajo*; es decir, valores pequeños anómalos, la fórmula es la misma pero restando el `1.5 * IQR` al primer cuartil.

[^3]: Esto funciona porque, al anteponer la colita de chancho (`~`) a la función, creamos una *función lambda* que reciba los datos directamente sin tener que especificar el nombre del objeto (conveniente, por ejemplo, si pasaste directo de modificar los datos a hacer el gráfico sin crear un objeto intermedio).

[^4]: En R, decir `variable == TRUE` es lo mismo que decir simplemente `variable`, porque `variable` *es* `TRUE`; o sea que puedes hacer `filter(variable)` en vez de `filter(variable == TRUE)`, y de la misma forma, `filter(!variable)` en vez de `filter(variable == FALSE)`.
