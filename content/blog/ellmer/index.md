---
title: Chatea con modelos de lenguaje en R usando {ellmer}
author: Bastián Olea Herrera
date: '2025-10-18'
draft: true
slug: []
categories: []
tags:
  - inteligencia artificial
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: github
    icon_pack: fab
    name: Ellmer
    url: https://ellmer.tidyverse.org/index.html
execute:
  eval: false
---


https://ellmer.tidyverse.org/index.html

``` r
library(ellmer)

chat <- chat_github()

live_console(chat)

chat$chat("en qué lenguaje de programación se programó Mario 64?")
```

``` r
usethis::edit_r_environ()
```

reiniciar R

``` r
OPENAI_API_KEY=3453453
ANTHROPIC_API_KEY=34534534
```

``` r
chat <- chat_anthropic()
chat <- chat_openai("Be terse", model = "gpt-4o-mini")
```

Datos estructurados
https://ellmer.tidyverse.org/articles/structured-data.html

------------------------------------------------------------------------

Para más paquetes y herramientas de modelos de lenguaje e IA en R, revisa [Large Language Model tools for R](https://luisdva.github.io/llmsr-book/), de Luis D. Verde Arregoitia.
