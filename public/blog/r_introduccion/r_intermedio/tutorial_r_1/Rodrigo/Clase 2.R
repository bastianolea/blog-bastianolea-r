# En esta clase veremos: tipos de datos, funciones, 
# comparaciones, vectores y objetos

# Como este script es más largo, recordemos que podemos usar el "índice" que está al lado derecho del panel de script para navegar por los títulos y subtítulos



# Tipos de datos ----
# Cada objeto en R tiene una clase o tipo. Las clases pueden ser:

# Numéricos
1
2
3
4.3

# Caracter
"hola"
"yo me llamo Bastián"
# "1" + "1"
# "1" + 1

# Lógicos
TRUE
FALSE



# Funciones ----
# Son pequeños programas u operaciones que podemos ejecutar sobre nuestros objetos

is.character("texto") #retorna TRUE si el objeto es un texto

is.character(11111) #retorna FALSE si el objeto no es un texto

is.numeric(4985984) #retorna TRUE si el objeto es un número

?is.numeric #buscar ayuda sobre una función

is.numeric(5555)

as.character(4444)

# Podemos usar la función class() para saber el tipo de un objetos
class(5)
class("hola")
class(TRUE)

# Esta función transforma elementos de un tipo a otro tipo
# a esto se le llama "coerción"
as.numeric("777")
as.numeric("perro") #si no se puede convertir, arroja una alerta



# Comparación ----
# Utilizando operadores (símbolos que realizan operaciones) podemos pedirle a R que compare cifras:
# La igualdad se escribe "==" y se usa para evaluar si dos cifras son iguales
# La respuesta de las comparaciones es TRUE o FALSE (verdadero o falso)

# Igualdad
1 == 1
1 == 2

# Desigualdad
40 != 30
40 != 40

# Mayor que
31 > 18

# Menor que
40 < 80

# Mayor o igual, menor o igual
40 >= 40
4 <= 5



# Vectores ----
# Los vectores son la unidad principal de R, y corresponden a secuencias de datos, como cadenas de valores.
# Los vectores tienen elementos, tienen un largo, y tienen un tipo

# Podemos crear un vector de forma manual con la función c() (combinar)
c(1, 2, 2, 1, 2, 2, 3, 4)

# Podemos realizar operaciones sobre los vectores, y la operación se va a aplicar a todos sus elementos
c(1, 2, 2, 1, 2, 2, 3, 4) + 100

c(1, 2, 2, 1, 2, 2, 3, 4) * 54849

c(31, 32, 56, 74, 10) - 2024

2024 - c(31, 32, 56, 74, 10) #el orden de la operación no importa

# También podemos hacer comparaciones sobre los elementos de un vector
c(3, 3, 3, 4, 5, 4, 3) == 3

c(1, 1, 1, 0, 1) == 0

# Se pueden crear vectores de números continuos usando el operador ":"
1:10 #números de 1 al 10

1990:2024 #años del 1990 al 2024

# Podemos poner vectores dentro de funciones para que la función opere sobre los elementos
mean(c(10, 20, 50))

mean(c(10, 20, 50, 7, 7, 7, 7))

# Acá sacaremos el promedio de 80 millones de números:
mean(1:87667899)



# Objetos ----
# R es un lenguaje caracterizado por ser "orientado a objetos"
# Un objeto es un elemento que creamos, que puede contener información de cualquier tipo
# Podemos crear objetos asignando un valor a un objeto. Para eso usamos el operador de asignación, "<-"
# De este modo, podemos "guardar" un dato en un objeto para usarlo más adelante
# Los objetos tienen un nombre, el cual puede ser solo una palabra sin separar por espacios, y puede contener símbolos como guión bajo, tildes, eñes y números

# Crear objetos
año_actual <- 2080
año_nacimiento <- 1952
# Al crear un objeto, aparece en el panel de entorno, "Environment", en la parte superior derecha

# Para ver los contenidos del objeto, simplemente lo llamamos por su nombre
año_nacimiento

# Podemos usar los objetos para calcular, porque R sabe que en el fondo son cifras
año_actual - año_nacimiento #restar

# También podemos crear un nuevo objeto a partir de un cálculo
edad <- año_actual - año_nacimiento 

edad


## Ejemplo de operaciones con objetos ----
# Crearemos distintos objetos, y luego realizaremos un cálculo
presupuesto <- 100000
pizza <- 15000
bebida <- 3500

# Restamos todos los elementos para ver cuánto queda de presupuesto
presupuesto - pizza - bebida
# También podemos usar paréntesis para ordenar nuestras operaciones
presupuesto - (pizza - bebida) 


## Ejemplo 2 ----
presupuesto <- 100000
pizza <- 15000
bebida <- 3500

# Creamos otro objeto a partir de una operación
pizzas_totales <- pizza * 20

# Hacemos el cálculo, pero guardamos el resultado en otro objeto
restante <- presupuesto - pizzas_totales - bebida

# Ahora revisamos el resultado
restante

# La gracia de hacerlo así es que facilita la posiblidad de ir modificando los precios de los objetos, sus cantidades, y luego volver a ejecutar todas las líneas para llegar al resultado actualizado


## Otros ejemplos ---- 
corrupcion <- 30000000000
auto <- 20000000

corrupcion/auto


corrupcion = 30000000000
palta = 6000
tonelada = palta*1000

corrupcion/tonelada

## Aplicar funciones a objetos ----
# Creamos un objeto que contenga un vector
edades = c(20, 24, 25, 27, 19, 20, 23, 22, 20, 20, 24, 25, 27, 19, 20, 23, 22, 20)

edades

# Luego podemos aplicar funciones a estos objetos
mean(edades)
median(edades)
min(edades)
max(edades)
var(edades)
sd(edades)
