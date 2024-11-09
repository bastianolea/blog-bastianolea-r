# esta clase vimos: explorar datos con dplyr, crear variables con ifelse, 
# crear variables con case_when

# cargar datos ----
# cargamos el paquete readxl para poder cargar datos desde excel
library(readxl)

# cargar archivos en excel
campamentos <- read_excel("campamentos_chile_2024.xlsx")

# el objeto campamentos ahora contiene los datos del archivo excel
campamentos

# ver cantidad de filas de la tabla
nrow(campamentos)

# ver cantidad de columnas de la tabla
length(campamentos)

# tidyverse ----
# cargamos el paquete tidyverse para poder manejar mejor los datos
library(tidyverse)
# recordemos que tidyverse es un conjunto de varios paquetes, y en este 
# caso solo usaremos dplyr, así que sería lo mismo cargar sólo library(dplyr)

## seleccionar ----
# seleccionar columnas 
campamentos |> 
    select(nombre, comuna)


campamentos |> 
    select(1, 2, 3, 4)

campamentos |> 
    select(1, 2, 3, 4, hogares)

campamentos |> 
    select(1:4, hogares)

# también podemos hacer selecciones negativas
campamentos |> 
    select(-hogares)


## ordenar ----
# ordenar las observaciones en base a una variable
campamentos |> 
    arrange(hogares)

# ordenar las observaciones de mayor a menor
campamentos |> 
    arrange(desc(hogares))

## contar ----
# conteo de casos de una variable
# detecta todos las categoría posibles de una variable, y cuenta 
# las observaciones pertenecientes a cada categoría
campamentos |> 
    count(region)

# combinamos un conteo con un ordenamiento de las filas
campamentos |> 
    count(region) |> 
    arrange(desc(n))

campamentos |> 
    count(comuna) |> 
    arrange(desc(n))

campamentos |> 
    count(region, comuna) |> 
    arrange(desc(n)) 

## filtrar ----
# usamos comparaciones para hacer filtros
campamentos |> 
    filter(hogares > 40)
# en este caso, solo quedarán en nuestra tabla las observaciones donde
# los hogares sean mayor a 40

# combinamos una selección negativa con un filtro
campamentos |> 
    select(-cut_r, -cut_p, -cut, -provincia) |> 
    filter(hogares > 40)

# combinamos un filtro con un conteo y un ordenar, así
# obtenemos un conteo de los campamentos por comuna que tienen más de 5,
# hogares, ordenados de mayor a menor
campamentos |> 
    filter(hogares > 5) |> 
    count(comuna) |> 
    arrange(desc(n))

campamentos |> 
    filter(hogares < 5) |> 
    count(comuna) |> 
    arrange(desc(n))

## renombrar ----
campamentos |> 
    rename(campamento = nombre)
# cambia el nombre de una columna (el primer argumento es el nombre nuevo, el segundo el antiguo)

campamentos |> 
    slice(100)

## crear variables ----
# crear una nueva variable en base al valor de otra variable
campamentos |> 
    select(1:4, hogares) |> 
    mutate(prueba = "hola")
# en este caso creamos una variable que solo contiene un texto, repetido 
# para cada fila

# recordemos que las comparaciones retornan TRUE o FALSE
10 > 3
10 == 10
5 < 2

# entonces, usamos este conocimiento para crear una columna donde
# se ponga TRUE o FALSE dependiendo si cada observación cumple o no
# la comparación que le damos
# así podemos crear una nueva variable con un condicional
campamentos |> 
    select(nombre, region, hogares) |> 
    mutate(tipo = hogares > 50)

campamentos |> 
    select(nombre, region, hogares) |> 
    mutate(tipo = hogares > 40)

## if else ----
# un if else es una comparación, pero que en vez de retornar TRUE o FALSE,
# retorna los valores que nosotras le pidamos
plata <- 1000000
plata < 300000
# una comparación normal retorna TRUE o FALSE

# pero en el ifelse, le especificamos primero la comparación,
# luego lo que queremos que retorne si la comparación es TRUE,
# y finalmente lo que queremos que retorne si es false
ifelse(plata < 300000, yes = "poca", no = "mucha")

ifelse(plata < 300000, 
       yes = "poca", no = "mucha")

ifelse(plata < 3000000, 
       yes = "poca", 
       no = "mucha")
# recordemos que podemos escribir las funciones como nosotras queramos,
# poniendo saltos de línea después de las comas para hacer más legible el código

# también se puede escribir así, obviando el "yes" y "no"
ifelse(plata < 300000, "poca", "mucha")

# entonces, usamos este conocimiento para crear una variable usando ifelse:
campamentos |> 
    select(nombre, region, hogares) |> 
    mutate(tipo = ifelse(hogares > 40, 
                         yes = "grande", 
                         no = "chico")
    )

# combinamos un ifelse con un filtro en base a la nueva variable
campamentos |> 
    select(nombre, region, hogares) |> 
    mutate(tipo = ifelse(hogares > 40, 
                         yes = "grande", 
                         no = "chico")) |> 
    # filtrar
    filter(tipo == "grande")

# si estamos satisfechas con la nueva variable, podemos guardar el
# resultado en un nuevo objeto, así podemos usar el objeto nuevo que contiene nuestros cambios
campamentos2 <- campamentos |> 
    select(nombre, region, hogares, hectareas, area) |> 
    mutate(tipo = ifelse(hogares > 40, 
                         yes = "grande", 
                         no = "chico"))

campamentos2

## crear múltiples variables ----
# podemos usar varias veces mutate para crear varias variables

# por ejemplo, cada vez que hagamos un mutate podemos guardar el resultado
# en un objeto nuevo, así hacemos todo por pasos
campamentos3 <- campamentos2 |>
    mutate(densidad_ha = hectareas / hogares)

campamentos3

campamentos4 <- campamentos3 |>
    mutate(area_km = area/1000)

campamentos4

campamentos5 <- campamentos4 |>
    mutate(densidad_km = area_km / hogares)

campamentos5

# pero también podemos hacer todo junto, creando tres variables de una vez
campamentos2 |> 
    mutate(densidad_ha = hectareas / hogares) |> 
    mutate(area_km = area/1000) |> 
    mutate(densidad_km = area_km / hogares)
# cada línea de mutate crea una nueva variable

# opcionalmente, también se pueden crear todas las variables en una
# sola llamada a mutate, separando cada una con comas, así
# hacemos todo más junto
campamentos3 <- campamentos2 |> 
    mutate(densidad_ha = hectareas / hogares,
           area_km = area/1000,
           densidad_km = area_km / hogares)
# la forma que decidamos usar depende de lo que nos parezca mejor, ya que
# son todas equivalentes

## case_when ----
# case_when es equivalente a usar varios ifelse seguidos, y por lo tanto
# nos permite crear variables más complejas, que tengan más de dos categorías
# y se usa poniendo todas las evaluaciones junto al valor que queremos que adopten
# si es que estas comparaciones son TRUE

# como prueba, vamos a uncluir una sola comparación, para ver que le otorga
# el valor solo a las observaciones correspondientes, y las demás las deja vacías
campamentos3 |> 
    mutate(categoria = case_when(densidad_km < 0.3 ~ "baja"))

# en este ejemplo, ponemos dos comparaciones que van dando valores a las filas del dataframe
campamentos3 |> 
    mutate(categoria = case_when(densidad_km < 0.3 ~ "baja",
                                 densidad_km < 0.6 ~ "media"
    ))

# finalmente, este ejemplo pone suficientes comparaciones para cubrir cualquier número posible
campamentos3 |> 
    mutate(categoria = case_when(densidad_km < 0.3 ~ "baja",
                                 densidad_km < 0.6 ~ "media",
                                 densidad_km < 0.9 ~ "alta",
                                 densidad_km >= 0.9 ~ "muy alta"
    ))
# en estos ejemplos, usamos ocmparaciones que proponen un valor numérico, y coinciden con los valores inferiores
# al valor que pusimos, entonces va de menor a mayor: de 0.3 para abajo, de 0.6 para abajo, de 0.9 para abajo,
# y lo importante es entender que una vez que una observación adquiere su etiqueta, las demás comparaciones no la van a sobreescribir,
# por ejemplo, si tenemos el valor 0.2, va a ser etiquetado por la comparación "valores menores a 0.3", porque es menor a 0.3, pero cuando 
# se aplique la siguiente comparación, que es "valores menores a 0.6", a pesar de que 0.2 también es menor a 0.6, no va a 
# recibir una nueva etiqueta, porque ya obtuvo una en la comparación anterior (menores a 0.3).

# las comparaciones también pueden combinarse para volverse más específicas
# en este ejemplo definimos no solamente si son menores a un valor, sino que definimos un rango de valores:
# mayores a 0 y menores a 3; mayores o iguales a 0.3 y menores a 0.6; etc.
campamentos3 |> 
    mutate(categoria = case_when(densidad_km > 0 & densidad_km < 0.3 ~ "baja",
                                 densidad_km >= 0.3 & densidad_km < 0.6 ~ "media",
                                 densidad_km >= 0.6 & densidad_km < 0.9 ~ "alta",
                                 densidad_km >= 0.9 ~ "muy alta"
    ))

# también podemos especificar el argumento .default para que le otorgue a un valor a "todos los demás";
# es decir, a los valores que no coincidieron con ninguna condición
campamentos3 |>
    mutate(categoria = case_when(
        densidad_km > 0 & densidad_km < 0.3 ~ "baja",
        densidad_km >= 0.3 & densidad_km < 0.6 ~ "media",
        densidad_km >= 0.6 & densidad_km < 0.9 ~ "alta",
        .default = "desconocido")) |>
    filter(categoria != "desconocido") |>
    print(n = 30)

# finalmente, case_when nos permite crear cualquier tipo de comparación arbitraria,
# usando cualquier columna de nuestro dataframe; por ejemplo, en este caso estamos
# etiquetando una variable sobre densidad, pero si lo decidimos podemos combinar la 
# densidad con una región; es decir, solo las observaciones que no son de Valparaíso pueden ser altas
campamentos3 |>
    mutate(categoria = case_when(densidad_km > 0 & densidad_km < 0.3 ~ "baja",
                                 densidad_km >= 0.3 & densidad_km < 0.6 ~ "media",
                                 region != "Valparaíso" & densidad_km >= 0.6 & densidad_km < 0.9 ~ "alta"))

