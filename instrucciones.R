
# previsualizar sitio
blogdown::serve_site()
blogdown::stop_server()


## posts ----

# crear un post normal
blogdown::new_post(title = "Rellenar datos perdidos usando otro dataframe", 
                   file = paste0("blog/", lubridate::today(), "/index.qmd"),
                   author = "Bastián Olea Herrera",
                   tags = c("consejos", "datos", "limpieza de datos")
)

# crear un post tutorial
blogdown::new_post(title = "Creando colores con R", 
                   file = "blog/colores/colores.qmd",
                   author = "Bastián Olea Herrera",
                   tags = c("visualización de datos", "gráficos", "ggplot2"),
                   categories = c() 
)
# format: 
#   hugo-md:
#     output-file: "index"
#     output-ext: "md"


## archivos ----

"content/blog/r_introduccion/recursos_r/index.md" # páginas

"assets/tema-morado-hex.scss" # tema

"config.toml" # configuración


## utilidades ----

# convertir script a Quarto
convertr::r_to_qmd(
  input_dir = "~/Documents/Clases R/Clases SpatialLab/Cursos/curso_intro/nivel_2-datos/clase_2.R",
  output_dir = "content/blog/r_introduccion/dplyr_intermedio/clase_2.qmd"
)

# ver en github
usethis::browse_github()

# configurar netlifly
# blogdown::config_netlify()
blogdown::check_netlify()
