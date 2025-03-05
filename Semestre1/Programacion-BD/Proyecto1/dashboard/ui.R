library(shiny)
library(shinydashboard)
library(plotly)

ui <- dashboardPage(
  skin = "blue",  # Color del dashboard
  dashboardHeader(title = "Análisis de Algoritmos"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Asignaciones", tabName = "assignments", icon = icon("chart-bar")),
      menuItem("Intercambios", tabName = "swaps", icon = icon("exchange-alt")),
      menuItem("Comparaciones", tabName = "comparisons", icon = icon("columns"))
    )
  ),
  
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .skin-blue .main-header .logo {
          background-color: #003366;
        }
        .skin-blue .main-header .navbar {
          background-color: #004080;
        }
        .skin-blue .main-sidebar {
          background-color: #00264d;
        }
        .skin-blue .main-sidebar .sidebar-menu a {
          color: #ffffff;
        }
      "))
    ),
    
    tabItems(
      tabItem(tabName = "assignments",
              fluidRow(
                box(title = "Opciones", status = "primary", solidHeader = TRUE, width = 3,
                    radioButtons("assign_metric", "Métrica:", choices = c("Comparison", "Swap"), selected = "Comparison")
                ),
                box(title = "Gráficos de Asignaciones", status = "info", solidHeader = TRUE, width = 9,
                    plotlyOutput("plot_assignments"),
                    plotlyOutput("plot_assignments_line")
                )
              )
      ),
      
      tabItem(tabName = "swaps",
              fluidRow(
                box(title = "Opciones", status = "primary", solidHeader = TRUE, width = 3,
                    radioButtons("swap_metric", "Métrica:", choices = c("Comparison", "Swap"), selected = "Comparison")
                ),
                box(title = "Gráficos de Intercambios", status = "info", solidHeader = TRUE, width = 9,
                    plotlyOutput("plot_swaps"),
                    plotlyOutput("plot_swaps_line")
                )
              )
      ),
      
      tabItem(tabName = "comparisons",
              fluidRow(
                box(title = "Opciones", status = "primary", solidHeader = TRUE, width = 3,
                    selectInput("size_select", "Selecciona tamaño del vector:", choices = NULL)
                ),
                box(title = "Comparaciones", status = "info", solidHeader = TRUE, width = 9,
                    plotlyOutput("plot_comparaciones"),
                    plotlyOutput("plot_intercambios")
                )
              )
      )
    )
  )
)
