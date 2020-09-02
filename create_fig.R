viz <- function(data,
                regions,
                metrics,
                #log_value = FALSE,
                smooth_value = TRUE,
                y_axis_value = "perc_pop",
                y_lab = "% Percent of Respective Region's Population",
                x_axis = "date",
                x_lab = "Date") {
  
  # filter data ----
  df_fig <- data %>%
    filter(metric %in% metrics,
           region %in% regions,
           smooth == smooth_value,
           y_axis == y_axis_value)
  
  # get last data point ----
  df_fig_last <- df_fig %>%
    group_by(region) %>%
    filter(date == last(date)) %>%
    unique()
  
  # get figure ----
  fig <-
    ggplot(df_fig, aes(eval(as.name(x_axis)), value, color = region, linetype = region)) +
    geom_line() +
    geom_point(data = df_fig_last,
               mapping = aes(eval(as.name(x_axis)), value, color = region)) +
    labs(
      x = paste0("\n", x_lab),
      color = "Region",
      linetype = "Region",
      y = paste0(y_lab, "\n")
    ) +
    theme_minimal() +
    scale_y_continuous(limits = c(0, NA))
    theme(axis.text.x = element_text(hjust = 1, angle = 90))
  
  if (x_axis == "date") {
    fig <- fig + scale_x_date(date_breaks = "months", date_labels = "%Y-%m")
  }
    
  # get unreliable regions ----
  # add note that data may be unreliable (i.e., flat line of 0s)
  df_fig_unreliable <- df_unreliable %>%
    filter(region %in% regions,
           metric %in% metrics) %>%
    ungroup() %>%
    select(region) %>%
    unlist() %>%
    as.character()

  if (length(df_fig_unreliable) > 0) {
    fig <- fig +
      labs(caption = paste0("\nWarning: Data from some regions (i.e., ", paste0(df_fig_unreliable, collapse = ", "),") may not be reliable"))
  }
  
  return(fig)
  
}