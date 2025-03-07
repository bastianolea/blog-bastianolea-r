---
title: Creación y personalización de paletas de colores en R
author: Bastián Olea Herrera
date: '2025-03-06'
format:
  hugo-md:
    output-file: "index"
    output-ext: "md"
slug: []
categories: []
tags:
  - visualización de datos
  - gráficos
  - ggplot2
execute:
  messages: false
---




El uso del color es clave para comunicar, y el ecosistema de R tiene varios trucos convenientes para ayudarnos a usar el color de mejores formas. 

El primer consejo que usaremos a lo largo de este post es la función `swatch()` del paquete {shades}, que genera una paleta a partir de un vector de colores, lo que nos ayudará a visualizar nuestros colores más fácil. También usaremos {colorspace}, otro paquete conveniente para trabajar con color.




``` r
library(shades)
library(colorspace)
```

```
## 
## Attaching package: 'colorspace'
```

```
## The following object is masked from 'package:shades':
## 
##     coords
```




## Extender paletas de colores

Si tienes un vector de colores y necesitas alargarlo para tener más colores basados en la paleta original, la función `colorRampPalette()` crea una función a partir del vector de colores, cuyo argumento es el número de colores que necesites obtener a partir de la paleta original:




``` r
paleta <- c("#f4b43f", "#ec6a2d", "#cc3b7b", "#705ce6", "#668cf6")

paleta |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-2-1.png" width="672" />

``` r
colorRampPalette(paleta)(12) |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-2-2.png" width="672" />



También podemos usar esta función para crear con facilidad una paleta secuencial entre dos o más colores:



``` r
colores <- c("#df65b2", "#fae55f")

colorRampPalette(colores)(8) |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-3-1.png" width="672" />




## Paletas de colores
Varios paquetes de R contienen sus propias paletas de colores prediseñadas.




``` r
RColorBrewer::display.brewer.all()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-4-1.png" width="864" />


``` r
colorspace::hcl_palettes(plot = TRUE)
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-5-1.png" width="1152" />



Encuentro una lista que compila todas las paletas de colores de la comunidad de R [en este repositorio.](https://github.com/EmilHvitfeldt/r-color-palettes)


## Paletas secuenciales

Las paletas secuenciales consiste en un degradado entre dos o más colores. Suelen usarse para representar una variable continua o numérica, cuyo valor va cambiando de forma cuantitativa.

La función `sequential_hcl()` del paquete {colorspace} permite crear paletas secuenciales




``` r
colorspace::sequential_hcl(8, h = 300) |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-6-1.png" width="672" />

``` r
colorspace::sequential_hcl(8, h = c(300, 100)) |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-6-2.png" width="672" />

``` r
colorspace::sequential_hcl(5, h = 260,
                           c = c(45, 25), l = c(25, 85), power = .9) |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-6-3.png" width="672" />



También se pueden obtener vectores de colores a partir de las paletas existentes que vienen con el paquete {colorspace}:




``` r
colorspace::sequential_hcl(5, palette = "Red-Blue") |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-7-1.png" width="672" />

``` r
colorspace::sequential_hcl(5, palette = "Purple-Orange") |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-7-2.png" width="672" />




## Paletas cualitativas

Como su nombre ética, en las paletas cualitativas los colores van saltando para maximizar la diferencia entre ellos. Se utilizan para variables cualitativas, categóricas o discretas, donde cada elemento de una secuencia es independiente de los demás, y el objetivo del uso del color es poder distinguirlos. 

La función `rainbow_hcl()` de {colorspace} entrega una típica paleta de arcoíris, pero con la posibilidad de modificar sus atributos de color en sus argumentos, tales como las tonalidades (_hue_) de inicio o final, la intensidad (_chroma_) de los tonos



``` r
colorspace::rainbow_hcl(7, c = 70) |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-8-1.png" width="672" />

``` r
colorspace::rainbow_hcl(7, c = 100, start = 190, end = 380) |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-8-2.png" width="672" />

``` r
colorspace::rainbow_hcl(6, c = 60, l = 30, start = 230, end = 370) |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-8-3.png" width="672" />


Éste tipo de paletas usualmente reúne colores en una escala tipo arcoíris, o bien reúne colores temáticos, distintos entre ellos, pero armónicos entre sí.

También pueden usarse los nombres de las paredes preexistentes para generar una secuencia cualitativa con ellos.



``` r
colorspace::qualitative_hcl(6, palette = "Cold", c = 80) |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-9-1.png" width="672" />

``` r
colorspace::qualitative_hcl(6, palette = "Warm", c = 80) |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-9-2.png" width="672" />




## Paletas divergentes

Las paletas divergentes se utilizan cuando una variable expresa a dos polos, una una misma magnitud donde los extremos son separados por una brecha central.




``` r
colorspace::diverging_hcl(n = 5, h = c(200, 300)) |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-10-1.png" width="672" />

``` r
colorspace::diverging_hcl(n = 7, h = c(700, 180)) |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-10-2.png" width="672" />

``` r
colorspace::diverging_hcl(n = 7, h = c(700, 180), c = 130, alpha = .7) |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-10-3.png" width="672" />





## Modificar colores

Las funciones del paquete {shades} nos permitan obtener información detallada sobre cada uno de los colores, y usar esta misma información para modificarlos con mucho detalle.

Por ejemplo, definamos un color, y luego obtengamos el valor de su tonalidad. Recordemos que la tonalidad de los colores se expresan como grados entre 0° y 360°.



``` r
library(shades)

color <- "#f65b74"

swatch(color)
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-11-1.png" width="672" />

``` r
hue(color)
```

```
## [1] 350.3226
```



Obtenemos que, para el color definido, el valor de su tonalidad es 350. Podemos usar esta información para modificar levemente el mismo color y así obtener una variable del mismo color levemente más anaranjada.



``` r
swatch(c(color, hue(color, 370)))
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-12-1.png" width="672" />



Podemos obtener mismos resultados utilizando el _delta_ de la tonalidad del color; es decir, sumándole restándole una cantidad de grados a el valor de la tonalidad del color mismo:



``` r
swatch(c(color, hue(color, delta(50))))
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-13-1.png" width="672" />


Al usar la función `delta()`, lo que hacemos es pedirle que cambie la tonalidad del color en 50°, volviéndose en un tono amarillo.



El brillo (_brighness_) va de cero a uno, mientras que la claridad (_loghtness_) va de cero a 100.



``` r
color |> brightness(0.7) |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-14-1.png" width="672" />

``` r
color |> lightness(delta(20)) |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-14-2.png" width="672" />



Por su parte, la saturación aumenta la intensidad del color.



``` r
color |> saturation(delta(30)) |> swatch()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-15-1.png" width="672" />



Podemos utilizar la función `delta()` para crear una sencilla paleta de colores a partir de un mismo color, aumentando y disminuyendo su intensidad (_chroma_):



``` r
swatch(
  c(color |> chroma(delta(30)), 
    color,
    color |> chroma(delta(-30)))
)
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-16-1.png" width="672" />



Podemos combinar estas técnicas para crear una paleta de colores más compleja, construida toda a partir de un solo color al cual se le va aumentando o disminuyendo sus valores de claridad e intensidad. El beneficio de hacerlo de esta manera es que luego basta con cambiar el color principal para obtener una paleta de iguales características, pero basada en una tonalidad distinta.



``` r
color_principal = "#4D4484"

color_fondo = color_principal |> lightness(13) |> chroma(20)
color_detalle = color_principal |> lightness(20) |> chroma(40)
color_destacado = color_principal |> lightness(50) |> chroma(65)
color_texto = color_principal |> lightness(80)

swatch(c(color_principal,
         color_fondo,
         color_detalle,
         color_destacado,
         color_texto))
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-17-1.png" width="672" />


``` r
color_principal = "#3170ac"

color_fondo = color_principal |> lightness(13) |> chroma(20)
color_detalle = color_principal |> lightness(20) |> chroma(40)
color_destacado = color_principal |> lightness(50) |> chroma(65)
color_texto = color_principal |> lightness(80)

swatch(c(color_principal,
         color_fondo,
         color_detalle,
         color_destacado,
         color_texto))
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-18-1.png" width="672" />



Notar que el código es igual, y sólo se cambió el valor del `color_principal`. Esta estrategia es muy útil si se están produciendo visualizaciones o aplicaciones que ocupan una paleta de colores monocroma.


## Mezclar colores
Las funciones `submix()` y `addmix()` del paquete {shades} facilitan el mezclado de colores sustraje ctivo y aditivo, respectivamente. A partir de dos colores, entrega la mezcla de ellos, abriendo muchas posibilidades para la experimentación y creación de nuevos colores:




``` r
swatch(c("#70f1d5",
         submix("#70f1d5", "#fae55f"),
         "#fae55f"))
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-19-1.png" width="672" />


``` r
swatch(c("#3377f7",
         addmix("#3377f7", "#ec4e3c"),
         "#ec4e3c"))
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-20-1.png" width="672" />


``` r
swatch(c("#f9ce45",
         submix("#f9ce45", "#77d671", amount = 0.5),
         "#77d671"))
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-21-1.png" width="672" />




## Usar paletas de colores en {ggplot2}
Muchas de estos paquetes incorporan funciones de escalas de colores (`scale_color_x()`, `scale_fill_x()`) para aplicar una paleta de color fácilmente a un gráfico creado {ggplot2}.




``` r
library(ggplot2)
library(dplyr)
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
iris |> 
  ggplot() +
  geom_bar(aes(Petal.Width, fill = Species)) +
  colorspace::scale_fill_discrete_qualitative(palette = "Dark 3") +
  scale_y_continuous(expand = expansion(c(0, 0.1))) +
  theme_classic()
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-22-1.png" width="672" />

``` r
iris |> 
  ggplot() +
  geom_point(aes(Sepal.Width, Sepal.Length, color = Petal.Width, size = Petal.Length), alpha = .8) +
  colorspace::scale_color_continuous_sequential(palette = "Sunset", na.value = "white") +
  theme_classic() +
  guides(size = guide_legend(override.aes = list(color = "#784FA1")),
         color = guide_colorsteps()) +
  theme(legend.title = element_blank(),
        axis.title = element_blank())
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-22-2.png" width="672" />

``` r
iris |> 
  ggplot() +
  geom_point(aes(Petal.Length, Sepal.Width, color = Petal.Width, size = Sepal.Length), alpha = .8) +
  viridis::scale_colour_viridis("viridis", na.value = "white") +
  theme_classic() +
  guides(size = guide_legend(override.aes = list(color = "#88D181")),
         color = guide_colorsteps()) +
  theme(legend.title = element_blank(),
        axis.title = element_blank())
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-22-3.png" width="672" />





## Avanzado

{colorspace} incluye funciones para poder visualizar secuencias de colores en proyecciones del espacio de color HCL (_hue, chroma, luminance_), lo que nos permite contextualizar las paletas en un espacio perceptual del color basado ene stos tres parámetros.



``` r
colorspace::hclplot(sequential_hcl(7, h = 260, c = 80, l = c(35, 95), power = 1.5))
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-23-1.png" width="672" />

``` r
colorspace::hclplot(sequential_hcl(7, h = c(260, 220), c = c(50, 75, 0), l = c(30, 95), power = 1))
```

<img src="/blog/colores/colores_files/figure-html/unnamed-chunk-23-2.png" width="672" />



----

## Fuentes y recursos

- https://github.com/EmilHvitfeldt/r-color-palettes
- https://r-graph-gallery.com/ggplot2-color.html
- https://www.datanovia.com/en/blog/top-r-color-palettes-to-know-for-great-data-visualization/
- https://jbengler.github.io/tidyplots/articles/Color-schemes.html



{{< cafecito >}}

