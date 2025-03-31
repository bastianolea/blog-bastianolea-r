---
title: "Tutorial Quarto: presenta los resultados de tus análisis en R con documentos Quarto"
author: Bastián Olea Herrera
date: '2025-03-30'
draft: true
slug: []
categories: []
tags:
  - quarto
---

Quarto es una herramienta que te permite generar documentos y reportes de manera muy sencilla utilizando bloques de código de R. En estos reportes puedes incluir tablas, gráficos, y mucho más, de forma atractiva, para poder compartir tus análisis y resultados con otras personas.


## Crear un reporte Quarto

New File, Quarto Document
Render

## Header
- yaml


### Título

```
title-block-banner: "#f0f3f5"
title-block-banner-color: "black"
```

Markdown
- negrita, itálica
- líneas separadoras
- enlaces
- imágenes
- html


Format	Code	Result
bold	**hello**	hello
italic	*hello*	hello
underline	<u>hello</u>	hello
strikethrough	~~hello~~	hello
code	`hello`	hello

### Separadores
```
----
```

### Enlaces
```
[Texto](http://enlace.cl)
```

### Notas al pie
```
This statement requires further illumination[^1].
[^1]: Texto al pie de la página
```

```
For instance, here is one attached to the word carrot^[The carrot (Daucus
carota subsp. sativus) is a root vegetable, typically orange in color].
```



### Pestañas
```
::: {.panel-tabset .nav-pills}

## Scatterplot
Content that will show under first tab

## Boxplot
Content that will show under first tab

## Barplot
Content that will show under first tab
:::
```
También puede ser solo `::: {.panel-tabset}`


### Columnas
```
:::: {.columns}
::: {.column width="40%"} Left column
:::
::: {.column width="60%"}
Right column
:: :
```



## Chunks


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


### Índices o tablas de contenido
```yaml
toc: true
number-sections: true
```

### Self-contained
```
html:
  embed-resources: true
```

## avanzado
### css

```
css: style.css
```

```
h1, .h1, h2, .h2, h3, .h3 {
    margin-top: 84px;
}
```

###Viñetas debajo de figuras
```
#| fig.cap = "Figure: Here is a really important caption."
```


### Enlaces internos

```
# Data wrangling {#section-2}
```

```
Here is the link to the [section 2](#section-2) of the document!
```

### Ocultar código

```
format:
  html:
    code-fold: true
    code-summary: "Show the code"
```


Contenido en los márgenes

```
::: {.column-margin}

Hi! I'm a side note!

:::
```

```
```{r}
#| column: margin

knitr::kable(
  mtcars[1:3, 1:3]
)
```
```


