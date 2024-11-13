---
title: Predecir género a partir de nombres usando un modelo de lenguaje en R
author: Bastián Olea Herrera
date: '2024-11-11'
slug: []
categories: []
tags:
  - procesamiento de datos
  - inteligencia artificial
  - análisis de texto
---


[Hace poco](https://bastianolea.rbind.io/blog/introduccion_llm_mall/) conocí [el paquete `{mall}`](https://mlverse.github.io/mall/), que facilita mucho el uso de un un modelo de lenguaje (LLM) local como una herramienta cotidiana para el análisis y procesamiento de datos.

El paquete incluye varias funciones para usar un modelo LLM local en las columnas de un dataframe. `{mall}` te puede ayudar a :
- clasificar el contenido de una variable
- resumir textos
- extraer sentimiento a partir del texto
- extraer información desde el texto
- confirmar si algo es verdadero o falso a partir de un texto
- y también a aplicar cualquier *prompt* a una variable.

Recientemente lo usé para un caso real, donde tenía una columna de casi 2.000 nombres, y necesitaba asignarle un género a cada una de estas personas, solamente a partir de sus nombres y apellidos.

``` r
library(dplyr) # manipulación de datos
library(readr) # cargar datos
library(tictoc) # medición de tiempo
library(mall) # aplicar modelos de lenguaje en dataframe
```

[Los datos provienen del servicio electoral de Chile](https://github.com/bastianolea/servel_scraping_votaciones), y los nombres corresponden a 1.576 candidatos y candidatas a alcaldías.

Con el siguiente código puedes descargar los datos listos para su uso:

``` r
archivo_remoto <- "https://raw.githubusercontent.com/bastianolea/servel_scraping_votaciones/refs/heads/main/datos/resultados_alcaldes_2024.csv"

candidatos <- readr::read_csv2(archivo_remoto) |> 
  select(nombres = candidato, partido, sector) |> 
  filter(nombres != "Nulo/Blanco")

candidatos
```

    # A tibble: 1,576 × 3
       nombres                            partido sector       
       <chr>                              <chr>   <chr>        
     1 Marco Antonio Gonzalez Candia      RN      Derecha      
     2 Veronica Maricel Cueto Cueto       IND     Independiente
     3 Marcela Maritza Mansilla Potocnjak IND     Independiente
     4 Alejandro Felipe Ricotti Sepulveda IND     Independiente
     5 Carlos Orlando Tapia Aviles        IND     Independiente
     6 Maria Luisa Hamilton Velasco       IND     Independiente
     7 Gaston Dubournais Riveros          IND     Independiente
     8 Marcela Chamorro Macias            IND     Izquierda    
     9 Jose Andres Arellano Blanco        IND     Independiente
    10 Andrea Elizabeth Galvez Sepulveda  REP     Derecha      
    # ℹ 1,566 more rows

En esta instancia, tengo configurado `{ollamar}` para que use el modelo local y de código abierto [Llama 3.2](https://www.llama.com), de 3 billones de parámetros. Podemos instalar este modelo, o uno distinto, con estas instrucciones:

``` r
library(ollamar)
ollamar::pull("llama3.2") # descargar e instalar un modelo
mall::llm_use("ollama", "llama3.2") # elegir un modelo instalado
```

En una primera prueba, le entregamos al modelo de lenguaje la columna `nombres` (que contiene nombre, segundo nombre, apellido, y segundo apellido), y le pedimos al modelo que clasifique cada observación como *masculino* o *femenino.*

``` r
tic()
resultados_1 <- candidatos |> 
  llm_classify(nombres,
               labels = c("masculino", "femenino"),
               pred_name = "genero")
```

    Ollama local server running

    ── mall session object 

    Backend: Ollama
    LLM session: model:llama3.2:latest
    R session:
    cache_folder:/var/folders/z8/61w5pwts4h5fsvhfqs1wpvk40000gn/T//RtmpntMvSc/_mall_cache127421f0326aa

``` r
toc()
```

    421.687 sec elapsed

El proceso tarda aproximadamente 7 minutos en clasificar los casi 1.576 nombres, un ritmo de 0.26 segundos por cada predicción.

``` r
resultados_1 |> select(genero, nombres) |> slice_sample(n = 15)
```

    # A tibble: 15 × 2
       genero    nombres                         
       <chr>     <chr>                           
     1 masculino Juan Jesus Herrera Fuentes      
     2 masculino Efrain Oporto Torres            
     3 masculino Dino Lotito Flores              
     4 masculino Maria Marjorie Jopia Herrera    
     5 masculino Jorge Contanzo Bravo            
     6 masculino Cristobal Sanchez Carvallo      
     7 masculino Humberto Garcia Diaz            
     8 masculino Gustavo Diego Marquez Cadagan   
     9 masculino Maximiliano Radonich Radonich   
    10 masculino Luis Reinaldo Pradenas Moran    
    11 masculino Nelson Fernando Lazcano Silva   
    12 masculino Bernardo Cornejo Ceron          
    13 masculino Rodrigo Esteban Castro Sepulveda
    14 masculino Juan Pablo Gomez Ramirez        
    15 masculino Kether Bautista Gomez Pasten    

Para la segunda prueba, intentamos entregarle al modelo *solamente los nombres*, excluyendo segundos nombres y apellidos, bajo el supuesto de que el primer nombre es el mejor predictor del género, mientras que los apellidos no son un predictor del género.

Probamos el código con una [expresión regular](https://stringr.tidyverse.org/articles/regular-expressions.html) (regex) para extraer la primera palabra de una secuencia de texto:

``` r
candidatos |> 
  mutate(nombre = stringr::str_extract(nombres, "\\w+")) |> 
  select(nombre, nombres) |> 
  slice_sample(n = 5)
```

    # A tibble: 5 × 2
      nombre  nombres                       
      <chr>   <chr>                         
    1 Marcelo Marcelo Patricio Bersano Reyes
    2 Americo Americo Guajardo Oyarce       
    3 Jorge   Jorge Westermeier Estrada     
    4 Omar    Omar Vera Castro              
    5 Camilo  Camilo Riffo Quintana         

Realizamos la segunda prueba de clasificación, esta vez solamente con el primer nombre:

``` r
tic()
resultados_2 <- candidatos |> 
  mutate(nombre = stringr::str_extract(nombres, "\\w+")) |> # extraer nombres
  llm_classify(nombre,
               labels = c("masculino", "femenino"),
               pred_name = "genero")
toc()
```

    139.47 sec elapsed

Esta vez el proceso tarda aproximadamente 2 minutos, ¡casi 4 veces más rápido! El modelo clasifica los textos más rápido mientras menos texto tenga que analizar. Es importante mencionar que la velocidad va a depender mucho de tu computador, específicamente su GPU.

``` r
resultados_2 |> select(genero, nombre) |> slice_sample(n = 10)
```

    # A tibble: 10 × 2
       genero    nombre  
       <chr>     <chr>   
     1 masculino Pablo   
     2 masculino Luis    
     3 femenino  Sandra  
     4 masculino Johnny  
     5 masculino Miguel  
     6 masculino Oscar   
     7 masculino Luis    
     8 masculino Gonzalo 
     9 masculino Juan    
    10 masculino Mauricio

Revisemos los resultados, obteniendo una muestra al azar de 30 nombres:

``` r
resultados_2 |> 
  filter(nombres != "Nulo/Blanco") |> 
  relocate(genero, nombre, .before = nombres) |> 
  slice_sample(n = 30) |> 
  print(n = Inf)
```

    # A tibble: 30 × 5
       genero    nombre    nombres                             partido  sector      
       <chr>     <chr>     <chr>                               <chr>    <chr>       
     1 masculino Christian Christian Arturo Cardenas Silva     IND      Independien…
     2 masculino Osvaldo   Osvaldo Cartagena Garcia            IND      Independien…
     3 masculino Romelio   Romelio Borquez Hidalgo             IND      Derecha     
     4 masculino Patricio  Patricio Marchant Ulloa             IND      Centro      
     5 masculino Claudio   Claudio Miranda Ibañez              IND      Independien…
     6 masculino Marcos    Marcos Gaete Flores                 IND      Derecha     
     7 masculino Raul      Raul Jaime Espejo Escobar           IND      Independien…
     8 masculino Camilo    Camilo Alejandro Rapu Riroroko      IND      Centro      
     9 femenino  Clara     Clara Lazcano Fernández             IND      Derecha     
    10 masculino Drazen    Drazen Andre Markusovic Caceres     PDG      Derecha     
    11 femenino  Denisse   Denisse Tamara Leon Rojas           REP      Derecha     
    12 masculino Juan      Juan Pablo Gomez Ramirez            IND      Independien…
    13 masculino Alexis    Alexis Mendez Uribe                 IND      Independien…
    14 femenino  Juana     Juana Sarmiento Acosta              IND      Independien…
    15 masculino Marco     Marco Antonio Gonzalez Candia       RN       Derecha     
    16 masculino Miguel    Miguel Bruna Silva                  IND      Independien…
    17 masculino Hernaldo  Hernaldo Andres Ahumada Chavez      IND      Independien…
    18 femenino  Nivia     Nivia Del Carmen Riquelme Gutierrez IGUALDAD Izquierda   
    19 masculino Cristian  Cristian Alejandro Sobarzo Sanhueza IND      Independien…
    20 masculino Cristian  Cristian Andres Pozo Parraguez      PS       Izquierda   
    21 femenino  Rosa      Rosa Torres Escobedo                IND      Independien…
    22 masculino Juan      Juan Carlos Gonzalez Romo           IND      Independien…
    23 femenino  Paula     Paula Rodriguez Valenzuela          IND      Independien…
    24 masculino Gabriel   Gabriel Silva Gonzalez              IND      Independien…
    25 femenino  Daniela   Daniela Isabel Munizaga Villegas    REP      Derecha     
    26 masculino Ramon     Ramon Sandoval Zurita               IND      Independien…
    27 masculino Ramon     Ramon Bahamonde Cea                 IND      Independien…
    28 masculino Claudio   Claudio Arellano Cortes             IND      Independien…
    29 femenino  Sigrid    Sigrid Ramirez Arias                IND      Derecha     
    30 masculino Patricio  Patricio Ernesto Gonzalez Nuñez     IND      Independien…

Revisando los nombres, al parecer las predicciones son bastante buenas, pero al hacer más pruebas nos damos cuenta de que no es 100% infalible, ya que se equivoca en algunos nombres como *Aracelli, Edita, Elizabeth,* o *Josselyn.* si se requiere aumentar la calidad de la predicción, podría [instalarse un modelo de lenguaje más grande.](https://ollama.com/library)

En conclusión, se trata de una herramienta muy fácil de implementar, que también es capaz de ahorrarnos bastante tiempo, por ejemplo, en el desarrollo de un algoritmo que detecte el nombre a partir de ciertas estructuras en la composición de cada uno, o bien, en tener que contrastar los nombres con alguna base de datos ya existente de nombres con un género asignado (si es que existe).
