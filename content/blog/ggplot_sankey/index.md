---
title: Gráficos aluviales o diagramas _Sankey_ en `{ggplot2}`
author: Bastián Olea Herrera
date: '2026-02-13'
slug: []
draft: true
categories: []
tags:
  - visualización de datos
  - gráficos
format:
  hugo-md:
    output-file: index
    output-ext: md
---


``` r
tibble::tribble(
  ~tipologia, ~modelo,    ~n,
          1,     "A", 2017,
          1,     "B", 2049,
          2,     "A",  518,
          2,     "B", 1281,
          2,     "C",  351,
          2,     "D",  119,
          3,     "B",   96,
          3,     "C", 1153,
          3,     "D",  690,
          4,     "B",  124,
          4,     "C", 1072,
          4,     "D",  563,
          5,     "B",   14,
          5,     "C",  279,
          5,     "D", 1250
  )
```

``` r
 datos |> 
    mutate(tipologia = as.factor(tipologia),
           modelo = as.factor(modelo)) |>
    ggplot(aes(axis1 = tipologia, axis2 = modelo, y = n)) +
    geom_flow(aes(fill = tipologia, color = tipologia),
              knot.pos = 0.2,
              width = .3) +
    # geom_alluvium(aes(fill = tipologia, color = tipologia)) +
    geom_stratum(width = .3, linewidth = .4, color = "grey20", alpha = 0.8) +
    # geom_label(stat = "stratum", aes(label = after_stat(stratum),
    #                                  fill = tipologia),
    #           fontface = "bold", color = "white", size = 4) +
    geom_text(stat = "stratum", aes(label = after_stat(stratum)),
              fontface = "bold", size = 4) +
    scale_x_discrete(limits = c("tipologia", "modelo"), 
                     labels = c("Figem", renombrar_modelo(.modelo)), 
                     expand = c(.05, .05)) +
    scale_y_continuous(breaks = NULL, expand = c(0.01, 0)) +
    theme_minimal() +
    theme(axis.text.x = element_text(size = 12, face = "bold"),
          panel.grid = element_blank()) +
    labs(title = "Cambios en la tipología de comunas",
         subtitle = paste("Flujo entre postulantes, desde tipología original\nhacia tipología del modelo", .modelo),
         x = "Flujo entre tipologías",
         y = "Número de postulantes",
         fill = "Tipología\noriginal",
         color = "Tipología\noriginal")
```
