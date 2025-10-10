library(shiny)
library(bslib)
library(shinyjs)

ui <- page_fluid(
  theme = bs_theme(bg = "#EAD1FA",
                   fg = "#553A74", 
                   primary = "#8557AB"),
  
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

shinyApp(ui, server)