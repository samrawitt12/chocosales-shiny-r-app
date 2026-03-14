# ChocoSales Shiny for R App

This is an individual Shiny for R dashboard based on our group ChocoSales project.  
The app lets users filter chocolate sales data by country, view the monthly total sales trend, and see the top 5 products by sales for the selected country filter.

## App features

- 1 input: country filter dropdown
- 1 reactive calc: filtered sales dataframe
- 2 outputs:
  - monthly total sales trend plot
  - top 5 products by sales table

## Data

The app uses the cleaned dataset:

`data/chocolate_sales_clean.csv`

## Install packages

Open R and run:

```r
install.packages(c("shiny", "dplyr", "ggplot2", "readr"))
