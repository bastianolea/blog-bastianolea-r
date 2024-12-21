---
title: '¿Por qué usar R?'
subtitle: "Beneficios del análisis de datos por medio de la programación en R"
author: Bastián Olea Herrera
format: hugo-md
date: 2024-11-07T00:00:00.000Z
weight: 2
series_weight: 2
draft: false
series: Introducción a R
categories: []
tags: 
  - blog
lang: es
excerpt: Analizar datos mediante lenguajes de programación (como R u otros) puede sonar complicado, pero trae muchos beneficios para tu análisis. Aquí te dejo algunas de las razones principales.
---

_¿Por qué usar R para analizar datos?_

Analizar datos mediante lenguajes de programación (como R u otros) puede sonar complicado, pero trae muchos beneficios para tu análisis.

### Usabilidad
- _Facilidad de uso:_
  - A diferencia de otros lenguajes de programación, R está diseñado por y para personas que no se especializan en computación ni informática, sino que se enfoca en profesionales de distintas áreas que requieren aplicar técnicas computacionales a sus disciplinas. Por lo tanto, suele ser más sencillo de usar que otros lenguajes, y por sobre todo más "legible" que otros lenguajes, en el sentido de que la sintaxis de R es fácilmente interpretable como instrucciones en lenguaje natural, una vez que entiendes las reglas básicas para escribirlo y leerlo. Por lo demás, cada función del lenguaje está ampliamente documentada, y existe una gran comunidad de usuarios y usuarios con mucha disposición para ayudar y enseñar.
- _Análisis estadísticos complejos:_ 
  - R es una herramienta poderosa para realizar análisis estadísticos complejos, como aplicar modelos estadísticos a tus datos, herramientas de _machine learning,_ o análisis estadísticos sofisticados. Muchas de estas herramientas vienen por defecto en R, y muchísimas otras son fácilmente instalables mediante paquetes.
- _Visualizaciones de datos:_
  - R cuenta con una amplia variedad de herramientas para visualizar datos. El paquete `{ggplot2}` permite crear gráficos personalizables y complejos con una sintaxis clara y concisa, basada en capas. Puedes explorar visualmente tus datos en cuestión de segundos, o producir visualizaciones complejas y atractivas si lo requieres.
- _Velocidad:_
  - Con R puedes procesar bases de datos de millones o miles de millones de filas. Existen múltiples estrategias para trabajar con grandes volúmenes de datos en R, y puedes elegir la que más te convenga en cada situación para encontrar el equilibrio entre desempeño y conveniencia que desees.



### Flujos de trabajo
- _Tener todo tu proyecto a la vista:_
  - En vez de pensar el procesamiento de datos y la obtención de resultados como un proceso continuo o una sucesión de pasos que realizamos uno después del otro, desde los datos iniciales hasta el producto final, vemos el proceso como una iteración de pasos que van aumentando su complejidad en cada etapa, y donde se puede ir optimizando cada fase del mismo.
- No vas a tener que repetir cosas que ya has hecho: tendrás flujos de trabajo que puedes reutilizar con distintas fuentes de datos, distintas versiones de los datos, o variaciones en los cálculos. Esto te permite experimentar e iterar.
- Tus proyectos tendrán entradas y salidas claras. Podrás cambiar las entradas de datos sin tener que deshacer el trabajo que ya has hecho.
- Como vas procesando datos por pasos, siempre puedes cambiar un paso anterior y aplicar los cambios a los pasos siguientes, o hacer cambios en pasos intermedios y volver a obtener los nuevos resultados.
- Flexibilidad en tecnologías y métodos: un mismo proceso puede ser fácilmente actualizado para usar una tecnología que mejore su desempeño; por ejemplo, pasar de leer un Excel a consultar una base de datos relacional como SQL. 
- _Podrás basarte en el progreso de otros:_
  - La comunidad de estadísticos, analistas de datos, científicos de datos, geógrafos, y otros profesionales que usan R, usualmente comparten sus proyectos, herramientas y código. Puedes basarte en eso para aplicarlo a tus necesidades.

### Procesos reutilizables
- _Si lo haces una vez, puedes hacerlo 100 veces:_
  - Automatización de tareas repetitivas, por ejemplo, realizar un mismo análisis sobre cientos de archivos. Pero también puedes automatizar la generación de reportes, informes, visualizaciones y resultados.

- Si realizas tareas repetitivas, puedes especificar el procedimiento una sola vez, y aplicarlo cientos de veces.
- Si redactas reportes basados en datos que se actualizan periódicamente, o con información repetitiva, puedes programar un solo reporte que se actualice con información nueva de forma automática.
- Si llevas a cabo un mismo procedimiento a muchos datos similares, por ejemplo a muchas planillas de Excel, puedes programar un proceso una sola vez y aplicarlo a cientos o miles de casos, ahorrándote tiempo para generar tus resultados.
- Si trabajas con múltiples unidades de información, como pueden ser empresas, clientes, países o comunas, puedes definir los resultados que requieres una sola vez, y obtener el resultado para cada una de las unidades; por ejemplo, una tabla para cada empresa, un reporte para cada cliente, un gráfico para cada comuna, etc.
    - _Ejemplos:_
    - Si generas un reporte para varias empresas, programas un solo reporte y así puedes obtener los reportes que desees. 
    - Si recibes unos mismos datos cada cierto tiempo, puedes tener un flujo de trabajo listo para que solo lo apliques sobre el archivo nuevo y obtengas los resultados que esperas.
    - Si estás haciendo gráficos sobre datos de una comuna, y tienes cientos de comunas, basta hacer un solo gráfico para aplicarlos a todas las comunas.
    - Si recibes decenas de planillas de datos de clientes y tienes que hacer cambios a cada uno, creas una función que haga los cambios y la aplicas a todas las planillas que quieras.

### Reproducibilidad
El análisis por medio de programación garantiza que otros usuarios pueden revisar todos los pasos de tu análisis y obtener los mismos resultados que tú.

- En R existe una tendencia a incentivar la creación de flujos de trabajo _reproducibles;_ es decir, que tus scripts abarquen desde la primera carga de los datos crudos u originales, avanzando por los pasos del análisis, hasta llegar a los resultados. En otras palabras, puedes volver a repetir tu proyecto desde cero, y llegarás siempre a los mismos resultados. 
- Esto ocurre porque los pasos que vamos realizando en R son _no destructivos_, dado que nunca modificamos los datos originales, sino que vamos generando nuevos datos en cada paso, y podemos repetir esos pasos o devolvernos en ellos y modificarlos/corregirlos. Esto se contrapone a otras formas de trabajo, como por ejemplo editar los datos directamente en Excel: una mala práctica que te hace alterar los datos originales, volviendo invisibles para los demás los pasos que hiciste para llegar a tus resultados. En cambio, en R uno va dejando un registro de cada paso realizado, lo que permite que mantengamos los datos originales intactos, que otros puedan verificar y revisar nuestro trabajo, y que nosotres podamos también volver atrás en los pasos y revisar nuestro avance o corregir errores.


----

Creo que la mayoría de los beneficios de R provienen de su origen: R es un lenguaje desarrollado por estadísticos y profesionales de fuera de la informática, y es dirigido también a personas fuera de la informática, por lo que es un len guaje enfocado en ser fácil de leer y aprender, y en obtener resultados. El hecho de que se dirija a usuarios variados hace que su dificultad de uso sea menor, y también a que su comunidad de usuarios sea diversa.

¿Necesitas aprender a explorar tus datos?
¿Tienes datos pero no les puedes sacar provecho?
¿Quieres presentar tus resultados de forma atractiva y/o interactiva? **¡Considera aprender R!**
