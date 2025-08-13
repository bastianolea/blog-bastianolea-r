---
title: Encuentra diferencias entre objetos de R con {waldo}
author: Bastián Olea Herrera
date: '2025-08-12'
draft: true
format:
  hugo-md:
    output-file: index
    output-ext: md
slug: []
categories: []
tags:
  - limpieza de datos
  - consejos
---


https://waldo.r-lib.org

``` r
library(waldo)
```

``` r
vector_a <- c("a", "b", "c", "d", "e")
vector_b <- c("a", "b", "c", "f")

compare(vector_a, vector_b)
```

    `old`: "a" "b" "c" "d" "e"
    `new`: "a" "b" "c" "f"    

``` r
library(tibble)

tabla_a <- tibble(variable_ead32 = 1, 
       variable_efe23 = 1, 
       variable_eea31 = 1, 
       variable_edr52 = 1, 
       variable_ead30 = 1, 
       variable_eae31 = 1) 

tabla_b <- tibble(variable_ead32 = 1, 
       variable_efe23 = 1, 
       variable_eae31 = 1, 
       variable_ede52 = 1, 
       variable_ead30 = 1, 
       variable_eae30 = 1) 

compare(tabla_a, tabla_b)
```

        names(old)       | names(new)          
    [1] "variable_ead32" | "variable_ead32" [1]
    [2] "variable_efe23" | "variable_efe23" [2]
    [3] "variable_eea31" - "variable_eae31" [3]
    [4] "variable_edr52" - "variable_ede52" [4]
    [5] "variable_ead30" | "variable_ead30" [5]
    [6] "variable_eae31" - "variable_eae30" [6]

    `old$variable_eea31` is a double vector (1)
    `new$variable_eea31` is absent

    `old$variable_edr52` is a double vector (1)
    `new$variable_edr52` is absent

    `old$variable_ede52` is absent
    `new$variable_ede52` is a double vector (1)

    `old$variable_eae30` is absent
    `new$variable_eae30` is a double vector (1)
