# previsualizar sitio

blogdown::serve_site()
blogdown::stop_server()
blogdown::build_site()



## posts ----

# editar el más reciente
abrir_post_reciente()


# crear un post normal
blogdown::new_post(title = "Renombrar muchos archivos desde R", 
                   file = paste0("blog/", lubridate::today(), "/index.md"),
                   author = "Bastián Olea Herrera",
                   tags = c("automatización")
)

# crear un post tutorial
blogdown::new_post(title = "Gráficos de variación o _dumbbell_ en `{ggplot2}`", 
                   file = "blog/ggplot_variacion/index.md",
                   author = "Bastián Olea Herrera",
                   tags = c("visualización de datos", "ggplot2", "gráficos"),
                   categories = c("Tutoriales") 
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
"content/blog/ggplot_variacion/index.qmd"
"content/blog/2026-02-25/index.qmd"
"content/blog/ellmer/index.md"
"content/blog/ggplot_sankey/index.qmd"
"content/blog/googledrive/index.qmd"
# hacer que R te pregunte cosas
# mapas de chile con comunas pero sin líneas en la costa
# pildoritas en shiny y en ggiraph
# subir apps Shiny a posit connect
# tablas gt con flechitas
# datos de género en chile (mmeg, subcomisión, datos.gob, red chilena, ibg)
# How do I replace NA values with zeros in an R dataframe?
# https://www.linkedin.com/feed/update/urn:li:activity:7405241344316841984?utm_source=share&utm_medium=member_desktop&rcm=ACoAAB9if5MBe0keh4VrsmJOFbZxmIK9T9GSkYM

# constantes
"content/blog/mapas_sf/mapas_sf.qmd"
"content/blog/git_comandos/index.md"

# en construcción
"content/blog/mapas_sf/mapas_sf.qmd"

"content/blog/shiny_validacion/index.md"
"content/blog/tutorial_digitalocean/index.md"

# casi listos
"content/blog/shiny_tipografias/shiny_tipografias.qmd"

# ideas
# ejercicios de datos usando datos abiertos: limpiar datos, calcular alguna cosa, predecir algo
"content/blog/dt_tablas/index.qmd"
"content/blog/ellmer/ellmer.qmd"
"content/blog/2025-07-06/index.qmd" # cargar y unir datos

"https://cran.r-project.org/web/packages/janitor/vignettes/tabyls.html" # plagiar
"https://github.com/rundel/livecode"
"content/blog/2025-07-01/index.qmd" # st_join
"content/blog/unpivotr/index.qmd"
"content/blog/web_scraping_github_actions/github_actions_scraping.qmd"



## shortcodes ----

# {{< indice >}}
# {{< cafecito >}}
# {{< cursos >}}
# {{< bajada "x" >}}
# {{< imagen "x" >}}
# {{< imagen_tamaño "x" "300px" >}}
# {{< video "x" >}}
# {{< aviso "x" >}}
# {{< info "x" >}}
# {{< detalles "Hola" >}} {{< /detalles >}}
# {{< boton "Buscador" "https://bastianoleah.shinyapps.io/buscador/" "fas fa-search" >}}



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