---
title: Visualización y scraping de resultados de las elecciones presidenciales 2025
author: Bastián Olea Herrera
date: '2025-11-17'
slug: []
categories: []
tags:
  - shiny
  - optimización
format:
  hugo-md:
    output-file: index
    output-ext: md
tags:
  - procesamiento de datos
  - web scraping
  - visualización de datos
  - gráficos
  - tablas
  - mapas
  - datos
  - Chile
lang: es
excerpt: En una nueva fecha electoral en Chile, apliqué el código que he usado en elecciones pasadas para obtener los datos del Servicio Electoral en tiempo real para así ir generando gráficos, tablas y mapas con los resultados preliminares.
links:
- icon: github
  icon_pack: fab
  name: código
  url: https://github.com/bastianolea/servel_scraping_votaciones
---

Hoy domingo 17 de noviembre celebramos una nueva fecha electoral en Chile, esta vez eligiendo presidente.

Apliqué el [código que he usado en elecciones pasadas](https://bastianolea.rbind.io/blog/elecciones_municipales_2024/) para obtener los datos del Servicio Electoral (Servel) en tiempo real, para así ir **generando gráficos, tablas y mapas** con los resultados preliminares.

[El repositorio contiene todo el código](https://github.com/bastianolea/servel_scraping_votaciones) para acceder en tiempo real a los [datos preliminares publicados en la web del Servel](https://elecciones.servel.cl). 

El sistema que programé usa [RSelenium para hacer web scraping](https://bastianolea.rbind.io/blog/tutorial_scraping_selenium/) de las tablas, a las que se debe acceder presionando botones en el sitio para elegir elección, región, y comuna, por lo que Selenium resulta ideal para ir probando junto al navegador _títere_ las formas de controlar la navegación por medio de código, y eventualmente **automatizar el acceso a todas las tablas** mediante un loop. Luego se aplica un script de **limpieza de datos**, y finalmente, según las comunas del país que se definan, el sistema genera gráficos, tablas, mapas y textos en base a los resultados de cada comuna, los cuales se guardan y se ordenan en una carpeta llamada `salidas`, la que me permite obtener todos los resultados juntos (las imágenes y el texto con cifras y otros datos) y listos para subir a redes sociales.





----

**Mapa comparativo por candidato presidencial** en la Región Metropolitana, por comuna, para Jeanette Jara (26,85%), José Antonio Kast (23,93%) y Franco Parisi (19,69%):

{{< imagen_tamaño "servel_mapa_rm_p.jpg" "50%" >}}

**Mapa de ventajas de candidatos presidenciales** en la Región Metropolitana, comparando ventaja porcentual por comuna entre las dos primeras mayorías:

{{< imagen "servel_mapa_rm_dif.jpg" >}}

----

**Gráficos y tablas** para comunicar resultados comunales:

{{< imagen "puente_alto_grafico_16-11-25_2025.jpg" >}}
{{< bajada "Gráfico de resultados presidenciales por comuna" >}}

{{< imagen_tamaño "maipu_tabla_16-11-25_2025.png" "50%" >}}
{{< bajada "Tabla de resultados presidenciales por comuna" >}}



