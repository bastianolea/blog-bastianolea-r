---
title: 'Actualización de app Análisis de prensa: visualización de análisis de sentimiento
  de noticias recientes'
author: Bastián Olea Herrera
date: '2025-01-14'
slug: []
categories: []
tags:
  - web scraping
  - inteligencia artificial
  - visualización de datos
  - shiny
---

### Actualización de app análisis de prensa 🗞️

**Nuevo:** gráfico de análisis de sentimiento: elige un tema y revisa si las noticias recientes fueron mayormente positivas o negativas. Compara cómo distintos medios abordan las temáticas. ¡Pronto más detalle!

<img style = "border-radius: 7px; width: 100%; max-width: 400px; display: block; margin: auto;"
src = analisis_sentimiento_1.png>

Visita la aplicación [siguiendo éste enlace](/apps/prensa_chile/)

<img style = "border-radius: 7px; width: 100%; max-width: 400px; display: block; margin: auto;"
src = analisis_sentimiento_2-featured.png>

Para agregar esta funcionalidad a la app tuve que [desarrollar un proceso automatizado de análisis de datos usando modelos extensos de lenguaje (LLM)](/blog/analisis_sentimiento_llm/). Luego de que se obtienen las noticias por web scraping, se deja ejecutando el modelo de lenguaje sobre las noticias recientes para analizar el sentimiento del texto, clasificar la noticia en temáticas, y producir un resumen de su contenido.

<img style = "border-radius: 7px; width: 100%; max-width: 400px; display: block; margin: auto;"
src = analisis_sentimiento_3.png>

Tuve que [procesar cientos de miles de datos hacia atrás, lo que hago de manera local](/blog/2024-12-20/) corriendo el modelo Llama 3.1 8B en mi computador, por lo que tomó bastantes horas. Semanalmente son aprox. 3000 las noticias nuevas, las cuales se procesan en unas 8 horas aprox., por lo que será factible dejar el computador todos los domingos por la noche analizando las noticias de la semana.

<img style = "border-radius: 7px; width: 100%; max-width: 400px; display: block; margin: auto;"
src = analisis_sentimiento_4.png>

Pronto voy a poder agregar nuevas visualizaciones, como por ejemplo seleccionar un concepto (como Boric, delincuencia, Bachelet, minería, etc.) o varios conceptos a la vez, y visualizar si las noticias con esa/esas palabra/s han sido positivas o negativas, y cómo esto varía en cada medio.