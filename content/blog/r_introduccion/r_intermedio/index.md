---
title: Principios de R para el análisis de datos
author: Bastián Olea Herrera
date: '2024-11-16'
format:
  hugo-md:
    output-file: index
    output-ext: md
weight: 4
draft: true
series: Introducción a R
slug: []
categories:
  - Tutoriales
tags:
  - dplyr
lang: es
excerpt: Prueba
execute:
  error: true
---


## Introducción

Esta es la segunda guía introductoria para aprender el lenguaje de programación R. [En la guía anterior vimos los principios más fundamentales del lenguaje R](../../../../blog/r_introduccion/r_basico/), para familiarizarnos con R y entender su funcionamiento básico. En esta segunda guía veremos cómo utilizar R para analizar datos de manera básica y sencilla, por medio del uso del paquete `{dplyr}`.

# cambiar todo esto para que sea no solo de dplyr

### Proyectos

Antes de hacer cualquier trabajo que involucre datos con R, se recomienda [crear un *Proyecto* de RStudio](../../../../blog/r_introduccion/proyectos/). Un proyecto es una forma de definir la carpeta específica donde vamos a guardar todos los scripts y archivos que vamos a necesitar. Se caracteriza por un archivo que termina en `.Rproj`, que marca nuestro espacio de trabajo: una carpeta reúne todas las piezas de nuestro análisis.

Para crear un proyecto nuevo, elegimos la opción *New Project...* en el menú *File*, o apretamos el ícono del cubo celeste ubicado en la esquina superior derecha de RStudio y elegimos la primera opción.

Una vez que creamos el proyecto, podemos abrir nuestro proyecto haciendo doble clic en el archivo que termina en ".Rproj", seleccionando en RStudio el menú *File* y el ítem *Open Project...* o *Recent Projects*, o en la esquina superior derecha de RStudio, donde aparece un icono celeste que contiene los proyectos recientes.

Es muy importante que, antes de empezar a trabajar con R, te asegures de que estás dentro del proyecto correcto. [Para más información sobre los proyectos de RStudio, revisa esta guía.](../../../../blog/r_introduccion/proyectos/)

Deberíamos encontrarnos con una ventana de RStudio con un script nuevo, listo para recibir instrucciones.

### Instalación

Para usar el paquete `{dplyr}`, así como cualquier otro paquete de R que no venga instalado por defecto, tenemos que instalarlo desde internet. La instalación de los paquetes en R se facilita por la función `install.packages()`, que se conecta a un servidor centralizado donde todos los paquetes son revisados y verificados manualmente por revisores humanos, para garantizar que sean seguros de usar y funcionales.

Instalamos `{dplyr}` con el siguiente comando:

``` r
install.packages("dplyr")
```

### Datos

## {dplyr}

<img src = dplyr.png style = "float: left; max-width: 128px; margin-right: 20px;">

La herramienta que utilizaremos para explorar, manipular, y transformar datos será [el paquete `{dplyr}`](https://dplyr.tidyverse.org/articles/dplyr.html). Este paquete, parte central del [conjunto *Tidyverse* de herramientas para el análisis de datos con R](https://www.tidyverse.org), es uno de los más usados por la comunidad de R por su facilidad de uso. Se caracteriza porque casi todas sus funciones son escritas por medio de *verbos*, lo que hace que su sintaxis sea muy legible, ya que cada función se corresponde con una acción que estamos realizando sobre nuestros datos. Otra de sus características es el uso del operador de conexión o *pipe*, qué es un operador de R que nos permite encadenar instrucciones de forma secuencial. Su uso hace que las instrucciones se ordenen de izquierda a derecha y de arriba hacia abajo, mejorando mucho más la legibilidad del código.

### Seleccionar ----

censo %\>% \# control + shift + M
select(comuna, población)

## Resumir ----

censo %\>%
summarize(min(población))

## Ordenar

censo %\>%
arrange(población) %\>%
select(comuna, población)

censo %\>%
filter(población \> 100000) %\>%
arrange(población)

censo %\>%
filter(población \> 100000) %\>%
arrange(desc(población))

## Renombrar ----

censo %\>%
rename(p = población)

# ver filas específicas del dataframe

censo %\>%
slice(200:220)

### Filtrar ----

censo %\>%
filter(población \> 300000)

censo %\>%
filter(población \< 1000)

censo %\>%
filter(población \> 1000)

censo %\>%
filter(población == min(población))

censo %\>%
filter(población == max(población))

censo %\>%
filter(comuna == "La Florida")

censo %\>%
filter(población == 407297)

censo %\>%
filter(población == min(población))

### Filtrar usando objetos ----

min_pob \<- 25000
max_pob \<- 30000

censo %\>%
filter(población \> min_pob,
población \< max_pob)

promedio \<- mean(censo\$población)

censo %\>%
filter(población \> promedio)

censo %\>%
filter(población \> promedio\*1.5)

maximo \<- max(censo\$población)

censo %\>%
filter(población \>= maximo\*0.8)
