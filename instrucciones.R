# previsualizar sitio

blogdown::serve_site()
blogdown::stop_server()
blogdown::build_site()


## posts ----

# crear un post normal
blogdown::new_post(title = "Actualización del blog", 
                   file = paste0("blog/", lubridate::today(), "/index.qmd"),
                   author = "Bastián Olea Herrera",
                   tags = c("blog")
)

# crear un post tutorial
blogdown::new_post(title = "App: comparación de ingresos regionales y comunales", 
                   file = "blog/mideso_ingresos_genero/index.md",
                   author = "Bastián Olea Herrera",
                   tags = c("apps", "shiny", "datos", "Chile", "ciencias sociales"),
                   categories = c("apps") 
)

# draft: true
# format:
#   hugo-md:
#     output-file: "index"
#     output-ext: "md"

# links:
#   - icon: github
#     icon_pack: fab
#     name: Código
#     url: https://gist.github.com/bastianolea/8ea85fa8169b302d2144e05434668c89

## borradores ----

# {gander}

# contador de visitas https://haseebmajid.dev/posts/2022-11-20-til-how-you-can-add-goatcounter-to-your-hugo-blog/
  
"content/blog/sf_mapas/sf_mapas.qmd"
"content/blog/shiny_tipografias/shiny_tipografias.qmd"
"content/blog/2025-07-06/index.qmd" # cargar y unir datos
"content/blog/diferencias/waldo.qmd"

"https://cran.r-project.org/web/packages/janitor/vignettes/tabyls.html" # plagiar
# https://github.com/rundel/livecode
"content/blog/2025-07-01/index.qmd" # st_join
"content/blog/unpivotr/index.qmd"
"content/blog/web_scraping_github_actions/github_actions_scraping.qmd"
"content/blog/tutorial_digitalocean/index.md"


## shortcodes ----
# {{< indice >}}
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

"layouts/index.html" #index
"layouts/partials/shared/summary.html" # posts individuales en página de blog
"layouts/partials/shared/summary-thumbnail.html" # posts individuales en las páginas de cada tag 
"layouts/_default/single.html" # html de los post 
"layouts/taxonomy/taxonomy.html" # html de la página de tags (/tags/)

"layouts/partials/shared/sidebar/sidebar-header.html" # sidebar con tags


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
