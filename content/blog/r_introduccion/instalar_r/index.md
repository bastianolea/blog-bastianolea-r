---
title: 'Primer paso: instalar R'
author: Bastián Olea Herrera
format: hugo-md
date: 2024-11-07T00:00:00.000Z
draft: false
weight: 1
series: Introducción a R
tags:
categories:
  - Tutoriales
lang: es
excerpt: Instrucciones básicas para que descargues e instales R y RStudio, dirigidas a personas sin conocimientos previos o principiantes. ¡Es tu primer paso al mundo de la programación!
---

Para adentrarte en el mundo del análisis de datos, la visualización de datos, y la programación, el primer paso es instalar R, el lenguaje, y RStudio, la interfaz que nos va a permitir trabajar con el lenguaje.

### 1. Descargar e instalar R
R es el lenguaje de programación y análisis estadístico base, el cual se caracteriza por operar mediante paquetes o librerías que expanden sus prestaciones.

<div style="text-align: center;">
{{< figure src="logo_r_morado-featured.png" width="128">}}
</div>

El siguiente enlace es del [sitio oficial de R,](https://cran.r-project.org) donde pueden descargarlo para el sistema operativo que utilicen:
https://cran.r-project.org

Elige la descarga correspondiente a tu sistema operativo, e instálalo. Si usas Windows, es probable que tengas que instalar otro software llamado _Rtools,_ cuyo enlace aparece en el mismo enlace anterior cuando eliges Windows.

### R y RStudio
R funciona a través de la línea de comandos (la línea de comandos es el nivel más bajo de interacción con un computador), lo que significa que hay que escribirle instrucciones exactas para que trabaje, y retorna resultados en forma de texto. Como esto resulta un poco tedioso, se suele utilizar R a través de un entorno de desarrollo, RStudio, que facilita su uso.

### 2. Descargar e instalar RStudio
RStudio es el entorno de desarrollo integrado (IDE) que facilita el trabajo con R. También funciona con Python, y también hay otras alternativas de IDE, pero RStudio es la más usada.

<div style="text-align: center;">
{{< figure src="logo_rstudio_morado.png" width="128">}}
</div>

Descargar e instalar RStudio para su sistema operativo:
https://posit.co/download/rstudio-desktop/#download

Principalmente, lo que hace RStudio es presentarnos una consola de R junto a otros paneles: el panel de visualización, donde exploramos los gráficos, la ventana de entorno (environment) donde vemos los elementos con los que estamos trabajando, y la ventana de script o source, donde podemos ir elaborando uno o varios documentos con instrucciones para R. Además de estos paneles, RStudio facilita tareas como la importación de datos, la instalación de paquetes, la gestión de cambios, y otros.

Teniendo ambas cosas instaladas, podemos abrir RStudio y verificar está funcionando escribiendo en la consola: “2+2” (sin comillas), y presionamos enter. Si obtenemos una respuesta, significa que la instalación funciona.