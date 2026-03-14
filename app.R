library(shiny)
library(dplyr)
library(ggplot2)
library(readr)

# Load cleaned data
sales_data <- read_csv("data/chocolate_sales_clean.csv", show_col_types = FALSE) |>
  mutate(date = as.Date(date))

country_choices <- c("All", sort(unique(sales_data$country)))

ui <- fluidPage(
  titlePanel("ChocoSales Shiny for R App"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "country",
        label = "Filter by country",
        choices = country_choices,
        selected = "All"
      )
    ),
    
    mainPanel(
      plotOutput("sales_trend_plot"),
      br(),
      h4("Top 5 Products by Sales"),
      tableOutput("top_products_table")
    )
  )
)

server <- function(input, output, session) {
  
  # Reactive calc: filtered dataframe
  filtered_sales <- reactive({
    if (input$country == "All") {
      sales_data
    } else {
      sales_data |> filter(country == input$country)
    }
  })
  
  # Output 1: monthly sales trend plot
  output$sales_trend_plot <- renderPlot({
    trend_data <- filtered_sales() |>
      mutate(month_date = as.Date(paste0(year_month, "-01"))) |>
      group_by(month_date) |>
      summarise(total_sales = sum(sales, na.rm = TRUE), .groups = "drop")
    
    ggplot(trend_data, aes(x = month_date, y = total_sales)) +
      geom_line(color = "steelblue", linewidth = 1) +
      geom_point(color = "steelblue", size = 2) +
      labs(
        title = "Monthly Total Sales for Selected Country Filter",
        x = "Month",
        y = "Total Sales (USD)"
      ) +
      theme_minimal()
  })
  
  # Output 2: top 5 products table
  output$top_products_table <- renderTable({
    filtered_sales() |>
      group_by(product) |>
      summarise(total_sales = sum(sales, na.rm = TRUE), .groups = "drop") |>
      arrange(desc(total_sales)) |>
      slice_head(n = 5) |>
      mutate(total_sales = round(total_sales, 2))
  })
}

shinyApp(ui = ui, server = server)
