# https://hugo-apero-docs.netlify.app/start/setup/
# https://app.netlify.com/
# https://bastianoleah.netlify.app

# previsualizar sitio
blogdown::serve_site()
blogdown::stop_server()
blogdown::stop_server(); blogdown::serve_site() # reiniciar

# crear un post
blogdown::new_post(title = "Introducción al lenguaje de programación R", 
                   subdir = "blog/",
                   file = "blog/r_introduccion/r_basico/index.md",
                   author = "Bastián Olea Herrera",
                   tags = c(),
                   categories = c() 
)

# convertir script a Quarto
convertr::r_to_qmd(
  input_dir = "~/Documents/Clases R/Clases particulares/Luciano/reporte_gestion/dias_habiles.R",
  output_dir = "content/blog/contar_dias_habiles/codigo.qmd"
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