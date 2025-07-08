---
title: Controla las dimensiones de tus gráficos con {ggview}
author: Bastián Olea Herrera
date: '2025-07-08'
slug: []
draft: false
categories: []
tags:
  - visualización de datos
  - gráficos
  - ggplot2
---

[`{ggview}`](https://github.com/idmn/ggview) es un paquete de R que te ayuda a crear gráficos en `{ggplot2}` manteniendo un tamaño fijo. ¿Para qué serviría esto?

En RStudio, los gráficos que aparecen en el panel de gráficos (_Plots_) adquieren el tamaño de dicho panel. Por ejemplo, si tu panel es chico, el gráfico no tendría espacio para verse bien:


{{< imagen "grafico_chico.png">}}

Pero si amplías el tamaño del panel lo suficiente, el gráfico se verá mejor:

{{< imagen "grafico_rstudio.png">}}

Una vez que tu gráfico está listo, procedes a guardarlo:
```{r}
ggsave("grafico.jpg")
```

Pero cuando abres el gráfico, sorpresa, se ve distinto!

{{< imagen "grafico_guardado.png">}}

Esto es porque las dimensiones del panel _Plots_ no son las mismas que las dimensiones con que se guardan por defecto los gráficos. Entonces, lo que podrías hacer es intentar configurar `ggsave()` para que el gráfico se guarde como tú esperas... pero a veces esto es un juego de ir adivinando, intentando números varias veces hasta que le acertas.

Una mejor alternativa es usar `{ggview}` para previsualizar tus gráficos desde el inicio con un tamaño fijo:

```{r}
library(ggview)

grafico + canvas(7, 5)
```

{{< imagen "grafico_ggview.png">}}

De esta forma, no importa el tamaño de tu ventana de RStudio: tu gráfico se previsualizará con la resolución y proporción que tu especifiques.