---
title: Generando ruido visual con R
author: Bastián Olea Herrera
date: '2025-08-27'
slug: []
categories: []
tags:
  - curiosidades
  - arte generativo
  - loops
format:
  hugo-md:
    output-file: index
    output-ext: md
excerpt: "Una aproximación al arte generativo ASCII por medio de loops de código que generan secuencias de textos aleatorias, produciendo patrones de ruido interesantes."
links:
- icon: github
  icon_pack: fab
  name: código
  url: https://github.com/bastianolea/ruido_visual
---

El otro día tuve que usar R para generar comandos muy largos (para automatizar el convertir cientos de reportes `html` a `pdf` usando un navegador web), y el código resultante fue eterno. Al pegarlo en la consola se produjo un aluvión de texto:

{{< video "videos/comando_eterno.mp4" >}}

Entre el océano de texto y código aparecen algunas figuras diagonales con cierta regularidad. Es un fenómeno que me había pasado antes, y que siempre llamó mi atención.

Cuando [programo _loops_](https://bastianolea.rbind.io/blog/r_introduccion/r_intermedio/#bucles) me gusta hacer que R imprima mensajes de estado en cada paso (con `message()` o `cat()`) para saber cómo avanza el proceso, y en algunos casos esto genera un caos de texto, particularmente cuando los procesos son demasiado rápidos.

Me interesaba replicar estas situaciones. Lo más básico sería hacer un _loop_ que imprima todos los números del 1 al `n`. Una operación de este tipo es instantánea, ya que no tiene mayor complejidad, así que para que se note mejor, le ponemos una breve espera[^1] de una milésima de segundo entre cada paso:

```r
# función para pausar entre cada paso
wait <- Sys.sleep

# loop desde el 1 al 10000
for (i in 1:10000) {
  cat(i) # imprimir valor a la consola
  wait(0.001) # tomarse una pausa
  # repetir
}
```

[^1]: La función `Sys.sleep(x)` hace que R pause por X segundos. Acá renombré la función a `wait()`, simplemente porque me carga el nombre `Sys.sleep` con mayúscula y puntos.

{{< video "videos/ejemplo.mp4" >}}

El loop simplemente imprime a la consola el valor que le toca en cada paso, empezando por el 1 y terminando en el 10.000. Pero el movimiento de cientos de caracteres ASCII en la pantalla hace que emerjan patrones visuales interesantes.

Me puse a explorar formas de crear distintos patrones de código que producen estas secuencias de ruido visual.

Primero definimos algunas constantes para la cantidad de pasos de los loops y la espera entre cada paso:
```r
n <- 60000
t <-  0.0002 
```

Si en cada paso imprimimos una cantidad al azar de barras (`|`), e imprimimos estas barras en los números impares y espacios vacíos en los pares, obtenemos una especie de fondo blanco con muchos espacios distribuidos aleatoriamente.

```r
for (i in 1:n) {
  cantidad <- sample(1:16, 1) # números al azar entre 1 y 16
  barras <- paste(rep("|", cantidad), collapse = "") # cantidad de barras
  if (i %% 2 == 0) cat(" ") else cat(barras) # imprimir vacío si el número es par, barras si es impar
  wait(t) # espera antes del siguiente paso
}
```

{{< video_ancho "videos/ruido_7.mp4" >}}



Si en cada paso del loop imprimimos una cantidad al azar de espacios en blanco, imprimimos estos espacios solamente en los pasos divisibles por 10, y el resto de los pasos imprimimos una barra, obtenemos un patrón de ruido con figuras de vacío contínuas hacia abajo, que parecen líneas de zebra.

```r
for (i in 1:n) {
  espacios <- rep(" ", sample(1:6, 1)) # espacios al azar entre 1 y 6
  vacio <- paste(espacios, collapse = "") # unir los espacios resultantes
  if (i %% 10 == 0) cat(vacio) else cat("|") # imprimir vacío en todos los pasos excepto en múltiplos de 10
  wait(3e-04) # espera 
}
```

{{< video_ancho "videos/ruido_2.mp4" >}}


En el siguiente, por cada número de los pasos del loop, se imprime una cantidad de barras (si el número es impar) o vacío (si el número es par) dependiendo del último dígito del número. Por ejemplo, en el paso 543 se imprimen 3 barras, porque 3 es el último número de 543, y es impar. 

Se genera una especie de cuadrantes con cierto degradado, o diagonales crecientes con espaciado y figuras geométricas, dependiendo del tamaño del texto y/o de la ventana de la consola.

```r
for (i in 1:n) {
  vacio <- paste(rep(" ", i %% 10), collapse = "")
  barras <- paste(rep("|", i %% 10), collapse = "")
  if (i %% 2 == 0) cat(vacio) else cat(barras)
  wait(2e-03)
}
```

{{< video_ancho "videos/ruido_6.mp4" >}}

Encuentro maravilloso que los patrones cambien según el tamaño de la consola (la cantidad de columnas de texto, en realidad), y espero poder explorar más en ese sentido.

En este otro intento generé un número al azar en cada paso, y se imprimen barras y vacíos en esa cantidad, dependiendo de si el paso es es par o impar. El resultado es un ruido con barras anchas, que genera manchas que se conectan entre si.

```r
for (i in 1:n) {
  cantidad <- sample(1:18, 1)
  barras <- paste(rep("|", cantidad), collapse = "")
  vacio <- paste(rep(" ", cantidad), collapse = "")
  if (i %% 2 == 0) cat(vacio) else cat(barras)
  wait(2e-03)
}
```

{{< video_ancho "videos/ruido_8.mp4" >}}


Para el siguiente intento me basé en el código anterior, pero en un loop sobre los números de una distribución poisson con un lambda de 1. El resultado es mucho más ruidoso, con figuras geométricas esporádicas interesantes.

```r
for (i in rpois(n, 1)) {
  barras <- paste(rep("|", i), collapse = "")
  vacio <- paste(rep(" ", i), collapse = "")
  if (i %% 2 == 0) cat(vacio) else cat(barras)
  wait(t)
}
```

{{< video_ancho "videos/ruido_11.mp4" >}}


Si se crea una secuencia de pares de vacío y barras del mismo largo (`|||   |||   |||`), se generan barras verticales o diagonales dependiendo de la cantidad de columnas de la consola.

```r
for (i in 1:n) {
  cantidad <- 8
  barras <- paste(rep("|", cantidad), collapse = "")
  vacio <- paste(rep(" ", cantidad), collapse = "")
  if (i %% 2 == 0) cat(vacio) else cat(barras)
  wait(2e-3)
}
```

{{< video_ancho "videos/ruido_12.mp4" >}}

En esta última prueba generé dos loops dentro de cada paso del loop principal, donde los loops internos van del 1 al 4 creando una secuencia que genera esa cantidad de elementos, una vez del 1 al 4, y luego del 4 al 1:

```
| |  |   |    |    |   |  | |
```

El resultado son secuencias que en ciertos anchos de consola se ven onduladas,  luego se producen patrones diagonales más espaciados entre ellos.

```r
for (i in 1:n) {
  x = 4
  for (y in 1:x) {
    cat(rep(" ", y) |> paste(collapse = "")) 
    cat("|")
  }
  for (y in x:1) {
    cat(rep(" ", y) |> paste(collapse = "")) 
    cat("|")
  }
  wait(t*20)
}
```

{{< video_ancho "videos/ruido_15.mp4" >}}

Me encantó esta primera aproximación al arte generativo, y ojalá poder seguir descrubriendo nuevas formas de generar patrones interesantes! Sería ideal desarrollar una aplicación interactiva donde los patrones fluyan continuamente y vayan siendo alterados directamente desde el código, en tiempo real.