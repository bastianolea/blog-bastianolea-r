---
title: 'Tutorial: publicar una app Shiny en Digital Ocean'
author: Bastián Olea Herrera
format: hugo-md
date: 2024-11-06T00:00:00.000Z
draft: true
categories:
  - Tutoriales
tags:
  - Shiny
lang: es
excerpt: En este tutorial encuentras instrucciones paso a paso para crear un droplet (servidor privado) en Digital Ocean, en el cual puedes subir aplicaciones Shiny, ejecutar RStudio, dejar automatizados procesos recurrentes de análisis de datos o web scraping, y más.
---


[3] Digital Ocean

![](tutorial_digitalocean_2.png)


![](tutorial_digitalocean_3-featured.png)

- crear una cuenta (necesita medio de pago)

https://m.do.co/c/b117f791b027

![](tutorial_digitalocean_4.png)
- crear droplet
    - elegir imagen RStudio
    
    ![](tutorial_digitalocean_5.png)
    - elegir configuración
    ![](tutorial_digitalocean_6.png)
    
    
![](tutorial_digitalocean_7.png)
- configurar droplet
    - crear usuarios
```
adduser usuario
```

```
adduser usuarioprueba
usermod -aG sudo usuarioprueba
```

- abrir Rstudio: IP:8787


![](tutorial_digitalocean_1.png)
- Clonar una app
    - Nuevo proyecto
    - Proyecto desde control de versiones
    - https://github.com/bastianolea/estimador_ingresos_trabajo.git

- Enlazar proyecto con la carpeta de shiny-server
```
sudo ln -s ~/miaplicacion /srv/shiny-server/
```

- Instalar paquetes para Shiny
Desde la consola de Digital Ocean:
```
sudo su - shiny
R
install.packages("...")
```

- Editar configuración de Shiny
```
sudo nano /etc/shiny-server/shiny-server.conf
```
Dentro de este archivo, agregar estas opciones:
```
preserve_logs true;
sanitize_errors false;
```

Guardar usando control+O, cerrar usando control+W.

