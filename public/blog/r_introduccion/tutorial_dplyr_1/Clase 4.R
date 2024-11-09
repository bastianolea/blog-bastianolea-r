# En esta clase aprendimos a instalar y cargar paquetes, y a usar dplyr para: 
# seleccionar columnas, filtrar datos, ordenar datos
# También aprendimos a cargar datos de Excel y guardar en formato Excel


# Repaso ----

# Crear vectores de datos
objetos <- c(1, 1, 1, 2, 3, 4, 5, 8)

# Ejecutamos el nombre del objeto para mirar en la consola lo que contiene
objetos

# Podemos aplicar funcionres a los objetos o a los vectores
mean(objetos)

mean(c(1, 2, 3, 4, 5, 6, 7))

# a veces ocurren errores: un warning es un "aviso" pero que igual entrega resultado, un "error" es derechamente un error que detiene la ejecución
mean(c("b", "c", "d")) #warning
mean(c("d", 5, )) #error


# —----


# paquetes
# Los paquetes son conjuntos de funciones, programas, datos y documentación que sirven para potenciar R
# Para poder usarlos, primero hay que instalarlos usando install.packages().
# Luego de instalarlos, simplemente los cargamos usando library()

# Instalación de paquetes
install.packages("tidyverse") #solo es necesario de ejecutar la primera vez
# Tidyverse es un conjunto de paquetes que ayudan al análisis de datos. Es como un paquete que te instala varios paquetes útiles

# Cargar paquete
library(dplyr) 
# Dplyr es un paquete parte de Tidyverse que se usa para manejar datos
# Los paquetes contienen funciones. Podemos revisar la ayuda de R para navegar la documentación de cada función:



# Cargar datos ----

# Primero vamos a leer un archivo Excel. los arhcivos Excel suelen terminar en .xls o .xlsx
# Para esto, instalamos otro paquete: "readxl"
install.packages("readxl") #el nombre de los paquetes a instalar va entre comillas

# Luego, lo cargamos para poder usarlo
library(readxl)

# Podemos importar el dato usando la funcion "read_excel", cuyo argumento es el nombre del archivo
censo <- read_excel("censo_proyeccion_2024.xlsx")
# Asignamos el resultado a un objeto, y así tenemos nuetros datos de Excel cargados en R


# Dataframes ----

# Igual que con los vectores, podemos ver los datos ejecutando el objeto por su nombre:
censo
# Este tipo de objetos se llaman "data frame", específicamente "tibble", que es un tipo de tabla
# Los dataframes son tablas de datos hechas a partir de vectores. 
# Tenemos que tener en mente que cada columna de los dataframes son un vector, 
# por lo que vamos a poder aplicar nuestros conocimientos anteriores a los dataframes

# Podemos aplicar funciones al dataframe
length(censo) #el "largo", o su cantidad de columnas
nrow(censo) #su cantidad de filas
str(censo) #su estructura interna

# Como los dataframes son hechos de vectores, podemos acceder a cada una de sus columnas
# usando el operador "$". Así podemos extraer los vectores que conforman sus columnas:
censo$población
# Este es el vector corresponde a la columna "población".

# Como las columnas son vectores, podemos hacer lo mismo que hicimos antes, como aplicar funciones
mean(censo$población) #función sobre un vector

# Podemos calcular la suma de la población al aplicar la función "sum" sobre la columna "población"
sum(censo$población)

# Podemos crear un nuevo objeto a partir de un cálculo sobre una columna
promedio <- mean(censo$población)

# Luego podemos usar ese nuevo objeto en un ifelse
ifelse(censo$población > promedio, "mayor población que el promedio", "menor")
# Pero notamos que, al trabajar con grandes datos, se vuelve incómodo seguir trabajando con vectores
# Para eso, usaremos un paquete que nos permite trabajar con los dataframes directamente

# Cargar Dplyr
library(dplyr) #si el paquete ya estaba cargando, no afecta en nada volver a cargarlo

## Seleccionar columnas ----
# La función select selecciona columnas del dataframe
# El operador "|>" se llama "pipe", es un conector, y significa que a este objeto le hago esto otro,
# es equivalente a leerlo como si dijera "luego" o "entonces"
censo |> select(comuna)
# "Al objeto 'censo' luego le 'select' la columna 'comuna'."

censo |> select(comuna, población) #seleccionar más de una

censo |> select(población)

## Filtrar datos ----
# Con la función filter podemos filtrar nuestro dataframe a partir de una comparación,
# dejando solamente las filas del dataframe que cumplan con la comparación

# Por ejemplo, dejar sólo las filas donde la comuna sea "Providencia"
censo |> filter(comuna == "Providencia")

# Sacar las filas donde la columna sea "Alto Hospicio"
censo |> filter(comuna != "Alto Hospicio")

# Dejar sólo las observaciones donde la población sea mayor a x
censo |> filter(población > 200000)

# Población menor a 1000
censo |> filter(población < 1000)

# Población menor a 1000, y sólo dejar comuna y población
censo |> filter(población < 1000) |> select(comuna, población) 


## Ordenar observaciones ----
# Usamos la función "arrange" para ordenar las filas de acuerdo a otra variable
censo |> arrange(población)

# Para ordenar en orden descendiente:
censo |> arrange(desc(población))

# Crear un objeto a partir de un orden y una selección
mayores_comunas <- censo |> arrange(desc(población)) |> select(comuna, población)

# Luego podemos seguir haciendo cosas con el objeto nuevo
mayores_comunas |> filter(población > 400000)



## Guardar en Excel ----

# Si queremos guardar estos resultados a un archivo Excel, instalamos y cargamos el paquete "writexl"
install.packages("writexl")
library(writexl)

# Ponemos al final el nombre del archivo que queremos guardar
censo |> filter(población < 1000) |> select(comuna, población) |> write_xlsx("tabla.xlsx")

# O, para hacerlo más ordenado, primero creamos un objeto con el resultado, y luego lo guardamos como Excel
comunas_chicas <- censo |> filter(población < 1000) |> select(comuna, población)

comunas_chicas

# guardar
comunas_chicas |> write_xlsx("tabla.xlsx")

