library(shiny)
library(bslib)

ui <- page_fluid(
  titlePanel("Mi aplicación"),
  
  h1("Título"),
  
  card(
    h1("Hola"),
    selectInput("selector",
                label = "Elegir palabra",
                choices = c("hola", "como", "estás")
                )
  )
)
