---
title: Usar un modelo de lenguaje local (LLM) para analiar texto en R
author: Bastián Olea Herrera
format: hugo-md
date: 2024-10-29T00:00:00.000Z
categories:
  - Análisis de texto
tags:
  - análisis de texto
  - inteligencia artificial
lang: es
cache: false
excerpt: >-
  Procesa datos con IA en R, localmente! El paquete `{mall}` permite aplicar un
  modelo de lenguaje (LLM) local a tus datos, para así crear nuevas columnas a
  partir de prompts, tales como resumir, extraer sentimiento, clasificación, y
  más.
---


[Recientemente se lanzó el paquete `{mall}`,](https://mlverse.github.io/mall/) que facilita el uso de un LLM *(large language model)* o modelo de lenguaje de gran tamaño para analizar texto con IA en un dataframe. Esto significa que, para cualquier dataframe que tengamos, podemos aplicar un modelo de IA a una de sus columnas y recibir sus resultados en una columna nueva.

Para poder hacer ésto, primero necitamos tener un modelo LLM instalado localmente en nuestra computadora. Para eso, [tenemos que instalar Ollama](https://ollama.com), y ejecutar la aplicación. Ollama tiene que estar abierto para poder proveer del modelo a nuestra sesión de R.

Luego, [instalamos el paquete `{ollamar}` en R,](https://hauselin.github.io/ollama-r/), que es una dependencia de `{mall}`. Usamos `{ollamar}` para descargar a nuestro equipo el modelo de lenguaje que usaremos:

``` r
library(ollamar)
ollamar::pull("llama3.2")
```

Con eso hecho, ya puedes usar modelo directamente desde R con `{ollamar}`, o en un dataframe usando `{mall}`.

``` r
library(mall)
library(dplyr)
```


    Attaching package: 'dplyr'

    The following objects are masked from 'package:stats':

        filter, lag

    The following objects are masked from 'package:base':

        intersect, setdiff, setequal, union

Con el siguiente código vamos a descargar un dataframe que contiene texto de noticias de Chile, para usarlo como datos de prueba. Los datos provienen de mi [repositorio de web scraping y análisis de prensa de Chile.](https://github.com/bastianolea?tab=repositories)

``` r
# obtener datos de prensa
url <- "https://raw.githubusercontent.com/bastianolea/prensa_chile/refs/heads/main/datos/prensa_datos_muestra.csv"

datos_prensa <- readr::read_csv2(url, show_col_types = FALSE)
```

    ℹ Using "','" as decimal and "'.'" as grouping mark. Use `read_delim()` for more control.

``` r
head(datos_prensa)
```

    # A tibble: 6 × 3
      titulo                                                       cuerpo fecha     
      <chr>                                                        <chr>  <date>    
    1 Dólar cierra sus operaciones con leve tendencia alcista y n… "Este… 2023-03-10
    2 Caso Convenios: Consejo de Defensa del Estado presenta quer… "El C… 2023-08-11
    3 Nuevo estudio revela que un café con leche tiene prometedor… "De a… 2023-01-30
    4 Contraloría oficia a 53 municipalidades del país por nivele… "La C… 2024-01-24
    5 Realizan funerales de los dos trabajadores fallecidos en el… "Dura… 2024-06-23
    6 Partido Comunista vuelve a la conducción de la FECH: La min… "“Con… 2023-08-30

Probemos `{mall}` con 10 noticias al azar, pidiéndole al LLM que detecte el sentimiento de cada texto (si es positivo, neutro o negativo):

``` r
# extraer sentimiento de textos
datos_sentimiento <- datos_prensa |> 
  select(titulo) |> 
  slice(60:70) |> 
  llm_sentiment(titulo, pred_name = "sentimiento")

datos_sentimiento |> 
  relocate(sentimiento, .before = titulo)
```

    # A tibble: 11 × 2
       sentimiento titulo                                                           
       <chr>       <chr>                                                            
     1 negative    "Ministerio de Desarrollo Social pone fin anticipado a contrato …
     2 positive    "Xi expuso cuál es \"la llave de oro\" para solucionar los probl…
     3 negative    "Multitudinarias protestas en Israel: Exigen dimisión de Netanya…
     4 negative    "Encuesta Cadem: desaprobación del Presidente Boric aumentó dos …
     5 negative    "Desaparición de TENS Rosa Lira: Las contradicciones que acusa e…
     6 negative    "Ministro Grau por cierre de Siderúrgica Huachipato: “Nuestro fo…
     7 negative    "Piñera confirma que no irá a La Moneda para el 11S: “El clima d…
     8 positive    "Subsecretaria defiende migración de isapres a Fonasa: \"Fortale…
     9 negative    "Ministra Orellana tras críticas por no contactar a denunciante …
    10 negative    "Joven fue acusado de grabar niñas en la entrada de un colegio e…
    11 negative    "Confirman que Jorge Valdivia se reunió con generales de Carabin…

Otro uso es pedirle que genere resúmenes de textos. Para ello, usaremos un *prompt* manual, donde le pedimos explícitamente `"resumir en hasta 5 palabras"`. El paquete aplicará dicha solicitud a cada una de las observaciones en la columna indicada, y retornará los resultados en una nueva columna llamada `resumen`:

``` r
# resumir textos
datos_resumidos <- datos_prensa |> 
  select(titulo, cuerpo) |> 
  slice_sample(n = 10) |> 
  mutate(resumen = llm_vec_custom(
    cuerpo, 
    "resumir en hasta 7 palabras")) |> 
  select(resumen, titulo)

datos_resumidos
```

    # A tibble: 10 × 2
       resumen                                                               titulo 
       <chr>                                                                 <chr>  
     1 "Expo Viñas Campesinas en Chépica, 27-28 abril."                      "Expo …
     2 "Inflación baja en Estados Unidos."                                   "La te…
     3 "\"Operación Renta 2024 incluye cobro de impuestos arrendamientos\"." "Opera…
     4 "Normas para vehículos de Uber."                                      "\"Ley…
     5 "Coca Guazzini defiende a Camila Vallejo."                            "Coca …
     6 "Asesinato de dirigente indígena en Ecuador."                         "Conmo…
     7 "Seremi aborda problemas de higiene en restaurante."                  "Inici…
     8 "\"Las empresas de Inteligencia y Consulting piden liquidación.\""    "Grupo…
     9 "Tiroteo en Puente Alto deja muerto y herido."                        "Balac…
    10 "Cuerpos sin vida encontrados en Región Metropolitana."               "Dos c…
