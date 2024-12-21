---
title: Análisis de sentimiento usando modelos de lenguaje (LLM) locales en R
author: Bastián Olea Herrera
date: '2024-12-22'
slug: []
format: hugo-md
draft: false
tags:
  - análisis de texto
  - inteligencia artificial
categories:
  - tutoriales
editor_options:
  chunk_output_type: console
---


El análisis de sentimientos es una técnica de análisis de texto donde se aplican distintos algoritmos para poder clasificar textos de distinta longitud y complejidad en un conjunto preestablecido de categorías relacionadas al sentimiento de dichos textos. Con el *sentimiento* de los textos nos referimos a la información subjetiva que entregan estos textos, así como los afectos que producen. Por ejemplo, "odio a mi gato" versus "mi gatita es tan tierna" son dos textos que expresan distintos niveles de negatividad/positividad, agresividad, ternura, etcétera. Las categorías del análisis del sentimiento suelen ser *positivo, neutro* y *negativo,* u otras más complejas, como agrado (agradable/desagradable), activación (activo/pasivo), entre otros.

En otras palabras, la aplicación de un análisis de sentimiento a un conjunto de textos nos permitiría clasificar estos textos en categorías como positivo, neutro y negativo, en base a la forma en que describen el tema del que tratan, o bien, cualidades de las palabras que se usen dentro del texto.

El análisis de sentimiento usualmente es un medio para poder contar con nueva información que nos permita desarrollar nuevos análisis. En este sentido, la nueva variable de sentimiento resulta útil de ser cruzada con otras variables acerca del texto, tales como variables que identifiquen la autoría del texto, su fuente, quien enuncia el texto, de qué trata el texto, etc.

Algunos usos del análisis de sentimiento son:
- Evaluar si los textos dentro de un conjunto de textos o *corpus* son positivos o negativos,
- Correlacionar si los textos de distintos autores difieren en sus sentimientos,
- Analizar si textos sobre determinadas temáticas se correlacionan con sentimientos específicos,
- Estudiar si ciertos temas son tratados de una forma específica por ciertos autores, y de una forma distinta por otros
- Comparar si textos sobre un mismo tema son expuestos de forma distinta por distintos autores o fuentes

Pensemos en el ejemplo de un conjunto de artículos de prensa o noticias, cada uno con fecha y el medio de comunicación del que proviene. Si hacemos una selección de noticias sobre un tema específico, podríamos analizar cómo cambia el sentimiento dominante con el que se plantea la temática en distintos momentos del tiempo, o si dos medios de comunicación representan una misma temática bajo distinto sentimiento.

``` r
library(dplyr)
library(readr)
```

Probemos haciendo un análisis de sentimiento a partir de un corpus de textos de noticias chilenas publicadas el año 2024. Los datos son obtenidos de [este repositorio de obtención automatizada de textos de noticias de prensa escrita chilena.](https://github.com/bastianolea/prensa_chile)

``` r
# dirección web donde se encuentran los datos
url_datos <- "https://raw.githubusercontent.com/bastianolea/prensa_chile/refs/heads/main/datos/prensa_datos_muestra.csv"

# lectura de los datos ubicados en internet
noticias <- read_csv2(url_datos)

# extracción de una marcha aleatoria de 20 noticias
noticias_muestra <- noticias |> 
  slice_sample(n = 20)
```

En el código anterior, identificamos la ubicación de los datos que usaremos de prueba, que corresponden a un conjunto de 3000 noticias públicas del año 2024, y cargamos los datos directamente desde internet. Como se trata de una prueba, reduciremos la cantidad de noticias a tan sólo 20:

``` r
noticias_muestra
```

    # A tibble: 20 × 4
       titulo                                               cuerpo fuente fecha     
       <chr>                                                <chr>  <chr>  <date>    
     1 "Sismo de 7,3 de magnitud con epicentro en San Pedr… "El m… La Na… 2024-07-18
     2 "Mirar, inclinar y tocar: Las recomendaciones del B… "Aton… Emol   2024-09-13
     3 "Frío y lluvia en la zona central: El pronóstico de… "El p… Megan… 2024-04-26
     4 "Comisión de Minería y Energía de la Cámara aprueba… "De m… D. Fi… 2024-11-06
     5 "Nuevo líder de Salesforce Chile entrega detalles d… "En f… D. Fi… 2024-09-30
     6 "Carabineros incauta 84 máquinas de azar y detiene … "Los … La Na… 2024-04-05
     7 "Este martes se estrena la nueva temporada de Indec… "Este… Megan… 2024-08-13
     8 "Trabajo activa subsidio al empleo en zonas afectad… "El s… D. Fi… 2024-02-20
     9 "José Piñera aparece en misa fúnebre de su hermano … "El e… Megan… 2024-02-09
    10 "Hombre de 41 años es asesinado en Viña: fue atacad… "El p… La Na… 2024-09-17
    11 "Canto de ballenas jorobadas enviada al espacio ins… "Desd… El De… 2024-05-06
    12 "Juan Pablo Hermosilla adelanta que entregará chats… "Juan… El Dí… 2024-10-23
    13 "Eclipse Solar 2024: revisa la fecha y ciudades de … "El m… El Mo… 2024-10-01
    14 "Lluvia en Santiago: ¿Hasta cuándo precipitará inte… "En l… Megan… 2024-06-21
    15 "OLCA y alza de la luz: “El sistema energético está… "En u… El Ci… 2024-07-06
    16 "Caso Pío Nono: fiscalía busca evitar ir a juicio t… "Qué … Ex-An… 2024-01-24
    17 "“Le mintió a Chile”: Diputado Guzmán presentó ante… "El d… CNN C… 2024-11-18
    18 "PDI confirma detención de \"Perro Elvis\" por pres… "Dura… 24 Ho… 2024-08-31
    19 "Otra de Maduro: El controvertido mandatario boliva… "Vene… Publi… 2024-08-09
    20 "“Ha sido un día difícil”: ministra Tohá confirma q… "“Ha … Publi… 2024-10-17

Los datos tienen una columna con el título, otra con el cuerpo de la noticia, y finalmente la fuente de la noticia y su fecha de publicación.

## Configuración del modelo de lenguaje local

Para poder usar modelos LLM localmente con R, [tenemos que instalar Ollama](https://ollama.com/) en nuestro equipo, que es la aplicación que nos permite obtener y usar modelos de lenguaje locales, y ejecutar la aplicación en nuestro computador. Ollama tiene que estar abierto para poder proveer del modelo a nuestra sesión de R.

Luego, ya sea desde Ollama o desde R, tenemos que instalar un modelo de lenguaje. Desde R, es tan simple como ejecutar: `ollamar::pull("llama3.2:1b")`, definiendo el [modelo](https://ollama.com/search) que queremos instalar. Al elegir un modelo, debes considerar las capacidades de tu computador para ejecutar los modelos, y que el tamaño del modelo es directamente proporcional con la calidad de sus respuestas[^1].

Una vez tengas Ollama abierto en tu computador, y un modelo previamente instalado, puedes proceder a usarlo en R en el siguiente paso.

## Extracción de sentimiento a partir del texto

Para realizar el análisis de sentimiento, utilizaremos la ayuda de un modelo de lenguaje de gran tamaño (LLM), los cuales están entrenados para este tipo de tareas. Cargamos [el paquete {mall} para uso de LLMs en R](https://mlverse.github.io/mall/#get-started), y {beepr} para anunciar con una campanita cuando se termine el procesamiento, porque puede tardar unos minutos.

``` r
library(mall)
library(beepr)

# ollamar::pull("llama3.1:8b") # instalar modelo
llm_use("ollama", "llama3.1:8b") # cargar modelo
```

La [función `llm_sentiment()` del paquete {mall}](https://mlverse.github.io/mall/#sentiment) facilita la extracción del sentimiento a partir del texto. Tan sólo es necesario indicar la columna que contiene el texto, y las categorías de sentimiento que deseamos obtener. Por medio del siguiente código, se alimenta al modelo de lenguaje con cada uno de los textos, y se le pide obtener como respuesta si el texto es positivo, neutro o negativo.

``` r
noticias_sentimiento <- noticias_muestra |> 
  llm_sentiment(cuerpo, 
                pred_name = "sentimiento",
                options = c("positivo", "neutro", "negativo"))
beep()
```

En mi computador personal, este proceso en total tomó 88 segundos, lo que significa que tarda aproximadamente cuatro segundos por cada texto que el modelo analiza y clasifica. Esto depende de las capacidades gráficas de tu computador, y del largo del texto. Las noticias suelen tener como mínimo varios cientos de palabras, lo que hace que el proceso sean un poco más lento.

A continuación, vemos los resultados del análisis de sentimiento:

``` r
noticias_sentimiento |> 
  select(sentimiento, titulo)
```

    # A tibble: 20 × 2
       sentimiento titulo                                                           
       <chr>       <chr>                                                            
     1 neutro      "Sismo de 7,3 de magnitud con epicentro en San Pedro de Atacama …
     2 positivo    "Mirar, inclinar y tocar: Las recomendaciones del Banco Central …
     3 negativo    "Frío y lluvia en la zona central: El pronóstico de Alejandro Se…
     4 positivo    "Comisión de Minería y Energía de la Cámara aprueba en particula…
     5 positivo    "Nuevo líder de Salesforce Chile entrega detalles de los súper a…
     6 negativo    "Carabineros incauta 84 máquinas de azar y detiene a 3 personas …
     7 positivo    "Este martes se estrena la nueva temporada de Indecisos: Candida…
     8 positivo    "Trabajo activa subsidio al empleo en zonas afectadas por los in…
     9 negativo    "José Piñera aparece en misa fúnebre de su hermano Sebastián: Le…
    10 negativo    "Hombre de 41 años es asesinado en Viña: fue atacado con “un obj…
    11 positivo    "Canto de ballenas jorobadas enviada al espacio inspira obra de …
    12 positivo    "Juan Pablo Hermosilla adelanta que entregará chats de su herman…
    13 positivo    "Eclipse Solar 2024: revisa la fecha y ciudades de Chile en las …
    14 negativo    "Lluvia en Santiago: ¿Hasta cuándo precipitará intensamente en l…
    15 negativo    "OLCA y alza de la luz: “El sistema energético está centrado en …
    16 negativo    "Caso Pío Nono: fiscalía busca evitar ir a juicio tras revés par…
    17 negativo    "“Le mintió a Chile”: Diputado Guzmán presentó antecedentes a Co…
    18 negativo    "PDI confirma detención de \"Perro Elvis\" por presunta responsa…
    19 negativo    "Otra de Maduro: El controvertido mandatario bolivariano ordena …
    20 negativo    "“Ha sido un día difícil”: ministra Tohá confirma que Presidente…

``` r
noticias_sentimiento |> 
  select(sentimiento) |> 
  table()
```

    sentimiento
    negativo   neutro positivo 
          11        1        8 

### Conclusión

Revisando los resultados a la rápida, vemos que una noticia sobre un sismo es aparentemente **neutra**, probablemente por la forma en que esté redactada. Noticias sobre la aprobación de un proyecto de ley, la presentación de nuevas tecnologías, o beneficios para personas afectadas por incendios, son interpretadas como **positivas**. Por último, noticias sobre frentes de mal tiempo, operaciones policiales, funerales, crímenes y asesinatos son interpretadas como **negativas**. También, vemos que una noticia donde una ministra interpreta una jornada como difícil también es negativa, y otra donde se critica al mandatario de un país por sus actos también.

En este sentido, el desempeño de aplicar el modelo de lenguaje para obtener el sentimiento de los textos parece satisfactorio. De forma automatizada, y sin intervención ni supervisión humana, hemos obtenido valiosa información que resume un aspecto del significado codificado en los textos.

A partir de esta nueva variable, podemos proceder, por ejemplo, a detectar noticias que contienen ciertos conceptos, y analizar si dicha temática se trata mayormente de forma positiva o negativa. O si está positividad o negatividad varía a través de las distintas fuentes de información, momentos en el tiempo, u otras particularidades del texto.

### Consideraciones

Los resultados siempre van a depender de la calidad de los datos que alimentes al modelo. También es necesario considerar que, debido a que los modelos de lenguaje no son deterministas, los resultados siempre pueden variar. En otras palabras, si analiza el sentimiento de un mismo texto múltiples veces, puede que los resultados sean levemente distintos. Teniendo esto en consideración, es importante ser críticos al momento de recibir resultados de un modelo de lenguaje o de cualquier otra herramienta de inteligencia artificial, y también considerar estos resultados como convenientes intentos de aproximación a la realidad: por un lado, los modelos de lenguaje facilitan muchas tareas, pero por otro, nunca podemos fiarnos 100% de sus resultados, sobre todo cuando estamos tratando con temáticas complejas como son el significado expresado por textos que reflejan facetas complejas de la realidad social y política.

------------------------------------------------------------------------

Si este tutorial te sirvió, por favor considera hacerme una pequeña donación para poder tomarme un cafecito mientras escribo el siguiente tutorial 🥺

<div style = "height: 18px;">
</div>
<div>
  <div style="display: flex;
  justify-content: center;
  align-items: center;">
    <script type="text/javascript" src="https://cdnjs.buymeacoffee.com/1.0.0/button.prod.min.js" data-name="bmc-button" data-slug="bastimapache" data-color="#FFDD00" data-emoji="☕"  data-font="Cookie" data-text="Regálame un cafecito" data-outline-color="#000000" data-font-color="#000000" data-coffee-color="#ffffff" ></script>
  </div>

[^1]: Si tu computador es muy básico (tiene poca memoria RAM), recomiendo instalar Llama 3.2 1B. Si tiene al menos 8GB de memoria, recomiendo Llama 3.2 3B. Si tienes suficiente memoria (más de 8GB), recomiendo Llama 3.1 8B.
