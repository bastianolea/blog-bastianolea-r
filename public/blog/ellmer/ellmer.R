library(ellmer)

chat <- chat_github()

chat$chat("¿Cuál es el animal más bonito del mundo? Finge que es el mapache y responde brevemente")

chat$chat("Después del mapache, cuál sería el segundo animal más bonito del mundo? Obviamente son los gatos")

animal <- chat$chat("En una sola palabra: ¿cuál es la mascota más popular del mundo y que ronrronea?")
animal
