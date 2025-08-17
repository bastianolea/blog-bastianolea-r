---
title: Taller Medición y Análisis de la Corrupción en Chile desde el Análisis de
  Datos y Herramientas Abiertas
author: Bastián Olea Herrera
date: '2025-07-23'
draft: false
excerpt: "Taller online dentro del Congreso Estudiantil de Sociología Interdisciplinaria. En este taller introduje a estudiantes de sociología al lenguaje de programación R, explicando los beneficios del análisis de datos desarrollado en flujos de trabajo basados en la programación, y las posibilidades que se abren para producir estudios y obtener resultados usando código. Puse énfasis en el uso de tecnologías y datos abiertos, y en el principal beneficio de la programación (en mi opinión): el poder actualizar resultados, aplicaciones y visualizaciones automáticamente."
layout: single
location: Online
links:
- icon: github
  icon_pack: fab
  name: código y contenidos
  url: https://github.com/bastianolea/curso_shiny_2_spatialLab
---

Taller online que impartí para el _Congreso Estudiantil de Sociología Interdisciplinaria._ En este taller introduje a estudiantes de sociología al lenguaje de programación R, explicando los beneficios del análisis de datos desarrollado en flujos de trabajo basados en la programación, y las posibilidades que se abren para producir estudios y obtener resultados usando código. Puse énfasis en el uso de tecnologías y datos abiertos, y en el principal beneficio de la programación (en mi opinión): el poder actualizar resultados, aplicaciones y visualizaciones automáticamente.

{{<imagen "afiche-featured.webp">}}


## Herramientas y Estrategias contra la Corrupción: _Talleres para la Medición y Análisis de la Corrupción en Chile desde el Análisis de Datos y Herramientas Abiertas_

Sesión 2: **Extracción de Datos desde Medios: Web scraping y Criterios de Selección/ Análisis y Visualización de Datos**

- Web scraping en investigación social: definición, casos de uso.
- Selección de medios y criterios éticos.
- Exploración de estructuras HTML simples (solo como contexto).
- Uso de la app de Bastián para extraer datos de prensa.
- Visualización básica en RStudio con ggplot2

{{< youtube fAmwXWvtR4E >}}

## Aplicaciones vistas en la sesión
- [Visualizador de casos de corrupción en Chile](https://bastianoleah.shinyapps.io/corrupcion_chile/)
- [Visualizador de análisis de prensa digital en Chile](https://bastianoleah.shinyapps.io/prensa_chile/)

## Código
En este repositorio está todo el código usado en el taller.

- **Ejemplo de web scraping de un medio digital chileno:** [`scraping.qmd`](https://github.com/bastianolea/taller_corrupcion_cesi/blob/main/scraping.qmd)

- **Ejemplo de modelamiento de tópicos en análisis de texto:** [`modelamiento_stm.R`](https://github.com/bastianolea/taller_corrupcion_cesi/blob/main/modelamiento_stm.R)

- **Análisis de datos de un corpus de noticias de corrupción (6.000 noticias):** [`explorar.qmd`](https://github.com/bastianolea/taller_corrupcion_cesi/blob/main/explorar.qmd), los datos están disponibles en: [`datos/prensa_corrupcion.parquet`](https://github.com/bastianolea/taller_corrupcion_cesi/blob/main/datos/prensa_corrupcion.parquet)
