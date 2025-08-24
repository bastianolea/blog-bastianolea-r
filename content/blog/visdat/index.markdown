---
title: Echa un vistazo preliminar a tus datos con {visdat}
author: Bastián Olea Herrera
date: '2025-08-08'
slug: []
categories: []
tags:
  - visualización de datos
  - limpieza de datos
  - consejos
excerpt: El paquete `{visdat}` tiene funciones para visualizar tus conjuntos de datos completos, para poder entenderlos de manera visual antes de proseguir con la limpieza o análisis. El paquete entrega varias funciones `vis_x()` para visualzar la tabla de datos entera, destacando distintos aspectos de la misma. En este post muestro ejemplos de uso de este paquete para encontrar datos perdidos, explorar datos, y más.
---




En una clase reciente me preguntaron cómo saber de una dónde hay datos perdidos o _missing_ en un conjunto de datos. La respuesta que di fue usar `summarize()` para contar la cantidad de datos perdidos en todas las columnas de un dataframe:





``` r
library(dplyr) # manipulación de datos
library(messy) # ensuciar datos

# agregar datos perdidos al azar
iris_m <- iris |> 
  messy::make_missing(cols = names(iris))

iris_m |> 
  # resumir los datos
  summarize(
    # en todas las columnas
    across(everything(),
           # contar la cantidad de missing
           ~sum(is.na(.x))
           )
    )
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1            8          14           11          15      14
```




Pero hay formas más convenientes de hacerlo!

----

[El paquete `{visdat}`](https://github.com/ropensci/visdat) tiene funciones para visualizar tus conjuntos de datos completos, para poder entenderlos de manera visual antes de proseguir con la limpieza o análisis. El paquete entrega varias funciones `vis_x()` para visualzar la tabla de datos entera, destacando distintos aspectos de la misma.





``` r
install.packages("visdat")
library(visdat)
```




En [este post de ROpenSci](https://ropensci.org/blog/2017/08/22/visdat/) hay una reseña más completa del paquete, pero te dejo ejemplos útiles a continuación:










## Visualizar datos perdidos

Para visualizar si es que hay datos perdidos en nuestro dataframe, y además saber _dónde_ están esos datos perdidos, usamos la función `vis_miss()`:





``` r
vis_miss(iris_m)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-1.png" width="672" />




`{visdat}` nos muestra visualmente toda la tabla de datos como un rectángulo, destacando los datos perdidos. ¡Súper útil!

Con el argumento `cluster` podemos agrupar los datos perdidos para tener una mejor noción de la proporción en cada columna.





``` r
vis_miss(iris_m, cluster = TRUE)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" width="672" />




## Visualizar el tipo de las columnas

Con `vis_dat()` vemos con colores distintos las columnas que corresponden a tipos distintos (numérico, caracter, factor, etc.)





``` r
vis_dat(iris)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-6-1.png" width="672" />




## Visualizar los valores de las variables numéricas

Para explorar los datos de tipo numérico, podemos usar `vis_value()` para visualizar con una escala de colores los valores de cada columna, dándonos una noción sobre las cifras dentro de nuestra tabla:





``` r
iris |> 
  select(where(is.numeric)) |> 
  vis_value()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-7-1.png" width="672" />




## Visualizar valores numéricos que cumplan una condición

Para indagar en los datos numéricos, podemos entregar una condición dentro de una función lambda para aplicarla a todas las columnas y visualizar los resultados:




``` r
vis_expect(iris, ~.x >= 5)
```

```
## Warning in Ops.factor(.x, 5): '>=' not meaningful for factors
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" width="672" />

{{< cafecito >}}


{{< cursos >}}


