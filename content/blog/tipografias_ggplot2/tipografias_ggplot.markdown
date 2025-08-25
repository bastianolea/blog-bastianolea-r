---
title: Usar tipografías personalizadas en gráficos {ggplot2}
author: Bastián Olea Herrera
date: '2025-08-25'
draft: true
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
execute: 
  warning: false
---



¿Quieres darle un toque personalizado a tus gráficos? O tal vez alinearlos mejor al mensaje que quieres entregar, o a los lineamientos estéticos de tu organización. En esta breve guía te explico cómo cambiar las tipografías, tipos de letra o fuentes de tus gráficos hechos en R [con `{ggplot2}`](/tags/ggplot2/).

Para demostrar, primero creemos datos ficticios siguiento distribuciones normales:




``` r
library(ggplot2)
library(dplyr)

# crear datos al azar
datos <- tibble(a = rnorm(20, mean = 10, sd = 1),
                b = rnorm(20, mean = 10, sd = 1),
                c = round(rnorm(20, mean = 10, sd = 1), 1))
```



Ahora creemos un gráfico de dispersión como muestra, con un poco de texto extra:




``` r
grafico <- datos |> 
  ggplot() +
  aes(x = a, y = b) +
  geom_point(size = 2, alpha = 0.4) +
  labs(title = "Gráfico de dispersión",
       subtitle = "Números al azar",
       x = "Eje horizontal", y = "Eje vertical",
       caption = "Fuente: de los deseos") +
  theme_light(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))
```



Por defecto, `{ggplot2}` usa las tipografías Helvetica en Mac y Arial en Windows:




``` r
grafico
```

<img src="/blog/tipografias_ggplot2/tipografias_ggplot_files/figure-html/unnamed-chunk-3-1.png" width="672" />



A pesar de no ser malas tipografías, se vuelven aburridas rápidamente.




{{< aviso "Si necesitas aprender a usar `{ggplot2}` para gráficos en R, primero revisa [este tutorial introductorio!](http://localhost:4321/blog/r_introduccion/tutorial_visualizacion_ggplot/)" >}}




## Tipografías instaladas

Podemos cambiar la tipografía de los gráficos `{ggplot2}` fácilmente si éstas se encuentran instaladas en tu computador. Por ejemplo, La tipografía _Menlo_ que viene por defecto en Mac.

Para establecer la tipografía de los gráficos, modificamos desde el tema (`theme()`) los elementos de texto (`text = element_text()`), especificando en el argumento `family` el nombre de la tipografía:




``` r
# especificar tipografía desde el tema
grafico +
  theme(text = element_text(family = "Menlo"))
```

<img src="/blog/tipografias_ggplot2/tipografias_ggplot_files/figure-html/unnamed-chunk-4-1.png" width="672" />



Si agregamos capas de texto al gráfico (con `geom_text()`, `geom_label()` u otros), tenemos que especificar la tipografía que usaremos en cada capa. En el siguiente ejemplo, agregamos con `geom_text_repel()` una [capa de texto que se repele de los puntos y otras etiquetas de texto automáticamente](/blog/ggrepel/).




``` r
# especificar tipografía para geom_text() y también para el tema
grafico +
  ggrepel::geom_text_repel(aes(label = c), family = "Menlo") +
  theme(text = element_text(family = "Menlo"))
```

<img src="/blog/tipografias_ggplot2/tipografias_ggplot_files/figure-html/unnamed-chunk-5-1.png" width="672" />






## Showtext




``` r
library(showtext)
```

```
## Loading required package: sysfonts
```

```
## Loading required package: showtextdb
```

``` r
# descargar una tipografía desde google fonts
font_add_google(name = "Pacifico")

# activar tipografías
showtext_auto()
showtext_opts(dpi = 300)

# usar la tipografía desde Google Fonts
grafico +
  ggrepel::geom_text_repel(aes(label = c), family = "Pacifico") +
  theme(text = element_text(family = "Pacifico"))
```

<img src="/blog/tipografias_ggplot2/tipografias_ggplot_files/figure-html/unnamed-chunk-6-1.png" width="672" />




## Descargar

https://fonts.google.com/specimen/Arvo

- `Arvo-Bold.ttf`
- `Arvo-BoldItalic.ttf`
- `Arvo-Italic.ttf`
- `Arvo-Regular.ttf`




``` r
# agregar una tipografía desde un archivo
font_add("Arvo", 
         regular = "tipografías/Arvo-Regular.ttf",
         bold = "tipografías/Arvo-Bold.ttf")

# activar tipografías
showtext_auto()
showtext_opts(dpi = 300)

# probar tipografía descargada como archivo desde Google Fonts
grafico +
  ggrepel::geom_text_repel(aes(label = c), family = "Arvo") +
  theme(text = element_text(family = "Arvo"))
```

<img src="/blog/tipografias_ggplot2/tipografias_ggplot_files/figure-html/unnamed-chunk-7-1.png" width="672" />


``` r
# descargar tipografía desde Google Fonts
gfonts::setup_font("arvo", "tipografías")
```

{{< cafecito >}}


{{< cursos >}}

