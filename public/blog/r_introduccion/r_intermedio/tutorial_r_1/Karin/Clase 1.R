# Introducción ----

# En esta clase veremos: operaciones matemáticas, comparaciones, objetos

# Antes de iniciar el análisis, creamos un Proyecto de R.
# Un proyecto es una carpeta donde guardamos todos los scripts y archivos que vamos a necesitar. 
# Luego, podemos abrir nuestro proyecto haciendo doble clic en el archivo que termina en ".Rproj"

# Realizamos nuestro análisis mediante Scripts. 
# Un script de R es un archivo de texto cuyo nombre termina en ".R", en el que vamos escribiendo las instrucciones para nuestro análisis.
# Dentro del script, ejecutamos las instrucciones línea por línea, poniendo el cursor de texto en la línea que deseamos, y presionando el botón "Run", o bien, presionando las teclas comando + enter.
# Al ejecutar una línea o instrucción, el comando se va a enviar a la consola, que es el panel de abajo donde se muestran las operaciones realizadas, y la consola va a retornar la respuesta o resultado.

# En un script, un comentario empieza con signo gato, y es una línea de código que no se ejecuta
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


# Comparaciones ----
# Utilizando operadores (símbolos que realizan operaciones) podemos pedirle a R que compare cifras:
# La igualdad se escribe "==" y se usa para evaluar si dos cifras son iguales
# La respuesta de las comparaciones es TRUE o FALSE (verdadero o falso)

1 == 1

2 != 2

10000 >= 40

10000 <= 40


# Asignaciones ----
# R es un lenguaje caracterizado por ser "orientado a objetos"
# Un objeto es un elemento que creamos, que puede contener información de cualquier tipo
# Podemos crear objetos asignando un valor a un objeto. Para eso usamos el operador de asignación, "<-"
# De este modo, podemos "guardar" un dato en un objeto para usarlo más adelante
# Los objetos tienen un nombre, el cual puede ser solo una palabra sin separar por espacios, y puede contener símbolos como guión bajo, tildes, eñes y números

# Crear objeto:
año_nacimiento <- 1993
# Al crear un objeto, aparece en el panel de entorno, "Environment", en la parte superior derecha

# Para ver los contenidos del objeto, simplemente lo llamamos por su nombre
año_nacimiento

# Podemos usar los objetos para calcular, porque R sabe que en el fondo son cifras
2024 - año_nacimiento #restar

# También podemos crear un nuevo objeto a partir de un cálculo
edad <- 2024 - año_nacimiento

edad


