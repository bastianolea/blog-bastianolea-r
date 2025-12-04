---
title: Calcula estadísticos descriptivos básicos en R
author: Bastián Olea Herrera
date: '2025-12-02'
slug: []
categories: []
tags:
  - estadísticas
  - básico
  - dplyr
format:
  hugo-md:
    output-file: index
    output-ext: md
excerpt: >-
  Calcular estadísticos descriptivos, como promedio, mediana y cuartiles, es un
  paso inicial de la exploración de datos. En este post aprendemos varias formas
  de calcular descriptivos personalizables a todas las variables de tu
  _dataframe_ al mismo tiempo.
---


Calcular estadísticos descriptivos en R es tan simple como usar la función `summary()` sobre cualquier tabla de datos o *dataframe*.

{{< indice >}}

## Estadísticos descriptivos iniciales

Usaremos como ejemplo el conjunto de datos `iris`, que viene incorporado en R, para aplicarle `summary()` y así obtener sus **estadísticos descriptivos**.

``` r
summary(iris)
```

      Sepal.Length    Sepal.Width     Petal.Length    Petal.Width   
     Min.   :4.300   Min.   :2.000   Min.   :1.000   Min.   :0.100  
     1st Qu.:5.100   1st Qu.:2.800   1st Qu.:1.600   1st Qu.:0.300  
     Median :5.800   Median :3.000   Median :4.350   Median :1.300  
     Mean   :5.843   Mean   :3.057   Mean   :3.758   Mean   :1.199  
     3rd Qu.:6.400   3rd Qu.:3.300   3rd Qu.:5.100   3rd Qu.:1.800  
     Max.   :7.900   Max.   :4.400   Max.   :6.900   Max.   :2.500  
           Species  
     setosa    :50  
     versicolor:50  
     virginica :50  
                    
                    
                    

La función `summary()` calcula estadísticos descriptivos básicos para cada variable numérica del conjunto de datos, incluyendo:
- **Mínimo** y **máximo**
- **Mediana:** el valor central, si los datos se ordenaran de menor a mayor
- **Promedio**
- **Primer y tercer cuartil:** si se ordenan los datos de menor a mayor, el primer cuartil indica el valor que corta la distrución de manera que el 25% de los datos son menores o iguales a él, y el tercer cuartil lo mismo pero cortando el 75% de los datos son menores o iguales a él.

## Estadísticos descriptivos con `{dplyr}`

Si queremos tener más control sobre los cálculos de estadísticos descriptivos, podemos usar `{dplyr}`.

Vamos a partir viendo cómo se hace un sólo estadístico descriptivo promedio para una sola variable, y vamos a ir avanzando desde ahí hasta poder aplicar **múltiples estadísticos descriptivos a todas las variables**.

### Calcular promedio con `summarize()`

Si bien `{dplyr}` no tiene una función que lo haga automáticamente como `summary()`, podemos usar la función `summarize()` para calcular **resúmenes estadísticos**. A `summarize()` le damos una función que usaremos para *resumir* los datos a una sola fila.

Por ejemplo, calculemos el **promedio** de una variable:

``` r
library(dplyr)

iris |> 
  summarize(
    promedio = mean(Sepal.Length)
  )
```

      promedio
    1 5.843333

### Calcular promedio de varias variables con `summarize(across())`

Para hacerlo más útil, en vez de calcular para una sola variable, podemos pedirle que calcule el promedio para todas las variables numéricas. Esto lo logramos usando `across()`, que permite aplicar las operaciones a varias columnas a la vez, indicando que queremos aplicar la operación *donde* (`where()`) las variables *sean numéricas* (`is.numeric`).

Entonces, este código calculará el promedio para todas las columnas numéricas del *dataframe*:

``` r
iris |> 
  summarize(             # resumir los datos
    across(              # donde las columnas
      where(is.numeric), # sean numéricas
      ~mean(.x),         # calculando el promedio
      .names = "{col}_promedio") # cambiar el nombre de columnas
  )
```

      Sepal.Length_promedio Sepal.Width_promedio Petal.Length_promedio
    1              5.843333             3.057333                 3.758
      Petal.Width_promedio
    1             1.199333

### Estadísticos descriptivos con `summarize()`

Siguiendo los mismos principios, ahora podemos calcular varios estadísticos descriptivos a la vez agregándolos a `summarize()`.

Primero calculemos los descriptivos para una sola variable:

``` r
iris |>
  # definir variable
  rename(var = Petal.Width) |> 
  # omitir datos perdidos
  filter(!is.na(var)) |>
  # calcular
  summarize(
    "minimo" = min(var),
    "primer" = quantile(var, probs = 0.25),
    "promedio" = mean(var),
    "mediana" = median(var),
    "tercer" = quantile(var, probs = 0.75),
    "maximo" = max(var),
    "desviacion" = sd(var)
  )
```

      minimo primer promedio mediana tercer maximo desviacion
    1    0.1    0.3 1.199333     1.3    1.8    2.5  0.7622377

### Estadísticos descriptivos por grupo

La gracia de `{dplyr}` es que al código anterior podemos agregarle una agrupación (`group_by()`) para calcular los mismos estadísticos descriptivos **por grupos**:

``` r
iris |>
  # definir variable
  rename(var = Petal.Width) |> 
  # omitir datos perdidos
  filter(!is.na(var)) |>
  # grupo
  group_by(Species) |> 
  # calcular
  summarize(
    "minimo" = min(var),
    "primer" = quantile(var, probs = 0.25),
    "promedio" = mean(var),
    "mediana" = median(var),
    "tercer" = quantile(var, probs = 0.75),
    "maximo" = max(var),
    "desviacion" = sd(var)
  )
```

    # A tibble: 3 × 8
      Species    minimo primer promedio mediana tercer maximo desviacion
      <fct>       <dbl>  <dbl>    <dbl>   <dbl>  <dbl>  <dbl>      <dbl>
    1 setosa        0.1    0.2    0.246     0.2    0.3    0.6      0.105
    2 versicolor    1      1.2    1.33      1.3    1.5    1.8      0.198
    3 virginica     1.4    1.8    2.03      2      2.3    2.5      0.275

### Estadísticos descriptivos para todas las variables

Podemos **automatizar el cálculo** de todos los estadísticos descriptivos para **todas las variables** numéricas usando `across()` dentro de `summarize()`. El resultado lo podemos [transformar a formato largo](../../../blog/r_introduccion/tidyr_pivotar/) con `{tidyr}` para facilitar su lectura:

``` r
library(tidyr)

iris |> 
  summarise(
    across(where(is.numeric),
           list("minimo" = ~min(.x),
                "primer" = ~quantile(.x, probs = 0.25),
                "promedio" = ~mean(.x),
                "mediana" = ~median(.x),
                "tercer" = ~quantile(.x, probs = 0.75),
                "maximo" = ~max(.x),
                "desviacion" = ~sd(.x))
    )
  ) |> 
  pivot_longer(everything(), 
               names_sep = "_", 
               names_to = c("variable", ".value"))
```

    # A tibble: 4 × 8
      variable     minimo primer promedio mediana tercer maximo desviacion
      <chr>         <dbl>  <dbl>    <dbl>   <dbl>  <dbl>  <dbl>      <dbl>
    1 Sepal.Length    4.3    5.1     5.84    5.8     6.4    7.9      0.828
    2 Sepal.Width     2      2.8     3.06    3       3.3    4.4      0.436
    3 Petal.Length    1      1.6     3.76    4.35    5.1    6.9      1.77 
    4 Petal.Width     0.1    0.3     1.20    1.3     1.8    2.5      0.762

### Estadísticos descriptivos para todas las variables, por grupos

Finalmente, el mismo proceso anterior de calcular todos los descriptivos para todas las variables, pero ahora **por grupos**, simplemente agregándole `group_by()` al código y cambiando las columnas a pivotar para que no incluya la variable de grupo:

``` r
iris |> 
  rename(grupo = Species) |> 
  group_by(grupo) |> 
  summarise(
    across(where(is.numeric),
           list("minimo" = ~min(.x),
                "primer" = ~quantile(.x, probs = 0.25),
                "promedio" = ~mean(.x),
                "mediana" = ~median(.x),
                "tercer" = ~quantile(.x, probs = 0.75),
                "maximo" = ~max(.x),
                "desviacion" = ~sd(.x))
    )
  ) |> 
  pivot_longer(c(everything(), -grupo), # todas menos la variable de agrupación
               names_sep = "_", 
               names_to = c("variable", ".value"))
```

    # A tibble: 12 × 9
       grupo      variable   minimo primer promedio mediana tercer maximo desviacion
       <fct>      <chr>       <dbl>  <dbl>    <dbl>   <dbl>  <dbl>  <dbl>      <dbl>
     1 setosa     Sepal.Len…    4.3   4.8     5.01     5      5.2     5.8      0.352
     2 setosa     Sepal.Wid…    2.3   3.2     3.43     3.4    3.68    4.4      0.379
     3 setosa     Petal.Len…    1     1.4     1.46     1.5    1.58    1.9      0.174
     4 setosa     Petal.Wid…    0.1   0.2     0.246    0.2    0.3     0.6      0.105
     5 versicolor Sepal.Len…    4.9   5.6     5.94     5.9    6.3     7        0.516
     6 versicolor Sepal.Wid…    2     2.52    2.77     2.8    3       3.4      0.314
     7 versicolor Petal.Len…    3     4       4.26     4.35   4.6     5.1      0.470
     8 versicolor Petal.Wid…    1     1.2     1.33     1.3    1.5     1.8      0.198
     9 virginica  Sepal.Len…    4.9   6.22    6.59     6.5    6.9     7.9      0.636
    10 virginica  Sepal.Wid…    2.2   2.8     2.97     3      3.18    3.8      0.322
    11 virginica  Petal.Len…    4.5   5.1     5.55     5.55   5.88    6.9      0.552
    12 virginica  Petal.Wid…    1.4   1.8     2.03     2      2.3     2.5      0.275

Si bien R base trae herramientas útiles como `summary()`, metiéndole un poco de `{dplyr}` podemos tener formas más flexibles y personalizables para calcular estadísticos descriptivos.

## Estadísticos descriptivos con `{skimr}`

Otra alternativa a `summary()` es la función `skim()` del [paquete `{skimr}`](https://docs.ropensci.org/skimr/), que nos entrega resúmenes estadísticos permite obtener un resumen estadístico más completo y visualmente atractivo.

Instalamos el paquete:

``` r
install.packages("skimr")
```

Luego lo probamos con nuestros datos:

``` r
library(skimr)

skim(iris)
```

La función entregará tablas con resúmenes de cantidad de observaciones, tipo de las columnas, y estadísticas descriptivas específicas para variables categóricas y numéricas.

``` r
── Data Summary ────────────────────────
                           Values
Name                       iris  
Number of rows             150   
Number of columns          5     
_______________________          
Column type frequency:           
  factor                   1     
  numeric                  4     
________________________         
Group variables            None  

── Variable type: factor ───────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate ordered n_unique top_counts               
1 Species               0             1 FALSE          3 set: 50, ver: 50, vir: 50

── Variable type: numeric ──────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate mean    sd  p0 p25  p50 p75 p100 hist 
1 Sepal.Length          0             1 5.84 0.828 4.3 5.1 5.8  6.4  7.9 ▆▇▇▅▂
2 Sepal.Width           0             1 3.06 0.436 2   2.8 3    3.3  4.4 ▁▆▇▂▁
3 Petal.Length          0             1 3.76 1.77  1   1.6 4.35 5.1  6.9 ▇▁▆▇▂
4 Petal.Width           0             1 1.20 0.762 0.1 0.3 1.3  1.8  2.5 ▇▁▇▅▃
```

{{< bajada "Gracias a [Darakhshan Nehal](https://www.linkedin.com/in/darakhshan-nehal-b38747154/) por enseñarme esta función!" >}}
{{< cafecito >}}
{{< cursos >}}
