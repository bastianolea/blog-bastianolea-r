library(shiny)
library(bslib)
library(shinyjs)
library(dplyr)
library(ggplot2)
library(thematic)

thematic_shiny()

ui <- page_fluid(
  theme = bs_theme(bg = "#EAD1FA",
                   fg = "#553A74", 
                   primary = "#8557AB"),
  
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
  
  # mostrar y ocultar elementos en base a los datos
  observe({
    if(nrow(datos()) == 0) {
      hide("grafico")
      show("aviso")
    } else {
      show("grafico")
      hide("aviso")
    }
  })
}

shinyApp(ui, server)