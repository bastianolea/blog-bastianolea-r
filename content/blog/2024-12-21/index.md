---
title: 'Novedades: app de temperaturas extremas, actualizaciones de otras apps'
author: Bastián Olea Herrera
date: '2024-12-21'
slug: []
categories: []
tags:
  - blog
---

Resumen de las actualizaciones recientes de mis trabajos. Recientemente lancé un [visualizador de temperaturas extremas de Chile](https://bastianolea.rbind.io/apps/temperaturas_chile/), que permite ver gráficamente los efectos del calentamiento global medidas por las estaciones meteorológicas del país. Además, actualicé los datos del [visualizador de delincuencia](https://bastianolea.rbind.io/apps/delincuencia_chile/), que ahora tiene datos hasta septiembre de 2024, y también del [visualizador de femicidios](https://bastianolea.rbind.io/apps/femicidios_chile/), que también ahora tiene datos hasta la fecha.

En paralelo, otra aplicación que se actualiza frecuentemente es la de [análisis de prensa](https://bastianolea.rbind.io/apps/prensa_chile/), que se actualiza todos los lunes o martes de la semana con las noticias hasta el domingo anterior; es decir, muestra los datos de la última semana completa hacia atrás (esto porque el visualizador es de datos semanales, no diarios, entonces tienen que estar terminadas las semanas para poder incluirlas en el análisis, de lo contrario las semanas aparecerían con menos datos).


----

**Actualización:** [visualizador de delitos](https://bastianolea.rbind.io/apps/delincuencia_chile/), ahora con datos hasta septiembre de 2024 📈 Explora la evolución de la delincuencia en cualquier comuna o región de Chile, y analiza el fenómeno de la inseguridad desde datos oficiales.

Recuerda que todas las apps que hago son de código abierto, y en sus repositorios incluyo los datos para que puedas reusarlos en tus propios análisis!

----

**Nuevo:** [Visualizador de temperaturas extremas en Chile](https://bastianolea.rbind.io/apps/temperaturas_chile/) 🌤️🔥

Consulta datos históricos de temperaturas extremas en el país, desde 1970 hasta 2024, y visualiza los cambios históricos en las temperaturas producto de la crisis climática 😞

Este proyecto parte por dos razones: porque quería reutilizar los datos publicados en la plataforma de Datos Abiertos del Estado (muy recomendable, pero también requiere de muchas mejoras), y porque genuinamente tenía curiosidad sobre la evolución en las temperaturas que estamos viviendo. 

Me tardé solamente la tarde del domingo en hacer el scraping de datos, y parte del domingo y la mañana del lunes en hacer el dashboard. Desarrollar este tipo de proyectos con R es realmente rápido!

Lo otro que quería hacer eran estos gráficos radiales que muestran múltiples años en un anillo de meses. Nunca los había hecho! Quedan muy lindos y son muy fáciles de hacer con {ggplot2}.

Nunca había explorado ni visualizado datos de clima, así que acepto cualquier crítica ☺️ 

[En el repositorio del proyecto](https://github.com/bastianolea/temperaturas_chile) dejé los conjuntos de datos limpios y en un solo archivo, para quienes deseen explorar!