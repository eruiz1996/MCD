library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

read_path <- "C://Users//ed_22//Documents//MCD//Semestre1//Programacion-BD//Proyecto1//data//"
bubble_data <- read.csv(paste0(read_path, "bubble.csv"))
merge_asignaciones_data <- read.csv(paste0(read_path, "merge_asignaciones.csv"))
merge_intercambios_data <- read.csv(paste0(read_path, "merge2.csv"))

server <- function(input, output, session) {
  
  updateSelectInput(session, "selected_size", choices = unique(bubble_data$size))
  
  render_comparison_plots <- function(bubble, merge, output_comparison, output_swap) {
    output[[output_comparison]] <- renderPlotly({
      p <- ggplot() +
        geom_line(data = bubble, aes(x = size, y = comparison, color = "Bubble Sort")) +
        geom_line(data = merge, aes(x = size, y = comparison, color = "Merge Sort")) +
        labs(y = "Promedio de comparaciones", x = "Tamaño del vector", color = "Algoritmo") +
        theme_minimal()
      ggplotly(p)
    })
    
    output[[output_swap]] <- renderPlotly({
      p <- ggplot() +
        geom_line(data = bubble, aes(x = size, y = swap, color = "Bubble Sort")) +
        geom_line(data = merge, aes(x = size, y = swap, color = "Merge Sort")) +
        labs(y = "Promedio de intercambios", x = "Tamaño del vector", color = "Algoritmo") +
        theme_minimal()
      ggplotly(p)
    })
  }
  
  render_comparison_plots(bubble_data, merge_asignaciones_data, "plot_comparisons_asign", "plot_swaps_asign")
  render_comparison_plots(bubble_data, merge_intercambios_data, "plot_comparisons_inter", "plot_swaps_inter")
  
  output$bar_comparisons <- renderPlotly({
    size_selected <- input$selected_size
    
    df <- data.frame(
      Algoritmo = c("Bubble Sort", "Merge Asignaciones", "Merge Intercambios"),
      Comparaciones = c(
        sum(bubble_data$comparison[bubble_data$size == size_selected]),
        sum(merge_asignaciones_data$comparison[merge_asignaciones_data$size == size_selected]),
        sum(merge_intercambios_data$comparison[merge_intercambios_data$size == size_selected])
      )
    )
    
    p <- ggplot(df, aes(x = Algoritmo, y = Comparaciones, fill = Algoritmo)) +
      geom_bar(stat = "identity") + theme_minimal()
    ggplotly(p)
  })
  
  output$bar_swaps <- renderPlotly({
    size_selected <- input$selected_size
    
    df <- data.frame(
      Algoritmo = c("Bubble Sort", "Merge Asignaciones", "Merge Intercambios"),
      Intercambios = c(
        sum(bubble_data$swap[bubble_data$size == size_selected]),
        sum(merge_asignaciones_data$swap[merge_asignaciones_data$size == size_selected]),
        sum(merge_intercambios_data$swap[merge_intercambios_data$size == size_selected])
      )
    )
    
    p <- ggplot(df, aes(x = Algoritmo, y = Intercambios, fill = Algoritmo)) +
      geom_bar(stat = "identity") + theme_minimal()
    ggplotly(p)
  })
}
