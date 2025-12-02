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
excerpt: Hola
---


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
                    
                    
                    

``` r
library(dplyr)

iris |> 
  summarize(
    across(where(is.numeric), 
           ~min(.x))
    )
```

      Sepal.Length Sepal.Width Petal.Length Petal.Width
    1          4.3           2            1         0.1

``` r
iris |>
  rename(var = Petal.Width) |> # definir variable
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

``` r
library(tidyr)

iris |> 
  tibble() |> 
  summarise(
    across(where(is.numeric),
           list("minimo" = ~min(.x),
                "primer" = ~quantile(.x, probs = 0.25),
                "promedio" = ~mean(.x),
                "mediana" = ~median(.x),
                "tercer" = ~quantile(.x, probs = 0.75),
                "maximo" = ~max(.x),
                "desviacion" = ~sd(.x)
           )
    )) |> 
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
