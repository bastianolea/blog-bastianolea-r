---
title: Generar múltiples gráficos automáticamente con R
author: Bastián Olea Herrera
date: '2025-07-07'
slug: []
draft: true
format:
  hugo-md:
    output-file: index
    output-ext: md
categories: []
tags:
  - visualización de datos
  - automatización
  - purrr
  - ggplot2
---


Uno de los principales beneficios de usar programación para el análisis de datos es que **el código es reutilizable.** esto significa que cualquier cosa que hayas hecho una vez, puedes volver a hacerla muy fácilmente, o cualquier cosa que hayas hecho antes puedes volver a usarla para hacer algo similar y así ahorrar mucho trabajo.

En la visualización de datos, la reutilización de código resulta altamente conveniente. Una vez que has diseñado un gráfico, con muy pocas modificaciones puedes adaptarlo para que funcione con una fuente de datos distintas o actualizada, o para que exprese una variable distinta.

Una vez que empiezas a crear tus gráficos con la reutilización en mente, el siguiente paso lógico es **automatizar la creación de gráficos** para que solamente tengas que diseñar una visualización que te genere múltiples resultados.

Entonces, los pasos serían: preparar los datos para la visualización, diseñar una visualización que pueda adaptarse a distintos datos datos variables, crear un loop o iteración donde el código que genera el gráfico se ejecute múltiples veces en base a lo que necesites replicar.

Esto podría ser, por ejemplo,
