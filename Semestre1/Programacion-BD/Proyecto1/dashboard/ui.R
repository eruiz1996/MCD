library(shinydashboard)
library(shiny)
library(plotly)

ui <- dashboardPage(
  dashboardHeader(title = "Comparación bubble vs merge sort"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Gráficas", tabName = "graficas", icon = icon("chart-line")),
      menuItem("Métricas", tabName = "metricas", icon = icon("table"))
    )
  ),
  
  dashboardBody(
    tabItems(
      # Sección de gráficas
      tabItem(tabName = "graficas",
              fluidRow(
                box(title = "Selecciona rango de tamaño", width = 12,
                    sliderInput("size_range", "Tamaño del vector:",
                                min = 10, max = 100, value = c(10, 100), step = 10)
                )
              ),
              fluidRow(
                box(title = "Comparaciones por tamaño", width = 6, plotlyOutput("plot_comparisons")),
                box(title = "Intercambios por tamaño", width = 6, plotlyOutput("plot_swaps"))
              ),
              fluidRow(
                box(title = "Distribución de comparaciones", width = 6, plotOutput("hist_comparisons")),
                box(title = "Distribución de intercambios", width = 6, plotOutput("hist_swaps"))
              )
      ),
      
      # Sección de métricas
      tabItem(tabName = "metricas",
              fluidRow(
                box(title = "Métricas Comparativas", width = 12, tableOutput("summary_table"))
              )
      )
    )
  )
)
