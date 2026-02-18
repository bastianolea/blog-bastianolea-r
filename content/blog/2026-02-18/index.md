---
title: Crea árboles de las carpetas de tus proyectos con `{printtree}` en R
author: Bastián Olea Herrera
date: '2026-02-18'
slug: []
categories: []
tags:
  - consejos
format:
  hugo-md:
    output-file: index
    output-ext: md
excerpt: "Este paquete crea árboles de las carpetas de tus proyectos, que sirven para tener una visión general de la estructura de tus proyectos. Esto puede ser útil de incluir en informes, reportes o documentación de proyectos en los que trabajes, para dejar por escrito la estructura del proyecto."
---


Recientemente **[Estación R](https://www.linkedin.com/company/estacion-r/)** compartió su [paquete del día](https://www.linkedin.com/posts/estacion-r_rstats-rstatses-rtips-activity-7429863625126977536-Sqng) y lo encontré útil.

<div style="width: 100%; text-align: center;">
<iframe src="https://www.linkedin.com/embed/feed/update/urn:li:share:7429863623935684608" height="1063" width="504" frameborder="0" allowfullscreen="" title="Publicación integrada"></iframe>
</div>

Como dice el post, `{printtree}` crea árboles de las carpetas de tus proyectos, lo que es muy útil para tener una visión general de la estructura de tus proyectos. Esto puede ser útil de incluir en **informes, reportes o documentación** de proyectos en los que trabajes, para **dejar por escrito la estructura del proyecto** y así poder comentar sobre ella para lectores.

Por ejemplo, aquí genero un árbol de la estructura de un proyecto laboral, que sirve para indicar en el informe de entrega la forma en que se guardan los datos originales y los resultados:

```r
printtree::print_rtree(format = "unicode", max_depth = 2)
```

```
indice_brechas_genero/
├── indice_brechas_genero.Rproj
├── app/
│   └── ibg/
├── datos/
│   ├── censo_edad/
│   ├── censo_educacion/
│   ├── censo_poblacion/
│   ├── clasificacion_pndr/
│   ├── conadi_indigena/
│   ├── cultura_agentes/
│   ├── cultura_bibliotecas/
│   ├── cultura_fondos/
│   ├── cut_comunas/
│   ├── fosis_beneficiarios/
│   ├── integra/
│   ├── junji_mineduc/
│   ├── mideso_educacion/
│   ├── mideso_ingresos/
│   ├── mideso_ocupacion/
│   ├── mideso_salud/
│   ├── mineduc_etp/
│   ├── mineduc_paes/
│   ├── mineduc_rendimiento/
│   ├── mineduc_simce/
│   ├── minsal_egresos/
│   ├── minsal_rem/
│   ├── minsal_urgencias/
│   ├── prodesal_agropecuario/
│   ├── rsh_hogares/
│   ├── senadis_mideso/
│   ├── sercotec_beneficiarios/
│   ├── servel_concejales/
│   ├── servel_partidos/
│   ├── sinim_municipios/
│   ├── sp_pensiones/
│   └── transparencia_usarios/
├── resultados/
│   ├── comunas/
│   ├── regiones/
│   ├── diccionario.parquet
│   ├── dimensiones.parquet
│   ├── icbg_regional.parquet
│   ├── icbg_regional.xlsx
│   ├── icbg.parquet
│   ├── icbg.xlsx
│   ├── indice_brechas_genero_subdere.xlsx
│   ├── interpretacion.parquet
│   └── portada.xlsx
├── funciones.R
├── pendientes.md
├── procesar_regiones.R
├── procesar.R
├── pruebas.R
└── readme.md
```

Opcionalmente se puede guardar como una imagen agregando el argumento `snapshot = TRUE`.