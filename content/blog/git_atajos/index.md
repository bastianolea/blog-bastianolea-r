---
title: Comandos comunes de Git
author: Bastián Olea Herrera
date: '2025-10-22'
slug: []
draft: true
categories: []
tags:
  - git
format:
  hugo-md:
    output-file: index
    output-ext: md
---

Crear repositorio git en proyecto de RStudio

```r
use_git()
```

Subir proyecto a GitHub
```r
use_github()
```

Deshacer `git add`

```r
git reset HEAD~
```


Deshacer `commit`

```
git reset --soft HEAD~1
```

Volver al último `commit`

```
git reset --hard HEAD
```

Eliminar archivos del repositorio remoto
```r
git rm --cached "archivo"
git commit -m "mensaje"
git push -u origin branch
```

Forzar push
```r
git push origin main --force
```


Deshacer `git add .`
```
git reset
```


ohshitgit.com