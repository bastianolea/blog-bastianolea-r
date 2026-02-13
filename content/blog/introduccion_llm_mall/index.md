---
title: Usar un modelo de lenguaje local (LLM) para analizar texto en R
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
freeze: true
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
ollamar::pull("llama3.2:3b")
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

``` r
mall::llm_use("ollama", "llama3.2:3b")
```

    ── mall session object 

    Backend: ollama
    LLM session: model:llama3.2:3b
    R session:
    cache_folder:/var/folders/gt/vdp_nx_x3bq5wgnlr1nphkd1zbdps_/T//RtmpzqBMog/_mall_cachee7f20d2b28

Con el siguiente código vamos a descargar un dataframe que contiene texto de noticias de Chile, para usarlo como datos de prueba. Los datos provienen de mi [repositorio de web scraping y análisis de prensa de Chile.](https://github.com/bastianolea?tab=repositories)

``` r
# obtener datos de prensa
url <- "https://raw.githubusercontent.com/bastianolea/prensa_chile/refs/heads/main/prensa_datos_muestra.csv"

datos_prensa <- readr::read_csv2(url, show_col_types = FALSE)
```

    ℹ Using "','" as decimal and "'.'" as grouping mark. Use `read_delim()` for more control.

``` r
head(datos_prensa)
```

    # A tibble: 6 × 4
      titulo                                                cuerpo fuente fecha     
      <chr>                                                 <chr>  <chr>  <date>    
    1 Hombre de 66 años fue asesinado en plena vía pública… "El h… Coope… 2024-07-21
    2 Revive el cuarto capítulo de Indecisos: Candidatos a… "Este… Megan… 2024-09-03
    3 Menos personas circulando y miedo de los residentes:… "Poca… Megan… 2024-04-08
    4 CEO de Walmart Chile sostiene que si la empresa no d… "Hace… The C… 2024-12-22
    5 Pdte. Boric entregó mensaje por la muerte de Piñera … "El p… CNN C… 2024-02-06
    6 Encuentran dos cadáveres en un canal de regadío en P… "Pers… Publi… 2024-07-13

Probemos `{mall}` con 10 noticias al azar, pidiéndole al LLM que detecte el sentimiento de cada texto (si es positivo, neutro o negativo):

``` r
# extraer sentimiento de textos
datos_sentimiento <- datos_prensa |> 
  select(titulo) |> 
  slice(10:20) |> 
  llm_sentiment(titulo, 
                pred_name = "sentimiento",
                options = c("positivo", "neutro", "negativo"))

datos_sentimiento |> 
  relocate(sentimiento, .before = titulo)
```

    # A tibble: 11 × 2
       sentimiento titulo                                                           
       <chr>       <chr>                                                            
     1 negativo    "Dos personas resultan baleadas tras intentar evitar asalto en m…
     2 negativo    "Mujer de 54 años recibió trasplante de bomba cardíaca y riñón d…
     3 negativo    "Fiscalía investiga una segunda presunta agresión de Monsalve co…
     4 negativo    "Los RUT definitivos que reciben el premio de La Suerte en Chile…
     5 negativo    "Este domingo parte el Festival de Viña 2024: Revisa el orden y …
     6 negativo    "Danesa se coronó como Miss Universo 2024: Emilia Dides quedó en…
     7 positivo    "Hassler opta por tesis de Boric por sobre la del PC en Venezuel…
     8 negativo    "Carabinero de civil disparó a delincuente que estaba robando en…
     9 negativo    "Seguridad en días del 18’: Ex PDI llama a ser precavido y a evi…
    10 positivo    "¿Quién es Janet Yellen? La Secretaria del Tesoro de EEEUU que v…
    11 negativo    "Fijan audiencia para los detenidos por el homicidio del subofic…

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
       resumen                                     titulo                           
       <chr>                                       <chr>                            
     1 Lo siento, no tengo información disponible. Sernageomin decreta Alerta Amari…
     2 Lo siento, no tengo información disponible. Caos y golpes durante llegada de…
     3 Lo siento, no tengo información disponible. Delegada Martínez y evacuaciones…
     4 Lo siento, no tengo información disponible. Incendio en Copenhague destruye …
     5 Lo siento, no tengo información disponible. VIDEO| “No entienden que…”: Jorg…
     6 Lo siento, no tengo información disponible. Alza en los planes podría genera…
     7 Lo siento, no tengo información disponible. Exmilitar venezolano presuntamen…
     8 Lo siento, no tengo información disponible. ¿Hay que adelantar o retrasar el…
     9 Lo siento, no tengo información disponible. Familia Imschenetzky compra part…
    10 Lo siento, no tengo información disponible. Feria de vinos llega a Providenc…
