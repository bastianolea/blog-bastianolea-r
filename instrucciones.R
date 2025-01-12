# https://hugo-apero-docs.netlify.app/start/setup/
# https://app.netlify.com/
# https://bastianoleah.netlify.app

# previsualizar sitio
blogdown::serve_site()
blogdown::stop_server()
blogdown::stop_server(); blogdown::serve_site() # reiniciar

# crear un post
blogdown::new_post(title = "Configura RStudio para que cambie al modo oscuro o claro automáticamente según la hora del día", 
                   subdir = "blog/",
                   # file = "blog/portafolio_apps/portafolio_apps.qmd", # para posts con slug o url
                   # file = "blog/camcorder/index.md", # para posts con slug o url
                   file = paste0("blog/", lubridate::today(), "/index.md"), #para posts menos interesantes
                   author = "Bastián Olea Herrera",
                   tags = c("consejos", "temas"),
                   categories = c() 
)

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

# los colores se cambian en assets/tema-morado-hex.scss

# obtener dominio rbind https://github.com/rbind/support/issues/new

# carpetas
# blog: content/blog
# proyectos: content/project


# agregar más paginas: https://hugo-apero-docs.netlify.app/start/section-config/?panelset=project-%25F0%259F%2593%25B7&panelset1=list-sidebar-%25F0%259F%2593%25B7