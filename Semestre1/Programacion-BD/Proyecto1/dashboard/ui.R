library(shiny)
library(plotly)

ui <- navbarPage("Análisis de Algoritmos",
                 tabPanel("Asignaciones",
                          sidebarLayout(
                            sidebarPanel(
                              radioButtons("assign_metric", "Métrica:", choices = c("Comparison", "Swap"), selected = "Comparison")
                            ),
                            mainPanel(
                              plotlyOutput("plot_assignments"),
                              plotlyOutput("plot_assignments_line")
                            )
                          )
                 ),
                 tabPanel("Intercambios",
                          sidebarLayout(
                            sidebarPanel(
                              radioButtons("swap_metric", "Métrica:", choices = c("Comparison", "Swap"), selected = "Comparison")
                            ),
                            mainPanel(
                              plotlyOutput("plot_swaps"),
                              plotlyOutput("plot_swaps_line")
                            )
                          )
                 ),
                 tabPanel("Comparaciones",
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("size_select", "Selecciona tamaño del vector:", choices = NULL)
                            ),
                            mainPanel(
                              plotlyOutput("plot_comparaciones"),
                              plotlyOutput("plot_intercambios")
                            )
                          )
                 )
)
