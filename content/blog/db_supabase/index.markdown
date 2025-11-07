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
excerpt: "Cuando se habla de datos, coloquialmente se usa el término _base de datos_ para referirse a datos que están en Excel. Pero en realidad una base de datos es algo distinto: un sistema de almacenamiento y procesamiento de datos que puede contener múltiples tablas, alojado en un computador, servidor o en la nube, que puede entregar datos de forma rápida y eficiente de acuerdo a las solicitudes que se le hagan. En este post veremos cómo crear una base de datos gratuita, cómo conectarnos a ella desde R, a leer y escribir tablas, y procesar datos desde la base de datos remota."
---


{{< indice >}}

## Qué es una base de datos
Cuando se habla de datos, mucha gente (me incluyo) usa coloquialmente el término _base de datos_ para referirse a datos que están en Excel o `csv`. Pero la realidad es que una base de datos es algo distinto: un sistema de almacenamiento y procesamiento de datos que puede contener múltiples tablas, y que está _hosteado_ en un computador, servidor o en la nube, que puede entregar datos de acuerdo a las solicitudes que se le hagan. En este sentido **una base de datos es distinto a _leer_ un archivo**, porque la base de datos siempre tiene cargados los datos, y está esperando que se los pidan para entregarlos de manera optimizada. 

Una de las diferencias principales al usar bases de datos es que **no necesitas _cargar_ los datos** en tu computador, porque se encuentran en la base de datos remota. En vez de cargarlos, los puedes **solicitar** para que la base de datos los procese y te los entregue. Solamente cuando los necesitas en memoria, los cargas localmente.

Pero además, una base de datos puede hacer más que simplemente almacenar los datos. Las solicitudes que hacemos a la base, usualmente hechas por medio del lenguaje `SQL`, son **procesadas de forma rápida y eficiente**, entregándote solamente lo necesario. De este modo puedes acceder a conjuntos de **muchos millones de observaciones** sin que tu computador colapse 🤯


## Cuándo usar una base de datos

- Cuando la **cantidad de observaciones es muy grande**, y te encuentras con límites de memoria
- Cuando necesitas **acceder a los datos desde varios equipos o aplicaciones**
- Cuando tus datos **ocupan mucho almacenamiento local** y preferirías que estuvieran en la nube
- Cuando tienes muchos datos, y solo los cargas para obtejer subconjuntos o resúmenes de los mismos
- Cuando quieres **optimizar la velocidad** de acceso a los datos, sobre todo la velocidad de cargar archivos
- Cuando tienes un conjunto de datos complejos que requieren de **múltiples tablas relacionadas entre sí**

A continuación veremos cómo crear una base de datos gratuita, cómo conectarnos a ella desde R, y cómo subir y trabajar con los datos en la base de datos remota.

----

## Crear una base de datos en Supabase

Como una base de datos requiere estar instalada en un computador o servidor, necesitamos un proveedor que nos permita alojar la base de datos. Una opción es [Supabase](https://supabase.com), una plataforma para bases de datos que se basa en código abierto, y que ofrece **bases de datos Postgres gratuitas** para proyectos pequeños.

Para empezar, [crea una cuenta en Supabase](https://supabase.com/dashboard/sign-up).

Una vez en tu cuenta, en la sección _**Proyects**_, crea un nuevo proyecto:

{{< imagen "supabase_1.png" >}}

Un proyecto es una instancia en el servidor de Supabase con su propia **base de datos Postgres**, donde podrás escribir tus tablas de datos. Ponle un nombre y define una contraseña segura. Con esta contraseña podrás acceder a tus datos.

{{< imagen "supabase_2.png" >}}

Luego de crear el proyecto se abrirá el panel principal, donde te indica que (por ahora) tienes cero tablas 👎🏼 

## Conectarse a la base de datos Postgres

Con el proyecto creado, ahora podemos conectarnos a la base de datos presionando el botón _**Connect**_ en la parte superior.

{{< imagen "supabase_3.png" >}}

Se abrirá un panel donde se nos entregarán los **parámetros de acceso** a la base de dato. Presiona _View parameters_ para desplegar la información:

{{< imagen "supabase_5.png" >}}

Necesitamos los parámetros `host`, `port`, `database` y `user`. Ahora pasamos a R para introducirlos y conectarnos.

### Credenciales

Necesitamos el paquete `{DBI}`, que gestiona las conexiones con bases de datos, y en nuestro caso el paquete `{RPostgres}`, que es el motor para trabajar con bases de datos Postgres.


``` r
install.packages("DBI")
install.packages("RPostgres")
```

Para conectarnos a una base de datos desde R usamos la función `dbConnect()`. Dentro de esta función explicitamos el _driver_ de la base de datos (en este caso `Postgres()`), y los parámetros de conexión que obtuvimos en Supabase: `dbname`, `host`, `port`, `user` y `password`.


``` r
db_con <- DBI::dbConnect(
  RPostgres::Postgres(),
  dbname = "postgres",
  host = "host",
  port = 5432,
  user = "postgres",
  password = "contraseña"
  )
```

¡Pero espera! **No es seguro escribir credenciales en un script.** Es un riesgo de seguridad que puede significar que un usuario indeseado acceda a tu información. Así que vamos a seguir las _buenas prácticas_ y vamos a **guardar las credenciales de forma segura**.

Una opción es no escribir la contraseña y en su lugar usar `rstudioapi::askForPassword()` para ingresar la contraseña manualmente pero de forma segura. Sin embargo, no queremos estar escribiendo la contraseña cada vez que usemos los datos!

#### Variables de entorno
Vamos a crear un script donde podamos guardar **variables de entorno**, que son variables que R puede leer pero que **no quedan en el código**, y que además **siempre se cargan cuando abrimos el proyecto**. Es decir, quedan disponibles para poder usarlas, estarán ocultas. Así podemos compartir y respaldar nuestro código sin exponer información sensible, y podemos conectarnos a la base de datos sin tener que volver a introducir las credenciales.

**Creamos un script de entorno** llamado `.Renviron` en la raíz de nuestro proyecto con la función `usethis::edit_r_environ(scope = "project")` que lo hace por nosotres.

En el script que se abre **guardamos las credenciales** de la siguiente manera:

```
db_host=db.blablablabla.supabase.co
db_port=5432
db_user=postgres
db_pass=clavebasededatosprueba
```

{{< aviso "**⚠️ Muy importante:** Si usas git, no olvides agregar el archivo `.Renviron` a tu `.gitignore` para evitar subir a internet credenciales privadas!" >}}

Una vez guardadas las credenciales, **reiniciamos la sesión de R** para que se lean las variables de entorno (siempre se leerán al iniciar R), o podemos ejecutar `readRenviron(".Renviron")` para cargarlas.

### Conexión
Ahora sí podemos hacer la conexión de forma segura, usando `Sys.getenv()` para obtener las variables de entorno desde `.Renviron`:




``` r
library(DBI)
library(RPostgres)

db_con <- DBI::dbConnect(
  RPostgres::Postgres(),
  dbname = "postgres",
  host = Sys.getenv("db_host"),
  port = Sys.getenv("db_port"),
  user = Sys.getenv("db_user"),
  password = Sys.getenv("db_pass")
)
```

Obtenemos un **objeto de conexión** `db_con`:


``` r
db_con
```

```
## <PqConnection> postgres@db.tpcfjhlqnczkhejsbbel.supabase.co:5432
```






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

{{< imagen "supabase_6.png" >}}

### Recursos
[A Crash Course on PostgreSQL for R Users](https://pacha.dev/blog/2020/08/09/postgresql-for-r-users/), por [Mauricio Vargas S.](https://pacha.dev)

