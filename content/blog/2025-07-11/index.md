---
title: Gráfico de densidad tipo Joy Division en {ggplot2}
author: Bastián Olea Herrera
date: '2025-07-12'
draft: false
slug: []
categories: []
tags:
  - ggplot2
  - gráficos
excerpt: "Existe un gráfico estadístico muy famoso por haber aparecido en la portada del disco _Unknown Pleasures_ de Joy Division. Se trata de un gráfico de densidad, donde las densidades están apiladas verticalmente y se sobreponen, dando una apariencia montañosa, cordillerana y casi tridimensional. En este post reproduciremos este gráfico en R, usando datos socioeconómicos de la Encuesta de caracterización socioeconómica nacional (Casen) 2022."
---


Existe un gráfico estadístico muy famoso por haber aparecido en la portada del disco _Unknown Pleasures_ de Joy Division:

{{< imagen "joy_division.jpg" >}}

Se trata de un gráfico de densidad, donde las densidades están apiladas verticalmente y se sobreponen, dando una apariencia montañosa, cordillerana y casi tridimensional.

En este post reproduciremos este gráfico en R, pero usando datos socioeconómicos de la [Encuesta de caracterización socioeconómica nacional (Casen) 2022.](https://observatorio.ministeriodesarrollosocial.gob.cl/encuesta-casen-2022)

Los paquetes que usaremos son los siguientes: 
```r
library(arrow) # carga de datos en formato parquet
library(dplyr) # manipulación de datos
library(ggplot2) # visualización de datos
library(scales) # escalas para gráficos
library(ggridges) # geometría de densidad apilada para {ggplot2}
library(forcats) # orden ordenamiento de datos tipo factor
library(tidyr) # transformación y ordenamiento de datos 
```

Vamos a obtener los datos de la Casen de forma más rápida desde un [repositorio de datos de ingresos de la encuesta Casen](https://github.com/bastianolea/casen_comparador_ingresos), en el cual dispongo los datos en un formato [más rápido](https://arrow.apache.org/docs/r/) de cargar.

Como dato al margen, los datos de ese repositorio se usan en una [aplicación interactiva desarrollada en R](https://bastianoleah.shinyapps.io/casen_comparador_ingresos). donde puedes comparar la densidades de las distribuciones de ingreso de cualquier comuna de Chile.

<div style="max-width:340px; margin:auto;">

{{< imagen "comparador_ingresos_casen.jpg" >}}

</div>


### Datos

Primero cargamos los datos de población comunal, que solamente usaremos para luego seleccionar las comunas con mayor población del país. Como en el siguiente código los datos se cargan directamente desde el repositorio, no necesita descargar ningún archivo para poder ejecutar este código en tu computadora.

```r
# cargar datos de población
poblacion <- arrow::read_parquet("https://github.com/bastianolea/casen_comparador_ingresos/raw/main/datos/censo_proyecciones_año.parquet")

# obtener población comunal
poblacion_comunas <- poblacion |> 
  filter(año == 2024) |> 
  arrange(desc(población))
```

Luego cargamos los datos de la encuesta Casen desde el repositorio:

```r
# cargar encuesta casen
casen2022_2 <- arrow::read_parquet("https://github.com/bastianolea/casen_comparador_ingresos/raw/main/datos/casen_ingresos.parquet")
```

### Procesamiento

Para poder usar estos datos de la forma correcta necesitamos procesarlos en base al [diseño de encuestas de muestreo complejo](https://bastianolea.rbind.io/blog/casen_introduccion/#conteo-de-encuestas-de-muestreo-complejo), en el que se basa la Casen. Esto debido a que la encuesta requiere de la aplicación de factores de expansión para poder obtener resultados que busquen representar a la población real. Para más información, [revisa este post donde lo explico.](https://bastianolea.rbind.io/blog/casen_introduccion/)

```r
# procesar encuesta de diseño complejo
library(srvyr)

casen_svy <- casen2022_2 |> 
  # filtrar 80 comunas con más población
  filter(comuna %in% poblacion_comunas$comuna[1:80]) |> 
  # crear diseño de encuestas complejas
  as_survey(weights = expc, 
            strata = estrato, 
            ids = id_persona, 
            nest = TRUE)
```

En el código anterior se cargó el conjunto de datos, se filtraron las 80 comunas con más población, para no tener un gráfico eterno, y se aplicó el diseño de encuestas complejas con `as_survey()`.

Una vez que tenemos el objeto `survey` que nos permite trabajar con los datos usando la metodología apropiada de factor de expansión, calculamos la cantidad de personas a la que representa cada observación en la encuesta. Usaremos la variable de ingresos propios de la ocupación principal, `yoprcor`.

```r
# calcular cantidades usando factor de expansión
casen_ingresos <- casen_svy |> 
  group_by(comuna, yoprcor) |> 
  summarize(n = survey_total(),
            p = survey_mean())
```

Si realizamos los datos, nos encontramos con las observaciones de la encuesta, que incluyen la información de la comuna y la variable de ingresos que elegimos, pero además, tenemos la columna `n` que nos indica a cuántas personas representa cada observación de la encuesta, gracias a la aplicación del factor de expansión.

```
# A tibble: 9,155 × 6
# Groups:   comuna [80]
   comuna        yoprcor     n  n_se        p     p_se
   <chr>           <dbl> <dbl> <dbl>    <dbl>    <dbl>
 1 Alto Hospicio   14789    36  36   0.000260 0.000233
 2 Alto Hospicio   20000    32  32   0.000231 0.000213
 3 Alto Hospicio   30000   211 109.  0.00152  0.000691
 4 Alto Hospicio   40000    36  36   0.000260 0.000233
 5 Alto Hospicio   45000    36  36   0.000260 0.000233
 6 Alto Hospicio   50000   527 262.  0.00380  0.00124 
 7 Alto Hospicio   60000   405 333.  0.00292  0.00207 
 8 Alto Hospicio   70000    48  48   0.000346 0.000334
 9 Alto Hospicio   75000    77  52.1 0.000556 0.000332
10 Alto Hospicio   80000   264 136.  0.00191  0.000779
# ℹ 9,145 more rows
```

Ahora limpiamos un poco los datos, calculamos las medianas de ingresos comunales, y limitamos los ingresos máximos en una cifra que considero un ingreso suficientemente alto como para mostrar la inequidad de ingresos sin que los ingresos bajos se vuelvan invisibles.

```r
# limpiar datos y limitar ingresos
casen_ingresos_2 <- casen_ingresos |> 
  rename(variable = yoprcor) |> 
  filter(!is.na(variable)) |> 
  # calcular mediana de ingresos
  group_by(comuna) |> 
  mutate(mediana = median(variable, na.rm = T)) |>
  # limitar ingresos máximos, ordenar comunas
  filter(variable < 2500000) |> 
  ungroup() |> 
  # ordenar las comunas de mayor a menor por su mediana de ingresos
  mutate(comuna = as.factor(comuna),
         comuna = fct_reorder(comuna, mediana))
```

Finalmente, preparamos los datos para la visualización. [El tipo de visualización que vamos a usar, el **gráfico de densidad**](https://bastianolea.rbind.io/blog/r_introduccion/tutorial_visualizacion_ggplot/#densidad), realiza un cálculo de densidades; es decir, distribuye todas las observaciones a través del eje horizontal del gráfico, y eleva a una curva en relación a la cantidad de personas que percibe los ingresos correspondientes a cada punto del eje. 

Entonces, necesitamos que cada observación de nuestra tabla corresponda a una _persona_ que percibe un ingreso específico. 

Como vimos más atrás, tenemos una columna de `comunas`, una columna de la cifra de los ingresos (`yoprcor`), y la columna `n` que indica cuántas personas perciben cada ingreso. Por lo tanto, tenemos que _alargar_ nuestra base de datos para que cada ingreso percibido aparezca repetido en tantas filas como personas se indican en `n`. En otras palabras, tenemos que hacer el ejercicio inverso a _contar_ las personas que perciben un ingreso; es decir, _des-contar_ la tabla de datos: justamente lo que hace la función `uncount()`:

```r
# expandir observaciones
casen_ingresos_3 <- casen_ingresos_2 |> 
  mutate(n = as.integer(n)) |> 
  uncount(weights = n)
```

Obtenemos una tabla de datos con 6 millones de filas, donde cada fila representa a una _persona._  

### Gráfico de densidad apilada

El gráfico que queremos hacer tiene en el eje horizontal los ingresos, y en el eje vertical las comunas, y cada una de estas filas del eje vertical mostrará la densidad de ingresos de cada comuna.

En su versión más básica sería algo así:

```r
casen_ingresos_3 |>
  ggplot() +
  aes(x = variable, y = comuna) +
  geom_density_ridges()
```

{{< imagen "grafico_base.png" >}}


A este gráfico horripilante le aplicaremos un poco de magia de `{ggplot2}` para darle la apariencia que merece.

El punto clave es la función `geom_density_ridges()`, que produce las densidades apiladas o _crestas_. El argumento `scale` define la elevación de cada densidad por encima de la que tiene detrás, y `bandwidth` controla que tanto se suavizan los datos al calcular la curva de densidad, aumentando disminuyendo el detalle de las figuras. Al extremo derecho del gráfico agregué la mediana de ingresos de cada comuna con `geom_text()`.

```r
number_options(decimal.mark = ",", big.mark = ".") # opciones de números grandes

casen_ingresos_3 |>
  ggplot() +
  aes(x = variable, y = comuna) +
  # densidades
  geom_density_ridges(rel_min_height = 0, scale = 4, bandwidth = 30000,
                      fill = "black", color = "white") +
  # textos de medianas a la derecha
  geom_text(data = ~distinct(.x, variable, comuna, mediana),
            aes(label = label_currency()(mediana |> signif(digits = 2)), 
                x = 2500000), nudge_x = 120000,
            color = "white", size = 2.5, check_overlap = T, hjust = 0, vjust = 0.3) +
  # expandir escala horizontal
  scale_x_continuous(expand = expansion(c(0, 0.09)), 
                     breaks = c(0, .5, 1, 1.5, 2, 2.5)*1000000,
                     labels = label_currency()) +
  # no cortar geometrías fuera del plano de coordenadas
  coord_cartesian(clip = "off") +
  # tema
  theme_void(base_family = "Helvetica") +
  # texto eje horizontal
  theme(axis.text.x = element_text(size = 6, color = "white", margin = margin(t = 4))) +
  # texto eje vertical
  theme(axis.text.y = element_text(size = 7, color = "white", hjust = 1, vjust = 0.3, margin = margin(r = 7))) +
  # fondo
  theme(panel.background = element_rect(fill = "black", linewidth = 0),
        plot.background = element_rect(fill = "black", linewidth = 0),
        plot.margin = unit(c(5, 4, 5, 4), "mm")) +
  theme(plot.title = element_text(size = 10, hjust = 0.4, colour = "white", margin = margin(b = 3)),
        plot.subtitle = element_text(size = 8, hjust = 0.4, colour = "white", margin = margin(b = 6))) +
  # textos
  labs(title = "Distribución de ingresos por comuna: Chile" |> toupper(),
       subtitle = "Ingreso de la ocupación principal, CASEN 2022")
```

{{< imagen "grafico_densidad_joy_division.jpg" >}}

Evidentemente, este gráfico es más estético que funcional. Sin embargo, se trata de un ejercicio de visualización basada en datos reales. El gráfico nos permite ver rápidamente la concentración de ingresos en la mayoría de las comunas en torno al sueldo mínimo, cada una con distintas desviaciones respecto a esta columna montañosa. Las densidades de más arriba corresponden a comunas de mayores ingresos, y por lo tanto sus distribuciones muestran una mayor cantidad de personas que perciben ingresos mayores a 500.000, incluso formándose una pequeña montañita sobre los 2 millones. A medida que bajamos la vista por el gráfico vemos como las demás comunas van acercando sus densidades hacia la mediana nacional.

----

{{< cafecito >}}

{{< cursos >}}