
abrir_post_reciente <- function() {
  # de todas las carpetas con posts, presentar las más recientes,
  # y abrir el archivo quarto o markdown de la carpeta elegida
  
  library(fs)
  library(dplyr)
  library(stringr)
  
  # obtener todas las carpetas del blog
  carpetas <- dir_info("content/blog", type = "directory")
  
  # filtrar las 3 más recientes
  recientes <- carpetas |> 
    slice_max(modification_time, 
              n = 3)
  
  # dar a elegir entre las 3
  eleccion <- menu(recientes$path, title = "Archivos recientes")
  
  # carpeta elegida
  elegido <- recientes$path[eleccion]
  
  # archivos dentro de la carpeta elegida
  archivos <- dir_info(elegido, regexp = "\\.qmd|\\.md") |> 
    pull(path)
  
  # revisar si uno de ellos es quarto
  hay_quarto <- str_detect(archivos, "\\.qmd")
  
  # si hay quarto, abrir ese, y si no, abrir markdown
  if (any(hay_quarto)) {
    archivo <- str_subset(archivos, "\\.qmd")[1]
  } else {
    archivo <- str_subset(archivos, "\\.md")[1]
  }
  
  # abrir archivo con RStudio
  rstudioapi::navigateToFile(archivo)
}
