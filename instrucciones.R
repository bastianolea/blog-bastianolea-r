# previsualizar sitio
blogdown::serve_site()
blogdown::stop_server()

# crear un post
blogdown::new_post(title = "Cargar archivos .csv más rápido con Arrow", 
                   # file = "blog/portafolio_apps/portafolio_apps.qmd", # para posts con slug o url
                   file = paste0("blog/", lubridate::today(), "/index.md"), #para posts menos interesantes
                   author = "Bastián Olea Herrera",
                   tags = c("consejos", "datos"),
                   categories = c() 
)

# páginas
"content/blog/r_introduccion/recursos_r/index.md"

# convertir script a Quarto
convertr::r_to_qmd(
  input_dir = "~/R/blog-r/content/blog/r_introduccion/r_intermedio/codigo.R",
  output_dir = "content/blog/r_introduccion/r_intermedio/codigo2.qmd"
)

# ver en github
usethis::browse_github()

# configurar netlifly
# blogdown::config_netlify()
blogdown::check_netlify()
