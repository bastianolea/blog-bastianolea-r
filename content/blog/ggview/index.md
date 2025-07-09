---
title: "Controla las dimensiones de tus gráficos con {ggview}"
author: "Bastián Olea Herrera"
date: '2025-07-08'
slug: []
draft: false
categories: []
tags:
  - "visualización de datos"
  - "gráficos"
  - "ggplot2"
excerpt: "¿Te ha pasado que estás haciendo un gráfico con `{ggplot2}` pero al momento de guardarlo te das cuenta que sale en otro tamaño y en otra proporción? Entonces este consejo es para ti: `{ggview}` es un paquete de R que te ayuda a previsualizar gráficos en `{ggplot2}` manteniendo un tamaño fijo."
---

[`{ggview}`](https://github.com/idmn/ggview) es un paquete de R que te ayuda a crear gráficos en `{ggplot2}` manteniendo un tamaño fijo.

En RStudio, los gráficos que aparecen en el panel de gráficos (_Plots_) se adaptan al tamaño de dicho panel. Por ejemplo, si tu panel es chico, el gráfico no tendría espacio para verse bien:

{{< imagen "grafico_chico.png">}}

Pero si amplías el tamaño del panel lo suficiente, el gráfico se verá mejor:

{{< imagen "grafico_rstudio.png">}}

Esto es conveniente para ir explorando visualizaciones, pero puede confundirte cuando quieras guardar el gráfico. Una vez que tu gráfico está listo, procedes a guardarlo...

```r
ggsave("grafico.jpg")
```

Pero cuando abres el gráfico, sorpresa, se ve distinto! 🙄

{{< imagen "grafico_guardado.png">}}

Esto es porque las dimensiones del panel _Plots_ no son las mismas que las dimensiones con que se guardan por defecto los gráficos. En la función `ggsave()` puedes especificar ancho, alto y resolución de la imagen que se va a guardar. Entonces, lo que podrías hacer es intentar configurar `ggsave()` para que el gráfico se guarde como tú esperas... pero a veces esto se vuelve en un juego de ir adivinando, intentando números varias veces hasta que le achuntas al gráfico que esperabas.

Una mejor alternativa es usar `{ggview}` para previsualizar tus gráficos con un tamaño fijo:

```r
library(ggview)

grafico + canvas(7, 5)
```

{{< imagen "grafico_ggview-featured.png">}}

De esta forma, no importa el tamaño de tu ventana de RStudio: tu gráfico se previsualizará con la resolución y proporción que tu especifiques.

Recomiendo empezar a usar `ggview::canvas()` cuando tu gráfico ya está casi completo y te pones a afinar detalles estéticos finales.

Cuando ya sea la hora de guardar el gráfico como una imagen, si usas la función `ggview::save_ggplot()` (no confundir con la común, `ggsave()`), el gráfico se guardará con las dimensiones que habías puesto en `canvas()` y se verá exactamente como lo estabas previsualizando en RStudio!

```r
grafico_2 <- grafico + canvas(7, 5)

save_ggplot(grafico_2, "grafico_2.jpg") # mantiene las dimensiones 
```
