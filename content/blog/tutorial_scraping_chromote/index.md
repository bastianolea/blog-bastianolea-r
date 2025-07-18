---
title: Web scraping usando Google Chrome desde R con {chromote}
author: Bastián Olea Herrera
date: '2025-07-17'
draft: false
format:
  hugo-md:
    output-file: index
    output-ext: md
slug: []
categories: []
tags:
  - web scraping
execute:
  eval: false
excerpt: >-
  El paquete `{chromote}` permite utilizar desde R _Chrome DevTools_ para
  controlar navegadores Chromium, como Google Chrome, entre otros. Esto
  significa que podremos usar Chrome para conectarnos a los sitios web e
  interpretarlos usando su propio motor para cargar sitios web dinámicos y
  complejos.
---


En este blog ya hemos cubierto un par de herramientas de [web scraping](../../../tags/web-scraping/), cada una con sus características y beneficios: [`{rvest}`](../../../blog/tutorial_scraping_rvest/), un paquete fácil y rápido de usar para extraer datos desde sitios webs comunes, y [`{RSelenium}`](../../../blog/tutorial_scraping_selenium/), una interfaz en R para utilizar un software de automatización de navegadores bastante popular, aunque un poco menos amigable.

Ahora veremos cómo extraer datos desde páginas web usando un paquete de R que, a grandes rasgos, hace web scraping controlando Google Chrome.

{{< aviso "Si necesitas aprender lo básico del web scraping, primero [revisa este tutorial de `{rvest}`](/blog/tutorial_scraping_rvest/)" >}}

El [paquete `{chromote}`](https://rstudio.github.io/chromote/index.html) permite utilizar desde R *Chrome DevTools* para controlar navegadores Chromium, como Google Chrome, entre otros. Esto significa que podremos usar Chrome para conectarnos a los sitios web e interpretarlos usando su propio motor para cargar sitios web dinámicos y complejos, como con [`{RSelenium}`](../../../blog/tutorial_scraping_selenium/).

Instalamos el paquete, si es que no lo tenemos aún:

``` r
install.packages("chromote")
```

Cargamos `{chromote}` y especificamos que queremos utilizar el nuevo modo sin interfaz gráfica (*headless*) de Chrome, ya recientemente hubo una actualización de este modo que cambió la forma en que se usa.

``` r
library(chromote)
options(chromote.headless = "new")
```

Ahora abrimos una nueva sesión en el navegador para poder empezar a controlarlo:

``` r
chrome <- ChromoteSession$new()
```

Lo que hicimos aquí fue crear un objeto `chrome` te representa la instancia del navegador que abrimos, y desde el cual podremos ir ejecutando las instrucciones.

Como `{chromote}` principalmente funciona sin un interfaz gráfica, igual que `{rvest}`, podremos seguir desde nuestra consola de R sin tener que cambiar de aplicación.

Ahora podemos aplicar una de las fortalezas de estas estrategia para web scraping, que es **especificar un [agente de usuario personalizado](https://rstudio.github.io/chromote/articles/example-custom-user-agent.html)**. Lo que hace esto es decirle a los sitios web que te estás conectando desde un navegador común y corriente, en vez de que detecten que estas haciendo scraping de manera programática, es decir, que no sospechen que eres un robot 🤖

``` r
navegador <- "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36"

chrome$Network$setUserAgentOverride(userAgent = navegador)
```

De este modo estamos simulando que usamos un navegador real, lo que puede ayudarte a resolver problemas con conexiones a determinados sitios.

### Navegar a páginas web

Ahora podemos controlar el navegador para dirigirlo a una página web con `$Page$navigate()`. Luego podemos ejecutar `$Page$loadEventFired()` para que la sesión se bloquee hasta que la página web esté completamente cargada. Esto es súper conveniente cuando los sitios son complejos, para evitar extraer el código del sitio antes de qué esté completamente cargado.

``` r
enlace <- "https://bastianolea.rbind.io"
chrome$Page$navigate(enlace) # navegar a la página
chrome$Page$loadEventFired() # esperar a que cargue
```

### Extraer el código fuente

Una vez que estamos en el sitio que deseamos, ejecutamos lo siguiente para [extraer el código fuente](https://rstudio.github.io/chromote/articles/example-extract-text.html) de la página:

``` r
fuente <- chrome$Runtime$evaluate("document.querySelector('html').outerHTML")$result$value # obtener datos
```

Ahora contamos con todo el código HTML que genera el contenido de la página web, podemos [recurrir a `{rvest}`](../../../blog/tutorial_scraping_rvest/) para interpretar el código y así extraer los contenidos que necesitemos:

``` r
library(rvest)

# leer código fuente del sitio web
sitio <- read_html(fuente)

# extraer un párrafo de texto
sitio |> 
  html_elements(".page-main") |> 
  html_elements("p") |> 
  html_text2()
```

    [1] "Este sitio contiene todo tipo de recursos sobre programación con el lenguaje R para análisis de datos, con un foco en las ciencias sociales. En el blog comparto consejos, novedades y tutoriales de R para que otras personas aprendan a programar en este lenguaje."

### Otros

Si queremos vigilar visualmente el control que hacemos sobre Chrome con `{chromote}`:

``` r
chrome$view()
```

{{< imagen "chromote_r.png" >}}

También podemos tomar capturas de pantalla de lo que está viendo nuestro navegador remoto:

``` r
chrome$screenshot("pantallazo.png")
```

Finalmente, para terminar la sesión y apagar el proceso del navegador remoto, ejecutamos lo siguiente:

``` r
chrome$close()
```

------------------------------------------------------------------------

{{< cafecito >}}
{{< cursos >}}
