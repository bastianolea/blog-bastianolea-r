---
title: 'Reportes y páginas web online con GitHub Pages, R y Quarto'
author: Bastián Olea Herrera
date: '2024-11-18'
slug: []
categories: []
draft: true
format:
  hugo-md:
    output-file: index
    output-ext: md
tags:
  - Quarto
  - git
---


Quarto es una herramienta que te permite generar documentos y reportes de manera muy sencilla utilizando bloques de código de R. En estos reportes puedes incluir tablas, gráficos, y mucho más, de forma atractiva, para poder compartir tus análisis y descubrimientos con otras personas.

Los reportes de Quarto suelen ser en formato PDF o HTML, siendo HTML el formato más recomendado, porque además de ser más compatible, permite ciertos elementos de interacción en tu reporte, como índices, barras de menú, pestañas, selectores, enlaces, y más.

Si tenemos un reporte en formato HTML, el salto a generar un sitio web estático que puedas compartir con otras personas es muy sencillo de hacer.

En esta guía, te explico cómo generar un reporte sencillo con Quarto, y automatizar el proceso para que dicho reporte esté siempre disponible como un sitio web, alojado gratuitamente en GitHub, que puedes compartir con los demás sabiendo que siempre se mantendrá actualizado cuando tú actualices tu reporte.

Beneficios:
- No necesitas enviar tu reporte como un archivo adjunto
- No es necesario preocuparse si tu reporte contiene cientos de gráficos o es muy pesado, ya que estará online
- Si necesitas modificar o actualizar algo de tu reporte, puedes hacer los cambios y actualizar tu reporte cuando quieras
- Las personas que tengan el enlace tendrán siempre la versión actualizada de tu reporte
- La publicación de tu reporte es automática: subes los cambios a GitHub y tu reporte se actualizará en unos minutos
- El alojamiento online de tu reporte es gratuito

------------------------------------------------------------------------

Si este tutorial te sirvió, por favor considera hacerme una pequeña donación para poder tomarme un cafecito mientras escribo el siguiente tutorial 🥺

<div style = "height: 18px;">
</div>
<div>
  <div style="display: flex;
  justify-content: center;
  align-items: center;">
    <script type="text/javascript" src="https://cdnjs.buymeacoffee.com/1.0.0/button.prod.min.js" data-name="bmc-button" data-slug="bastimapache" data-color="#FFDD00" data-emoji="☕"  data-font="Cookie" data-text="Regálame un cafecito" data-outline-color="#000000" data-font-color="#000000" data-coffee-color="#ffffff" ></script>
  </div>
