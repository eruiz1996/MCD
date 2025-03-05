library(shinydashboard)
library(shiny)
library(plotly)

ui <- dashboardPage(
  dashboardHeader(title = "Comparación Bubble vs Merge Sort", titleWidth = 350),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Asignaciones", tabName = "asignaciones", icon = icon("chart-line")),
      menuItem("Intercambios", tabName = "intercambios", icon = icon("chart-line")),
      menuItem("Comparaciones", tabName = "comparaciones", icon = icon("bar-chart"))
    )
  ),
  
  dashboardBody(
    tabItems(
      # Asignaciones
      tabItem(tabName = "asignaciones",
              fluidRow(
                box(title = "Comparaciones por tamaño", width = 6, plotlyOutput("plot_comparisons_asign")),
                box(title = "Intercambios por tamaño", width = 6, plotlyOutput("plot_swaps_asign"))
              )
      ),
      
      # Intercambios
      tabItem(tabName = "intercambios",
              fluidRow(
                box(title = "Comparaciones por tamaño", width = 6, plotlyOutput("plot_comparisons_inter")),
                box(title = "Intercambios por tamaño", width = 6, plotlyOutput("plot_swaps_inter"))
              )
      ),
      
      # Comparaciones
      tabItem(tabName = "comparaciones",
              fluidRow(
                box(title = "Selecciona tamaño", width = 12,
                    selectInput("selected_size", "Tamaño del vector:", choices = NULL)
                )
              ),
              fluidRow(
                box(title = "Comparaciones", width = 6, plotlyOutput("bar_comparisons")),
                box(title = "Intercambios", width = 6, plotlyOutput("bar_swaps"))
              )
      )
    )
  )
)
