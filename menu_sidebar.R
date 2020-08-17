dashboard_menu <- sidebarMenu(
  menuItem("Dashboard", icon = icon("dashboard"), startExpanded = T, tabName = "dashboard", selected = T,
    menuItem("Regions", icon("globe-americas"), startExpanded = T,
             checkboxGroupInput("regions", NULL, c("World", "USA", "Thailand", "Guatemala", "California", "Texas", "Dallas", "Los Angeles"), c("Los Angeles", "Dallas"))),
    menuItem(text = "Data Transformation", icon = icon("cogs"), startExpanded = T, checkboxInput("smooth", "7-Day Moving Average", TRUE)),
    menuItem(text = "Figure", icon = icon("chart-line"), startExpanded = T, selectInput("y_axis", "Y-Axis", c("Number of People", "% of Respective Region Population", "Per Thousand", "% of Respective World Metric"), "% of Respective Region Population"))
  ),
  menuItem(text = "Code", icon = icon("code"), tabName = "code"),
  menuItem(text = "References", icon = icon("thumbs-up"), tabName = "references"),
  menuItem(text = "Ekarin Eric Pongpipat, M.A.", icon = icon("id-badge"), href = "https://ekarinpongpipat.com", newtab = T)
)