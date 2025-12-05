---
title: Procesa datos con R sin programar y de forma interactiva
author: Bastián Olea Herrera
date: '2025-12-05'
slug: []
categories: []
draft: false
tags:
  - curiosidades
  - básico
format:
  hugo-md:
    output-file: index
    output-ext: md
excerpt: "El paquete de R `{blockr}`](https://bristolmyerssquibb.github.io/blockr/) nos ofrece una interfaz gráfica interactiva para poder usar R sin escribir código. Como su nombre lo indica, funciona por medio de bloques que se conectan entre sí, representando de forma visual el flujo de procesamiento de datos. En esta guía te muestro un ejemplo de su uso!"
links:
  - icon: registered
    icon_pack: fas
    name: Paquete
    url: https://bristolmyerssquibb.github.io/blockr/
  - icon: youtube
    icon_pack: fab
    name: Presentación
    url: "https://www.youtube.com/live/H4eheaXZKzs?si=FTo8q_sXCCjV-hBw&t=4394"
---

Viendo el streaming de la [conferencia LatinR 2025](https://www.youtube.com/watch?v=H4eheaXZKzs) conocí el [paquete de R `{blockr}`](https://bristolmyerssquibb.github.io/blockr/), que nos ofrece una interfaz gráfica interactiva para usar R **sin escribir código**. 

{{< imagen "blockr_12.jpg" >}}

Como su nombre lo indica, funciona por medio de **bloques** que se conectan entre sí, representando de forma visual el flujo de procesamiento de datos.

Esta herramienta puede servirle a gente que esté aprendiendo R y quizás les sirva empezar por lo práctico antes de entrar al código. También puede ser útil para personas que les cueste programar en R, o que tengan alguna dificultad para escribir código, o bien, para quienes quieran esbozar un proceso antes de escribirlo.



## Empezar

Para empezar a usarlo, primero hay que instalar el paquete. Se requiere tener el paquete `{pak}` instalado, y luego usarlo para instalar `{blockr}`:

```r
# install.packages("pak")
pak::pak("BristolMyersSquibb/blockr")
```

Una vez instalado, lo cargamos y ejecutamos la interfaz gráfica:

```r
library(blockr)
run_app()
```

{{< imagen "blockr_1.jpg" >}}

La interfaz empieza como un lienzo vacío, al cual hay que **agregar bloques**.

Les voy a mostrar un ejemplo sencillo, pero recomiendo [seguir las instrucciones oficiales](https://bristolmyerssquibb.github.io/blockr/getting-started.html), que son bien completas.

Al agregar un bloque, se nos abre un panel donde escribimos lo que necesitamos:

{{< imagen "blockr_2.jpg" >}}


## Cargar datos
Para partir, agregamos un bloque de **carga de datos**. Podemos cargar datos desde un archivo local, importarlos a `{blockr}` para que el paquete los guarde, o bien usar datos de ejemplo.

{{< imagen_tamaño "blockr_3.png" "60%">}}

Al elegir el bloque, éste aparece en el lienzo, y en el panel derecho aparecen las opciones, que son equivalentes a los _argumentos_ de las funciones en R: 

{{< imagen "blockr_4.jpg" >}}

Pero además tiene otros beneficios: por ejemplo, el bloque de carga de datos detecta automáticamente el tipo de datos que vamos a cargar, simplificando un poco el proceso de tener que encontrar un paquete y una función específicas.

Una vez que tenemos un bloque, le agregamos (_append_) una conexión a un nuevo bloque:

{{< imagen_tamaño "blockr_4.png" "220px">}}

## Manipular datos

Vamos a hacer una **selección de columnas** para acotar el conjunto de datos:

{{< imagen_tamaño "blockr_5.png" "60%">}}

El bloque de la acción nueva aparece conectado a los datos, y en el panel derecho elegimos las columans y vamos previsualizando los datos en tiempo real:

{{< imagen "blockr_6.png" >}}

Luego podemos **agregar un filtro**, para elegir las filas de la tabla. La interfaz va sugiriendo variables y columnas en todo momento:

{{< imagen "blockr_7.png" >}}


### Crear y transformar columnas
Ahora vamos a **transformar algunas** columnas:

{{< imagen_tamaño "blockr_8.png" "60%" >}}

Al transformar columnas, nos encontramos con una interfaz parecida a la de `mutate()`, donde vamos definiendo nuevas columnas a partir de las existentes. Pero en este punto ya es necesario ir aplicando un poquito de código. En este caso, redondeamos los valores de una columna.

Así va quedando nuestro flujo hasta ahora:

{{< imagen_tamaño "blockr_8b.png" "180px" >}}

Ahora vamos a **guardar** el tablero que hemos ido trabajando. Para guardar se aprieta la barra negra que está al costado derecho de la aplicación y aparece una barra lateral con opciones para guardar y cargar (_browse_) tableros:

{{< imagen_tamaño "blockr_9.png" "300px">}}


## Visualizar datos
Para ir finalizando, [crearemos un gráfico con `{blockr}`](https://bristolmyerssquibb.github.io/blockr/showcase/ggplot.html) basado en `{ggplot2}`. Para ello, agregamos un **bloque de gráfico**:

{{< imagen_tamaño "blockr_10.png" "70%">}}

Nos encontramos con un panel donde podemos elegir el tipo de gráfico que queremos, y seleccionamos las columnas que vamos a aplicar a cada aspecto del gráfico. En este sentido se parece un poco a [`{esquisse}`, paquete para hacer gráficos de forma interactiva](https://dreamrs.github.io/esquisse/).

{{< imagen_tamaño "blockr_11.png" "60%">}}

Obtenemos un gráfico básico, que acá podemos ver junto al flujo de procesamiento de datos que lo genera. Es interesante poder ir agregando bloques para obtener _caminos_ separados en el flujo, que luego puedes reordenar o reconectar entre sí.

{{< imagen "blockr_12.jpg" >}}

## Exportar código

Finalmente, podemos **exportar el código R** que genera todo el flujo de procesamiento de datos y gráficos que hemos creado. Esto es súper útil, porque nos permite aprender a programar en R viendo el código que genera cada bloque, y luego obtener el código para continuar o mejorar el análisis fuera de `{blockr}`.

Entramos al panel lateral y elegimos _show code_:

{{< imagen_tamaño "blockr_13.png" "300px">}}

Se abre una ventana con el código R completo que genera todo el flujo de procesamiento de datos y gráficos que hemos creado:

{{< imagen "blockr_14.png" >}}


Me parece una alternativa bien interesante para usar R! Tiene harto potencial para aprender, explorar, y enseñar de una manera más liviana e interactiva, con miras a luego profundizar usando el lenguaje.

----

## Video


Mira el video de la presentación en LatinR para saber más:

<div style="margin:auto; text-align: center;">
<iframe width="90%" height="315" src="https://www.youtube-nocookie.com/embed/H4eheaXZKzs?si=UR9sHkiJRXpZxGWt&amp;start=4394" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</div>

----

### Otros recursos
- [`{esquisse}`, paquete de R para hacer gráficos de forma interactiva](https://dreamrs.github.io/esquisse/).
- [DisplayR, servicio online para programar dashboards analíticos con R sin necesidad de usar código](https://www.displayr.com), que además tiene varios [ejemplos](https://www.displayr.com/dashboard-examples/) de productos.

