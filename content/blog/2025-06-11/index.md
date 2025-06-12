---
title: 'Feliz cumpleaños, {ggplot2}!'
author: Bastián Olea Herrera
date: '2025-06-11'
slug: []
categories: []
format:
  hugo-md:
    output-file: index
    output-ext: md
tags:
  - ggplot2
  - gráficos
excerpt: >-
  Hoy está de cumpleaños el paquete `{ggplot2}` para visualización de datos en
  R! Así que le hice un gráfico de mini celebración en 20 líneas.
---


Hoy está de cumpleaños [el paquete `{ggplot2}`](https://ggplot2.tidyverse.org) para visualización de datos en R! Este paquete es indispensable para explorar el mundo de los datos, ya que su [filosofía o gramática](https://ggplot2-book.org/mastery.html) está muy bien lograda, su simplicidad ayuda a llegar a resultados útiles en pocos pasos, y su flexibilidad posibilita crear casi lo que desees, siempre siguiendo principios firmemente sostenidos en un enfoque de ciencia de datos. El paquete cumple 18 años desde su creación por [Hadley Wickham](https://hadley.nz), _Chief Scientist_ de [Posit](https://posit.co) y jefe del equipo [Tidyverse](https://www.tidyverse.org).

Se trata de una herramienta que uso día a día, así que con mucho cariño (🤪) le hice un gráfico de mini celebración en 20 líneas 💜

``` r
library(ggplot2)
library(dplyr)
library(ggtext)
library(ragg)

tibble(x = sample(1:18), y = sample(1:18)) |> 
  ggplot() +
  geom_text(aes(label = "⭐️", y, x), size = 4) +
  geom_text(aes(label = "🎈", x, y, size = y)) +
  annotate("text", y = -1, x = 18/2, hjust = 0.5, 
           label = "🎂", size = 12) +
  theme_void() +
  coord_cartesian(xlim = c(0, 18), ylim = c(-2, 20)) +
  scale_size(range = c(4, 9)) +
  guides(size = guide_none()) +
  labs(title = "Feliz cumpleaños <span style='font-family:
                Menlo;'>{ggplot2}</span> 🎉") +
  theme(plot.title = element_markdown(family = "Helvetica"),
        plot.margin = margin(8, 8, 8, 8))
```

{{< imagen "grafico_ggplot_cumple.jpeg" >}}

El gráfico usa números al azar para poner globos y estrellas. Los globitos crecen con respecto al eje *y*, mientras que la torta simplemente se ubica abajo y al centro.

{{< imagen "linkedin.jpg" >}}

Partió de una idea mucho más sencilla que comenté [en una publicación de celebración que hizo Hadley Wickham](https://www.linkedin.com/posts/hadleywickham_rstats-activity-7338353740267122688-ELEh), desarrollador de `{ggplot2}`, `{dplyr}` y muchos más paquetes del [Tidyverse](https://www.tidyverse.org).

El original era así de simple:

``` r
tibble(a = sample(1:18, 18),
 b = sample(1:18, 18)) |> 
 ggplot() +
 aes(a, b, size = b) +
 geom_text(aes(label = "🎈")) +
 theme_void() +
 guides(size = guide_none())
```

Intenta reproducirlo en tu R! Si no te resulta, puede deberse a que el backend gráfico por defecto de R tiene problemas con los textos complejos, como los emojis. En las configuraciones de RStudio, entra a *General* y luego en *Graphics* puedes cambiar el backend por uno como AGG (del [paquete `{ragg}`](https://ragg.r-lib.org))

<!-- {{< imagen "grafico_ggplot_cumple_penca.png" >}} -->

Si quieres aprender `{ggplot2}` desde cero, [revisa este tutorial gratuito que hice](../../../blog/r_introduccion/tutorial_visualizacion_ggplot/), donde te explico a usar esta útil y flexible herramienta desde lo más sencillo, con muchos ejemplos de visualizaciones aplicadas a datos reales.
