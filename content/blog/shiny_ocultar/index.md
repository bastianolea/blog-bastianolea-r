---
title: Mostrar y ocultar elementos de una app Shiny a partir de datos o inputs
author: Bastián Olea Herrera
date: '2025-10-10'
slug: []
categories: []
tags:
  - shiny
format:
  hugo-md:
    output-file: index
    output-ext: md
excerpt: "En este post vemos dos tutoriales para aprender a mostrar y ocultar elementos de una app Shiny a partir de datos o inputs del usuario, usando el paquete `{shinyjs}`. Se trata de una habilidad clave para crear aplicaciones que se adapten a datos complejos, cambiantes, o modificables por los usuarios."
---

Gracias [al paquete `{shinyjs}`](https://deanattali.com/shinyjs/) podemos hacer que una app Shiny muestre u oculte elementos según los datos que correspondan o los inputs que haya seleccionado el usuario. 

**Por ejemplo:**
- Si el/la usuario/a selecciona una opción en particular, mostrar un contenedor con información adicional.
- Si no hay datos para graficar, ocultar el gráfico y mostrar un aviso.

Se trata de una habilidad clave para crear aplicaciones que se adapten a datos complejos, cambiantes, o modificables por los usuarios.

Lo primero que tenemos que hacer en nuestra app es activar el uso de `{shinyjs}` agregando la función `useShinyjs()` en nuestra UI:

```r
library(shiny)
library(bslib)
library(shinyjs)

ui <- page_fluid(
  
  # activar javascript
  useShinyjs()
  )
```

----

## Tutorial 1: mostrar/ocultar elementos según selección del usuario

Para el primer ejemplo, **haremos una app simple que muestre y oculte un elemento de acuerdo a lo que elija el/la usuario/a.** 

En esta app ponemos un título y un selector de opciones (`selectInput()`), una salida de texto (`textOutput()`) para mostrar la selección hecha, y un contenedor `div()` que contiene un aviso que queremos mostrar u ocultar según la selección del usuario. En este contenedor, el argumento `id` es lo que nos permitirá **identificar el elemento** para poder mostrarlo u ocultarlo.

```r
library(shiny)
library(bslib)
library(shinyjs)

ui <- page_fluid(
  
  # activar javascript
  useShinyjs(),
  
  h1("Mostrar/ocultar"),
  
  # selector de opciones 
  selectInput("filtro", label = "Filtrar", 
              choices = c("gato", "perro", "gallina")
  ),
  
  textOutput("animales"),
  
  # contenedor con un aviso para mostrar
  div(id = "aviso",
      style = css(margin_top = "8px"),
      span(
        style = css(border = "solid 1px #A085B7",
                  border_radius = "6px",
                  padding = "6px",
                  font_weight = "bold"),
      "⚠️ Muy muy feo!"
      )
  )
)
```

En la sección `server` de nuestra app vamos a **programar la lógica que hará que se muestre u oculte el aviso**:

```r
server <- function(input, output, session) {
  
  # texto con la selección del usuario/a
  output$animales <- renderText({
    paste("Animal seleccionado:", input$filtro)
  })
  
  # mostrar contenedor sólo si se selecciona "perro"
  observe({
    if(input$filtro == "perro") {
      show("aviso")
    } else {
      hide("aviso")
    }
  })
  
}
```

Usamos `observe()` para que **ocurra una acción en nuestra app si es que cambia algún objeto reactivo.** En este caso, haremos que si se cambia `input$filtro`, se detecte si la selección es `"perro"`, y si es así, mostrar (`show()`) el elemento llamado `"aviso"`. Si la selección es cualquier otra, se oculta (`hide()`) el elemento.

**Veamos la app en acción!**

{{< video "shiny_app_a.mov" >}}

Para este ejemplo, agregamos un pequeño para que se vea más bonita la aplicación, definido al principio de la UI:

```r
theme = bs_theme(bg = "#EAD1FA",
                   fg = "#553A74", 
                   primary = "#8557AB")
```
 
Puedes ver el [código completo de esta aplicación en este Gist de Github.](https://gist.github.com/bastianolea/4fd42f2e95bfd34deb386b3373960358)

----

## Tutorial 2: mostrat/ocultar elementos según los datos

Crearemos una aplicación básica que muestre un gráfico, con un input encima que filtrará los datos del gráfico. Primero definimos la interfaz:

```r
library(shiny)
library(bslib)
library(shinyjs)
library(dplyr)
library(ggplot2)

ui <- page_fluid(
  
  # activar javascript
  useShinyjs(),
  
  h1("Mostrar/ocultar"),
  
  sliderInput("filtro", 
              "Filtrar", 
              min = 5,
              max = 10,
              value = 1),
  
  # contenedor con el elemento a mostrar u ocultar
  div(id = "grafico",
      plotOutput("grafico_barras", width = 320, height = 200)
      ),
  
  # otro contenedor con un aviso para mostrar
  div(id = "aviso",
      p(em("No hay datos para mostrar!"))
  )
)
```

En la sección `server` de nuestra app vamos a crear un objeto reactivo con `reactive()` que filtre los datos a partir del selector `input$filtro`:

```r
server <- function(input, output, session) {
  
  datos <- reactive({
    iris |> 
      filter(Sepal.Length >= input$filtro)
  })
}
```

Con este código, creamos el objeto reactivo `datos()` que se actualizará cada vez que la/el usuario cambie el input `input$filtro`, y por consiguiente actualizará los elementos que usen este objeto.

Luego, definimos un gráfico sencillo en base a `datos()`, y que por consiguiente se actualizará automáticamente cuando cambien los datos reactivos:

```
 # generar un gráfico de barras
  output$grafico_barras <- renderPlot({
    datos() |> 
      ggplot() +
      aes(Sepal.Length, Sepal.Width) +
      geom_point()
  })
```

Finalmente, programamos la lógica que hará que se muestren u oculten los elementos. La idea principal es que **los elementos aparezcan y se oculten a partir de los datos**, por lo que creamos un observador con `observe()` que **ejecute código cada vez que los datos cambien**. En este caso, el observador evaluará con un `if` si el número de filas de los datos (`nrow(datos())`) es cero, y si llega a ser cero, ocultar el gráfico (`hide("grafico")`) y mostrar un texto de aviso (`show("aviso")`).

```r
  # mostrar y ocultar elementos en base a los datos
  observe({
    if (nrow(datos()) == 0) {
      hide("grafico")
      show("aviso")
    } else {
      show("grafico")
      hide("aviso")
    }
  })
```

Vale mencionar que debemos especificar también la condición donde el gráfico debe volver a mostrarse, y el aviso debe volver a ocultarse, para que cuando el o la usuaria cambie el filtro y vuelvan a haber datos, el gráfico vuelva a aparecer.

**Veamos la aplicación!**

{{< video "shiny_app_b.mov" >}}

Puedes ver el [código completo de esta aplicación en este Gist de Github.](https://gist.github.com/bastianolea/31509ea2d6ed040fe61231e2247987a1)

Nuevamente, le agregamos el tema a la aplicación para que se vea bonita, y además agregamos la función `thematic_shiny()` del paquete `{thematic}` para que los gráficos usen los colores del tema automáticamente.
