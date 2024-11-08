library(shiny)
library(bslib)

ui <- page_fluid(
  h1("Título"),
  
  h2("Introducción"),
  p("Bienvenidx a mi primera app"),
  
  textInput("nombre", 
            label = "Escribe tu nombre"),
  
  selectInput("saludo",
              label = "Elije un saludo",
              choices = c("Hola", 
                          "Chao", 
                          "Hasta nunca" = "Hasta nunca,")),
  hr(),
  
  # salida desde server
  textOutput("texto") 
)

server <- function(input, output, session) {
  
  # crear un objeto reactivo
  texto <- reactive({
    # paste("Hola", input$nombre) # pegar el contenido del input con otro texto
    paste(input$saludo, input$nombre) # pegar los dos inputs
  })
  
  # output del objeto reactivo
  output$texto <- renderText({
    texto()
  })
}

shinyApp(ui, server)