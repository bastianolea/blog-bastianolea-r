---
title: 'Tutorial: web scraping con Selenium en R usando {RSelenium}'
author: Bastián Olea Herrera
date: '2025-03-07'
draft: true
format:
  hugo-md:
    output-file: index
    output-ext: md
slug: []
categories:
  - Tutoriales
tags:
  - web scraping
execute:
  eval: false
excerpt: >-
  Selenium es una herramienta que permite realizar web scraping avanzado por
  medio del control programático de un navegador web, lo cual abre infinitas
  posibilidades al momento de automatizar la obtención de datos e información
  desde sitios web dinámicos y/o complejos. En este tutorial aprenderemos a usar
  {RSelenium} para programar scripts de R que automaticen el control de un
  navegador para interactuar con sitios web y así scrapear datos mas difíciles
  de obtener.
---


Selenium es una herramienta que permite realizar web scraping avanzado por medio del control programático de un navegador web, lo cual abre infinitas posibilidades al momento de automatizar la obtención de datos e información desde sitios web dinámicos y/o complejos. En este tutorial aprenderemos a usar {RSelenium} para programar scripts de R que automaticen el control de un navegador para interactuar con sitios web y así scrapear datos mas difíciles de obtener.

``` r
library(RSelenium)

driver <- rsDriver(port = 4570L, browser = "firefox", chromever = NULL, verbose = T, check = T)


remDr <- driver[["client"]]
```

Navegar a un sitio web

``` r
remDr$navigate("http://chileindica.cl/home.php")
```

Hacer click

``` r
remDr$findElement("xpath", "/html/body/section/form/div[2]/div[2]/div[4]/a/span")$clickElement()
```

Obtener código de fuente del sitio

``` r
sitio <- read_html(remote$getPageSource()[[1]])
```

Luego podemos continuar usando {rvest} para realizar el scraping

``` r
sitio |> 
  html_elements(".recursos") |> 
  html_elements("a")
```

Tomar captura de pantalla

``` r
remDr$screenshot(file = 'test.png')
```

Descargar archivos

``` r
# obtener enlaces

download.file(tabla_enlaces$url,
              destfile = paste0("datos/", tabla_enlaces$archivos))
```

Descargar imágenes

``` r
# for parsing the src:
library(stringr)

# Get all the images:
images <- remDr$findElements(using="tag name", "img")

# create images directory
dir.create("images")

for (image in images) {
  # get the image src
  src <- image$getElementAttribute("src")

  # extract the end of the url and hope it is unique. should be good to go based on a quick inspection
  src_name <- gsub("/", "", str_extract(src, "[^/]+/[^/]+.jpg"))

  # download!
  download.file(src, paste("./images/", src_name, sep=""))
}
```

Obtener dimensiones del navegador

``` r
# Get inner window height and width
inner_window_height <- remDr$executeScript("return window.innerHeight")[[1]]
inner_window_width <- remDr$executeScript("return window.innerWidth")[[1]]
```

Cambiar dimensiones de ventana del navegador

``` r
# remDr$setWindowSize(width = 1024, height = 1000)
```

Desplazarse por el sitio (scroll)

``` r
# Scroll down (loop from here to end)
remDr$executeScript(str_c("window.scrollBy(0, ", inner_window_height, ");"))
```

Usar Selenium IDE para grabar interacciones con un sitio

https://addons.mozilla.org/en-US/firefox/addon/selenium-ide/
