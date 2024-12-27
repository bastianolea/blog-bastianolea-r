---
title: Web scraping automatizado en R con GitHub Actions
author: Bastián Olea Herrera
date: '2024-11-18'
slug: []
categories: []
draft: true
format:
  hugo-md:
    output-file: index
    output-ext: md
tags:
  - web scraping
  - git
---


Las acciones de GitHub permiten especificar uno o varios scripts que queremos que se ejecuten automáticamente en la nube. De este modo, podemos automatizar la ejecución de un proceso de R, y calendarizar su ejecución con una cierta regularidad.

En esta guía, veremos cómo usar acciones de GitHub para automatizar la obtención de datos mediante web scrapping, de modo que tengamos un repositorio que se alimente constantemente con datos nuevos, sin que tengamos que obtener manualmente esos datos, ni que tengamos que intervenir en el proceso.

¿Para qué serviría esto?
- Obtener datos desde fuentes de internet que se actualizan con regularidad, para tenerlos todos actualizados y procesados de forma regular, y así poder usar estos datos en otros de nuestros proyectos, sabiendo que siempre estarán actualizados, procesados y almacenados en un repositorio único.
- Obtener datos que cambian constantemente de forma automática, para ir a almacenando estos datos paulatinamente, y luego poder analizarlos. Por ejemplo, datos de noticias o prensa, que aumentan sus registros diariamente, y que necesitamos ir obteniendo de forma diaria.
- Generar un reporte, dashboard o aplicación Shiny que utilice datos de actualización regular, con el fin de que sus datos siempre estén actualizados de forma automática, sin tener que volver a publicar la aplicación o volver a generar el reporte.

------------------------------------------------------------------------

Si este tutorial te sirvió, por favor considera hacerme una pequeña donación para poder tomarme un cafecito mientras escribo el siguiente tutorial 🥺

<div style = "height: 18px;">
</div>
<div>
  <div style="display: flex;
  justify-content: center;
  align-items: center;">
    <script type="text/javascript" src="https://cdnjs.buymeacoffee.com/1.0.0/button.prod.min.js" data-name="bmc-button" data-slug="bastimapache" data-color="#FFDD00" data-emoji="☕"  data-font="Cookie" data-text="Regálame un cafecito" data-outline-color="#000000" data-font-color="#000000" data-coffee-color="#ffffff" ></script>
  </div>
