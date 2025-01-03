---
title: Resumir textos usando modelos de lenguaje (LLM) locales en R
author: Bastián Olea Herrera
date: '2024-12-06'
slug: []
categories:
  - tutoriales
tags:
  - análisis de texto
  - inteligencia artificial
draft: true
format:
  hugo-md:
    output-file: index
    output-ext: md
editor_options:
  chunk_output_type: console
execute:
  eval: false
---


``` r
library(dplyr)
library(readr)
```

``` r
url_datos <- "https://raw.githubusercontent.com/bastianolea/prensa_chile/refs/heads/main/datos/prensa_datos_muestra.csv"

noticias <- read_csv2(url_datos)

noticias_muestra <- noticias |> 
  slice_sample(n = 20)

noticias_muestra
```

``` r
library(mall)
library(stringr)
library(beepr)
```

``` r
llm_use("ollama", "llama3.1:8b")

noticias_muestra_resumen <- noticias_muestra |> 
  llm_summarize(paste(titulo, cuerpo) |> str_trunc(3000, side = "center"), 
                max_words = 25, pred_name = "resumen", 
                additional_prompt = "Redacta el resumen de la idea principal de la noticia en español, y en un solo párrafo.")

beep()
```

2.7 minutos

``` r
noticias_muestra_resumen
```
