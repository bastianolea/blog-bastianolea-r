
edades <- c(30, 40, 50, 55, 45, 46, 47, 23, 25, 74, 63)

# obtener cantidad de elementos del vector
length(edades)

# extraer una muestra aleatoria desde el vector
sample(edades, 1) # un elemento al azar
sample(edades, 5) # cinco elementos al azar

# crear una secuencia entre dos números
seq(from = 10, to = 100, by = 5)
# del 10 al 100, de 5 en 5

# del 1 al 2, avanzando en 0.1
seq(from = 1, to = 2, by = 0.1)

# podemos usar funciones para definir cualquier argumento de cualquier otra función
seq(from = min(edades), to = max(edades), by = 10)

# repetir un objeto
rep("hola", 10)

# crear una secuencia de años
años <- seq(1900, 2020, 10)

# crear una secuencia de números decimales
numeros <- seq(from = 0, to = 2, by = 0.132)
