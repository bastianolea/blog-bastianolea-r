# previsualizar sitio

blogdown::serve_site()
blogdown::stop_server()
blogdown::build_site()



## posts ----

# editar el más reciente
abrir_post_reciente()


# crear un post normal
blogdown::new_post(title = "Recibe fotos de gatos o bendiciones automáticamente al abrir RStudio", 
                   file = paste0("blog/", lubridate::today(), "/index.md"),
                   author = "Bastián Olea Herrera",
                   tags = c("blog", "gráficos")
)

# crear un post tutorial
blogdown::new_post(title = "Interactúa desde R con una IA que conoce tus datos, archivos y paquetes", 
                   file = "blog/btw/index.qmd",
                   author = "Bastián Olea Herrera",
                   tags = c("inteligencia artificial", "consejos"),
                   categories = c() 
)

# draft: true
# format:
#   hugo-md:
#     output-file: "index"
#     output-ext: "md"

# links:
#   - icon: file-code
#     icon_pack: fas
#     name: Código
#     url: https://gist.github.com/bastianolea/8ea85fa8169b302d2144e05434668c89


## borradores ----

# https://www.linkedin.com/feed/update/urn:li:activity:7405241344316841984?utm_source=share&utm_medium=member_desktop&rcm=ACoAAB9if5MBe0keh4VrsmJOFbZxmIK9T9GSkYM


# constantes
"content/blog/mapas_sf/mapas_sf.qmd"
"content/blog/git_comandos/index.md"

# en construcción
"content/blog/mapas_sf/mapas_sf.qmd"
"content/blog/ellmer/index.md"
"content/blog/shiny_validacion/index.md"
"content/blog/tutorial_digitalocean/index.md"

# casi listos
"content/blog/shiny_tipografias/shiny_tipografias.qmd"

# pendientes importantes
"content/blog/r_introduccion/dplyr_intermedio/dplyr_intermedio.qmd"
"content/blog/r_introduccion/dplyr_variables/dplyr_variables.qmd"

# ideas
"content/blog/dt_tablas/index.qmd"
"content/blog/ellmer/ellmer.qmd"
"content/blog/2025-07-06/index.qmd" # cargar y unir datos

"https://cran.r-project.org/web/packages/janitor/vignettes/tabyls.html" # plagiar
"https://github.com/rundel/livecode"
"content/blog/2025-07-01/index.qmd" # st_join
"content/blog/unpivotr/index.qmd"
"content/blog/web_scraping_github_actions/github_actions_scraping.qmd"




## pendientes ----

# last.fm https://blog.spacehey.com/entry?id=221954
# búsqueda 
# https://aaronluna.dev/blog/add-search-to-static-site-lunrjs-hugo-vanillajs/
# https://palant.info/2020/06/04/the-easier-way-to-use-lunr-search-with-hugo/
# https://dev.to/fajarwz/create-search-feature-for-hugo-static-site-with-lunr-4dbl



## shortcodes ----

# {{< indice >}}
# {{< cafecito >}}
# {{< cursos >}}
# {{< bajada "x" >}}
# {{< imagen "x" >}}
# {{< imagen_tamaño "x" "300px" >}}
# {{< video "x" >}}
# {{< aviso "x" >}}
# {{< detalles "Hola" >}} {{< /detalles >}}



## archivos ----
"content/blog/r_introduccion/recursos_r/index.md" # páginas
"assets/tema-morado-hex.scss" # tema
"config.toml" # configuración

"layouts/index.html" #index
"layouts/partials/shared/summary.html" # posts individuales en página de blog
"layouts/partials/shared/summary-thumbnail.html" # posts individuales en las páginas de cada tag 
"layouts/blog/single-sidebar.html" # html de los post 
"layouts/taxonomy/taxonomy.html" # html de la página de tags (/tags/)

"layouts/index.json" # genera el sitio en JSON para el buscador (el archivo queda en public como index.json)
"layouts/partials/shared/sidebar/sidebar-header.html" # sidebar del blog

"assets/custom.scss" # css del sitio
"static/css/syntax.css" # css del syntax higlight


## utilidades ----

# convertir script a Quarto
convertr::r_to_qmd(
  input_dir = "~/Documents/Clases R/Clases SpatialLab/Cursos/curso_intro/nivel_3-visualizaciones/clase_2.R",
  output_dir = "content/blog/tutorial_visualizacion_ggplot/clase_2.qmd"
)

# ver en github
usethis::browse_github()