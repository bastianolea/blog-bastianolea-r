---
title: Crear y conectarse a una base de datos Postgres en R
author: Bastián Olea Herrera
date: '2025-11-06'
draft: true
slug: []
categories:
  - Tutoriales
tags:
  - datos
  - optimización
format:
  hugo-md:
    output-file: index
    output-ext: md
excerpt: >-
  Cuando se habla de datos, coloquialmente se usa el término _base de datos_
  para referirse a datos que están en Excel. Pero en realidad una base de datos
  es algo distinto: un sistema de almacenamiento y procesamiento de datos que
  puede contener múltiples tablas, alojado en un computador, servidor o en la
  nube, que puede entregar datos de forma rápida y eficiente de acuerdo a las
  solicitudes que se le hagan. En este post veremos cómo crear una base de datos
  gratuita, cómo conectarnos a ella desde R, a leer y escribir tablas, y
  procesar datos desde la base de datos remota.
---


{{< indice >}}

## Qué es una base de datos

Cuando se habla de datos, mucha gente (me incluyo) usa coloquialmente el término *base de datos* para referirse a datos que están en Excel o `csv`. Pero la realidad es que una base de datos es algo distinto: un sistema de almacenamiento y procesamiento de datos que puede contener múltiples tablas, y que está *hosteado* en un computador, servidor o en la nube, que puede entregar datos de acuerdo a las solicitudes que se le hagan. En este sentido **una base de datos es distinto a *leer* un archivo**, porque la base de datos siempre tiene cargados los datos, y está esperando que se los pidan para entregarlos de manera optimizada.

Una de las diferencias principales al usar bases de datos es que **no necesitas *cargar* los datos** en tu computador, porque se encuentran en la base de datos remota. En vez de cargarlos, los puedes **solicitar** para que la base de datos los procese y te los entregue. Solamente cuando los necesitas en memoria, los cargas localmente.

Pero además, una base de datos puede hacer más que simplemente almacenar los datos. Las solicitudes que hacemos a la base, usualmente hechas por medio del lenguaje `SQL`, son **procesadas de forma rápida y eficiente**, entregándote solamente lo necesario. De este modo puedes acceder a conjuntos de **muchos millones de observaciones** sin que tu computador colapse 🤯

## Cuándo usar una base de datos

-   Cuando la **cantidad de observaciones es muy grande**, y te encuentras con límites de memoria
-   Cuando necesitas **acceder a los datos desde varios equipos o aplicaciones**
-   Cuando tus datos **ocupan mucho almacenamiento local** y preferirías que estuvieran en la nube
-   Cuando tienes muchos datos, y solo los cargas para obtejer subconjuntos o resúmenes de los mismos
-   Cuando quieres **optimizar la velocidad** de acceso a los datos, sobre todo la velocidad de cargar archivos
-   Cuando tienes un conjunto de datos complejos que requieren de **múltiples tablas relacionadas entre sí**

A continuación veremos cómo crear una base de datos gratuita, cómo conectarnos a ella desde R, y cómo subir y trabajar con los datos en la base de datos remota.

------------------------------------------------------------------------

## Crear una base de datos en Supabase

{{< imagen "supabase_1.png" >}}
{{< imagen "supabase_2.png" >}}
{{< imagen "supabase_3.png" >}}

## Conectarse a la base de datos Postgres

{{< imagen "supabase_5.png" >}}
{{< imagen "supabase_6.png" >}}

### Credenciales

``` r
usethis::edit_r_environ(scope = "project")
```

    db_host=db.blablablabla.supabase.co
    db_port=5432
    db_user=postgres
    db_pass=clavebasededatosprueba

{{< aviso "**⚠️ Muy importante:** no escribas tus claves en un script! Si usas git, no olvides agregar el archivo `.Renviron` a tu `.gitignore` para evitar subir a internet credenciales privadas!" >}}

``` r
library(DBI)

# conexión
db_con <- DBI::dbConnect(
  RPostgres::Postgres(),
  dbname = "postgres",
  host = Sys.getenv("db_host"),
  port = Sys.getenv("db_port"),
  user = Sys.getenv("db_user"),
  password = Sys.getenv("db_pass")
)
```

También puedes escribir las credenciales pero ingresar la contraseña manualmente de forma segura usando `rstudioapi::askForPassword()`.

``` r
library(DBI)

db_con
dbListTables(db_con)

dbWriteTable(conn = db_con, 
             name = "prueba",
             iris, 
             overwrite = TRUE)

# opcional: indexes = list(c("semana", "fecha"))

dbListTables(db_con)

dbReadTable(db_con, "prueba")
```

``` r
install.packages("dbplyr")
```

https://dbplyr.tidyverse.org

``` r
library(dplyr)

copy_to(db_con, iris, "prueba",
        overwrite = TRUE)

db_iris <- tbl(db_con, "prueba")

datos <- db_iris |> 
  filter(Species == "setosa") |> 
  summarise(mean_sepal_length = mean(Sepal.Length))
```

``` r
datos

datos |> show_query()
datos_df <- datos |> collect()
```

### Recursos

[A Crash Course on PostgreSQL for R Users](https://pacha.dev/blog/2020/08/09/postgresql-for-r-users/), por [Mauricio Vargas S.](https://pacha.dev)
