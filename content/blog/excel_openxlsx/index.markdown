---
title: "Crea planillas de Excel con formato desde R con {openxlsx}"
author: Bastián Olea Herrera
date: '2025-08-01'
slug: []
categories: []
draft: true
tags:
  - limpieza de datos
  - procesamiento de datos
  - automatización
  - Excel
---



https://ycphs.github.io/openxlsx/

https://www.r-bloggers.com/2024/11/creating-professional-excel-reports-with-r-a-comprehensive-guide-to-openxlsx-package/

https://guslipkin.medium.com/making-pretty-excel-files-in-r-46a15c7a2ee8




``` r
library(arrow)

datos <- read_parquet("https://github.com/bastianolea/siedu_indicadores_urbanos/raw/main/datos/siedu_indicadores_desarrollo_urbano.parquet")

datos
```

```
## # A tibble: 6,701 × 12
##    codigo_comuna codigo_region codigo_provincia nombre_region nombre_provincia
##            <dbl> <chr>         <chr>            <chr>         <chr>           
##  1          1107 01            011              Tarapacá      Iquique         
##  2          1107 01            011              Tarapacá      Iquique         
##  3          1107 01            011              Tarapacá      Iquique         
##  4          1107 01            011              Tarapacá      Iquique         
##  5          1107 01            011              Tarapacá      Iquique         
##  6          1107 01            011              Tarapacá      Iquique         
##  7          1107 01            011              Tarapacá      Iquique         
##  8          1107 01            011              Tarapacá      Iquique         
##  9          1107 01            011              Tarapacá      Iquique         
## 10          1107 01            011              Tarapacá      Iquique         
## # ℹ 6,691 more rows
## # ℹ 7 more variables: nombre_comuna <chr>, id <chr>, año <dbl>, variable <chr>,
## #   valor <dbl>, medida <chr>, estandar <chr>
```


``` r
library(dplyr)

datos |> distinct(variable)
```

```
## # A tibble: 68 × 1
##    variable                                                                     
##    <chr>                                                                        
##  1 Cantidad de jornadas diarias completas de trabajo de médicos, en salud prima…
##  2 Cantidad de luminarias cada 50 metros lineales de red vial                   
##  3 Cantidad de residuos eliminados con disposición final per cápita             
##  4 Consumo de energía eléctrica per cápita no residencial                       
##  5 Consumo de energía eléctrica per cápita residencial                          
##  6 Densidad de hogares en campamentos                                           
##  7 Densidad de oferta planificada de transporte público mayor en periodo punta …
##  8 Densidad de oferta planificada de transporte público menor en periodo punta …
##  9 Diferencia entre el valor de suelo más alto y el más bajo entre las áreas ho…
## 10 Distancia a centros de salud primaria                                        
## # ℹ 58 more rows
```


``` r
datos <- datos |> 
  filter(variable %in% c("Distancia a plazas públicas",
                         "Número de víctimas mortales en siniestros de tránsito por cada 100.000 habitantes",
                         "Porcentaje de cobertura de la red de ciclovía sobre la red vial")) |> 
  group_by(nombre_region, nombre_comuna, variable) |>
  filter(año == max(año)) |>
  ungroup()

datos
```

```
## # A tibble: 340 × 12
##    codigo_comuna codigo_region codigo_provincia nombre_region   nombre_provincia
##            <dbl> <chr>         <chr>            <chr>           <chr>           
##  1          1107 01            011              Tarapacá        Iquique         
##  2          1107 01            011              Tarapacá        Iquique         
##  3          1107 01            011              Tarapacá        Iquique         
##  4          9201 09            092              La Araucanía    Malleco         
##  5          9201 09            092              La Araucanía    Malleco         
##  6          9201 09            092              La Araucanía    Malleco         
##  7          2101 02            021              Antofagasta     Antofagasta     
##  8          2101 02            021              Antofagasta     Antofagasta     
##  9          2101 02            021              Antofagasta     Antofagasta     
## 10         15101 15            151              Arica y Parina… Arica           
## # ℹ 330 more rows
## # ℹ 7 more variables: nombre_comuna <chr>, id <chr>, año <dbl>, variable <chr>,
## #   valor <dbl>, medida <chr>, estandar <chr>
```


``` r
library(tidyr)

datos <- datos |> 
  select(nombre_region, nombre_comuna, codigo_comuna, variable, valor) |> 
  pivot_wider(names_from = variable, values_from = valor) |> 
  arrange(codigo_comuna)

datos
```

```
## # A tibble: 117 × 6
##    nombre_region nombre_comuna   codigo_comuna `Distancia a plazas públicas`
##    <chr>         <chr>                   <dbl>                         <dbl>
##  1 Tarapacá      Iquique                  1101                          282.
##  2 Tarapacá      Alto Hospicio            1107                          275.
##  3 Antofagasta   Antofagasta              2101                          426.
##  4 Antofagasta   Calama                   2201                          274.
##  5 Atacama       Copiapó                  3101                          245.
##  6 Atacama       Tierra Amarilla          3103                          289.
##  7 Atacama       Vallenar                 3301                          241.
##  8 Coquimbo      La Serena                4101                          303.
##  9 Coquimbo      Coquimbo                 4102                          291.
## 10 Coquimbo      Ovalle                   4301                          275.
## # ℹ 107 more rows
## # ℹ 2 more variables:
## #   `Número de víctimas mortales en siniestros de tránsito por cada 100.000 habitantes` <dbl>,
## #   `Porcentaje de cobertura de la red de ciclovía sobre la red vial` <dbl>
```


``` r
library(writexl)

write_xlsx(datos, "indicadores.xlsx")
```



{{< imagen "openxlsx_0.png">}}




``` r
library(openxlsx)

tabla <- createWorkbook()
```


``` r
addWorksheet(tabla, "Hoja")
```

{{< imagen "openxlsx_1.png" >}}



``` r
# tabla con formato personalizado
writeDataTable(tabla, "Hoja",
               x = datos,  # la tabla que queremos escribir en el Excel
               tableStyle = "TableStyleLight9", # estilo de la tabla
               startRow = 1, startCol = 1,
               colNames = TRUE,
               bandedRows = TRUE,
               withFilter = FALSE, 
               # keepNA = TRUE, 
               # na.string = "sin datos"
)
```

{{< imagen "openxlsx_2.png" >}}



``` r
# ancho de columnas
setColWidths(tabla, "Hoja",
             cols = c(1, 2, 3,
                      4, 5, 6),
             widths = c(22, 22, 13,
                        30, 30, 30)
)
```

{{< imagen "openxlsx_3.png" >}}



``` r
# flujo de texto 
addStyle(tabla, "Hoja",
         style = createStyle(wrapText = TRUE), 
         rows = c(1, 1:nrow(datos)+1), 
         cols = c(1, 4, 5, 6), 
         stack = TRUE, gridExpand = T)  
```

{{< imagen "openxlsx_4.png" >}}



``` r
# celdas en negrita
addStyle(tabla, "Hoja",
         style = createStyle(textDecoration = "BOLD"), 
         rows = 1:nrow(datos)+1, 
         cols = c(1, 2), 
         stack = TRUE, gridExpand = T)
```

{{< imagen "openxlsx_5.png" >}}



``` r
# centrado vertical
addStyle(tabla, "Hoja",
         style = createStyle(valign = "center"),
         rows = 1:nrow(datos)+1, cols = 1:length(datos), 
         stack = TRUE, gridExpand = T)
```

{{< imagen "openxlsx_6.png" >}}



``` r
# decimales

addStyle(tabla, "Hoja",
         style = createStyle(numFmt = "0.00"), 
         rows = 1:nrow(datos)+1, cols = c(6),
         stack = TRUE, gridExpand = TRUE)

addStyle(tabla, "Hoja",
         style = createStyle(numFmt = "0.0"), 
         rows = 1:nrow(datos)+1, cols = c(4, 5),
         stack = TRUE, gridExpand = TRUE)
```

{{< imagen "openxlsx_7.png" >}}



``` r
which(datos[[4]] > 400)
```

```
##  [1]   3  11  14  15  16  21  22  24  25  27  28  29  36  46  51  57  61  77  79
## [20]  94  96  98  99 102 105 110
```


``` r
# color condicional
addStyle(tabla, "Hoja",
         style = createStyle(fgFill = "indianred1"),
         rows = which(datos[[4]] > 400)+1, 
         cols = 4, 
         stack = TRUE, gridExpand = T)

addStyle(tabla, "Hoja",
         style = createStyle(fgFill = "indianred1"),
         rows = which(datos[[5]] > 10)+1, 
         cols = 5, 
         stack = TRUE, gridExpand = T)

addStyle(tabla, "Hoja",
         style = createStyle(fgFill = "palegreen3"),
         rows = which(datos[[6]] > 5)+1, 
         cols = 6, 
         stack = TRUE, gridExpand = T)
```

{{< imagen "openxlsx_8.png" >}}



``` r
# guardar
saveWorkbook(tabla, 
             "indicadores.xlsx",
             overwrite = TRUE)
```




### Otros
Aquí voy a ir dejando otras funcionalidades útiles de `{openxlsx}`:

Definir el tamaño que tendrá la ventana al abrir la planilla



``` r
# tamaño de la ventana
setWindowSize(tabla,
              yWindow = 12, xWindow = 12,
              windowWidth = "23000",
              windowHeight = "19000")
```



Cambiar la altura de las celdas:



``` r
# altura para celdas con texto
setRowHeights(tabla, "Hoja",
              rows = c(6, 7, 12, 13),
              heights = c(64, 64, 64))
```

