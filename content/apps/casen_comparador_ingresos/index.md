---
title: Comparador de ingresos Casen
subtitle: Visualizador interactivo de ingresos
categories:
- Aplicaciones
author: Bastián Olea Herrera
date: "2024-01-21"
draft: false
excerpt: "Visualizador que compara distribuciones y promedios de ingresos entre las comunas de Chile, para observar las diferencias en las realidades socioeconómicas del país.
Selecciona un grupo de comunas, y elige una variable de ingresos, como ingresos individuales, ingresos por hogar, ingresos per cápita o montos de pensiones/jubilación, para obtener un gráfico de densidad que describe y compara las poblaciones de las comunas, y un gráfico de dispersión que ubica los ingresos de las comunas seleccionadas en comparación a todas las demás comunas del país."

layout: single
links:
- icon: link
  icon_pack: fas
  name: aplicación
  url: https://bastianoleah.shinyapps.io/casen_comparador_ingresos
- icon: github
  icon_pack: fab
  name: código
  url: https://github.com/bastianolea/casen_comparador_ingresos
---

[Aplicación web](https://bastianoleah.shinyapps.io/casen_comparador_ingresos) para generar gráficos de densidad que representan los ingresos de la población de cualquier comuna del país, o de varias comunas a la vez, para poder comparar las realidades económicas de sus habitantes.

Un gráfico de densidad indica cómo se distribuye una población con respecto a una variable indicada en el eje horizontal. En este caso, el eje horizontal corresponde a una escala de ingresos, y el eje vertical es la proporción de la población.

La visualización indica en qué tramos de ingresos se ubican las personas de la comuna seleccionada, donde la altura de la curva representa a una mayor proporción de las personas que perciben los ingresos que indica el eje horizontal. Por ejemplo, un gráfico con mucha altura en la parte inferior de la escala (izquierda) significa que la mayoría de la población percibe ingresos bajos, o un gráfico con mucha altura simultáneamente en los extremos izquierdo y derecho representaría una población con alta desigualdad y polarización de ingresos.

Los datos provienen de la [Encuesta de caracterización socioeconómica nacional (Casen) 2022](https://observatorio.ministeriodesarrollosocial.gob.cl/encuesta-casen-2022).

[La aplicación web está disponible en shinyapps.io](https://bastianoleah.shinyapps.io/casen_comparador_ingresos), o bien, puedes clonar este repositorio en tu equipo para usarla por medio de RStudio.

![Comparador de ingresos Casen](comparador_ingresos_casen.jpg)
