---
title: Convertir un script de R con comentarios a un documento Quarto
author: Bastián Olea Herrera
date: '2024-11-10'
slug: []
categories: []
tags:
  - consejos
  - Quarto
links:
- icon: r-project
  icon_pack: fab
  name: paquete
  url: https://github.com/martinasladek/convertr
---

Cuando trabajo con R, siempre intento dejar comentarios sobre de las cosas que estoy haciendo, tanto antes como después de cada bloque de código. Así, le hago un favor a mi _yo_ del futuro, dejando una cierta documentación de las cosas que estuve haciendo, los objetivos que tenía, y otras aclaraciones sobre los procesos realizados.

A esta combinación de bloques de código y párrafos de textos se le llama [programación literaria](https://es.wikipedia.org/wiki/Programación_literaria), o _literate programming._

Otra buena forma de poder documentar tu código, que no sea dejando comentarios en el script, es programar directamente en un [_notebook_ o documento Quarto](https://quarto.org/docs/get-started/hello/rstudio.html), que combina párrafos de texto enriquecido y titulares con bloques de código. 

Sin embargo, yo no acostumbro mucho a empezar mis análisis desde un documento Quarto, sino que desde scripts de R. Entonces, cuando quise transformar mis script de R a documentos Quarto para poder publicarlos en este blog, me encontré con el fastidio de tener que convertir todos los comentarios a texto, y tener que introducir _todos_ los bloques de código dentro de bloques (_chunks_). 

[El paquete `{convertr}`](https://github.com/martinasladek/convertr) permite convertir scripts R a documentos Quarto, y documentos Quarto a scripts de R:

```r
# instalación
devtools::install_github("martinasladek/convertr")
```

```r
convertr::r_to_qmd(
  input_dir = "path/to/some_R_script.R",
  output_dir = "path/to/new_converted_qmd_file.qmd"
)
```

Usando la función anterior, puedo convertir automáticamente mis scripts de R con comentarios a documentos Quarto, donde los comentarios sean párrafos de texto y cada bloque de código se ubica en un _chunk_ individual. ¡Muy conveniente!