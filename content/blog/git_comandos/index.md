---
title: Comandos comunes de Git
author: Bastián Olea Herrera
date: '2025-10-27'
slug: []
draft: false
categories: []
tags:
  - git
format:
  hugo-md:
    output-file: index
    output-ext: md
excerpt: "Colección de comandos de `git` para realizar acciones comunes y resolver problemas frecuentes. `git` es una herramienta para el control de versiones de código, respaldo de código, y colaboración."
---

`git` es una herramienta para el control de versiones de código, respaldo de código, y colaboración. En otro post hice un tutorial para [aprender a usar `git` y GitHub con R y RStudio](/blog/r_introduccion/tutorial_github/). En este post voy a mantener una lista[^1] de los comandos que más uso en `git`, así como los comandos que necesito para resolver los **problemas más frecuentes.**

[^1]: Hago esto porque tengo una nota en el computador con todos los comandos y siempre vuelvo a buscarla para copiarlos, así que mejor dejo todo eso acá 😋

Otro recurso mucho más completo es [ohshitgit.com](https://ohshitgit.com/es), que como su nombre indica, está enfocado en resolver problemas comunes con `git`.



### Crear repositorio git en proyecto de RStudio

```
git init
```

```r
usethis::use_git()
```
Para más información sobre la integración de R con `git`, [revisa este post](/blog/r_introduccion/tutorial_github/). También existe el libro [Happy Git with R](https://happygitwithr.com), que detalla todos los pasos necesarios para poder usar `git` con R, incluyendo soluciones a problemas comunes.



### Agregar archivos al área de preparación (_staging area_)
Cuando creaste o modificaste archivoc, y quieres registrarlos para ser agregados a la nueva versión del proyecto:

```
git add archivo.R
```

Para agregar todos los archivos cambiados desde el último _commit_:

```
git add .
```

### Ver estado del repositorio
Para ver qué archivos han sido modificados, cuáles están en el área de preparación, y cuáles no:

```
git status
```

### Guardar los cambios preparados en una versión (_commit_)
Un _commit_ es la operación en la que tomas los archivos del área de preparación y los guardas como una nueva versión del proyecto. Siempre hay que agregar un mensaje que describa los cambios de esta versión:

```
git commit -m "script de procesamiento de datos actualizado"
```

### Ver todos los _commits_ que has hecho
Te entrega una lista con las versiones de tu repositorio, con sus mensajes respectivos y el índice de cada uno de ellos (un código único que identifica cada cambio)

```
git log
```

También está el comando `git reflog`, que muestra un historial de todos los movimientos en el repositorio, incluyendo _commits_, cambios de ramas, y otras operaciones.
```
git reflog
```

### Subir los cambios guardados al repositorio remoto (GitHub)

Asumiendo que tu proyecto de RStudio tiene un repositorio `git`, que has hecho `commit` de tus cambios, y que [ya conectaste el repositorio local con un repositorio remoto](/blog/r_introduccion/tutorial_github/#crear-un-repositorio-remoto-en-github-para-tu-proyecto-de-r) en GitHub o GitLab:

```
git push
```

Si no has creado una versión remota de tu repositorio aún, puedes usar el comando `use_github()` para crear una rápidamente.

```r
usethis::use_github()
```


### Deshacer `git add archivo.R`
Por si la embarraste y agregaste un archivo incorrecto a la zona de preparación:

```
git rm archivo.R
```

### Deshacer `git add .`
```
git reset
```

### Deshacer `commit`
Si guardaste una versión del código pero ésta tenía archivos equivocados, puedes deshacer el _commit_ pero **sin perder los cambios** que hiciste. Con esto, tu repositorio volverá a la versión antes del commit, pero el código y archivos nuevos no se perderán, y estarán disponibles para volver a agregarlos con `git add` y rehacer la versión con `git commit`.

```
git reset --soft HEAD~1
```


### Eliminar archivos agregados con `git add`
Para cuando agregaste archivos al _commit_ pero luego te das cuenta que no debías haberlo hecho. Por ejemplo, si agregaste un archivo muy grande por error:

```r
git rm --cached "archivo"
git commit -m "mensaje"
git push -u origin branch
```


### Volver al último `commit`
Borra el último commit, **perdiendo tus cambios locales.**
```
git reset --hard HEAD
```

### Forzar push
Por si no te deja subir los cambios, pero estás segurx de que quieres sobreescribir el repositorio remoto con tu versión local:

```r
git push origin main --force
```


### Volver a una versión anterior de tu código

Busca el índice de la versión a la cual quieres volver, y usa `git reset` para regresar a esa versión:

```
git reflog
git reset HEAD@{index}
```

### Ramas

Aprende a [hacer ramas online aquí](https://learngitbranching.js.org/)