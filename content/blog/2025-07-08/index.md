---
title: Reduce el tamaño de tus reportes Quarto con este truco
author: Bastián Olea Herrera
date: '2025-07-08'
draft: true
slug: []
categories: []
tags:
  - quarto
  - consejos
---

Consejo: si tus documentos Quarto salen muy pesados por tener muchos gráficos, intenta cambiar en el `YAML` el siguiente argumento para que los gráficos incluidos vayan en formato `.jpg` en vez de `.png` (por defecto). Las imágenes `.jpg` son más livianas, aunque pueden tener un poco menos de calidad y no tienen fondo transparente.

<div style="max-width:390px; margin:auto">

{{< imagen "quarto_yaml.png" >}}

</div>

Acá se nota la diferencia de tamaños entre un mismo reporte con gráficos en `.png` y `.jpg`.

<div style="display: flex; margin:auto;">
  <div style="flex: 1; margin: auto; padding: 0px;">
  {{< imagen "quarto_size_a.png" >}}
  </div>
  <div style="flex: 1; margin: auto; padding: 0px;">
  {{< imagen "quarto_size_b.png" >}}
  </div>
</div>
