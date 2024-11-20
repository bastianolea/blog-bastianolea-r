---
title: Análisis de sentimiento usando modelos de lenguaje (LLM) en R
author: Bastián Olea Herrera
date: '2024-11-18'
slug: []
categories: []
format: hugo-md
draft: true
tags:
  - análisis de texto
  - inteligencia artificial
---


El análisis de sentimientos es una técnica de análisis de texto que aplica distintos algoritmos para poder clasificar textos de distinta longitud y complejidad en un conjunto preestablecido de categorías relacionadas al sentimiento de dichos textos. Con el sentimiento de los textos nos referimos a la información subjetiva que entregan estos textos, así como los afectos que producen. Las categorías del análisis del sentimiento suelen ser positivo, neutro y negativo, u otras más complejas, como agrado (agradable/desagradable), activación (activo/pasivo), y otros.

En otras palabras, la aplicación de un análisis de sentimiento un conjunto de textos nos permitiría clasificar estos textos en categorías como positivo, neutro y negativo, y a partir de eso poder realizar otros análisis.

Algunos ejemplos son:
- Correlacionar si los textos de distintos autores difieren en sus sentimientos,
- Analizar si textos sobre determinadas temáticas se correlacionan con sentimientos específicos,
- Estudiar si ciertos temas son tratados de una forma específica por ciertos autores, y de una forma distinta por otros
- Comparar si textos sobre un mismo tema son expuestos de forma distinta por distintos autores o fuentes

Por ejemplo, tenemos un conjunto de Artículos de prensa o noticias, cada uno con fecha y el medio de comunicación del que proviene. Si hacemos una selección de noticias sobre un tema específico, podríamos analizar cómo cambia el sentimiento dominante con el que se plantea la temática en distintos momentos del tiempo, o si dos medios de comunicación representan recurrentemente una misma temática bajo distinto sentimiento.
