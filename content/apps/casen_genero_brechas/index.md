---
title: Brechas de género Casen
subtitle: Visualizador de desigualdad de género
tags:
- shiny
categories:
- Aplicaciones
author: Bastián Olea Herrera
date: "2024-01-31"
draft: false
excerpt: "Visualizador que detalla brechas de género en temas sociales, de vivienda e ingresos, para analizar variables en las que las mujeres experimentan peores condiciones de vida, a nivel regional
Selecciona una de las variables disponibles para generar un gráfico con todas las regiones del país, donde se detalla el porcentaje de la población femenina y masculina afectada por la variable seleccionada, o si eliges variables de vivienda o familia, el porcentaje de hogares con jefatura femenina o masculina correspondientes. Los puntos del gráfico además se detallan con las brechas o diferencias entre géneros existentes, volviendo explícitas las desigualdades o ausencia de las mismas."

layout: single
links:
- icon: link
  icon_pack: fas
  name: aplicación
  url: https://bastianoleah.shinyapps.io/casen_genero_brechas
- icon: github
  icon_pack: fab
  name: código
  url: https://github.com/bastianolea/casen_genero_brechas
---

[Aplicación web](https://bastianoleah.shinyapps.io/casen_brechas_genero) que permite visualiza variables desde la encuesta Casen 2022, explicitando las brechas de género existentes en Chile mediante un gráfico de puntos por género y región.

Este visualizador permite explorar con facilidad las múltiples desigualdades de género que son medibles empíricamente utilizando los datos más recientes de la [Encuesta de caracterización socioeconómica nacional (Casen) 2022](https://observatorio.ministeriodesarrollosocial.gob.cl/encuesta-casen-2022).

Las variables fueron seleccionadas por el interés general que puedan tener, y no por la existencia o no de brechas de género en ellas. Si se te ocurren otras variables que incluir, [puedes contactarme!](https://bastian.olea.biz)

Tanto la aplicación como el procesamiento de los datos, incluida la descarga de los datos oficiales de la Casen, están programadas en R y disponibles en este repositorio.

[La aplicación web está disponible en shinyapps.io](https://bastianoleah.shinyapps.io/casen_brechas_genero), o bien, puedes clonar este repositorio en tu equipo para reproducir todos los cálculos y usarla por medio de RStudio.

![Brechas de género Casen 2022](brechas_de_genero_casen_2022.jpg)

----

Diseñado y programado en R por Bastián Olea Herrera. Magíster en Sociología, data scientist.

https://bastian.olea.biz

bastianolea arroba gmail punto com