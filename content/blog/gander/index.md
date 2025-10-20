---
title: Acelera tus análisis con {gander}, un asistente de IA integrado en RStudio
author: Bastián Olea Herrera
date: '2025-10-18'
draft: false
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
  - icon: github
    icon_pack: fab
    name: Gander
    url: https://simonpcouch.github.io/gander/
  - icon: book
    icon_pack: fas
    name: LLMs en R
    url: https://luisdva.github.io/llmsr-book/r-pkgs.html
execute: 
  eval: false
excerpt: "`{gander}` es un paquete de R para integrar asistentes de inteligencia artificial (IA) directamente en RStudio. Solo con presionar una combinación de teclas, podrás pedirle a un asistente con tus propias palabras que escriba código, corrija tu código, o incluso que genere gráficos."
---

<div style="max-width:400px; margin: auto;">
{{< imagen "featured.png" >}}
</div>

{{< indice >}}


[`{gander}` es un paquete de R para integrar asistentes de inteligencia artificial (IA) directamente en RStudio.](https://simonpcouch.github.io/gander/) Solo con presionar una combinación de teclas, podrás pedirle a un asistente con tus propias palabras que escriba código, corrija tu código, o incluso que genere gráficos. 

Se trata de una herramienta capaz de acelerar tu trabajo escribiéndote código, ayudándote a salir de bloqueos mentales, y solucionando problemas en los que usualmente perdemos tiempo tipeando. 

**Pasos a seguir:** tienes que configurar su acceso a un modelo de lenguaje (como OpenAI, Anthropic, Copilot, o un modelo local como Llama), luego configurar el atajo de teclado para invocarlo, y listo!

**Cómo funciona:** en vez de tener que copiar tu código e ir pidiéndole a una IA que te ayude, `{gander}` se conecta directamente a la IA para entregarle lo que le pides, y te lo entrega directo en tu código. Pero además le entrega al modelo información contextual sobre tu proyecto que hará que el código recibido se adecúe a tu entorno de R. Esto significa que el modelo sabrá los objetos que tienes cargados, sus columnas, y más, por lo que las respuestas serán mucho más útiles.

La idea principal es que puedes seleccionar tu código en R, o invocarlo en una línea nueva, y presionar una combinación de teclas para abrir una ventana en la que puedes escribir tu solicitud. Presionas enter y el modelo te entrega el código directamente en RStudio, ya sea reemplazando el código que tenías seleccionado, o agregando código en el punto que le pediste.


## Configurar un proveedor de IA/modelo de lenguaje

Para conectar la IA a `{gander}`, tenemos dos opciones: [usar un **modelo de IA local**](#opción-a-instalar-un-modelo-de-lenguaje-local-desde-r), o [usar un **proveedor de IA en la nube.**](#opción-b-configurar-un-proveedor-de-ia-en-la-nube)

### Opción A: instalar un modelo de lenguaje local desde R

Si tu computador tiene una tarjeta de video lo suficientemente grande (más de 16GB de memoria de video), si quieres usar IA gratis, o si prefieres no usar modelos en la nube por privacidad, puedes instalar un modelo de lenguaje localmente en tu equipo.

El modelo [Llama 3.2](https://ollama.com/library/llama3.2) tiene 3 billones de parámetros, por lo que puede correr localmente en varios equipos. Para instalar un modelo localmente en tu equipo desde R, primero tienes que [instalar Ollama en tu equipo](https://ollama.com), abrir la aplicación, y luego [instalar el paquete de R {ollamar}](https://hauselin.github.io/ollama-r/) para descargar un modelo de lenguaje local desde R.[^1]

[^1]: Si tu computador no es muy poderoso, te recomiendo instalar `llama3.2:1b` (más liviano) o `llama3.2:3b` (un poco mejor), pero si tienes suficiente memoria y tarjeta de video, puedes instalar `llama3.1:8b`.

Si no tienes un modelo instalado, usa este comando para descargar e instalar un modelo desde R:

```r
library(ollamar)
pull("llama3.2:3b")
```

Es necesario tener la aplicación Ollama abierta en tu computadora, dado que ésta aplicación es la que le entrega el modelo de lenguaje a R.



### Opción B: configurar un proveedor de IA en la nube

Para conectarte a un proveedor en la nube de IA, como ChatGPT y otros, necesitas darle a R la _API key_ o clave de acceso. Como esta clave es privada (nadie más la debería ver!), la mejor forma de guardarla es en las **variables de entorno** de R. 

#### Variables de entorno

Las variables de entorno son variables definidas en un archivo `.Renviron` que está fuera de tus proyectos de R, y que permanece **oculto** y **no se sube** a GitHub ni similares. Puedes editar este archivo ejecutando `usethis::edit_r_environ()`. Se abrirá un script en el que puedes agregar **variables disponibles para todos tus proyectos de R.**

Las variables de entorno se definen sin comillas, siguiendo este formato `VARIABLE=valor`. Por ejemplo, para **guardar una clave de API de ChatGPT** (OpenAI) en tus variables de entorno, agrega la siguiente línea en tu archivo `.Renviron`:

```r
OPENAI_API_KEY=345345398475937434534539847593743453453984759374
```

Si tu proveedor es Claude (Anthropic), el nombre de la variable es `ANTHROPIC_API_KEY`, etc.

----

## Guardar configuración del modelo

Ahora que tienes tu modelo de lenguaje listo, tienes que indicarle a `{gander}` qué modelo usar. Esto lo haces configurando la opción `.gander_chat` en R. Pero la gracia es configurar ésto una sola vez y que quede siempre configurado, como veremos a continuación.

Similar a las variables de entorno, el **perfil de R** es un script _global_ de R llamado `.Rprofile`, que no se ubica en un proyecto de R específico, sino que se guarda en tu carpeta de usuario y por ende aplica a todos tus proyectos de R. El código del perfil de R se **ejecuta automáticamente cada vez que abras un proyecto o crees una sesión de R nueva.** Es el lugar perfecto para guardar algo que necesites que siempre se ejecute en todos tus proyectos, como definir configuraciones y similares.

Para **editar tu perfil de R**, ejecuta `usethis::edit_r_profile()`. Se abrirá un script en el que puedes agregar código que se ejecutará cada vez que inicies una sesión de R.

Agrega una línea para decirle a `{gander}` que use el modelo que elijas:

```r
options(.gander_chat = ellmer::chat_ollama(model = "llama3.2:3b"))
```

O si usas ChatGPT:

```r
options(.gander_chat = ellmer::chat_openai())
```

Personalmente uso Copilot, así que pongo `ellmer::chat_copilot()`.

{{< aviso "Para conocer otras formas de usar la integración de IA con R, revisa [este post sobre `{ellmer}`](/blog/ellmer/)" >}}



## Configurar atajo de teclado

Un paso clave para poder integrar rápidamente IA en tu flujo de trabajo es configurar un atajo de teclado para invocar a `{gander}`.

Para esto, entra al menú _Tools_ de RStudio, presiona _Modify Keyboard Shortcuts_, y en la ventana que se abre busca _gander._ Se sugiere configurar algo como `shift+comando+G` en Mac o `control+alt+G` en Windows.

{{< imagen "gander_keys.png" >}}


## Usar `{gander}`

Ahora que tienes todo configurado, ya puedes usar `{gander}`!

**Selecciona código**, o pon el cursor de texto en **cualquier parte de tu script**, y presiona el [atajo](#configurar-atajo-de-teclado) que configuraste 😱

Se abrirá una ventana para escribir lo que necesites pedirle al asistente. Usa tus propias paralabras para especificar la tarea que quieres lograr. 

Escribe algo como:
- transforma estos datos a formato wide
- crea un gráfico de barras con estos datos
- recodifica la variable `género`
- limpia los datos de la columna `nombre`
- exporta los datos a formato Excel

**Presiona enter**, y el modelo te entregará los resultados de inmediato! 🎉 Además, si usas proveedores de IA, lograste que se consumieran 200ml de agua! 🤑

## Ejemplo de uso

En este ejemplo, con tan sólo seleccionar el código e invocar `{gander}` con `shift+comando+G`, se abre una ventana a la que le pido que transforme y recodifique los datos, y luego que haga un gráfico.

<video src="gander_1.mp4" style="border-radius:7px; max-width: 100%; margin:auto;" autoplay loop>
</video>

Magia? No! Estadísticas! Yey! 🥳

{{< aviso "Para más paquetes y herramientas de modelos de lenguaje e IA en R, revisa [Large Language Model tools for R](https://luisdva.github.io/llmsr-book/), de Luis D. Verde Arregoitia." >}}