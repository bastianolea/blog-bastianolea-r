---
title: Mensajes de desconexión personalizados en Shiny
author: Bastián Olea Herrera
date: '2025-11-16'
slug: []
categories: []
tags:
  - shiny
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: registered
    icon_pack: fas
    name: shinydisconnect
    url: https://github.com/daattali/shinydisconnect
  # - icon: github
  #   icon_pack: fab
  #   name: Código
  #   url: https://github.com/daattali/shinydisconnect
excerpt: "Las aplicaciones Shiny funcionan con un servidor detrás, que es el proceso de R que realiza los cálculos necesarios para mostrar tus contenidos. Por lo mismo, estas aplicaciones no pueden estar conectadas por siempre. Lo bueno es que podemos personalizar el mensaje de desconexión de la app para que les usaries entiendan mejor que la app requiere recargarse."
---

Las aplicaciones Shiny funcionan con un servidor detrás, que es el proceso de R que realiza los cálculos necesarios para mostrar tus contenidos. Por lo mismo, estas aplicaciones **no pueden estar conectadas por siempre**, porque el proceso no puede estar esperando que la o el usuario hagan algo por siempre, así que y **luego de un tiempo de inactividad se desconectan**. 

Por ejemplo, si pasa mucho tiempo, o si el usuario de la app presiona un enlace y se va de la aplicación, y después aprieta atrás en el navegador, la app podría haberse desconectado al detectar que el usuario se fue. 
En estos casos la aplicación se pone gris, o bien, aparece un mensaje en inglés sobre la desconexión.

Para mejorar la experiencia de uso podemos configurar mensaje de desconexión más amigable. Con [el paquete {shinydisconnect} de Dean Attali](https://github.com/daattali/shinydisconnect) podemos personalizar el mensaje de desconexión de la app para que les usaries entiendan mejor que la app requiere recargarse.

Instala el paquete con `install.packages("shinydisconnect")` y agrégalo al código de tu app:

```r
library(shinydisconnect)
```

Usaremos una aplicación sencilla de prueba, que tiene el siguiente código para hacerla desconectarse:

```r
observeEvent(input$desconectar, {
    session$close()
  })
```

{{< imagen "shinydisconnect_1.png" >}}

Para personalizar el mensaje de desconexión, en la interfaz de usuario (`ui`), agregamos la función `disconnectMessage()`, donde puedes personalizar el texto y los colores:

```r
# mensaje en caso de desconexión
disconnectMessage(
  refresh = "Volver a cargar",
  background = "#EAD1FA",
  colour = "#553A74",
  refreshColour = "#9069C0",
  overlayColour = "#553A74",
  size = 14,
  text = "La aplicación se desconectó. Vuelve a cargar la página."
),
```

Ahora cuando la aplicación se cae o desconecta, aparece un mensaje más amigable:

{{< imagen "shinydisconnect_2.png" >}}

Mucho mejor!

{{< detalles "Ver código completo de la aplicación" >}}

```r
library(shiny)
library(bslib)
library(ggplot2)
library(shinydisconnect)

thematic::thematic_shiny()

ui <- page_fill(
  
  # tema
  theme = bs_theme(
    fg = "#553A74",
    bg = "#EAD1FA",
    primary = "#6E3A98"
  ),
  
  
  # mensaje en caso de desconexión
  disconnectMessage(
    refresh = "Volver a cargar",
    background = "#EAD1FA",
    colour = "#553A74",
    refreshColour = "#9069C0",
    overlayColour = "#553A74",
    size = 14,
    text = "La aplicación se desconectó. Vuelve a cargar la página."
  ),
  
  # interfaz
  div(
  h1("Una aplicación muy aburrida"),
  
  plotOutput("grafico", height = 240, width = 320),
  
  actionLink("desconectar", 
               "Desconectar la app")
  )
)
 
server <- function(input, output, session) { 
  
  # desconectar la app
  observeEvent(input$desconectar, {
    session$close()
  })
  
  output$grafico <- renderPlot({
    iris |> 
      ggplot() +
      aes(Sepal.Length, Sepal.Width) +
      geom_point()
  })
  
}

shinyApp(ui, server)
```

{{< /detalles >}}