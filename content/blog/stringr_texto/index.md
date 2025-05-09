---
title: 'Recodificación de datos categóricos con {stringr}'
author: Bastián Olea Herrera
date: '2024-12-23'
draft: true
format:
  hugo-md:
    output-file: index
output-ext: md
slug: []
categories:
  - tutoriales
tags:
  - limpieza de datos
  - dplyr
  - stringr
  - procesamiento de datos
  - datos
execute:
  eval: false
---


``` r
library(dplyr)
library(readxl)
library(stringr) # para trabajar con textos
```

cargar datos

``` r
datos <- read_excel("MATERIAS_R.xlsx") |> 
  rename(materia = 1, 
         submateria = 2)
```

conteo exploratorio de la columna

``` r
datos |> 
  count(materia, sort = TRUE)
```

crear una columna

``` r
datos |> 
  count(materia, sort = TRUE) |> 
  mutate(id = 1)
```

detectar si en un texto está presente otro texto

``` r
str_detect("un texto acá muy feo", "feo") # sí (TRUE)

str_detect("un texto acá muy bonito", "feo") #no (FALSE)
```

nueva columna detectando si está presente un texto en una columna

``` r
datos |> 
  count(materia, sort = TRUE) |> 
  mutate(ley_19886 = str_detect(materia, "19.886"))
```

lo mismo, pero con ifelse, para explicitar la condición verdadera y la falsa

``` r
datos |> 
  count(materia, sort = TRUE) |> 
  mutate(ley_19886 = ifelse(str_detect(materia, "19.886"), 
                            yes = "Ley 19.886",
                            no = "Otros"))
```

crear columna con coincidencia múltiple

``` r
datos |> 
  count(materia, sort = TRUE) |> 
  mutate(tipo = case_when(str_detect(materia, "licitación privada") ~ "Licitación Privada",
                          str_detect(materia, "licitación pública") ~ "Licitación Pública",
                          str_detect(materia, "trato directo") ~ "Trato directo")) |> 
  count(tipo) # contar cuántas observaciones coinciden
```

crear columna con coincidencia múltiple, pero primero pasando a minúscula la columna materia

``` r
datos |> 
  count(materia, sort = TRUE) |> 
  mutate(tipo = case_when(str_detect(str_to_lower(materia), "licitación privada") ~ "Licitación Privada",
                          str_detect(str_to_lower(materia), "licitación pública") ~ "Licitación Pública",
                          str_detect(str_to_lower(materia), "trato directo") ~ "Trato directo")) |> 
  count(tipo) # contar cuántas observaciones coinciden
```

escribir distintas formas de coincidir cada texto a una misma categoría
(por ejemplo, los tildes o plurales)

``` r
datos |> 
  count(materia, sort = TRUE) |> 
  mutate(tipo = case_when(str_detect(str_to_lower(materia), "licitación privada") ~ "Licitación Privada",
                          str_detect(str_to_lower(materia), "licitacion privada") ~ "Licitación Privada",
                          str_detect(str_to_lower(materia), "licitación pública") ~ "Licitación Pública",
                          str_detect(str_to_lower(materia), "licitacion pública") ~ "Licitación Pública",
                          str_detect(str_to_lower(materia), "licitaciones publicas") ~ "Licitación Pública",
                          str_detect(str_to_lower(materia), "trato directo") ~ "Trato directo"))
```

usar regex para coincidir en una misma regla palabras con leves diferencias

``` r
str_detect(c("hola", "holo", "holi"), "hol(a|i)")
datos |> 
  count(materia, sort = TRUE) |> 
  mutate(tipo = case_when(str_detect(str_to_lower(materia), "licitaci(ó|o)n privada") ~ "Licitación Privada",
                          str_detect(str_to_lower(materia), "licitaci(ó|o)n p(ú|u)blica") ~ "Licitación Pública",
                          str_detect(str_to_lower(materia), "licitaciones p(ú|u)blicas") ~ "Licitación Pública",
                          str_detect(str_to_lower(materia), "trato directo") ~ "Trato directo")) |> 
  count(tipo)
```

usar el operador punto de regex para coincidir con cualquier letra en la posición del punto
(por ejemplo, "." equivaldría a "a" o "á" o "o")

``` r
str_detect(c("hola", "holo", "holi"), "hol.")
datos |> 
  count(materia, sort = TRUE) |> 
  mutate(tipo = case_when(str_detect(str_to_lower(materia), "licitaci.n privada") ~ "Licitación Privada",
                          str_detect(str_to_lower(materia), "licitaci.n p.blica") ~ "Licitación Pública",
                          str_detect(str_to_lower(materia), "licitaciones p.blicas") ~ "Licitación Pública",
                          str_detect(str_to_lower(materia), "trato directo") ~ "Trato directo")) |> 
  count(tipo)
```

usar el operador ".*" de regex para indicar cualquier cantidad de caracteres entre el texto inicial y el final
(por ejemplo "ho.*la" coincide "hola" y "hooooooola" o "ho8787897la" o "hola hola")

``` r
str_detect(c("hola", "hooooooola", "ho8787897la", "hola hola"), "ho.*la")
datos |> 
  count(materia, sort = TRUE) |> 
  mutate(tipo = case_when(str_detect(str_to_lower(materia), "lic.*privada") ~ "Licitación Privada",
                          str_detect(str_to_lower(materia), "lic.*p.blica") ~ "Licitación Pública",
                          str_detect(str_to_lower(materia), "trato.*directo|contra.*direct") ~ "Trato directo")
  )
```

buscar casos que aún no tengan coincidencia

``` r
datos |> 
  count(materia, sort = TRUE) |> 
  mutate(tipo = case_when(str_detect(str_to_lower(materia), "lic.*privada") ~ "Licitación Privada",
                          str_detect(str_to_lower(materia), "lic.*p.blica") ~ "Licitación Pública",
                          str_detect(str_to_lower(materia), "trato.*directo|contra.*direct") ~ "Trato directo")
  ) |> 
  filter(is.na(tipo))

datos |> 
  mutate(tipo = case_when(str_detect(str_to_lower(materia), "lic.*privada") ~ "Licitación Privada",
                          str_detect(str_to_lower(materia), "lic.*p.blica") ~ "Licitación Pública",
                          str_detect(str_to_lower(materia), "trato.*directo|contra.*direct") ~ "Trato directo")
  ) |> 
  count(submateria, tipo, sort = TRUE) |> 
  filter(is.na(tipo))
```

crear la columna con coincidencias desde mas de una columna

``` r
datos |> 
  mutate(tipo = case_when(
    # materia
    str_detect(str_to_lower(materia), "lic.*privada") ~ "Licitación Privada",
    str_detect(str_to_lower(materia), "lic.*p.blica") ~ "Licitación Pública",
    str_detect(str_to_lower(materia), "trato.*directo|contra.*direct") ~ "Trato directo",
    # submateria
    str_detect(str_to_lower(submateria), "lic.*privada") ~ "Licitación Privada",
    str_detect(str_to_lower(submateria), "lic.*p.blica") ~ "Licitación Pública",
    str_detect(str_to_lower(submateria), "trato.*directo|contra.*direct") ~ "Trato directo")
  ) |> 
  count(submateria, tipo, sort = TRUE)
```

usar el operador "\$" de regex para buscar algo que solo aparezca al final de la línea

``` r
str_detect("director", "directo$")
str_detect(c("directo trato", "directorio", "director de", "trato directo"), "directo$")
str_detect("directo", "directo$")
str_detect("director de asuntos", "directo$")
```

coincidir usando una condición que tiene que cumplirse y otra que no tenga que cumplirse
así coincidimos por un criterio pero excluimos por otro, simultáneamente

``` r
tibble(tipo = c("contrato de personal",
                "contratación directa",
                "contrato directo")) |> 
  mutate(tipo2 = case_when(str_detect(tipo, "contrat") & !str_detect(tipo, "personal") ~ "Sí",
                           .default = "No"))
```

crear otra columna más, de tipo lógico (TRUE/FALSE)

``` r
datos |> 
  mutate(tipo = case_when(
    # materia
    str_detect(str_to_lower(materia), "lic.*privada") ~ "Licitación Privada",
    str_detect(str_to_lower(materia), "lic.*p.blica") ~ "Licitación Pública",
    str_detect(str_to_lower(materia), "trato.*directo|contra.*direct") ~ "Trato directo",
    # submateria
    str_detect(str_to_lower(submateria), "lic.*privada") ~ "Licitación Privada",
    str_detect(str_to_lower(submateria), "lic.*p.blica") ~ "Licitación Pública",
    str_detect(str_to_lower(submateria), "trato.*directo|contra.*direct") ~ "Trato directo",
    .default = "Otros"
  )
  ) |> 
  mutate(contratacion_publica = case_when(
    str_detect(str_to_lower(materia), "contrata.*p.blic")~ TRUE, .default = FALSE)) |> 
  # filter(tipo == "Licitación Pública" | contratacion_publica)
  filter(contratacion_publica) # si es TRUE/FALSE, al filtrar se subentiende que es TRUE
```

coincidir usando límites de palabras (word boundary)

``` r
tibble(tipo = c("Trato directo",
                "TD",
                "KADSHTDJSDKS",
                "T D")) |> 
  mutate(tipo2 = case_when(str_detect(tolower(tipo), "trato directo") ~ "Sí",
                           str_detect(tipo, "\\b(TD)\\b") ~ "Sí", # boundary
                           str_detect(tipo, "\\bT D\\b") ~ "Sí",
                           .default = "No"))
```

guardar un resultado como objeto

``` r
datos_2 <- datos |> 
  mutate(tipo = case_when(
    # materia
    str_detect(str_to_lower(materia), "lic.*privada") ~ "Licitación Privada",
    str_detect(str_to_lower(materia), "lic.*p.blica") ~ "Licitación Pública",
    str_detect(str_to_lower(materia), "trato.*directo|contra.*direct") ~ "Trato directo",
    # submateria
    str_detect(str_to_lower(submateria), "lic.*privada") ~ "Licitación Privada",
    str_detect(str_to_lower(submateria), "lic.*p.blica") ~ "Licitación Pública",
    str_detect(str_to_lower(submateria), "trato.*directo|contra.*direct") ~ "Trato directo",
    .default = "Otros"
  )
  )

datos_3 <- datos_2 |> 
  mutate(contratacion_publica = case_when(
    str_detect(str_to_lower(materia), "contrata.*p.blic")~ TRUE, .default = FALSE))

datos_3 |> 
  rowwise() |> 
  mutate(concat = sample(399999:322999, 1))
```

Unir textos de forma redactada

``` r
library(glue)

animales <- c("mapache", "gato", "castor")

glue_collapse(animales, sep = ", ", last = " y ")
```

Agregar artículos a etxtos

``` r
nombre_region_de <- nombre_region |>
  case_match("Metropolitana de Santiago" ~ nombre_region,
             c("Biobío", "Maule", "Libertador General Bernardo O'Higgins") ~ paste("del", nombre_region),
             .default = paste("de", nombre_region))
```

Limpiar texto

``` r
library(stringr)

texto_esp <- "Éste texto tendrÁ una Pequeññña Ración de caracteres roñosos"

str_replace_all(texto_esp, c("ñ"="n", "á"="a", "é"="e", "í"="i", "ó"="o", "ú"="u"))

str_replace_all(str_to_lower(texto_esp), c("ñ"="n", "á"="a", "é"="e", "í"="i", "ó"="o", "ú"="u"))

str_replace_all(str_to_upper(texto_esp), c("Ñ"="Ñ", "Á"="A", "É"="E", "Í"="I", "Ó"="O", "Ú"="U"))

str_replace_all(texto_esp, c("Ñ"="ñ", "Á"="A", "É"="E", "Í"="I", "Ó"="O", "Ú"="U",
                             "ñ"="n", "á"="a", "é"="e", "í"="i", "ó"="o", "ú"="u"))

stringi::stri_trans_general(texto_esp, "Latin-ASCII")  # transliterar, pero remueve eñes

iconv(texto_esp, to = "ASCII//translit") #elimina tildes pero los reaplica como símbolos individuales

texto_num <- "hoy!!! tenemos **empanadas**..."

textclean::strip(texto_num) # elimina símbolos pero no tildes ni eñes
```
