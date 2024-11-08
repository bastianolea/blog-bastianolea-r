---
title: '¿Por qué usar R? Razones y beneficios'
author: Bastián Olea Herrera
format: hugo-md
date: 2024-11-07T00:00:00.000Z
weight: 2
draft: false
series: Introducción a R
categories:
tags:
lang: es
excerpt: Analizar datos mediante lenguajes de programación (como R u otros) puede sonar complicado, pero trae muchos beneficios para tu análisis
---

_¿Por qué usar R para analizar datos?_

Analizar datos mediante lenguajes de programación (como R u otros) puede sonar complicado, pero trae muchos beneficios para tu análisis:

- En vez de pensar el procesamiento de datos y la obtención de resultados como un proceso continuo o una sucesión de pasos que realizamos uno después del otro, desde los datos iniciales hasta el producto final, vemos el proceso como una iteración de un proceso que va aumentando su complejidad en cada paso, y donde se puede ir optimizando cada fase del mismo

Los beneficios pueden ser múltiples:
- Flujos de trabajo que puedes reutilizar con distintas fuentes de datos
- Automatización de tareas repetitivas, por ejemplo, realizar un mismo análisis sobre cientos de archivos
- Automatización de reportes, informes, visualizaciones y resultados
- Mejor desempeño a la hora de procesar bases de datos grandes
- Reproducibilidad de tus resultados, garantizando que otros usuarios pueden revisar todos los pasos de tu análisis y obtener los mismos resultados que tú
- Flexibilidad en tecnologías y métodos: un mismo proceso puede ser fácilmente actualizado para usar una tecnología que mejore su desempeño; por ejemplo, pasar de leer un Excel a consultar una base de datos relacional como SQL 

¿Necesitas aprender a explorar tus datos?
¿Tienes datos pero no les puedes sacar provecho?
¿Quieres presentar tus resultados de forma atractiva y/o interactiva? **¡Considera aprender R!**

## Beneficios de R

#### Flujos de trabajo:
- Tus proyectos tendrán entradas y salidas claras. Podrás cambiar las entradas de datos sin tener que deshacer el trabajo que ya has hecho.
- Como vas procesando datos por pasos, siempre puedes cambiar un paso anterior y aplicar los cambios a los pasos siguientes, o hacer cambios en pasos intermedios y volver a obtener los nuevos resultados.

#### Procesos reutilizables:
- Si realizas tareas repetitivas, puedes especificar el procedimiento una sola vez, y aplicarlo cientos de veces.
- Si redactas reportes basados en datos que se actualizan periódicamente, o con información repetitiva, puedes programar un solo reporte que se actualice con información nueva de forma automática.
- Si llevas a cabo un mismo procedimiento a muchos datos similares, por ejemplo a muchas planillas de Excel, puedes programar un proceso una sola vez y aplicarlo a cientos o miles de casos, ahorrándote tiempo para generar tus resultados.
- Si trabajas con múltiples unidades de información, como pueden ser empresas, clientes, países o comunas, puedes definir los resultados que requieres una sola vez, y obtener el resultado para cada una de las unidades; por ejemplo, una tabla para cada empresa, un reporte para cada cliente, un gráfico para cada comuna, etc.
    - _Ejemplos:_
    - Si generas un reporte para varias empresas, programas un solo reporte y así puedes obtener los reportes que desees. 
    - Si recibes unos mismos datos cada cierto tiempo, puedes tener un flujo de trabajo listo para que solo lo apliques sobre el archivo nuevo y obtengas los resultados que esperas.
    - Si estás haciendo gráficos sobre datos de una comuna, y tienes cientos de comunas, basta hacer un solo gráfico para aplicarlos a todas las comunas.
    - Si recibes decenas de planillas de datos de clientes y tienes que hacer cambios a cada uno, creas una función que haga los cambios y la aplicas a todas las planillas que quieras.

#### Reproducibilidad
- Existe una tendencia a incentivar la creación de flujos de trabajo _reproducibles;_ es decir, que tus scripts abarquen desde la primera carga de los datos crudos u originales, avanzando por los pasos del análisis, hasta llegar a los resultados. En otras palabras, puedes volver a repetir tu proyecto desde cero, y llegarás siempre a los mismos resultados. 
- Esto ocurre porque los pasos que vamos realizando en R son _no destructivos_, dado que nunca modificamos los datos originales, sino que vamos generando nuevos datos en cada paso, y podemos repetir esos pasos o devolvernos en ellos y modificarlos/corregirlos. Esto se contrapone a otras formas de trabajo, como por ejemplo editar los datos directamente en Excel: una mala práctica que te hace alterar los datos originales, volviendo invisibles para los demás los pasos que hiciste para llegar a tus resultados. En cambio, en R uno va dejando un registro de cada paso realizado, lo que permite que mantengamos los datos originales intactos, que otros puedan verificar y revisar nuestro trabajo, y que nosotres podamos también volver atrás en los pasos y revisar nuestro avance o corregir errores.


----

Creo que la mayoría de los beneficios de R provienen de su origen: R es un lenguaje desarrollado por estadísticos y profesionales de fuera de la informática, y es dirigido también a personas fuera de la informática, por lo que es un len guaje enfocado en ser fácil de leer y aprender, y en obtener resultados. El hecho de que se dirija a usuarios variados hace que su dificultad de uso sea menor, y también a que su comunidad de usuarios sea diversa.

