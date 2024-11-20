---
title: 'Reportes y páginas web online con GitHub Pages, R y Quarto'
author: Bastián Olea Herrera
date: '2024-11-18'
slug: []
categories: []
format: hugo-md
draft: true
tags:
  - Quarto
  - git
---


Quarto es una herramienta que te permite generar documentos y reportes de manera muy sencilla utilizando bloques de código de R. En estos reportes puedes incluir tablas, gráficos, y mucho más, de forma atractiva, para poder compartir tus análisis y descubrimientos con otras personas.

Los reportes de Quarto suelen ser en formato PDF o HTML, siendo HTML el formato más recomendado, porque además de ser más compatible, permite ciertos elementos de interacción en tu reporte, como índices, barras de menú, pestañas, selectores, enlaces, y más.

Si tenemos un reporte en formato HTML, el salto a generar un sitio web estático que puedas compartir con otras personas es muy sencillo de hacer.

En esta guía, te explico cómo generar un reporte sencillo con Quarto, y automatizar el proceso de qué dicho reporte esté siempre disponible como un sitio web, alojado gratuitamente en GitHub, que puedes compartir con los demás sabiendo que siempre se mantendrá actualizado cuando tú actualices tu reporte.

Beneficios:
- No necesitas enviar tu reporte como un archivo adjunto
- No es necesario preocuparse si tu reporte contiene cientos de gráficos o es muy pesado, ya que estará online
- Si necesitas modificar o actualizar algo de tu reporte, puedes hacer los cambios y actualizar tu reporte cuando quieras
- Las personas que tengan el enlace tendrán siempre la versión actualizada de tu reporte
- La publicación de tu reporte es automática: subes los cambios a GitHub y tu reporte se actualizará en unos minutos
- El alojamiento online de tu reporte es gratuito
