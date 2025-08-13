---
title: Validación avanzada de datos y código con {testthat} y {pointblank}
author: Bastián Olea Herrera
date: '2025-08-08'
draft: true
slug: []
categories: []
tags:
  - procesamiento de datos
  - consejos
  - automatización
  - control de flujo
  - funciones
---


``` r
# install.packages("testthat")

library(testthat)

test_that("mapache existe",
          expect_true(exists("mapache"))
          )
```

    ── Failure: mapache existe ─────────────────────────────────────────────────────
    exists("mapache") is not TRUE

    `actual`:   FALSE
    `expected`: TRUE 

    Error:
    ! Test failed

``` r
test_that("numeritos",
          expect_equal(4, 4)
)
```

    Test passed 🌈

``` r
test_that("tipo texto",
          expect_type("mapache", "character")
)
```

    Test passed 😀
