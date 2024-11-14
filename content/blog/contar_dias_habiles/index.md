---
title: Contar días hábiles entre dos fechas en R
author: Bastián Olea Herrera
date: '2024-11-13'
format: hugo-md
slug: []
categories: []
tags:
  - limpieza de datos
  - procesamiento de datos
  - lubridate
excerpt: >-
  En esta guía explico cómo hacer un cálculo de diferencia entre fechas, o
  conteo entre de días entre dos fechas, ya sea entre días corridos o solamente
  considerando los días hábiles.
---


``` r
library(dplyr) # manipulación de datos
library(lubridate) # trabajar con fechas
library(RQuantLib) # paquete con calendarios
library(bizdays) # paquete para contar días hábiles
```

Hoy se me planteó un pequeño desafío que no había tenido que hacer antes. Tenía que contar la cantidad de días entre dos fechas.

Esto no es particularmente complejo, de hecho es demasiado fácil:

Primero definimos las dos fechas:

``` r
fecha_hoy <- today()
fecha_anterior <- today() - weeks(2)

fecha_hoy
```

    [1] "2024-11-13"

``` r
fecha_anterior
```

    [1] "2024-10-30"

Y luego usamos una sencilla función para buscar la diferencia entre ambas fechas:

``` r
difftime(fecha_hoy, fecha_anterior)
```

    Time difference of 14 days

Entre el 13 de noviembre y el 30 de octubre de 2024 hay 14 días. Incluso, lo anterior podría ser aún más simple:

``` r
fecha_hoy - fecha_anterior
```

    Time difference of 14 days

En R, tan sencillo como restar dos fechas para obtener la diferencia de tiempo entre ambas.

Pero el problema no era que tenía que contar entre dos fechas, sino que tenía que contar sólo los **días hábiles** entre ambas.

Esto se vuelve más complejo. Primero, porque habría que definir una forma de saltarse los fines de semana. Pero también, los días hábiles son aquellos que no son festivos, y esto implica tener una lista de todos los días festivos o feriados. Pero además, ¡los días festivos son locales! Dependen de cada país y son distintos en cada uno, e incluso cambian en el tiempo: se crean nuevos, desaparecen otros, y algunos cambian de fecha entre año y año.

Menos mal que en R existe un paquete para todo 😌 [El paquete `{RQuantLib}`](https://github.com/eddelbuettel/rquantlib) contiene la información de calendarios de muchísimos países del mundo. A su vez, [el paquete `{bizdays}`](http://wilsonfreitas.github.io/R-bizdays/) te permite tomar esa información de los calendarios y usarlos para el cálculo de días hábiles entre fechas:

``` r
bizdays::load_quantlib_calendars(
  "Chile", 
  from = "2023-01-01",
  to = "2025-12-31")
```

    Calendar QuantLib/Chile loaded

``` r
calendars() # confirmar que el calendario está cargado
```

    Calendars: 
    actual, Brazil/ANBIMA, Brazil/B3, Brazil/BMF, QuantLib/Chile, weekends

Ahora que tenemos un calendario de los días feriados en Chile cargado en R, usamos la función `bizdays()` del paquete del mismo nombre para calcular la cantidad de días hábiles entre ambas fechas, especificando el calendario que queremos usar:

``` r
bizdays(fecha_hoy, fecha_anterior, 
        "QuantLib/Chile")
```

    [1] -8

En este caso, el resultado es 8, porque a los 14 días que habían entre ambas fechas le resta dos fines de semana (4 días), y además le resta dos días feriados oficiales en Chile (*día de las Iglesias Evangélicas* el 31 de octubre y el *Día de todos los santos* el 1 de noviembre).

Repitamos el mismo ejemplo, pero ahora en una pequeña tabla de datos ficticios:

``` r
datos <- tibble::tribble(
  ~n,        ~fecha,       ~fecha_hoy,
  "16831",   "2024-02-19", "2024-11-13",
  "40003",   "2024-01-12", "2024-11-13",
  "90667",   "2024-04-06", "2024-11-13",
  "80205",   "2024-10-07", "2024-11-13",
  "14457",   "2024-08-30", "2024-11-13"
)
```

En este ejemplo, primero calculamos la diferencia normal entre días, arreglamos el resultado de la diferencia de tiempo para formar los números comunes, y luego calculamos la diferencia entre días hábiles, para poder comparar:

``` r
datos |> 
  mutate(dias_comunes = difftime(fecha, fecha_hoy), 
         dias_comunes = dias_comunes |> as.numeric() |> abs() |> round(0),
         dias_habiles = bizdays(fecha, fecha_hoy, "QuantLib/Chile")
  )
```

    # A tibble: 5 × 5
      n     fecha      fecha_hoy  dias_comunes dias_habiles
      <chr> <chr>      <chr>             <dbl>        <dbl>
    1 16831 2024-02-19 2024-11-13          268          181
    2 40003 2024-01-12 2024-11-13          306          207
    3 90667 2024-04-06 2024-11-13          221          147
    4 80205 2024-10-07 2024-11-13           37           25
    5 14457 2024-08-30 2024-11-13           75           48
