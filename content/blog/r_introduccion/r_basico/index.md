---
title: Introducción al lenguaje de programación R
author: Bastián Olea Herrera
date: '2024-11-16'
format: hugo-md
weight: 3
series: Introducción a R
slug: []
categories:
  - Tutoriales
tags: []
lang: es
excerpt: >-
  Instrucciones paso a paso para aprender los aspectos más básicos del lenguaje
  R. Dirigida a personas sin ningún conocimiento del lenguaje. Si quieres
  aprender R desde cero, esta publicación es para ti.
execute:
  error: true
---


## Introducción a R

Esta guía contiene instrucciones paso a paso para aprender los aspectos más básicos del lenguaje R. Va dirigida a personas sin ningún conocimiento previo de R, así que si quieres aprender R desde cero, ¡sigue este tutorial!

Si sigues estas instrucciones de principio a fin, aprenderás a: trabajar con el programa RStudio, a gestionar tus scripts para el análisis, a realizar las primeras operaciones matemáticas, a comprender los distintos tipos de datos que existen en R, y a manejar las operaciones fundamentales para todo análisis posterior, ya sea básico o avanzado: objetos, comparaciones, asignaciones, vectores, y funciones.

Entender estos aspectos básicos del lenguaje es fundamental para que, en un futuro cercano, puedas utilizar R para analizar datos, crear visualizaciones, generar reportes, desarrollar aplicaciones, y mucho más.

La idea de esta guía es aproximarnos a los principios más básicos de R, en partes pequeñas y con ejemplos simples, para poder entenderlos más fácilmente. Una vez que entendamos estos principios básicos, veremos que son aplicables a bases de datos de cientos o millones de observaciones simultáneamente, sin demasiada diferencia.

### Instalación

Para **instalar R**, el lenguaje de programación, y además RStudio, el programa que te ayuda a trabajar con el lenguaje, dirígete a este post donde doy todas las instrucciones: [Primer paso: Instalar R](../../../../blog/r_introduccion/instalar_r/)

Una vez que [hayamos instalado R y R Studio](../../../../blog/r_introduccion/instalar_r/), abrimos RStudio.

El programa debía haberse más o menos así:

![](rstudio.png)

Vemos que el estudio tiene cuatro paneles. De izquierda a derecha, y de arriba a abajo, los paneles principales son:

1.  *Panel de scripts:* aquí tenemos nuestros archivos de texto con nuestro código. Podemos tener varias pestañas de distintos archivos de texto.
2.  *Panel de entorno:* acá veremos los objetos que vayamos creando, que pueden ser números, texto, tablas de datos, funciones, gráficos y otros.
3.  *Panel de consola:* en la consola se imprimen los resultados que arroja R a partir del código que ejecutamos en los scripts. También podemos ejecutar código directamente en la consola.
4.  *Panel de archivos:* en este panel podemos navegar los archivos y carpetas de nuestro proyecto y/o computador.

### Scripts

Al trabajar en R, realizamos nuestros análisis y pruebas mediante scripts. Los **scripts** son archivos de texto que terminan en `.R`. En estos archivos de texto escribimos nuestro código, intentando tener una instrucción por línea. Dentro del script, ejecutamos las instrucciones línea por línea, poniendo el cursor de texto en la línea que deseamos ejecutar, y presionando el botón *"Run"* (arriba a la derecha en el panel de scripts), o bien, presionando las teclas `comando + enter` en Mac y `control + enter` en Windows.

Al ejecutar una línea o instrucción, el comando se va a enviar a la consola, que es el panel de abajo donde se muestran las operaciones realizadas, y la consola va a retornar la respuesta o resultado.

La **consola** es la forma directa de interactuar con el lenguaje R. En ella, las instrucciones se escriben, un comando a la vez, y se presiona *enter* para enviar los comandos. La consola va a responder un resultado efímero, que sirve para que lo puedas revisar de forma rápida, pero no queda registrado en ninguna parte.

Si escribimos nuestros comandos en scripts, los comandos van a quedar guardados en texto para que los puedas volver a ejecutar, revisar, etc. Una particularidad de los scripts, es que si una línea contiene un signo gato `#`, todo lo que esté después del gato se transformará un **comentario.** Esto significa que lo que esté después del signo no se ejecuta, y por lo tanto, puedes escribir lo que quieras. Es muy recomendable que a lo largo de tu script vayas dejando comentarios, iniciando una línea con el signo gato, para ir dejando registro de las cosas que estás haciendo, ideas al respecto, correcciones, preguntas, y aclaraciones, debido a que es muy fácil confundirse o olvidarse de lo que se está haciendo.

------------------------------------------------------------------------

## Primeras operaciones en R

Ahora que tenemos nuestro R y RStudio preparados, empezaremos a utilizar R para entender sus aspectos más básicos. La idea es que vayas copiando estos códigos y los vayas ejecutando uno a uno, para ver y entender cómo funciona.

### Tipos de datos

Un *dato* es una unidad mínima de información. Puede ser un número, una palabra, o incluso puede ser nada. Esto es lo que se denomina el *tipo* de un dato, y el tipo de un dato determina, en cierto modo, lo que podemos hacer con un dato.

Los tipos principales son:

*Numéricos:*

``` r
1
2
3.1
```

Con los datos numéricos se pueden realizar todo tipo de operaciones matemáticas y transformaciones numéricas.

*Caracter* o *texto:*

``` r
"hola"
```

Los textos van entre comillas, y pueden contener cualquier caracter dentro.

*Lógicos:*

``` r
TRUE
FALSE
```

Los datos de tipo lógico son una forma de representar una condición verdadera o falsa.

En el lenguaje R, todos los datos son también denominados *objetos*, porque son elementos que contienen algo dentro de sí, aunque en lo que hemos visto hasta ahora, el objeto y su contenido son equivalentes (`1` es igual a `1`).

### Operaciones matemáticas

Quizás lo más básico que podemos hacer con un lenguaje de programación es sacar cálculos matemáticos. En R, esto es tan sencillo como escribir la expresión matemática, y teniendo el cursor de texto en la línea que queremos ejecutar, presionamos el botón *Run* (arriba a la derecha del script) o presionamos las teclas comando + enter.

A lo largo de este tutorial, vamos a ir viendo bloques de código, seguidos de su resultado.

``` r
2 + 2 # suma
```

    [1] 4

En estos dos bloques, el primero es la operación que hicimos, y el segundo es el resultado que entrega a la consola de R; en este caso, el resultado de 2 + 2.

``` r
50 * 100 # multiplicación
```

    [1] 5000

``` r
4556 - 1000 # resta
```

    [1] 3556

``` r
6565 / 89 # división
```

    [1] 73.76404

Si escribimos estas operaciones en un script, podemos ejecutar las instrucciones en cualquier orden y cuando deseemos. Sólo debemos ir poniendo el cursor de texto en la línea que queramos y ejecutarla. O bien, podemos seleccionar varias líneas y ejecutarlas todas al mismo tiempo, teniendo cuidado de seleccionar las operaciones completas[^1].

Como el tipo de los datos determina las operaciones que podemos realizar, veremos que hay ciertas operaciones que no podemos hacer conciertos datos. Si intentamos sumar dos datos de tipo caracter (texto), obtenemos un error, que dice que estamos usando un dato que no es numérico.

``` r
"1" + "1"
```

    Error in "1" + "1": non-numeric argument to binary operator

Es importante saber con qué tipo de datos estamos trabajando, para poder saber las herramientas que tenemos de nuestra disposición, o bien, para planificar qué hacer para poder hacer lo que necesitamos con los datos que tenemos.

Con esta primera operaciones matemáticas podemos entender que en un script escribimos instrucciones y las vamos ejecutando. Al ir ejecutando operaciones consecutivas vamos estructurando nuestro análisis.

### Comparaciones

Las comparaciones son una de las operaciones computacionales más básicas, pero a su vez pueden ser muy poderosas.

En una comparación, se utilizan símbolos específicos que realizan operaciones, llamados operadores, para pedirle a R que compare distintos datos.

Al comparar datos, la respuesta obtenida va a ser si la comparación es igual o es distinta a lo establecido.

Por ejemplo: ¿es 1 igual a 1?

``` r
1 == 1
```

    [1] TRUE

La *igualdad* se escribe `==`, y se usa para evaluar si dos cifras son iguales. En este caso, la comparación entre 1 y 1 retorna `TRUE` (verdadero), porque 1 es igual a 1.

``` r
1 == 2
```

    [1] FALSE

1 no es igual a 2, por lo que la comparación retorna `FALSE` (falso).

La operación inversa la igualdad es la *desigualdad*: evaluar si un dato es distinto de otro.

``` r
40 != 30
```

    [1] TRUE

40 es distinto a 30, por lo que la comparación retorna `FALSE`. Si evaluamos si dos cifras iguales son distintas, lógicamente la respuesta va a ser verdadero (`TRUE`).

``` r
40 != 40
```

    [1] FALSE

Los operadores *mayor que* (`>`) y *menor que* (`<`) retorno si una cifra es mayor o menor, respectivamente.

``` r
31 > 18
```

    [1] TRUE

``` r
40 < 80
```

    [1] TRUE

También existen los operadores mayor o igual, y menor o igual:

``` r
40 >= 40
```

    [1] TRUE

``` r
50 >= 40
```

    [1] TRUE

``` r
4 <= 5
```

    [1] TRUE

### Asignaciones

Anteriormente, mencionamos que los datos son objetos. Un objeto puede contener información de cualquier tipo, y lo relevante es que podemos crear todos los objetos que queramos para realizar nuestros análisis.

¿Cómo crear un objeto? Creamos un objeto *asignando* un dato o valor a un nombre. Es decir, tenemos un dato, y queremos que ese dato esté contenido en un nuevo objeto, el cual tendrá un nombre específico.

Para crear un objeto usamos el operador de asignación: `<-`

Al crear un objeto nuevo, el objeto va a tener un nombre: el símbolo que va a contener el dato, y por medio del cual vamos a llamar el dato contenido en el objeto.

Todos los objetos tienen un nombre, el cual puede ser solo una palabra sin separar por espacios, y puede contener símbolos como guión bajo, tildes, eñes y números.

*Crear objeto:*

``` r
año <- 1993
```

De este modo, podemos *guardar* un dato en un objeto para usarlo más adelante.

Para ver los contenidos del objeto, simplemente lo llamamos por su nombre:

``` r
año
```

    [1] 1993

Al crear un objeto, aparece en el panel de entorno o *Environment,* en el panel superior derecho de RStudio.

Podemos usar los objetos para realizar operaciones matemáticas, porque llamar a un objeto, es reutiliza el dato que está dentro de ese objeto:

``` r
año + 10
```

    [1] 2003

``` r
2024 - año
```

    [1] 31

Podemos crear un nuevo objeto a partir de un cálculo, escribiendo un cálculo y asignándolo a un nuevo objeto:

``` r
edad <- 2024 - año
edad
```

    [1] 31

### Ejemplos

Para practicar con la idea de que los objetos son símbolos que contienen datos, crearemos distintos objetos los usaremos para hacer distintos cálculos sencillos.

#### Ejemplo 1

En este ejemplo, definiremos unas cifras que representan el cálculo de un presupuesto.

Primero, definimos varios datos. Cuando un dato hace referencia a un aspecto real de algo, ya sea una propiedad o cualidad, se le denomina *variable,* debido a que estas cualidades no son fijas, sino que cambian en las distintas situaciones, contextos o realidades.

``` r
presupuesto <- 100000
pizza <- 12000
bebida <- 2500
```

Restamos todos los objetos para ver cuánto queda de presupuesto:

``` r
presupuesto - pizza - bebida
```

    [1] 85500

También podemos usar paréntesis para ordenar nuestras operaciones:

``` r
presupuesto - (pizza + bebida) 
```

    [1] 85500

#### Ejemplo 2

Repetimos la creación de un presupuesto al definir nuestras variables:

``` r
presupuesto <- 100000
pizza <- 12000
bebida <- 2500
```

El objeto `pizza` representa el precio de una sola pizza. Pero en este ejemplo, necesitamos comprar varias pizzas, así que crearemos un objeto nuevo a partir de una operación:

``` r
pizzas_totales <- pizza * 4
pizzas_totales
```

    [1] 48000

También tenemos que considerar la compra de bebidas:

``` r
bebidas_totales <- bebida * 2
bebidas_totales
```

    [1] 5000

Ahora hacemos el cálculo del presupuesto considerando los dos objetos nuevos que creamos, y guardamos el resultado en otro objeto:

``` r
total <- pizzas_totales + bebidas_totales
total
```

    [1] 53000

Restamos el total de las compras con el presupuesto disponible:

``` r
restante <- presupuesto - total
```

Ahora revisamos el resultado:

``` r
restante
```

    [1] 47000

La gracia de hacerlo así es que facilita la posiblidad de ir modificando los precios de los objetos, sus cantidades, y luego volver a ejecutar todas las líneas para llegar al resultado actualizado.

*Ejercicio:*
- Intenta volver al principio del ejemplo, donde se definen las variables, y modifica el precio de alguna. Luego, vuelve a ejecutar los cálculos para llegar al nuevo monto restante.
- Intenta reescribir este último ejemplo, pero haciendo que las cantidades de pizzas y bebidas sean también variables que se definan al principio del cálculo, junto con el resto de las variables. Define estas nuevas variables con valores distintos, y llega al nuevo resultado.

------------------------------------------------------------------------

Si bien estos ejemplos pueden parecer muy básicos, la estructura de análisis más complejos sigue patrones bastante bastante similares a los que estamos viendo ahora.

------------------------------------------------------------------------

## Vectores

Hasta este punto, hemos visto operaciones sobre un solo dato a la vez; es decir, sobre objetos que contienen un solo elemento. Pero en la vida real, probablemente queremos realizar cálculos sobre múltiples datos a la vez, ya sea desde hojas de cálculos, planillas o bases de datos.

Los objetos en R pueden tener múltiples propiedades. Una de estas es su largo. Un objeto que contiene un solo dato es un objeto de largo 1. Los **vectores** en R son objetos que contienen una secuencia de datos, una cadena de valores.

Los vectores tienen elementos, tienen un largo, y tienen un tipo.

Podemos crear un vector de forma manual con la función `c()`:

``` r
c(1, 2, 3, 4, 5, 6, 7, 8)
```

    [1] 1 2 3 4 5 6 7 8

En este bloque de código hemos creado un vector, una secuencia de valores que tiene ocho elementos.

En un vector podemos almacenar datos arbitrarios, siempre y cuando sean todos del mismo tipo.

``` r
c(40, 2, 7, 345)
```

    [1]  40   2   7 345

``` r
c("a", "b", "c", "d")
```

    [1] "a" "b" "c" "d"

Si queremos crear un vector que contenga una secuencia continua de números, podemos usar el operador `:` entre el número de inicio y el número final de la secuencia:

``` r
1:10 # números de 1 al 10
```

     [1]  1  2  3  4  5  6  7  8  9 10

``` r
1990:2010 # años del 1990 al 2010
```

     [1] 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004
    [16] 2005 2006 2007 2008 2009 2010

Podemos realizar **operaciones** sobre los vectores, dado que son secuencias de datos, y la operación se va a aplicar a todos sus elementos:

``` r
c(1, 2, 4, 8) + 100
```

    [1] 101 102 104 108

``` r
c(31, 32, 56, 74) - 2024
```

    [1] -1993 -1992 -1968 -1950

``` r
1:10 * 20
```

     [1]  20  40  60  80 100 120 140 160 180 200

También podemos hacer **comparaciones** sobre los elementos de un vector:

``` r
c(3, 3, 4, 5, 4, 3) == 3
```

    [1]  TRUE  TRUE FALSE FALSE FALSE  TRUE

``` r
c("sí", "no", "sí", "sí") == "no"
```

    [1] FALSE  TRUE FALSE FALSE

Pero el potencial de los vectores es cuando están asignados a un objeto. Asignamos a un objeto el vector de números:

``` r
edades <- c(25, 27, 30, 45, 37, 28, 46, 54)
```

Teniendo un objeto que contiene una secuencia de datos, ahora podemos realizar operaciones escritas de una forma más abstracta o resumida, y que se empiezan a acercar a casos de uso reales.

``` r
edades - 40
```

    [1] -15 -13 -10   5  -3 -12   6  14

``` r
edades > 30
```

    [1] FALSE FALSE FALSE  TRUE  TRUE FALSE  TRUE  TRUE

``` r
edades == 30
```

    [1] FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE

Para acceder para acceder a uno de los valores específicos de un vector, usamos las sintaxis de corchetes. Dentro de corchetes ponemos el elemento o elementos del vector que queremos extraer.

``` r
edades[3]
```

    [1] 30

``` r
edades[1:3]
```

    [1] 25 27 30

### Tipos de datos en vectores

Por definición, los valores de los vectores en R son todos de un mismo tipo. Esto se debe a que queremos realizar operaciones sobre los factores, y como las operaciones dependen del tipo de cada dato (no podrmos sumar letras), garantizar que los vectores sean de un mismo tipo permite que siempre podamos realizar operaciones en todas sus elementos.

Cuando creamos un vector de distintos tipos de datos, R va a reducirlo por defecto a un solo tipo:

``` r
c(1, 2, 3, 4, "cinco")
```

    [1] "1"     "2"     "3"     "4"     "cinco"

Si notamos la salida de la consola, podemos ver que los números aparecen envueltos en comillas, porque la presencia de un elemento de tipo carácter dentro del vector hizo que todos los demás elementos fueran convertidos a caracter.

### Ejemplos

#### Ejemplo 1

Un vector con años de nacimiento, y luego restamos el año actual al vector, para obtener las edades actuales de las personas que nacieron en esos años.

``` r
años <- c(1992, 1997, 1986, 1980, 1999)
edades <- 2024 - años
edades
```

    [1] 32 27 38 44 25

Si el objeto resultante le sumamos 10, podemos obtener las edades que tendrían estas personas 10 años después.

``` r
edades_en_10_años <- edades + 10
edades_en_10_años
```

    [1] 42 37 48 54 35

#### Ejemplo 2

Tenemos un vector con precios de productos, y un objeto que contiene un determinado valor, que sería el presupuesto que tenemos. Queremos saber qué productos son más baratos que el presupuesto. Entonces, comparamos los elementos del vector `precios` con el `presupuesto`:

``` r
precios <- c(10500, 26990, 9900, 56700, 12350, 12000, 24990)
presupuesto <- 15000
precios < presupuesto
```

    [1]  TRUE FALSE  TRUE FALSE  TRUE  TRUE FALSE

El resultado es un vector de valores lógicos que indican si que el precio es menor o no que el presupuesto.

Podemos usar ese resultado para filtrar el vector `precios`, porque cada valor verdadero o falso se corresponde con el valor de la misma posición en el vector original. Es decir, el primer elemento del vector `precios` es menor al `presupuesto`, el segundo no, el tercero sí, etc. Así podemos obtener exactamente los datos que cumplen la condición:

``` r
precios[precios < presupuesto]
```

    [1] 10500  9900 12350 12000

Esto funciona porque, como habíamos mencionado antes, se pueden seleccionar elementos específicos del vector usando corchetes, y en este caso, los elementos que están siendo seleccionados son los que resultan `TRUE` de la comparación `precios < presupuesto`.

------------------------------------------------------------------------

## Funciones

Las funciones son pequeños programas que se aplican a nuestros objetos o vectores.

El uso de funciones es la ventana que nos abre posibilidades a nuevas herramientas y análisis, porque dentro de ellas se pueden ejecutar operaciones e instrucciones mucho más complejas que las que hemos visto hasta el momento.

Una función es simplemente un programa dentro del cual se entregan ciertos argumentos.

``` r
funcion(argumento_1, argumento_2, ...)
```

Dependiendo de lo que haga la función, dentro de ella podemos poner uno o varios vectores, un vector con algunas opciones definidas, u objetos más complejos que veremos adelante.

Una función sencilla es la función `mean()`, que calcula el promedio de los valores de un vector:

``` r
mean(c(10, 20, 39))
```

    [1] 23

``` r
cifras <- c(1, 5, 4, 7, 8, 4, 3, 2, 9, 0, 2)
mean(cifras)
```

    [1] 4.090909

``` r
años <- c(1992, 1997, 1986, 1980, 1999, 2010, 1993, 1976)
edades <- 2024 - años
mean(edades)
```

    [1] 32.375

Como R es un lenguaje principalmente estadístico, hay varias funciones matemáticas que operan sobre vectores de números:

``` r
mean(edades) # promedio
```

    [1] 32.375

``` r
min(edades) # mínimo
```

    [1] 14

``` r
max(edades) # máximo
```

    [1] 48

``` r
median(edades) # mediana
```

    [1] 31.5

``` r
sum(edades) # suma
```

    [1] 259

También hay funciones que no realizan cálculos sobre los datos, sino que nos dicen otra cosa sobre ellos:

``` r
length(edades)
```

    [1] 8

Algo que podría ser importante de confirmar, como hemos visto, sería el tipo de un vector. Para esto, existen varias funciones:

``` r
class(edades)
```

    [1] "numeric"

La función permite saber la clase de un objeto, que es una propiedad de los objetos relacionada a su tipo. En este caso retorna *numeric,* porque se trata de números, pero en realidad el tipo es otro:

``` r
typeof(edades)
```

    [1] "double"

Esto ocurre porque los números pueden ser de distintos tipos: hay números enteros (*integer*), números decimales (*double*), entre otros, y tienen características distintas. Pero es suficiente con saber si es o no numérico para la mayoría de los casos.

Otras funciones permiten consultar si un objeto es de un tipo específico:

``` r
is.numeric(edades)
```

    [1] TRUE

``` r
is.character(edades)
```

    [1] FALSE

Si tenemos un vector de un tipo que no nos sirve, podemos convertirlo a uno que si nos sirva:

``` r
numeros <- c(1, 2, 3, 4, "perro")
numeros_2 <- as.numeric(numeros) # convertir a números
```

    Warning: NAs introduced by coercion

``` r
numeros_2
```

    [1]  1  2  3  4 NA

Notamos que R nos entrega una alerta! dice que hay `NA` introducidos por coerción. Los valores `NA` son también llamados valores *perdidos,* y significa que es un elemento de un vector que no contiene nada. En este caso, el último elemento del vector es convertido a un dato perdido, porque el texto *perro* no se corresponde realmente con ningún número.

``` r
is.character("texto") # retorna TRUE si el objeto es un texto
```

    [1] TRUE

``` r
is.character(11111) # retorna FALSE si el objeto no es un texto
```

    [1] FALSE

``` r
is.numeric(4985984) # retorna TRUE si el objeto es un número
```

    [1] TRUE

``` r
is.numeric(5555)
```

    [1] TRUE

``` r
as.character(4444)
```

    [1] "4444"

Si necesitamos saber qué hace una función, o cómo funciona, podemos escribir en la consola un `?` seguido por el nombre de la función `?as.numeric`, o bien, entrar al panel de ayuda de RStudio, que se encuentra en la parte inferior derecha de la pantalla, y buscar la función que queramos aclarar.

En la ayuda de R aparecen las funciones explicadas, con ejemplos, con detalles de cada uno de sus argumentos, y más.

### Números al azar

La función `sample()` permite obtener una cantidad de elementos al azar desde otro conjunto de elementos. Por ejemplo, obtengamos un número al azar entre uno y 10 millones:

``` r
numeros <- 1:10000000
sample(numeros, size = 1)
```

    [1] 4407528

La función recibe como primer argumento el vector de elementos, y como segundo argumento la cantidad de elementos que queremos obtener al azar.

Intenta cambiando el segundo argumento para que te entregue cuatro números al azar.

### Redactar textos

Otra función básica es `paste()`, que te permite unir varios elementos en un sólo texto:

``` r
texto_1 <- "Hola"
texto_2 <- "amigues"
paste(texto_1, texto_2)
```

    [1] "Hola amigues"

Podemos unir varios elementos, sacados de vectores o calculados con funciones, para generar un texto más complejo:

``` r
años <- c(1992, 1997, 1986, 1980, 1999, 2010, 1993, 1976)
edades <- 2024 - años
promedio <- mean(edades)

paste("Entre las", length(edades), "edades analizadas,",
      "el promedio fue de", promedio,
      "y la edad máxima fue de", max(edades), "años."
)
```

    [1] "Entre las 8 edades analizadas, el promedio fue de 32.375 y la edad máxima fue de 48 años."

Podemos usar esta función combinada con `sample()` para obtener un muestreo aleatorio de cualquier tipo de elementos, lo que puede servir para hacer algunas cosas entretenidas:

``` r
animales <- c("gato", "mapache", "castor", "pollo", "ratón", "pudú")
paste("el animal más lindo es el", sample(animales, 1))
```

    [1] "el animal más lindo es el pudú"

### Redondear datos

En el ejemplo anterior, obtuvimos que el promedio de edades era 32.375. Si queremos redondear este número, podemos abusar la función `round()`, cuyo primer argumento es el número o números que queremos redondear, y el segundo es la cantidad de decimales:

``` r
round(mean(edades), digits = 1)
```

    [1] 32.4

### Condicionales

Una función condicional permite hacer algo si se cumple o no una condición. Esto que puede sonar sencillo puede resultar tremendamente útil.

En la función `ifelse()`, el primer argumento es una comparación, y luego hay que especificar dos argumentos más: el primero es lo que queremos si la comparación es *verdadera*, y lo segundo es lo que queremos si la comparación es *falsa*. La expresión *"if else"* significa en castellano "si pasa esto, entonces haz esto". En una sentencia *if else,* se define una o más condiciones que queremos que se cumplan para ejecutar un código y, si esa condición no se cumple, ejecutamos otro código (o no ejecutamos nada).

Por ejemplo, evaluamos si un número es mayor a 5, y si es así, retornamos la palabra *alto,* y si no, retornamos la palabra *bajo*:

``` r
numero <- 10
ifelse(numero > 5, 
       yes = "alto", no = "bajo")
```

    [1] "alto"

``` r
numero <- 3
ifelse(numero > 5, 
       yes = "alto", no = "bajo")
```

    [1] "bajo"

Tenemos un vector de la cantidad de dulces que comieron unas personas. Si definimos que comer más de 4 dulces es mucho, aplicamos la función `ifelse()` para categorizar las cantidades de dulces que comieron las personas:

``` r
dulces <- c(3, 2, 4, 3, 5, 6, 5, 7, 6, 2, 1, 2, 3, 2)

dulces_2 <- ifelse(dulces >= 4, 
                   yes = "muchos", 
                   no = "normal")
dulces_2
```

     [1] "normal" "normal" "muchos" "normal" "muchos" "muchos" "muchos" "muchos"
     [9] "muchos" "normal" "normal" "normal" "normal" "normal"

Luego, podemos usar una suma condicionada para saber cuántas personas comieron muchos dulces:

``` r
sum(dulces_2 == "muchos") # cantidad de personas que comieron "muchos" dulces
```

    [1] 6

Con este otro ejemplo, aprenderemos a usar el operador de inclusión, `%in%`, qué es lo que hace es determinar si un elemento está dentro de otro conjunto de elementos. Creamos un vector de elementos, y un segundo actor que contiene un subgrupo de los elementos. Luego, usamos el operador de inclusión `%in%` para saber cuál de los primeros elementos están dentro del segundo grupo de elementos. En este caso, tenemos un vector con los colores, y después los colores que yo considero que son más lindos, y queremos saber cuál es están dentro de este grupo de colores más lindos:

``` r
colores <- c("rojo", "verde", "azul", "rosado", "amarillo", 
             "morado", "naranjo", "gris", "lavanda", "celeste")
lindos <- c("morado", "rosado")

colores %in% lindos
```

     [1] FALSE FALSE FALSE  TRUE FALSE  TRUE FALSE FALSE FALSE FALSE

Luego, aplicaremos el mismo principio, pero dentro de un `if_else()`, para asignarle la categoría lindo o feo a cada uno de los colores:

``` r
opinión <- ifelse(colores %in% lindos, 
                  yes = "lindos",
                  no = "feos")

opinión
```

     [1] "feos"   "feos"   "feos"   "lindos" "feos"   "lindos" "feos"   "feos"  
     [9] "feos"   "feos"  

Finalmente, podemos hacer una tabla con los resultados, o una suma condicionada, para saber cuántos colores caen en cada categoría:

``` r
table(opinión)
```

    opinión
      feos lindos 
         8      2 

``` r
paste("Hay", sum(opinión == "feos"), "colores feos,",
      "y", sum(opinión == "lindos"), "colores lindos")
```

    [1] "Hay 8 colores feos, y 2 colores lindos"

------------------------------------------------------------------------

## Conclusión

Si bien en estas instrucciones no aprendimos a analizar datos, si considero que comprender estos principios es algo fundamental para poder pasar al análisis de datos teniendo dudas recurrentes despejadas y una familiaridad con elementos básicos del lenguaje que es necesaria. Por ejemplo, saber lo que es un vector, o entender las particularidades de los tipos o clases, ahorra caer en los errores más recurrentes de personas que entran a R a trabajar directamente con tablas de datos sin entender qué está pasando internamente.

El entender cómo funcionan estas pequeñas herramientas, y familiarizarse con su uso nos facilitará bastante la aplicación del lenguaje al procesamiento de tablas, bases de datos, y otras situaciones en las que podemos aplicar R para ayudarnos y para producir resultados.

------------------------------------------------------------------------

*Si entendiste este tutorial y quieres pasar al siguiente nivel, mala suerte porque todavía no lo escribo 😂 pero podrías atreverte a intentar con este otro tutorial en el cual se abarcan herramientas básicas de manipulación de datos: [Tutorial: introducción a {dplyr} con datos de población](../../../../blog/r_introduccion/tutorial_dplyr_censo/)*

Si este tutorial te sirvió, por favor considera hacerme una donación, al menos para poder tomarme un cafecito 🥺

<div style = "height: 18px;">
</div>
<div>
  <div style="display: flex;
  justify-content: center;
  align-items: center;">
    <script type="text/javascript" src="https://cdnjs.buymeacoffee.com/1.0.0/button.prod.min.js" data-name="bmc-button" data-slug="bastimapache" data-color="#FFDD00" data-emoji="☕"  data-font="Cookie" data-text="Regálame un cafecito" data-outline-color="#000000" data-font-color="#000000" data-coffee-color="#ffffff" ></script>
  </div>

[^1]: Si ejecutamos una línea incompleta, puede ser que la consola de R quede esperando que terminemos la expresión o que la completemos, y esto puede ser muy confuso para usuarios principiantes. Por ejemplo, si ejecutamos `1 +`, la consola va a quedar esperando que le demos el número que está esperando que venga, y cualquier otra cosa que le entreguemos va a intentar sumársela a la operación anterior que quedó inconclusa.
