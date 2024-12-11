# https://hugo-apero-docs.netlify.app/start/setup/
# https://app.netlify.com/
# https://bastianoleah.netlify.app

# previsualizar sitio
blogdown::serve_site()
blogdown::stop_server()
blogdown::stop_server(); blogdown::serve_site() # reiniciar

# crear un post
blogdown::new_post(title = "Crea tu propio asistente de programación con inteligencia artificial usando el paquete {pal}", 
                   subdir = "blog/",
                   file = "blog/pal_asistentes_llm/index.qmd",
                   author = "Bastián Olea Herrera",
                   tags = c("consejos", "inteligencia artificial"),
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