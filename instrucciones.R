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
blogdown::new_post(title = "Mapas y visualización de datos geoespaciales en R con {sf}", 
                   file = "blog/sf_mapas/index.qmd",
                   author = "Bastián Olea Herrera",
                   tags = c("mapas"),
                   categories = c("tutoriales") 
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
"content/blog/sf_mapas/sf_mapas.qmd"
"content/blog/shiny_tipografias/shiny_tipografias.qmd"
"content/blog/diferencias/waldo.qmd"


"https://cran.r-project.org/web/packages/janitor/vignettes/tabyls.html" # plagiar
# https://github.com/rundel/livecode
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
"themes/hugo-apero/layouts/_default/single.html" # html de los post 
"themes/hugo-apero/layouts/taxonomy/taxonomy.html" # html de la página de tags (/tags/)
"themes/hugo-apero/layouts/partials/shared/summary-thumbnail.html" # html de las páginas de cada tag (por ejemplo /tags/shiny/)


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
