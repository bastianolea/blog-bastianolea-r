---
title: Encuentra diferencias entre objetos de R con {waldo}
author: Bastián Olea Herrera
date: '2025-08-12'
draft: true
format:
  hugo-md:
    output-file: index
    output-ext: md
slug: []
categories: []
tags:
  - limpieza de datos
  - consejos
---


https://waldo.r-lib.org

``` r
iris |> gt::gt()
```

<div id="azdksbbyxq" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#azdksbbyxq table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#azdksbbyxq thead, #azdksbbyxq tbody, #azdksbbyxq tfoot, #azdksbbyxq tr, #azdksbbyxq td, #azdksbbyxq th {
  border-style: none;
}

#azdksbbyxq p {
  margin: 0;
  padding: 0;
}

#azdksbbyxq .gt_table {
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

#azdksbbyxq .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#azdksbbyxq .gt_title {
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

#azdksbbyxq .gt_subtitle {
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

#azdksbbyxq .gt_heading {
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

#azdksbbyxq .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#azdksbbyxq .gt_col_headings {
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

#azdksbbyxq .gt_col_heading {
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

#azdksbbyxq .gt_column_spanner_outer {
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

#azdksbbyxq .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#azdksbbyxq .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#azdksbbyxq .gt_column_spanner {
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

#azdksbbyxq .gt_spanner_row {
  border-bottom-style: hidden;
}

#azdksbbyxq .gt_group_heading {
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

#azdksbbyxq .gt_empty_group_heading {
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

#azdksbbyxq .gt_from_md > :first-child {
  margin-top: 0;
}

#azdksbbyxq .gt_from_md > :last-child {
  margin-bottom: 0;
}

#azdksbbyxq .gt_row {
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

#azdksbbyxq .gt_stub {
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

#azdksbbyxq .gt_stub_row_group {
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

#azdksbbyxq .gt_row_group_first td {
  border-top-width: 2px;
}

#azdksbbyxq .gt_row_group_first th {
  border-top-width: 2px;
}

#azdksbbyxq .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#azdksbbyxq .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#azdksbbyxq .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#azdksbbyxq .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#azdksbbyxq .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#azdksbbyxq .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#azdksbbyxq .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#azdksbbyxq .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#azdksbbyxq .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#azdksbbyxq .gt_footnotes {
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

#azdksbbyxq .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#azdksbbyxq .gt_sourcenotes {
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

#azdksbbyxq .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#azdksbbyxq .gt_left {
  text-align: left;
}

#azdksbbyxq .gt_center {
  text-align: center;
}

#azdksbbyxq .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#azdksbbyxq .gt_font_normal {
  font-weight: normal;
}

#azdksbbyxq .gt_font_bold {
  font-weight: bold;
}

#azdksbbyxq .gt_font_italic {
  font-style: italic;
}

#azdksbbyxq .gt_super {
  font-size: 65%;
}

#azdksbbyxq .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#azdksbbyxq .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#azdksbbyxq .gt_indent_1 {
  text-indent: 5px;
}

#azdksbbyxq .gt_indent_2 {
  text-indent: 10px;
}

#azdksbbyxq .gt_indent_3 {
  text-indent: 15px;
}

#azdksbbyxq .gt_indent_4 {
  text-indent: 20px;
}

#azdksbbyxq .gt_indent_5 {
  text-indent: 25px;
}

#azdksbbyxq .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#azdksbbyxq div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>

| Sepal.Length | Sepal.Width | Petal.Length | Petal.Width | Species    |
|--------------|-------------|--------------|-------------|------------|
| 5.1          | 3.5         | 1.4          | 0.2         | setosa     |
| 4.9          | 3.0         | 1.4          | 0.2         | setosa     |
| 4.7          | 3.2         | 1.3          | 0.2         | setosa     |
| 4.6          | 3.1         | 1.5          | 0.2         | setosa     |
| 5.0          | 3.6         | 1.4          | 0.2         | setosa     |
| 5.4          | 3.9         | 1.7          | 0.4         | setosa     |
| 4.6          | 3.4         | 1.4          | 0.3         | setosa     |
| 5.0          | 3.4         | 1.5          | 0.2         | setosa     |
| 4.4          | 2.9         | 1.4          | 0.2         | setosa     |
| 4.9          | 3.1         | 1.5          | 0.1         | setosa     |
| 5.4          | 3.7         | 1.5          | 0.2         | setosa     |
| 4.8          | 3.4         | 1.6          | 0.2         | setosa     |
| 4.8          | 3.0         | 1.4          | 0.1         | setosa     |
| 4.3          | 3.0         | 1.1          | 0.1         | setosa     |
| 5.8          | 4.0         | 1.2          | 0.2         | setosa     |
| 5.7          | 4.4         | 1.5          | 0.4         | setosa     |
| 5.4          | 3.9         | 1.3          | 0.4         | setosa     |
| 5.1          | 3.5         | 1.4          | 0.3         | setosa     |
| 5.7          | 3.8         | 1.7          | 0.3         | setosa     |
| 5.1          | 3.8         | 1.5          | 0.3         | setosa     |
| 5.4          | 3.4         | 1.7          | 0.2         | setosa     |
| 5.1          | 3.7         | 1.5          | 0.4         | setosa     |
| 4.6          | 3.6         | 1.0          | 0.2         | setosa     |
| 5.1          | 3.3         | 1.7          | 0.5         | setosa     |
| 4.8          | 3.4         | 1.9          | 0.2         | setosa     |
| 5.0          | 3.0         | 1.6          | 0.2         | setosa     |
| 5.0          | 3.4         | 1.6          | 0.4         | setosa     |
| 5.2          | 3.5         | 1.5          | 0.2         | setosa     |
| 5.2          | 3.4         | 1.4          | 0.2         | setosa     |
| 4.7          | 3.2         | 1.6          | 0.2         | setosa     |
| 4.8          | 3.1         | 1.6          | 0.2         | setosa     |
| 5.4          | 3.4         | 1.5          | 0.4         | setosa     |
| 5.2          | 4.1         | 1.5          | 0.1         | setosa     |
| 5.5          | 4.2         | 1.4          | 0.2         | setosa     |
| 4.9          | 3.1         | 1.5          | 0.2         | setosa     |
| 5.0          | 3.2         | 1.2          | 0.2         | setosa     |
| 5.5          | 3.5         | 1.3          | 0.2         | setosa     |
| 4.9          | 3.6         | 1.4          | 0.1         | setosa     |
| 4.4          | 3.0         | 1.3          | 0.2         | setosa     |
| 5.1          | 3.4         | 1.5          | 0.2         | setosa     |
| 5.0          | 3.5         | 1.3          | 0.3         | setosa     |
| 4.5          | 2.3         | 1.3          | 0.3         | setosa     |
| 4.4          | 3.2         | 1.3          | 0.2         | setosa     |
| 5.0          | 3.5         | 1.6          | 0.6         | setosa     |
| 5.1          | 3.8         | 1.9          | 0.4         | setosa     |
| 4.8          | 3.0         | 1.4          | 0.3         | setosa     |
| 5.1          | 3.8         | 1.6          | 0.2         | setosa     |
| 4.6          | 3.2         | 1.4          | 0.2         | setosa     |
| 5.3          | 3.7         | 1.5          | 0.2         | setosa     |
| 5.0          | 3.3         | 1.4          | 0.2         | setosa     |
| 7.0          | 3.2         | 4.7          | 1.4         | versicolor |
| 6.4          | 3.2         | 4.5          | 1.5         | versicolor |
| 6.9          | 3.1         | 4.9          | 1.5         | versicolor |
| 5.5          | 2.3         | 4.0          | 1.3         | versicolor |
| 6.5          | 2.8         | 4.6          | 1.5         | versicolor |
| 5.7          | 2.8         | 4.5          | 1.3         | versicolor |
| 6.3          | 3.3         | 4.7          | 1.6         | versicolor |
| 4.9          | 2.4         | 3.3          | 1.0         | versicolor |
| 6.6          | 2.9         | 4.6          | 1.3         | versicolor |
| 5.2          | 2.7         | 3.9          | 1.4         | versicolor |
| 5.0          | 2.0         | 3.5          | 1.0         | versicolor |
| 5.9          | 3.0         | 4.2          | 1.5         | versicolor |
| 6.0          | 2.2         | 4.0          | 1.0         | versicolor |
| 6.1          | 2.9         | 4.7          | 1.4         | versicolor |
| 5.6          | 2.9         | 3.6          | 1.3         | versicolor |
| 6.7          | 3.1         | 4.4          | 1.4         | versicolor |
| 5.6          | 3.0         | 4.5          | 1.5         | versicolor |
| 5.8          | 2.7         | 4.1          | 1.0         | versicolor |
| 6.2          | 2.2         | 4.5          | 1.5         | versicolor |
| 5.6          | 2.5         | 3.9          | 1.1         | versicolor |
| 5.9          | 3.2         | 4.8          | 1.8         | versicolor |
| 6.1          | 2.8         | 4.0          | 1.3         | versicolor |
| 6.3          | 2.5         | 4.9          | 1.5         | versicolor |
| 6.1          | 2.8         | 4.7          | 1.2         | versicolor |
| 6.4          | 2.9         | 4.3          | 1.3         | versicolor |
| 6.6          | 3.0         | 4.4          | 1.4         | versicolor |
| 6.8          | 2.8         | 4.8          | 1.4         | versicolor |
| 6.7          | 3.0         | 5.0          | 1.7         | versicolor |
| 6.0          | 2.9         | 4.5          | 1.5         | versicolor |
| 5.7          | 2.6         | 3.5          | 1.0         | versicolor |
| 5.5          | 2.4         | 3.8          | 1.1         | versicolor |
| 5.5          | 2.4         | 3.7          | 1.0         | versicolor |
| 5.8          | 2.7         | 3.9          | 1.2         | versicolor |
| 6.0          | 2.7         | 5.1          | 1.6         | versicolor |
| 5.4          | 3.0         | 4.5          | 1.5         | versicolor |
| 6.0          | 3.4         | 4.5          | 1.6         | versicolor |
| 6.7          | 3.1         | 4.7          | 1.5         | versicolor |
| 6.3          | 2.3         | 4.4          | 1.3         | versicolor |
| 5.6          | 3.0         | 4.1          | 1.3         | versicolor |
| 5.5          | 2.5         | 4.0          | 1.3         | versicolor |
| 5.5          | 2.6         | 4.4          | 1.2         | versicolor |
| 6.1          | 3.0         | 4.6          | 1.4         | versicolor |
| 5.8          | 2.6         | 4.0          | 1.2         | versicolor |
| 5.0          | 2.3         | 3.3          | 1.0         | versicolor |
| 5.6          | 2.7         | 4.2          | 1.3         | versicolor |
| 5.7          | 3.0         | 4.2          | 1.2         | versicolor |
| 5.7          | 2.9         | 4.2          | 1.3         | versicolor |
| 6.2          | 2.9         | 4.3          | 1.3         | versicolor |
| 5.1          | 2.5         | 3.0          | 1.1         | versicolor |
| 5.7          | 2.8         | 4.1          | 1.3         | versicolor |
| 6.3          | 3.3         | 6.0          | 2.5         | virginica  |
| 5.8          | 2.7         | 5.1          | 1.9         | virginica  |
| 7.1          | 3.0         | 5.9          | 2.1         | virginica  |
| 6.3          | 2.9         | 5.6          | 1.8         | virginica  |
| 6.5          | 3.0         | 5.8          | 2.2         | virginica  |
| 7.6          | 3.0         | 6.6          | 2.1         | virginica  |
| 4.9          | 2.5         | 4.5          | 1.7         | virginica  |
| 7.3          | 2.9         | 6.3          | 1.8         | virginica  |
| 6.7          | 2.5         | 5.8          | 1.8         | virginica  |
| 7.2          | 3.6         | 6.1          | 2.5         | virginica  |
| 6.5          | 3.2         | 5.1          | 2.0         | virginica  |
| 6.4          | 2.7         | 5.3          | 1.9         | virginica  |
| 6.8          | 3.0         | 5.5          | 2.1         | virginica  |
| 5.7          | 2.5         | 5.0          | 2.0         | virginica  |
| 5.8          | 2.8         | 5.1          | 2.4         | virginica  |
| 6.4          | 3.2         | 5.3          | 2.3         | virginica  |
| 6.5          | 3.0         | 5.5          | 1.8         | virginica  |
| 7.7          | 3.8         | 6.7          | 2.2         | virginica  |
| 7.7          | 2.6         | 6.9          | 2.3         | virginica  |
| 6.0          | 2.2         | 5.0          | 1.5         | virginica  |
| 6.9          | 3.2         | 5.7          | 2.3         | virginica  |
| 5.6          | 2.8         | 4.9          | 2.0         | virginica  |
| 7.7          | 2.8         | 6.7          | 2.0         | virginica  |
| 6.3          | 2.7         | 4.9          | 1.8         | virginica  |
| 6.7          | 3.3         | 5.7          | 2.1         | virginica  |
| 7.2          | 3.2         | 6.0          | 1.8         | virginica  |
| 6.2          | 2.8         | 4.8          | 1.8         | virginica  |
| 6.1          | 3.0         | 4.9          | 1.8         | virginica  |
| 6.4          | 2.8         | 5.6          | 2.1         | virginica  |
| 7.2          | 3.0         | 5.8          | 1.6         | virginica  |
| 7.4          | 2.8         | 6.1          | 1.9         | virginica  |
| 7.9          | 3.8         | 6.4          | 2.0         | virginica  |
| 6.4          | 2.8         | 5.6          | 2.2         | virginica  |
| 6.3          | 2.8         | 5.1          | 1.5         | virginica  |
| 6.1          | 2.6         | 5.6          | 1.4         | virginica  |
| 7.7          | 3.0         | 6.1          | 2.3         | virginica  |
| 6.3          | 3.4         | 5.6          | 2.4         | virginica  |
| 6.4          | 3.1         | 5.5          | 1.8         | virginica  |
| 6.0          | 3.0         | 4.8          | 1.8         | virginica  |
| 6.9          | 3.1         | 5.4          | 2.1         | virginica  |
| 6.7          | 3.1         | 5.6          | 2.4         | virginica  |
| 6.9          | 3.1         | 5.1          | 2.3         | virginica  |
| 5.8          | 2.7         | 5.1          | 1.9         | virginica  |
| 6.8          | 3.2         | 5.9          | 2.3         | virginica  |
| 6.7          | 3.3         | 5.7          | 2.5         | virginica  |
| 6.7          | 3.0         | 5.2          | 2.3         | virginica  |
| 6.3          | 2.5         | 5.0          | 1.9         | virginica  |
| 6.5          | 3.0         | 5.2          | 2.0         | virginica  |
| 6.2          | 3.4         | 5.4          | 2.3         | virginica  |
| 5.9          | 3.0         | 5.1          | 1.8         | virginica  |

</div>

``` r
library(waldo)
```

``` r
vector_a <- c("a", "b", "c", "d", "e")
vector_b <- c("a", "b", "c", "f")

compare(vector_a, vector_b)
```

    `old`: "a" "b" "c" "d" "e"
    `new`: "a" "b" "c" "f"    

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

        names(old)       | names(new)          
    [1] "variable_ead32" | "variable_ead32" [1]
    [2] "variable_efe23" | "variable_efe23" [2]
    [3] "variable_eea31" - "variable_eae31" [3]
    [4] "variable_edr52" - "variable_ede52" [4]
    [5] "variable_ead30" | "variable_ead30" [5]
    [6] "variable_eae31" - "variable_eae30" [6]

    `old$variable_eea31` is a double vector (1)
    `new$variable_eea31` is absent

    `old$variable_edr52` is a double vector (1)
    `new$variable_edr52` is absent

    `old$variable_ede52` is absent
    `new$variable_ede52` is a double vector (1)

    `old$variable_eae30` is absent
    `new$variable_eae30` is a double vector (1)
