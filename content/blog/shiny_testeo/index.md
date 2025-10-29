---
title: Testeo automatizado de aplicaciones Shiny con {shinytest2}
author: Bastián Olea Herrera
date: '2025-10-29'
draft: true
slug: []
categories: []
tags:
  - shiny
  - automatización
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: github
    icon_pack: fab
    name: shinytest2
    url: https://rstudio.github.io/shinytest2/index.html
---

https://rstudio.github.io/shinytest2/index.html


```r
library(shinytest2)

test_that("{shinytest2} recording: inversion_gores_2", {
  app <- AppDriver$new(variant = platform_variant(), name = "test-tablas", 
                       height = 985, width = 1254)
  
  # cambiar de pestaña
  app$set_inputs(tabs = "Tabla", allow_no_input_binding_ = TRUE)
  
  # cambiar un input
  app$set_inputs(region = "2")  
  
  # esperar a que la app haya cargado
  app$wait_for_idle(200)
  
  # tomar pantallazo
  app$expect_screenshot()

})

```