# previsualizar sitio
blogdown::serve_site()
blogdown::stop_server()

# crear un post
blogdown::new_post(title = "Repositorio de datos sociales", 
                   file = "blog/portafolio_apps/portafolio_apps.qmd", # para posts con slug o url
                   # file = paste0("blog/", lubridate::today(), "/index.md"), #para posts menos interesantes
                   author = "Bastián Olea Herrera",
                   tags = c("blog", "datos", "tablas"),
                   categories = c() 
)

# páginas
"content/blog/r_introduccion/recursos_r/index.md"

# convertir script a Quarto
convertr::r_to_qmd(
  input_dir = "~/R/blog-r/content/blog/recodificacion_stringr/recodificar.R",
  output_dir = "content/blog/recodificacion_stringr/recodificar.qmd"
)

# ver en github
usethis::browse_github()

# configurar netlifly
# blogdown::config_netlify()
blogdown::check_netlify()
