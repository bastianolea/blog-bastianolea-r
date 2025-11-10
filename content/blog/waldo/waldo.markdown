---
title: Encuentra diferencias entre objetos de R con {waldo}
author: Bastián Olea Herrera
date: '2025-08-12'
draft: true
format:
  hugo-md:
    output-file: "index"
    output-ext: "md"
slug: []
categories: []
tags:
  - limpieza de datos
  - consejos
---

https://waldo.r-lib.org

| hola |
|------|
| chao |

``` r
iris |> gt::gt()
```

<div id="gqjwhlhxzg" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#gqjwhlhxzg table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#gqjwhlhxzg thead, #gqjwhlhxzg tbody, #gqjwhlhxzg tfoot, #gqjwhlhxzg tr, #gqjwhlhxzg td, #gqjwhlhxzg th {
  border-style: none;
}
&#10;#gqjwhlhxzg p {
  margin: 0;
  padding: 0;
}
&#10;#gqjwhlhxzg .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#gqjwhlhxzg .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#gqjwhlhxzg .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#gqjwhlhxzg .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#gqjwhlhxzg .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#gqjwhlhxzg .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#gqjwhlhxzg .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#gqjwhlhxzg .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#gqjwhlhxzg .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#gqjwhlhxzg .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#gqjwhlhxzg .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#gqjwhlhxzg .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#gqjwhlhxzg .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#gqjwhlhxzg .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#gqjwhlhxzg .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#gqjwhlhxzg .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#gqjwhlhxzg .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#gqjwhlhxzg .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#gqjwhlhxzg .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#gqjwhlhxzg .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#gqjwhlhxzg .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#gqjwhlhxzg .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#gqjwhlhxzg .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#gqjwhlhxzg .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#gqjwhlhxzg .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#gqjwhlhxzg .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#gqjwhlhxzg .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#gqjwhlhxzg .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#gqjwhlhxzg .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#gqjwhlhxzg .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#gqjwhlhxzg .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#gqjwhlhxzg .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#gqjwhlhxzg .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#gqjwhlhxzg .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#gqjwhlhxzg .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#gqjwhlhxzg .gt_left {
  text-align: left;
}
&#10;#gqjwhlhxzg .gt_center {
  text-align: center;
}
&#10;#gqjwhlhxzg .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#gqjwhlhxzg .gt_font_normal {
  font-weight: normal;
}
&#10;#gqjwhlhxzg .gt_font_bold {
  font-weight: bold;
}
&#10;#gqjwhlhxzg .gt_font_italic {
  font-style: italic;
}
&#10;#gqjwhlhxzg .gt_super {
  font-size: 65%;
}
&#10;#gqjwhlhxzg .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#gqjwhlhxzg .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#gqjwhlhxzg .gt_indent_1 {
  text-indent: 5px;
}
&#10;#gqjwhlhxzg .gt_indent_2 {
  text-indent: 10px;
}
&#10;#gqjwhlhxzg .gt_indent_3 {
  text-indent: 15px;
}
&#10;#gqjwhlhxzg .gt_indent_4 {
  text-indent: 20px;
}
&#10;#gqjwhlhxzg .gt_indent_5 {
  text-indent: 25px;
}
&#10;#gqjwhlhxzg .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#gqjwhlhxzg div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Sepal.Length">Sepal.Length</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Sepal.Width">Sepal.Width</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Petal.Length">Petal.Length</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Petal.Width">Petal.Width</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="Species">Species</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.1</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.5</td>
<td headers="Petal.Length" class="gt_row gt_right">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.9</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right">1.3</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.6</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.0</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.6</td>
<td headers="Petal.Length" class="gt_row gt_right">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.4</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.9</td>
<td headers="Petal.Length" class="gt_row gt_right">1.7</td>
<td headers="Petal.Width" class="gt_row gt_right">0.4</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.6</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right">0.3</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.0</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.4</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.9</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right">0.1</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.4</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.7</td>
<td headers="Petal.Length" class="gt_row gt_right">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.8</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right">1.6</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.8</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right">0.1</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.3</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">1.1</td>
<td headers="Petal.Width" class="gt_row gt_right">0.1</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.8</td>
<td headers="Sepal.Width" class="gt_row gt_right">4.0</td>
<td headers="Petal.Length" class="gt_row gt_right">1.2</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">4.4</td>
<td headers="Petal.Length" class="gt_row gt_right">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right">0.4</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.4</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.9</td>
<td headers="Petal.Length" class="gt_row gt_right">1.3</td>
<td headers="Petal.Width" class="gt_row gt_right">0.4</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.1</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.5</td>
<td headers="Petal.Length" class="gt_row gt_right">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right">0.3</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.8</td>
<td headers="Petal.Length" class="gt_row gt_right">1.7</td>
<td headers="Petal.Width" class="gt_row gt_right">0.3</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.1</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.8</td>
<td headers="Petal.Length" class="gt_row gt_right">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right">0.3</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.4</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right">1.7</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.1</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.7</td>
<td headers="Petal.Length" class="gt_row gt_right">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right">0.4</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.6</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.6</td>
<td headers="Petal.Length" class="gt_row gt_right">1.0</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.1</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.3</td>
<td headers="Petal.Length" class="gt_row gt_right">1.7</td>
<td headers="Petal.Width" class="gt_row gt_right">0.5</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.8</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right">1.9</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.0</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">1.6</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.0</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right">1.6</td>
<td headers="Petal.Width" class="gt_row gt_right">0.4</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.2</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.5</td>
<td headers="Petal.Length" class="gt_row gt_right">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.2</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right">1.6</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.8</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right">1.6</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.4</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right">0.4</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.2</td>
<td headers="Sepal.Width" class="gt_row gt_right">4.1</td>
<td headers="Petal.Length" class="gt_row gt_right">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right">0.1</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.5</td>
<td headers="Sepal.Width" class="gt_row gt_right">4.2</td>
<td headers="Petal.Length" class="gt_row gt_right">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.9</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.0</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right">1.2</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.5</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.5</td>
<td headers="Petal.Length" class="gt_row gt_right">1.3</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.9</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.6</td>
<td headers="Petal.Length" class="gt_row gt_right">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right">0.1</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.4</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">1.3</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.1</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.0</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.5</td>
<td headers="Petal.Length" class="gt_row gt_right">1.3</td>
<td headers="Petal.Width" class="gt_row gt_right">0.3</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.5</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.3</td>
<td headers="Petal.Length" class="gt_row gt_right">1.3</td>
<td headers="Petal.Width" class="gt_row gt_right">0.3</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.4</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right">1.3</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.0</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.5</td>
<td headers="Petal.Length" class="gt_row gt_right">1.6</td>
<td headers="Petal.Width" class="gt_row gt_right">0.6</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.1</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.8</td>
<td headers="Petal.Length" class="gt_row gt_right">1.9</td>
<td headers="Petal.Width" class="gt_row gt_right">0.4</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.8</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right">0.3</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.1</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.8</td>
<td headers="Petal.Length" class="gt_row gt_right">1.6</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.6</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.3</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.7</td>
<td headers="Petal.Length" class="gt_row gt_right">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.0</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.3</td>
<td headers="Petal.Length" class="gt_row gt_right">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right">0.2</td>
<td headers="Species" class="gt_row gt_center">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">7.0</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right">4.7</td>
<td headers="Petal.Width" class="gt_row gt_right">1.4</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.4</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right">4.5</td>
<td headers="Petal.Width" class="gt_row gt_right">1.5</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.9</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right">4.9</td>
<td headers="Petal.Width" class="gt_row gt_right">1.5</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.5</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.3</td>
<td headers="Petal.Length" class="gt_row gt_right">4.0</td>
<td headers="Petal.Width" class="gt_row gt_right">1.3</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.5</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right">4.6</td>
<td headers="Petal.Width" class="gt_row gt_right">1.5</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right">4.5</td>
<td headers="Petal.Width" class="gt_row gt_right">1.3</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.3</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.3</td>
<td headers="Petal.Length" class="gt_row gt_right">4.7</td>
<td headers="Petal.Width" class="gt_row gt_right">1.6</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.9</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.4</td>
<td headers="Petal.Length" class="gt_row gt_right">3.3</td>
<td headers="Petal.Width" class="gt_row gt_right">1.0</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.6</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right">4.6</td>
<td headers="Petal.Width" class="gt_row gt_right">1.3</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.2</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.7</td>
<td headers="Petal.Length" class="gt_row gt_right">3.9</td>
<td headers="Petal.Width" class="gt_row gt_right">1.4</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.0</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.0</td>
<td headers="Petal.Length" class="gt_row gt_right">3.5</td>
<td headers="Petal.Width" class="gt_row gt_right">1.0</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.9</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">4.2</td>
<td headers="Petal.Width" class="gt_row gt_right">1.5</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.0</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.2</td>
<td headers="Petal.Length" class="gt_row gt_right">4.0</td>
<td headers="Petal.Width" class="gt_row gt_right">1.0</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.1</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right">4.7</td>
<td headers="Petal.Width" class="gt_row gt_right">1.4</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.6</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right">3.6</td>
<td headers="Petal.Width" class="gt_row gt_right">1.3</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right">4.4</td>
<td headers="Petal.Width" class="gt_row gt_right">1.4</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.6</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">4.5</td>
<td headers="Petal.Width" class="gt_row gt_right">1.5</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.8</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.7</td>
<td headers="Petal.Length" class="gt_row gt_right">4.1</td>
<td headers="Petal.Width" class="gt_row gt_right">1.0</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.2</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.2</td>
<td headers="Petal.Length" class="gt_row gt_right">4.5</td>
<td headers="Petal.Width" class="gt_row gt_right">1.5</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.6</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.5</td>
<td headers="Petal.Length" class="gt_row gt_right">3.9</td>
<td headers="Petal.Width" class="gt_row gt_right">1.1</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.9</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right">4.8</td>
<td headers="Petal.Width" class="gt_row gt_right">1.8</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.1</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right">4.0</td>
<td headers="Petal.Width" class="gt_row gt_right">1.3</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.3</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.5</td>
<td headers="Petal.Length" class="gt_row gt_right">4.9</td>
<td headers="Petal.Width" class="gt_row gt_right">1.5</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.1</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right">4.7</td>
<td headers="Petal.Width" class="gt_row gt_right">1.2</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.4</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right">4.3</td>
<td headers="Petal.Width" class="gt_row gt_right">1.3</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.6</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">4.4</td>
<td headers="Petal.Width" class="gt_row gt_right">1.4</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.8</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right">4.8</td>
<td headers="Petal.Width" class="gt_row gt_right">1.4</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">5.0</td>
<td headers="Petal.Width" class="gt_row gt_right">1.7</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.0</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right">4.5</td>
<td headers="Petal.Width" class="gt_row gt_right">1.5</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.6</td>
<td headers="Petal.Length" class="gt_row gt_right">3.5</td>
<td headers="Petal.Width" class="gt_row gt_right">1.0</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.5</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.4</td>
<td headers="Petal.Length" class="gt_row gt_right">3.8</td>
<td headers="Petal.Width" class="gt_row gt_right">1.1</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.5</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.4</td>
<td headers="Petal.Length" class="gt_row gt_right">3.7</td>
<td headers="Petal.Width" class="gt_row gt_right">1.0</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.8</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.7</td>
<td headers="Petal.Length" class="gt_row gt_right">3.9</td>
<td headers="Petal.Width" class="gt_row gt_right">1.2</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.0</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.7</td>
<td headers="Petal.Length" class="gt_row gt_right">5.1</td>
<td headers="Petal.Width" class="gt_row gt_right">1.6</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.4</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">4.5</td>
<td headers="Petal.Width" class="gt_row gt_right">1.5</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.0</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right">4.5</td>
<td headers="Petal.Width" class="gt_row gt_right">1.6</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right">4.7</td>
<td headers="Petal.Width" class="gt_row gt_right">1.5</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.3</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.3</td>
<td headers="Petal.Length" class="gt_row gt_right">4.4</td>
<td headers="Petal.Width" class="gt_row gt_right">1.3</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.6</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">4.1</td>
<td headers="Petal.Width" class="gt_row gt_right">1.3</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.5</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.5</td>
<td headers="Petal.Length" class="gt_row gt_right">4.0</td>
<td headers="Petal.Width" class="gt_row gt_right">1.3</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.5</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.6</td>
<td headers="Petal.Length" class="gt_row gt_right">4.4</td>
<td headers="Petal.Width" class="gt_row gt_right">1.2</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.1</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">4.6</td>
<td headers="Petal.Width" class="gt_row gt_right">1.4</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.8</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.6</td>
<td headers="Petal.Length" class="gt_row gt_right">4.0</td>
<td headers="Petal.Width" class="gt_row gt_right">1.2</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.0</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.3</td>
<td headers="Petal.Length" class="gt_row gt_right">3.3</td>
<td headers="Petal.Width" class="gt_row gt_right">1.0</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.6</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.7</td>
<td headers="Petal.Length" class="gt_row gt_right">4.2</td>
<td headers="Petal.Width" class="gt_row gt_right">1.3</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">4.2</td>
<td headers="Petal.Width" class="gt_row gt_right">1.2</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right">4.2</td>
<td headers="Petal.Width" class="gt_row gt_right">1.3</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.2</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right">4.3</td>
<td headers="Petal.Width" class="gt_row gt_right">1.3</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.1</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.5</td>
<td headers="Petal.Length" class="gt_row gt_right">3.0</td>
<td headers="Petal.Width" class="gt_row gt_right">1.1</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right">4.1</td>
<td headers="Petal.Width" class="gt_row gt_right">1.3</td>
<td headers="Species" class="gt_row gt_center">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.3</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.3</td>
<td headers="Petal.Length" class="gt_row gt_right">6.0</td>
<td headers="Petal.Width" class="gt_row gt_right">2.5</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.8</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.7</td>
<td headers="Petal.Length" class="gt_row gt_right">5.1</td>
<td headers="Petal.Width" class="gt_row gt_right">1.9</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">7.1</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">5.9</td>
<td headers="Petal.Width" class="gt_row gt_right">2.1</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.3</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right">5.6</td>
<td headers="Petal.Width" class="gt_row gt_right">1.8</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.5</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">5.8</td>
<td headers="Petal.Width" class="gt_row gt_right">2.2</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">7.6</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">6.6</td>
<td headers="Petal.Width" class="gt_row gt_right">2.1</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">4.9</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.5</td>
<td headers="Petal.Length" class="gt_row gt_right">4.5</td>
<td headers="Petal.Width" class="gt_row gt_right">1.7</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">7.3</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right">6.3</td>
<td headers="Petal.Width" class="gt_row gt_right">1.8</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.5</td>
<td headers="Petal.Length" class="gt_row gt_right">5.8</td>
<td headers="Petal.Width" class="gt_row gt_right">1.8</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">7.2</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.6</td>
<td headers="Petal.Length" class="gt_row gt_right">6.1</td>
<td headers="Petal.Width" class="gt_row gt_right">2.5</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.5</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right">5.1</td>
<td headers="Petal.Width" class="gt_row gt_right">2.0</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.4</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.7</td>
<td headers="Petal.Length" class="gt_row gt_right">5.3</td>
<td headers="Petal.Width" class="gt_row gt_right">1.9</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.8</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">5.5</td>
<td headers="Petal.Width" class="gt_row gt_right">2.1</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.5</td>
<td headers="Petal.Length" class="gt_row gt_right">5.0</td>
<td headers="Petal.Width" class="gt_row gt_right">2.0</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.8</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right">5.1</td>
<td headers="Petal.Width" class="gt_row gt_right">2.4</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.4</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right">5.3</td>
<td headers="Petal.Width" class="gt_row gt_right">2.3</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.5</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">5.5</td>
<td headers="Petal.Width" class="gt_row gt_right">1.8</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">7.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.8</td>
<td headers="Petal.Length" class="gt_row gt_right">6.7</td>
<td headers="Petal.Width" class="gt_row gt_right">2.2</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">7.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.6</td>
<td headers="Petal.Length" class="gt_row gt_right">6.9</td>
<td headers="Petal.Width" class="gt_row gt_right">2.3</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.0</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.2</td>
<td headers="Petal.Length" class="gt_row gt_right">5.0</td>
<td headers="Petal.Width" class="gt_row gt_right">1.5</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.9</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right">5.7</td>
<td headers="Petal.Width" class="gt_row gt_right">2.3</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.6</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right">4.9</td>
<td headers="Petal.Width" class="gt_row gt_right">2.0</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">7.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right">6.7</td>
<td headers="Petal.Width" class="gt_row gt_right">2.0</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.3</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.7</td>
<td headers="Petal.Length" class="gt_row gt_right">4.9</td>
<td headers="Petal.Width" class="gt_row gt_right">1.8</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.3</td>
<td headers="Petal.Length" class="gt_row gt_right">5.7</td>
<td headers="Petal.Width" class="gt_row gt_right">2.1</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">7.2</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right">6.0</td>
<td headers="Petal.Width" class="gt_row gt_right">1.8</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.2</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right">4.8</td>
<td headers="Petal.Width" class="gt_row gt_right">1.8</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.1</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">4.9</td>
<td headers="Petal.Width" class="gt_row gt_right">1.8</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.4</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right">5.6</td>
<td headers="Petal.Width" class="gt_row gt_right">2.1</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">7.2</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">5.8</td>
<td headers="Petal.Width" class="gt_row gt_right">1.6</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">7.4</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right">6.1</td>
<td headers="Petal.Width" class="gt_row gt_right">1.9</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">7.9</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.8</td>
<td headers="Petal.Length" class="gt_row gt_right">6.4</td>
<td headers="Petal.Width" class="gt_row gt_right">2.0</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.4</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right">5.6</td>
<td headers="Petal.Width" class="gt_row gt_right">2.2</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.3</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right">5.1</td>
<td headers="Petal.Width" class="gt_row gt_right">1.5</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.1</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.6</td>
<td headers="Petal.Length" class="gt_row gt_right">5.6</td>
<td headers="Petal.Width" class="gt_row gt_right">1.4</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">7.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">6.1</td>
<td headers="Petal.Width" class="gt_row gt_right">2.3</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.3</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right">5.6</td>
<td headers="Petal.Width" class="gt_row gt_right">2.4</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.4</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right">5.5</td>
<td headers="Petal.Width" class="gt_row gt_right">1.8</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.0</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">4.8</td>
<td headers="Petal.Width" class="gt_row gt_right">1.8</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.9</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right">5.4</td>
<td headers="Petal.Width" class="gt_row gt_right">2.1</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right">5.6</td>
<td headers="Petal.Width" class="gt_row gt_right">2.4</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.9</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right">5.1</td>
<td headers="Petal.Width" class="gt_row gt_right">2.3</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.8</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.7</td>
<td headers="Petal.Length" class="gt_row gt_right">5.1</td>
<td headers="Petal.Width" class="gt_row gt_right">1.9</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.8</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right">5.9</td>
<td headers="Petal.Width" class="gt_row gt_right">2.3</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.3</td>
<td headers="Petal.Length" class="gt_row gt_right">5.7</td>
<td headers="Petal.Width" class="gt_row gt_right">2.5</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.7</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">5.2</td>
<td headers="Petal.Width" class="gt_row gt_right">2.3</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.3</td>
<td headers="Sepal.Width" class="gt_row gt_right">2.5</td>
<td headers="Petal.Length" class="gt_row gt_right">5.0</td>
<td headers="Petal.Width" class="gt_row gt_right">1.9</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.5</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">5.2</td>
<td headers="Petal.Width" class="gt_row gt_right">2.0</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">6.2</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right">5.4</td>
<td headers="Petal.Width" class="gt_row gt_right">2.3</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_right">5.9</td>
<td headers="Sepal.Width" class="gt_row gt_right">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right">5.1</td>
<td headers="Petal.Width" class="gt_row gt_right">1.8</td>
<td headers="Species" class="gt_row gt_center">virginica</td></tr>
  </tbody>
  &#10;  
</table>
</div>

``` r
library(waldo)
```

``` r
vector_a <- c("a", "b", "c", "d", "e")
vector_b <- c("a", "b", "c", "f")

compare(vector_a, vector_b)
```

    ## `old`: "a" "b" "c" "d" "e"
    ## `new`: "a" "b" "c" "f"

``` r
library(tibble)

tabla_a <- tibble(variable_ead32 = 1, 
       variable_efe23 = 1, 
       variable_eea31 = 1, 
       variable_edr52 = 1, 
       variable_ead30 = 1, 
       variable_eae31 = 1) 

tabla_b <- tibble(variable_ead32 = 1, 
       variable_efe23 = 1, 
       variable_eae31 = 1, 
       variable_ede52 = 1, 
       variable_ead30 = 1, 
       variable_eae30 = 1) 

compare(tabla_a, tabla_b)
```

    ##     names(old)       | names(new)          
    ## [1] "variable_ead32" | "variable_ead32" [1]
    ## [2] "variable_efe23" | "variable_efe23" [2]
    ## [3] "variable_eea31" - "variable_eae31" [3]
    ## [4] "variable_edr52" - "variable_ede52" [4]
    ## [5] "variable_ead30" | "variable_ead30" [5]
    ## [6] "variable_eae31" - "variable_eae30" [6]
    ## 
    ## `old$variable_eea31` is a double vector (1)
    ## `new$variable_eea31` is absent
    ## 
    ## `old$variable_edr52` is a double vector (1)
    ## `new$variable_edr52` is absent
    ## 
    ## `old$variable_ede52` is absent
    ## `new$variable_ede52` is a double vector (1)
    ## 
    ## `old$variable_eae30` is absent
    ## `new$variable_eae30` is a double vector (1)
