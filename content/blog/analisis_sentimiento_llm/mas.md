---
title: Untitled
format: html
execute:
  eval: false
---


Otra alternativa al momento de obtener este tipo de resultados es aplicarlos a un texto más corto, como podría ser el título de la noticia, o bien un resumen de la misma.

En el siguiente ejemplo, antes de obtener el sentimiento de los textos, primero limitaremos el largo máximo de los textos, para que no sean extremadamente largos, luego usaremos el modelo de lenguaje para obtener un resumen de cada uno de los textos, y finalmente obtendremos el sentimiento a partir de estos resúmenes creados por el modelo de lenguaje.

``` r
tictoc::tic()
noticias_muestra_resumen <- noticias_muestra |> 
  # reducir largo máximo del texto
  mutate(cuerpo = cuerpo |> str_trunc(2000, side = "center")) |> 
  # generar resumen
  llm_summarize(cuerpo,
                max_words = 40, pred_name = "resumen", 
                additional_prompt = "Redacta el resumen de la idea principal de la noticia en español, en un solo párrafo.")
tictoc::toc()

tictoc::tic()
noticias_resumen_sentimiento <- noticias_muestra_resumen |> 
  llm_sentiment(resumen, 
                pred_name = "sentimiento",
                options = c("positivo", "neutro", "negativo"))
tictoc::toc()
beep()
```

2 minutos en resumir
13 segundos en sentimiento

Uno de los beneficios de esta aproximación es que, además de poder calcular el sentimiento en menor tiempo, también obtenemos la variable de resumen de las noticias, que puede tener distintas utilidades por sí sola.

diferencias

``` r
noticias_sentimiento |> 
  bind_cols(sentimiento_resumen = noticias_resumen_sentimiento$sentimiento) |> 
  mutate(diferencia = sentimiento != sentimiento_resumen) |> 
  select(titulo, sentimiento, sentimiento_resumen, diferencia) |> 
  filter(diferencia)
```
