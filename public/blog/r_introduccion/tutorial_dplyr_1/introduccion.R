

# objetos ----
# creación de objetos con el operador de asignación
año <- 2024

año_nacimiento <- 1993

# realizar operaciones matemáticas entre objetos
año - año_nacimiento

# crear un nuevo objeto a partir del resultado de una operación
edad <- año - año_nacimiento


# comparaciones ----
# obtener TRUE o FALSE a partir de una comparación numérica
edad > 18
edad >= 31 
edad > 31 
edad != 18


# vectores ----
# los vectores son secuencias de datos de un mismo tipo (numérico, caracter, etc)
vector <- c(1, 2, 3, 4, 5, 6)
length(vector) # largo del vector, es decir, su cantidad de elementos
class(vector) # tipo del vector, que define lo que podemos o no hacer con cada dato

c(1, 2, 3, 4, 5, 6, "7") # R coerciona los datos a caracter si encuentra discrepancias en el tipo de un vector

as.character(vector) # convertir un vector a otro tipo

as.numeric(c(1, 2, 3, 4, 5, 6, "7"))

# pruebas con la coerción
as.numeric(c(1, 2, 3, 4, 5, 6, "7", "ocho"))

c(1, 2, 3, 4, 5, 6, "7", "ocho") |> 
  as.numeric()

# crear vectores numéricos
años <- c(2022, 2010, 1998, 2006, 2025)

# crear una secuencia de números como vector
2000:2024
numeros <- 1:1000000

## operaciones sobre vectores numéricos ----
numeros |> class()
numeros |> length()
numeros |> max()
numeros |> min()
numeros |> mean()
numeros |> median()

# si realizamos una operación, se ejecuta a todos los elementos del vector
años - 2024
2024 - años
(años - 2024) * -1



# paquetes ----

# instalar paquetes (solo se necesita hacer una vez)
# install.packages("readxl")

# cargar paquetes (cada vez que queramos usarlos)
library(readxl)


# cargar datos desde Excel ----
datos <- read_excel("campamentos_chile_2024.xlsx")

# imprimir más filas que las que entrega la consola por defecto
datos |> 
  print(n = 50)

# funciones para revisar nuestros datos
datos |> class()
datos |> length()
datos |> nrow()
datos |> names()

# aplicar funciones a las columnas de un dataframe, que en el fondo son vectores
datos$nombre
datos$hectareas |> min()
datos$hectareas |> max()
datos$hectareas |> mean()


# dplyr ----
# el paquete dplyr nos permite trabajar con datos más facilmente
# a partir de funciones "verbos", y paso por paso usando el conectos o pipe (|>)

# install.packages("dplyr")
library(dplyr)


## seleccionar ----
datos |> 
  select(nombre, hectareas)

# excluir
datos |> 
  select(-cut, -cut_r, -cut_p)

# seleccionar en base al nombre de la columna
datos |> 
  select(-contains("cut"))

# selección por el numero de una columna (su posición)
datos |> 
  select(1:4, año)

## mirar ----
datos |> 
  glimpse()

datos |> 
  head(40)

datos |> 
  tail(40) |> 
  print(n=Inf)

datos |> 
  slice(1000:1010)

datos |> 
  slice_max(hogares,  n = 10)

datos |> 
  slice_min(hogares, n = 10)

datos |> slice_sample(n = 5)

## ordenar ----
datos |> 
  arrange(nombre)

datos |> 
  arrange(desc(hogares))

datos |> 
  arrange(comuna, desc(hogares)) |> 
  select(nombre, comuna, hogares)

datos |> glimpse()

datos2 <- datos |> 
  select(1:4) |> 
  slice_sample(n = 10)


## filtros ----
datos |> 
  filter(hogares > 80)

datos |> 
  filter(hogares < 10)

datos |> 
  filter(region == "Ñuble")

datos |> 
  filter(region != "Valparaíso")

datos |> 
  filter(hogares > 90, hectareas > 30)

datos |> 
  filter(hogares > 90) |> 
  filter(hectareas > 30)

datos |> 
  filter(hogares > 90 & hogares != 91)

datos |> 
  filter(hogares > 300 | hectareas > 100)

datos |> 
  filter(hogares > 30 & region == "Ñuble" |
         hogares > 300 & region == "Valparaíso")

# fitrar datos usando un objeto
prom_hogares <- mean(datos$hogares)

datos |> 
  filter(hogares > prom_hogares) #mayores que el promedio

# filtrar datos a partir de una operación sobre una columna
datos |> 
  filter(hogares > mean(hogares) * 8)

datos |> 
  filter(hogares > quantile(hogares, .9))

## pegar textos ----
region = "Ñuble"
comuna = "Perrito"
hogar = "El Bosque 5456"

# concatenar
c(region, comuna, hogar) |> length()

# pegar
paste(region, comuna, hogar, sep = "/")

# pegar textos desde una columna
datos2 |> 
  # mutate(ubicacion = paste(region, provincia, comuna, sep = " / "))
  mutate(ubicacion = paste("Región de ", region, ", provincia de ",  provincia, comuna, sep = ""))

## crear variables ----

# pegar texto
datos |> 
  select(nombre, where(is.numeric), -cut) |> 
  mutate(columna1 = paste("Numero de hogares:", hogares))

# redondear
datos |> 
  select(nombre, where(is.numeric), -cut) |> 
  mutate(hectareas2 = round(hectareas, digits = 1))

# nueva columna a partir de un cálculo
datos |> 
  select(nombre, where(is.numeric), -cut) |> 
  mutate(densidad = hectareas/hogares)

# nueva columna a partir de una condicional
datos |> 
  mutate(prioridad = hectareas > 2)
         
### if else ----                   
datos |> 
  select(nombre, where(is.numeric), -cut) |> 
  mutate(prioridad = ifelse(hectareas > 2, "prioridad", "normal"))

### case when ----
datos |> 
  select(nombre, where(is.numeric), -cut) |> 
  mutate(tamaño = case_when(hogares > 60 ~ "grande",
                            hogares >= 30 ~ "mediano",
                            hogares < 20 ~ "chico"))

# crear varias variables 
datos3 <- datos |> 
  select(nombre, region, where(is.numeric), -cut) |> 
  mutate(densidad = hectareas/hogares) |> 
  mutate(prioridad = ifelse(hectareas > 2, "prioridad", "normal")) |> 
  mutate(tamaño = case_when(hogares > 60 ~ "grande",
                            hogares > 30 ~ "mediano",
                            .default = "chico")
         )

## conteos ----
datos3 |> 
  count(tamaño)

datos3 |> 
  count(region, tamaño) |> 
  print(n = Inf)

## pivotar a ancho ----
library(tidyr)

tablita <- datos3 |> 
  count(region, tamaño) |> 
  pivot_wider(names_from = tamaño, values_from = n, 
              values_fill = 0)


# guardar en excel ----
tablita |> 
  select(region, chico, mediano, grande)

tablita2 <- tablita |> 
  relocate(mediano, .after = chico)

writexl::write_xlsx(tablita2, "tabla_campamentos.xlsx")
