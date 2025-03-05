library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

read_path = "C://Users//ed_22//Documents//MCD//Semestre1//Programacion-BD//Proyecto1//data//"
bubble_csv = paste0(read_path, "bubble.csv")
merge_assing_csv = paste0(read_path, "merge_asignaciones.csv")
merge2 = paste0(read_path, "merge2.csv")

server <- function(input, output) {
  # Cargar datos
  bubble_data <- read.csv(bubble_csv)
  merge_data <- read.csv(merge_assing_csv)
  
  # Unir y promediar los datos por tamaño
  summary_data <- bubble_data %>%
    group_by(size) %>%
    summarise(avg_comparison_bubble = mean(comparison),
              avg_swap_bubble = mean(swap)) %>%
    inner_join(
      merge_data %>%
        group_by(size) %>%
        summarise(avg_comparison_merge = mean(comparison),
                  avg_swap_merge = mean(swap)),
      by = "size"
    ) %>%
    mutate(
      comparison_diff = (avg_comparison_bubble - avg_comparison_merge) / avg_comparison_bubble * 100,
      swap_diff = (avg_swap_bubble - avg_swap_merge) / avg_swap_bubble * 100
    )
  
  # Filtrar datos por tamaño seleccionado
  filtered_data <- reactive({
    summary_data %>% filter(size >= input$size_range[1], size <= input$size_range[2])
  })
  
  # Gráfico interactivo de comparaciones
  output$plot_comparisons <- renderPlotly({
    p <- ggplot(filtered_data(), aes(x = size)) +
      geom_line(aes(y = avg_comparison_bubble, color = "Bubble Sort")) +
      geom_line(aes(y = avg_comparison_merge, color = "Merge Sort")) +
      labs(y = "Promedio de comparaciones", x = "Tamaño del vector", color = "Algoritmo") +
      theme_minimal()
    
    ggplotly(p)  # Aplicamos ggplotly al objeto ggplot completo
  })
  
  # Gráfico interactivo de intercambios
  output$plot_swaps <- renderPlotly({
    p <- ggplot(filtered_data(), aes(x = size)) +
      geom_line(aes(y = avg_swap_bubble, color = "Bubble Sort")) +
      geom_line(aes(y = avg_swap_merge, color = "Merge Sort")) +
      labs(y = "Promedio de intercambios", x = "Tamaño del vector", color = "Algoritmo") +
      theme_minimal()
    
    ggplotly(p)  # Aplicamos ggplotly al objeto ggplot completo
  })
  
  
  # Histograma de comparaciones
  output$hist_comparisons <- renderPlot({
    ggplot(bubble_data, aes(x = comparison, fill = "Bubble Sort")) +
      geom_histogram(alpha = 0.6, bins = 30) +
      geom_histogram(data = merge_data, aes(x = comparison, fill = "Merge Sort"), alpha = 0.6, bins = 30) +
      labs(x = "Número de comparaciones", y = "Frecuencia", fill = "Algoritmo") +
      theme_minimal()
  })
  
  # Histograma de intercambios
  output$hist_swaps <- renderPlot({
    ggplot(bubble_data, aes(x = swap, fill = "Bubble Sort")) +
      geom_histogram(alpha = 0.6, bins = 30) +
      geom_histogram(data = merge_data, aes(x = swap, fill = "Merge Sort"), alpha = 0.6, bins = 30) +
      labs(x = "Número de intercambios", y = "Frecuencia", fill = "Algoritmo") +
      theme_minimal()
  })
  
  # Tabla resumen de métricas
  output$summary_table <- renderTable({
    filtered_data() %>%
      select(size, avg_comparison_bubble, avg_comparison_merge, comparison_diff,
             avg_swap_bubble, avg_swap_merge, swap_diff)
  })
}

