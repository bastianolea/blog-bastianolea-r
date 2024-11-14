---
title: Tips para limpieza de datos en R
author: Bastián Olea Herrera
date: '2024-11-13'
slug: []
categories: []
tags:
  - consejos
  - limpieza de datos
  - texto
excerpt: >-
  Algunos de los paquetes y funciones que uso frecuentemente al momento de limpiar datos en R.
---

En este post dejo algunos de los paquetes y funciones que uso frecuentemente al momento de limpiar datos en R. Voy a ir actualizando este post por si se me van ocurriendo más.

<div style = "max-width: 220px">

```r
library(janitor)
library(stringr)
library(dplyr)
library(lubridate)
```

</div>

### Limpiar nombres de columnas
```r
janitor::clean_names()
```
Como su nombre lo indica, esta función cambia los nombres de las variables o columnas para estandarizar la forma en que están escritas: todo en minúsculas, sin espacios, sin símbolos, y las palabras separadas con guión bajo. Esto facilita mucho el trabajo con datos, ya que minimiza las probabilidades de qué te equivoques al escribir el nombre de una columna. Personalmente siempre ocupo esta función al momento de cargar datos, sobre todo si estos datos vienen desde Excel. Lo único malo de `clean_names()` es que esta función también cambia las eñes por enes.

### Corregir tablas sin nombres de columnas
```r
janitor::row_to_names()
```
Esta función soluciona un problema bastante común al cargar datos desde Excel, que es que las planillas de datos de Excel suelen venir con filas vacías arriba. Esto porque los usuarios de Excel les gusta darle un espaciado a las tablas, pero al momento de cargar esos datos, las filas vacías producen problemas.

### Eliminar filas y columnas vacías
```r
janitor::remove_empty()
```
Una función muy conveniente para limpiar datos, porque permite eliminar con una sola instrucción las filas vacías, o las columnas vacías. En Excel es común separar distintas tablas con filas o columnas vacías, o usar filas vacías o columnas vacías para hacer espacio entre los datos. De este modo, todas las columnas y celdas de nuestra tabla de datos contendrán información.

### Filtrar datos según un patrón de texto
```r
filter(stringr::str_detect())
```
La combinación de estas dos funciones permite filtrar las filas que contengan un texto parcial. Se puede usar para excluir filas que contengan un cierto patrón de texto si se le antepone un signo de exclamación

### Buscar y reemplazar texto
```r
stringr::str_replace()
```
A esta función se le entrega una columna, y dos textos: el texto que queremos detectar, y después el texto que queremos reemplazar. De esta forma, podemos encontrar ciertos patrones de texto y reemplazarlos por otros, facilitando procesos de limpieza que involucren corregir cosas mal escritas, cambiar ciertos símbolos por otros, etc.

### Creación de variables co múltiples condicionales
```r
case_when()
```
Es una función muy poderosa para poder crear nuevas variables en base al contenido de otras variables. Su potencial radica en la facilidad que te entrega para utilizar múltiples condiciones simultáneas para especificar las categorías de la nueva variable. Por ejemplo, si una cierta celda contiene un número, puedes hacer una operación. Pero si no contiene números, puedes hacer otra. Pero si el número tiene cierto largo puede ser algo distinto, etc.

### Corregir mayúsculas de un texto
```r
stringr::str_to_sentence()
```
El uso de mayúsculas suele ser un problema al trabajar con datos, pero esta función, junto con sus funciones hermanas, facilitan transformar las mayúsculas de cualquier texto. Con `str_to_sentence()` se pone solamente la primera letra de una oración con mayúscula y el resto en minúsculas. Mientras `str_to_upper()` y `str_to_lower()` transforman todo a mayúsculas o todo a minúsculas, respectivamente.

### Extraer un patrón de texto
```r
stringr::str_extract()
```
La extracción de texto resulta muy útil cuando la combinas con expresiones regulares (regex). Te permite, por ejemplo, extraer la primera palabra de una cadena de texto, o la última palabra. Te permite extraer distintas formas de escribir un mismo concepto. Te permite extraer textos  que empiecen con algo y terminen con otro término, independiente del texto que haya entre ambos extremos.

### Extraer años desde un texto
```r
stringr::str_extract("\\d{4}")
```
Una tarea común al limpiar datos es poder extraer el año que puede venir dentro de una columna de una fecha, de una variable de texto, o de un texto distinto que incluye alguna fecha dentro de sí. Con esta expresión de regex podemos extraer una cifra numérica de cuatro dígitos, que en la mayoría de los casos corresponde al año que queremos obtener.

### Convertir fechas
```r
lubridate::dmy()
```
Una confusión común al trabajar con R ocurre cuando intentan nacer una operación sobre una columna que no permite ese tipo de operaciones. Como sumar números que en realidad son variables de formato texto. Lo mismo pasa con las fechas, que suelen ser expresadas en texto, pero que necesitan ser interpretadas como una fecha para poder realizar operaciones propias de una fecha, como calcular rangos de tiempo, sumar o restar días, extraer meses o años, saber el día de la semana, etc. Con esta función, es tan sencillo como indicar que la fecha viene expresada en _día mes año,_ o si viene como _año mes día,_ usar la variante `ymd()`.

----

¿Tienes alguna otra función o paquete de R que uses regularmente para limpiar datos? Cuéntame en los comentarios 😊