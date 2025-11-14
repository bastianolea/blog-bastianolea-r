---
title: 'Portafolio: mapas de Áreas Metropolitanas'
author: Bastián Olea Herrera
date: '2025-11-14'
slug: []
categories: []
tags:
  - blog
  - mapas
  - Chile
  - gráficos
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: gitlab
    icon_pack: fab
    name: Código
    url: https://gitlab.subdere.gob.cl/bolea/areas_metropolitanas_2
excerpt: "Comparto un poco de mi trabajo como analista de datos. En esta oportunidad me pidieron hacer mapas que visualizaran las propuestas de Áreas Metropolitanas en distintas regiones de Chile, junto a algunas estadísticas relacionadas."
---

Comparto un poco de mi trabajo como analista de datos en la Subsecretaría de Desarrollo Regional y Administrativo (Subdere). 

{{< imagen_tamaño "areas_metropolitanas_mapa_6.jpg" "60%" >}}

En esta oportunidad me pidieron hacer mapas que visualizaran las propuestas de Áreas Metropolitanas en distintas regiones de Chile, junto a algunas estadísticas relacionadas.

{{< imagen_tamaño "areas_metropolitanas_mapa_6.jpg" "60%" >}}

Los mapas combinan _shapes_ y datos de múltiples fuentes:

- Polígonos comunales: División Político Administrativa 2023, IDE Chile
- Límites comunales: División Político Administrativa 2022, Subdere
- Polígonos de áreas pobladas: Biblioteca del Congreso Nacional
- Red vial: Biblioteca del Congreso Nacional
- Polígonos de masas lacustres: Biblioteca del Congreso Nacional

{{< imagen_tamaño "areas_metropolitanas_mapa_10.jpg" "60%" >}}

Este proyecto lo organicé en cuatro scripts: 

En `funciones.R` se definen las funciones para cargar, procesar, filtrar y generar los mapas. 

El script `procesar.R` recibe el identificador de una región, y usando las funciones definidas en `funciones.R` carga los datos y filtra los mapas para esa región, haciendo ajustes específicos al territorio si es que corresponde. El resultado son varios objetos que contienen las capas geográficas y datos para la región.

Luego el script `graficar.R` recibe esos objetos y genera la visualización, incluyendo el gráfico de torta, el minimapa, y los textos que van encima de las visualizaciones. En este paso las funciones realizan varias adaptaciones particulares a cada región para que se vean bien, como recortes, posicionamiento de los elementos, dimensiones del mapa, etc. 

Todo lo anterior (idealmente) se ejecuta desde `generar.R`, que es el loop/orquestador que produce todo pasando por todas las regiones, de modo que si se modifica un dato, un _shape_ o algún detalle de la visualización, se ejecuta el orquestador y se obtienen todos los mapas actualizados.

{{< cursos >}}



