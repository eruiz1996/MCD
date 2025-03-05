library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

read_path <- "C://Users//ed_22//Documents//MCD//Semestre1//Programacion-BD//Proyecto1//data//"
bubble_csv <- paste0(read_path, "bubble.csv")
merge_assing_csv <- paste0(read_path, "merge_asignaciones.csv")
merge2_csv <- paste0(read_path, "merge2.csv")

server <- function(input, output, session) {
  # Cargar datos
  bubble_data <- read.csv(bubble_csv)
  merge_assing_data <- read.csv(merge_assing_csv)
  merge2_data <- read.csv(merge2_csv)
  
  # Obtener los tamaños únicos para el selectInput
  observe({
    updateSelectInput(session, "size_select", choices = unique(bubble_data$size))
  })
  
  # Datos para las gráficas de "Asignaciones"
  summary_data_assign <- bubble_data %>%
    group_by(size) %>%
    summarise(avg_comparison_bubble = mean(comparison),
              avg_swap_bubble = mean(swap)) %>%
    inner_join(
      merge_assing_data %>%
        group_by(size) %>%
        summarise(avg_comparison_merge = mean(comparison),
                  avg_swap_merge = mean(swap)),
      by = "size"
    )
  
  # Datos para las gráficas de "Intercambios"
  summary_data_swaps <- bubble_data %>%
    group_by(size) %>%
    summarise(avg_swap_bubble = mean(swap)) %>%
    inner_join(
      merge2_data %>%
        group_by(size) %>%
        summarise(avg_swap_merge = mean(swap)),
      by = "size"
    )
  
  # Gráficas de la pestaña "Asignaciones"
  output$plot_assignments <- renderPlotly({
    p <- ggplot(summary_data_assign, aes(x = factor(size))) +
      geom_bar(aes(y = avg_comparison_bubble, fill = "Bubble Sort"), stat = "identity", position = "dodge") +
      geom_bar(aes(y = avg_comparison_merge, fill = "Merge Sort"), stat = "identity", position = "dodge") +
      labs(y = "Promedio de Comparaciones", x = "Tamaño del Vector", fill = "Algoritmo") +
      theme_minimal()
    ggplotly(p)
  })
  
  output$plot_assignments_line <- renderPlotly({
    p <- ggplot(summary_data_assign, aes(x = size)) +
      geom_line(aes(y = avg_comparison_bubble, color = "Bubble Sort")) +
      geom_line(aes(y = avg_comparison_merge, color = "Merge Sort")) +
      labs(y = "Promedio de Comparaciones", x = "Tamaño del Vector", color = "Algoritmo") +
      theme_minimal()
    ggplotly(p)
  })
  
  # Gráficas de la pestaña "Intercambios"
  output$plot_swaps <- renderPlotly({
    p <- ggplot(summary_data_swaps, aes(x = factor(size))) +
      geom_bar(aes(y = avg_swap_bubble, fill = "Bubble Sort"), stat = "identity", position = "dodge") +
      geom_bar(aes(y = avg_swap_merge, fill = "Merge Sort"), stat = "identity", position = "dodge") +
      labs(y = "Promedio de Intercambios", x = "Tamaño del Vector", fill = "Algoritmo") +
      theme_minimal()
    ggplotly(p)
  })
  
  output$plot_swaps_line <- renderPlotly({
    p <- ggplot(summary_data_swaps, aes(x = size)) +
      geom_line(aes(y = avg_swap_bubble, color = "Bubble Sort")) +
      geom_line(aes(y = avg_swap_merge, color = "Merge Sort")) +
      labs(y = "Promedio de Intercambios", x = "Tamaño del Vector", color = "Algoritmo") +
      theme_minimal()
    ggplotly(p)
  })
  
  # Gráficas de la pestaña "Comparaciones"
  output$plot_comparaciones <- renderPlotly({
    filtered_bubble <- bubble_data %>% filter(size == input$size_select)
    filtered_merge <- merge_assing_data %>% filter(size == input$size_select)
    
    plot_data <- data.frame(
      Algoritmo = c(rep("Bubble Sort", nrow(filtered_bubble)), rep("Merge Sort", nrow(filtered_merge))),
      Comparaciones = c(filtered_bubble$comparison, filtered_merge$comparison)
    )
    
    p <- ggplot(plot_data, aes(x = Algoritmo, y = Comparaciones, fill = Algoritmo)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(y = "Número de Comparaciones", x = "Algoritmo") +
      theme_minimal()
    
    ggplotly(p)
  })
  
  output$plot_intercambios <- renderPlotly({
    filtered_bubble <- bubble_data %>% filter(size == input$size_select)
    filtered_merge <- merge_assing_data %>% filter(size == input$size_select)
    
    plot_data <- data.frame(
      Algoritmo = c(rep("Bubble Sort", nrow(filtered_bubble)), rep("Merge Sort", nrow(filtered_merge))),
      Intercambios = c(filtered_bubble$swap, filtered_merge$swap)
    )
    
    p <- ggplot(plot_data, aes(x = Algoritmo, y = Intercambios, fill = Algoritmo)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(y = "Número de Intercambios", x = "Algoritmo") +
      theme_minimal()
    
    ggplotly(p)
  })
}
