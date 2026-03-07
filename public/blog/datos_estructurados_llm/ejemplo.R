# extracción de datos estructurados a partir de textos
# basado en el workshop [_LLMs in R for Data Analysis_](https://thisisnic.github.io/rainbowrworkshop/code.html) impartido por [Nic Crane](https://niccrane.com) en la fabulosa [conferencia de RainbowR 2026](https://conference.rainbowr.org)

# carga de datos
library(readr)
url = "https://github.com/bastianolea/prensa_chile/raw/main/prensa_datos_muestra_2025.csv"

noticias <- read_csv2(url)


# preparación de datos
library(dplyr)

muestra <- noticias |> 
  slice(20:25)


# definición de variables a extraer
library(ellmer)

tipo_lugar <- type_string("Ubicación principal de la noticia")

tipo_actor <- type_string("Actor, personaje o institución principal de la noticia")

tipo_grupo <- type_enum(description = "Tipo de entidad del actor, personaje o institución principal de la noticia",
                        values = c("institución pública", "político", "empresa", "empresario", "ciudadano", "otros"))

tipo_clasificacion <- type_enum(description = "Clasificación de la noticia según su enfoque temático principal",
                                values = c("social", "económico", "político", "judicial", "delincuencia", "otros"))

tipo_sentimiento <- type_enum(values = c("positivo", "neutro", "negativo"), 
                              description = "Sentimiento general de la noticia según su contenido")


# definición de system prompt
instruccion <- "Eres un clasificador de noticias experto en el acontecer nacional de Chile"


# extracción de datos estructurados a partir de textos
resultado <- parallel_chat_structured(
  chat = chat_anthropic(model = "claude-haiku-4-5",
                        system_prompt = instruccion),
  prompts = as.list(muestra$cuerpo),
  type = type_object(
    lugar = tipo_lugar,
    actor = tipo_actor,
    actor_grupo = tipo_grupo,
    sentimiento = tipo_sentimiento,
    clasificacion = tipo_clasificacion
  )
)


# unir resultados
tabla <- muestra |> 
  # select(titulo, fecha) |> 
  bind_cols(resultado)

tabla