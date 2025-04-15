---
title: "Tutorial Quarto: presenta los resultados de tus análisis de datos con R creando reportes y documentos Quarto"
author: Bastián Olea Herrera
format: hugo-md
date: '2025-04-14'
draft: false
slug: []
categories: 
  - Tutoriales
tags:
  - quarto
excerpt: "Quarto es una herramienta que te permite generar documentos y reportes de manera muy sencilla utilizando bloques de código de R. En estos reportes puedes incluir tablas, gráficos, y mucho más, de forma atractiva, para poder compartir tus análisis y resultados con otras personas. Aprender a generar documentos Quarto es una herramienta que puede llevar tus habilidades de análisis de datos al siguiente nivel!"
---

Quarto es una herramienta que te permite generar documentos y reportes de manera muy sencilla utilizando bloques de código de R. En estos reportes puedes incluir tablas, gráficos, y mucho más, de forma atractiva, para poder compartir tus análisis y resultados con otras personas.

<div style="padding:18px;padding-bottom:1px;padding-top:1px;background-color:#493365;color:#E9DDEE;border-radius:6px;margin:20px;margin-top:40px;margin-left:40px;margin-right:40px;font-size:100%;">
&#10;Puedes leer este mismo tutorial directamente desde un reporte Quarto [**en este enlace**](/reportes/quarto_clase_1.html), y también puedes ver un documento de ejemplo hecho siguiendo los pasos de este totiral [en este otro enlace](/reportes/quarto_clase_1b.html).
&#10;</div>

## Crear un reporte Quarto

En RStudio, crear un nuevo archivo desde *New File*, y elegir *Quarto Document*.

Cuando hagamos los cambios que deseemos, presionamos el botón *Render* para generar el reporte a partir del código. El reporte se abre en el visor *Viewer*, y queda guardado como un archivo `.html` para abrirlo con un navegador web.

## Markdown

Markdown es el formato de escritura usado en Quarto. Permite escribir texto enriquecido a aprtir de texto plano (código), usando síbolos de marcado para definir el estilo del texto. Más información [en esta guía](https://quarto.org/docs/authoring/markdown-basics.html)

Algunos de los estilso básicos que puedes darle al texto:

``` markdown
**negrita**
*itálica* o _itálica_
<u>subrayado</u>
~~tachado~~
`código`
```

Resultarían en lo siguiente:

<div style = "line-height: 6pt;">
&#10;**negrita**
&#10;*itálica*	o _itálica_
&#10;<u>subrayado</u>
&#10;~~tachado~~
&#10;`código`
&#10;</div>

### Otras posibilidades

Puedes insertar **separadores** escribiendo cuatro guiones. Estos resultan en una línea vertical, como la de encima del subtítulo anterior.

``` markdown
----
```

Para agregar un **enlace** en markdown, escirbimos el texto del enlace entre corchetes, y luego el enlace enter paréntesis:

    [Texto](http://enlace.cl)

El [enlace se vería así](http://enlace.cl).

Para agregar una **nota al pie** se escribe el número de la nota entre corchetes, antecedido por el símbolo de superíndice o potencia `^`.

Ejemplo de una nota al pie[^1]. También se puede agregar directamente en el texto[^2].

``` markdown
Agregar una nota al pie[^1].
[^1]: Esta es una nota al pie
```

``` markdown
También se puede agregar directamente en el texto^[De esta forma].
```

------------------------------------------------------------------------

## Configuración básica

Los documentos Quarto se configuran principalmente desde su encabezado o *header*. Éste es el código que se encuentra en las primeras líneas, escrito entre tres guiones (`---`). Este código está escrito en `yaml`, y permite configurar casi todos los aspectos de apariencia del documento.

### Títulos

Puedes cambiar el título del documento en la etiqueta `title`.

``` yaml
---
title: "Probando"
lang: es
---
```

También puedes agregar autoría y fecha, simplemente agregando las configuraciones debajo de las existentes:

``` yaml
---
author: "Bastián Olea Herrera"
date: 2025-04-01
lang: es
---
```

Puedes cambiar el texto que aparece arriba de alguna de las etiquetas. Sugiero buscar en internet este tipo de cosas, ya que Quarto tiene muy buena documentación.

``` yaml
lang: es
language: 
  title-block-author-single: "Creado por"
```

Puedes personalizar el titular del documento con estas etiquetas:

``` yaml
title-block-banner: "#f0f3f5"
title-block-banner-color: "black"
```

Para más información sobre el bloque titular, [revisar esta guía.](https://quarto.org/docs/authoring/title-blocks.html)

{{< imagen “quarto_header.png” >}}

### Índices o tablas de contenido

A medida que agregas títulos markdown, puedes agregar una tabla de contenidos que se actualizará automáticamente con los títulos que vayas agregando. Para más información, [revisa esta otra guía](https://quarto.org/docs/output-formats/html-basics.html#table-of-contents).

Activa la tabla de contenidos reemplazando el `format` de tu documento por uno personalizable:

``` yaml
format:
  html
    toc: true
```

Personaliza el nivel de titulares que aparecen en la tabla de contenidos con `toc-depth`, y puedes hacer que las secciones se numeren automáticamente con `number-sections`.

``` yaml
format:
  html
    toc: true
    number-sections: true
    toc-expand: 2
```

También poner enlaces debajo del índice, por ejemplo a tu sitio web o redes sociales. Los enlaces pueden tener un [ícono personalizado](https://quarto.org/docs/output-formats/html-basics.html#code-links-and-other-links).

``` yaml
format:
  html:
    other-links:
      - text: Enlace 1
        href: https://data.nasa.gov/
      - text: Enlace 2
        icon: file-code
        href: https://data.nasa.gov/
```

<img src="quarto_toc.png" style="border-radius: 7px; max-height: 360px; display: block; margin: auto; margin-bottom: 8px; margin-top: 8px;">

### Temas

Configura el tema de tu reporte para cambiar su apariencia completa, incluyendo colores, espaciados, tipografías y más. Revisa la [lista de temas en este enlace](https://quarto.org/docs/output-formats/html-themes.html).

Tan solo agregando `theme` y el nombre del tema (de la [lista de temas](https://quarto.org/docs/output-formats/html-themes.html)) cambiarás la apariencia completa de tu reporte.

``` yaml
theme: darkly
```

Personaliza la tipografía y el tamaño global de las letras:

    mainfont: Courier
    fontsize: "20px"

{{< imagen “quarto_themes.png” >}}

### Autocontenido

Los reportes Quarto son archivos web, y como tales requieren de dependencias externas, como scripts, estilos e imágenes, que se guardan como archivos. Éstos se guardan en una carpeta con el mismo nombre de tu reporte. Pero esto puede resultar inconveniente para compartir los documentos, además de generar desorden. Para que el documento no tenga dependencias externas, sino que sea portable y auto-contenido en un sólo archivo `.html`, podemos hacer que el reporte contenga todas sus dependencias dentro de sí agregando lo siguiente al `format` de nuestro documento:

``` yaml
format:
  html:
    embed-resources: true
```

Recomiendo siempre usar esta opción, a pesar de que puede generar archivos más pesados.

------------------------------------------------------------------------

## Disposición

Veamos algunas formas de personalizar la disposición de los reportes, como columnas, pestañas y contenido en los márgenes. Para más información, consulta [esta guía oficial](https://quarto.org/docs/output-formats/html-basics.html)

### Columnas

Para escribir contenido en columnas, debes crear un *bloque* (`::::`) con el estilo `.columns`, y dentro de él, crear dos secciones con el estilo `.column` indicando el porcentaje del ancho que tomarán:

``` markdown
:::: {.columns}

::: {.column width="40%"} 
Columna izquierda
:::

::: {.column width="60%"}
Columna derecha
:::

::::
```

{{< imagen “quarto_cols.png” >}}

Si quieres agregar un espacio entre ambas columnas, crea una columna vacía que sea más delgada:

``` markdown
:::: {.columns}

::: {.column width="40%"} 
Columna izquierda
:::

::: {.column width="5%"} 
:::

::: {.column width="55%"}
Columna derecha
:::

::::
```

### Pestañas

Para poner [contenido dentro de pestañas](https://quarto.org/docs/output-formats/html-basics.html#tabsets), crea un bloque con el estilo `.panel-tabset`, y dentro de éste, todos los títulos markdown que pongas (`##`, `###`, etc.) aparecerán en su propia pestaña:

``` markdown
::: {.panel-tabset}

## Pestaña 1
Contenido de la pestaña 1

## Pestaña 3
Contenido de la pestaña 2

## Pestaña 3
Contenido de la pestaña 3
:::
```

Si usas como estilo `{.panel-tabset .nav-pills}`, los botones de las pestañas aparecerán rellenados.

{{< imagen “quarto_tabs.png” >}}

### Contenido al margen

Puedes agregar cualquier contenido en los márgenes del documento, como fórmulas, aclaraciones, o incluso tablas y gráficos, usando un bloque con el estilo `.aside`:

``` markdown
::: {.aside}
\
Esto es un ejemplo. Esto es un ejemplo. Esto es un ejemplo. Esto es un ejemplo. Esto es un ejemplo. Esto es un ejemplo. Esto es un ejemplo. Esto es un ejemplo. Esto es un ejemplo. 
:::
```

<img src="quarto_aside2.png" style="border-radius: 7px; max-width: 300px; display: block; margin: auto; margin-bottom: 8px; margin-top: 8px;">
<img src="quarto_aside.png" style="border-radius: 7px; max-width: 300px; display: block; margin: auto; margin-bottom: 8px; margin-top: 8px;">

------------------------------------------------------------------------

## Código

La gracia de Quarto es combinar código con texto. Para agregar código, creamos bloques o *chunks*, en los que podemos escribir código de R, y sus resultados aparecerán en el documento.

``` r
library(ggplot2)

iris |> 
  ggplot() +
  aes(x = Sepal.Length, y = Sepal.Width) +
  geom_point(color = "purple4", alpha = 0.4, size = 4) +
  theme_minimal()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-1-1.png" width="672" />

Si queremos que no aparezca el código, y sólo aparezca el output, agregamos `#| echo: false` al inicio del bloque. De este modo sólo saldrá el resultado del código, sin el código mismo. Por ejemplo, si en un bloque pongo `head(iris)` pero agrego antes `#| echo: false`, sólo saldrá el resultado, sin el código:

    ##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
    ## 1          5.1         3.5          1.4         0.2  setosa
    ## 2          4.9         3.0          1.4         0.2  setosa
    ## 3          4.7         3.2          1.3         0.2  setosa
    ## 4          4.6         3.1          1.5         0.2  setosa
    ## 5          5.0         3.6          1.4         0.2  setosa
    ## 6          5.4         3.9          1.7         0.4  setosa

Algunas funciones u operaciones en R entregan mensajes además del resultado esperado. Por ejemplo, cuando ocurren *warnings*. Para omitir que los bloques impriman mensajes y/o alertas, agregamos `#| message: false` y `#| warning: false` respectivamente.

``` r
library(dplyr)
```

Para configurar el tamaño de los gráficos, agregamos al bloque las opciones `#| fig-width: 4` y/o `#| fig-height: 6` para modificar el ancho o alto, respectivamente. Por defecto, los gráficos son de 7 x 5.

``` r
iris |> 
  ggplot() +
  aes(x = Sepal.Length, y = Sepal.Width) +
  geom_point(color = "orange", alpha = 0.4, size = 4) +
  theme_minimal()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-1.png" width="384" />

### Código entre el texto

Para integrar código en el texto de los párrafos de tu reporte, por ejemplo, para insertar una cifra, escribimos comillas invertidas (`` ` ``), la letra `r`, y el código cuyo output queremos que aparezca en el documento:

{{\<imagen “quarto1.png” >}}

De esta forma podemos agregar texto que proviene desde nuestros datos: el dataset `iris` tiene 5 variables que describen 3 especies de plantas.

{{\<imagen “quarto2.png” >}}

------------------------------------------------------------------------

Aprender a generar documentos Quarto es una herramienta que puede llevar tus habilidades de análisis de datos al siguiente nivel. Con Quarto puedes presentar tu resultado de forma mucho más atractiva, pero también puedes aprender a automatizar muchísimo trabajo relacionado a reportabilidad.

Si quieres seguir aprendiendo Quarto, por ejemplo a automatizar reportes con documentos Quarto parametrizado, o a generar contenido automáticamente para tus reportes usando loops, [revisa las siguientes publicaciones de este blog en la etiqueta Quarto!](/tags/quarto/)

{{< cafecito >}}

[^1]: Nota al pie.

[^2]: De esta forma
