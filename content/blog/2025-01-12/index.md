---
title: Configura RStudio para que cambie al modo oscuro o claro automáticamente según
  la hora del día
author: Bastián Olea Herrera
date: '2025-01-12'
slug: []
categories: []
tags:
  - consejos
  - temas
excerpt: La idea de usar un tema oscuro en una pantalla no es que se vea más bonito y profesional todo de negro, sino ayudarte a reducir el contraste de la pantalla con respecto al espacio en el que estás trabajando. Para resolver esto, sólo se necesitan dos paquetes y una pequeña configuración.
---

<div style = "display: flex; justify-content: center; width: 100%; margin-bottom: 40px;">
<img style = "width: 50%;" src="/blog/tema_morado/tema_oscuro.png">
<img style = "width: 50%;" src="/blog/tema_morado/tema_claro.png">
</div>


En la eterna batalla entre usuarios de tema oscuro y tema claro, yo lamentablemente soy del bando correcto: **tema oscuro durante la noche, y tema claro durante el día.**

La idea de usar un tema oscuro en una pantalla no es que se vea más bonito y profesional todo de negro, sino ayudarte a **reducir el contraste de la pantalla con respecto al espacio en el que estás trabajando.** En este sentido, si estás en un espacio bien iluminado, deberías usar un tema claro, para no forzar a vista a tener que adaptarse entre un entorno brillante y una pantalla oscura. Si estás en un espacio oscuro, o de iluminación baja, deberías usar un tema oscuro para adecuarte a la iluminación a tu alrededor, junto con ajustar el brillo de tu pantalla.

La mayoría de los sistemas operativos modernos cambian automáticamente entre el tema claro u oscuro dependiendo de la hora del día, asumiendo que durante la noche tendremos menor iluminación. Además, la mayoría de las pantallas adaptan su brillo automáticamente a la iluminación ambiente, reduciéndola en espacios oscuros. Un paso extra de cuidado de la vista e higiene del sueño es el cambio de los colores de la pantalla a un tinte cálido durante la noche, activado por defecto en sistemas operativos macOS y iOS.

Pero RStudio no se adapta solito al tema de tu computador, principalmente porque los temas son configurados por el/la usuario/a. Para resolver esto, se necesitan dos paquetes y una pequeña configuración:

1. [Instala {usethis}](https://usethis.r-lib.org), un paquete que facilita varias operaciones convenientes en R y asociadas al desarrollo con R, 
2. [Instala {rsthemes}](https://www.garrickadenbuie.com/project/rsthemes/), un paquete que contiene temas para RStudio y varias utilidades relacionadas a los temas, como la habilidad de cambiarlos por medio de funciones, usar temas aleatorios, y más.
3. En tu consola de R, ejecuta `usethis::edit_r_profile()`, lo que hará que se abra tu archivo `.Rprofile`. Este script es un archivo especial, que se ejecuta automáticamente cada vez que inicies una sesión en R, por lo que puedes incluir en él ciertas configuraciones que siempre tengas que ejecutar, como la que incluiremos a continuación.
4. Incluye el siguiente código en tu `.Rprofile`:

<div style = "margin-left: 40px;">

```r
# especificar temas para modo claro y oscuro
if (interactive() && requireNamespace("rsthemes", quietly = TRUE)) {

  rsthemes::set_theme_light("Basti Purple Light")  # tema claro
  rsthemes::set_theme_dark("Basti Purple Dark") # tema oscuro

  # cambiar al tema dependiendo de la hora al iniciar una sesión en RStudio
  setHook("rstudio.sessionInit", function(isNewSession) {
    rsthemes::use_theme_auto(dark_start = "21:00", # hora del tema oscuro
                             dark_end = "6:00") #hora del tema claro
  }, action = "append")
}
```

</div>

5. Dentro de este bloque de código, tienes que configurar cuatro cosas: el **nombre del tema claro** que quieres usar durante el día, y el **nombre del tema oscuro** que quieres usar durante la noche, junto con la **hora del día** a la que quieres que se active automáticamente el modo oscuro, y la hora del día a la que quieres que se active el modo claro.

En mi caso, estoy usando [dos temas de RStudio morados](/blog/tema_morado/) que creé yo, basados en una paleta de colores morada y rosada. En [este post](/blog/tema_morado/) explico cómo descargarlos e instalarlos en tu RStudio.

Ahora, cada vez que abras una nueva sesión de RStudio (o reinicies tu sesión), el tema de RStudio se ajustará automáticamente al tema que elegiste para el día o la noche!

_Recuerda cuidar tus ojos mientras programas mirando a la distancia con regularidad y configurando el brillo de tu pantalla para que sea similar al brillo de tu habitación!_