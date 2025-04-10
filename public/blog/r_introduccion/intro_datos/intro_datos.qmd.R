---
title: "Usando R para trabajar con datos"
author: Bastián Olea Herrera
date: '2024-11-16'
format: 
  hugo-md:
  output-file: "index"
output-ext:  "md"
weight: 6
draft: true
series: "Introducción a R"
slug: []
categories: ["Tutoriales"]
tags:
  - dplyr
lang: es
excerpt: Prueba
execute: 
  error: true
---
  
  
library("dplyr")

# crear una tabla: opción a
tibble(a = 1:10,
       b = 1:10,
       c = 11:20)

# crear una tabla: opción b
tribble(~animal,  ~patas, ~color,
        "perro",   4,     "negro",
        "mapache", 4,     "gris",
        "ganso",   2,     "blanco"
)
