# web scraping de tablas de Wikipedia con datos de pobreza y desarrollo humano para países de latinoamérica

library(dplyr)
library(rvest)
library(janitor)

# pobreza ----
url_pobreza <- "https://es.wikipedia.org/wiki/Anexo:Países_por_porcentaje_de_pobreza_en_Latinoamérica"

tablas_pobreza <- url_pobreza |> 
  read_html() |> 
  html_table()

pobreza <- tablas_pobreza[[1]] |> 
  row_to_names(1) |> 
  select(1, 2, 3) |> 
  rename(pais = 1, pobreza_bm = 2, pobreza_cepal = 3) |> 
  mutate(across(2:3, ~stringr::str_replace(.x, ",", "."))) |> 
  mutate(across(2:3, as.numeric))

# Banco Mundial (2025): % < US$6,85 día
# CEPAL (2019): % < canasta básica de CEPAL

# desarrollo ----
url_desarrollo <- "https://es.wikipedia.org/wiki/Anexo:Países_de_América_Latina_por_índice_de_desarrollo_humano"

tablas_desarrollo <- url_desarrollo |> 
  read_html() |> 
  html_table()

desarrollo <- tablas_desarrollo[[1]] |> 
  row_to_names(1) |> 
  rename(puesto = 1) |> 
  filter(nchar(puesto) < 4) |> 
  select(pais = 2, 3:6) |> 
  mutate(across(2:5, ~stringr::str_replace(.x, ",", "."))) |> 
  mutate(across(2:5, as.numeric))


indicadores <- tablas_desarrollo[[3]] |> 
  row_to_names(1) |> 
  rename(puesto = 1) |> 
  filter(nchar(puesto) < 4) |> 
  select(pais = 2, esperanza = 3, escolaridad = 4, inb = 6) |> 
  mutate(inb = stringr::str_remove(inb, " ")) |> 
  mutate(across(esperanza:inb, as.numeric))


datos <- pobreza |> 
  # left_join(desarrollo) |> 
  left_join(indicadores) |> 
  na.omit() |> 
  arrange(pobreza_bm) |> 
  select(pais, pobreza = pobreza_bm, esperanza, escolaridad) |> 
  slice(1:10)


# guardar ----
readr::write_rds(datos, "content/blog/r_introduccion/tidyr_pivotar/datos_latam.rds")


pobreza |> 
  datapasta::dpasta()


datos |> 
  datapasta::dpasta()


desarrollo |> 
  slice(1:10) |> 
  datapasta::dpasta()


