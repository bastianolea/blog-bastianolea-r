---
title: 'App: Suicidios en Chile (2010-2024) desde una perspectiva de género'
author: Bastián Olea Herrera
date: '2026-02-21'
slug: []
categories:
  - Aplicaciones
tags:
  - apps
  - Chile
  - datos
  - gráficos
format:
  hugo-md:
    output-file: index
    output-ext: md
excerpt: Conjunto de visualizaciones que exploran los datos de egresos médicos del Ministerio de Salud de Chile, distinguiendo entre intentos de suicidio y suicidios consumados. Los gráficos buscan describir las diferencias de género en el fenómeno del suicidio, mostrando desigualdades en la cantidad de intentos y en las víctimas fatales, pero también en los métodos utilizados por hombres y mujeres.
links:
  - icon: link
    icon_pack: fas
    name: Aplicación
    url: https://bastianolea.github.io/minsal_suicidios_genero/
  - icon: file-code
    icon_pack: fas
    name: Código
    url: https://github.com/bastianolea/minsal_suicidios_genero
---

[Sitio web con visualizaciones](https://bastianolea.github.io/minsal_suicidios_genero/) que exploran los datos de **egresos médicos** del Ministerio de Salud de Chile, distinguiendo entre intentos de suicidio y suicidios consumados. 

Los gráficos buscan describir las diferencias de género en el fenómeno del suicidio, mostrando desigualdades en la cantidad de intentos y en las víctimas fatales, pero también en los métodos utilizados por hombres y mujeres.

{{< imagen "suicidios_genero_1_featured.png" >}}

{{< imagen "suicidios_genero_2.png" >}}

> Los datos de egresos médicos incluyen el diagnóstico de las y los pacientes, su género, su ubicación, y si sobrevivieron o no a sus aflicciones. Según el diagnóstico de cada paciente, es posible identificar casos de lesiones autoinfligidas intencionalmente, interpretables como intentos de suicidio. En base al egreso con vida (alta médica) o sin vida (fallecimiento) de los pacientes, se pueden distinguir intentos de suicidio y suicidios consumados.

La aplicación fue desarrollada con Quarto y R para el procesamiento de datos y visualizaciones.

{{< boton "Visita la aplicación" "https://bastianolea.github.io/minsal_suicidios_genero/" "fas fa-link" >}}

### Fuentes
- Ministerio de Salud, Egresos hospitalarios
- [Datos abiertos](https://deis.minsal.cl/#datosabiertos), Departamento de Estadísticas e Información de Salud