---
title: Usando tipografías personalizadas en aplicaciones Shiny
author: Bastián Olea Herrera
date: '2025-08-20'
draft: true
format:
  hugo-md:
    output-file: index
    output-ext: md
slug: []
categories: []
tags:
  - visualización de datos
  - shiny
---


``` r
install.packages("gfonts")
```

``` r
gfonts::setup_font("manrope", "apps/icbg/www")

# luego en shiny ui:
gfonts::use_font("manrope", "www/css/manrope.css")
```

{{< cafecito >}}
{{< cursos >}}
