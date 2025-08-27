---
title: '¿Arte? Nubes aleatorias en `{ggplot2}`'
author: Bastián Olea Herrera
date: '2024-11-08'
format: hugo-md
slug: []
categories: []
tags:
  - ggplot2
  - gráficos
  - curiosidades
  - arte generativo
draft: false
excerpt: >-
  Probando un poco de arte generativo en `{ggplot2}`. La idea era generar
  gráficos que parecieran nubes o humo. 

  Tomé el dataframe `iris`, configuré algunos elementos aleatorios en el
  gráfico, le agregué un efecto de desenfoque a los puntos, y luego hice un loop
  que genera 9 gráficos con parámetros aleatorios.
---


Probando un poco de arte generativo en `{ggplot2}`. La idea era generar gráficos que parecieran nubes o humo.

Tomé el dataframe `iris`, configuré algunos elementos aleatorios en el gráfico, le agregué un efecto de desenfoque a los puntos, y luego hice un loop que genera 9 gráficos con parámetros aleatorios.

``` r
library(dplyr)
library(glue)
library(ggplot2)
library(ggfx)
library(purrr)
```

Partimos con un gráfico base usando los datos de `iris`, donde los puntos crecen en base a una variable, y también aumentan su transparencia en la misma medida que aumentan su tamaño. De esta forma, los puntos más grandes son también menos visibles.

``` r
iris |> 
  ggplot(aes(x = Sepal.Length, y = Sepal.Width, alpha = Petal.Length,
             size = Petal.Length, color = Sepal.Width)) +
  geom_point() +
  theme_void() +
  scale_size(range = c(2, 5)) +
  scale_alpha(range = c(.7, .1)) +
  scale_color_gradient2(low = "red", mid = "purple", high = "blue", 
                        midpoint = mean(iris$Sepal.Width)) +
  theme(legend.position = "none") +
  theme(plot.margin = margin(rep(2, 4))) + # margen interior del gráfico
  coord_cartesian(clip = "off") +
  theme(plot.background = element_rect(fill = "#EAD1FA", linewidth = 0))
```

<img src="index.markdown_strict_files/figure-markdown_strict/unnamed-chunk-2-1.png" width="672" />

Luego que tenemos un gráfico base, hacemos una prueba aplicando `geom_jitter()` a los puntos, que hace que la posición de los puntos sea siempre aleatoria, y cambiamos los rangos de tamaño y de transparencia:

``` r
iris |> 
  ggplot(aes(x = Sepal.Length, y = Sepal.Width, alpha = Petal.Length,
             size = Petal.Length, color = Sepal.Width)) +
  geom_jitter(width = 1, height = 1) +
  theme_void() +
  scale_size(range = c(8, 70)) +
  scale_alpha(range = c(.1, .0)) +
  scale_color_gradient2(low = "red", mid = "purple", high = "blue", 
                        midpoint = mean(iris$Sepal.Width)) +
  theme(legend.position = "none") +
  theme(plot.margin = margin(rep(60, 4))) + # margen interior del gráfico
  coord_cartesian(clip = "off") +
  theme(plot.background = element_rect(fill = "#EAD1FA", linewidth = 0))
```

<img src="index.markdown_strict_files/figure-markdown_strict/unnamed-chunk-3-1.png" width="672" />

Ahora que tenemos un gráfico de movimiento aleatorio, agregamos a `geom_jitter()` la función `with_blur()` del paquete `{ggfx}`, que desenfoca el elemento al que se la apliquemos. Así creamos el efecto de humo o nube:

``` r
iris |> 
  ggplot(aes(x = Sepal.Length, y = Sepal.Width, alpha = Petal.Length,
             size = Petal.Length, color = Sepal.Width)) +
  geom_jitter(width = 1, height = 1) |> with_blur(sigma = 7) +
  theme_void() +
  scale_size(range = c(8, 70)) +
  scale_alpha(range = c(.1, .0)) +
  scale_color_gradient2(low = "red", mid = "purple", high = "blue", 
                        midpoint = mean(iris$Sepal.Width)) +
  theme(legend.position = "none") +
  theme(plot.margin = margin(rep(60, 4))) + # margen interior del gráfico
  coord_cartesian(clip = "off") +
  theme(plot.background = element_rect(fill = "#EAD1FA", linewidth = 0))
```

<img src="index.markdown_strict_files/figure-markdown_strict/unnamed-chunk-4-1.png" width="672" />

Una vez que tenemos un gráfico interesante, le agregamos más parámetros aleatorios, y lo metemos dentro de `purrr::map()` para generar muchos gráficos de una sola vez:

``` r
map(1:9, ~{
  # parámetros aleatorios
  jitter_x = sample(seq(0.7, 1.2, 0.1), 1) # 1
  jitter_y = sample(seq(0.7, 1.2, 0.1), 1) # 1
  tamaño_max = sample(seq(40, 80, 5), 1) # 60
  tamaño_min = sample(seq(5, 20, 5), 1) # 10
  centro_color = sample(iris$Sepal.Width, 1)
  
  # generar
  iris |> 
    ggplot(aes(x = Sepal.Length, y = Sepal.Width, alpha = Petal.Length,
               size = Petal.Length, color = Sepal.Width)) +
    geom_jitter(width = jitter_x, height = jitter_y) |> with_blur(sigma = 9) +
    theme_void() +
    scale_size(range = c(tamaño_min, tamaño_max)) +
    scale_alpha(range = c(.07, .0)) +
    scale_color_gradient2(low = "red", mid = "purple", high = "blue", 
                          midpoint = centro_color) +
    theme(legend.position = "none") +
    theme(plot.margin = margin(rep(60, 4))) + # margen interior del gráfico
    coord_cartesian(clip = "off") +
    theme(plot.background = element_rect(fill = "#EAD1FA", linewidth = 0))
  
  # guardar
  # ggsave(glue("nubes/orbe_{sample(111:999, 1)}.png"), 
  #        width = 3, height = 3, scale = 2, dpi = 200)
})
```

    [[1]]

<img src="index.markdown_strict_files/figure-markdown_strict/unnamed-chunk-5-1.png" width="672" />


    [[2]]

<img src="index.markdown_strict_files/figure-markdown_strict/unnamed-chunk-5-2.png" width="672" />


    [[3]]

<img src="index.markdown_strict_files/figure-markdown_strict/unnamed-chunk-5-3.png" width="672" />


    [[4]]

<img src="index.markdown_strict_files/figure-markdown_strict/unnamed-chunk-5-4.png" width="672" />


    [[5]]

<img src="index.markdown_strict_files/figure-markdown_strict/unnamed-chunk-5-5.png" width="672" />


    [[6]]

<img src="index.markdown_strict_files/figure-markdown_strict/unnamed-chunk-5-6.png" width="672" />


    [[7]]

<img src="index.markdown_strict_files/figure-markdown_strict/unnamed-chunk-5-7.png" width="672" />


    [[8]]

<img src="index.markdown_strict_files/figure-markdown_strict/unnamed-chunk-5-8.png" width="672" />


    [[9]]

<img src="index.markdown_strict_files/figure-markdown_strict/unnamed-chunk-5-9.png" width="672" />

Si queremos guardar los resultados a una carpeta, agregamos el siguiente código dentro de la iteración con `map()` para guardar los gráficos en una carpeta, dándole a los archivos nombres aleatorios para que no se sobreescriban.

``` r
# guardar
ggsave(glue("nubes_{sample(111:999, 1)}.png"),
       width = 3, height = 3, scale = 2, dpi = 200)
```
