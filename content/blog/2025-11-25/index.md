---
title: Configura R para que haga cosas automáticamente al abrirlo
author: Bastián Olea Herrera
date: '2025-11-25'
draft: false
slug: []
categories: []
tags:
  - curiosidadades
  - automatización
format:
  hugo-md:
    output-file: index
    output-ext: md
excerpt: "Se puede configurar R para que haga cosas automáticamente al iniciarse. Esto se logra creando un archivo `.Rprofile`, que es un script de R que se ejecuta automáticamente cuando se inicia la sesión."
---

Se puede configurar R para que haga cosas automáticamente al iniciarse. Esto se logra creando un archivo `.Rprofile`, que es un script de R que se ejecuta automáticamente cuando se inicia la sesión.

Para crear un **archivo de perfil** o `.Rprofile`, usamos la función `edit_r_profile()` del paquete `{usethis}`:

```r
usethis::edit_r_profile()
```

Con esto se abrirá el `.Rprofile`. Este es un archivo invisible que se guarda en tu carpeta de usuario (home directory), que se va a ejecutar en todas tus sesiones de R. Pero también es posible tener otro dentro de cada proyecto de R, que sólo aplica a ese proyecto. 

Al iniciar R, R ejecutará el perfil **global** (en tu carpeta de usuario) y luego el perfil del **proyecto** (si existe). Para crear un `.Rprofile` que sólo aplique a un [**proyecto** específico](/blog/r_introduccion/proyectos/), hay que ejecutar `usethis::edit_r_profile(scope = "project")`.

----

Dentro del `.Rprofile`, cualquier código que agreguemos se ejecutará automáticamente al abrir R o el proyecto.

Si agregamos el siguiente código, R nos dará un mensaje de bienvenida al iniciarse:

```r
message("Bienvenido/a a RStudio! 💜")
```

Puedes confirmarlo **reiniciando la sesión de R** (menú _Session_, opción _Restart R_).

Podemos usar esto para definir configuraciones, o ejecutar cualquier tarea que necesitemos que se realice apenas abramos R.

----


Por ejemplo, podemos configurar la cantidad de decimales de los números antes de pasar a notación científica agregando:

```r
options(scipen = 999)

# probar:
1/900000
```

```
[1] 0.000001111111
```

O cambiar el lenguaje de R:
```r
Sys.setenv(LANG = "es")
```
 
O podemos configurar globalmente el lenguaje de las fechas de R:

```r
# poner las fechas de R en español
Sys.setlocale("LC_TIME", "es_ES.UTF-8") 

# pedirle una fecha para confirmar que usa meses en español
lubridate::today() |> format("%d de %B")
```

```
[1] "25 de noviembre"
```

Podemos hacer que R nos de un saludo personalizado al azar:

```r
saludos <- c("Holi 💕",
             "Te extrañaba 🥺",
             "Holi polli 🐥",
             "Hoy es un buen día para la ciencia",
             "Que tengas un bonito día, nerd 🤓")
             
message(sample(saludos, 1))
```

```
Holi 💕
```

O podemos hacer algo más útil; que R nos entregue información al iniciarse; por ejemplo, que nos diga la fecha de actualización del último archivo modificado en una carpeta:

```r
# obtener información del contenido de una carpeta
directorio <- fs::dir_info("datos/")
# obtener la fecha de la última modificación
ultimo <- max(directorio$modification_time)
# formatear fecha
fecha <- format(ultimo, "%d de %B a las %H:%M")

message("Bienvenidx! ☺️ Última actualización: ", fecha)
```

```
Bienvenidx! ☺️ Última actualización: 25 de noviembre a las 15:10
```


Pero siempre tenemos que tener cuidado de no agregar al _perfil_ código que haga que nuestros proyectos dejen de ser reproducibles! Si el proyecto _depende_ de código que está en el _perfil_, alguien más que abra el proyecto no podrá correrlo correctamente.

----

En mi caso, tengo un proyecto específico donde quiero que al abrirlo **se abra un script** y **se navegue a una carpeta** del proyecto. Como el software que puede abrir scripts e interactuar con los paneles de Rstudio es RStudio (y no R) este caso, necesitamos agregar código extra para que R confirme que estamos en RStudio.

Ejecuto `usethis::edit_r_profile(scope = "project")` para crear un _perfil_ solamente par ami proyecto, y le agrego:

```r
# abrir script al iniciar RStudio
setHook("rstudio.sessionInit", function(newSession) {
  if (newSession)
    # navegar a carpeta 
    rstudioapi::filesPaneNavigate(here::here("content/blog/"))
    # abrir script principal
    rstudioapi::documentOpen("_instrucciones.R")
}, action = "append")
```

Para probar que funciona, hay que cerrar y abrir RStudio, no sólo reiniciar R.

----

Del mismo modo, en otro post del blog explico que podemos [configurar RStudio para que use un tema durante el día y otro durante la noche](/blog/2025-01-12/). En este caso, usamos el paquete `{rsthemes}` para definir los temas claro y oscuro, y las horas del día a las que se activan:

```r
# especificar temas para modo claro y oscuro
if (interactive() && requireNamespace("rsthemes", quietly = TRUE)) {

  # definir temas favoritos
  rsthemes::set_theme_light("Basti Purple Light")  # tema claro
  rsthemes::set_theme_dark("Basti Purple Dark") # tema oscuro

  # cambiar al tema dependiendo de la hora al iniciar una sesión en RStudio
  setHook("rstudio.sessionInit", function(isNewSession) {
    rsthemes::use_theme_auto(dark_start = "21:00", # hora del tema oscuro
                             dark_end = "6:00") #hora del tema claro
  }, action = "append")
}
```

También hay que poner código extra, porque es RStudio (y no R) quien define los temas de RStudio.