---
title: 'Actualización: plataforma de visualización de estadísticas delictuales'
author: Bastián Olea Herrera
date: '2025-11-15'
draft: false
slug: []
categories: []
tags:
  - blog
  - datos
  - Chile
  - apps
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: link
    icon_pack: fas
    name: Aplicación
    url: https://bastianoleah.shinyapps.io/delincuencia_chile
  - icon: github
    icon_pack: fab
    name: Código
    url: https://github.com/bastianolea/delincuencia_chile
excerpt: "Acabo de publicar una actualización a mi [app de visualización de estadísticas delictuales](https://bastianoleah.shinyapps.io/delincuencia_chile). Es una aplicación tipo dashboard que presenta visualizaciones de los datos oficiales de casos policiales. La app se actualizó a los datos más recientes a la fecha: junio de 2025, publicados en la plataforma de estadísticas delictuales del Centro de Estudios y Análisis del Delito."
---

Acabo de publicar una actualización a mi [app de visualización de estadísticas delictuales](https://bastianoleah.shinyapps.io/delincuencia_chile). Consiste en la actualización a los **datos más recientes a la fecha: junio de 2025**, publicados en la plataforma de estadísticas delictuales del [Centro de Estudios y Análisis del Delito](https://cead.minsegpublica.gob.cl/estadisticas-delictuales/).

{{< video "app_delincuencia_chile.mp4" >}}

Se trata de una aplicación tipo dashboard que presenta visualizaciones de los datos oficiales de **casos policiales**, entendidos como:

> denuncias formales que la ciudadanía realiza en alguna unidad policial posterior a la ocurrencia del delito, más los delitos de los que la policía toma conocimiento al efectuar una detención en flagrancia, es decir, mientras ocurre el ilícito.

Una de las características principales de la aplicación es facilitar la exploración de **datos delictuales a nivel comunal, y además por mes y año**, lo cual es complicado y poco amigable de hacer en la plataforma oficial de CEAD. También es posible [**descargar los datos** desde el repositorio](https://github.com/bastianolea/delincuencia_chile?tab=readme-ov-file#datos).

{{< imagen "app_delincuencia_chile_3.png" >}}
{{< bajada "Gráfico de delitos de mayor connotación social" >}}
<br>

{{< imagen "app_delincuencia_chile_1_featured.png" >}}
{{< bajada "Gráfico de total de delitos mensuales en el país" >}}
<br>

{{< imagen "app_delincuencia_chile_2.png" >}}
{{< bajada "Gráfico de delitos en una comuna específica" >}}


Los datos de la aplicación se obtienen mediante [web scraping](/tags/web-scraping/), usando [código de R](https://bastianolea.rbind.io/blog/tutorial_delitos_cead/) que emula las _requests_ internas que la plataforma oficial de CEAD realiza para obtener sus datos. Esto significa que se emulan los miles de _requests_ necesarios para acceder a todas las comunas del país, por todos los años, en todos los meses, solicitando todos los delitos disponibles, dentro de un loop que toma un par de horas en terminar[^1]. El proceso de extracción de datos se explica [en este tutorial](https://bastianolea.rbind.io/blog/tutorial_delitos_cead/).

[^1]: debido a la espera _ética_ entre requests que toma en consideración el tiempo de respuesta del servidor para no sobrecargarlo.

{{< imagen "captura.png" >}}

{{< bajada "Captura de mi sesión de R obteniendo los datos actualizados" >}}

----

<div style="width: 100%; text-align: center; margin:auto;">
<iframe src="https://platform.twitter.com/embed/Tweet.html?creatorScreenName=bastimapache&dnt=true&embedId=twitter-widget-0&features=eyJ0ZndfdGltZWxpbmVfbGlzdCI6eyJidWNrZXQiOltdLCJ2ZXJzaW9uIjpudWxsfSwidGZ3X2ZvbGxvd2VyX2NvdW50X3N1bnNldCI6eyJidWNrZXQiOnRydWUsInZlcnNpb24iOm51bGx9LCJ0ZndfdHdlZXRfZWRpdF9iYWNrZW5kIjp7ImJ1Y2tldCI6Im9uIiwidmVyc2lvbiI6bnVsbH0sInRmd19yZWZzcmNfc2Vzc2lvbiI6eyJidWNrZXQiOiJvbiIsInZlcnNpb24iOm51bGx9LCJ0ZndfZm9zbnJfc29mdF9pbnRlcnZlbnRpb25zX2VuYWJsZWQiOnsiYnVja2V0Ijoib24iLCJ2ZXJzaW9uIjpudWxsfSwidGZ3X21peGVkX21lZGlhXzE1ODk3Ijp7ImJ1Y2tldCI6InRyZWF0bWVudCIsInZlcnNpb24iOm51bGx9LCJ0ZndfZXhwZXJpbWVudHNfY29va2llX2V4cGlyYXRpb24iOnsiYnVja2V0IjoxMjA5NjAwLCJ2ZXJzaW9uIjpudWxsfSwidGZ3X3Nob3dfYmlyZHdhdGNoX3Bpdm90c19lbmFibGVkIjp7ImJ1Y2tldCI6Im9uIiwidmVyc2lvbiI6bnVsbH0sInRmd19kdXBsaWNhdGVfc2NyaWJlc190b19zZXR0aW5ncyI6eyJidWNrZXQiOiJvbiIsInZlcnNpb24iOm51bGx9LCJ0ZndfdXNlX3Byb2ZpbGVfaW1hZ2Vfc2hhcGVfZW5hYmxlZCI6eyJidWNrZXQiOiJvbiIsInZlcnNpb24iOm51bGx9LCJ0ZndfdmlkZW9faGxzX2R5bmFtaWNfbWFuaWZlc3RzXzE1MDgyIjp7ImJ1Y2tldCI6InRydWVfYml0cmF0ZSIsInZlcnNpb24iOm51bGx9LCJ0ZndfbGVnYWN5X3RpbWVsaW5lX3N1bnNldCI6eyJidWNrZXQiOnRydWUsInZlcnNpb24iOm51bGx9LCJ0ZndfdHdlZXRfZWRpdF9mcm9udGVuZCI6eyJidWNrZXQiOiJvbiIsInZlcnNpb24iOm51bGx9fQ%3D%3D&frame=false&hideCard=false&hideThread=false&id=1989499507894014463&lang=es&origin=http%3A%2F%2Flocalhost%3A4321%2Fblog%2F2025-11-14%2F&sessionId=176886ace112c1e8632f95795406d94a9a4a2c69&siteScreenName=bastimapache&theme=light&widgetsVersion=2615f7e52b7e0%3A1702314776716&width=550px" 
height="650px" width="80%" margin="auto" frameborder="0" allowfullscreen="" title="Publicación integrada"></iframe>
</div>