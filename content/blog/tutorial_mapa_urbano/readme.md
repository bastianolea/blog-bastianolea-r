## Tutorial: Graficar datos comunales sobre un mapa de la Región Metropolitana de Chile

Este tutorial de R te explicará paso a paso a cómo obtener mapas de todo Chile usando el paquete [`{chilemapas}` desarrollado por Mauricio Vargas](https://github.com/pachadotdev/chilemapas), y hacer gráficos con estos mapas usando `{ggplot2}`.

En la primera parte veremos cómo **obtener los mapas** y cómo **visualizar datos comunales** usando mapas en R.

Luego, nos enfrentaremos a un problema común que se tiene al graficar un mapa de la Región Metropolitana de Santiago, que tiene que ver con la diferencia entre los límites comunales reales de cada comuna y los **límites urbanos** de las comunas. Es la diferencia entre tener un mapa de la RM que abarque sectores rurales como Paine y que llegue hasta Argentina, o un mapa que demarque la zona urbana de Santiago, aproximadamente correspondiente a la zona que atravieza el anillo Vespucio.

Graficando un mapa de la superficie urbana de la Región Metropolitana, obtenemos una figura que es más familiar al habitante promedio de la RM, y que es la que usalmente vemos en la cotidianeidad, en contraste con un mapa geográficamente correcto de todo el territorio abarcado por la región.

Accede al tutorial en este enlace: [Tutorial: Mapa de la zona urbana de la Región Metropolitana de Santiago (o Gran Santiago) en R](https://rpubs.com/bastimapache/mapa_urbano_rm)

![Mapa urbano de la RM en R](tutorial_mapa_urbano_rm_files/figure-html/region_urbana_fill_continuo-1.png)