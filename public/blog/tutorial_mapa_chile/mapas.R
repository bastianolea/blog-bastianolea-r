# crear mapas comunales y regionales con R
# https://bastianolea.rbind.io/blog/tutorial_mapa_chile/

library(chilemapas) # mapas de chile
library(dplyr) # manipulación de datos
library(ggplot2) # visualización de datos
library(scales) # utilidad para visualización de datos
library(sf) # manipulación de datos geográficos

mapa_comunas <- chilemapas::mapa_comunas

# mapa regional ----
mapa_regiones <- mapa_comunas |> 
  group_by(codigo_region) |> 
  summarize(geometry = st_union(geometry)) # resumir los datos agrupados uniéndolos

mapa_regiones

## visualizar ----
grafico_regiones <- mapa_regiones |> 
  st_set_geometry(mapa_regiones$geometry) |> # especificar la geometría del mapa
  ggplot() + # graficar
  geom_sf() + # capa geográfica
  coord_sf(xlim = c(-77, -65)) # recortar coordenadas

grafico_regiones +
  theme_classic()


# mapa con datos ----

## obtener datos ----
library(rvest)

# dirección de wikipedia con tabla de comunas de Chile
url <- "https://es.wikipedia.org/wiki/Anexo:Comunas_de_Chile"

# obtener tabla con datos de comunas con web scraping
tabla <- session(url) |> 
  read_html() |> 
  html_table(convert = FALSE)

tabla[[1]]

## limpiar datos ----
library(janitor)
library(stringr)

# limpiar datos
datos_comunas <- tabla[[1]] |> 
  clean_names() |> 
  # seleccionar y renombrar columnas
  select(codigo_comuna = cut_codigo_unico_territorial,
         nombre, region, superficie_km2,
         poblacion = poblacion2020) |> 
  # eliminar espacios de la columna de población
  mutate(poblacion = str_remove_all(poblacion, " "),
         poblacion = as.numeric(poblacion)) |> 
  # eliminar los separadores de miles
  mutate(superficie_km2 = str_remove_all(superficie_km2, "\\."),
         # convertir comas a puntos
         superficie_km2 = str_replace(superficie_km2, ",", "."),
         superficie_km2 = as.numeric(superficie_km2))

datos_comunas

## unir datos y mapa ----
mapa_comunas_2 <- mapa_comunas |> 
  # adjuntar datos al mapa, coincidiendo por columna de código de comunas
  left_join(datos_comunas,
            by = join_by(codigo_comuna)) |> 
  relocate(geometry, .after = 0) # tirar geometría al final

mapa_comunas_2


## visualizar datos ----

### población ----
mapa_comunas_2 |> 
  st_set_geometry(mapa_comunas_2$geometry) |> # asignar geometría
  ggplot() + # gráfico
  aes(fill = poblacion) +
  geom_sf(linewidth = 0) + # capa geométrica
  theme_classic() +
  scale_fill_distiller(type = "seq", palette = 12, 
                       labels = label_comma(big.mark = ".")) + # colores
  scale_x_continuous(breaks = seq(-76, -65, length.out = 3) |> floor()) + # escala x
  coord_sf(xlim = c(-77, -65)) + # recortar coordenadas
  theme(legend.key.width = unit(3, "mm"))

### superficie ----
mapa_comunas_2 |> 
  st_set_geometry(mapa_comunas_2$geometry) |>
  ggplot() +
  aes(fill = superficie_km2) + # variable de relleno
  geom_sf(linewidth = 0) +
  theme_classic() +
  scale_fill_distiller(type = "seq", palette = 11,
                       labels = label_comma(big.mark = ".")) + 
  scale_x_continuous(breaks = seq(-76, -65, length.out = 3) |> floor()) +
  coord_sf(xlim = c(-77, -65)) + 
  theme(legend.key.width = unit(3, "mm"))


### una región ----
# filtrar datos
mapa_comunas_filtro <- mapa_comunas_2 |> 
  filter(codigo_region == "06")

mapa_comunas_filtro |> 
  st_set_geometry(mapa_comunas_filtro$geometry) |>
  ggplot() +
  aes(fill = poblacion) +
  geom_sf(linewidth = 0.12, color = "white") +
  geom_sf_text(aes(label = comma(poblacion, big.mark = ".")), 
               size = 2, color = "white", check_overlap = T) +
  theme_classic() +
  scale_fill_distiller(type = "seq", palette = 12,
                       labels = label_comma(big.mark = ".")) + 
  theme(legend.key.width = unit(3, "mm")) +
  theme(axis.title = element_blank())
