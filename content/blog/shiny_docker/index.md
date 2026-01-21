---
title: Desplegar aplicaciones Shiny a producción en contenedores Docker
author: Bastián Olea Herrera
date: '2026-01-20'
slug: []
categories: []
tags:
  - shiny
  - optimización
draft: false
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: registered
    icon_pack: fas
    name: Shiny2docker
    url: https://github.com/VincentGuyader/shiny2docker
  - icon: docker
    icon_pack: fab
    name: Rocker Project
    url: https://rocker-project.org
excerpt: Docker es una plataforma que permite empaquetar aplicaciones y sus dependencias en contenedores, lo que simplifica el proceso de despliegue (_deployment_) y gestión de aplicaciones. Con Docker puedes empaquetar tu app Shiny junto con todo lo necesario para que funcione correctamente, y así poder desplegarla en cualquier lugar sin preocuparte por las diferencias en los entornos de ejecución. Esto significa que crearás un contenedor con una versión de Linux y de R específica, junto a todas las configuraciones e instalaciones que necesites.
---

Docker es una plataforma que permite empaquetar aplicaciones y sus dependencias en **contenedores**, lo que simplifica el proceso de despliegue (_deployment_) y gestión de aplicaciones. 

{{< aviso "Post en construcción! A medida que voy aprendiendo iré complementando la publicación." >}}

{{< info "Este es un post para usuarios avanzados de Shiny que necesiten desplegar sus apps contextos de empresas o producción. Si eres un usuario casual de Shiny, probablemente sea mejor usar [Posit Connect Cloud](https://connect.posit.cloud) para publicar tus apps." >}}

## ¿Qué es Docker?

Docker es un programa que te permite crear **contenedores** dentro de los cuales puedes ejecutar aplicaciones. Estos son entornos exclusivos y específicos para tu app, de manera que ya no la ejecutas en _tu_ computador, sino que la ejecutas dentro del contenedor, que es una especie de computador virtual sólo para tu app. Estos contenedores son independientes entre sí y reproducibles, ayudándote a que tus apps siempre funcionen siempre igual, sin importar dónde las ejecutes.

Los objetivos principales de usar Docker en aplicaciones Shiny son:

- **Garantizar un entorno de ejecución consistente y reproducible**: al ejecutar la app en el contenedor, tienes garantizado que se ejecutará igual en otro computador, en un servidor Linux, o en cualquier entorno.
- **Congelar las dependencias** de la aplicación, para asegurarte de que se usan las versiones exactas de R y de los paquetes que utilices, además de ejecutarse en un mismo sistema operativo (usualmente Linux) con todas las librerías y configuraciones que éste requiera.
- **Facilitar el despliegue** en servidores o plataformas de nube, dado que tu app vive aislada dentro del contenedor, y por ende no requiere cambiar configuraciones ni instalar cosas al servidor.

En pocas palabras, Docker sirve para empaquetar tu aplicación Shiny junto con todo lo necesario para que funcione correctamente, y así poder desplegarla en cualquier lugar sin preocuparte por las diferencias en los entornos de ejecución. Esto significa que crearás un **contenedor** con una versión de Linux y de R específica, junto a todas las configuraciones e instalaciones que necesites.

### Imágenes

Los contenedores Docker dependende **imágenes**. Las imágenes contienen un sistema operativo base y las configuraciones e instalaciones necesarias.

En el caso de R y Shiny existen las imágenes de [Rocker Project](https://rocker-project.org), un proyecto que mantiene imágenes con versiones de R y todo lo necesario para usar R.

Existen imágenes de Shiny y [Shiny-Verse, que es Shiny + paquetes del Tidyverse](https://hub.docker.com/r/rocker/shiny-verse/tags), para acelerar el despliegue si usas esos paquetes (recomendado).


### Dockerfiles

Un **Dockerfile** es el archivo que contiene la _receta_ para crear tu contenedor: empezando por la imagen que se usará como base, e incluyendo instalación de libreríass, copiado de archivos, configuración de puertos, y todo lo necesario para que tu aplicación funcione correctamente.


## Creando contenedores para apps Shiny

### Crear un contenedor automáticamente con `{shiny2docker}`

[El paquete `{shiny2docker}`](https://github.com/VincentGuyader/shiny2docker) facilita enormemente esta tarea. 

Simplemente instala el paquete con `install.packages("shiny2docker")` y luego, en el directorio de la app, ejecuta:

```r
shiny2docker::shiny2docker(path = ".")
```

La función capturará las dependencias de tu aplicación y generará un `dockerfile` personalizado.

El paquete decidirá la imagen que usará como base, pero puedes cambiarla especificando el argumento `FROM = "rocker/shiny-verse"`.

El `dockerfile` resultante se vería más o menos así:

```docker
FROM rocker/shiny:4.4.2
RUN apt-get update -y && apt-get install -y  make pandoc libx11-dev libfontconfig1-dev libfreetype6-dev libcairo2-dev libpng-dev zlib1g-dev cmake libssl-dev libgdal-dev gdal-bin libgeos-dev libproj-dev libsqlite3-dev libudunits2-dev libicu-dev && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/local/lib/R/etc/ /usr/lib/R/etc/
RUN echo "options(renv.config.pak.enabled = FALSE, repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" | tee /usr/local/lib/R/etc/Rprofile.site | tee /usr/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
RUN R -e 'remotes::install_version("renv", version = "1.1.4")'
COPY renv.lock renv.lock
RUN --mount=type=cache,id=renv-cache,target=/root/.cache/R/renv R -e 'renv::restore()'
WORKDIR /srv/shiny-server/
COPY . /srv/shiny-server/
EXPOSE 3838
CMD R -e 'shiny::runApp("/srv/shiny-server",host="0.0.0.0",port=3838)'
```

- Vemos que lo primero que hace es basarse en una imagen de [Rocker Project](https://rocker-project.org) con una versión específica de R. 
- Luego instala librerías de Ubuntu con `apt-get install`. 
- Después ejecuta varios comandos de Linux con `RUN`, entre ellos los necesarios para activar `{renv}` y así instalar las versiones específicas de los paquetes usados en tu sesión de R. 
- Finalmente usa `COPY` para copiar los archivos de tu app a la carpeta `/srv/shiny-server/`, desde la cual se ejecutará tu app.



### Crear un contenedor manualmente

También podemos crear un contenedor a mano, creando un archivo llamado `Dockerfile` que contenga, como mínimo, la imagen que usaremos, la instalación de librerías de Ubuntu requeridas y la instalación de paquetes de R.

```docker
FROM rocker/shiny-verse:4.5.2

RUN apt-get update -y && apt-get install -y  
RUN apt-get install -y fonts-manrope
RUN apt-get install -y libudunits2-dev libgdal-dev libgeos-dev libproj-dev

RUN R -e 'install.packages("shinyWidgets")'
RUN R -e 'install.packages("shinycssloaders")'
RUN R -e 'install.packages("shinydisconnect")'
RUN R -e 'install.packages("shinyjs")'
RUN R -e 'install.packages("writexl")'
RUN R -e 'install.packages("gfonts")'
RUN R -e 'install.packages("ragg")'
RUN R -e 'install.packages("gt")'
RUN R -e 'install.packages("sf")'
RUN R -e 'install.packages("cli")'
RUN R -e 'install.packages("ggiraph")'
RUN R -e 'remotes::install_github("hrbrmstr/waffle")'

RUN sudo chown -R shiny:shiny /srv/shiny-server/
```

{{< info "Si no sabes qué librerías de Ubuntu/Linux son necesarias, simplemente omite esas líneas e instala los paquetes que necesites. Al ejecutar el contenedor, los mensajes de error te dirán lo que necesitas instalar." >}}


Luego, crea un archivo `docker-compose.yml` para definir el servicio de la app Shiny:

```yaml
services:
   shiny_server:
     container_name: app
     build:
       context: .
       dockerfile: Dockerfile
     ports:
        - "3838:3838" # cambiar primer puerto si tienes varias apps
     volumes:
       - ./app/:/srv/shiny-server/
     restart: always
```

Este archivo coordinará el despliegue de tu contenedor, y copiará los contenidos de la carpeta `app/` a `/srv/shiny-server/` dentro del contenedor, así que asegúrate de que dentro de `app/` (o el nombre de la carpeta de tu app) estén los archivos `app.R` o `ui.R` y `server.R`.



## Ejecutando apps Shiny desde contenedores Docker

Para ejecutar el contenedor con tu app Shiny, deberías tener en un mismo directorio lo siguiente:

1. El archivo `Dockerfile` con los pasos de instalación de tu contenedor, ya sea escrito por ti o creado por `{shiny2docker}`
2. El archivo `docker-compose.yml` para coordinar el despliegue de tu contenedor
3. Una carpeta `app/` (o el nombre de tu app) con los scripts y archivos necesarios para tu aplicación Shiny (`app.R`, etc).

Luego necesitas **abrir una Terminal** y ubicar la terminal en esa carpeta (`cd ruta/a/carpeta/`), y desde ahí ejecutar el siguiente comando:

```bash
docker compose up -d
```
Este comando levanta una aplicación Shiny hecha con Docker Compose en segundo plano, asumiendo que la carpeta desde la que ejecutaste el comando contiene el `dockerfile` y `docker-compose.yml`.

La primera vez que lo ejecutes, debería salir en la terminal el proceso de construcción del contenedor, con la instalación de todo lo que detallaste. Luego de unos minutos (dependiendo de la cantidad de paquetes y librerías que tengas que instalar), el contenedor debería estar listo y ejecutándose.

Para **acceder a la aplicación**, accede desde un navegador a `localhost:3838`, o reemplaza `3838` por el puerto que hayas definido en `docker-compose.yml`. 

{{< info "Si tienes varias apps en varios contenedores, cada una debe salir por un puerto distinto!" >}}


## Comandos de Docker más frecuentes

Levantar una aplicación Shiny hecha con Docker Compose:
```bash
docker compose up -d
```

Bajar la aplicación Shiny hecha con Docker Compose:
```bash
docker compose down
```

Ver los contenedores Docker activos:
```bash
docker ps 
```

Ver las imágenes Docker disponibles:
```bash
docker image ls
```

Eliminar una imagen Docker:
```bash
docker image ls
docker rmi xxxx
```
_Reemplaza `xxxx` por el ID de la imagen_

Reconstruir y levantar la aplicación Shiny hecha con Docker Compose:
```bash
docker compose up --build --force-recreate -d
```
_Para recibir cambios nuevos y asegurarte de que se aplicarán_

Entrar a la consola de un contenedor Docker activo:
```bash
docker ps 
docker exec -ti xxxx /bin/bash
```
_Reemplaza `xxxx` por el ID del contenedor_


----


## Recursos

