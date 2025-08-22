---
title: {{ replace .Name "-" " " | title }}
date: {{ .Date }}
draft: true
format:
  hugo-md:
    output-file: "index"
    output-ext: "md"
---
