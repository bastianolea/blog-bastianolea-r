---
title: Números romanos en R
author: Bastián Olea Herrera
format: hugo-md
date: 2024-09-25T00:00:00.000Z
categories:
  - Procesamiento de datos
tags:
  - curiosidades
lang: es
excerpt: ¿Sabías que R tiene un tipo de datos para números romanos? Yo tampoco
---


¿Sabías que R tiene un tipo de datos para números romanos? Yo tampoco.

``` r
library(dplyr)

regiones <- tibble(region = c("I Región de Tarapacá", "II Región de Antofagasta", "III Región de Atacama", 
                              "IV Región de Coquimbo", "IX Región de La Araucanía", "V Región de Valparaíso", 
                              "VI Región del Libertador General Bernardo O'Higgins", "VII Región del Maule", 
                              "VIII Región del Bío Bío", "X Región de los Lagos", "XI Región de Aysén del General Carlos Ibañez del Campo", 
                              "XII Región de Magallanes y la Antártica Chilena", "XIII Región Metropolitana", 
                              "XIV Región Los Ríos", "XV Región Arica y Parinacota", "XVI Ñuble"
))
```

Si extraemos la primera palabra de la variable `region`, obtenemos solamente el número romano.

``` r
regiones_2 <- regiones |> 
  mutate(romano = stringr::str_extract(region, "\\w+"))

regiones_2
```

    # A tibble: 16 × 2
       region                                                 romano
       <chr>                                                  <chr> 
     1 I Región de Tarapacá                                   I     
     2 II Región de Antofagasta                               II    
     3 III Región de Atacama                                  III   
     4 IV Región de Coquimbo                                  IV    
     5 IX Región de La Araucanía                              IX    
     6 V Región de Valparaíso                                 V     
     7 VI Región del Libertador General Bernardo O'Higgins    VI    
     8 VII Región del Maule                                   VII   
     9 VIII Región del Bío Bío                                VIII  
    10 X Región de los Lagos                                  X     
    11 XI Región de Aysén del General Carlos Ibañez del Campo XI    
    12 XII Región de Magallanes y la Antártica Chilena        XII   
    13 XIII Región Metropolitana                              XIII  
    14 XIV Región Los Ríos                                    XIV   
    15 XV Región Arica y Parinacota                           XV    
    16 XVI Ñuble                                              XVI   

Luego, convertimos le damos al número romano la clase apropiada:

``` r
regiones_3 <- regiones_2 |> 
  mutate(romano = as.roman(romano)) |> 
  relocate(romano, .before = 1)

regiones_3
```

    # A tibble: 16 × 2
       romano  region                                                
       <roman> <chr>                                                 
     1 I       I Región de Tarapacá                                  
     2 II      II Región de Antofagasta                              
     3 III     III Región de Atacama                                 
     4 IV      IV Región de Coquimbo                                 
     5 IX      IX Región de La Araucanía                             
     6 V       V Región de Valparaíso                                
     7 VI      VI Región del Libertador General Bernardo O'Higgins   
     8 VII     VII Región del Maule                                  
     9 VIII    VIII Región del Bío Bío                               
    10 X       X Región de los Lagos                                 
    11 XI      XI Región de Aysén del General Carlos Ibañez del Campo
    12 XII     XII Región de Magallanes y la Antártica Chilena       
    13 XIII    XIII Región Metropolitana                             
    14 XIV     XIV Región Los Ríos                                   
    15 XV      XV Región Arica y Parinacota                          
    16 XVI     XVI Ñuble                                             

``` r
class(regiones_3$romano)
```

    [1] "roman"

Finalmente, vemos cómo resulta posible convertir desde números romanos a números arábigos; es decir, a la clase `numeric` en R.

``` r
regiones_2 |> 
  mutate(numero = as.numeric(romano)) |> 
  relocate(numero, .after = romano)
```

    Warning: There was 1 warning in `mutate()`.
    ℹ In argument: `numero = as.numeric(romano)`.
    Caused by warning:
    ! NAs introduced by coercion

    # A tibble: 16 × 3
       region                                                 romano numero
       <chr>                                                  <chr>   <dbl>
     1 I Región de Tarapacá                                   I          NA
     2 II Región de Antofagasta                               II         NA
     3 III Región de Atacama                                  III        NA
     4 IV Región de Coquimbo                                  IV         NA
     5 IX Región de La Araucanía                              IX         NA
     6 V Región de Valparaíso                                 V          NA
     7 VI Región del Libertador General Bernardo O'Higgins    VI         NA
     8 VII Región del Maule                                   VII        NA
     9 VIII Región del Bío Bío                                VIII       NA
    10 X Región de los Lagos                                  X          NA
    11 XI Región de Aysén del General Carlos Ibañez del Campo XI         NA
    12 XII Región de Magallanes y la Antártica Chilena        XII        NA
    13 XIII Región Metropolitana                              XIII       NA
    14 XIV Región Los Ríos                                    XIV        NA
    15 XV Región Arica y Parinacota                           XV         NA
    16 XVI Ñuble                                              XVI        NA
