
library(purrr) 
library(furrr)
library(readr)

library(dplyr)

# cargar datos
# https://github.com/bastianolea/prensa_chile
prensa <- read_csv2("https://github.com/bastianolea/prensa_chile/raw/main/datos/prensa_datos_muestra.csv")

# multiplicar cantidad de datos
prensa_b <- rep(list(prensa), 20) |> list_rbind()


términos <- "delincuen(cia|te)|crimen|criminal|inseguridad|deli(to|ctual)|hurto|robo|asalt(o|ante)|narco|homicidio|asesina(to|do)"

tictoc::tic()
prensa_delincuencia <- prensa_b |> 
  mutate(conceptos = str_extract_all(cuerpo, términos)) |> 
  mutate(n_conceptos = lengths(conceptos)) |> 
  filter(n_conceptos > 2)
tictoc::toc() #70 s


plan(multisession, workers = 6)

tictoc::tic()

prensa_delincuencia <- prensa_b |> 
  # crear variable con 8 niveles de igual cantidad de filas 
  # y separar el dataframe en una lista con un dataframe por grupo
  split(1:6) |> 
  # calcular multiprocesador, un grupo por procesador
  future_map(\(parte) {
    parte |> 
      mutate(conceptos = str_extract_all(cuerpo, términos)) |> 
      mutate(n_conceptos = lengths(conceptos)) |> 
      filter(n_conceptos > 2)
  }) |> 
# volver a unir resultados en un solo dataframe
list_rbind()
  
tictoc::toc() #18 s


groups <- split(prensa, cut(prensa, breaks = 3, labels = FALSE))

# Print the result
print(groups)

split(prensa, 1:6)

prensa |> 
  group_split(1:6)
