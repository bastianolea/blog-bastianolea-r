
# previsualizar sitio
blogdown::serve_site()
blogdown::stop_server()


## posts ----

# crear un post normal
blogdown::new_post(title = "Web scraping usando Google Chrome desde R con {chromote}", 
                   file = paste0("blog/", lubridate::today(), "/index.qmd"),
                   author = "Bastián Olea Herrera",
                   tags = c("quarto", "consejos")
)

# crear un post tutorial
blogdown::new_post(title = "Web scraping con R", 
                   file = "blog/web_scraping/index.qmd",
                   author = "Bastián Olea Herrera",
                   tags = c("web scraping"),
                   categories = c() 
)
# draft: true
# format:
#   hugo-md:
#     output-file: "index"
#     output-ext: "md"

## borradores ----
"content/blog/2025-07-06/index.qmd" # unir datos
"content/blog/2025-07-01/index.qmd" # st_join
"content/blog/openxlsx/index.md"
"content/blog/unpivotr/index.qmd"

# scraping chromote?
"content/blog/tutorial_scraping_selenium/selenium.qmd"
"content/blog/web_scraping_github_actions/github_actions_scraping.qmd"
"content/blog/tutorial_digitalocean/index.md"

## shortcodes ----
# {{< cafecito >}}
# {{< cursos >}}
# {{< bajada "x" >}}
# {{< imagen "x" >}}
# {{< aviso "x" >}}


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
