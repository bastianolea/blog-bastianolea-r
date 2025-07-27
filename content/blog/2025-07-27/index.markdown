---
title: Descargar todos los archivos de la página web del Censo 2024 con {rvest}
author: Bastián Olea Herrera
date: '2025-07-27'
slug: []
categories: []
tags:
  - datos
  - Chile
  - automatización
  - loops
  - purrr
  - web scraping
links:
- icon: github
  icon_pack: fab
  name: código
  url: https://github.com/bastianolea/censo_2024
- excerpt: "Éste es un mini ejemplo de automatización de tareas con R: los resultados del Censo 2024 vienen en 20 archivos, en 20 enlaces distintos! En un script de R, con `{rvest}` extraemos todos los enlaces del sitio, y con `{purrr}` descargamos todos los archivos de una."
---



Veamos un mini ejemplo de automatización de tareas con R: los resultados del Censo 2024 vienen en 20 archivos, en 20 enlaces distintos! 

¿El problema? para obtenerlos, tendríamos que entrar al sitio con el navegador, ir al enlace de descargas, bajar cada uno de los 20 archivos manualmente, y guardarlos en una carpeta para poder usarlos.

En un script de R, con `{rvest}` extraemos todos los enlaces del sitio, y con `{purrr}` descargamos todos los archivos de una 🚀

Beneficios? Muchos!
- No tendrás que apretar 20 veces un botón como un perdedor/a 😎
- Obtendrás una fuente reproducible de los datos originales 🤓
- Creaste trazabilidad de los datos (nadie puede alegar que son manipulados) 🕵🏻‍♀️
- Puedes actualizarlos o volver a descargarlos en otro equipo con un clic
- Creaste un proceso que puedes aplicar a otros sitios!
- Fastidiaste a la gente del INE descargando 20 archivos en menos de 1 segundo 😣

Lo primero obtener el código fuente de la página y extraer los en enlaces que están en cada botón con [web scraping](https://bastianolea.rbind.io/blog/r_introduccion/web_scraping/). Puedes aprender cómo extraer elementos de una página web con [este tutorial de web scraping](https://bastianolea.rbind.io/blog/tutorial_scraping_rvest/) o viendo [este taller donde lo explico en un video](https://bastianolea.rbind.io/blog/taller_corrupcion_cesi/).



``` r
enlace <- "https://censo2024.ine.gob.cl/estadisticas/"

# extraer enlaces de descarga
enlaces <- rvest::read_html(enlace) |> # descargar sitio
  rvest::html_elements(".fusion-button") |> # botones
  rvest::html_attr("href") |> # enlaces
  stringr::str_subset("xls") # sólo excel

enlaces
```

```
##  [1] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/06/P1-Discapacidad.xlsx"                                            
##  [2] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/06/P2-Pueblos-indigenas.xlsx"                                       
##  [3] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/06/P3_Lenguas-indigenas.xlsx"                                       
##  [4] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/06/P4-Afrodescendencia.xlsx"                                        
##  [5] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/06/P5_Genero.xlsx"                                                  
##  [6] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/06/P6_Religion-o-credo.xlsx"                                        
##  [7] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/06/P7_Educacion.xlsx"                                               
##  [8] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/06/P8-Escolaridad-poblacion-inmigrante-internacional.xlsx"          
##  [9] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/05/V2_Caracteristicas-vivienda-y-viv-irrecuperables.xlsx"           
## [10] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/05/V3_N-de-dormitorios-hacinamiento-y-viv-con-mas-de-un-hogar.xlsx" 
## [11] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/05/V4_Servicios_basicos_de_la_vivienda.xlsx"                        
## [12] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/05/H1_Servicios-basicos-hogar-y-tenencia-vivienda.xlsx"             
## [13] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/05/V5_Tipologias-de-viviendas-censadas.xlsx"                        
## [14] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/04/D5_Migracion-interna.xlsx"                                       
## [15] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/04/D4_Inmigracion-Internacional.xlsx"                               
## [16] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/04/D6_Fecundidad.xlsx"                                              
## [17] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/03/D1_Poblacion-censada-por-sexo-y-edad-en-grupos-quinquenales.xlsx"
## [18] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/03/D2_Indice-de-envejecimiento-por-sexo.xlsx"                       
## [19] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/03/D3_Poblacion-censada-por-tipo-de-operativo.xlsx"                 
## [20] "https://censo2024.ine.gob.cl/wp-content/uploads/2025/03/V1_Viviendas-y-hogares-censados.xlsx"
```



Obtuvimos todos los enlaces que están en la página! Ahora usaremos [un poco de magia (`regex`) con `{stringr}`](/blog/stringr_texto/) para que solamente queden los enlaces que apuntan a archivos Excel:



``` r
# extraer nombres de archivos
archivos <- stringr::str_extract(enlaces, "(?<=\\d{2}/\\d{2}/).*")

archivos
```

```
##  [1] "P1-Discapacidad.xlsx"                                            
##  [2] "P2-Pueblos-indigenas.xlsx"                                       
##  [3] "P3_Lenguas-indigenas.xlsx"                                       
##  [4] "P4-Afrodescendencia.xlsx"                                        
##  [5] "P5_Genero.xlsx"                                                  
##  [6] "P6_Religion-o-credo.xlsx"                                        
##  [7] "P7_Educacion.xlsx"                                               
##  [8] "P8-Escolaridad-poblacion-inmigrante-internacional.xlsx"          
##  [9] "V2_Caracteristicas-vivienda-y-viv-irrecuperables.xlsx"           
## [10] "V3_N-de-dormitorios-hacinamiento-y-viv-con-mas-de-un-hogar.xlsx" 
## [11] "V4_Servicios_basicos_de_la_vivienda.xlsx"                        
## [12] "H1_Servicios-basicos-hogar-y-tenencia-vivienda.xlsx"             
## [13] "V5_Tipologias-de-viviendas-censadas.xlsx"                        
## [14] "D5_Migracion-interna.xlsx"                                       
## [15] "D4_Inmigracion-Internacional.xlsx"                               
## [16] "D6_Fecundidad.xlsx"                                              
## [17] "D1_Poblacion-censada-por-sexo-y-edad-en-grupos-quinquenales.xlsx"
## [18] "D2_Indice-de-envejecimiento-por-sexo.xlsx"                       
## [19] "D3_Poblacion-censada-por-tipo-de-operativo.xlsx"                 
## [20] "V1_Viviendas-y-hogares-censados.xlsx"
```



Finalmente, [creamos un loop](/blog/r_introduccion/r_intermedio/#bucles) que vaya por cada uno de los enlaces, descargue cada uno de los archivos, y le ponga el nombre al archivo correspondiente:



``` r
# crear carpeta
dir.create("datos/originales", showWarnings = F) 

# por cada posición de los enlaces (x va del 1 al n)
seq_along(enlaces) |> 
  purrr::walk(
    ~{message("descargando ", enlaces[.x]) # enlace correspondiente a x
      
      # descargar archivo en el enlace
      download.file(enlaces[.x],
                    # nombre del archivo a guardar
                    destfile = paste0("datos/originales/", 
                                      archivos[.x]) # nombre de archivo de x
      )
      Sys.sleep(1) # espera post-descarga
    })
```



<div style="margin:auto; max-width:70%;">
<video src="r_grabacion.mov" style="border-radius:7px; max-width: 100%; margin:auto;" autoplay loop>
</video>
</div>

Con este breve script obtuviste un proceso que te permite descargar automáticamente todos los datos, lo cual es una forma certera de crear una trazabilidad y una fuente real de los datos, además de darte un proceso que puedes volver a utilizar en otros sitios para optimizar tu trabajo!

Puedes encontrar el código de este ejemplo (y los datos) en [este repositorio sobre extracción y limpieza de los datos del Censo 2024.](https://github.com/bastianolea/censo_2024)
