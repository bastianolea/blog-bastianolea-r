---
title: Redactar textos basados en datos usando IA desde R
author: Bastián Olea Herrera
date: '2026-02-19'
slug: []
categories: []
tags:
  - texto
  - inteligencia artificial
format:
  hugo-md:
    output-file: index
    output-ext: md
excerpt: >-
  En un post anterior vimos cómo usar R para [producir textos basados en
  datos](/blog/redactar_texto/). En este post veremos cómo usar un modelo de
  lenguaje (LLM) o _IA_ para interpretar datos directamente desde R, pero
  también usaremos la IA para generar código de R y reutilizarlo. Moraleja: es
  mejor pedirle código a la IA que pedirle respuestas y arriesgarte a errores o
  alucinaciones!
---


[Como vimos en un post anterior](../../../blog/redactar_texto/), podemos usar funcionalidades de R para generar párrafos de texto que se basen en datos, para integrar cifras y otros valores de un *dataframe* en un párrafo diseñado para resumir o presentar la información.

Si bien esto produce textos de máxima precisión y nos entrega todo el control sobre el texto generado, también existen **herramientas de inteligencia artificial** que pueden facilitar este trabajo.

{{< info "Al usar IA siempre debemos recordar que obtendremos **resultados probabilísticos**; es decir que serán resultados que pueden **variar**, pueden **contener errores**, y que **no son reproducibles**." >}}

Existen paquetes que hacen muy fácil usar IA en R!

Igual que en el [post anterior](../../../blog/redactar_texto/), usaremos un conjunto de datos demográficos: los [resultados del Censo de población y vivienda 2024 de Chile](https://censo2024.ine.gob.cl/resultados/), específicamente la **población por género** en cada región del país.

{{< boton "Descargar datos" "P5_Genero.xlsx" "fas fa-file-download" >}}
{{< detalles "**Ver código de la limpieza de los datos**" >}}

``` r
library(dplyr)
library(janitor)
library(readxl)
library(tidyr)

# cargar
genero <- read_xlsx("P5_Genero.xlsx", sheet = 2)

# limpiar
genero_limpio <- genero |> 
  row_to_names(3) |> 
  filter(!is.na(Región))

# transformar a largo
genero_long <- genero_limpio |> 
  pivot_longer(cols = 4:last_col(),
               names_to = "genero",
               values_to = "poblacion") |> 
  rename(total = 3)

# convertir variables y calcular porcentajes
genero_porcentaje <- genero_long |> 
  mutate(poblacion = as.numeric(poblacion),
         total = as.numeric(total)) |>
  clean_names() |>
  mutate(porcentaje = poblacion / total)

# filtrar
genero <- genero_porcentaje |> 
  filter(region != "País")
```

{{< /detalles >}}

Luego de limpiar estos datos, vemos columnas con las regiones del país, la población regional, los distintos géneros consultados en el censo, la cantidad de personas y su porcentaje:

``` r
library(dplyr)

datos <- genero |> 
filter(region == "Valparaíso")

datos
```

    # A tibble: 7 × 6
    codigo_region region       total genero                   poblacion porcentaje
    <chr>         <chr>        <dbl> <chr>                        <dbl>      <dbl>
    1 5             Valparaíso 1505034 Masculino                   704691   0.468   
    2 5             Valparaíso 1505034 Femenino                    780209   0.518   
    3 5             Valparaíso 1505034 Transmasculino                3003   0.00200 
    4 5             Valparaíso 1505034 Transfemenino                 1369   0.000910
    5 5             Valparaíso 1505034 No binario                    2161   0.00144 
    6 5             Valparaíso 1505034 Otro                           624   0.000415
    7 5             Valparaíso 1505034 Prefiere no responder/N…     12977   0.00862 

Para ver más claramente los datos, aquí una tabla:

| region     |   total | genero                        | poblacion | porcentaje |
|:-----------|--------:|:------------------------------|----------:|-----------:|
| Valparaíso | 1505034 | Masculino                     |    704691 |  0.4682226 |
| Valparaíso | 1505034 | Femenino                      |    780209 |  0.5183996 |
| Valparaíso | 1505034 | Transmasculino                |      3003 |  0.0019953 |
| Valparaíso | 1505034 | Transfemenino                 |      1369 |  0.0009096 |
| Valparaíso | 1505034 | No binario                    |      2161 |  0.0014358 |
| Valparaíso | 1505034 | Otro                          |       624 |  0.0004146 |
| Valparaíso | 1505034 | Prefiere no responder/No sabe |     12977 |  0.0086224 |

Ahora que tenemos los datos, pasemos a lo interesante!

## Configurar un modelo de IA en R con `{ellmer}`

{{< info "Puedes encontrar instrucciones más detalladas sobre configurar el uso de IA en R [en esta publicación.](/blog/ellmer/)" >}}

Usaremos un modelo de lenguaje (LLM) en R [por medio del paquete `{ellmer}`.](https://ellmer.tidyverse.org)

``` r
install.packages("ellmer")
```

{{< info "`{ellmer}` es un [paquete de R](https://ellmer.tidyverse.org/index.html) que facilita la interacción con modelos de lenguaje desde R, y se usa como el motor de muchos otros paquetes que usan IA.">}}

Antes que nada, para poder usar la IA en R tienes que tener una **llave API de tu proveedor de IA** (OpenAI, Anthropic, GitHub Models, etc.) configurada en tus **variables de entorno**, como se explica en la [documentación de `{ellmer}`](https://ellmer.tidyverse.org/index.html#authentication).

En mi caso, uso [GitHub Copilot](https://github.com/copilot), que me da acceso a GitHub Models, que a su vez me da acceso a varias IA como ChatGPT y Claude.

{{< detalles "**Instrucciones para configurar tu proveedor de IA en R**" >}}

En resumen, ejecuta `usethis::edit_r_environ()` para abrir tu archivo `.Renviron`, donde se pueden guardar secretos que se aplican a todas tus sesiones de R pero quedan ocultos, y agrega una línea con la *API key*, por ejemplo:

``` r
OPENAI_API_KEY=345345398475937434534539847593743453453984759374
```

Si tu proveedor es Claude (Anthropic), el nombre de la variable es `ANTHROPIC_API_KEY`, etc.

Luego de esto podrás usar las funciones `chat_openai()`, `chat_anthropic()` o la que te corresponda, porque estas funciones simplemente buscarán que tengas la *API key* para poder funcionar. De lo contrario, te aparecerá un mensaje en la consola o instrucciones para configurar las llaves.

{{< /detalles >}}

Puedes probar si R puede acceder al modelo de IA iniciando un chat de prueba. Primero creamos una sesión con `chat_openai()`, `chat_anthropic()`, o la función que corresponda a tu proveedor de IA, y luego usamos el objeto resultante para mantener una conversación con la IA.

``` r
library(ellmer)

# crear sesión de chat
chat <- chat_github() # o chat_openai(), chat_anthropic(), etc.

# preguntar algo a la IA
chat$chat("¿Cuál es el animal más bonito del mundo? Finge que es el mapache")
```

> El mapache, sin duda, es el animal más bonito del mundo. Con su adorable carita enmascarada, sus ojos grandes y curiosos, y sus pequeñas manos habilidosas, el mapache conquista corazones en todo el planeta.

🦝 Si nuestro modelo está funcionando, pasemos a su configuración para ponerlo a hacer algo útil!

## Interpretar datos con IA desde R

Para generar texto a partir de datos desde R usando modelos de lenguaje necesitamos dos cosas:
1. **Un *prompt*** que haga que el modelo de lenguaje interprete los datos correctamente
2. **Una tabla** de datos que el modelo pueda interpretar.

### Configurar el modelo para interpretar texto

El *prompt* es simplemente una **instrucción** para el modelo de lenguaje. Procura usar conceptos claros y relacionados al *output* que esperas (en este caso, palabras como *demográfico*, *estadísticas*, etc.):

``` r
prompt <- "Eres un interpretador de datos sobre demográficos. 
Tu rol es entregar una interpretación clara y precisa 
de tablas de datos poblacionales. Responde solamente 
con una interpretación de los datos estadísticos que 
resuma la información y exponga los puntos clave, 
escrito en un sólo párrafo conciso."
```

Luego, al momento de **crear el chat** en R con la función `chat_openai()` o equivalente, podemos entregar este *prompt* como *system prompt*; es decir, como una instrucción general que coordina el funcionamiento del modelo:

``` r
chat <- chat_github(model = "openai/gpt-5",
system_prompt = prompt)
```

### Preparar los datos para la IA

Ahora que tenemos el modelo configurado, necesitamos **preparar los datos** para que el modelo pueda interpretarlos.

Algunos modelos y servicios permiten recibir datos directamente, pero en este caso **entregaremos los datos como texto.**

Para esto, usamos la función `kable()` del paquete `{knitr}` para convertir nuestro *dataframe* en una **tabla de texto** (en formato *markdown*) que el modelo pueda leer:

``` r
tabla <- knitr::kable(datos)

tabla
```

``` md
|region     |   total|genero                        | poblacion| porcentaje|
|:----------|-------:|:-----------------------------|---------:|----------:|
|Valparaíso | 1505034|Masculino                     |    704691|  0.4682226|
|Valparaíso | 1505034|Femenino                      |    780209|  0.5183996|
|Valparaíso | 1505034|Transmasculino                |      3003|  0.0019953|
|Valparaíso | 1505034|Transfemenino                 |      1369|  0.0009096|
|Valparaíso | 1505034|No binario                    |      2161|  0.0014358|
|Valparaíso | 1505034|Otro                          |       624|  0.0004146|
|Valparaíso | 1505034|Prefiere no responder/No sabe |     12977|  0.0086224|
```

Otra alternativa popular es convertir los datos a `JSON`, un formato de datos no estructurados que, en teoría, los modelos de lenguaje saben interpretar mejor:

``` r
tabla <- jsonlite::toJSON(datos)

tabla
```

``` json
[{"region":"Valparaíso","total":1505034,"genero":"Masculino","poblacion":704691,"porcentaje":0.4682},{"region":"Valparaíso","total":1505034,"genero":"Femenino","poblacion":780209,"porcentaje":0.5184},{"region":"Valparaíso","total":1505034,"genero":"Transmasculino","poblacion":3003,"porcentaje":0.002},{"region":"Valparaíso","total":1505034,"genero":"Transfemenino","poblacion":1369,"porcentaje":0.0009},{"region":"Valparaíso","total":1505034,"genero":"No binario","poblacion":2161,"porcentaje":0.0014},{"region":"Valparaíso","total":1505034,"genero":"Otro","poblacion":624,"porcentaje":0.0004},{"region":"Valparaíso","total":1505034,"genero":"Prefiere no responder/No sabe","poblacion":12977,"porcentaje":0.0086}] 
```

### Obtener la interpretación datos

El último paso es simplemente **entregar la tabla de texto al chat**, el cual retornará su interpretación, dado que ya le dimos la instrucción en el *system prompt* al crear el chat:

``` r
resultado <- chat$chat(tabla)

resultado
```

> En la Región de Valparaíso (total 1.505.034 personas), la población es mayoritariamente femenina con 780.209 personas (≈51,84%), seguida por 704.691
> hombres (≈46,82%); las identidades trans y no binarias suman proporciones pequeñas pero presentes: transmasculino 3.003 (≈0,20%), transfemenino 1.369
> (≈0,09%), no binario 2.161 (≈0,14%) y "otro" 624 (≈0,04%); además, 12.977 personas (≈0,86%) prefieren no responder o no saben, configurando un perfil
> predominantemente femenino con baja no respuesta y diversidad de género minoritaria.

Obtuvimos una interpretación clara de los datos, con cifras exactas, con muy poco esfuerzo 🤖

⛅️ En algún lugar lejano, 6 litros de agua fueron consumidos por un *datacenter* 🏭

Lo malo de esto es que no hay garantías de que al pedirle algo similar al modelo obtengamos un resultado equivalente. Sin embargo, existen opciones:
- Entregar el *output* de la IA como un ejemplo para que el modelo de lenguaje se guíe en su siguiente respuesta, siguiendo la anterior.
- Usar el modelo de lenguaje para **pedirle código de R que genere los textos de descripción** 💡😲

## Usar IA para obtener código de R

Cuando usamos IA para analizar datos, muchas veces **pedirle a la IA código que produzca los resultados es mejor que pedirle los resultados directamente!**

Esto se debe a que el código es **reproducible**, mientras que los resultados de la IA pueden variar cada vez que se los pidas. Además, el código te da **control total** sobre cómo se generan los resultados, y puedes modificarlo para ajustarlo a tus necesidades.

Primero tomamos el párrafo de texto que obtuvimos anteriormente como **ejemplo** para la IA:

``` r
ejemplo <- "En la Región de Valparaíso (total 1.505.034 personas), la población es mayoritariamente femenina con 780.209 personas (≈51,84%), seguida por 704.691 hombres (≈46,82%); las identidades trans y no binarias suman proporciones pequeñas pero presentes: transmasculino 3.003 (≈0,20%), transfemenino 1.369 (≈0,09%), no binario 2.161 (≈0,14%) y “otro” 624 (≈0,04%); además, 12.977 personas (≈0,86%) prefieren no responder o no saben, configurando un perfil 
predominantemente femenino con baja no respuesta y diversidad de género minoritaria."
```

Luego escribimos un *system prompt* distinto, que explicite nuestro nuevo objetivo:

``` r
chat <- chat_github(model = "openai/gpt-5",
system_prompt = "Eres un desarrollador de R experto en ciencias sociales y estadísticas, con experiencia en paquetes del Tidyverse. Entrega respuestas en código de R.")
```

Luego creamos un *prompt* que integre nuestra nueva instrucción, el ejemplo de párrafo que esperamos, y los datos nuevos:

``` r
resultado <- chat$chat(
paste("Entrégame código de R que redacte un párrafo similar al siguiente, a partir de la tabla de datos que te adjunto:",
"Ejemplo del texto:", ejemplo,
"Tabla de datos", tabla)
)
```

El resultado es una **función** bastante extensa, aunque dudo que sea [mejor que mi propia función artesanal](https://bastianolea.rbind.io/blog/redactar_texto/#crear-una-función-que-redacte-texto), hecha a mano, vegana, y libre de consumo de agua 😌

{{< detalles "**Ver código para generar párrafos de texto entregado por la IA**" >}}

``` r
library(dplyr)
library(stringr)
library(glue)
library(scales)
library(tibble)

# Función para redactar el párrafo
redactar_parrafo <- function(df, region = NULL) {
  df1 <- df %>%
    { if (!is.null(region)) filter(., region == !!region) else . } %>%
    mutate(genero = as.character(genero))
  
  if (nrow(df1) == 0) return(NA_character_)
  
  total <- df1$total %>% unique() %>% `[`(1)
  total_fmt <- number(total, accuracy = 1, big.mark = ".", decimal.mark = ",")
  
  # Masculino y Femenino
  mf <- df1 %>% 
    filter(genero %in% c("Masculino","Femenino")) %>% 
    select(genero, poblacion, porcentaje)
  
  if (nrow(mf) == 0) stop("No se encontraron filas para Masculino/Femenino.")
  
  if (nrow(mf) == 2) {
    mayor <- mf %>% arrange(desc(porcentaje)) %>% slice(1)
    menor <- mf %>% arrange(desc(porcentaje)) %>% slice(2)
  } else {
    mayor <- mf %>% slice(1)
    menor <- NULL
  }
  
  adj_map <- c("Femenino" = "femenina", "Masculino" = "masculina")
  sus_map <- c("Femenino" = "mujeres",  "Masculino" = "hombres")
  
  mayor_adj <- adj_map[mayor$genero]
  mayor_pop <- number(mayor$poblacion, accuracy = 1, big.mark = ".", decimal.mark = ",")
  mayor_pct <- percent(mayor$porcentaje, accuracy = 0.01, decimal.mark = ",")
  
  if (!is.null(menor)) {
    menor_sus <- sus_map[menor$genero]
    menor_pop <- number(menor$poblacion, accuracy = 1, big.mark = ".", decimal.mark = ",")
    menor_pct <- percent(menor$porcentaje, accuracy = 0.01, decimal.mark = ",")
  }
  
  # Otras identidades (excluye no respuesta)
  otros <- df1 %>% 
    filter(!genero %in% c("Masculino","Femenino","Prefiere no responder/No sabe")) %>%
    mutate(
      etiqueta = case_when(
        genero == "Otro" ~ "“otro”",
        TRUE ~ str_to_lower(genero)
      ),
      pieza = glue("{etiqueta} {number(poblacion, accuracy=1, big.mark='.', decimal.mark=',')} (≈{percent(porcentaje, accuracy=0.01, decimal.mark=',')})")
    )
  
  otros_str <- if (nrow(otros) > 0) {
    v <- otros$pieza
    if (length(v) == 1) v else paste0(paste(v[-length(v)], collapse = ", "), " y ", v[length(v)])
  } else ""
  
  # No respuesta
  nr <- df1 %>% filter(genero == "Prefiere no responder/No sabe")
  nr_pieza <- if (nrow(nr) == 1) {
    nr_pop <- number(nr$poblacion, accuracy = 1, big.mark = ".", decimal.mark = ",")
    nr_pct <- percent(nr$porcentaje, accuracy = 0.01, decimal.mark = ",")
    glue("{nr_pop} personas (≈{nr_pct})")
  } else NA_character_
  
  nr_qual <- if (nrow(nr) == 1) {
    if (nr$porcentaje < 0.02) "baja" else if (nr$porcentaje < 0.05) "moderada" else "alta"
  } else "—"
  
  region_nom <- unique(df1$region)[1]
  
  parte_mf <- if (!is.null(menor)) {
    glue("la población es mayoritariamente {mayor_adj} con {mayor_pop} personas (≈{mayor_pct}), seguida por {menor_pop} {menor_sus} (≈{menor_pct});")
  } else {
    glue("la población reportada es {mayor_adj} con {mayor_pop} personas (≈{mayor_pct});")
  }
  
  parte_otros <- if (nchar(otros_str) > 0) {
    glue(" las identidades trans y no binarias suman proporciones pequeñas pero presentes: {otros_str};")
  } else ""
  
  parte_nr <- if (!is.na(nr_pieza)) {
    glue(" además, {nr_pieza} prefieren no responder o no saben,")
  } else ""
  
  cierre <- glue(" configurando un perfil predominantemente {mayor_adj} con {nr_qual} no respuesta y diversidad de género minoritaria.")
  
  texto <- glue("En la Región de {region_nom} (total {total_fmt} personas), {parte_mf}{parte_otros}{parte_nr}{cierre}")
  as.character(texto)
}
```

{{< /detalles >}}

Lo importante es que podemos usar la función generada por la IA para obtener resultados reutilizables y reproducibles:

``` r
redactar_parrafo(genero, region = "Valparaíso")
```

<ul>
<li>En la Región de Valparaíso (total 1.505.034 personas), la población es mayoritariamente femenina con 780.209 personas (≈51,84%), seguida por 704.691 hombres (≈46,82%); las identidades trans y no binarias suman proporciones pequeñas pero presentes: transmasculino 3.003 (≈0,20%), transfemenino 1.369 (≈0,09%), no binario 2.161 (≈0,14%) y “otro” 624 (≈0,04%); además, 12.977 personas (≈0,86%) prefieren no responder o no saben, configurando un perfil predominantemente femenina con baja no respuesta y diversidad de género minoritaria.</li>
</ul>

``` r
redactar_parrafo(genero, region = "Metropolitana de Santiago")
```

<ul>
<li>En la Región de Metropolitana de Santiago (total 5.839.785 personas), la población es mayoritariamente femenina con 3.010.084 personas (≈51,54%), seguida por 2.746.994 hombres (≈47,04%); las identidades trans y no binarias suman proporciones pequeñas pero presentes: transmasculino 13.754 (≈0,24%), transfemenino 5.838 (≈0,10%), no binario 8.230 (≈0,14%) y “otro” 2.318 (≈0,04%); además, 52.567 personas (≈0,90%) prefieren no responder o no saben, configurando un perfil predominantemente femenina con baja no respuesta y diversidad de género minoritaria.</li>
</ul>

La moraleja es que **es mejor usar la IA para que produzca código que genere los resultados que esperas**, en lugar de pedirle directamente respuestas que no van a ser reproducibles ni reutilizables y pueden contener ~~alucinaciones~~ errores o datos inventados!

{{< cafecito >}}
{{< cursos >}}
