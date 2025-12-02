---
title: 'Crear tablas de datos manualmente'
author: Bastián Olea Herrera
date: '2025-12-02'
slug: []
categories: []
tags:
  - consejos
  - datos
  - básico
excerpt: "Las tablas de datos o _dataframes_ son la estructura de información principal que usamos en R. En este post veremos cómo crear _dataframes_ sencillos a mano de dos formas: usando la función base `data.frame()` y la función `tribble()`."
---

Las tablas de datos o _dataframes_ son la estructura de información principal que usamos en R.

En general cargamos los datos desde archivos o bases de datos, pero a veces necesitamos crear _dataframes_ sencillos a mano, ya sea para introducir datos manualmente, corregir datos, o crear pequeñas tablas auxiliares o de consulta (_lookup tables_). 

Aquí te muestro dos formas de hacerlo: usando la función base `data.frame()` y la función `tribble()` del [paquete `tibble`](https://tibble.tidyverse.org).


## Crear tablas de datos con `data.frame()`

La función `data.frame()` es la forma base de R para crear dataframes (tablas de datos). Puedes usarla para combinar vectores en columnas.

```r
animal <- c("mapache", "gato", "gallina")
patas <- c(4, 4, 2)
color <- c("gris", "negro", "blanco")

data.frame(animal, patas, color)
```

Así vas creando cada columna como un vector, y luego combinas los vectores para crear una tabla. 

El resultado es un objeto tipo `data.frame`, que es una tabla más tosca y primitiva que un _tibble_, pero siempre puedes convertir cualquier _dataframe_ a un _tibble_ con la función `tibble()`.


## Crear tablas de datos con `tribble()`

La función `tribble()` del [paquete `tibble`](https://tibble.tidyverse.org) (parte del [`tidyverse`](https://tidyverse.org)) permite crear _dataframes_ escribiéndolos como si fueran una planilla: por columnas y filas. Es **lo más parecido a abrir Excel y escribir los datos**, pero saltándote la parte de abrir Excel 🤢

```r
tibble::tribble(
       ~animal, ~patas,   ~color,
     "mapache",      4,   "gris",
        "gato",      4,  "negro",
     "gallina",      2, "blanco")
```
Así vas escribiendo los datos igual como si fuese una planilla, lo que puede ser más intuitivo, y el resultado sale como un _tibble_, que es una versión mejorada de los _dataframes_ base de R.

----

Te dejo [otro post](https://bastianolea.rbind.io/blog/datapasta/) para donde puedes ver cómo [convertir un _dataframe_ a código](https://bastianolea.rbind.io/blog/datapasta/#copiar) para poder compartirlo o prescindir de archivos, cómo [copiar datos desde R y pegarlos en una planilla](https://bastianolea.rbind.io/blog/datapasta/#pegar), y cómo [copiar datos desde planilla Excel y pegarla como código](https://bastianolea.rbind.io/blog/datapasta/#pegar-datos-desde-r-a-excel) que genere el _dataframe_.

----

Este post nace de la idea compartida por [Les Flores en Twitter](https://x.com/lesssflo/status/1995708807561781312)!

{{< detalles "**Ver tuit original**" >}}
<div style="width: 100%; text-align: center; margin:auto;">
<!-- para poner un embed de un tweet, intentar con la herramienta de twitter https://publish.twitter.com/# -->
<!-- después en el sitio se abre una ventana con el tuit, y esa url ponerla como iframe -->
<iframe src="https://platform.twitter.com/embed/Tweet.html?creatorScreenName=bastimapache&dnt=false&embedId=twitter-widget-0&features=eyJ0ZndfdGltZWxpbmVfbGlzdCI6eyJidWNrZXQiOltdLCJ2ZXJzaW9uIjpudWxsfSwidGZ3X2ZvbGxvd2VyX2NvdW50X3N1bnNldCI6eyJidWNrZXQiOnRydWUsInZlcnNpb24iOm51bGx9LCJ0ZndfdHdlZXRfZWRpdF9iYWNrZW5kIjp7ImJ1Y2tldCI6Im9uIiwidmVyc2lvbiI6bnVsbH0sInRmd19yZWZzcmNfc2Vzc2lvbiI6eyJidWNrZXQiOiJvbiIsInZlcnNpb24iOm51bGx9LCJ0ZndfZm9zbnJfc29mdF9pbnRlcnZlbnRpb25zX2VuYWJsZWQiOnsiYnVja2V0Ijoib24iLCJ2ZXJzaW9uIjpudWxsfSwidGZ3X21peGVkX21lZGlhXzE1ODk3Ijp7ImJ1Y2tldCI6InRyZWF0bWVudCIsInZlcnNpb24iOm51bGx9LCJ0ZndfZXhwZXJpbWVudHNfY29va2llX2V4cGlyYXRpb24iOnsiYnVja2V0IjoxMjA5NjAwLCJ2ZXJzaW9uIjpudWxsfSwidGZ3X3Nob3dfYmlyZHdhdGNoX3Bpdm90c19lbmFibGVkIjp7ImJ1Y2tldCI6Im9uIiwidmVyc2lvbiI6bnVsbH0sInRmd19kdXBsaWNhdGVfc2NyaWJlc190b19zZXR0aW5ncyI6eyJidWNrZXQiOiJvbiIsInZlcnNpb24iOm51bGx9LCJ0ZndfdXNlX3Byb2ZpbGVfaW1hZ2Vfc2hhcGVfZW5hYmxlZCI6eyJidWNrZXQiOiJvbiIsInZlcnNpb24iOm51bGx9LCJ0ZndfdmlkZW9faGxzX2R5bmFtaWNfbWFuaWZlc3RzXzE1MDgyIjp7ImJ1Y2tldCI6InRydWVfYml0cmF0ZSIsInZlcnNpb24iOm51bGx9LCJ0ZndfbGVnYWN5X3RpbWVsaW5lX3N1bnNldCI6eyJidWNrZXQiOnRydWUsInZlcnNpb24iOm51bGx9LCJ0ZndfdHdlZXRfZWRpdF9mcm9udGVuZCI6eyJidWNrZXQiOiJvbiIsInZlcnNpb24iOm51bGx9fQ%3D%3D&frame=false&hideCard=false&hideThread=false&id=1995708807561781312&lang=es&origin=http%3A%2F%2Flocalhost%3A4321%2Fblog%2Fcrear_dataframes%2F&sessionId=69124f27c64d2e8c9e315eda932a5ebb4983e5c6&siteScreenName=bastimapache&theme=light&widgetsVersion=2615f7e52b7e0%3A1702314776716&width=550px" 
height="900px" width="80%" margin="auto" frameborder="0" allowfullscreen="" title="Publicación integrada"></iframe>
</div>
{{< /detalles >}}

{{< cursos >}}