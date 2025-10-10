library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(thematic)

thematic_shiny()

ui <- page_fluid(
  theme = bs_theme(bg = "#EAD1FA",
                   fg = "#553A74", 
                   primary = "#8557AB"),
  
  br(),
  h1("App Shiny ✨"),
  
  # selector de números
  sliderInput("filtro", label = "Filtrar", 
              min = 5, max = 10, value = 1),
  
  # gráfico
  plotOutput("grafico_barras", width = 320, height = 200)
)

server <- function(input, output, session) {
  
  datos <- reactive({
    iris |> 
      filter(Sepal.Length >= input$filtro)
  })
  
  # generar un gráfico de barras
  output$grafico_barras <- renderPlot({
    datos() |> 
      ggplot() +
      aes(Sepal.Length, Sepal.Width) +
      geom_point()
  })
}

shinyApp(ui, server)