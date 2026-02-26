---
title: Renombrar archivos desde R
author: Bastián Olea Herrera
date: '2026-02-25'
slug: []
categories: []
tags:
  - automatización
  - texto
  - limpieza de datos
format:
  hugo-md:
    output-file: index
    output-ext: md
excerpt: >-
  Una tarea común en al trabajar con datos (y también en la computación en
  general) es necesitar renombrar muchos archivos. Podemos usar R para
  automatizar este tipo de tareas repetitivas; un ejemplo de que R no es sólo un
  lenguaje para análisis de datos.
---


Una tarea común en al trabajar con datos (y también en la computación en general) es necesitar renombrar muchos archivos. R puede ayudarnos a realizar este tipo de tareas repetitivas, dado que, además de ser un lenguaje centrado en el análisis de datos, R también puede usarse para cualquier otro propósito!

## Inspeccionar directorios y archivos con R

Hagamos como que tenemos una carpeta llena de archivos (pueden ser imágenes, documentos PDF, u otros documentos), en este caso la carpeta se llama `reportes` y dentro tiene 10 documentos PDF.

Usamos el paquete `{fs}` para **ver los archivos dentro de la carpeta**:

``` r
# install.packages("fs")
library(fs)

# rutas de archivos
rutas <- dir_ls("reportes")

rutas
```

    reportes/Reporte 2025 comuna Camarones.pdf
    reportes/Reporte 2025 comuna Camiña.pdf
    reportes/Reporte 2025 comuna Canela.pdf
    reportes/Reporte 2025 comuna Cañete.pdf
    reportes/Reporte 2025 comuna Carahue.pdf
    reportes/Reporte 2025 comuna Cartagena.pdf
    reportes/Reporte 2025 comuna Castro.pdf
    reportes/Reporte 2025 comuna Catemu.pdf
    reportes/Reporte 2025 comuna Cauquenes.pdf
    reportes/Reporte 2025 comuna Cerrillos.pdf

Obtenemos un vector con las *rutas* de los archivos, es decir, el lugar en nuestro computador donde se ubican los archivos[^1].

Estas rutas representan los archivos, y con ellas podemos hacer distintas operaciones.

Veamos cómo podemos usar R para **renombrar archivos**:

## Cambiar nombres

Para cambiar el nombre de un archivo, en realidad lo que hacemos es **moverlo** pero con un **nombre distinto**. Para eso usamos la función `file_move()`, que recibe como argumentos la ruta del archivo que queremos mover, y la ruta nueva, que sería el mismo lugar pero con un nombre distinto.

Renombremos un sólo archivo desde R:

``` r
# mover un sólo archivo
file_move(path = "reportes/Reporte 2025 comuna Cartagena.pdf",
          new_path = "reportes/reporte_camarones.pdf")
```

Y revisemos el resultado:

``` r
dir_ls("reportes")
```

    reportes/Reporte 2025 comuna Camarones.pdf
    reportes/Reporte 2025 comuna Camiña.pdf
    reportes/Reporte 2025 comuna Canela.pdf
    reportes/Reporte 2025 comuna Cañete.pdf
    reportes/Reporte 2025 comuna Carahue.pdf
    reportes/Reporte 2025 comuna Castro.pdf
    reportes/Reporte 2025 comuna Catemu.pdf
    reportes/Reporte 2025 comuna Cauquenes.pdf
    reportes/Reporte 2025 comuna Cerrillos.pdf
    reportes/reporte_camarones.pdf

Ahora, si queremos **renombrar todos los archivos de la carpeta**, podemos crear una tabla que tenga como primera variable los nombres de los archivos, y como segunda variable los nuevos nombres.

Aquí nos servirá mucho el paquete `{stringr}` para manipulación de texto. Algunas [funciones útiles para limpieza de texto](../../../blog/2025-03-31/) son:
- `str_replace()` para reemplazar partes del texto por otros textos
- `str_remove()` para eliminar partes del texto

Creemos una tabla con el vector de rutas usando la función `tibble()`:

``` r
library(dplyr)

# crear tabla con las rutas
archivos <- tibble(ruta = rutas)

archivos
```

    # A tibble: 10 × 1
       ruta                                      
       <fs::path>                                
     1 reportes/Reporte 2025 comuna Camarones.pdf
     2 reportes/Reporte 2025 comuna Camiña.pdf   
     3 reportes/Reporte 2025 comuna Canela.pdf   
     4 reportes/Reporte 2025 comuna Cañete.pdf   
     5 reportes/Reporte 2025 comuna Carahue.pdf  
     6 reportes/Reporte 2025 comuna Cartagena.pdf
     7 reportes/Reporte 2025 comuna Castro.pdf   
     8 reportes/Reporte 2025 comuna Catemu.pdf   
     9 reportes/Reporte 2025 comuna Cauquenes.pdf
    10 reportes/Reporte 2025 comuna Cerrillos.pdf

Ahora creemos una nueva columna con `mutate()` que tenga versiones modificadas de los nombres: cambiemos el texto *"Reporte 2025"* en el nombre de cada archivo por *"Documento"* y así creamos una nueva ruta:

``` r
library(stringr)

archivos <- archivos |> 
  mutate(ruta_nueva = str_replace(ruta, 
                                  pattern = "Reporte 2025", 
                                  replacement = "Documento"))

archivos
```

    # A tibble: 10 × 2
       ruta                                       ruta_nueva                        
       <fs::path>                                 <chr>                             
     1 reportes/Reporte 2025 comuna Camarones.pdf reportes/Documento comuna Camaron…
     2 reportes/Reporte 2025 comuna Camiña.pdf    reportes/Documento comuna Camiña.…
     3 reportes/Reporte 2025 comuna Canela.pdf    reportes/Documento comuna Canela.…
     4 reportes/Reporte 2025 comuna Cañete.pdf    reportes/Documento comuna Cañete.…
     5 reportes/Reporte 2025 comuna Carahue.pdf   reportes/Documento comuna Carahue…
     6 reportes/Reporte 2025 comuna Cartagena.pdf reportes/Documento comuna Cartage…
     7 reportes/Reporte 2025 comuna Castro.pdf    reportes/Documento comuna Castro.…
     8 reportes/Reporte 2025 comuna Catemu.pdf    reportes/Documento comuna Catemu.…
     9 reportes/Reporte 2025 comuna Cauquenes.pdf reportes/Documento comuna Cauquen…
    10 reportes/Reporte 2025 comuna Cerrillos.pdf reportes/Documento comuna Cerrill…

Entonces tenemos las rutas originales con las rutas nuevas.

Sabemos que con `file_move()` podemos mover cada archivo a su nuevo nombre. Pero ahora tenemos una tabla con dos columnas, así que podemos **mover todos los archivos al mismo tiempo!**

Usaremos las **columnas como vectores** para aplicar la función a todos los archivos. En el primer argumento (`path`) insertamos la columna con las rutas originales (`archivos$ruta`), y en el segundo argumento (`new_path`) insertamos la columna con las rutas nuevas (`archivos$ruta_nueva`):

``` r
# renombrar todos los archivos
file_move(path = archivos$ruta, 
          new_path = archivos$ruta_nueva)
```

Lo que hicimos fue **vectorizar** la función, haciendo que se aplique para todos los elementos de los vectores (ambos del mismo largo) que entregamos!

Revisemos el cambio que hicimos:

``` r
dir_ls("reportes")
```

    reportes/Documento comuna Camarones.pdf reportes/Documento comuna Camiña.pdf   
    reportes/Documento comuna Canela.pdf    reportes/Documento comuna Cañete.pdf   
    reportes/Documento comuna Carahue.pdf   reportes/Documento comuna Cartagena.pdf 
    reportes/Documento comuna Castro.pdf    reportes/Documento comuna Catemu.pdf    
    reportes/Documento comuna Cauquenes.pdf reportes/Documento comuna Cerrillos.pdf 

Funcionó!

## Eliminar palabras de los nombres

Usamos la función `str_remove()` si queremos eliminar palabras, textos o patrones específicos de los nombres de archivos. Luego usamos `str_squish()` para eliminar todos los espacios repetidos que pueden qeudar por la eliminación de palabras:

``` r
# obtener rutas
rutas <- dir_ls("reportes")

# crear tabla con las rutas
archivos <- tibble(ruta = rutas)

archivos <- archivos |> 
  mutate(ruta_nueva = str_remove(ruta, pattern = "comuna"),
         ruta_nueva = str_squish(ruta_nueva))

archivos
```

    # A tibble: 10 × 2
       ruta                                    ruta_nueva                      
       <fs::path>                              <chr>                           
     1 reportes/Documento comuna Camarones.pdf reportes/Documento Camarones.pdf
     2 reportes/Documento comuna Camiña.pdf    reportes/Documento Camiña.pdf   
     3 reportes/Documento comuna Canela.pdf    reportes/Documento Canela.pdf   
     4 reportes/Documento comuna Cañete.pdf    reportes/Documento Cañete.pdf   
     5 reportes/Documento comuna Carahue.pdf   reportes/Documento Carahue.pdf  
     6 reportes/Documento comuna Cartagena.pdf reportes/Documento Cartagena.pdf
     7 reportes/Documento comuna Castro.pdf    reportes/Documento Castro.pdf   
     8 reportes/Documento comuna Catemu.pdf    reportes/Documento Catemu.pdf   
     9 reportes/Documento comuna Cauquenes.pdf reportes/Documento Cauquenes.pdf
    10 reportes/Documento comuna Cerrillos.pdf reportes/Documento Cerrillos.pdf

Y nuevamente aplicamos los cambios a los archivos:

``` r
# renombrar todos los archivos
file_move(path = archivos$ruta, 
          new_path = archivos$ruta_nueva)

# revisar cambios
dir_ls("reportes")
```

    reportes/Documento Camarones.pdf reportes/Documento Camiña.pdf   
    reportes/Documento Canela.pdf    reportes/Documento Cañete.pdf   
    reportes/Documento Carahue.pdf   reportes/Documento Cartagena.pdf 
    reportes/Documento Castro.pdf    reportes/Documento Catemu.pdf    
    reportes/Documento Cauquenes.pdf reportes/Documento Cerrillos.pdf 

## Limpiar nombres

Si trabajamos con archivos que van a subirse a internet o a algún servicio, se recomienda limpiar los nombres de archivos para evitar problemas de compatibilidad: evitar espacios, tildes, eñes, mayúsculas, etc.

Podemos usar la función `make_clean_names()` del paquete `{janitor}` para limpiar los nombres de los archivos. Pero para hacerlo más ordenado, podemos sacar las rutas para trabajar solamente sobre los nombres de los archivos: luego de `dir_ls()` para obtener las rutas, usamos `path_file()` para quedarnos sólo con los nombres, y así no afectamos a las carpetas con la limpieza.

``` r
library(fs)

# lista con nombres de archivos sin ruta
ruta_archivos <- "reportes"
nombres_archivos <- dir_ls(ruta_archivos) |> path_file()

nombres_archivos
```

     [1] "Documento Camarones.pdf" "Documento Camiña.pdf"   
     [3] "Documento Canela.pdf"    "Documento Cañete.pdf"   
     [5] "Documento Carahue.pdf"   "Documento Cartagena.pdf"
     [7] "Documento Castro.pdf"    "Documento Catemu.pdf"   
     [9] "Documento Cauquenes.pdf" "Documento Cerrillos.pdf"

Luego, creamos la tabla con `tibble()`, y separamos el nombre del archivo de su extensión (`.pdf`, `.xlsx`, etc.) con `separate()`, para poder limpiar el nombre sin afectar la extensión. Luego usamos `make_clean_names()` del paquete `{janitor}` para limpiar los nombres:

``` r
library(tidyr) # para separar columnas a partir de un separador
library(dplyr) # para crear nuevas columnas
library(janitor) # para limpiar nombres

archivos <- tibble(archivo = nombres_archivos) |>
  # separar nombres de archivos de su extensión
  separate(archivo, sep = "\\.", into = c("nombre", "extension")) |>
  # limpiar nombres
  mutate(nombre_nuevo = janitor::make_clean_names(nombre))

archivos
```

    # A tibble: 10 × 3
       nombre              extension nombre_nuevo       
       <chr>               <chr>     <chr>              
     1 Documento Camarones pdf       documento_camarones
     2 Documento Camiña    pdf       documento_camina   
     3 Documento Canela    pdf       documento_canela   
     4 Documento Cañete    pdf       documento_canete   
     5 Documento Carahue   pdf       documento_carahue  
     6 Documento Cartagena pdf       documento_cartagena
     7 Documento Castro    pdf       documento_castro   
     8 Documento Catemu    pdf       documento_catemu   
     9 Documento Cauquenes pdf       documento_cauquenes
    10 Documento Cerrillos pdf       documento_cerrillos

Nótese que las eñes se reemplazaron por enes, y las letras con tilde se cambiaron por sus versiones sin tilde.

En la tabla podemos ver que separamos los nombres en distintas columnas. Ahora, usamos estas columnas para reconstruir las rutas originales y las nuevas rutas con los nombres limpios:

``` r
archivos <- archivos |> 
  # reconstruir ruta original
  mutate(ruta = paste(ruta_archivos, nombre, sep = "/"),
         ruta = paste(ruta, extension, sep = ".")) |>
  # crear ruta nueva
  mutate(ruta_nueva = paste(ruta_archivos, nombre_nuevo, sep = "/"),
         ruta_nueva = paste(ruta_nueva, extension, sep = ".")) |> 
  # ordenar
  select(ruta, ruta_nueva)

archivos
```

    # A tibble: 10 × 2
       ruta                             ruta_nueva                      
       <chr>                            <chr>                           
     1 reportes/Documento Camarones.pdf reportes/documento_camarones.pdf
     2 reportes/Documento Camiña.pdf    reportes/documento_camina.pdf   
     3 reportes/Documento Canela.pdf    reportes/documento_canela.pdf   
     4 reportes/Documento Cañete.pdf    reportes/documento_canete.pdf   
     5 reportes/Documento Carahue.pdf   reportes/documento_carahue.pdf  
     6 reportes/Documento Cartagena.pdf reportes/documento_cartagena.pdf
     7 reportes/Documento Castro.pdf    reportes/documento_castro.pdf   
     8 reportes/Documento Catemu.pdf    reportes/documento_catemu.pdf   
     9 reportes/Documento Cauquenes.pdf reportes/documento_cauquenes.pdf
    10 reportes/Documento Cerrillos.pdf reportes/documento_cerrillos.pdf

Renombramos todos los archivos usando las columnas de la tabla:

``` r
# renombrar todos los archivos
file_move(archivos$ruta, 
          archivos$ruta_nueva)
```

Claramente, todo lo anterior se puede hacer sin pasos intermedios, pero lo puse en varios pasos por motivos pedagógicos.

Así, podemos usar R para renombrar cientos o miles de archivos. Podemos usar este código básico para hacer cosas mucho más complejas, como cargar cada archivo y poner en su nombre algo relacionado a sus datos, crear nombres condicionales, navegar estructuras de directorios y organizar los archivos por carpetas, y más. Pero eso queda para otro tutorial! Si te interesa hacer alguna de estas cosas o algo similar, [escríbeme para motivarme a escribir otro post](../../../contacto/) ☺️

[^1]: Considera que las rutas dependen del lugar desde donde se ejecute R: [recuerda usar Proyectos!](https://bastianolea.rbind.io/blog/r_introduccion/proyectos/) para tener control y orden sobre dónde está trabajando R!
