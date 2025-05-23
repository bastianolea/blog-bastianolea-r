---
title: Redactar una lista de palabras separadas por comas en R
author: Bastián Olea Herrera
date: '2025-03-30'
slug: []
categories: []
tags:
  - consejos
  - texto
excerpt: >-
  Aprende a generar un texto que redacte un vector de palabras sueltas en una
  oración separada por comas y con el separador _y_ al final; por ejemplo: ’uno,
  dos y tres’. Útil para escribir programáticamente títulos, subtítulos y textos
  para reportes.
---


Cuando obtenemos una lista de palabras que obtuvimos desde nuestros datos, y
queremos incluirlas en algún reporte ---ya sea como el título de un gráfico, el
subtítulo de un capítulo, o un texto dinámico basado en los datos--- vamos a
querer que estén redactadas correctamente: separadas por comas. La función
`paste()` sirve para unir distintos objetos de tipo texto.

``` r
paste("primera", "segunda")
```

    [1] "primera segunda"

Si queremos unir las dos palabras, podemos especificar un separador:

``` r
paste("primera", "segunda", sep = ", ") # unir palabras, separadas por comas
```

    [1] "primera, segunda"

Pero si las palabras las estamos extrayendo desde los datos, lo más probable es
que vengan dentro de un vector de texto, como el siguiente:

``` r
palabras <- c("verde", "azul", "morado", "fuscia")
```

Entonces, la unión entre los elementos de un vector se realiza con el argumento
`collapse` de `paste()`:

``` r
paste(palabras, collapse = ", ")
```

    [1] "verde, azul, morado, fuscia"

Con esto obtenemos un vector de texto de largo 1, que contiene los elementos del
vector anterior, pero unidos, separados por una coma. Pero podemos mejorar este
resultado si escribimos un poco más de código para que la redacción de los
elementos sea más apropiada: separando el último elemento por la palabra *y*.
Primero obtendremos el largo del vector de palabras `length()`. Luego usaremos
este largo para seleccionar las palabras desde la primera a la penúltima.

``` r
largo <- length(palabras)
palabras_a <- palabras[1:largo-1]
print(palabras_a) # todas las palabras menos la última
```

    [1] "verde"  "azul"   "morado"

Volvemos a usar el largo para extraer solamente la última palabra:

``` r
palabras_b <- palabras[largo]
print(palabras_b) # la última palabra
```

    [1] "fuscia"

Unimos el vector de las primeras palabras, separándolas con comas:

``` r
# unir las primeras palabras separadas por comas
palabras_a2 <- paste(palabras_a, collapse = ", ")
```

Ahora que tenemos dos objetos, uno con las primeras palabras separadas por
comas, y otro con la última palabra, unimos ambos objetos, separándolos con la
palabra *y*:

``` r
# agregar la última palabra separada por "y"
palabras_redactadas <- paste(palabras_a2, palabras_b, sep = " y ")
print(palabras_redactadas)
```

    [1] "verde, azul, morado y fuscia"

Cómo resultado, obtenemos un código que genera la redacción de cualquier cantidad de palabras que vengan en un vector de texto. Podemos formalizar este invento creando una función que simplifique esta tarea:

``` r
redactar_palabras <- function(palabras) {
  largo <- length(palabras)
  palabras_a <- palabras[1:largo-1] # primeras palabras
  palabras_b <- palabras[largo] #última palabra
  
  # unir las primeras palabras separadas por comas
  palabras_a2 <- paste(palabras_a, collapse = ", ")
  
  # agregar la última palabra separada por "y"
  palabras_redactadas <- paste(palabras_a2, palabras_b, sep = " y ")
  
  # retornar palabras redactadas
  return(palabras_redactadas)
}
```

Gracias a esta función, ahora podemos lograr la redacción de las palabras de forma mucho más fácil y clara:

``` r
redactar_palabras(palabras)
```

    [1] "verde, azul, morado y fuscia"

------------------------------------------------------------------------

Dicho lo anterior, y gracias a lo extenso que es el ecosistema de R, quizás resulta más rápido usar una función que hace exactamente lo mismo y que viene en `{glue}`, un paquete del *Tidyverse*:

``` r
library(glue)
glue::glue_collapse(palabras, 
                    sep = ", ", 
                    last = " y ")
```

    verde, azul, morado y fuscia

A veces nos podemos reinventar la rueda cuando ya existen soluciones 😣 Pero esto no es tiempo perdido si es que nos permite aprender cosas nuevas y/o poner en práctica nuestras habilidades 🥰
