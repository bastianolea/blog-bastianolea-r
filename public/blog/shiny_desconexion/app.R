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
