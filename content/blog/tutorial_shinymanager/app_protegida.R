library(shiny)
library(bslib)
library(shinymanager)

# credenciales para autenticación
credentials <- data.frame(
  user = "usuario",
  password = "usuario"
)

ui <- page_fluid(
  
  page_fillable(
    card(
      h1("Aplicación"),
      
      sliderInput("numeros", "Prueba", 1, 10, 5)
    )
  )
)

server <- function(input, output, session) {
  # autenticación
  res_auth <- secure_server(check_credentials = check_credentials(credentials))
}

# autenticación
ui <- secure_app(theme = shinythemes::shinytheme("flatly"), ui)

# cambiar textos de autenticación
set_labels(language = "en",
           "Please authenticate" = "Acceder",
           "Username:" = "Usuario:",
           "Password:" = "Contraseña:",
           "Login" = "Acceder"
)

shinyApp(ui, server)