library(shiny)
library(shinydashboard)
library(plotly)

ui <- dashboardPage(
  dashboardHeader(title = "Comparación bubble vs merge sort",
                  titleWidth = 350),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Asignaciones", tabName = "asignaciones", icon = icon("chart-bar")),
      menuItem("Intercambios", tabName = "intercambios", icon = icon("chart-bar")),
      menuItem("Comparaciones", tabName = "comparaciones", icon = icon("table"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "asignaciones",
              fluidRow(
                tabsetPanel(
                  tabPanel("Barras", plotlyOutput("plot_assignments")),
                  tabPanel("Líneas", plotlyOutput("plot_assignments_line"))
                )
              )
      ),
      tabItem(tabName = "intercambios",
              fluidRow(
                tabsetPanel(
                  tabPanel("Barras", plotlyOutput("plot_swaps")),
                  tabPanel("Líneas", plotlyOutput("plot_swaps_line"))
                )
              )
      ),
      tabItem(tabName = "comparaciones",
              fluidRow(
                box(title = "Selecciona tamaño del vector", width = 12,
                    selectInput("size_select", "Tamaño del vector:", choices = NULL))
              ),
              fluidRow(
                box(title = "Comparaciones", width = 6, plotlyOutput("plot_comparaciones")),
                box(title = "Intercambios", width = 6, plotlyOutput("plot_intercambios"))
              )
      )
    )
  )
)
