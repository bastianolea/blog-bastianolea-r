# paquetes ----


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



         )




