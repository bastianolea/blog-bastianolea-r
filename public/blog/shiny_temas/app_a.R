library(shiny)
library(bslib)

ui <- page_fluid(
  theme = bs_theme(bg = "#EAD1FA",
                   fg = "#553A74",
                   primary = "#8557AB"),
  
  br(),
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

shinyApp(ui, server)
