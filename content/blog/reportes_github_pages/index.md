---
title: Publica reportes Quarto como páginas web con GitHub Pages
author: Bastián Olea Herrera
date: '2024-11-18'
slug: []
categories: []
draft: true
format: 
  hugo-md:
    output-file: "index"
    output-ext:  "md"
tags:
  - Quarto
  - git
  - GitHub
---

Quarto es una herramienta que te permite generar documentos y reportes de manera muy sencilla utilizando bloques de código de R. En estos reportes puedes incluir tablas, gráficos, y mucho más, de forma atractiva, para poder compartir tus análisis y descubrimientos con otras personas.

Los reportes de Quarto suelen ser en formato PDF o HTML, siendo HTML el formato más recomendado, porque además de ser más compatible, permite ciertos elementos de interacción en tu reporte, como índices, barras de menú, pestañas, selectores, enlaces, y más.

Si tenemos un reporte en formato HTML, el salto a generar un sitio web estático que puedas compartir con otras personas es muy sencillo de hacer.

En esta guía, te explico cómo generar un reporte sencillo con Quarto, y automatizar el proceso para que dicho reporte esté siempre disponible como un sitio web, alojado gratuitamente en [GitHub Pages](https://pages.github.com), que puedes compartir con los demás sabiendo que siempre se mantendrá actualizado cuando tú actualices tu reporte.

**Beneficios:**

-   No necesitas enviar tu reporte como un archivo adjunto
-   No es necesario preocuparse si tu reporte contiene cientos de gráficos o es muy pesado, ya que estará online
-   Si necesitas modificar o actualizar algo de tu reporte, puedes hacer los cambios y actualizar tu reporte cuando quieras
-   Las personas que tengan el enlace tendrán siempre la versión actualizada de tu reporte
-   La publicación de tu reporte es automática: subes los cambios a GitHub y tu reporte se actualizará en unos minutos
-   El alojamiento online de tu reporte es gratuito

----

## Crear un reporte Quarto

New File, Quarto Document
Render

Header
- yaml

Markdown
- negrita, itálica
- líneas separadoras
- enlaces
- imágenes
- html

Chunks

Configuración de Chunks
- echo: false
- mensajes, errores y alertas
- eval: false
- tamaño de figuras
- output: asis

Configuración de Quarto
- índice
- tamaño de figuras
- tipografías
- temas
- self-contained

----

Para hacer esto, necesitamos configurar primero el documento Quarto, subir nuestro documento Quarto a un repositorio de GitHub, y configurar el repositorio para que genere una página web estática a partir del documento. Todas estas instrucciones están detalladas [en esta guía oficial](https://quarto.org/docs/publishing/github-pages.html), pero a continuación te resumo lo principal.

### Nombre del reporte

La configuración del documento Quarto consiste revisar el nombre del archivo, y en agregar un archivo de configuración a nuestro proyecto que hará que se guarden los archivos necesarios en una sola carpeta.

Esto es importante, porque así GitHub Pages sabrá que éste es el documento específico que queremos que sea nuestra página web.

Revisemos el \*nombre del documento Quarto\*\*. Para que nuestro documento Quarto se publique como una página GitHub Pages, debe llamarse `index.qmd` (para que se genere un documento `index.html`), o bien, puede llamarse como queramos, pero agregando el siguiente código al header `yaml` del documento Quarto:

``` yaml
format: 
  html:
    output-file: "index"
```

De este modo, el documento `html` resultante de nuestro documento Quarto se llamará `index.html`.


### Configuración de Quarto

El siguiente paso de configuración implica agregar un **archivo de configuración** al proyecto. En el panel de archivos (*File*) de RStudio, presionamos el botón *New File* y creamos un archivo de texto en blanco, llamado `_quarto.yml`:

{{< imagen "img/quarto_4.png" >}}

En `_quarto.yml`, pegamos el siguiente código de configuración:

``` yaml
project:
  output-dir: docs
```

Con esta configuración le estamos pidiendo Quarto que guarde los recursos que necesita dentro de una carpeta `docs`, que es lo que necesitamos para generar nuestra página web.

Si le damos *render* al documento Quarto, se generará la carpeta `docs` con los recursos necesarios dentro.

### Configuración local de GitHub Pages

Otra configuración que debemos crear para GitHub Pages se hace mediante la creación de un archivo vacío. En el proyecto desde RStudio creamos un nuevo archivo que se llame `.nojekyll`, y que esté vacío. Este archivo es para decirle a GitHub Pages que no procese el sitio con Jekyll, porque del sitio nos encargamos nosotres.

{{< imagen "img/nojekyll.png" >}}


### Subir a GitHub
Ahora tenemos que subir estos cambios al repositorio remoto GitHub. En la pestaña *Terminal* de RStudio (al lado de la consola) ejecutamos los tres siguientes comandos:

``` bash
git add .
git commit -m "documento quarto en docs"
git push
```

Con el primer comando le pedimos que todos los archivos nuevos sean considerados para el *commit*, con el segundo creamos el *commit* y le damos un mensaje, y con el tercero hacemos *push* para subir los cambios al repositorio remoto.

Si vamos a GitHub debiesen estar nuestros nuevos archivos arriba. Ahora vamos a configurar GitHub para que genere una página web a partir del documento Quarto. Vamos a la seccion *Settings*:

{{< imagen "img/quarto_5.png" >}}


### Configuración del repositorio de GitHub para activar Pages
Dentro de *Settings*, en el menú izquierdo vamos a *Pages*. Dentro de *Pages*, tenemos que seleccionar la rama del repositorio que queremos usar (usualmente *main* o *master*), y especificar que queremos apuntar a la carpeta `/docs`. Luego presionamos *Save*.

{{< imagen "img/quarto_6.png" >}}

Se tomará unos segundos o minutos en generar la página web, pero luego aparecerá el siguiente mensaje que te permitirá acceder al sitio:

{{< imagen "img/quarto_7.png" >}}

¡Listo! Ahora puedes compartir tu página con todo el mundo. El enlace será algo como `https://usuario.github.io/repositorio/`

Ojo que con este método sólo podremos publicar un documento Quarto por repositorio.

Puedes ver las instrucciones completas para este proceso [en esta guía oficial.](https://quarto.org/docs/publishing/github-pages.html)


 
----

Si este tutorial te sirvió, por favor considera hacerme una pequeña donación para poder tomarme un cafecito mientras escribo el siguiente tutorial 🥺

{{< cafecito >}}
