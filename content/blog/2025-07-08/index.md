---
title: Reduce el tamaño de tus reportes Quarto con este truco
author: Bastián Olea Herrera
date: '2025-07-08'
draft: false
slug: []
categories: []
tags:
  - quarto
  - consejos
excerpt: Si tus documentos Quarto salen pesados por tener muchos gráficos, intenta cambiar en el `YAML` el siguiente argumento para que los gráficos incluidos vayan en formato `.jpg` en vez de `.png`.
---

Consejo: si tus [documentos Quarto](/blog/quarto_reportes/) salen pesados por tener muchos gráficos, intenta cambiar en el `YAML` el siguiente argumento para que los gráficos incluidos vayan en formato `.jpg` en vez de `.png` (por defecto). 

<div style="max-width:390px; margin:auto">

{{< imagen "quarto_yaml-featured.png" >}}

</div>

Las imágenes `.jpg` son más livianas, porque usan compresión, aunque pueden tener un poco menos de calidad y no tienen fondo transparente. Por otro lado, las imágenes `.png` son _lossless_ (no tienen compresión ni pérdida de calidad) y transparencia, pero a cambio son más pesadas.

Acá se nota la diferencia de tamaños entre un mismo reporte con gráficos en `.png` y `.jpg`: **una reducción de un 39,9% en el peso del archivo** con sólo agregar una línea.

<div style="display: flex; margin:auto;">
  <div style="flex: 1; margin: auto; padding: 0px;">
  {{< imagen "quarto_size_a.png" >}}
  </div>
  <div style="flex: 1; margin: auto; padding: 0px;">
  {{< imagen "quarto_size_b.png" >}}
  </div>
</div>
