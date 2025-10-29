---
title: Crea una carpeta inteligente con todos tus proyectos de R en Mac
author: Bastián Olea Herrera
date: '2025-10-29'
slug: []
categories: []
tags:
  - consejos
format:
  hugo-md:
    output-file: index
    output-ext: md
excerpt: "Si eres usuario/a de macOS y de R, aquí va un truquito para facilitar tu trabajo: crear un ícono en tu Dock que muestre todos tus proyectos de R, para poder acceder a ellos más rápido."
---

Si eres usuario/a de macOS y de R, aquí va un truquito para facilitar tu trabajo.

En el Finder puedes crear **carpetas inteligentes**, que muestran automáticamente archivos que cumplen ciertos criterios, intependiente de donde estén en tu computador. Básicamente son carpetas que guardan resultados de búsqueda que se mantienen actualizados. 

Con esto podemos crear una carpeta que muestre todos tus proyectos de R, para poder acceder a ellos más rápido.

En el Finder, vamos a _Archivo_ y creamos una nueva carpeta inteligente.

{{< imagen "rproj_paso_2.png" >}}

En la barra de búsqueda, escribimos `Rproj`, que es la extensión de los proyectos de R, y especificamos _El nombre contiene..._ para sólo buscar nombres de archivo que coincidan (y no, por ejemplo, archivos de texto que contengan esa palabra). 

Luego, en la barra de arriba, seleccionamos "Este Mac" si queremos buscar en todo el computador, o elegimos otra carpeta si queremos restringir la búsqueda.

{{< imagen "rproj_paso_3.png" >}}

En este punto ya debería aparecer el resultado dentro de la carpeta. Para guardar esta carpeta inteligente, hacemos clic en el botón _Guardar_ en la esquina superior derecha, y elegimos dónde guardarla.

{{< imagen "rproj_paso_1.png" >}}

Finalmente podemos agregar la carpeta al Dock para tener un acceso rápido a todos los proyectos de R, y si hacemos clic derecho podemos especificar que se ordenen por **fecha de modificación**, que aparezcan como **abanico**, y que el ícono se vea como **carpeta**.

{{< imagen "rproj_paso_4_featured.png" >}}