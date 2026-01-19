---
title: "Actualización del blog: menús, mejoras, y más morado"
author: Bastián Olea Herrera
date: '2025-12-03'
slug: []
categories: []
tags:
  - blog
excerpt: "He estado retocando algunos aspectos de este blog. Quería contarles los principales cambios: tablas de contenido en todas las publicaciones, nuevos _shortcodes_, nuevo tema de colores para bloques de código, resultados de búsqueda con resúmenes de posts, y más."
---

Recientemente he estado retocando algunos aspectos de este blog. Quería contarles los principales cambios: **tablas de contenido** en todas las publicaciones, nuevo **tema de colores para bloques de código**, y **resultados de búsqueda con resúmenes de posts**, y más.

----

### Tablas de contenido en posts

{{< imagen_lateral "indice.png" >}}

Uno de los cambios principales, y que quería hacer hace mucho tiempo, es mostrar un menú con la tabla de contenidos de cada post (títulos y subtítulos) al lado del texto, para facilitar la navegación. Este tipo de menú aparecen por defecto en los documentos y blogs Quarto, pero no en los de Hugo. Así que tuve que hacer algunos ajustes en el tema que uso.




{{< detalles "**Más detalles sobre cómo lo hice**" >}}

Tuve que cambiar la plantilla (_layout_) de los posts a `single-sidebar` en el _front matter_ del blog (`content/blog/_index.md`), y luego personalizar el _sidebar_ para que tenga etiquetas y la tabla de contenidos (que se agrega con `{{ $page.TableOfContents }}` en Hugo). 

En concreto, el código que agregué al _sidebar_ revisa que el post tenga títulos, de lo contrario no tiene sentido mostrar un índice, y si los tiene, mostrarlo con un estilo y atributos determinados. El código es:

```html
<!-- índice de la página -->
{{ $headers := findRE "<h[2].*>" $page.Content }}
{{- $has_headers := ge (len $headers) 1 -}}
{{- if $has_headers -}}
  <div id="PageTableOfContents", style="margin-top: 24px; position: sticky; top: 108px;">
      <div class="blog-info ph4 pb4 pb0-l">
      <h3 style="margin-bottom: 12px;">Índice:</h3>
        <div class="pl2 pr0 mh0" style = "font-size: 90%; margin-top: -8px; margin-left: -22px; margin-bottom: 32px;">
          {{ $page.TableOfContents }}
        </div>
      </div>
  </div>
{{ end }}
```

Para hacer la tabla de contenido flote mientras las personas hacen scroll en el sitio simplemente tuve que agregarle `position: sticky;` en el estilo CSS de la tabla.

También agregué las etiquetas a esta barra lateral, para que las personas que lean puedan ir saltando a otras temáticas. Las etiquetas las tengo guardadas como un _partial_, así que las puedo agregar en cualquier parte del sitio con tan sólo poner `{{ partial "shared/tags-wide.html" . }}` o  `{{ partial "shared/tags-long.html" . }}, dependiendo de si las quiero hacia el lado o hacia abajo.

Antes de implementar ésto estaba usando un _shortcode_ que agregaba un índice o tabla de contenidos al principio de las publicaciones, así que ahora hice que estos índices estuvieran cerrados por defecto, ya que se hicieron un poco redundantes. El _shortcode_ para el índice es casi igual que el código del índice en la sidebar:

```html
<div style = "margin-left: -16px;">
  <details {{.Get 2 | default "closed"}} id="PageTableOfContents">
    <summary>
      <h2 class="mv0 f5 fw7 ttu tracked dib" style = "margin-left: 6px; font-size: 120%;">Índice</h2>
      </summary>
    <div class="pl2 pr0 mh0" style = "font-size: 90%; margin-top: -8px; margin-left: 16px; margin-bottom: 32px;">
    {{ .Page.TableOfContents }}
    </div>
  </details>
</div>
```

{{< /detalles >}}


----

### Detalles!

¡¿Qué fue eso?! 😟 Un nuevo _shortcode_ llamado `detalles`! Así puedo agregar secciones de contenido que están ocultas por defecto, y que se pueden expandir o contraer al hacer clic en un botón. Así no es necesario marearlos con cosas siempre, y puedo esconder las cosas menos interesantes!

{{< detalles "**Detalles sobre los detalles**" >}}

El _shortcode_ es demasiado sencillo:

```html
<details>
  <summary>
    {{ (.Get 0 | default "**Ver código**") | markdownify }}
  </summary>
  <p>
    {{ .Inner | markdownify }}
  </p>
</details>
```

Solamente ese código guardado en `layouts/shortcodes/detalles.html`, y se usa poniendo el _shortcode_ de apertura y después uno de cierre con un `/` antes de la palabra _detalles_.

{{< /detalles >}}

----

### Mejoras al buscador
También mejoré el [buscador de mi blog](https://bastianolea-buscador.share.connect.posit.cloud), que es [una aplicación Shiny](https://bastianolea.rbind.io/blog/buscador/), para que sea un poquito más rápido, pero principalmente para que los resultados de búsqueda contengan un **resumen de cada publicación**. Más información sobre el buscador [en este post](https://bastianolea.rbind.io/blog/buscador/).

{{< detalles "**Más detalles sobre cómo lo hice**" >}}

Para esto, tuve que cambiar un poco la configuración de Hugo para que genere una versión del blog en JSON, agregándole que también incluya los textos de resumen o _excerpt_. 

Siguiendo las [instrucciones que di antes](https://bastianolea.rbind.io/blog/buscador/), en el archivo `layouts/index.json` hay que agregarle `"excerpt" (default $page.Summary $page.Params.excerpt)` para que registre ese atributo de cada post en el archivo JSON, que se regenera con cada compilación (_build_) del sitio.

Luego simplemente actualizar la app para que agregue ese texto, previamente interpretado como _markdown_ con la función `shiny::markdown()`.


{{< /detalles >}}

<br>

{{< boton "Buscador" "https://bastianolea-buscador.share.connect.posit.cloud" "fas fa-search" >}}

----

### Nuevo sitio: Aprende R

{{< imagen_lateral "aprende_r.png" >}}

Como ya se estaban acumulando muchos tutoriales sobre R en este blog, quise hacer un [sitio nuevo](https://bastianolea.github.io/aprende_r/) donde pudiera organizar todo, para que cualquier persona entre a [este sitio](https://bastianolea.github.io/aprende_r/) y encuentre **todo lo necesario para aprender R**, ya sean contenidos hechos por mí o por otras personas. [Más información sobre el sitio Aprende R en este post](https://bastianolea.rbind.io/blog/aprender_r/).

{{< boton "Aprende R" "https://bastianolea.github.io/aprende_r/" "fas fa-book" >}}

----

### Nueva etiqueta "básico"
Siguiendo la idea de organizar el **contenido para principiantes**, agregué una nueva [etiqueta](/tags/) a las publicaciones sobre [contenido básico de R](/tags/básico/).

----

### Más morado!
Otro cambio que tenía pendiente desde el inicio de este blog era usar un **tema para el código** (_syntax highlighting_) que combinara mejor con los colores del blog. Por fin me dediqué a hacerlo, y fue más fácil de lo que yo pensaba. Ahora el tema del código en este blog y el [tema morado que uso en RStudio](https://bastianolea.rbind.io/blog/tema_morado/) son iguales 💜

```r
"miren lo" |> 
  hermoso() # que quedó
  list(TRUE, "maravilloso", 100, 🔥)
  "el"; tema() -> morado !!
```

{{< detalles "**Detalles sobre cómo lo hice**" >}}

El tema del código del blog Hugo se puede cambiar en `config.toml`, pero las opciones de colores [son limitadas](https://xyproto.github.io/splash/docs/).

Para poder crear tu propio tema de _syntax highlighting_ primero tienes que cambiar la opción para que cada elemento de tu código use una clase CSS específica:

```toml
[markup]
  defaultMarkdownHandler = "goldmark"
  [markup.highlight]
    style = "rose-pine-moon"
    noClasses = false 
```

Al especificar `noClasses = false`, el texto de los bloques de código pasa a tener clases CSS distintas para cada elemento del código (comentarios, cadenas de texto, palabras reservadas, etc.). 

Luego, tienes que crear un archivo CSS donde definas los colores que quieres para cada clase, a partir de uno de los temas existentes, ejecutando el siguiente código en la Terminal:

```bash
hugo gen chromastyles --style=rose-pine-moon > syntax.css
```

Con esto se crea el archivo `syntax.css`, que puedes editar para cambiar los colores. Para saber la clase de cada elemento del código, usas el inspector del navegador:

{{< imagen_tamaño "inspector.png" "300px">}}

Finalmente tienes que poner el archivo CSS en la carpeta `static/css/syntax.css`, y cargarlo en todas las páginas del blog agregando `<link rel="stylesheet" href="/css/syntax.css">` al archivo `layouts/partials/head.html` (si no lo tienes, lo copias desde la carpeta del tema).

{{< /detalles >}}

Me hace muy feliz que todo se vea tan bonito, y si quieren su RStudio también puede verse así de cute 💕

{{< boton "Tema morado para RStudio" "https://bastianolea.rbind.io/blog/tema_morado/" "fas fa-brush" >}}


----

Eso por ahora! Recuerda que siempre puedes escribirme por [LinkedIn](https://www.linkedin.com/in/bastianolea/), Twitter a [@bastimapache](https://x.com/bastimapache), o [por correo](/contacto/).

