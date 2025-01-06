# En esta clase vimos: vectores, funciones, tipos de datos, 
# instalación de paquetes, carga de datos desde excel, y dplyr

# Vectores ----
# Los vectores son secuencias de elementos
# Creamos los vectores usando la función "c", separando los valores por comas

c(1, 2, 3, 4, 5, 6, 7, 8)

# Asignamos a un objeto el vector de números
edades <- c(25, 27, 30, 45, 37, 28, 46, 54)

# Podemos realizar operaciones sobre los vectores, donde el cálculo se aplica a cada elemento
edades - 40

edades > 30

edades == 30

edades[3] #acceder a uno de los elementos del vector, ene ste caso al tercero

# podemos crear secuencias de números con el operador ":"
1:9

1980:2024

1:1000000

2024:2020

años <- 2000:2024

años

length(años) #largo del vector, es decir, su cantidad de elementos

length(1:454958946)

edades

# Funciones ----
# Las funciones son pequeños programas que se aplican a nuestros objetos o vectores
mean(edades) #promedio
min(edades) #mínimo
max(edades) #máximo
median(edades) #mediana

edades <- c(62, 57, 67, 98, 34, 56, 23, 45, 65, 43, 21, 12, 23, 12, 13, 14, 15)
length(edades)

# valor promedio de un vector
promedio <- mean(edades)

# aplicar comparación a un vector
edades > promedio

# seleccionar elementos de un vector
edades[1]
edades[13]
edades[17]
edades[length(edades)] #seleccionar el ultimo elemento de un vector, usando la función que nos da el largo del vector, es decir, la posición del ultimo valor


# Tipos de datos en vectores ----
# Cuando creamos un vector de distintos tipos de datos, R va a reducirlo por defecto a un solo tipo
prueba <- c(1, 2, 3, 4, "cinco") #en este caso, transforma todo a caracter

# funciones para confirmar el tipo de un objeto
is.numeric(prueba)
is.character(prueba)
class(prueba)
class(1)

vector <- c(1, 2, 3, 4, 5)
class(vector)

# convertir un objeto a otro tipo
vector_texto <- as.character(vector)

vector_texto
class(vector_texto)
as.numeric(vector_texto) #esta función transforma las cosas en números
?as.numeric

as.numeric(c(1, 2, 3, 4, "cinco"))

class(c(1, 2, 3, 4, 5))

decimales <- c(1, 2, 3, 4, 5) - 0.1

class(decimales)

typeof(decimales)

typeof(1L)


# Instalar un paquete ----

# es necesario instalarlos una sola vez
# install.packages("readxl")
# install.packages("tidyverse")

# hay que cargar los paquetes cada vez que los queramos usar
library(readxl)
library(tidyverse)

# cargar datos desde excel usando el nombre del archivo
censo <- read_excel("censo_proyeccion_2024.xlsx")

# ver los datos de dataframe o tabla
censo

# imprimir más filas del dataframe
print(censo, n = 23)

# confirmar que las columnas del dataframe son en realidad vectores
censo$comuna
censo$población
censo$poblacion

# aplicar funciones a las columnas del dataframe
sum(censo$población)
min(censo$población)



# dplyr ----
# Librería que nos permite manejar datos
library(dplyr)

#3 Seleccionar ----
censo %>% # control + shift + M
    select(comuna, población)


## Resumir ----
censo %>% 
    summarize(min(población))

## Ordenar
censo %>%
    arrange(población) %>%
    select(comuna, población)

censo %>% 
    filter(población > 100000) %>% 
    arrange(población)

censo %>% 
    filter(población > 100000) %>% 
    arrange(desc(población))

## Renombrar ----
censo %>% 
    rename(p = población)

# ver filas específicas del dataframe
censo %>% 
    slice(200:220)

### Filtrar ----
censo %>% 
    filter(población > 300000)

censo %>% 
    filter(población < 1000)

censo %>% 
    filter(población > 1000)


censo %>% 
    filter(población == min(población))

censo %>% 
    filter(población == max(población))

censo %>% 
    filter(comuna == "La Florida")

censo %>% 
    filter(población == 407297)

censo %>% 
    filter(población == min(población))



### Filtrar usando objetos ----
min_pob <- 25000
max_pob <- 30000

censo %>% 
    filter(población > min_pob,
           población < max_pob)

promedio <- mean(censo$población)

censo %>% 
    filter(población > promedio)

censo %>% 
    filter(población > promedio*1.5)

maximo <- max(censo$población)

censo %>% 
    filter(población >= maximo*0.8)


