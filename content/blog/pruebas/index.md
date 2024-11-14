---
title: Prueba
author: Bastián Olea Herrera
date: '2024-11-13'
slug: []
categories: []
draft: true
tags:
  - consejos
  - procesamiento de datos
  - lubridate
---

<details {{ .Scratch.Get "details" }} class="f6 fw7 input-reset">
{{ with .Params.tags }}
  <dl class="f6 lh-copy">
    <dt class="fw7">Tags:</dt>
    <dd class="fw5 ml0">{{ range . }} <a href="{{ "tags/" | absURL }}{{ . | urlize }}">{{ . }}</a> {{ end }}</dd>
  </dl>
</details>
  
Hola