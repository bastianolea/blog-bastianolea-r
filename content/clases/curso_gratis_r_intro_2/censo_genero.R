library(dplyr)
library(janitor)
library(readxl)
library(tidyr)

# cargar
genero <- read_xlsx("P5_Genero.xlsx",
                    sheet = 2)

# limpiar
genero_limpio <- genero |> 
  row_to_names(3) |> 
  filter(!is.na(Región))

# transformar a largo
genero_long <- genero_limpio |> 
  pivot_longer(cols = 4:last_col(),
               names_to = "genero",
               values_to = "poblacion") |> 
  rename(total = 3)

# convertir variables y calcular porcentajes
genero_porcentaje <- genero_long |> 
  mutate(poblacion = as.numeric(poblacion),
         total = as.numeric(total)) |>
  clean_names() |>
  mutate(porcentaje = poblacion / total)

# filtrar
genero <- genero_porcentaje |> 
  filter(region != "País")
