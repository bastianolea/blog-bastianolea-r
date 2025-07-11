---
title: 'Limpiar textos con símbolos, tildes o eñes en R'
author: Bastián Olea Herrera
date: '2025-03-31'
slug: []
categories: []
tags:
  - consejos
  - texto
  - limpieza de datos
excerpt: >-
  Amamos el castellano, con sus tildes y eñes, y nos encanta que R no tenga
  problemas para usar estos símbolos en cualquier parte del lenguaje. Pero hay
  veces en las que necesitamos deshacernos de estos símbolos especiales, como
  tildes, eñes, e incluso mayúsculas. En este post te muestro varias opciones de
  limpieza de texto con R.
---


Amamos el castellano, con sus tildes y eñes, y nos encanta que R no tenga problemas para usar estos símbolos en cualquier parte del lenguaje. Pero hay veces en las que necesitamos deshacernos de estos símbolos especiales, como tildes, eñes, e incluso mayúsculas.

Por ejemplo:
- Si queremos dar nombres a carpetas (porque puede dar conflictos con otros sistemas operativos o para subir archivos a internet),
- Si queremos buscar coincidencias de texto con `stringr::str_detect()` y queremos aumentar probabilidades de coincidir al omitir variaciones de los caracteres,
- Si queremos hacer un `left_join()` entre dos bases de datos con formas distintas de guardar los datos (todos en mayúscula, todos sin tilde pero con eñes, etc.)

Hay muchas formas distintas de hacerlo, dependiendo de lo que necesitemos. El paquete `{stringr}` se enfoca en el procesamiento de texto y tiene varias funciones que nos pueden ayudar.

``` r
library(stringr)

texto_esp <- "TÉxtó con PequÉññños cáráctérés roñosos"
```

## Eliminar caracteres específicos

Podemos usar `str_remove_all()` para eliminar todos los caracteres problemáticos, separándolos con el operador *o* (`|`):

``` r
str_remove_all(texto_esp, "ñ|á|é|í|ó|ú")
```

    [1] "TÉxt con PequÉos crctrs roosos"

Pero vemos que no funciona con caracteres en mayúscula. Así que convertimos todo el texto a minúsculas primero:

``` r
str_remove_all(tolower(texto_esp), "ñ|á|é|í|ó|ú")
```

    [1] "txt con pequos crctrs roosos"

Sigue sin ser una buena opción, porque se pierden demasiados caracteres.

## Reemplazar caracteres específicos

Una mejor opción sería reemplazar los caracteres problemáticos por otros. Por ejemplo, reemplazar letras con tilde por sus versiones sin tilde. Para eso podemos usar `str_replace_all()`, que permite recibir un vector con las letras que queremos encontrar y un signo `=` con la letra que reemplazamos en casa caso:

``` r
str_replace_all(tolower(texto_esp), c("ñ"="n", "á"="a", "é"="e", "í"="i", "ó"="o", "ú"="u"))
```

    [1] "texto con pequennnos caracteres ronosos"

Una forma más larga pero más flexible de hacer esta limpieza sería incluir reemplazos para caracteres tanto en mayúscula como minúscula, así mantenemos la capitalización de los caracteres pero reemplazamos las versiones problemáticas por las versiones seguras:

``` r
str_replace_all(texto_esp, c("Ñ"="ñ", "Á"="A", "É"="E", "Í"="I", "Ó"="O", "Ú"="U",
                             "ñ"="ñ", "á"="a", "é"="e", "í"="i", "ó"="o", "ú"="u"))
```

    [1] "TExto con PequEññños caracteres roñosos"

La gracia de este método es que tú tienes todo el control sobre los reemplazos. En este caso, reemplazamos caracteres con tilde por versiones sin tilde, pero mantenemos las eñes.

## Transliterar

El paquete para procesamiento de texto `{stringi}` (no confundir con `{stringr}`) cuenta con la función `stri_trans_general()`, que procesa texto para convertirlo o transliterarlo a otros sistemas de escritura. Para lo que necesitamos, podemos pedirle que translitere nuestro texto a ASCII (estándar de texto plano, *American Standard Code for Information Interchange*):

``` r
stringi::stri_trans_general(texto_esp, "Latin-ASCII")  # transliterar, pero remueve eñes
```

    [1] "TExto con PequEnnnos caracteres ronosos"

Esta forma es más breve, pero menos flexible. Vemos, por ejemplo, que reemplaza las eñes, sin darnos mucha flexibilidad.

Otra opción podría ser la siguiente, que transforma los símbolos especiales por versiones de varios caracteres:

``` r
iconv(texto_esp, to = "ASCII//translit") # elimina tildes pero los reaplica como símbolos individuales
```

    [1] "T'Ext'o con Pequ'E~n~n~nos c'ar'act'er'es ro~nosos"

El resultado es extraño, pero puede ser que en ciertos casos nos sirva.

## Eliminar símbolos

El paquete `{textclean}` contiene varias funciones avanzadas para limpieza de texto. Una de ellas es `strip()`, que elimina todos los símbolos, pero preservando tildes.

``` r
texto_num <- "Hoy!!! Súper ricas **empanadas** a $1.000 pesos... Ñam ñam"
```

``` r
textclean::strip(texto_num)
```

    [1] "hoy súper ricas empanadas a pesos ñam ñam"

El resultado es solamente texto, con tildes y con eñes, pero sin símbolos ni números. Esta función sí posee ciertas opciones para ajustar la limpieza; por ejemplo, no remover números, y dejar sólo símbolos específicos:

``` r
textclean::strip(texto_num, digit.remove = FALSE, char.keep = c("!"))
```

    [1] "hoy!!! súper ricas empanadas a 1000 pesos ñam ñam"
