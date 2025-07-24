---
title: 'Video: Taller Medición y Análisis de la Corrupción en Chile desde el Análisis de
  Datos y Herramientas Abiertas'
author: Bastián Olea Herrera
date: '2025-07-23'
slug: []
categories: ["tutoriales"]
tags:
  - web scraping
  - Chile
  - visualización de datos
  - análisis de texto
  - videos
links:
- icon: github
  icon_pack: fab
  name: código
  url: https://github.com/bastianolea/taller_corrupcion_cesi
- icon: youtube
  icon_pack: fab
  name: ver video
  url: https://www.youtube.com/watch?v=fAmwXWvtR4E
---

Taller online que impartí para el _Congreso Estudiantil de Sociología Interdisciplinaria._ En este taller introduje a estudiantes de sociología al lenguaje de programación R, explicando los beneficios del análisis de datos desarrollado en flujos de trabajo basados en la programación, y las posibilidades que se abren para producir estudios y obtener resultados usando código. Puse énfasis en el uso de tecnologías y datos abiertos, y en el principal beneficio de la programación (en mi opinión): el poder actualizar resultados, aplicaciones y visualizaciones automáticamente.

{{<imagen "afiche.webp">}}


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


## Datos

- Base de datos de casos de corrupción: https://github.com/bastianolea/corrupcion_chile/ (descargar en [formato Excel](https://github.com/bastianolea/corrupcion_chile/raw/main/datos/casos_corrupcion_chile.xlsx))
- Datos de prensa chilena: https://github.com/bastianolea/prensa_chile
- Datos obtenidos en ejemplo de web scraping: `datos/noticias.csv`
- Base de datos con noticias de corrupción (6.000 noticias), desde 2023 a julio de 2025: `datos/prensa_corrupcion.parquet`
- Base de datos con muestra de noticias chilenas (10.000, al azar) de toda temática del año 2024: `datos/prensa_datos_muestra.csv`


## Gráficos

### Densidad
{{<imagen "000009.png">}}
{{< bajada "Gráfico de densidad de conceptos más frecuentes en noticias sobre corrupción, desde 2023 a julio de 2025" >}}

### Nube de palabras
{{<imagen "000011.png">}}
{{< bajada "Conceptos más frecuentes en noticias sobre corrupción, por fuente periodística">}}

### Correlaciones
{{<imagen "000010.png">}}
{{< bajada "Correlaciones de conceptos más fuertes para seis conceptos relacionados a corrupción">}}


