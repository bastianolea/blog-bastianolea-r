---
title: Crea tu propio asistente de programación en R con inteligencia artificial usando el paquete {pal}
author: Bastián Olea Herrera
date: '2024-12-10'
draft: false
slug: []
categories: []
tags:
  - consejos
  - inteligencia artificial
execute: 
  eval: false
excerpt: "El paquete {pal} te permite crear asistentes para programar en R, potenciados por modelos de lenguaje (LLM). La utilidad de estos asistentes es que pueden ayudarte a realizar tareas rápidamente a partir de tu código de R, o incluso a partir de un texto que describa lo que quieres hacer. En este post te enseño a crear dos asistentes para tareas que realizo frecuentemente: describir lo que hace un código de R, y traducir una instrucción a código de {dplyr}"
---

El paquete [`{pal}`](https://simonpcouch.github.io/pal/) te permite crear _asistentes_ para programar en R, potenciados por modelos de lenguaje (LLM). La utilidad de estos asistentes es que pueden ayudarte a realizar tareas rápidamente a partir de tu código de R, o incluso a partir de un texto que describa lo que quieres hacer.

En este post te enseño a crear y usar asistentes de `{pal}` para dos tareas que realizo frecuentemente: **describir lo que hace un código de R**, y **traducir una instrucción a código de `{dplyr}`**.

La idea principal es que puedes seleccionar tu código o texto en R, y presionar una combinación de teclas para elegir tu asistente. Dependiendo del tipo de asistente, se agregará código arriba o abajo de lo que seleccionaste, o bien, se va a reemplazar lo que seleccionaste por lo que haga el asistente.


## Instalar un modelo de lenguaje local desde R
Como este paquete depende de el uso de un modelo de lenguaje para funcionar, necesitas tener instalado un modelo de lenguaje en tu equipo, o tener una suscripción a un modelo de lenguaje en la nube. Personalmente prefiero usar un modelo de lenguaje local: [Llama 3.1](https://ollama.com/library/llama3.1) con 8 billones de parámetros. Para instalar un modelo localmente en tu equipo desde R, primero tienes que [instalar Ollama en tu equipo](https://ollama.com), abrir la aplicación, y luego [instalar el paquete de R {ollamar}](https://hauselin.github.io/ollama-r/) para descargar un modelo de lenguaje local desde R.[^1]

[^1]: Si tu computador no es muy poderoso, te recomiendo instalar `llama3.2:1b` (más liviano) o `llama3.2:3b` (un poco mejor), pero si tienes suficiente memoria y tarjeta de video, puedes instalar `llama3.1:8b`.

Si no tienes un modelo instalado, usa este comando para descargar e instalar un modelo desde R:
```r
library(ollamar)
pull("llama3.1:8b")
```
Es necesario tener la aplicación Ollama abierta en tu computadora, dado que ésta aplicación es la que le entrega el modelo de lenguaje a R.


## Crear asistentes de IA locales

Una vez que tengamos nuestro modelo LLM instalado, debemos indicarle a `{pal}` que queremos usarlo. Si tienes una suscripción a un modelo de lenguaje en la nube como Claude o ChatGPT, [puedes configurarlo en este paso.](https://simonpcouch.github.io/pal/articles/pal.html) Como tenemos un modelo local, le indicamos que usaremos Ollama y el nombre de nuestro modelo instalado:

```r
options(
  .pal_fn = "chat_ollama",
  .pal_args = list(model = "llama3.1:8b")
)
```

Ahora viene lo entretenido. Los asistentes tienen un _rol_, una _interfaz_ y un _contenido._ Para crear nuestro asistente, en la función `prompt_new()` tenemos que darle un rol (que sería como el nombre de asistente), y especificar la interfaz; es decir, cómo queremos que intervenga el código que le entreguemos. Esto puede ser agregando su intervención antes del código seleccionado (`prefix`), después del código seleccionado (`suffix`), o reemplazando el código seleccionado por su aporte (`replace`).

```r
library(pal)

prompt_new(role = "nombre_de_asistente",
           interface = "prefix")
```

Cuando ejecutas esta función se creará tu asistente y se abrirá un nuevo archivo `.md`, que contiene las **instrucciones** que usará tu asistente para ayudarte. Éste será el _contenido_ de tu asistente. El archivo contiene unas instrucciones por defecto que puedes modificar, o puedes escribir tus propias instrucciones. Lo importante es que estas instrucciones sean claras, breves, y que ojalá incluyan un ejemplo de qué es lo que esperas como respuesta.

Luego de modificar este archivo, tienes que ejecutar la función `directory_load()` para que `{pal}` actualice tus asistentes. Para volver a editar tu asistente puedes usar la función `prompt_edit("nombre_de_tu_asistente")`, pero luego de editarlo debes volver a ejecutar `directory_load()`.


## Crear un asistente de explicación de código de R

Primero voy a **crear un asistente que me ayude a explicar código de R**. La utilidad de esta asistente para mí sería que me ayude a agregar comentarios a los scripts que entrego a mis estudiantes de R, de manera que les sea más fácil entender lo que hace cada parte de los scripts.

Defino el nombre de mi asistente y su interacción con el código seleccionado:

```r
prompt_new(role = "explicar",
           interface = "prefix")
```

Luego se abre el archivo para definir el contenido del asistente. Luego de un par de pruebas, ingresé las siguientes instrucciones o _prompts_:

```
Eres un asistente experto en ciencia de datos, diseñado para ayudar a usuarios de R a entender lo que hace un código de R. 
El código que debes explicar proviene principalmente de paquetes de R del Tidyverse, como dplyr, tidyr, stringr y otros.

Tu tarea es explicar el código de forma breve y clara, explicando lo que hace cada función, pero sin extenderte demasiado.

Responde sólo en español y en minúsculas, anteponiendo un signo # a tu respuesta, para que tu respuesta sea un párrafo de comentario de R. 
Inserta un salto de línea cada 64 caracteres.
Responde sólo con la explicación del código, sin saltos de línea al rededor de la respuesta.

Por ejemplo, si recibes el siguiente código de R:

iris |> 
  group_by(Species) |> 
  summarize(n = mean(Sepal.Length)) |> 
  arrange(desc(n))

Responde con una explicación breve, como la siguiente:

# agrupa los datos del dataframe iris según la variable Species usando la función group_by(), luego calcula
# el promedio de la variable Sepal.Length usando la función mean() dentro de summarize(), y 
# finalmente ordena las filas resultantes de mayor menor usando la función arrange() y desc()
```

Cómo puedes ver, se trata de unas pocas instrucciones breves que definen claramente lo que espero de la asistente, junto a un ejemplo muy esquemático del resultado esperado.

El último paso para integrar a los asistentes a tu flujo de trabajo es especificar un **atajo de teclado para invocar a tu asistente.** En RStudio, si entras al menú _Tools_ y eliges la opción _Modify Keyboard Shortcuts,_ puede buscar _Pal_ para especificar un atajo de teclado. En mi caso usé `comando + shift + P`. Si no quieres un atajo de teclado, en el menú _Addins_ de RStudio puedes invocar _Pal._

En el siguiente video vemos la funcionalidad en acción:
1. Selecciona el código que necesites
2. Presiona el atajo de teclado 
3. Elige el asistente que quieras usar y presiona _Enter_
4. Espera a que el modelo de lenguaje inserte el texto

<video src="explicar_pal.mov" width="100%" autoplay loop></video>

Vemos cómo el asistente escribe una explicación del código que le entregué 🥳

A continuación (¡y para que vean que funciona bien!) les muestro tres ejemplos donde seleccioné código de R y usé el asistente para que escriba una explicación del código:

_Ejemplo 1:_
```r
# lee una hoja de excel llamada "Datos Histograma" desde la ruta indicada usando read_excel() de readxl,
# lo convierte a minúsculas con clean_names(), crea un nuevo campo "tmax" que reemplaza los valores nulos
# por 17.8 y finalmente selecciona solo las columnas que no son tmax, eliminando tmedia
datos_1 <- readxl::read_excel("Datos Histograma.xlsx") |>
  janitor::clean_names() |>
  mutate(tmax = replace_na(tmax, 17.8)) |> 
  select(-tmedia)
```

_Ejemplo 2:_
```r
# crea un nuevo dataframe llamado kms_año con variables año y kms a través de tribble(), luego 
# crea un modelo lineal usando la función lm() que relacionará kms con año, finalmente guarda las predicciones 
# del modelo en una nueva columna del mismo dataframe llamada pred1 utilizando predict()
# el modelo busca la relación entre los años y el kilometraje

kms_año <- tribble(~año, ~kms,
                   2021, 530,
                   2022, 930,
                   2023, 1260)

# crear modelo lineal
model <- lm(kms ~ año, data = kms_año)

# crear predicción
kms_año$pred1 <- predict(model)
```

_Ejemplo 3:_
```r
# selecciona las columnas titulo e id del dataframe metadatos usando la función select() ,
# luego filtra los datos para incluir solo aquellas filas en las que se encuentre la cadena "microemprend" 
# en la variable titulo según la detección de expresión regular definida por str_detect(),
# repite el proceso de filtro pero buscando ahora esta vez la cadena "sexo",
# por último extrae la columna id del dataframe resultante usando la función pull()
metadatos |> 
  select(titulo, id) |> 
  filter(str_detect(titulo, "microemprend")) |> 
  filter(str_detect(titulo, "sexo"))
  pull(id)
```

Cómo se ven los ejemplos, el asistente entrega explicaciones bastante buenas, que con mínimos retoques resultarían útiles para orientar a usuarios principiantes de R. También podría servir para otros usuarios de R que reciban código y no lo entiendan.


Si quieres instalar este asistente en tu equipo, ejecuta el siguiente código en tu consola de R:
```r
pal::prompt_new("explicar", 
                "prefix", 
                contents = "https://gist.github.com/bastianolea/b190b3be7477c1c48a5b06cbe7e8d441")
```

----

## Crear un asistente de programación en {dplyr} 

El segundo asistente de programación que voy a crear va a ser uno que **traduzca una descripción de código escrita en lenguaje natural a código de `{dplyr}`**. Es decir, un asistente que haga lo contrario al asistente anterior: le voy a dar una explicación de un código, y el asistente va a generar el código necesario.

Para poner a prueba la utilidad de esta herramienta y su facilidad de uso, la instrucción que le voy a dar al asistente para que funcione va a ser simplemente la misma instrucción que le di a la asistente de explicación de código, pero al revés; es decir, le voy a pedir que sea un asistente que programe en R con `{dplyr}`, y el ejemplo que le voy a dar de su funcionamiento va a ser el mismo ejemplo que le di al  asistente anterior, pero primero la explicación del código, y después el código.

La instrucción quedaría así:

```
Eres un asistente experto en ciencia de datos, diseñado para ayudar a programar en R usando principalmente el paquete dplyr. El código que debes escribir proviene principalmente de paquetes de R del Tidyverse, como dplyr, tidyr, stringr y otros.

Tu tarea es convertir la instrucción escrita en código de R usando dplyr.

Responde sólo con el código de dplyr necesario para cumplir con la instrucción, sin comentarios ni explicaciones.

Por ejemplo, si recibes la siguiente instrucción:

agrupa los datos del dataframe iris según la variable Species, luego calcula el promedio de 
la variable Sepal.Length, y finalmente ordena las filas resultantes de mayor menor

Responde con el siguiente código de R y dplyr:

iris |> 
  group_by(Species) |> 
  summarize(n = mean(Sepal.Length)) |> 
  arrange(desc(n))
```

El siguiente video retrata el funcionamiento de este nuevo asistente, y vemos que sus resultados son correctos y útiles:

<video src="dplyr_pal.mov" width="100%" autoplay loop></video>

Cómo podemos ver, el asistente escribe rápidamente código de `{dplyr}` a partir de la descripción que le dimos. Esto podría ser muy útil para usuarios principiantes que tengan una idea de lo que quieren hacer pero no sepan exactamente cómo hacerlo, o para usuarios avanzados que están cansados de escribir y quieren que una pobre máquina trabaje por ellos.

Si quieres instalar este asistente en tu equipo, ejecuta el siguiente código en tu consola de R:
```r
pal::prompt_new("dplyr", 
                "suffix", 
                contents = "https://gist.github.com/bastianolea/a0be6c6b4471cf8e69bc1b7f30d8101a")
```

----

Éstos son sólo dos usos básicos que se le podría dar a este paquete para ayudarnos a desarrollar en R. Se podrían crear muchos más, como asistentes que expliquen los resultados de técnicas estadísticas, [asistentes que produzcan visualizaciones de datos](https://github.com/frankiethull/ggpal2), y muchas otras aplicaciones de modelos de lenguaje a la programación. 

Si se te ocurren más ideas o ya probaste este paquete, ¡déjame un comentario!