---
title: Web scraping con R
author: Bastián Olea Herrera
date: '2025-07-17'
weight: 25
featured_image: ‘/blog/r_introduccion/web_scraping/featured.png’
tags:
  - web scraping
links:
  - icon: link
    icon_pack: fas
    name: rvest
    url: /blog/tutorial_scraping_rvest/
  - icon: link
    icon_pack: fas
    name: RSelenium
    url: /blog/tutorial_scraping_selenium/
  - icon: link
    icon_pack: fas
    name: chromotee
    url: /blog/tutorial_scraping_chromote/
excerpt: "Se trata del conjunto de técnicas que permiten extraer datos e información alojada en páginas web, usualmente en formatos que no son fácilmente convertibles a tablas de datos. En este post vemos tres formas de extraer datos desde páginas web con R, cada una con ventajas y desventajas, y su propio tutorial para aprender desde cero a usarlas."
---

{{< imagen "featured.png" >}}

Se denomina [web scraping](/tags/web-scraping/) al conjunto de técnicas que permiten **extraer datos e información alojada en páginas web**, usualmente en formatos que no son fácilmente convertibles a tablas de datos. 

Al ser R un lenguaje enfocado completamente el análisis de datos, es la plataforma ideal para este tipo de tareas, dado que puedes usar un sólo lenguaje para controlar las herramientas de extracción de datos, programar la lógica para automatizar la extracción, procesar y limpiar los datos, y finalmente analizar y presentar tus resultados.

A continuación, te presento tres formas distintas de extraer datos desde páginas web con R. Cada una tiene sus ventajas y desventajas, y están acompañadas de un tutorial en el que le explico desde cero a utilizarlas.

## {rvest}
<img src = https://rvest.tidyverse.org/logo.png style = "float: left; width: 100px; margin-left: 2px; margin-right: 20px;">

<div style = "margin-left: 120px;">

`{rvest}` es uno de los paquetes principales y más usados para extraer datos desde internet. Como forma parte del [Tidyverse](https://www.tidyverse.org), su sintaxis es muy intuitiva y coincide con el flujo de trabajo de la mayoría de usuarios/as de R. Además de ser una forma sencilla de acercarse al web scraping, contiene funciones para interpretar el código HTML obtenido, lo cual lo vuelve una herramienta versátil que también sirve a la par de otras herramientas de web scraping.

Sirve para la mayoría de los sitios web, pero presenta dificultades con sitios web dinámicos.

[**Tutorial de {rvest}**](/blog/tutorial_scraping_rvest/)

[**Sitio web oficial**](https://rvest.tidyverse.org)

</div>

----

## {RSelenium}
<img src = https://docs.ropensci.org/RSelenium/logo.png style = "float: left; margin-left: 2px; width: 100px; margin-right: 20px;">

Selenium es un software de automatización y testeo de sitios web bastante popular y muy usado. Por esta misma razón, puede ser una de las herramientas de web scraping para la que sea más fácil encontrar recursos, consejos y asistencia online.

Su fuerte está en la capacidad de controlar distintos navegadores, como Firefox y Chrome, incluso ayudándote con la instalación, u operando desde contendores Docker.

<div style = "margin-left: 120px;">

[**Tutorial de {RSelenium}**](/blog/tutorial_scraping_selenium/)

[**Sitio web oficial**](https://docs.ropensci.org/RSelenium/)

</div>

----

## {chromote}
<img src = https://rstudio.github.io/chromote/logo.png style = "float: left; width: 100px; margin-left: 4px; margin-right: 20px;">

<div style = "margin-left: 128px;">

Con este paquete se puede controlar una instancia sin interfaz gráfica de Google Chrome. Hoy en día, cuando este navegador ha monopolizado gran parte del internet, puede ser conveniente utilizarlo para la extracción de datos web. También te permite controlar el navegador de forma gráfica, y una de sus fortalezas es que es más difícil de detectar como un web scraper por los sitios web.



[**Tutorial de {chromote}**](/blog/tutorial_scraping_chromote/)

[**Sitio web oficial**](https://rstudio.github.io/chromote/index.html)

</div>

----

### Ejemplos de web scraping con R

- [Web scraping de datos electorales desde Servel (Chile), automatizando el control de varios botones y selectores, con `{RSelenium}`](https://github.com/bastianolea/servel_scraping_votaciones)
- [Web scraping de varios sitios del Banco Central usando `{rvest}`, automatizado de forma recurrente con GitHub Actions](https://github.com/bastianolea/economia_chile/blob/main/obtener_datos.R)
- [Web scraping de perfiles de GitHub con `{rvest}` para generar tablas de los repositorios](https://github.com/bastianolea/datos_sociales/blob/master/scraping.R)
- [Ejemplo de web scraping de noticias con `{rvest}`](https://github.com/bastianolea/prensa_chile/blob/main/scraping/fuentes/scraping_ejemplo.R)
- [Ejemplo de web scraping de un sitio web de Transparencia Activa (Chile) con `{RSelenium}`](https://bastianolea.rbind.io/blog/tutorial_scraping_selenium/#navegar-a-un-sitio-web)
- [Obtención automatizada y masiva de datos de prensa con `{rvest}` y `{chromote}` para sitios que bloquean el acceso](https://github.com/bastianolea/prensa_chile)
- [Extracción de una tabla de Wikipedia con `{rvest}`](https://bastianolea.rbind.io/blog/tutorial_scraping_rvest/#extraer-tablas-desde-un-sitio-web)
- [Ejemplo de extracción de una tabla del Banco Central con `{rvest}`](https://bastianolea.rbind.io/blog/tutorial_gt/#tabla-de-producto-interno-bruto-regional)

----

{{< cafecito >}}
{{< cursos >}}