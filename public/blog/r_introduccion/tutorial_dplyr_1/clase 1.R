# Introducción ----

# En esta clase vimos: operaciones matemáticas, comparaciones, vectores, asignación, funciones,
# función ifelse, instalación de paquetes, y dplyr.

# Antes de iniciar el análisis, creamos un Proyecto de R.
# Un proyecto es una carpeta donde guardamos todos los scripts y archivos que vamos a necesitar. 
# Luego, podemos abrir nuestro proyecto haciendo doble clic en el archivo que termina en ".Rproj"

# Realizamos nuestro análisis mediante Scripts. 
# Un script de R es un archivo de texto cuyo nombre termina en ".R", en el que vamos escribiendo las instrucciones para nuestro análisis.
# Dentro del script, ejecutamos las instrucciones línea por línea, poniendo el cursor de texto en la línea que deseamos, y presionando el botón "Run", o bien, presionando las teclas comando + enter.
# Al ejecutar una línea o instrucción, el comando se va a enviar a la consola, que es el panel de abajo donde se muestran las operaciones realizadas, y la consola va a retornar la respuesta o resultado.

# En un script, un comentario empieza con signo gato (#), y es una línea de código que no se ejecuta
# en cualquier comentario, si le agregamos cuatro guiones al final, se transforma en un título
# así podemos navegar el script como si tuviera un índice. 
# Podemos abrir y cerrar este índice si apretamos el último botón del panel de scripts, que es como un párrafo gris


# Operaciones matemáticas ----

2 + 2 #suma

50 * 100 #multiplicación

4556-000 #resta

6565 / 89 #división

10^4 #potencias

# Podemos ejecutar estas instrucciones en cualquier orden y cuando deseemos.
# Lo importante es entender que en un script podemos escribir instrucciones y ejecutarlas. Así estructuramos nuestro análisis.
# Nada de lo que ejecutemos de esta forma queda guardado, a menos que los guardemos nosotros, pero el procedimiento en sí mismo (las instrucciones) sí queda guardado en el script, para poder ejecutarlo en otra ocasión.

1 + 1

1000 * 9989786

5 + 9

5454645 / 767676

4343 + 24434 - 4354 * 54565

(4343 + ((24434 - 4354) * 54565))


# Texto ----
# Los objetos que son texto van entre comillas, y pueden contener cualquier caracter dentro.
# Naturalmente, no se pueden hacer operaciones matemáticas sobre texto
# Ejemplos de dato de tipo texto podrían ser los nombres de comunas
"hola"

"hola como estás"

"1" + "2"


# Comparaciones ----
# Utilizando operadores (símbolos que realizan operaciones) podemos pedirle a R que compare cifras:
# La igualdad se escribe "==" y se usa para evaluar si dos cifras son iguales
# La respuesta de las comparaciones es TRUE o FALSE (verdadero o falso)

1 == 1

2 != 2

10000 >= 40

10000 <= 40

444 == 434
3 != 3
40 > 7
5.2 > 5.1


# Vectores ----
# Los vectores son secuencias de elementos
# Creamos los vectores usando la función "c", separando los valores por comas

c(1, 2, 3, 4, 5, 6, 7)

1:10
1:100000
10:1
2000:2024


# Asignaciones ----
# R es un lenguaje caracterizado por ser "orientado a objetos"
# Un objeto es un elemento que creamos, que puede contener información de cualquier tipo
# Podemos crear objetos asignando un valor a un objeto. Para eso usamos el operador de asignación, "<-"
# De este modo, podemos "guardar" un dato en un objeto para usarlo más adelante
# Los objetos tienen un nombre, el cual puede ser solo una palabra sin separar por espacios, y puede contener símbolos como guión bajo, tildes, eñes y números

# Al crear un objeto, aparece en el panel de entorno, "Environment", en la parte superior derecha
edad <- 50
año <- 2024 - edad
año

# Podemos usar objetos para realizar operaciones 
perro <- 5
gato <- 3
perro + gato
total <- perro + gato
total

numeros <- c(1, 2, 3, 2, 3, 4, 3, 2, 3, 4)

numeros

is.numeric(numeros)

is.character(numeros)

numeros + 100


# Guardar un objeto como vector
edades <- c(20, 30, 40, 50, 45, 35, 24, 60, 14, 36, 47, 79)

# Podemos realizar operaciones sobre los vectores, donde el cálculo se aplica a cada elemento

edades - 2024

edades - 40

edades > 30

edades == 30

edades[3] #acceder a uno de los elementos del vector, ene ste caso al tercero



# Funciones ----
# Las funciones son pequeños programas que se aplican a nuestros objetos o vectores

mean(edades) #promedio
median(edades) #mediana
max(edades) #máximo
min(edades) #mínimo

length(edades) #largo del vector, es decir, su cantidad de elementos

mean(c("a", "b", "c"))

is.numeric("hola") # esta función consulta si el objeto que se le entrega es de tipo numérico


# Ejemplo: calcular un presupuesto

# creamos varios objetos para luego obtener diversos resultados
presupuesto <- 150000

pizza <- 14000
bebida <- 3000
palitos <- 10000

# calcular gastos totales
gastos <- pizza*6 + bebida*4 + palitos*2

# consultar acerca de los gastos
gastos > presupuesto # ¿los gastos superan al presupuesto?
restante = presupuesto - gastos # ¿cuánto dinero resta del persupuesto?

# usamos la función paste para "pegar" objetos, en este caso, un texto, el resultado
# de la operación anterior, y otro texto, para formar una oración:
paste("quedan", restante, "pesos de presupuesto")


# ifelse ----
# "if else" significa en castellano "si pasa esto, entonces haz esto"
# en una sentencia if else, se define una o más condiciones que queremos que se 
# cumplan para ejecutar un código y, si esa condición no se cumple, ejecutamos 
# otro código (o no ejecutamos nada)

# usamos la función ifelse() para realizar una comparación, y si la comparación es TRUE, 
# hacer una cosa, y si es FALSE, hacer otra
# en este caso, hacemos que retorne textos distintos para cada caso, en base al resultado
# de la operación anterior:

ifelse(gastos > presupuesto, 
       "nos quedamos sin plata", 
       "estamos bien")

ifelse(test = gastos > presupuesto, 
       yes = "nos quedamos sin plata",
       no = "estamos bien")


# Instalar un paquete ----

# es necesario instalarlos una sola vez
# install.packages("readxl")
# install.packages("dplyr")

# hay que cargar los paquetes cada vez que los queramos usar
library(readxl)
library(dplyr)

# cargar datos desde excel usando el nombre del archivo
datos <- read_excel("campamentos_chile_2024.xlsx")

# ver datos cargados en la consola
datos
# Este tipo de objetos se llaman "data frame", específicamente "tibble", que es un tipo de tabla
# Los dataframes son tablas de datos hechas a partir de vectores. 
# Tenemos que tener en mente que cada columna de los dataframes son un vector, 
# por lo que vamos a poder aplicar nuestros conocimientos anteriores a los dataframes

# Podemos aplicar funciones al dataframe
length(datos) #el "largo", o su cantidad de columnas
nrow(datos) #su cantidad de filas
str(datos) #su estructura interna

# ver datos en una nueva pestaña
View(datos)

# ver nombres de las columnas de un dataframe
names(datos)

# acceder a una de las columnas del dataframe, para verlas como vectores
datos$hogares

# aplicar funciones a las columnas
mean(datos$hogares)
round(mean(datos$hogares), 0)


# dplyr ----
# usamos el paquete dplyr, que nos permite manejar datos con mayor facilidad
# una de las particularidades de dplyr es el uso de un "pipe" o conector, lo que 
# nos ayuda a encadenar instrucciones. Este conector puede escribirse como %>% o |> 
# y también puede hacerse si presionas las teclas comando + shift + M (en Mac) y control + shift + M (en Windows)
# es equivalente a leerlo como si dijera "luego" o "entonces"

# ejemplo de dos operaciones encadenadas
datos |> 
    select(nombre, hogares, hectareas) |> 
    filter(hogares > 60)

## seleccionar ----
datos |> select(nombre, area)
datos |> select(-region)
datos |> select(-region, -comuna)
datos |> select(-starts_with("cut")) 

## filtrar ----
# usamos una comparación sobre una columna del dataframe para filtrar las observaciones (filas),
# dejando solamente las filas que cumplen con la condición
datos |> 
    filter(hogares > 100) 

# otros ejemplos
datos |> 
    filter(hogares == 97)

# dos filtros a la vez
datos |> filter(hogares > 100, hectareas < 1)

datos |> 
    filter(hogares > 100) |> 
    filter(hectareas < 1)
# se puede hacer de ambas formas: dos filtros en una sola llamada de "filter", o dos consecutivas

# seleccionar y filtrar a la vez
datos |> 
    filter(hogares > 100) |> 
    select(nombre, hogares, hectareas) |> 
    filter(hectareas < 1)

## ordenar ----
# ordenar observaciones en base a una o varias columnas
datos |> 
    arrange(hogares)

datos |> 
    arrange(desc(hogares)) #ordenamiento de mayor a menor

datos |> 
    arrange(desc(hogares), desc(hectareas)) #ordenar por dos variables

# filtrar y ordenar
datos |> 
    filter(hogares > 100) |> 
    arrange(desc(hogares))

# filtrar, ordenar, e imprimir (mostrar) más de 10 filas
datos |> 
    filter(hogares >70) |> 
    arrange(region, desc(hogares), desc(hectareas)) |> 
    print(n = 20)
