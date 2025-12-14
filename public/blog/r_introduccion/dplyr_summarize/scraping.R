# Web scraping con R de una tabla de datos de población de países de América del Sur desde Wikipedia

library(rvest)
library(dplyr)

# definir la dirección a scrapear
url <- "https://es.wikipedia.org/wiki/América_del_Sur#Geografía_política"

# leer el sitio web
sitio <- read_html(url)

# extraer todas las tablas  
tablas <- sitio |> html_table()

# extraer cuarta tabla, de población
tabla <- tablas[[4]]

# seleccionar columnas y filas
tabla_2 <- tabla |> 
  select(pais = 1, superficie = 2, poblacion = 3, idh = 4) |> 
  slice(1:14)
  
# limpiar columnas numéricas
library(stringr)
library(readr)

tabla_3 <- tabla_2 |> 
  # superficie
  mutate(
    # eliminar espacios
    superficie = str_remove_all(superficie, "\\s+"),
    # eliminar texto entre corchetes
    superficie = str_remove_all(superficie, "\\[.*\\]")
    ) |> 
  # población
  mutate(
    # reemplazar comas
    poblacion = str_replace(poblacion, ",", "."),
    # eliminar texto entre paréntesis
    poblacion = str_remove_all(poblacion, "\\(.*\\)")
  ) |> 
  # desarrollo humano
  mutate(
    # reemplazar comas
    idh = str_replace(idh, ",", ".")
  )

# convertir todo a numérico
datos <- tabla_3 |> 
  mutate(
    across(c(superficie, poblacion, idh), parse_number)
  ) |> 
  # convertir población
  mutate(poblacion = poblacion * 1000000)



# datapasta::dpasta(datos)