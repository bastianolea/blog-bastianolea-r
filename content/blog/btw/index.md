---
title: Interactúa desde R con una IA que conoce tus datos, archivos y paquetes
author: Bastián Olea Herrera
date: '2025-12-10'
slug: []
categories: []
tags:
  - inteligencia artificial
  - consejos
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: registered
    icon_pack: fas
    name: Paquete
    url: https://posit-dev.github.io/btw/index.html
excerpt: "El paquete `{btw}` te ofrece un chat de IA interactivo directamente a RStudio o Positron, que además cuenta con la capacidad de utilizar herramientas para interactuar con tus datos y tu código, y posee conocimiento contextual no sólo de tu entorno de R y tus datos, sino también de las funciones de los paquetes que usas y su documentación. Se trata de un asistente de IA que te entregará respuestas más certeras sin que tengas que estar explicándole todo."
---


{{< imagen "btw_featured.png" >}}


En este blog ya hemos visto varias [herramientas de IA](/tags/inteligencia-artificial) que te pueden ayudar a usar R, por ejemplo [el paquete `{gander}`](/blog/gander/), que al presionar una combinación de teclas cuando tienes código seleccionado invoca una ventana donde puedes pedir a una IA que haga cosas con ese código y/o datos, gracias a un **conocimiento contextual de tu entorno de R**.

<img src = btw_logo.png style = "float: right; max-width: 128px; margin-left: 20px;">

Ahora te presento otro paquete que va más alla: [el paquete `{btw}`](https://posit-dev.github.io/btw/index.html) (abreviación de _by the way_ o _por cierto_) trae un **chat de IA interactivo** directamente a RStudio o Positron, que además cuenta con la capacidad de **utilizar herramientas** para interactuar con tus datos y tu código, y posee **conocimiento contextual** no sólo de tu entorno de R y tus datos, sino también de las **funciones de los paquetes** que usas y su **documentación**!

Todas estas características potencian a los modelos de lenguaje al entregarles contexto valioso para que puedan ayudarte de forma más certera. Esto significa que:

- Habrá menos _alucinación_, ya que en vez de adivinar, el modelo **recurrirá a la documentación de cada paquete y función** para saber exactamente cómo se usan,
- El modelo **conocerá exactamente tus datos, sus columnas y tipos**, así que sus respuestas incluirán nombres de variable y funciones correctas,
- Al **saber qué paquetes tienes instalados y cargados**, el modelo podrá sugerirte funciones específicas de esos paquetes para realizar tareas concretas, en vez de cosas que no usas.

En resumen, se trata de un asistente de IA que te entregará respuestas más certeras sin que tengas que estar explicándole todo.

Instala `{btw}` con:

```r
install.packages("btw")
```


## Chat básico con una IA en R

Antes de mostrarte `{btw}`, veremos como comparación un [chat normal con una IA desde R, usando `{ellmer}`](https://ellmer.tidyverse.org/reference/Chat.html). La hipótesis es que no va a poder responder bien 🤓


{{< info "`{ellmer}` es un [paquete de R](https://ellmer.tidyverse.org/index.html) que facilita la interacción con modelos de lenguaje desde R, y se usa como el motor de muchos otros paquetes que usan IA.">}}

Primero **creamos el chat** con el proveedor de IA que usemos:
```r 
chat <- ellmer::chat_github() # yo uso Copilot
# chat <- ellmer::chat_openai()
```

Luego podemos **interactuar** con el modelo por medio del objeto `chat$chat()`. Vamos a hacerle una pregunta sencilla:

> ¿Qué objetos tengo en mi entorno de R?

```r
chat$chat("¿Qué objetos tengo en mi entorno de R?")
```

El modelo responde:

```
Para **ver los objetos que tienes en tu entorno de R**, puedes usar la función:

    ```r
    ls()
    ```

Esto te muestra una lista de los nombres de los objetos `(.GlobalEnv)` que has creado
(como variables, data frames, funciones, etc.).
```

Al igual que ChatGPT o cualquier otro chat de IA que usarías en la web, este modelo **no tiene** acceso a tu sesión de R ni conocimiento sobre tu contexto, por lo que sugiere soluciones genéricas! 🙄


## Chat interactivo con conocimiento contextual

A diferencia de un modelo sin contexto, al que tienes que darle mucha información en cada _prompt_ para que pueda ayudarte, [la función `btw_app()` de `{btw}`](https://posit-dev.github.io/btw/reference/btw_client.html) invoca una **aplicación interactiva** con un chat cuyo modelo tiene acceso a tu entorno de R, tus datos, los paquetes que tienes instalados y cargados, y otras herramientas que le van a permitir **responder mejor tus consultas**.

```r
chat <- ellmer::chat_github() # crear chat

library(btw) 
btw_app(client = chat) # lanzar char interactivo
```

Al ejecutar `btw_app()` se abre una aplicación interactiva con la que puedes chatear:

{{< imagen "btw_1.png" >}}

Como vemos en la imagen, ante la misma pregunta este modelo responde de forma mucho más precisa, entregando información exacta sobre los objetos que realmente tengo en mi entorno de R!

Esto funciona porque `{btw}` registra **herramientas** que el modelo puede usar para obtener contexto e información, sin que tú tengas que hacer nada. Por ejemplo, en el ejemplo anterior vemos que el modelo llama por sí solo una herramienta que le entrega tus datos en formato JSON, y por eso responde bien:

{{< imagen "btw_2.png" >}}


## Chat con conocimiento contextual por la consola

También es posible **reforzar** un chat con una IA para que tenga conocimiento contextual, sin necesidad de usar la aplicación interactiva, sino directamente desde la consola de R. Para eso usamos `btw_client()` sobre un chat nuevo o anterior, para que `{btw}` le entregue contexto y herramientas al modelo:

```r
chat <- btw_client(client = ellmer::chat_github()) # reforzar chat

chat$chat("¿qué objetos tengo en mi entorno de R?")
```
{{< imagen "btw_3.png" >}}

A diferencia de el primer ejemplo, ahora el modelo de lenguaje sí puede acceder a mi entorno de R y responder correctamente.

-----

## Ejemplo de uso

En una sesión de R cargué un archivo con datos, luego lancé una sesión de chat con `btw::btw_app()`, y le pregunté:

> con la base de datos que tengo cargada, ¿cómo puedo hacer un gráfico que compare el valor del capital humano en cada región?

Gracias al conocimiento contextual y el acceso a herramientas, responde correctamente, usando nombres y valores correctos:

{{< video "btw_4.mov" >}}

Me entregó este código, que pude copiar con un clic:

```r
human_capital <- datos |>
  filter(factor == "Capital Humano")

library(ggplot2)

ggplot(human_capital, aes(x = factor(region), y = stock_2023)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Capital Humano por Región",
       x = "Región",
       y = "Stock 2023 (Capital Humano)") +
  theme_minimal()
```

{{< imagen "btw_grafico.png" >}}

No es el gráfico más bonito del mundo (a mi me quedan mejores, todavía no me quitan el trabajo 😌), pero demuestra que sabe hacer la pega! Otros modelos hubieran inventado columnas, no hubieran podido hacer el filtro, o no sabrían poner los títulos de los ejes.


----

#### Otros

Para evitar tener que crear un chat y/o especificar proveedor y modelo cada vez, puedes configurarlos en tu perfil de R: en `usethis::edit_r_profile()`, incluye la siguiente línea especificando tu proveedor y modelo:

```r
options(btw.client = ellmer::chat_github()) |> suppressMessages()
```