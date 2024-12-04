---
title: 'Aplicando una regresión lineal en la vida diaria: predecir kilómetros por
  recorrer en bicicleta'
author: Bastián Olea Herrera
date: '2024-12-03'
format: hugo-md
slug: []
categories: []
tags:
  - estadística
  - ggplot2
excerpt: "Se me ocurrió aplicar estadísticas a una duda cotidiana: si se tiene un historial de kilómetros recorridos, ¿cómo podemos predecir los kilómetros que se recorrerán en el futuro? En este post aplicamos una regresión lineal en R para averiguarlo."
---



No soy una persona muy cercana a la estadística, pero el día de hoy por primera vez se me ocurrió aplicar una regresión lineal para responder una pregunta de mi vida cotidiana.

Resulta que un compañero del ultraciclismo, el [destacado ciclista Andrés Arias](https://www.instagram.com/aenederrese/), preguntó en su Instagram si alguien podía predecir cuántos kilómetros va a recorrer este 2024 durante el desafío [Rapha Festive 500](https://content.rapha.cc/us/en/story/festive500), un desafío del que participamos muchos ciclistas, que consiste en recorrer 500 km en bicicleta entre el 24 y el 31 de diciembre[^1].

[^1]: Sí, es enfermizo, y sí, nuestras familias nos odian.

La pregunta la hizo Andrés luego de comentar cuánto había recorrido para el desafío en los años anteriores: 530 kilómetros en 2021, 930 kms en 2022, y 1.260 en 2023. Naturalmente noté que existía una cierta progresión lineal entre estas cifras, así que me levanté del sillón y abrí R para hacer una prueba 🤔

Lo primero fue anotar estas cifras en una tabla de datos:




``` r
library(dplyr)

kms_año <- tribble(~año, ~kms,
                   2021, 530,
                   2022, 930,
                   2023, 1260)
```



Luego visualizar los datos:




``` r
library(ggplot2)

grafico_1 <- kms_año |> 
  ggplot() + 
  aes(x = año, y = kms) +
  geom_line(linewidth = 1, alpha = .4) +
  geom_point(size = 4, alpha = .7) +
  scale_x_continuous(breaks = kms_año$año) +
  theme_classic() +
  theme(panel.grid.major.x = element_line())

grafico_1
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-2-1.png" width="672" />


Efectivamente, la cantidad de kilómetros recorridos para este desafío en cada año ha aumentado de una manera casi lineal. 

Mi idea fue crear un **modelo de regresión lineal** para ajustar estos datos a una recta que, al extenderla, nos permita **predecir cuántos kilómetros serían recorridos en los siguientes años**, si la tendencia se mantiene.

Ajustamos un modelo de regresión lineal, por medio del cual queremos predecir los kilómetros a partir de los años, dado que intuimos que un aumento en los años conlleva también un aumento en los kilómetros.




``` r
# crear modelo lineal
modelo <- with(kms_año,
               lm(kms ~ año))

# crear predicción
prediccion <- predict(modelo)

prediccion
```

```
##         1         2         3 
##  541.6667  906.6667 1271.6667
```

``` r
# visualizar modelo
grafico_1 +
  geom_line(aes(y = prediccion), 
            color = "purple3", linewidth = 1.4, linetype = "dashed", alpha = .4) +
  geom_point(aes(y = prediccion), 
            color = "purple3", size = 4, alpha = .7) +
  theme(panel.grid.major.x = element_line())
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-1.png" width="672" />



La primera predicción que obtenemos es una predicción de los datos que ya conocemos, pero a partir de la recta ajusta por el modelo. Es decir, son los valores que corresponden a cada punto en el tiempo de acuerdo a la línea de regresión proyectada. Estos valores se asemejan mucho a los valores reales, pero al ser un modelo, no son exactamente iguales, ya que corresponden a una simplificación de la realidad.

En términos simples, un modelo de regresión lineal crea o _ajusta_ una recta que busca cruzar todos los puntos de los datos de la manera más cercana a ellos posible. Por lo tanto, el gráfico anterior compara los datos reales con los datos representados por el modelo, que en el fondo son resumidos por una sola recta.

A partir de esta recta, podemos **predecir** los valores que corresponderían a observaciones futuras (en este caso, los kilómetros recorridos en los años siguientes) asumiendo que los valores futuros seguirán ubicándose dentro de esta misma recta que predijo bastante bien los valores reales.

Lo que haremos será crear nuevos datos, en este caso nuevos años, que no estén contemplados dentro de los datos originales, que llegaban solamente hasta 2023.




``` r
# crear nuevas observaciones para predecir
predecir <- tibble(año = 2021:2026)
```



Luego usamos el modelo para predecir los valores que tendrían estos nuevos datos (al extender a recta hacia los nuevos años).




``` r
# predecir las nuevas observaciones en base al modelo ajustado
prediccion <- predict(modelo, newdata = predecir)

prediccion
```

```
##         1         2         3         4         5         6 
##  541.6667  906.6667 1271.6667 1636.6667 2001.6667 2366.6667
```



Finalmente reunimos estos resultados en una nueva tabla de datos que contiene los años y los kilómetros predichos.




``` r
predicho <- bind_cols(predecir, 
                      kms_pred = prediccion)

predicho
```

```
## # A tibble: 6 × 2
##     año kms_pred
##   <int>    <dbl>
## 1  2021     542.
## 2  2022     907.
## 3  2023    1272.
## 4  2024    1637.
## 5  2025    2002.
## 6  2026    2367.
```



Teniendo estas predicciones, el último paso es unir las predicciones con los datos reales, y ponernos a analizar los resultados:




``` r
# unir datos predichos (que tienen más años) con los datos reales
kms_año_pred <- left_join(predicho,
                          kms_año, 
                          by = join_by(año))

kms_año_pred
```

```
## # A tibble: 6 × 3
##     año kms_pred   kms
##   <dbl>    <dbl> <dbl>
## 1  2021     542.   530
## 2  2022     907.   930
## 3  2023    1272.  1260
## 4  2024    1637.    NA
## 5  2025    2002.    NA
## 6  2026    2367.    NA
```



Para visualizar los resultados, transformamos los datos a _formato largo_, para que en vez de tener dos columnas (los kilómetros reales y predichos) tengamos una sola columna con todos los valores, y una segunda columna que distinga los valores entre kilómetros reales y kilómetros predichos. Además, creamos una columna con los datos formateados de una manera más legible.




``` r
library(tidyr)

kms_año_pred_2 <- kms_año_pred |> 
  # transformar a largo o a tidy
  pivot_longer(c(kms, kms_pred),
               values_to = "valor",
               names_to = "tipo") |> 
  # recodificar categorías
  mutate(tipo = recode(tipo, 
                       "kms" = "kms reales",
                       "kms_pred" = "predicción")) |> 
  arrange(tipo) |> 
  # crear etiquetas
  mutate(etiqueta = round(valor, 0),
         etiqueta = format(etiqueta, big.mark = ".", trim = TRUE),
         etiqueta = paste(etiqueta, "kms"))

kms_año_pred_2
```

```
## # A tibble: 12 × 4
##      año tipo       valor etiqueta 
##    <dbl> <chr>      <dbl> <chr>    
##  1  2021 kms reales  530  530 kms  
##  2  2022 kms reales  930  930 kms  
##  3  2023 kms reales 1260  1.260 kms
##  4  2024 kms reales   NA  NA kms   
##  5  2025 kms reales   NA  NA kms   
##  6  2026 kms reales   NA  NA kms   
##  7  2021 predicción  542. 542 kms  
##  8  2022 predicción  907. 907 kms  
##  9  2023 predicción 1272. 1.272 kms
## 10  2024 predicción 1637. 1.637 kms
## 11  2025 predicción 2002. 2.002 kms
## 12  2026 predicción 2367. 2.367 kms
```



Creamos un gráfico para analizar visualmente los resultados de nuestra predicción:




``` r
kms_año_pred_2 |> 
  ggplot() +
  aes(x = año, y = valor, color = tipo, linetype = tipo) +
  geom_line(linewidth = 1, alpha = 0.7) +
  geom_point(size = 3, alpha = 0.8) +
  geom_point(data = ~filter(.x, año == 2024),
             size = 3*4, alpha = 0.1, show.legend = F) +
  geom_text(data = ~filter(.x, tipo == "predicción", año > 2023),
            aes(label = etiqueta), 
            hjust = 0, nudge_x = 0.1, nudge_y = -50, size = 3, show.legend = F) +
  geom_text(data = ~filter(.x, tipo != "predicción", año <= 2023),
            aes(label = etiqueta), 
            hjust = 0, nudge_x = 0.1, nudge_y = -50, size = 3, show.legend = F) +
  theme_classic() +
  scale_color_manual(values = c("kms reales" = "black", 
                                "predicción" = "red2")) +
  scale_y_continuous(labels = ~paste(format(.x, big.mark = "."), "kms")) +
  scale_x_continuous(expand = expansion(c(0.05, 0.1))) +
  guides(color = guide_legend(position = "inside")) +
  labs(y = "kms", color = NULL, linetype = NULL) +
  theme(panel.grid.major.x = element_line(),
        legend.position.inside = c(.9, .2))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-9-1.png" width="672" />


Considerando los tres años de datos que tenemos de los recorridos en bicicleta de Andrés Arias durante el desafío Rapha Festive 500, podríamos predecir que este año Andrés va a recorrer 1.637 kilómetros entre el 24 y el 31 de diciembre, bajo el supuesto de que cada año Andrés ha aumentado sus kilómetros de forma lineal.

Ahora, esto choca un poco con la realidad, porque el hecho de algo aumente periódicamente no significa que en el siguiente periodo el aumento vaya a ser necesariamente el mismo que antes. Mucho menos cuando estamos hablando de datos que tienen que ver con procesos humanos. Pero de todas maneras fue un ejercicio entretenido 😊


