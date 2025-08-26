---
title: Temas de colores personalizados para tus gráficos {ggplot2}
author: Bastián Olea Herrera
date: '2025-08-26'
draft: false
freeze: true
format:
  hugo-md:
    output-file: "index"
    output-ext: "md"
slug: []
categories: []
tags:
  - visualización de datos
  - ggplot2
  - gráficos
excerpt: "Darle un toque de color a tus gráficos produce visualizaciones con más personalidad y mayor impacto. Pero cambiar el color de cada elemento puede ser engorroso. Para ayudarte eso existe el paquete `{thematic}`. En este post vemos cómo usar `{thematic}` para cambiar fácilmente los colores de fondo de tus gráficos."
---



Darle un toque de color a tus gráficos produce visualizaciones con **más personalidad** y **mayor impacto**. Pero cambiar el color de cada elemento puede ser engorroso. Para ayudarte con eso existe el [paquete `{thematic}`](https://rstudio.github.io/thematic/)! En este post vemos cómo usar `{thematic}` para cambiar fácilmente los colores de tus gráficos.

Primero generemos datos al azar para crear una visualización de demostración:




``` r
library(dplyr)

# crear datos al azar
datos <- tibble(a = 1:10,
                b = rnorm(10, mean = 7, sd = 2)
                )
```



Ahora creemos un gráfico básico:



``` r
library(ggplot2)

grafico <- datos |> 
  ggplot() +
  aes(x = as.factor(a), y = b) +
  geom_col(width = 0.5) +
  geom_text(aes(label = round(b, 0), y = b + 0.6), 
            size = 3, fontface = "bold")

grafico
```

<img src="/blog/ggplot_temas/ggplot_temas_files/figure-html/unnamed-chunk-2-1.png" width="672" />



Agreguemos algunas capas extra para mejorar la apariencia de nuestro gráfico:



``` r
grafico <- grafico +
  labs(title = "Gráfico de barras",
       subtitle = "Números al azar",
       x = "Eje horizontal", y = "Eje vertical",
       caption = "Fuente: de los deseos") +
  scale_y_continuous(expand = expansion(c(0, 0.05))) +
  theme(plot.title = element_text(face = "bold"),
        panel.grid.minor.y = element_line(linetype = 2, linewidth = .5),
        axis.ticks.x = element_blank())

grafico
```

<img src="/blog/ggplot_temas/ggplot_temas_files/figure-html/unnamed-chunk-3-1.png" width="672" />



Ahora que tenemos un gráfico, probemos `{thematic}`. La idea es que tenemos que _activar_ la función que genera los temas con `thematic_on()`, y en el momento que la activamos, definimos los **colores principales** de nuestro tema. Estos colores son de **fondo** (`bg`) y de **frente** (`fg`), que como su nobre lo indica, definen el color base del gráfico y el color de los elementos principales.




``` r
library(thematic)

thematic_on(fg = "#553A74",
            bg = "#EAD2FA")

grafico
```

<img src="/blog/ggplot_temas/ggplot_temas_files/figure-html/unnamed-chunk-4-1.png" width="672" />



Solamente con definir dos colores con `thematic_on()` e imprimir el gráfico obtenemos el gráfico con el tema aplicado. Muy lindo 💜

Para encontrar pares de colores interesantes, recomiendo el sitio [Pigment](https://pigment.shapefactory.co), que genera pares de colores a los que puedes ajustar su saturación y su nivel de iluminación.



{{< imagen "pigment.png" >}}




Veamos algunos ejemplos de como queda el mismo gráfico con otros pares de colores: 






``` r
thematic_on(fg = "#6A3F5B",
            bg = "#E28B9F")

grafico
```

<img src="/blog/ggplot_temas/ggplot_temas_files/figure-html/unnamed-chunk-6-1.png" width="672" />


``` r
thematic_on(fg = "#81BFC3",
            bg = "#684D5B")

grafico
```

<img src="/blog/ggplot_temas/ggplot_temas_files/figure-html/unnamed-chunk-7-1.png" width="672" />


``` r
thematic_on(fg = "#524337",
            bg = "#C4B495")

grafico
```

<img src="/blog/ggplot_temas/ggplot_temas_files/figure-html/unnamed-chunk-8-1.png" width="672" />



Para desactivar la aplicación del tema de colores, usa `thematic_off()` y volverás a la aburrida normalidad.




``` r
thematic_off()

grafico
```

<img src="/blog/ggplot_temas/ggplot_temas_files/figure-html/unnamed-chunk-9-1.png" width="672" />



¡Así de simple! Claramente es una forma **básica y rápida** de personalizar la apariencia de las visualizaciones, pero el resultado suele ser positivo considerando el poquísimo esfuerzo necesario para lograrlo. Eficiencia, yey! 🥰



{{< cafecito >}}


{{< cursos >}}

