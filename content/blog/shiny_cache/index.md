---
title: Optimiza la velocidad de tus aplicaciones Shiny con bindCache()
author: Bastián Olea Herrera
date: '2025-10-30'
draft: true
slug: []
categories: []
tags:
  - shiny
links:
  - icon: github
    icon_pack: fab
    name: Código
    url: https://gist.github.com/bastianolea/8ea85fa8169b302d2144e05434668c89
---

```
shinyOptions(cache = cachem::cache_disk("./cache"))
```

Puedes combinar la generación de cache con el [testeo de aplicaciones Shiny con `{shinytest2}`](/blog/shiny_validacion/) para automatizar el uso de tu aplicación, con el doble objetivo de probar que cada interacción con tu app para conformar funcione correctamente, y en tanto la app es puesta a prueba, generar un cache de todos los cálculos sin tener que esperar que el usuario realice las interacciones manualmente.

### Recursos

- [Guía oficial de Posit para optimizar aplicaciones Shiny](https://shiny.posit.co/r/articles/improve/caching/)