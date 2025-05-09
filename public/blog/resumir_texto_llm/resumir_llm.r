# ---
# title: Resumir textos usando modelos de lenguaje (LLM) locales en R
# author: Bastián Olea Herrera
# date: '2025-02-08'
# slug: []
# categories: 
#   - tutoriales
# tags:
#   - análisis de texto
#   - inteligencia artificial
# draft: false
# format: 
#   hugo-md:
#     output-file: "index"
#     output-ext:  "md"
# editor_options: 
#   chunk_output_type: console
# execute: 
#   eval: true
#   freeze: true
# excerpt: "Los modelos de lenguaje (LLM) son herramientas muy útiles para analizar texto, y usarlos en tus análisis de datos con R es sencillo. En este tutorial, te enseño a utilizar modelos de lenguaje locales, instalados en tu propio computador, para obtener resúmenes de textos."
# ---
# 
# Los modelos de lenguaje (LLM) son herramientas muy útiles para analizar texto, y usarlos en tus análisis de datos con R es sencillo. Previamente en este blog ya he explicado cómo usar LLMs para [análisis de sentimiento](/blog/analisis_sentimiento_llm/) y [otros usos](/tags/inteligencia-artificial/). En este tutorial, te enseño a utilizar modelos de lenguaje locales, instalados en tu propio computador, para obtener resúmenes de textos. Esto puede servir por si estás analizando una base de datos de texto que contenga textos de extensión larga, para los cuales sería conveniente tener una versión más breve. Por ejemplo, al analizar resultados de [web scraping](/tags/web-scraping/), conjuntos de [datos periodísticos o de noticias](/blog/2024-12-31/), datos de entrevistas, respuestas abiertas en encuestas, etc.
# 
# Primero, obtendremos un corpus de textos de noticias chilenas publicadas el año 2024, en forma de un dataframe con columnas con el título, cuerpo, fuente y fecha de las noticias. Los datos son obtenidos de [este repositorio de obtención automatizada de textos de noticias de prensa escrita chilena.](https://github.com/bastianolea/prensa_chile)
# 
# ```{r}
# #| message: false
# 
# library(dplyr)
# library(readr)
# library(stringr)
# 
# url_datos <- "https://raw.githubusercontent.com/bastianolea/prensa_chile/refs/heads/main/datos/prensa_datos_muestra.csv"
# 
# noticias <- read_csv2(url_datos)
# ```
# 
# Exploremos rápidamente los datos:
# 
# ```{r}
# set.seed(1234)
# 
# noticias_muestra <- noticias |> 
#   slice_sample(n = 20)
# 
# head(noticias_muestra)
# ```
# 
# Confirmemos cómo llega el texto de las noticias:
# 
# ```{r}
# noticias_muestra |> 
#   slice(1) |> # extraer una fila
#   pull(cuerpo) |> # extraer variable como vector
#   str_trunc(800) |> # recortar textos muy largos
#   str_wrap(70) |> # insertar saltos de línea cada x caracteres
#   cat() # imprimir
# ```
# 
# Revisemos el promedio de palabras de cada noticia:
# ```{r}
# noticias_muestra |> 
#   # calcular cantidad de palabras
#   mutate(palabras = str_split(cuerpo, pattern = " ") |> lengths()) |> 
#   # calcular cantidad de caracteres
#   mutate(caracteres = nchar(cuerpo)) |> 
#   summarize(palabras = mean(palabras),
#             caracteres = mean(caracteres))
# ```
# 
# Cómo podemos ver, cada noticia tiene en promedio cerca de 400 palabras o más de 2000 caracteres. Usaremos un modelo de lenguaje para crear una nueva variable que contenga una versión resumida del texto de las noticias, para agilizar su comprensión.
# 
# Pero primero, tenemos que elegir e instalar un modelo de lenguaje local.
# 
# ## Configuración del modelo de lenguaje local
# 
# Para poder usar modelos LLM localmente con R, [tenemos que instalar Ollama](https://ollama.com/) en nuestro equipo, que es la aplicación que nos permite obtener y usar modelos de lenguaje locales. Ollama tiene que estar abierto para poder proveer del modelo de lenguaje a nuestra sesión de R.
# 
# Luego, ya sea desde Ollama o desde R, tenemos que instalar un modelo de lenguaje. 
# 
# Para instalar un modelo de lenguaje desde R, es tan simple como ejecutar: `ollamar::pull("llama3.2:3b")`, definiendo entre comillas el [modelo que hayamos elegido](https://ollama.com/search) para instalar. Al elegir un modelo, debes considerar las capacidades de tu computador para ejecutar los modelos, y que el tamaño del modelo es directamente proporcional con la calidad de sus respuestas[^1].
# 
# Para instalar un modelo desde ollama, en la línea de comandos o Terminal de tu equipo, ejecuta `ollama pull llama3.2:3b` y el modelo se descargará en tu equipo.
# 
# Una vez que tengas Ollama abierto en tu computador, y un modelo previamente instalado, puedes proceder a usarlo en R en el siguiente paso.
# 
# [^1]: Si tu computador es muy básico (tiene poca memoria RAM), recomiendo instalar Llama 3.2 1B. Si tiene al menos 8GB de memoria, recomiendo Llama 3.2 3B. Si tienes suficiente memoria (más de 8GB), recomiendo Llama 3.1 8B.
# 
# 
# ## Generar resúmenes de texto
# 
# El primer paso para trabajar con modelos de lenguaje extensos con datos tabulares R es cargar el paquete {mall}, y especificar qué modelo queremos usar:
# 
# ```{r}
# library(mall) # paquete para usar LLM en dataframes de R
# 
# llm_use("ollama", "llama3.2:3b") # indicar qué modelo usaremos
# ```
# 
# Posteriormente, podemos utilizar todas las funciones que empiezan con `llm_` para aplicar funciones que utilizan los modelos de lenguaje sobre cada observación de la columna que especifiquemos. En este caso, para producir resúmenes de texto, usamos la función `llm_summarize()`, la cual contiene un _prompt_ diseñado para resumir textos hacia la cantidad de palabras que solicitemos.
# 
# ```{r} 
# # crear columna de resumen de los textos
# noticias_muestra_resumen <- noticias_muestra |> 
#   llm_summarize(cuerpo, # columna con el texto original
#                 max_words = 20, # cantidad de palabras del resumen
#                 pred_name = "resumen", # nombre de la columna resultante
#                 additional_prompt = "en español"
#                 )
# ```
# 
# El proceso puede tardar unos minutos, dado que el modelo tiene que consumir el texto, realizar las relaciones entre todas las palabras, y generar la inferencia que produce el texto de salida. En mi computador, el procesamiento de 20 noticias se demoró un poco menos de 1 minuto, pero este tiempo puede variar en base al equipo que tengas y la cantidad de texto de cada elemento.
# 
# Si los textos son demasiado largos, se puede usar una función como `str_trunc(texto, side = "center", width = 3000)` para truncar textos demasiado largos cortando el texto sobrante desde el medio del texto.
# 
# Exploremos los resultados obtenidos:
# 
# ```{r}
# noticias_muestra_resumen |> 
#   select(resumen) |> 
#   # calcular cantidad de palabras
#   mutate(palabras = str_split(resumen, pattern = " ") |> lengths()) |> 
#   # calcular cantidad de caracteres
#   mutate(caracteres = nchar(resumen)) |> 
#   summarize(palabras_prom = mean(palabras),
#             palabras_min = min(palabras),
#             palabras_max = max(palabras),
#             caracteres_prom = mean(caracteres))
# ```
# 
# ```{r}
# noticias_muestra_resumen |> 
#   slice(1) |> 
#   pull(resumen)
# 
# noticias_muestra_resumen |> 
#   slice(4) |> 
#   pull(resumen)
# 
# noticias_muestra_resumen |> 
#   slice(3) |> 
#   pull(resumen)
# ```
# 
# Podemos ver que los nuevos textos mantienen coherencia con los textos originales, y en promedio consiste de resúmenes de 17 palabras, con un máximo de 21 palabras. Considerando que le pedimos al modelo que el máximo de palabra fueran 20, esto no hace recordar que los modelos de lenguaje no son deterministas, por lo tanto las instrucciones que les demos no reflejarán en un 100% los resultados que esperamos, y los resultados obtenidos nunca serán en un 100% consistentes, siempre habiendo un posible factor de azar y alucinación.
# 
# Si los resúmenes aparecen incorrectos, o salen en inglés, se puede usar el argumento `additional_prompt` de `llm_summarize()` para indicarle al modelo explícitamente que quieres resultados en español, o siguiendo alguna otra instrucción.