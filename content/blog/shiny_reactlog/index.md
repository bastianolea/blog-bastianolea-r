---
title: Analiza el funcionamiento de tus aplicaciones Shiny con {reactlog}
author: Bastián Olea Herrera
date: '2025-11-14'
slug: []
categories: []
tags:
  - shiny
  - optimización
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: registered
    icon_pack: fas
    name: Paquete
    url: https://rstudio.github.io/reactlog/
excerpt: "Las aplicaciones Shiny funcionan con _reactividad_: una cadena de causalidad que va desde los _inputs_ de tu app, pasando por las expresiones reactivas (objetos de R que se actualizan automáticamente cuando cambian sus dependencias), hasta los _outputs_ que se muestran en la interfaz de usuario. Con `{reactlog}` puedes explorar visualmente esta cadena o red de dependencias, para entender cómo tu aplicación se va generando, analizar las dependencias entre elementos, y buscar posibles optimizaciones."
---

Las aplicaciones Shiny funcionan con **[reactividad](https://shiny.posit.co/r/articles/build/reactivity-overview/)**: una cadena de causalidad que va desde los _inputs_ de tu app, pasando por las expresiones reactivas (objetos de R que se actualizan automáticamente cuando cambian sus dependencias), hasta los _outputs_ que se muestran en la interfaz de usuario. 

{{< imagen "shiny_esquema.png" >}}

Cuando programamos una app Shiny vamos haciendo éste tipo de **conexiones**: 

> estos dos _inputs_ van a hacer que en este `reactive()` se filtren los datos, y el resultado del `reactive()` va a usarse para generar un _output_ en forma de gráfico.

Con `{reactlog}` puedes **explorar visualmente** esta cadena o red de dependencias, para entender cómo tu aplicación se va generando, analizar las dependencias entre elementos, y buscar posibles optimizaciones.

Para activar `{reactlog}`, antes de ejecutar tu app, ejecuta lo siguiente:

```r
reactlog::reactlog_enable()
``` 

Luego ejecuta tu aplicación normalmente, o simplemente déjala cargarse, y tienes dos opciones:

1. Presiona `Ctrl + F3` (o `Cmd + F3` en Mac) **mientras la aplicación se ejecuta** para abrir la visualización de reactlog en una nueva ventana.
2. Después de **cerrar la aplicación**, ejecuta `reactlog::reactlog_show()` para abrir la visualización.

Aparecerá un diagrama de nodos y conexiones que representan los distintos elementos de tu aplicación y sus relaciones entre sí. 

{{< imagen "reactlog_4.png" >}}

En esta visualización vemos al lado izquierdo los _inputs_, que usualmente son el principio de la **cadena de reactividad**. Estos _inputs_ se conectan a las **expresiones reactivas** que usan sus valores, y éstas a su vez se conectan con otras expresiones reactivas, o con _outputs_, que salen al lado derecho.

Recordemos que, en Shiny, la reactividad va **desde el final hacia el principio**: todo parte porque existen _outputs_ que requieren los resultados de elementos reactivos (datos, cálculos), las cuales a su vez dependen de otros _inputs_, etc., y así se van evaluando todas las operaciones hasta que la app queda cargada (_idle_).

----

Puedes hacer clic en los nodos para ver **detalles** adicionales, como el tiempo que tomó cada operación, las dependencias, y más.

{{< imagen "reactlog_1_featured.png" >}}

Puedes hacer doble clic en los nodos para que el gráfico se reordene y muestre las **dependencias** directas.

{{< imagen "reactlog_3.png" >}}

En la parte superior, puedes **avanzar o retroceder** para ir viendo el estado de tu aplicación en distintos momentos de su ejecución; por ejemplo, empezar desde el inicio e ir viendo cómo los outputs van llamando a sus dependencias hasta que la app se carga completa.

{{< video "reactlog_shiny.mp4" >}}

En este video vemos el funcionamiento interno de una aplicación compleja, y arriba vemos que todo pasó en menos de 2 segundos.


## Recursos 
- [Posit: Reactivity - An overview](https://shiny.posit.co/r/articles/build/reactivity-overview/)
- [Mastering Shiny: Basic reactivity](https://mastering-shiny.org/basic-reactivity.html)

{{< cursos >}}