---
title: Cargar y explorar datos de la encuesta Casen en R, usando factor de expansión
author: Bastián Olea Herrera
date: '2024-11-10'
format: hugo-md
slug: []
categories:
  - Tutoriales
tags:
  - dplyr
  - chile
  - estadística
---



Este post ejemplifica tres formas de cargar y explorar los datos de la encuesta Casen 2022, la [Encuesta de caracterización socioeconómica nacional](https://observatorio.ministeriodesarrollosocial.gob.cl/encuesta-casen-2022).

Veremos cómo obtener resultados de la Casen a nivel de país, región y comuna, usando dos formas de aplicar el factor de expansión. El factor de expansión es necesario de aplicar para transformar los resultados de la muestra de la encuesta a cifras que tienen representación a los distintos niveles de agrupación geográfica. 

Para seguir las instrucciones, primero debes descargar los datos originales de la encuesta desde [este enlace](https://observatorio.ministeriodesarrollosocial.gob.cl/encuesta-casen-2022) (presionar _Bases de datos_) en formato Stata, junto con la base de datos complementaria de provincia y comuna. Crea un nuevo proyecto de RStudio, y dentro de la carpeta del proyecto ubica ambos archivos.

Los archivos necesarios son:
- _Base de datos Casen 2022 STATA (versión 18 de marzo 2024)_
- _Base de datos provincia y comuna Casen 2022 STATA_

Primero, cargamos los paquetes que usaremos a través de este tutorial:



``` r
library(haven) # carga datos formato Stata (.dta)
library(dplyr) # manipulación de datos
library(tidyr) # ordenamiento y limpieza de datos
library(srvyr) # análisis de encuestas complejas, entre otros
library(scales) # crear porcentajes a partir de proporciones
```



## Cargar datos de Casen
Cargar base de datos principal de la encuesta Casen, en formato Stata (`.dta`):



``` r
casen <- read_dta("Base de datos Casen 2022 STATA.dta")
```



Explorar los datos cargados:



``` r
casen |> select(1:20) |> glimpse()
```

```
## Rows: 202,231
## Columns: 20
## $ id_vivienda  <dbl> 1000901, 1000901, 1000901, 1000902, 1000902, 1000902, 100…
## $ folio        <dbl> 100090101, 100090101, 100090101, 100090201, 100090201, 10…
## $ id_persona   <dbl> 1, 2, 3, 1, 2, 3, 4, 1, 2, 3, 1, 2, 1, 1, 2, 3, 4, 1, 2, …
## $ region       <dbl+lbl> 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 1…
## $ area         <dbl+lbl> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,…
## $ cod_upm      <dbl> 10009, 10009, 10009, 10009, 10009, 10009, 10009, 10009, 1…
## $ nse          <dbl+lbl> 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,…
## $ estrato      <dbl> 1630324, 1630324, 1630324, 1630324, 1630324, 1630324, 163…
## $ hogar        <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
## $ expr         <dbl> 43, 43, 44, 51, 51, 52, 51, 42, 42, 42, 38, 38, 33, 56, 5…
## $ expr_osig    <dbl> 54, NA, 122, NA, 131, NA, 44, 101, 47, NA, 81, 56, 43, 84…
## $ varstrat     <dbl> 751, 751, 751, 751, 751, 751, 751, 751, 751, 751, 751, 75…
## $ varunit      <dbl> 12041, 12041, 12041, 12041, 12041, 12041, 12041, 12041, 1…
## $ fecha_entrev <date> 2023-01-28, 2023-01-28, 2023-01-28, 2022-12-29, 2022-12-…
## $ p1           <dbl+lbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
## $ p2           <dbl+lbl> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,…
## $ p3           <dbl+lbl> 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,…
## $ p4           <dbl+lbl> 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,…
## $ p9           <dbl> 3, 3, 3, 4, 4, 4, 4, 3, 3, 3, 2, 2, 1, 4, 4, 4, 4, 2, 2, …
## $ p10          <dbl+lbl>  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1, NA,  …
```


Notamos que las columnas que corresponden a preguntas de la encuesta vienen en formato `<bls+lbl>`, un formato propio del paquete `{haven}`, que combina los valores numéricos de las variables con las etiquetas de sus categorías de respuesta.

Cargar la base de datos complementaria que contiene columnas de factor de expansión, comuna y provincia:



``` r
casen_comunas <- read_dta("Base de datos provincia y comuna Casen 2022 STATA.dta")
```



Revisar contenidos del segundo archivo:



``` r
casen_comunas
```

```
## # A tibble: 202,231 × 6
##        folio id_persona provincia     comuna          expp  expc
##        <dbl>      <dbl> <dbl+lbl>     <dbl+lbl>      <dbl> <dbl>
##  1 100090101          1 163 [Punilla] 16303 [Ñiquén]    51    52
##  2 100090101          2 163 [Punilla] 16303 [Ñiquén]    50    53
##  3 100090101          3 163 [Punilla] 16303 [Ñiquén]    51    52
##  4 100090201          1 163 [Punilla] 16303 [Ñiquén]    51    52
##  5 100090201          2 163 [Punilla] 16303 [Ñiquén]    50    52
##  6 100090201          3 163 [Punilla] 16303 [Ñiquén]    51    52
##  7 100090201          4 163 [Punilla] 16303 [Ñiquén]    51    52
##  8 100090301          1 163 [Punilla] 16303 [Ñiquén]    51    52
##  9 100090301          2 163 [Punilla] 16303 [Ñiquén]    51    52
## 10 100090301          3 163 [Punilla] 16303 [Ñiquén]    51    52
## # ℹ 202,221 more rows
```



Ahora que tenemos cargadas la base de datos principal de la encuesta, y la base secundaria que contiene las columnas sobre datos comunales, debemos unir ambas a partir de las variables que identifican las observaciones únicas de la encuesta: `folio` e `id_persona`.



``` r
casen_2 <- left_join(casen,
                     casen_comunas,
                     by = join_by(folio, id_persona))
```


Obtenemos un nuevo dataframe que contiene las columnas de ambas bases. Debemos confirmar que la unión se realizó correctamente, comparando que la cantidad de filas de la base resultante sea igual a la de la base original.


## Obtener frecuencias y porcentajes de variables de la Casen

A modelo creativo, realizaremos tres formas distintas de obtener conteos de variables a partir de la encuesta. Con esto nos referimos, por ejemplo, a obtener la cantidad de casos bajo cada nivel de pobreza económica, calcular la frecuencia de cada nivel educacional, etc.


### Conteo sin aplicar factor de expansión
Primero realizaremos un conteo básico de los casos de una variable, sin realizar ninguna consideración metodológica respecto al muestreo de la encuesta. Es decir, solamente contar las filas de la base de datos. Esto lo haremos a pesar de ser incorrecto porque es la forma más básica de realizar la operación, y también para poder compararlo más adelante a las formas correctas de contar los casos en la encuesta que Casen.

Contar la frecuencia de una variable a nivel nacional, sin factor de expansión (inexacto):



``` r
casen_2 |> 
  count(pobreza) |> 
  mutate(p = round(n/sum(n), 2)) |> 
  mutate(porcentaje = percent(p))
```

```
## # A tibble: 4 × 4
##   pobreza                      n     p porcentaje
##   <dbl+lbl>                <int> <dbl> <chr>     
## 1  1 [Pobreza extrema]      4657  0.02 2%        
## 2  2 [Pobreza no extrema]  10616  0.05 5%        
## 3  3 [No pobreza]         186838  0.92 92%       
## 4 NA                         120  0    0%
```



Contar la frecuencia de una variable a nivel regional, sin factor de expansión (inexacto):



``` r
casen_2 |> 
  group_by(region) |> 
  count(pobreza) |> 
  mutate(p = round(n/sum(n), 2)) |> 
  mutate(porcentaje = percent(p))
```

```
## # A tibble: 63 × 5
## # Groups:   region [16]
##    region                    pobreza                     n     p porcentaje
##    <dbl+lbl>                 <dbl+lbl>               <int> <dbl> <chr>     
##  1 1 [Región de Tarapacá]     1 [Pobreza extrema]      300  0.03 3%        
##  2 1 [Región de Tarapacá]     2 [Pobreza no extrema]   589  0.07 7%        
##  3 1 [Región de Tarapacá]     3 [No pobreza]          7798  0.9  90%       
##  4 1 [Región de Tarapacá]    NA                          4  0    0%        
##  5 2 [Región de Antofagasta]  1 [Pobreza extrema]      265  0.03 3%        
##  6 2 [Región de Antofagasta]  2 [Pobreza no extrema]   462  0.05 5%        
##  7 2 [Región de Antofagasta]  3 [No pobreza]          8300  0.92 92%       
##  8 2 [Región de Antofagasta] NA                          2  0    0%        
##  9 3 [Región de Atacama]      1 [Pobreza extrema]      250  0.03 3%        
## 10 3 [Región de Atacama]      2 [Pobreza no extrema]   507  0.06 6%        
## # ℹ 53 more rows
```



Contar la frecuencia de una variable a nivel comunal, sin factor de expansión (inexacto):



``` r
casen_2 |> 
  filter(region == 13) |> 
  select(-region) |> 
  group_by(comuna) |> 
  count(pobreza) |> 
  mutate(p = round(n/sum(n), 2)) |> 
  mutate(porcentaje = percent(p))
```

```
## # A tibble: 155 × 5
## # Groups:   comuna [52]
##    comuna              pobreza                    n     p porcentaje
##    <dbl+lbl>           <dbl+lbl>              <int> <dbl> <chr>     
##  1 13101 [Santiago]    1 [Pobreza extrema]       50  0.03 3%        
##  2 13101 [Santiago]    2 [Pobreza no extrema]    58  0.03 3%        
##  3 13101 [Santiago]    3 [No pobreza]          1685  0.94 94%       
##  4 13102 [Cerrillos]   1 [Pobreza extrema]       17  0.04 4%        
##  5 13102 [Cerrillos]   2 [Pobreza no extrema]     8  0.02 2%        
##  6 13102 [Cerrillos]   3 [No pobreza]           376  0.94 94%       
##  7 13103 [Cerro Navia] 1 [Pobreza extrema]        6  0.01 1%        
##  8 13103 [Cerro Navia] 2 [Pobreza no extrema]     7  0.01 1%        
##  9 13103 [Cerro Navia] 3 [No pobreza]           542  0.98 98%       
## 10 13104 [Conchalí]    1 [Pobreza extrema]       21  0.04 4%        
## # ℹ 145 more rows
```




## Conteo usando factor de expansión 

Para aplicar el factor de expansión a la base de datos, usamos las columnas `expr` y `expc`, que contienen el factor de expansión regional y comunal, respectivamente. En términos sencillos, esta cifra indica la cantidad de personas que debiese representar cada observación de la encuesta, si se pretende que la encuesta represente a la población real.

Primero seleccionamos las columnas de la base que utilizaremos:



``` r
casen_3 <- casen_2 |> 
  select(region, comuna, 
         pobreza,
         starts_with("exp"))
```




Aplicaremos el factor de expansión usando la función `uncount()` del paquete `{tidyr}`, que básicamente multiplica las filas por el factor de expansión indicado en una variable. Por ejemplo,
si una fila de la base tiene un factor de expansión 53, entonces al aplicar `uncount()`, dicha fila se repetirá 53 veces.

Esto significa que nuestra base de datos aumentará considerablemente su tamaño, potencialmente alcanzando la cantidad de filas cercana a la población nacional. Esta puede ser una cantidad de datos demasiado grande para ciertos computadores, por lo que se recomienda primero filtrar por la región o comuna que se utilizará para el análisis. 



``` r
casen_antofagasta <- casen_3 |> 
  filter(region == 2)
```




Realizar expansión de las filas de la base filtrada. Nótese la cantidad de observaciones que resulta de este procedimiento.



``` r
library(tidyr)

casen_antofagasta_exp <- casen_antofagasta |> 
  # aplicar factor de expansión
  uncount(expc)

casen_antofagasta_exp
```

```
## # A tibble: 710,691 × 6
##    region                    comuna        pobreza         expr expr_osig  expp
##    <dbl+lbl>                 <dbl+lbl>     <dbl+lbl>      <dbl>     <dbl> <dbl>
##  1 2 [Región de Antofagasta] 2201 [Calama] 3 [No pobreza]    67        81    68
##  2 2 [Región de Antofagasta] 2201 [Calama] 3 [No pobreza]    67        81    68
##  3 2 [Región de Antofagasta] 2201 [Calama] 3 [No pobreza]    67        81    68
##  4 2 [Región de Antofagasta] 2201 [Calama] 3 [No pobreza]    67        81    68
##  5 2 [Región de Antofagasta] 2201 [Calama] 3 [No pobreza]    67        81    68
##  6 2 [Región de Antofagasta] 2201 [Calama] 3 [No pobreza]    67        81    68
##  7 2 [Región de Antofagasta] 2201 [Calama] 3 [No pobreza]    67        81    68
##  8 2 [Región de Antofagasta] 2201 [Calama] 3 [No pobreza]    67        81    68
##  9 2 [Región de Antofagasta] 2201 [Calama] 3 [No pobreza]    67        81    68
## 10 2 [Región de Antofagasta] 2201 [Calama] 3 [No pobreza]    67        81    68
## # ℹ 710,681 more rows
```



Obtener frecuencia y porcentaje de una variable de la Casen, a nivel regional, aplicando factor de expansión:



``` r
casen_antofagasta_exp |> 
  # contar variable
  count(pobreza) |> 
  # calcular porcentaje
  mutate(p = n/sum(n)) |> 
  mutate(porcentaje = percent(p))
```

```
## # A tibble: 4 × 4
##   pobreza                      n        p porcentaje
##   <dbl+lbl>                <int>    <dbl> <chr>     
## 1  1 [Pobreza extrema]     19131 0.0269   2.7%      
## 2  2 [Pobreza no extrema]  34907 0.0491   4.9%      
## 3  3 [No pobreza]         656560 0.924    92.4%     
## 4 NA                          93 0.000131 0.0%
```



Obtener frecuencia y porcentaje de una variable de la Casen, a nivel comunal, aplicando factor de expansión:



``` r
casen_antofagasta_exp |> 
  # agrupar por comuna
  group_by(region, comuna) |> 
  # contar variable
  count(pobreza) |> 
  # calcular porcentaje
  mutate(p = n/sum(n)) |> 
  mutate(porcentaje = percent(p))
```

```
## # A tibble: 24 × 6
## # Groups:   region, comuna [8]
##    region                    comuna            pobreza      n       p porcentaje
##    <dbl+lbl>                 <dbl+lbl>         <dbl+l>  <int>   <dbl> <chr>     
##  1 2 [Región de Antofagasta] 2101 [Antofagast… 1 [Pob…  12108 0.0276  2.8%      
##  2 2 [Región de Antofagasta] 2101 [Antofagast… 2 [Pob…  18767 0.0428  4.3%      
##  3 2 [Región de Antofagasta] 2101 [Antofagast… 3 [No … 408071 0.930   93.0%     
##  4 2 [Región de Antofagasta] 2102 [Mejillones] 1 [Pob…     95 0.00613 0.6%      
##  5 2 [Región de Antofagasta] 2102 [Mejillones] 2 [Pob…    449 0.0290  2.9%      
##  6 2 [Región de Antofagasta] 2102 [Mejillones] 3 [No …  14955 0.965   96.5%     
##  7 2 [Región de Antofagasta] 2103 [Sierra Gor… 1 [Pob…     39 0.0218  2.2%      
##  8 2 [Región de Antofagasta] 2103 [Sierra Gor… 2 [Pob…     65 0.0364  3.6%      
##  9 2 [Región de Antofagasta] 2103 [Sierra Gor… 3 [No …   1684 0.942   94.2%     
## 10 2 [Región de Antofagasta] 2104 [Taltal]     1 [Pob…   1045 0.0752  7.5%      
## # ℹ 14 more rows
```



Obtener frecuencia y porcentaje de una variable creada a partir de la Casen, aplicando factor de expansión. Para este ejemplo, crearemos una nueva variable que unifique los dos niveles de pobreza en uno solo, generando una variable económica _pobre/no pobre:_



``` r
casen_antofagasta_exp |> 
  # crear variable dicotómica
  mutate(pobreza_2 = ifelse(pobreza %in% c(1, 2), "pobre", "no pobre")) |> 
  # conteo
  group_by(region, comuna) |> 
  count(pobreza_2) |> 
  # calcular porcentaje
  group_by(region, comuna) |> 
  mutate(p = n/sum(n)) |> 
  mutate(porcentaje = percent(p)) |> 
  # filtrar
  filter(pobreza_2 == "pobre")
```

```
## # A tibble: 7 × 6
## # Groups:   region, comuna [7]
##   region                    comuna             pobreza_2     n      p porcentaje
##   <dbl+lbl>                 <dbl+lbl>          <chr>     <int>  <dbl> <chr>     
## 1 2 [Región de Antofagasta] 2101 [Antofagasta] pobre     30875 0.0703 7%        
## 2 2 [Región de Antofagasta] 2102 [Mejillones]  pobre       544 0.0351 4%        
## 3 2 [Región de Antofagasta] 2103 [Sierra Gord… pobre       104 0.0582 6%        
## 4 2 [Región de Antofagasta] 2104 [Taltal]      pobre      2423 0.174  17%       
## 5 2 [Región de Antofagasta] 2201 [Calama]      pobre     15445 0.0793 8%        
## 6 2 [Región de Antofagasta] 2203 [San Pedro d… pobre       394 0.0363 4%        
## 7 2 [Región de Antofagasta] 2301 [Tocopilla]   pobre      4253 0.150  15%
```



----

## Conteo de encuestas de muestreo complejo

Usando el paquete `{srvyr}` podemos crear un objeto de diseño de encuestas complejas, que utilice variables acerca del diseño y muestreo de la Casen para poder calcular correctamente los estadísticos que necesitemos, incluyendo la aplicación del factor de expansión.

Establecer el diseño de encuestas complejas para la Casen:



``` r
library(srvyr)

casen_svy <- casen_2 |> 
  as_survey(weights = expr, 
            strata = estrato, 
            ids = id_persona, 
            nest = TRUE)
```




Luego, podemos utilizar este diseño para calcular frecuencias y porcentajes, entre otros, de la forma metodológicamente correcta.

Calcular frecuencia y porcentaje de una variable a nivel país, usando diseño de encuestas complejas, con factor de expansión:



``` r
casen_svy |> 
  group_by(pobreza) |> 
  summarize(n = survey_total(),
            p = survey_mean()) |> 
  # select(pobreza, n, p) |> 
  mutate(porcentaje = percent(p, accuracy = 0.01))
```

```
## # A tibble: 4 × 6
##   pobreza                        n    n_se        p      p_se porcentaje
##   <dbl+lbl>                  <dbl>   <dbl>    <dbl>     <dbl> <chr>     
## 1  1 [Pobreza extrema]      397608  12243. 0.0200   0.000432  2.00%     
## 2  2 [Pobreza no extrema]   894216  22302. 0.0450   0.000870  4.50%     
## 3  3 [No pobreza]         18572834 573457. 0.934    0.00118   93.43%    
## 4 NA                         13915   1817. 0.000700 0.0000932 0.07%
```



Notamos que éste método de calcular los estadísticos también nos ofrece los errores estándar de los conteos y los porcentajes.

Calcular frecuencia y porcentaje de una variable a nivel regional, usando diseño de encuestas complejas, con factor de expansión:



``` r
casen_svy |> 
  filter(region == 2) |> 
  group_by(pobreza) |> 
  summarize(n = survey_total(),
            p = survey_mean()) |> 
  select(pobreza, n, p) |> 
  mutate(porcentaje = percent(p, accuracy = 0.01))
```

```
## # A tibble: 4 × 4
##   pobreza                      n         p porcentaje
##   <dbl+lbl>                <dbl>     <dbl> <chr>     
## 1  1 [Pobreza extrema]     19618 0.0276    2.76%     
## 2  2 [Pobreza no extrema]  34593 0.0487    4.87%     
## 3  3 [No pobreza]         656641 0.924     92.36%    
## 4 NA                          69 0.0000971 0.01%
```



Calcular frecuencia y porcentaje de una variable a nivel comunal, usando diseño de encuestas complejas, con factor de expansión:



``` r
casen_svy |> 
  filter(region == 13) |> 
  group_by(comuna, pobreza) |> 
  summarize(n = survey_total(),
            p = survey_mean()) |> 
  select(pobreza, n, p) |> 
  mutate(porcentaje = percent(p, accuracy = 0.01)) |> 
  print(n = 15)
```

```
## Adding missing grouping variables: `comuna`
```

```
## # A tibble: 155 × 5
## # Groups:   comuna [52]
##    comuna              pobreza                     n      p porcentaje
##    <dbl+lbl>           <dbl+lbl>               <dbl>  <dbl> <chr>     
##  1 13101 [Santiago]    1 [Pobreza extrema]     12501 0.0253 2.53%     
##  2 13101 [Santiago]    2 [Pobreza no extrema]  17213 0.0348 3.48%     
##  3 13101 [Santiago]    3 [No pobreza]         465004 0.940  93.99%    
##  4 13102 [Cerrillos]   1 [Pobreza extrema]      3232 0.0406 4.06%     
##  5 13102 [Cerrillos]   2 [Pobreza no extrema]   1336 0.0168 1.68%     
##  6 13102 [Cerrillos]   3 [No pobreza]          75048 0.943  94.26%    
##  7 13103 [Cerro Navia] 1 [Pobreza extrema]      1227 0.0116 1.16%     
##  8 13103 [Cerro Navia] 2 [Pobreza no extrema]   1442 0.0137 1.37%     
##  9 13103 [Cerro Navia] 3 [No pobreza]         102811 0.975  97.47%    
## 10 13104 [Conchalí]    1 [Pobreza extrema]      4409 0.0395 3.95%     
## 11 13104 [Conchalí]    2 [Pobreza no extrema]   3544 0.0318 3.18%     
## 12 13104 [Conchalí]    3 [No pobreza]         103635 0.929  92.87%    
## 13 13105 [El Bosque]   1 [Pobreza extrema]      3998 0.0225 2.25%     
## 14 13105 [El Bosque]   2 [Pobreza no extrema]   8053 0.0454 4.54%     
## 15 13105 [El Bosque]   3 [No pobreza]         165284 0.932  93.20%    
## # ℹ 140 more rows
```


Repetimos el ejemplo anterior, pero creando una variable dicotómica de pobreza para agrupar los dos niveles de pobreza:



``` r
casen_svy |> 
  filter(region == 13) |> 
  # crear variable dicotómica
  mutate(pobreza_2 = ifelse(pobreza %in% c(1, 2), "pobre", "no pobre")) |> 
  # calcular
  group_by(comuna, pobreza_2) |> 
  summarize(n = survey_total(),
            p = survey_mean()) |> 
  select(pobreza_2, comuna, n, p) |>
  mutate(porcentaje = percent(p, accuracy = 0.01)) |> 
  filter(pobreza_2 == "pobre") |> 
  print(n = 15)
```

```
## # A tibble: 52 × 5
## # Groups:   comuna [52]
##    pobreza_2 comuna                       n       p porcentaje
##    <chr>     <dbl+lbl>                <dbl>   <dbl> <chr>     
##  1 pobre     13101 [Santiago]         29714 0.0601  6.01%     
##  2 pobre     13102 [Cerrillos]         4568 0.0574  5.74%     
##  3 pobre     13103 [Cerro Navia]       2669 0.0253  2.53%     
##  4 pobre     13104 [Conchalí]          7953 0.0713  7.13%     
##  5 pobre     13105 [El Bosque]        12051 0.0680  6.80%     
##  6 pobre     13106 [Estación Central]  9481 0.0454  4.54%     
##  7 pobre     13107 [Huechuraba]        3510 0.0322  3.22%     
##  8 pobre     13108 [Independencia]    12977 0.0703  7.03%     
##  9 pobre     13109 [La Cisterna]       8309 0.0651  6.51%     
## 10 pobre     13110 [La Florida]       13691 0.0289  2.89%     
## 11 pobre     13111 [La Granja]         9140 0.0793  7.93%     
## 12 pobre     13112 [La Pintana]       32563 0.135   13.46%    
## 13 pobre     13113 [La Reina]          2027 0.0159  1.59%     
## 14 pobre     13114 [Las Condes]        1720 0.00574 0.57%     
## 15 pobre     13115 [Lo Barnechea]       705 0.00738 0.74%     
## # ℹ 37 more rows
```




Realizar conteos obteniendo intervalos de confianza:



``` r
casen_svy |> 
  filter(region == 2) |> 
  group_by(region, comuna, pobreza) |> 
  summarize(n = survey_total(),
            p = survey_mean(vartype = c("se", "ci")))
```

```
## # A tibble: 24 × 9
## # Groups:   region, comuna [8]
##    region       comuna     pobreza      n   n_se       p    p_se   p_low   p_upp
##    <dbl+lbl>    <dbl+lbl>  <dbl+l>  <dbl>  <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
##  1 2 [Región d… 2101 [Ant… 1 [Pob…  12195 2.83e3 0.0280  0.00455 0.0190  0.0370 
##  2 2 [Región d… 2101 [Ant… 2 [Pob…  18947 5.09e3 0.0435  0.00778 0.0281  0.0589 
##  3 2 [Región d… 2101 [Ant… 3 [No … 404323 1.01e5 0.928   0.0120  0.905   0.952  
##  4 2 [Región d… 2102 [Mej… 1 [Pob…     68 1.37e1 0.00485 0.00185 0.00119 0.00851
##  5 2 [Región d… 2102 [Mej… 2 [Pob…    409 1.18e2 0.0292  0.00679 0.0157  0.0426 
##  6 2 [Región d… 2102 [Mej… 3 [No …  13552 4.51e3 0.966   0.00791 0.950   0.982  
##  7 2 [Región d… 2103 [Sie… 1 [Pob…     22 1.04e1 0.0173  0.00400 0.00936 0.0252 
##  8 2 [Región d… 2103 [Sie… 2 [Pob…     44 1.56e1 0.0346  0.00678 0.0212  0.0480 
##  9 2 [Región d… 2103 [Sie… 3 [No …   1207 4.23e2 0.948   0.00761 0.933   0.963  
## 10 2 [Región d… 2104 [Tal… 1 [Pob…   1239 2.45e2 0.0768  0.0169  0.0433  0.110  
## # ℹ 14 more rows
```



Repetir el ejemplo, pero utilizando otra variable:



``` r
casen_svy |> 
  filter(region == 2) |> 
  group_by(region, comuna, v4) |> 
  summarize(n = survey_total(),
            p = survey_mean(vartype = c("se", "ci")))
```

```
## # A tibble: 43 × 9
## # Groups:   region, comuna [8]
##    region      comuna     v4           n   n_se       p    p_se    p_low   p_upp
##    <dbl+lbl>   <dbl+lbl>  <dbl+l>  <dbl>  <dbl>   <dbl>   <dbl>    <dbl>   <dbl>
##  1 2 [Región … 2101 [Ant… 1 [1. …  80318 22990. 0.184   2.70e-2  1.31e-1 0.238  
##  2 2 [Región … 2101 [Ant… 2 [2. … 321605 80216. 0.739   2.16e-2  6.96e-1 0.781  
##  3 2 [Región … 2101 [Ant… 3 [3. …   3208   779. 0.00737 7.58e-4  5.87e-3 0.00887
##  4 2 [Región … 2101 [Ant… 4 [4. …  11973  2714. 0.0275  2.89e-3  2.18e-2 0.0332 
##  5 2 [Región … 2101 [Ant… 5 [5. …  17714  5218. 0.0407  8.21e-3  2.44e-2 0.0569 
##  6 2 [Región … 2101 [Ant… 6 [6. …    647   212. 0.00149 4.79e-4  5.37e-4 0.00243
##  7 2 [Región … 2102 [Mej… 1 [1. …   1160   203. 0.0827  1.61e-2  5.09e-2 0.114  
##  8 2 [Región … 2102 [Mej… 2 [2. …  12285  4296. 0.876   2.17e-2  8.33e-1 0.919  
##  9 2 [Región … 2102 [Mej… 5 [5. …    548   140. 0.0391  6.54e-3  2.61e-2 0.0520 
## 10 2 [Región … 2102 [Mej… 6 [6. …     36    36  0.00257 2.68e-3 -2.73e-3 0.00787
## # ℹ 33 more rows
```



----

## Comparación de resultados

Luego de haber visto tres métodos para calcular frecuencias y porcentajes desde la encuesta que hacen utilizando factor de expansión, para cerrar compararemos los resultados de los tres métodos.

**Conteo simple, sin expansión:**



``` r
casen_2 |> 
  filter(region == 5) |> 
  count(pobreza) |> 
  mutate(p = round(n/sum(n), 4)) |> 
  mutate(porcentaje = percent(p))
```

```
## # A tibble: 4 × 4
##   pobreza                     n      p porcentaje
##   <dbl+lbl>               <int>  <dbl> <chr>     
## 1  1 [Pobreza extrema]      386 0.0188 1.9%      
## 2  2 [Pobreza no extrema]   958 0.0466 4.7%      
## 3  3 [No pobreza]         19202 0.934  93.4%     
## 4 NA                          6 0.0003 0.0%
```



**Conteo y porcentaje con factor de expansión:**



``` r
casen_2 |> 
  filter(region == 5) |> 
  uncount(expr) |> 
  count(pobreza) |> 
  mutate(p = round(n/sum(n), 4)) |> 
  mutate(porcentaje = percent(p, accuracy = 0.001))
```

```
## # A tibble: 4 × 4
##   pobreza                       n      p porcentaje
##   <dbl+lbl>                 <int>  <dbl> <chr>     
## 1  1 [Pobreza extrema]      38850 0.0194 1.940%    
## 2  2 [Pobreza no extrema]   92721 0.0463 4.630%    
## 3  3 [No pobreza]         1869211 0.934  93.400%   
## 4 NA                          495 0.0002 0.020%
```



**Conteo y porcentaje con factor de expansión y diseño de encuesta compleja:**



``` r
casen_svy |> 
  filter(region == 5) |> 
  group_by(pobreza) |> 
  summarize(n = survey_total(),
            p = survey_mean()) |> 
  select(pobreza, n, p) |> 
  mutate(porcentaje = percent(p, accuracy = 0.001))
```

```
## # A tibble: 4 × 4
##   pobreza                       n        p porcentaje
##   <dbl+lbl>                 <dbl>    <dbl> <chr>     
## 1  1 [Pobreza extrema]      38850 0.0194   1.941%    
## 2  2 [Pobreza no extrema]   92721 0.0463   4.633%    
## 3  3 [No pobreza]         1869211 0.934    93.401%   
## 4 NA                          495 0.000247 0.025%
```



Los resultados de los tres métodos difieren, especialmente los del primer método con los del segundo y tercero. El segundo y tercer método solo difieren en sus decimales, pero aún así es importante comparar ambos y tomar la decisión apropiada antes de realizar el análisis:

1. El primer método _no debe usarse nunca,_ pues no aplica correctamente la metodología de la encuesta, y sus resultados difieren de la realidad. 
2. El segundo método, usando `tidyr::uncount()`, si bien puede parecer más conveniente y rápido de aplicar, obtiene resultados tiene un peor desempeño al obtener los resultados, y consume una _muy alta_ cantidad de memoria para calcular resultados a nivel nacional, o incluso regiones o comunas de gran población. En computadores con menos de 24 GB de memoria, probablemente no pueda ser posible calcular estadísticos a nivel nacional sin realizar pasos intermediarios para disminuir el consumo de memoria (como separar el cálculo por regiones y luego realizar las sumas entre ellas).
3. Entre los tres métodos, el más correcto de utilizar es el tercero, usando el paquete `{srvyr}`. Además de entregar los resultados con mayor eficiencia y velocidad, aplica correctamente la metodología de muestreo especificada por la encuesta, por lo que también es el método más exacto.


