# https://hugo-apero-docs.netlify.app/start/setup/
# https://app.netlify.com/
# https://bastianoleah.netlify.app

# previsualizar sitio
blogdown::serve_site()
blogdown::stop_server()
blogdown::stop_server(); blogdown::serve_site() # reiniciar

# crear un post
blogdown::new_post(title = "Portafolio de trabajos remunerados en R", 
                   subdir = "blog/",
                   file = "blog/portafolio_trabajos_r/index.md",
                   author = "Bastián Olea Herrera",
                   tags = c("aplicaciones", "gráficos", "shiny", "tablas", "mapas", "quarto"),
                   categories = c() 
)

# convertir script a Quarto
convertr::r_to_qmd(
  input_dir = "~/R/servel_votaciones/pruebas/genero_candidatos_LLM.R",
  output_dir = "~/R/blog/blog-r/content/blog/genero_nombres_llm/codigo.qmd"
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