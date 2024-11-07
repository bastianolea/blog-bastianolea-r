---
title: 'Tutorial: publicar una app Shiny en shinyapps.io'
author: Bastián Olea Herrera
format: hugo-md
date: 2024-11-06T00:00:00.000Z
draft: true
categories:
  - Tutoriales
tags:
  - Shiny
lang: es
excerpt: 
---

- Crear una cuenta en ShinyApps.io
https://www.shinyapps.io

- Las cuentas gratuitas permiten tener hasta 5 aplicaciones, con 25 horas de uso mensual (en total, entre todos tus usuarios)
- El plan inicial (13USD) permite 25 aplicaciones y 1000 horas de uso mensual.

![](tutorial_shinyapps_5.png)

Instalar el paquete {rsconnect}

```
install.packages('rsconnect')
```
Autorizar tu cuenta de ShinyApps.io en RStudio.
Para ello, shinyapps te entrega un código secreto asociado a tu cuenta, el cual debes registrar en tu sesión de R

![](tutorial_shinyapps_2.png)

```
rsconnect::setAccountInfo(name=‘cuenta’,
			  token=‘<TOKEN>,
			  secret='<SECRET>')
```

![](tutorial_shinyapps_1.png)

Botón _publicar_
![](tutorial_shinyapps_4.png)

Agregar cuenta 

![](tutorial_shinyapps_3.png)
Copiar y pegar en el panel


![](tutorial_shinyapps_8.png)

En el script de tu aplicación Shiny, presiona el botón azul de Publicar
Selecciona los archivos a incluir, tu cuenta, y el nombre de la aplicación
Presiona Publicar

![](tutorial_shinyapps_7.png)