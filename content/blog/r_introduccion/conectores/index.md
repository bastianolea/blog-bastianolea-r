---
title: Aprendiendo a usar conectores o _pipes_
author: Bastián Olea Herrera
date: '2025-11-24'
format:
  hugo-md:
    output-file: index
    output-ext: md
weight: 6
draft: false
series: Introducción a R
categories:
  - Tutoriales
tags: []
lang: es
excerpt: >-
  Los conectores o _pipes_ son símbolos que nos permiten encadenar varias
  operaciones. En inglés, _pipe_ significa literalmente 'tubería', porque la
  idea es que los datos fluyan a través de una serie de pasos. En esta guía
  comprenderemos cómo se usan los conectores, y cómo pueden ayudarnos a escribir
  mejores análisis.
execute:
  error: true
  eval: true
---


<script src="conectores_files/libs/bslib-component-js-0.9.0/components.min.js"></script>
<script src="conectores_files/libs/bslib-component-js-0.9.0/web-components.min.js" type="module"></script>
<link href="conectores_files/libs/bslib-component-css-0.9.0/components.css" rel="stylesheet" />
<link href="conectores_files/libs/htmltools-fill-0.5.8.1/fill.css" rel="stylesheet" />
<script src="conectores_files/libs/bslib-tag-require-0.9.0/tag-require.js"></script>


Los conectores o *pipes* son símbolos que nos permiten **encadenar varias operaciones**. En inglés, *pipe* significa literalmente "tubería", porque la idea es que los datos fluyan a través de una serie de pasos.

El uso de conectores **facilita la lectura** del código, porque nos muestra el flujo de las operaciones de forma ordenada y lógica, y también **simplifica la escritura**, porque nos hace escribir en el mismo orden lógico que pensamos las operaciones, y porque además nos permite reordenar, comentar, agregar o eliminar pasos.

En R, el conector nativo es `|>` y a continuación veremos cómo usarlo!

## Definición

Un conector **conecta dos pasos del procesamiento de datos**, ya sea conectando los datos a una acción, o el resultado de una acción con una nueva acción. Así que la lectura de un conector (`|>`) sería algo así como *"luego"* o *"entonces"*.

Pensemos en una idea de procesamiento:

> Para obtener `resultado`, empiezo con mis `datos`, y *luego* `|>` les aplico una `acción()`, y *luego* `|>` les hago `otra_acción()`

Traduzcámosla a código:

``` r
resultado <- datos |> 
    acción() |> 
    otra_acción()
```

En otras palabras, se empieza con los `datos`, los datos se modifican una vez en el primer paso, y en el segundo paso se modifica el resultado del paso anterior. Es una cadena de operaciones con un inicio (`datos`) y un final (`resultado`).

Recordemos que, en R, el resultado (la *[asignación](../../../../blog/r_introduccion/r_basico/#asignaciones)*) se pone al principio, porque es una forma de decir *vamos a hacer esto de la siguiente manera*, una especie de *título* de la operación.

## Escritura del conector

El conector se escribe como `|>`, es decir, una barra vertical `|` seguida de un símbolo *mayor que* `>`.

Pero recomiendo aprender el **atajo de teclado** para insertarlo, ya que va a ser una operación de uso muy frecuente:

{{< imagen "atajo_mac.png" >}}
{{< bajada "Atajo de teclado para insertar el conector `|>` en Mac" >}}

<br>

{{< imagen "atajo_windows.png" >}}
{{< bajada "Atajo de teclado para insertar el conector `|>` en Linux y Windows" >}}

## Tipos de conectores

Si intentaste el paso anterior, puede que te haya salido un símbolo distinto 😱

En R existen dos conectores: el `|>` (*pipe* nativo de R) y el `%>%` (*pipe* del paquete `{magrittr}`). Ambos hacen prácticamente lo mismo.

<div style="text-align: center;">
<bslib-layout-columns class="bslib-grid grid bslib-mb-spacing html-fill-item" data-require-bs-caller="layout_columns()" data-require-bs-version="5">
<div class="bslib-grid-item bslib-gap-spacing html-fill-container">
<div style="font-size: 400%; color: #9069C0; font-weight: bold;&#10;           font-family: Menlo, Consolas, Courier, monospace, monaco;">
<p>|&gt;</p>
</div>
</div>
<div class="bslib-grid-item bslib-gap-spacing html-fill-container">
<div style="font-size: 400%; color: #9069C0; font-weight: bold;&#10;           font-family: Menlo, Consolas, Courier, monospace, monaco;">
<p>%&gt;%</p>
</div>
</div>
</bslib-layout-columns>
</div>

El conector que aparezca va a depender de tu configuración de RStudio: en el menú *Tools*, entra a *Global options*, y en el menú *Code* elige si quieres o no usar el conector nativo de R (recomendado).

------------------------------------------------------------------------

## Ejemplos

Veamos unos ejemplos de uso del conector en R, y cuándo resulta conveniente de usar:

Empecemos con un vector de números:

``` r
datos <- c(4, 6, 3, 7, 8, 6)
```

#### Ejemplo sin conector 👎🏼

Si tenemos un vector de números y queremos calcular su promedio:

``` r
mean(datos)
```

Pero si además queremos redondear el resultado (dos operaciones), tenemos que empezar a **anidar** las funciones:

``` r
round(mean(datos), digits = 2)
```

Este código se leería, de izquierda a derecha, como *redondear el promedio de datos*, lo cual no está mal, pero te obliga a entender la operación *desde adentro hacia afuera* (los datos o el inicio del proceso están al medio del código). Además, anidar las funciones empieza a hacer que el código sea cada vez menos legible. Imagínate si en vez de 2 funciones necesitas 4 o 5? 🫤

#### Ejemplo con conector 👍🏼

Para hacer lo mismo pero usando conectores, encadenamos las operaciones empezando con los datos, en el orden de su ejecución:

``` r
datos |> 
  mean() |> 
  round(digits = 2)
```

La lectura sería: *a los datos les calculo el promedio y luego al resultado lo redondeo.* La operación ahora es **más legible** (vemos que hay claramente 3 pasos) y sigue un orden **secuencial** (se leen en el orden que se aplican).

------------------------------------------------------------------------

Creemos una pequeña tabla de datos para el siguiente ejemplo:

``` r
# crear tabla de datos de ejemplo con tribble
library(dplyr)

datos <- tibble(animal = c("gato", "ratón", "perro", "pez", "paloma"),
                color = c("gris", "negro", "blanco", "azul", "gris"),
                patas = c(4, 4, 4, 0, 2),
                edad = c(8, 2, 10, 1, 3))
```

{{< bajada "Copia y pega el código para ejecutarlo en tu sesión de R" >}}

| animal | color  | patas | edad |
|:-------|:-------|------:|-----:|
| gato   | gris   |     4 |    8 |
| ratón  | negro  |     4 |    2 |
| perro  | blanco |     4 |   10 |
| pez    | azul   |     0 |    1 |
| paloma | gris   |     2 |    3 |

#### Ejemplo sin conector 👎🏼

Imagina que a estos datos queremos hacerle varias operaciones:

1.  Seleccionar algunas columnas,
2.  filtrar algunas filas, y
3.  ordenar los resultados

Vamos agregando las funciones en orden: primero la selección...

``` r
select(datos, animal, patas, edad) # 🙂
```

Ahora el filtro, pero adentro hay que ponerle los datos seleccionados...

``` r
filter(select(datos, animal, patas, edad), patas >= 4) # 🤨
```

Si queremos ordenarlos tenemos que poner todo adentro de otra función...

``` r
arrange(filter(select(datos, animal, patas, edad), patas >= 4), edad) # 😵‍💫
```

Terminamos con esta aberración de paréntesis y funciones que se leen algo así como *ordeno el filtro de la selección de los datos* 😣 y al final van apareciendo los argumentos de cada función. Imposible de leer! 😭

Una forma de solucionarlo es ir asignando cada paso a un objeto...

``` r
datos_2 <- select(datos, animal, patas, edad)
datos_3 <- filter(datos_2, patas >= 4)
datos_4 <- arrange(datos_3, edad)
```

...pero esto hace que tengamos que crear muchos objetos intermedios, que no nos interesan! Además se lee muy mal porque te interrumpe la constante creación de objetos.

#### Ejemplo con conector 👍🏼

Para hacer lo mismo pero usando los conectores, empezamos con los datos y vamos agregando los pasos del procesamiento: primero la selección, luego el filtro, y finalmente el ordenamiento:

``` r
datos |> 
  select(animal, patas, edad) |> 
  filter(patas >= 4) |> 
  arrange(edad)
```

El proceso queda **más ordenado**, se lee en orden (de arriba hacia abajo), no necesitamos crear objetos intermedios, y no hay ningún caos de paréntesis para desenredar! Mucho mejor 😊

Además, se hace mucho más fácil reordenar los pasos o agregar pasos intermedios, o bien poder poner comentarios entre medio, para ir apoyándonos en la lectura y el aprendizaje:

``` r
datos |> 
  # seleccionar sólo columnas útiles
  select(animal, patas, edad) |> 
  # filtrar animales con 4 o más patitas
  filter(patas >= 4) |> 
  # ordenarlos empeazndo por el más bebé
  arrange(edad)
```

Solamente hay que acostumbrarse a fijarnos bien que los conectores *conecten* con algo: no dejar conectores apuntando a nada, porque hacen que R piense que el código conecta con lo que sea que tenga abajo, o peor, que R quede esperando que lo conectes con algo![^1]

[^1]: en cuyo caso hay que tirarle cualquier cosa a la consola para que retorne error y podamos seguir con nuestras vidas
