---
title: Herramientas básicas para programar con R
author: Bastián Olea Herrera
date: '2025-02-14'
format:
  hugo-md:
    output-file: index
    output-ext: md
weight: 4
series: Introducción a R
categories:
  - Tutoriales
tags:
  - básico
  - funciones
  - control de flujo
  - loops
lang: es
excerpt: >-
  En guía aprenderemos herramientas de programación poderosas que flexibilizarán
  mucho nuestras capacidades de análisis de datos, abriendo infinitas
  posibilidades. Con ellas, podremos crear nuevas herramientas que nos permitan
  hacer lo que necesitamos (funciones), condicionar lo que queremos que ocurra
  en nuestros procesos (controlar el flujo), y realizar operaciones
  repetidamente (iteraciones o loops).
---


Esta es la segunda guía introductoria para aprender el lenguaje de programación R orientado al análisis de datos. [En la guía anterior vimos los principios más fundamentales del lenguaje R](../../../../blog/r_introduccion/r_basico/), para familiarizarnos con R y entender su funcionamiento básico. En esta segunda guía, seguiremos puliendo nuestros aprendizajes para aprender herramientas de programación poderosas que flexibilizarán mucho nuestras capacidades de análisis de datos, abriendo infinitas posibilidades.

En esta guía, aprenderemos herramientas que nos permitirán a:
1. Crear herramientas que nos permitan hacer lo que necesitamos (crear **funciones**)
2. Condicionar lo que queremos que ocurra en nuestros procesos (**controlar** el flujo)
3. Hacer lo que necesitamos repetidamente (realizar iteraciones o **loops**)

------------------------------------------------------------------------

## Crear funciones

La creación de funciones nos abre las puertas a todo el mundo nuevo en el uso de R para analizar nuestros datos, dado que, una vez que te familiarizas con la creación de funciones, ya no depende solamente de las herramientas existentes, sino que empiezas a hacer tú quien crea nuevas herramientas adaptadas a tus propias necesidades.

La anterior tiene el enorme beneficio de permitirte personalizar las herramientas que utilices para analizar datos a tu forma de trabajo, a las especificidades de tus datos, y a las particularidades del proceso que estés llevando a cabo. Quizás el aspecto más satisfactorio de la creación de funciones sea poder englobar un proceso largo y complejo en una función llamada `procesar_datos()`, o poder generar un gráfico detallado y atractivo tan sólo con llamar `graficar()`!

Para **crear una función** se usa, valga la redundancia, la función `function()`. Dentro de `function()` se definen los **argumentos**, que ---como sabemos--- son los elementos que pasamos dentro de la función para que ésta opere. Luego de `function()` se abren unos paréntesis de llave, dentro de los cuales definiremos qué hará la función con los argumentos que le entregamos, y que retornará. Con **retornar** nos referimos a el producto final de esta función; es decir, lo que nos entrega al ejecutarla.

Definamos el nombre, los argumentos, y el cuerpo de una nueva función:

``` r
multiplicar_mil <- function(cifra) {
  cifra * 1000
}
```

En este ejemplo, estamos creando una función que se llamará `multiplicar_mil()`. La función tendrá un solo argumento, llamado `cifra`. Dentro del cuerpo de la función, vemos que el objeto cifra, que viene desde el argumento, se multiplica por 1000. Como esta es la única y última operación dentro del cuerpo de la función, su resultado será lo que se retorne al ejecutarla.

Probemos nuestra primera función y veamos su comportamiento:

``` r
multiplicar_mil(4)
```

    [1] 4000

``` r
multiplicar_mil("hola")
```

    Error in cifra * 1000: non-numeric argument to binary operator

``` r
multiplicar_mil(c(32, 65, 87))
```

    [1] 32000 65000 87000

Hagamos otro ejemplo:

``` r
personas <- c("Basti", "Paula", "Catherine", "Luis", "María José")

saludar <- function(persona) {
  paste("¡Hola ", persona, "!", sep = "")
}

saludar(personas)
```

    [1] "¡Hola Basti!"      "¡Hola Paula!"      "¡Hola Catherine!" 
    [4] "¡Hola Luis!"       "¡Hola María José!"

``` r
saludar("Caro")
```

    [1] "¡Hola Caro!"

En esta función, el argumento `persona` expuesto dentro de una función `paste()` que genera un texto a partir de argumento. Como en el primer ejemplo se le entrega un vector a la función, `paste()` produce múltiples textos con cada elemento del vector. O sea que nuestra función funciona tanto para múltiples elementos como para uno solo.

Pasemos a una versión más compleja de la función anterior:

``` r
saludar <- function(persona) {
  
  # pasar el nombre a mayúsculas
  nombre_mayuscula <- toupper(persona)
  
  # crear un saludo uniendo el texto con el argumento
  saludo <- paste("¡Hola ", nombre_mayuscula, "!", sep = "")
  
  # crear números al azar
  números <- sample(1:99, length(persona)) # uno por persona
  
  # agregar números de la suerte
  saludo2 <- paste(saludo, "Tu número de la suerte es", números)
  
  saludo2
}

saludar(personas)
```

    [1] "¡Hola BASTI! Tu número de la suerte es 52"     
    [2] "¡Hola PAULA! Tu número de la suerte es 70"     
    [3] "¡Hola CATHERINE! Tu número de la suerte es 63" 
    [4] "¡Hola LUIS! Tu número de la suerte es 39"      
    [5] "¡Hola MARÍA JOSÉ! Tu número de la suerte es 48"

En este caso, dentro del cuerpo de la función estamos realizando varias operaciones. Dentro de una función podemos crear nuevos objetos, y usar esos nuevos objetos para realizar otras operaciones sobre ellos. De este modo podemos llevar a cabo acciones más complejas. En el ejemplo, el argumento de la función es transformado a mayúsculas con `toupper()`, luego se inserta dentro del texto con `paste()`. Después, se crea un vector de números al azar que contenga una cantidad de números igual a la cantidad de elementos del vector que viene del argumento de la función, para que haya un número por persona. Finalmente, se usa nuevamente `paste()` junto a `sample()` para agregar el número aleatorio, y se entrega el objeto final, que será lo que la función retorna.

Las funciones pueden tener más de un argumento. Creemos una función que use dos argumentos para calcular una estimación de tiempo de viaje a partir de una velocidad y una distancia dados:

``` r
calcular_tiempo <- function(velocidad, distancia) {
  
  # el tiempo de viaje equivale a la distancia dividida por la velocidad
  tiempo <- distancia/(velocidad/60) # pasar km/h a km/minutos
  
  paste("Tiempo de viaje:", round(tiempo, 1), "minutos")
}

calcular_tiempo(velocidad = 20, distancia = 5)
```

    [1] "Tiempo de viaje: 15 minutos"

En este ejemplo, una función que calcula el tiempo de viaje requiere dos argumentos: la velocidad y la distancia. Dentro de `function()` simplemente se definen los nombres de los argumentos, y se usan dentro del cuerpo de la función para calcular lo necesario.

Al momento de ejecutar una función, si ponemos los argumentos en el orden en que se especifican en la función, no es necesario que pongamos el nombre del argumento antes de el valor:

``` r
calcular_tiempo(velocidad = 22, distancia = 6)
```

    [1] "Tiempo de viaje: 16.4 minutos"

``` r
calcular_tiempo(22, 6)
```

    [1] "Tiempo de viaje: 16.4 minutos"

También podemos especificar valores por defecto para los argumentos al momento de crear la función. Éstos valores por defecto serán aplicados si es que el/la usuario/a no define los argumentos.

``` r
# ejecutar función sin argumentos
calcular_tiempo()
```

    Error in calcular_tiempo(): argument "distancia" is missing, with no default

Como no definimos los argumentos, la función retorna un error. Modifiquemos la función para que tenga argumentos por defecto:

``` r
# actualizar función con valores por defecto
calcular_tiempo <- function(velocidad = 0, distancia = 1) {
  tiempo <- distancia/(velocidad/60)
  paste("Tiempo de viaje:", round(tiempo, 1), "minutos")
}

# volver a ejecutar sin argumentos, por lo que usará los argumentos por defecto
calcular_tiempo()
```

    [1] "Tiempo de viaje: Inf minutos"

Ahora la función no tira un error si no se definen los argumentos, aunque el resultado que entrega en estos casos no sea muy útil 😅

*¿Cómo puede ayudarte la creación de funciones para el análisis de datos?*

-   Si realizas una misma tarea frecuentemente, puedes guardarla a una función para así **reutilizar** la operación en varios momentos de tu código.
-   Si realizas una operación matemática o estadística sobre una columna, puedes guardarla como una función para **simplificar** la lectura del código
-   Puedes simplificar los pasos de tu procesamiento de datos guardándolos como funciones, cuya entrada son los datos y la salida son los datos procesados. De este modo puedes ocultar la complejidad, lo que produce scripts **más legibles**.
-   Puedes definir todas tus funciones en otro script, permitiéndote así tener scripts **más ordenados** y **menos extensos**.

------------------------------------------------------------------------

## Control de flujo

Las estructuras de control de flujo son el conjunto de reglas que hacen que, dentro de un proceso de análisis de datos, se realicen (o no) ciertas acciones si es que condiciones específicas se cumplen, o bien, que no ocurran ciertas cosas si es que las condiciones no lo permiten. En otras palabras, es una forma de hacer que tu proceso de análisis de datos adquiera fluidez, al definir momentos en los que **el flujo del procesamiento es determinado por las condiciones que tu definas**.

*¿En qué situaciones podría ser útil el control de flujo del código?*
- Si un dato no cumple con un criterio específico, corregirlo o descartarlo.
- Si los datos llegan en cierto estado, o con ciertas particularidades, realizar un paso extra de limpieza.
- Si dentro de los datos existen observaciones de ciertas características, visualizar los datos de una manera específica.
- Si a la tabla de datos le falta una comuna columna, crearla.
- Si una columna viene en un tipo que no es el esperado, convertirla al apropiado.
- Si ocurre un error o el resultado no es aceptable, realizar la operación de nuevo de una forma alternativa.

En la práctica, esta técnica permite **crear condicionalidad en la ejecución del código** usando una comparación, cuyo resultado (`TRUE`/`FALSE`) **decide si el código siguiente se ejecutará o no**. El código dentro de la condición sólo se ejecuta si la comparación retorna `TRUE`.

Creemos un ejemplo donde definimos un vector de números, y si alguno de estos números cumple con un criterio específico, realizaremos una operación que corrija la situación:

``` r
edades <- c(15, 17, 18, 24, 29, 31, 34, 36, 45, 49, 52)

edades
```

     [1] 15 17 18 24 29 31 34 36 45 49 52

``` r
# si viene alguna edad que sea menor a 18 años, ejecutar lo siguiente
if (any(edades < 18)) {
  # filtrar vector
  menores <- edades[edades < 18]
  
  message(paste("Se detectaron registros menores de 18 años: eliminando",
                length(menores), "registros"))
  
  # dejar solamente las edades que son igual o mayor a 18
  edades <- edades[edades >= 18]
} 
```

    Se detectaron registros menores de 18 años: eliminando 2 registros

``` r
edades
```

    [1] 18 24 29 31 34 36 45 49 52

En este ejemplo, creamos un flujo de control donde un conjunto de datos se filtra sólo
si se cumple un cierto criterio. Se usa la función `any()` para detectar si es que existe algún elemento dentro del vector que cumpla con el criterio de ser menor de 18 años. Si esto es así, se ejecuta el código dentro del `if`, que detecta las observaciones problemáticas, emite un mensaje, y finalmente filtra el vector para dejar solamente las observaciones válidas, y lo retorna sobreescribiendo el vector original.

Probemos nuevamente cambiando el dato, agregando un mensaje que también confirma
si la condición no se cumple:

``` r
edades <- c(31, 34, 36, 45, 49, 52, 62, 63)

edades
```

    [1] 31 34 36 45 49 52 62 63

``` r
# si viene alguna edad que sea menor a 18 años, ejecutar lo siguiente
if (any(edades < 18)) {
  
  menores <- edades[edades < 18]
  
  message(paste("Se detectaron registros menores de 18 años: eliminando", length(menores), "registros"))
  
  edades <- edades[edades >= 18]
} else {
  # emitir un mensaje si la condición no se cumple
  message("OK: todos los registros corresponden a mayores de 18 años")
}
```

    OK: todos los registros corresponden a mayores de 18 años

En el apartado `else` podemos especificar el código que se ejecutará si la
condición que especificamos en el `if` retorna `FALSE`, o bien, simplemente podemos omitir el apartado `else` para que en cuyo caso no ocurra nada, como en el ejemplo anterior.

El control de flujo resulta particularmente útil para crear funciones más complejas. Dentro de las funciones puedes crear condicionales que realizan operaciones específicas dependiendo de lo que se le entregue a la función.

También podemos crear nuevos argumentos en la función que se usen en condicionales para alterar la operación de la función. Así puedes hacer que tu función trabaje de forma distinta dependiendo de lo que le especifiques.

## Bucles

Los bucles o loops son operaciones extremadamente útiles. Permiten generalizar tu código, en el sentido que una operación u operaciones que definas pueden aplicarse repetidas veces sobre distintos objetos, con un alto grado de libertad en el proceso.

En un bucle, se realiza una operación múltiples veces en base a un vector que entregues. Por cada elemento del vector que entregues al bucle, el código se ejecutará. En este sentido, el bucle tendrá tantos pasos como elementos tenga el vector. Cuando entregas un vector al bucle, también indicas cómo se va a llamar la variable que representa al paso; es decir, la variable que va a contener el valor del vector que se corresponde al paso que se está ejecutando.

Por ejemplo:

``` r
numeros <- c(1, 2, 3, 4)

for (paso in numeros) {
  print(paso)
}
```

    [1] 1
    [1] 2
    [1] 3
    [1] 4

En este ejemplo, creamos un vector `numeros` que contiene números del 1 al 4. Luego, definimos un bucle con el operador `for`, que en español se leería *"por cada"*. El primer argumento que definimos luego del `for` es el nombre que tendrá cada paso, luego `in`, y luego el vector. Entonces, se leería *"por cada `paso` en `numeros`, ejecutar..."*. En el ejemplo, lo que se ejecutará es solamente retornar el valor de cada paso. Es decir, en el primer paso se retorna el valor 1 de `numeros`, en el segundo paso el valor 2, y así sucesivamente.

Otro ejemplo más concreto:

``` r
pasos <- 10:20

for (i in pasos) {
  texto <- paste("este es el paso:", i)
  print(texto)
}
```

    [1] "este es el paso: 10"
    [1] "este es el paso: 11"
    [1] "este es el paso: 12"
    [1] "este es el paso: 13"
    [1] "este es el paso: 14"
    [1] "este es el paso: 15"
    [1] "este es el paso: 16"
    [1] "este es el paso: 17"
    [1] "este es el paso: 18"
    [1] "este es el paso: 19"
    [1] "este es el paso: 20"

En este caso, tenemos un vector de 10 números, por lo que el código especificado
se aplica a cada uno de los números, usando el objeto `i` como si fuera el objeto
que contiene el valor de cada paso (10, 11, 12, etc.).

Dentro de una iteración también podemos controlar el flujo del código con `if else`:

``` r
for (persona in personas) {
  
  saludo <- paste("Hola", persona)
  
  if (persona == "María José") {
    saludo <- paste0("¡Hola amiguita ", persona, "!")
  }
  
  print(saludo)
}
```

    [1] "Hola Basti"
    [1] "Hola Paula"
    [1] "Hola Catherine"
    [1] "Hola Luis"
    [1] "¡Hola amiguita María José!"

En este caso, ponemos una excepción con un `if` para que, en un paso específico del loop, el comportamiento sea distinto.

En este ejemplo, controlamos el flujo del código para que hayan múltiples condiciones,
y para que en cada condición se haga algo distinto. Podemos evaluar múltiples condiciones con `else if`, que es una forma de hacer que si la comparación anterior no coincidió con el valor, se intente se nuevo con la siguiente. Se pueden encadenar varios `else if`, y de este modo, se puede hacer que un solo valor vaya siendo evaluado en múltiples condiciones, a ver si coincide con alguna. Si coincide con alguna, se ejecuta el código correspondiente a ese paso, y se sale del flujo. Pero si no coincide con ninguna, no pasará nada a menos que al final pongas un `else` que capture todos los demás casos.

``` r
for (persona in personas) {
  
  if (persona == "Basti") {
    saludo <- paste("¡Hola a todes!")
    
  } else if (persona == "Catherine") {  
    saludo <- paste("Excelente pregunta, Catherine")
    
  } else if (persona == "Luis") {
    saludo <- sample(c("Serpiente", "Perro", "Gato", "Rata", "Gallina", "Pez"), 1)
    
  } else {
    saludo <- paste("Hola", persona)
  }
  
  print(saludo)
}
```

    [1] "¡Hola a todes!"
    [1] "Hola Paula"
    [1] "Excelente pregunta, Catherine"
    [1] "Gallina"
    [1] "Hola María José"

Por cada paso, el objeto `persona` asume el valor del elemento correspondiente del vector `personas`. El código avanza dentro del loop probando si `persona` coincide con alguna de las condiciones dadas, y si no coincide, prueba si coincide la siguiente con `else if`, y al final, si el valor no coincidió con ninguna de las comparaciones específicas de los `if`, entonces se realiza una operación general para todos los demás casos en `else`.

*¿En qué casos sería útil usar bucles o loops?*
- Si tienes múltiples objetos, observaciones, o tablas de datos, a las cuales quiera realizarles una misma operación a todas al mismo tiempo.
- Si realizaste un análisis, pero tienes que volver a realizar este mismo análisis sobre muchas versiones distintas de un conjunto de datos (por ejemplo, cuando los datos vienen separados en distintos archivos por mes o por año).
- Si tienes la ubicación de muchos archivos, y quieres cargarlos todos al mismo tiempo.
- Si tienes un conjunto de datos que puedes filtrar por una variable, y quieres generar múltiples visualizaciones a partir de el filtrado de cada una de las categorías de dicha variable. Por ejemplo, si tienes un conjunto de datos de 10 países, puedes enterar por los nombres de los países para generar 10 gráficos, uno para cada país.
- Si tienes un conjunto de datos con muchas variables, y a todas las variables quieres calcularle estadísticos descriptivos, defines el cálculo de los estadísticos descriptivos una vez, y lo pones dentro de una iteración que vaya por todas las columnas del dataframe.

------------------------------------------------------------------------

Cómo puedes ver, la creación de funciones, el control de flujo, y los bucles o iteraciones son herramientas complementarias. Muchas veces, lo que podemos hacer con una función queda mejor dentro de un bucle, o un bucle que diseñamos puede ser insertado en una función para nuestra conveniencia, y dentro de funciones o de bucle siempre vamos a estar usando el control de flujo para poder adaptarnos a todos los casos posibles que encontremos en nuestros datos.

*Luego de haber aprendido los contenidos de este tutorial, creo que podemos [dar el siguiente paso, que es adentrarnos a los datos tabulares o dataframes](../../../../blog/r_introduccion/dplyr_intro), e introducirnos al uso de R para el análisis de datos!*

{{< cafecito >}}
{{< cursos >}}
