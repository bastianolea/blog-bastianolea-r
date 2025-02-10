---
title: Repositorio de datos sociales
author: Bastián Olea Herrera
date: '2025-02-09'
slug: []
categories: []
tags: [blog, datos, tablas]
links:
- icon: link
  icon_pack: fas
  name: datos sociales
  url: https://bastianolea.github.io/datos_sociales/
---

Acabo de [publicar una nueva página](https://bastianolea.github.io/datos_sociales/) donde voy a estar recopilando todos los conjuntos de datos sociales con los que trabajo o he trabajado. 

La idea de esta página es poder compartir fácilmente datos sociales que vienen limpios y procesados, para facilitar el trabajo de otras personas, y también ayudarles a aprender análisis de datos. 

Se trata de una tabla que se genera automáticamente, la cual contiene una lista de repositorios enfocados en datos sociales, con clasificación según la temática del dato, y varias columnas que indican las características del conjunto de datos, como si es que el dato contiene variables de género, si está desagregado a nivel comunal, si existe una aplicación de visualización de datos asociada, la temporalidad (anual/mensual/semanal) de las observaciones, y más.

En cada repositorio se encuentran también scripts con el código que se utiliza para obtener los datos, procesarlos, limpiarlos, y también para generar nuevos productos a partir de estos datos, tales como gráficos, tablas, y aplicaciones.

{{< imagen "tabla_datos_sociales.png" >}}

La tabla se genera mediante un web scraping de mi cuenta de GitHub. Los contenidos de la tabla se adaptan en base a las etiquetas que tiene cada repositorio, la descripción viene de la descripción de cada repo, y el título viene del readme. Las columnas con iconos también se hacen automáticamente a partir de las etiquetas. La tabla se genera con el [paquete {gt}.](https://gt.rstudio.com) La página se genera con [Quarto](https://github.com/quarto-dev/quarto-r) y se publica automáticamente con GitHub Pages.