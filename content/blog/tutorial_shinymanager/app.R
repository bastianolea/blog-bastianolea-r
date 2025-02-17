library(shiny)
library(bslib)

ui <- page_fluid(
  
  page_fillable(
    card(
      h1("Aplicación"),
      
      sliderInput("numeros", "Prueba", 1, 10, 5)
    )
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)