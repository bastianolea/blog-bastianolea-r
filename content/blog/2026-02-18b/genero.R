# código para cargar datos del censo, crear funciones que los procesan, hacer una función para visualizar datos, y finalmente usar un loop para generar múltiples gráficos

library(readxl)
library(dplyr)
library(janitor)
library(tidyr)
library(ggplot2)

# setwd("~/Documents/Otros/blog/content/blog/2026-02-18b")

# https://censo2024.ine.gob.cl/resultados/

# función para cargar datos
censo_cargar_genero <- function(archivo = "P5_Genero.xlsx") {
  read_xlsx(archivo, sheet = 2)
}

# función para procesar datos
censo_procesar_genero <- function(genero) {
  
  genero |> 
    row_to_names(3) |> 
    pivot_longer(cols = 4:last_col(),
                 names_to = "genero",
                 values_to = "poblacion") |> 
    select(region = 2, genero, poblacion) |> 
    mutate(poblacion = as.numeric(poblacion)) |> 
    mutate(tipo = case_when(genero %in% c("Masculino", "Femenino") ~ "Binario cis",
                            genero %in% c("No binario", "Transfemenino", "Transmasculino") ~ "Trans",
                            TRUE ~ "Otros")) |> 
    filter(tipo != "Otros") |> 
    filter(!is.na(region))
}

# función para visualizar datos
censo_grafico_genero <- function(genero_long,
                                 filtro = "País",
                                 titulo = "Población nacional según género") {
  genero_long |> 
    filter(region == filtro) |> 
    ggplot(aes(x = genero, y = poblacion, fill = genero)) +
    geom_col(width = 0.5, color = "#EAD2FA") +
    geom_text(aes(label = scales::comma(poblacion)), 
              position = position_dodge(width = 0.9), 
              vjust = -0.5, 
              size = 3) +
    scale_fill_manual(values = c("Femenino" = "#9069C0", 
                                 "Masculino" = "#6974C0", 
                                 "No binario" = "#C46EBA", 
                                 "Transfemenino" = "#9069C0", 
                                 "Transmasculino" = "#6974C0")) +
    scale_y_continuous(labels = scales::comma,
                       expand = expansion(mult = c(0, 0.1))) +
    scale_x_discrete(labels = label_wrap_gen(15)) +
    facet_wrap(~tipo, scales = "free") +
    guides(fill = guide_none()) +
    theme_grey(ink = "#553A74",
               paper = "#EAD2FA",
               accent = "#9069C0") +
    labs(title = paste("Población", ifelse(filtro == "País", "nacional", paste("de", filtro)), "según género"),
         subtitle = "Censo 2024",
         x = "Géneros", y = "Población (a distintas escalas)")
}

# usar las funciones
genero <- censo_cargar_genero()

genero_long <- censo_procesar_genero(genero)

# obtener vector con las regiones
regiones <- unique(genero_long$region)

# hacer un loop para generar un gráfico por cada región
for (region in regiones) {
  message(region)
  
  # generar gráfico para la región   
  censo_grafico_genero(genero_long, filtro = region)
  
  # guardar gráfico como imagen con el nombre de la región
  ggsave(filename = paste0("graficos/", region, ".png"), 
           width = 6, height = 4, dpi = 300)
}
