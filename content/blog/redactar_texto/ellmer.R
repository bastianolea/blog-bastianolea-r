
library(dplyr)
library(janitor)
library(readxl)
library(tidyr)
library(here)


# cargar
genero <- read_xlsx(here("content/blog/2026-02-12", "P5_Genero.xlsx"), sheet = 2)

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



library(ellmer)

chat <- chat_github("llama3.2:1b",
                    system_prompt = "Eres un redactor de perfiles profesionales, breve y preciso")

chat$chat("hola")



library(ellmer)
library(dplyr)

datos <- tibble(
  nombre = c("Ana García", "Pedro López", "María Torres"),
  edad = c(28, 45, 33),
  profesion = c("Ingeniera de datos", "Médico", "Diseñadora UX"),
  ciudad = c("Santiago", "Buenos Aires", "Ciudad de México")
)

# Crear prompts para cada fila
prompts <- purrr::pmap_chr(datos, function(nombre, edad, profesion, ciudad) {
  interpolate(
    "Genera una descripción de perfil profesional para esta persona: Nombre: {{nombre}},Edad: {{edad}}, Profesión: {{profesion}}, Ciudad: {{ciudad}}"
  )
})

# Definir el tipo de salida estructurada
tipo_perfil <- type_object(
  descripcion = type_string("Descripción del perfil profesional en 1 oración"),
  tono = type_enum(
    c("formal", "preciso"),
    "El tono predominante de la descripción"
  )
)

chat <- chat_ollama(model = "llama3.2:1b",
                    system_prompt = "Eres un redactor de perfiles profesionales para LinkedIn."
)

# Obtener resultados estructurados (devuelve un tibble)
# resultados <- parallel_chat_structured(chat, as.list(prompts), type = tipo_perfil)

# tibble(resultados)

# chat$chat("hola")
library(purrr)
resultados <- map(prompts, ~chat$chat(.x))

# Combinar con los datos originales
datos_final <- bind_cols(datos, resultados)
datos_final

library(mall)
mall::llm_use(chat)

resultados <- datos |> 
  llm_custom(col = c(nombre, edad, profesion, ciudad),
             prompt = "Genera una descripción de perfil profesional breve",
             pred_name = "descripcion_perfil")

resultados <- datos |> 
  llm_custom(col = paste(nombre, edad, profesion, ciudad),
             prompt = "Genera una descripción de perfil profesional breve")
         
resultados |> pull(.pred)


chat <- chat_ollama(model = "llama3.2:1b",
                    system_prompt = "Eres un redactor de perfiles profesionales, breve y preciso")

# Crear prompts para cada fila
prompts <- pmap(datos, function(nombre, edad, profesion, ciudad) {
  glue::glue("Redacta un perfil profesional de esta persona, en solo una frase: Profesión: {profesion}, Ciudad: {ciudad}"
  )
})

prompts

resultados <- map(prompts,
    ~chat$chat(.x)
)



genero_regiones <- genero |> 
  select(region, genero, porcentaje, poblacion) |> 
  pivot_wider(names_from = genero, values_from = c(porcentaje, poblacion),
              names_sep = "_")

columnas <- names(genero_regiones)

columnas <- paste0(columnas, " ", "{{", columnas, "}}")

columnas <- paste(columnas, collapse = ", ")

columnas

# Definir el tipo de salida estructurada
tipo_perfil <- type_object(
  descripcion = type_string("Descripción del perfil profesional en 1 oración"),
  tono = type_enum(
    c("formal", "preciso"),
    "El tono predominante de la descripción"
  )
)

prompts <- genero_regiones |> 
  mutate(prompt = glue("region {region}, porcentaje_Masculino {porcentaje_Masculino}, porcentaje_Femenino {porcentaje_Femenino}, porcentaje_Transmasculino {porcentaje_Transmasculino}, porcentaje_Transfemenino {porcentaje_Transfemenino}, porcentaje_No binario {`porcentaje_No binario`}")) |> 
  pull(prompt) |> 
  list()

prompts  

resultados <- prompts |> 
  map(~chat$chat(.x))

resultados <- parallel_chat_text(chat, prompts)
