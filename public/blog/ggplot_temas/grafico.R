library(dplyr)

# crear datos al azar
datos <- tibble(a = 1:10,
                b = rnorm(10, mean = 7, sd = 2)
)

library(ggplot2)

grafico <- datos |> 
  ggplot() +
  aes(x = as.factor(a), y = b) +
  geom_col(width = 0.5) +
  geom_text(aes(label = round(b, 0), y = b + 0.6), 
            size = 3, fontface = "bold")

grafico <- grafico +
  labs(title = "Gráfico de barras",
       subtitle = "Números al azar",
       x = "Eje horizontal", y = "Eje vertical",
       caption = "Fuente: de los deseos") +
  scale_y_continuous(expand = expansion(c(0, 0.05))) +
  theme(plot.title = element_text(face = "bold"),
        panel.grid.minor.y = element_line(linetype = 2, linewidth = .5),
        axis.ticks.x = element_blank())

library(thematic)

thematic_on(fg = "#553A74",
            bg = "#EAD2FA")

grafico