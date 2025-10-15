# previsualizar sitio

blogdown::serve_site()
blogdown::stop_server()


## posts ----

# crear un post normal
blogdown::new_post(title = "Generando ruido visual con R", 
                   file = paste0("blog/", lubridate::today(), "/index.qmd"),
                   author = "Bastián Olea Herrera",
                   tags = c("curiosidades", "arte generativo")
)

# crear un post tutorial
blogdown::new_post(title = "Visualizar un mapa de Chile desde cartografías oficiales", 
                   file = "blog/tutorial_mapa_chile_subdere/index.qmd",
                   author = "Bastián Olea Herrera",
                   tags = c("shiny"),
                   categories = c("tutoriales") 
)
# draft: true
# format:
#   hugo-md:
#     output-file: "index"
#     output-ext: "md"

## borradores ----
"content/blog/validacion_avanzada/validacion_avanzada.qmd"
# https://github.com/rundel/livecode
"https://cran.r-project.org/web/packages/janitor/vignettes/tabyls.html" # plagiar
"content/blog/shiny_tipografias/shiny_tipografias.qmd"

"content/blog/diferencias/waldo.qmd"

"content/blog/2025-07-06/index.qmd" # cargar y unir datos
"content/blog/2025-07-01/index.qmd" # st_join
"content/blog/unpivotr/index.qmd"
"content/blog/web_scraping_github_actions/github_actions_scraping.qmd"
"content/blog/tutorial_digitalocean/index.md"

## shortcodes ----
# {{< cafecito >}}
# {{< cursos >}}
# {{< bajada "x" >}}
# {{< imagen "x" >}}
# {{< video "x" >}}
# {{< aviso "x" >}}


## archivos ----

"content/blog/r_introduccion/recursos_r/index.md" # páginas
"assets/tema-morado-hex.scss" # tema
"config.toml" # configuración

"themes/hugo-apero/layouts/partials/shared/summary.html" # html del blog (lista de posts)
"themes/hugo-apero/layouts/taxonomy/taxonomy.html" # html de la página de tags
"themes/hugo-apero/layouts/partials/shared/summary-thumbnail.html" # html de las páginas de cada tag

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
