---
title: Blog sobre éste blog
author: Bastián Olea Herrera
format: hugo-md
date: 2024-11-07
tags:
  - quarto
lang: es
excerpt: >-
  Post explicativo de cómo hice éste sitio web usando el tema Hugo Apéro. Describo los beneficios de Hugo, las dificultades que tuve para entender, y comentarios acerca de la importancia de tener un espacio web fuera de las grandes empresas que monopolizan la internet. La totalidad del código de este sitio web [está disponible en el repositorio `blog-r` en mi GitHub.](https://github.com/bastianolea/blog-r)
links:
- icon: github
  icon_pack: fab
  name: código
  url: https://github.com/bastianolea?tab=repositories
---

Éste es un post sobre este mismo blog. Quería compartir el proceso de creación de éste blog.

Lo creé usando [Hugo](https://gohugo.io), un generador de sitios web estáticos de código abierto y gratuito. Hugo se puede usar a través de R usando `{blogdown}` y el tema [Hugo Apéro](https://hugo-apero.netlify.app), creado por [Alison Hill](https://www.apreshill.com), y así puedes crear páginas y publicaciones usando Quarto o RMarkdown. De ese modo resulta muy fácil integrar las cosas que hagas con R en tu sitio, compartiendo el código en los posts. 

La [guía para aprender a usar Hugo Apéro](https://hugo-apero-docs.netlify.app) y dejar tu blog operacional es muy amigable y sencilla de seguir! Lo recomiendo, solo me tomó una tarde. Tiene amplia documentación y recursos [en su repositorio.](https://github.com/hugo-apero/)

El sitio web se genera con `{blogdown}` dentro de un proyecto de R cada vez que hago un cambio en el código del sitio. Luego, cuando subo los cambios del sitio a GitHub, [Netlifly](https://www.netlify.com) detecta los cambios, reconstruye el sitio y lo re-publica en minutos. De esta forma, el proceso es de _despliegue continuo:_ cada cambio local que hago, al ser subido al [repositorio remoto,](https://github.com/bastianolea/blog-r) gatilla la reconstrucción del sitio y su actualización en la versión pública del sitio web.

La totalidad del código de este sitio web [está disponible en el repositorio `blog-r` en mi GitHub.](https://github.com/bastianolea/blog-r)


## Sobre Hugo Apéro

Las [instrucciones de Hugo Apéro](https://hugo-apero-docs.netlify.app/start/) me parecieron fáciles de seguir, lo suficientemente sencillas para que cualquier persona sin experiencia en sitios web (yo) pueda seguirlas. Además, te prsentan [ejemplos hermosos](https://hugo-apero-docs.netlify.app/project/) de otros blogs que usan el tema. 

_Lo bueno:_
- Muy simple de usar
- Resultados agradables y profesionales con nada de código
- Todo es 100% gratuito: el generador del sitio (Hugo), la IDE donde hago el sitio (RStudio), el lenguaje que uso para construir el sitio (R), el hosting (Netlify), y el dominio (Rbind).

_Lo malo_
- Poca flexibilidad
- No encuentro recursos para personalizar detalles
- Difícil de encontrar respuestas en internet

Algunas dificultades que tuve con el procedimiento, y cómo las resolví:

- **Crear nuevas secciones**
  - El blog viene con secciones por defecto (_blog, talks, about, projects_), y me costó un poco entender [cómo crear nuevas o cambiarles el nombre](https://hugo-apero-docs.netlify.app/start/section-config/#renaming-sections) a las existentes.
  - Luego entendí que las carpetas dentro de `content/` se vuelven en secciones si las llamas desde el archivo de configuración `config.yoml`, y que adquieren una apariencia por defecto, pero puedes camibiarla en el _front matter_ de cada una (el archivo `_index.md` dentro de `content/blog`, por ejemplo).

- **Carpeta static**
  - Carpeta con los elementos estáticos que se copian a public y que van a estar disponibles para el resto del sitio, como algunas imágenes

- **Carpeta public**
  - Al principio no entendía por qué tenía todo duplicado, pero luego entendí que `public` es una carpeta que se genera cada vez que actualizas el sitio, y su objetivo es ser literalmente el sitio al cual van a acceder las personas por su navegador web. Pero a esta carpeta sólo se le agregan cosas, no se eliminan, así que si subiste algo por error tienes que borrarlo manualmente de `public` (por ejemplo, yo subí una carpeta con 30 imágenes siendo que solo estaba usando una)
  - Es seguro borrar todo el contenido de public, porque al guardar un cambio en tu sitio se re-escribe toda esta carpeta desde cero. Así evitas que queden recursos innecesarios en el sitio.

- **Redirects**
  - Las redirecciones sirven para que, luego de que consigas una nueva url para tu sitio `*.netlify.app`, puedas hacer que la gente que entre a la dirección `*.netlify.app` sea redireccionada automáticamente a tu nueva url. En mi caso, resirigí desde [bastianoleah.netlify.app](bastianoleah.netlify.app) a [https://bastianolea.rbind.io](https://bastianolea.rbind.io). El dominio que usé para este sitio, _rbind.io_, es un [servicio de la comunidad R](https://support.rbind.io/about/) de "unir" blogs y sitios webs de usuarios/as de R, y puedes pedir en su repositorio que te cedan un subdominio para que lo uses para tu blog.
  - Es muy fácil [especificar redirecciones](https://yihui.org/en/2017/11/301-redirect/#another-application-redirect-netlify-com-to-your-own-domain) creando un archivo llamado `_redirects` en `static`: link original y redirección.
  - Así evitas que los usuarios entren sin `https` a tu sitio, y que si entran a una url interna o antigua se les lleve a la url nueva.
  
- **Quarto documents en tu blog**
  - Para crear un post a partir de un documento Quarto, solamente tienes que poner en el `yaml` del documento quarto `format: hugo-md`. De este modo, el documento se va a renderizar en formato markdown, y si se llama `index.md`, va a aparecer como un post.
  - Usar Quarto te permite usar `{shiny}` para construir HTML para tu sitio (por ejemplo, usando `div()` y otras funciones de Shiny).
  - En los chunks donde uses Shiny debes ponerles `#| output: asis` para que su resultado salga como HTML y se vea en el sitio.

Igual me quedaron algunas cosas pendientes que no he sabido resolver 😞 
- Traducir fechas y otros textos, no encontré cómo cambiarlo 🙁 


## Conclusiones

Quizás voy a escribir un tutorial más detallado sobre cómo hacer un blog.

Creo que es importante tener un espacio en la web que sea realmente propio, sobre todo considerando que vivimos una época en que casi la totalidad de nuestra presencia online está a merced de grandes empresas (Meta con Instagram y Facebook, Microsoft con LinkedIn, Google con todo lo demás), que además operan en esquemas de mercantilización de nuestros datos. Un sitio web personal perdurará las decisiones o quiebres de las empresas en las que actualmente confiamos, y además nos permite volver un poco a la antigua web, donde las personas eran las dueñas del contenido, sin tener que conectar todo a trackers y plataformas privadas.

