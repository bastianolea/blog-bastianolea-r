# mapa población
mapa_comunas_2 |> 
  mutate(poblacion = ifelse(poblacion > 100000, 100000, poblacion)) |>
  st_set_geometry(mapa_comunas_2$geometry) |> # asignar geometría
  ggplot() + # gráfico
  aes(fill = poblacion, color = poblacion) +
  geom_sf() + # capa geométrica
  theme_classic() +
  scale_fill_distiller(type = "seq", palette = 12, 
                       labels = label_comma(big.mark = "."),
                       # limits = c(0, 300000), 
                       values = c(0, 1.4),
                       na.value = "#B6B6D8",
                       aesthetics = c("fill", "color")) + # colores
  scale_x_continuous(breaks = seq(-76, -65, length.out = 3) |> floor()) + # escala x
  coord_sf(xlim = c(-77, -65)) + # recortar coordenadas
  theme_void() +
  theme(legend.position = "none")

# guardar
ggsave(filename = "content/blog/tutorial_mapa_chile/mapa_chile_poblacion.png", 
       width = 8, height = 20)

# mapa superficie
mapa_comunas_2 |> 
  mutate(superficie_km2 = ifelse(superficie_km2 > 20000, 20000, superficie_km2)) |>
  st_set_geometry(mapa_comunas_2$geometry) |>
  ggplot() +
  aes(fill = superficie_km2, color = superficie_km2) + # variable de relleno
  geom_sf() +
  theme_classic() +
  scale_fill_distiller(type = "seq", palette = 11, 
                       values = c(0, 2),
                       labels = label_comma(big.mark = "."),
                       # limits = c(0, 30000), na.value = "#D187C0",
                       aesthetics = c("fill", "color")) + 
  scale_x_continuous(breaks = seq(-76, -65, length.out = 3) |> floor()) +
  coord_sf(xlim = c(-77, -65)) + 
  theme_void() +
  theme(legend.position = "none")


# guardar
ggsave(filename = "content/blog/tutorial_mapa_chile/mapa_chile_superficie.png", 
       width = 8, height = 20)
