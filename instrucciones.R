
# previsualizar sitio
blogdown::serve_site()
blogdown::stop_server()


## posts ----

# crear un post normal
blogdown::new_post(title = "Redactar una lista de palabras separadas por comas en R", 
                   file = paste0("blog/", lubridate::today(), "/index.qmd"),
                   author = "Bastián Olea Herrera",
                   tags = c("consejos", "texto")
)

# crear un post tutorial
blogdown::new_post(title = "Automatiza la generación de reportes creando documentos parametrizados con Quarto y R", 
                   file = "blog/quarto_params/index.md",
                   author = "Bastián Olea Herrera",
                   tags = c("quarto"),
                   categories = c() 
)
# format:
#   hugo-md:
#     output-file: "index"
#     output-ext: "md"

## borradores ----
"content/blog/stringr_texto/stringr.qmd" # sacar del computador de la pega
"content/blog/quarto_loop/index.md"
"content/blog/tutorial_scraping_selenium/selenium.qmd"
"content/blog/web_scraping_github_actions/github_actions_scraping.qmd"
"content/blog/tutorial_digitalocean/index.md"


## archivos ----

"content/blog/r_introduccion/recursos_r/index.md" # páginas

"assets/tema-morado-hex.scss" # tema

"config.toml" # configuración


## utilidades ----

# convertir script a Quarto
convertr::r_to_qmd(
  input_dir = "~/Documents/Clases R/Clases SpatialLab/Cursos/curso_intro/nivel_3-visualizaciones/clase_2.R",
  output_dir = "content/blog/tutorial_visualizacion_ggplot/clase_2.qmd"
)

# ver en github
usethis::browse_github()

# configurar netlifly
# blogdown::config_netlify()
blogdown::check_netlify()
