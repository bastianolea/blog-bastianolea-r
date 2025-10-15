library(dplyr)

datos <- tribble(~animal,   ~patas, ~lindura,    ~color,
                    "mapache",    "4",      100,    "gris",
                    "gato",      "80",       90,   "negro",
                    "pollo",      "2",       NA,  "plumas",
                    "rata",  "cuatro",       90, "#CCCCCC")

library(testthat)

# test_that("mapache existe",
#           expect_true(exists("mapache"))
# )
# 
# test_that("numeritos",
#           expect_equal(4, 4)
# )
# 
# test_that("tipo texto",
#           expect_type("mapache", "character")
# )


test_that("se cargaron los datos",
          expect_true(exists("datos"))
)

test_that("suficientes columnas",
          expect_equal(ncol(datos), 4)
)

test_that("columnas tipo texto",
          expect_type(datos$animal, "character")
)

test_that("columnas tipo texto",
          expect_type(datos$patas, "numeric")
)
