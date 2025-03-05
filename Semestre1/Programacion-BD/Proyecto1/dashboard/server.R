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
  
  # Datos agregados para gráficos de asignaciones e intercambios
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
  
  summary_data_swaps <- bubble_data %>%
    group_by(size) %>%
    summarise(avg_swap_bubble = mean(swap)) %>%
    inner_join(
      merge2_data %>%
        group_by(size) %>%
        summarise(avg_swap_merge = mean(swap)),
      by = "size"
    )
  
  # Gráficos de la pestaña "Asignaciones"
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
  
  # Gráficos de la pestaña "Intercambios"
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
  
  # Actualizar selectInput con tamaños disponibles
  observe({
    updateSelectInput(session, "size_select", choices = unique(bubble_data$size))
  })
  
  # Gráfico de comparaciones con tres barras
  output$plot_comparaciones <- renderPlotly({
    filtered_bubble <- bubble_data %>% filter(size == input$size_select)
    filtered_merge_assign <- merge_assing_data %>% filter(size == input$size_select)
    filtered_merge2 <- merge2_data %>% filter(size == input$size_select)
    
    plot_data <- data.frame(
      Algoritmo = c(rep("Bubble Sort", nrow(filtered_bubble)), 
                    rep("Merge Sort - Asignaciones", nrow(filtered_merge_assign)), 
                    rep("Merge Sort - Comparaciones", nrow(filtered_merge2))),
      Comparaciones = c(filtered_bubble$comparison, 
                        filtered_merge_assign$comparison, 
                        filtered_merge2$comparison)
    )
    
    p <- ggplot(plot_data, aes(x = Algoritmo, y = Comparaciones, fill = Algoritmo)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(y = "Número de Comparaciones", x = "Algoritmo") +
      theme_minimal()
    
    ggplotly(p)
  })
  
  # Gráfico de intercambios con tres barras
  output$plot_intercambios <- renderPlotly({
    filtered_bubble <- bubble_data %>% filter(size == input$size_select)
    filtered_merge_assign <- merge_assing_data %>% filter(size == input$size_select)
    filtered_merge2 <- merge2_data %>% filter(size == input$size_select)
    
    plot_data <- data.frame(
      Algoritmo = c(rep("Bubble Sort", nrow(filtered_bubble)), 
                    rep("Merge Sort - Asignaciones", nrow(filtered_merge_assign)), 
                    rep("Merge Sort - Comparaciones", nrow(filtered_merge2))),
      Intercambios = c(filtered_bubble$swap, 
                       filtered_merge_assign$swap, 
                       filtered_merge2$swap)
    )
    
    p <- ggplot(plot_data, aes(x = Algoritmo, y = Intercambios, fill = Algoritmo)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(y = "Número de Intercambios", x = "Algoritmo") +
      theme_minimal()
    
    ggplotly(p)
  })
}
