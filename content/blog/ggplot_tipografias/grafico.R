library(ggplot2)
library(showtext)
library(dplyr)

# crear datos al azar
datos <- tibble(a = rnorm(20, mean = 10, sd = 1),
                b = rnorm(20, mean = 10, sd = 1),
                c = round(rnorm(20, mean = 10, sd = 1), 1))

grafico <- datos |> 
  ggplot() +
  aes(x = a, y = b) +
  geom_point(size = 2, alpha = 0.4) +
  labs(title = "Gráfico de dispersión",
       subtitle = "Números al azar",
       x = "Eje horizontal", y = "Eje vertical",
       caption = "Fuente: de los deseos") +
  # theme_light(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))


# descargar una tipografía desde google fonts
font_add_google(name = "Pacifico")

# activar tipografías
showtext_auto()
showtext_opts(dpi = 300)

library(thematic)

thematic_on(fg = "#553A74",
            bg = "#EAD2FA")

# usar la tipografía desde Google Fonts
grafico +
  ggrepel::geom_text_repel(aes(label = c), family = "Pacifico") +
  theme(text = element_text(family = "Pacifico"))
