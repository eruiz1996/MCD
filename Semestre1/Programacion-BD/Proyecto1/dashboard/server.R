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
  
  # Actualizar selectInput con tamaños disponibles
  observe({
    updateSelectInput(session, "size_select", choices = unique(bubble_data$size))
  })
  
  # Gráficos de la pestaña "Asignaciones"
  output$plot_assignments <- renderPlotly({
    metric <- ifelse(input$assign_metric == "Comparison", "comparison", "swap")
    summary_data <- bubble_data %>%
      group_by(size) %>%
      summarise(value_bubble = mean(.data[[metric]])) %>%
      inner_join(
        merge_assing_data %>%
          group_by(size) %>%
          summarise(value_merge = mean(.data[[metric]])),
        by = "size"
      )
    
    p <- ggplot(summary_data, aes(x = factor(size))) +
      geom_bar(aes(y = value_bubble, fill = "Bubble Sort"), stat = "identity", position = "dodge") +
      geom_bar(aes(y = value_merge, fill = "Merge Sort"), stat = "identity", position = "dodge") +
      labs(y = paste("Promedio de", input$assign_metric), x = "Tamaño del Vector", fill = "Algoritmo") +
      theme_minimal()
    
    ggplotly(p)
  })
  
  output$plot_assignments_line <- renderPlotly({
    metric <- ifelse(input$assign_metric == "Comparison", "comparison", "swap")
    summary_data <- bubble_data %>%
      group_by(size) %>%
      summarise(value_bubble = mean(.data[[metric]])) %>%
      inner_join(
        merge_assing_data %>%
          group_by(size) %>%
          summarise(value_merge = mean(.data[[metric]])),
        by = "size"
      )
    
    p <- ggplot(summary_data, aes(x = size)) +
      geom_line(aes(y = value_bubble, color = "Bubble Sort")) +
      geom_line(aes(y = value_merge, color = "Merge Sort")) +
      labs(y = paste("Promedio de", input$assign_metric), x = "Tamaño del Vector", color = "Algoritmo") +
      theme_minimal()
    
    ggplotly(p)
  })
  
  # Gráficos de la pestaña "Intercambios"
  output$plot_swaps <- renderPlotly({
    metric <- ifelse(input$swap_metric == "Comparison", "comparison", "swap")
    summary_data <- bubble_data %>%
      group_by(size) %>%
      summarise(value_bubble = mean(.data[[metric]])) %>%
      inner_join(
        merge2_data %>%
          group_by(size) %>%
          summarise(value_merge = mean(.data[[metric]])),
        by = "size"
      )
    
    p <- ggplot(summary_data, aes(x = factor(size))) +
      geom_bar(aes(y = value_bubble, fill = "Bubble Sort"), stat = "identity", position = "dodge") +
      geom_bar(aes(y = value_merge, fill = "Merge Sort"), stat = "identity", position = "dodge") +
      labs(y = paste("Promedio de", input$swap_metric), x = "Tamaño del Vector", fill = "Algoritmo") +
      theme_minimal()
    
    ggplotly(p)
  })
  
  output$plot_swaps_line <- renderPlotly({
    metric <- ifelse(input$swap_metric == "Comparison", "comparison", "swap")
    summary_data <- bubble_data %>%
      group_by(size) %>%
      summarise(value_bubble = mean(.data[[metric]])) %>%
      inner_join(
        merge2_data %>%
          group_by(size) %>%
          summarise(value_merge = mean(.data[[metric]])),
        by = "size"
      )
    
    p <- ggplot(summary_data, aes(x = size)) +
      geom_line(aes(y = value_bubble, color = "Bubble Sort")) +
      geom_line(aes(y = value_merge, color = "Merge Sort")) +
      labs(y = paste("Promedio de", input$swap_metric), x = "Tamaño del Vector", color = "Algoritmo") +
      theme_minimal()
    
    ggplotly(p)
  })
  
  # Gráficos de la pestaña "Comparaciones"
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
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
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
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    ggplotly(p)
  })
}
