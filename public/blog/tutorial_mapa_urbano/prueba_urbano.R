
comunas_urbanas <- c("Pudahuel", "Cerro Navia", "Conchali", "La Pintana", "El Bosque", 
                     "Estacion Central", "Pedro Aguirre Cerda", "Recoleta", "Independencia", 
                     "La Florida", "Penalolen", "Las Condes", "Lo Barnechea", "Quinta Normal", 
                     "Maipu", "Macul", "Nunoa", "Puente Alto", "Quilicura", "Renca", 
                     "San Bernardo", "San Miguel", "La Granja", "Providencia", "Santiago",
                     "San Joaquin", "Lo Espejo", "La Reina", "San Ramon", "La Cisterna", 
                     "Lo Prado", "Cerrillos", "Vitacura", "Huechuraba")

# obtener mapa por zonas rural/urbano
mapa_zonas_urbanas <- chilemapas::mapa_zonas |> 
  filter(codigo_region == 13) |> 
  left_join(chilemapas::codigos_territoriales |> 
      select(matches("comuna")))

# mapa de sectores urbanos
mapa_zonas_urbanas |> 
  ggplot(aes(geometry = geometry)) +
  geom_sf(fill = "blue")

# mapa de sectores urbanos, unidos por comuna
mapa_zonas_urbanas |> 
  # simplificar por comunas
  group_by(nombre_comuna, codigo_comuna) %>% 
  summarise(geometry = st_union(geometry)) |> 
  ggplot(aes(geometry = geometry)) +
  geom_sf(fill = "blue")

# mapa de sectores urbanos, de comunas urbanas
mapa_zonas_urbanas |> 
  # filter(nombre_comuna %in% comunas_urbanas) |>
  filter(codigo_provincia %in% c(131, 132) | nombre_comuna == "San Bernardo", nombre_comuna != "Pirque") |>
  # simplificar por comunas
  group_by(nombre_comuna, codigo_comuna, codigo_provincia) %>% 
  summarise(geometry = st_union(geometry)) |> 
  ggplot(aes(geometry = geometry)) +
  geom_sf(fill = "blue") +
    geom_sf_text(aes(label = codigo_provincia))

# # una de las cosas mas absurdas que he hecho
# # va pintando los poligonos para ver como se llama cada uno, y así poder filtrar las islas
# mapa_zonas_urbanas |>
#   filter(nombre_comuna %in% comunas_urbanas) |>
#   filter(nombre_comuna == "Pudahuel") |>
#   # filter(!geocodigo %in% c("13124071004", "13124071005", "13124081001", "13124071001", "13124071002", "13124071003")) |>
#   # slice(30:40) |>
#   mutate(prueba = if_else(geocodigo %in% sample(geocodigo, 1), T, F)) |>
#   arrange(desc(prueba)) |>
#   print() |>
#   ggplot(aes(geometry = geometry, fill = prueba)) +
#   geom_sf() +
#   geom_sf_text(aes(label = geocodigo))



mapa_zonas_urbanas |> 
  # filtrar solo comunas urbanas
  filter(nombre_comuna %in% comunas_urbanas) |>
  # filtrar islas urbanas
  filter(!geocodigo %in% c("13124071004", "13124071005", "13124081001", "13124071001", "13124071002", "13124071003", #Pudahuel
                           "13401121001", #San Bernardo
                           "13119131001", #Maipú
                           "13203031000", "13203031001", "13203031002", "13203011001", "13203011002" #San José de Maipo
                           )) |>
  # unir comunas
  group_by(nombre_comuna, codigo_comuna) %>%
  summarise(geometry = st_union(geometry)) |>
  ungroup() |>
  # simplificar geometrías
  # mutate(geometry = ms_simplify(geometry,  keep = 0.2)) |>
  # graficar
  ggplot(aes(geometry = geometry)) +
  geom_sf(fill = "blue")


