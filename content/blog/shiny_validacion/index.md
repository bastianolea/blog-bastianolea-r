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


lo primero

```r
record_test("app/inversion_gores/")
```

crea la carpeta tests

dentro está `testthat.R` que contiene `shinytest2::test_app()`
y una carpeta con tests y sus resultados


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


dentro de la carpeta `tests/testthat/_snaps` se pueden encontrar los resultados de los pantallazos producidos durante el test con `app$expect_screenshot()`

Podemos inspeccionarlos visualmente para corroborar que la aplicación funciona correctamente

`testthat` nos avisará si las capturas de pantalla nuevas difieren de las anteriores, lo que significaría un cambio en los resultados


Si tienes una lista con los valores de uno o varios inputs que quieres testear, puedes **correr las pruebas en un loop** que repita la prueba para cada elemento.

De ser necesario, dentro del test puedes cargar datos que te entreguen la lista de inputs (por ejemplo, los valores únicos de una variable)
```r
# por cada variable, navegar y captura de pantalla
  for(i in variables) {
    app$set_inputs(indicador_lista = i)
    app$wait_for_idle(200)
    app$expect_screenshot()
  }
```


Para ejecutar todos los tests
```r
shinytest2::test_app("app/icbg/")
```