# En esta clase repasamos los cálculos usando objetos, y aprendimos a programar condicionales

# repaso ----
# Ejemplo de presupuesto
# La idea de este ejercicio es que, cambiando las tres variables a continuación, vemos cómo los resultados van chorreando a los pasos siguientes
presupuesto = 100000

mesa = 50000
silla = 20000

# crear un objeto que sea la suma de las compras
compras <- mesa + (silla * 2)

# restarle al presupuestoupuesto las compras
restante = presupuesto - compras

# ver el presupuesto restante
restante

restante > 0

# if else ----

# "if else" significa en castellano "si pasa esto, entonces haz esto"
# en una sentencia if else, se define una o más condiciones que queremos que se cumplan para ejecutar un código y, si esa condición no se cumple, ejecutamos otro código (o no ejecutamos nada)

## función ifelse() ----
# usamos la función ifelse() para realizar una comparación, y si la comparación es TRUE, hacer una cosa, y si es FALSE, hacer otra
# en este caso, hacemos que retorne textos distintos para cada caso

# siguiendo con el ejemplo anterior, haremos una función que nos retorne un texto que describa lo que pasó con el dinero restante del presupuesto:
ifelse(restante > 0, #comparación
       yes = "presupuesto ok", #texto si la comparación es TRUE
       no = "nos quedamos sin lucas") #texto si la comparación es FALSE

remanente <- ifelse(restante > 5000,
       yes = "queda algo de plata", 
       no = "queda muy poca plata")

# esa es la función ifelse(), que la vimos porque es más sencilla de entender en su funcionamiento
# pero hay una forma más flexible de hacer condicionales, y es con la sentencia if else:

## sentencia if else -----
# a diferencia de la función ifelse(), la sentencia if () {} else {} es más flexible, ya que no se limita a entregar un solo resultado como una función, sino que permite realizar cualquier operación u operaciones dentro de sus  

# primero, creemos nuestras variables
perros = 3
gatos = 2
maximo = 4

# calculemos el total a partir de las variables
total = perros + gatos

# ahora vamos a hacer que R haga cosas dependiendo de el resultado anterior
# si el resultado anterior es menor al maximo, es decir, 
# si podemos tener más animales en la casa, agreguemos animales
# pero si el resultado no es menor al máximo, entonces no agregamos

# haciendo una comparación, y si la comparación es TRUE, 
# hagamos una cosa
if (total < maximo) { #evalar si puedo tener mas animales en la casa
    # si sale TRUE, entonces hacemos esto:
    "todavía podemos tener más animales, agreguemos gatos"
    gatos = gatos + 1 #aumentemos los gatos
    total = perros + gatos #calculemos el nuevo total
} else {
    # si sale FALSE, entonces hacemos esto otro:
    "no nos dan permiso para tener más animales"
}
# lo que esté dentro de los corchetes será lo que se ejecuta si la condición se cumple, o si no, dependiendo del caso
# usando esta sintaxis, podemos hacer multiples cosas en cada caso; por ejemplo, aquí hicimos que la consola imprima un texto, luego sumamos 1 a un objeto, luego volvimos a ejecutar la suma de objetos
# de esta forma podemos automatizar ciertos procedimientos con nuestros datos, es una forma de automatizar decisiones y acciones a partir de condiciones determinadas

# programar condicionales es crucial, ya que es una de las herramientas básicas que nos permite realizar programas mucho más complejos