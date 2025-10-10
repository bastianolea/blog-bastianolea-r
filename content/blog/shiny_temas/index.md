---
title: Temas de colores personalizados en apps Shiny
author: Bastián Olea Herrera
date: '2025-10-09'
draft: false
slug: []
categories: []
tags:
  - visualización de datos
  - ggplot2
  - gráficos
excerpt: En este post muestro lo básico para personalizar la apariencia de tus aplicaciones Shiny con temas de colores personalizados usando el paquete `{bslib}`, y además cómo hacer que los gráficos `{ggplot2}` se ajusten automáticamente al tema usando {thematic}. Recuerda que una app con un diseño atractivo puede marcar la diferencia entre que alguien la use o no, o bien, que alguien la recuerde o no!
---

Elevar tus aplicaciones Shiny al siguiente nivel es muy fácil! Una app con un diseño atractivo y profesional puede marcar la diferencia entre que alguien la use o no, o bien, que alguien la recuerde o no!

En este tutorial veremos cómo personalizar los temas de colores en tus aplicaciones Shiny utilizando el [paquete `{bslib}`](https://rstudio.github.io/bslib/), y además combinaremos esto con la capacidad para que nuestros gráficos `{ggplot2}` se ajusten automáticamente al tema gracias [al paquete `{thematic}`](https://rstudio.github.io/thematic/).


## Crear una aplicación Shiny básica

Comencemos con una aplicación Shiny muy básica, que no tiene ningún tema de colores personalizado. El código es el siguiente:

```{r}
library(shiny)
library(bslib)

ui <- page_fluid(
  h1("App Shiny ✨"),
  
  # selector de opciones 
  selectInput("animal", label = "Animalito", 
              choices = c("Gatito", "Gallineta", "Ratita")),
  
  # deslizador de tamaño
  sliderInput("tamaño", label = "Tamaño", 
              min = 16, max = 128, value = 48, ticks = FALSE),
  
  htmlOutput("animales")
)

server <- function(input, output, session) {
}

shinyApp(ui, server)
```

{{< imagen "app_shiny_sin_tema.png" >}}

En esta aplicación extra básica tenemos un texto, un selector de alternativas, y un deslizador numérico para seleccionar valores.


## Cambiar los colores de una app Shiny

Para cambiar el tema de colores, usaremos la función `bs_theme()` del paquete `{bslib}`. Esta función nos permite definir los colores principales de la aplicación, y luego aplicarlos a la interfaz de usuario con el argumento `theme` de la función que usemos para construir la UI o interfaz de nuestra app (en este caso, `page_fluid()`).

Para definir los colores del tema, agregamos el argumento `theme` a `page_fluid()`, y definimos el tema de la siguiente manera:

```r
theme = bs_theme(bg = "#EAD1FA",
                   fg = "#553A74",
                   primary = "#8557AB")
```

Aquí se configuran los tres colores principales: el fondo (`bg`), el color de los textos (`fg`), y el color principal (`primary`) que se usa en los botones, barras de navegación, y otros elementos interactivos.

## Agregar funcionalidad a la app Shiny

Antes de seguir, agreguemos alguna funcionalidad a nuestra app! En la función `server` agregaremos el siguiente código para hacer que la app muestre el emoji del animal seleccionado junto a un texto, y el deslizador nos permitirá cambiar el tamaño del animal elegido:

```r
server <- function(input, output, session) {
  
  # generar animalito con texto y emoji
  output$animales <- renderUI({
    
    # animal y texto según selección
    if (input$animal == "Gatito") {
      animal <- list("texto" = "Miu", 
                     "emoji" = "🐈")
      
    } else if (input$animal == "Gallineta") {
      animal <- list("texto" = "Cocorocó", 
                     "emoji" = "🐓")
      
    } else if (input$animal == "Ratita") {
      animal <- list("texto" = "Mimimi", 
                     "emoji" = "🐁")
    }
    
    # generar interfaz para mostrar el animalito
    div(
      # título del animal
      h3(em(animal$texto)),
      
      # emoji del animal
      div(animal$emoji, 
          # tamaño del animalito
          style = css(font_size = paste0(input$tamaño, "px"))
      )
    )
  })
}
```

Ahora sí, **veamos cómo cambia la app al aplicar este tema:**

{{< video "app_shiny_tema.mov" >}}



