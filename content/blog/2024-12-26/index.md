---
title: Haciendo que un loop muy largo termine sin cancelarlo
author: Bastián Olea Herrera
date: '2024-12-26'
slug: []
categories: []
tags:
  - consejos
  - curiosidades
  - blog
  - purrr
---

Me encuentro en la tarea de tener que [procesar cientos de miles de datos](/blog/2024-12-20/), lo cual demorará varios cientos de horas, por lo que necesito que dejar mi computador trabajando durante las noches, por varios días. La idea es que, cada noche, el computador procese de la mayor cantidad de datos posibles, los resultados se guarden, y a la siguiente noche el proceso se repita con datos nuevos, hasta que en algunos días logre procesar todos los cientos de miles de datos que necesito. 

[El proceso en sí mismo](/blog/2024-12-20/) consiste en utilizar modelos de lenguaje (LLM) para extraer sentimiento, clasificación y resumen de cada unidad de los datos, que corresponden a textos de entre 100 a 5000 caracteres. Este procesamiento utiliza el 100% de mi tarjeta de video, por lo que el computador alcanzar altas temperaturas, así que prefiero hacer este cálculo mientras no estoy usándolo para otras cosas.

Como cada unidad de datos tiene una identificación única, cada noche lo que hago es extraer una muestra aleatoria del conjunto total de datos, excluyendo los datos cuyo id único ya fue procesado anteriormente. De esa manera no se repite el procesamiento de datos que ya fueron procesados.

Las primeras noches, lo que hice fue darle al loop una muestra aleatoria de un tamaño específico. El tamaño de esta muestra dependía del tiempo promedio de ejecución de cada paso del loop, multiplicado por _x_, para que el tiempo total de ejecución durara un poco menos de ocho horas, de modo que cuando amaneciera, el proceso ya haya terminado y yo pudiera usar mi computador normalmente.

Pero luego vino la navidad 🎄 y yo iba a salir de mi casa sin saber en cuántas horas iba a volver. Así que no sabía cuántos datos darle al loop. Si le daba muy pocos, el computador podía terminar antes de que yo volviera, y hubieran sido muchas horas de procesamiento perdido, pero si le daba muchos datos, yo podía llegar a la casa y encontrarme con mi computador inutilizable por estar trabajando al 100% en un proceso que aún no terminaba.

Lo ideal sería poder iniciar el proceso, que el computador se ponga a calcular, y que eventualmente yo pueda detener el proceso y obtener los resultados que se alcanzaron a calcular durante ese tiempo.  Pero si detienes un proceso en R, el proceso termina sin asignar su resultado. Entonces no puedo llegar y tener el proceso.

Esto podría evitarse si, en vez de que el proceso con `purrr::map()` asigne sus resultados finales a un objeto de R, se use `purrr::walk()` para que cada paso del proceso guarde su resultado individual como un archivo por separado, y luego en otro momento se unan todos los resultados individuales. Esto lo he hecho antes con buenos resultados, pero esta vez simplemente no quería hacerlo así.

La solución sería ser que el proceso _termine desde adentro_; es decir, que algo dentro del proceso haga que éste termine cuando yo se lo pida. En un loop normal, esto se haría con el uso de un `if` con un `stop()` dentro, lo cual detendría las siguientes iteraciones. Pero el problema seguiría siendo el cómo hacerle saber al loop, desde afuera, que tiene que terminarse. Por otro lado, los loops del paquete `{purrr}` no tienen un equivalente a `stop()`, dado que no tendría sentido bajo la lógica de la programación funcional. Pero lo que sí puedan hacer los loops de `{purrr}` es retornar `NULL` con antelación, como una forma de saltarse el paso. Por lo tanto, la forma de hacer que el loop "termine" sería haciéndole que retorne nulo para todos los siguientes pasos. El loop en sí no terminaría, pero las iteraciones que retornen nulo ocuparían un tiempo de procesamiento negligible, haciendo que las miles de operaciones restantes terminen en fracción de segundo. Entonces faltaría la forma de hacer que, desde fuera, el loop supiera que tiene que empezar a saltarse todas las operaciones y retornar nulo.

La solución que encontré fue crear un archivo de texto que tuviera cualquier texto, pero cuando eventualmente el texto dijera algo como "stop", el loop retornara nulo. La forma de que el loop supiera lo que contiene archivo de texto sería simplemente agregar un paso al principio de del loop que lea el archivo de texto. En la lectura del archivo, habría que confirmar si dice o no la palabra mágica, y si la dice, retornar `NULL`. 

```r
if (read.delim("stop.txt", header = FALSE)[[1]] == "stop") return(NULL)
```

No encontré una forma más elegante de leer un texto y obtener su resultado como un vector limpio, porque las funciones de lectura que probé asumen que esperas un dataframe y no solamente un texto, pero es suficientemente conciso.

Entonces, si el loop está ejecutándose, pero yo llego y edito el archivo de texto para que diga la palabra mágica, **el loop empezará a retornar nulo**, y terminará a la brevedad.

Una medición de rendimiento sencilla me indica que la lectura del archivo de texto se tarda tan solo 61 millonésimas de segundo y apenas 16KB de memoria, por lo que la lectura del archivo de texto en cada paso no afectaría virtualmente en nada al rendimiento del proceso:

```r
bench::mark(
  read.delim("stop.txt", header = FALSE)[[1]]
)

#   expression              min median `itr/sec` mem_alloc `gc/sec` n_itr  n_gc total_time result memory     time       gc      
#   <bch:expr>           <bch:> <bch:>     <dbl> <bch:byt>    <dbl> <int> <dbl>   <bch:tm> <list> <list>     <list>     <list>  
# 1 "read.delim(\"stop.… 58.1µs 61.7µs    15342.      16KB     44.7  6868    20      448ms <chr>  <Rprofmem> <bench_tm> <tibble>
```

Esta técnica dio resultado, porque ahora puedo dejar el proceso andando con una cantidad muy alta de de casos seleccionados al azar, y cuando cambio el archivo de texto para señalar que ya quiero que se termine el loop, todos los miles de pasos restantes que aún no eran procesados simplemente retornan nulo y terminan de forma instantánea, permitiendo que el loop termine correctamente y sus resultados se guarden. De esta forma no tengo que estar estimando cuántos datos voy a calcular, sino que simplemente dejo calculando y hago terminar el proceso cuando yo lo necesite. 

<video src="loop_stop.mp4" width="100%" autoplay loop></video>

Así que, durante las 24 horas que estuve fuera de casa por la navidad, el proceso alcanzó a calcular 15 mil textos, luego detuve el proceso, trabajé, y la noche siguiente a la navidad volví a dejarlo calculando y alcanzó a procesar 8 mil textos más 🥰
