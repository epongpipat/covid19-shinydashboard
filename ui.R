# load libraries ----
library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(shinythemes)
library(dplyr)
library(readr)

# load functions ----
source("get_y_axis.R")

# turn off scientific notation ----
options(scipen=999)

# loading spinner options ----
options(spinner.color = "#158CBA", spinner.type = 6)


# dashboard-ui ----
dashboardPage(
    dashboardHeader(title = "covid19"),
    
    # sidebar ----
    dashboardSidebar(
      sidebarMenu(
        menuItem(text = "Dashboard", icon = icon("dashboard"), tabName = "dashboard", selected = TRUE),
        menuItem(text = "Options", icon = icon("sliders-h"), startExpanded = T,
                 menuItem("Regions", icon("globe-americas"), startExpanded = T,
                          checkboxGroupInput("regions", NULL, c("World", "USA", "Thailand", "Guatemala", "California", "Texas", "Dallas", "Los Angeles"), c("Los Angeles", "Dallas"))),
                 menuItem(text = "Data Transformation", icon = icon("cogs"), startExpanded = T, checkboxInput("smooth", "7-Day Moving Average", TRUE)),
                 menuItem(text = "Figure", icon = icon("chart-line"), startExpanded = T, selectInput("y_axis", "Y-Axis", names(y_axis_list), "% of Respective Region's Population"))
        ),
        menuItem(text = "Code", icon = icon("code"), href = "https://github.com/epongpipat/covid19-shinydashboard", newtab = T),
        menuItem(text = "References", icon = icon("thumbs-up"), tabName = "references"),
        menuItem(text = "Ekarin Eric Pongpipat, M.A.", icon = icon("id-badge"), href = "https://ekarinpongpipat.com", newtab = T)
    )),
    
    # body ----
    dashboardBody(tabItems(
      
      # tab: dashboard ----
      tabItem(
        tabName = "dashboard",
        fluidRow(
          box(title = "Daily Tests", solidHeader = T, status = "primary", width = 12, withSpinner(plotOutput("plot_tests"))),
          box(title = "Daily Positive", solidHeader = T, status = "primary", width = 12, withSpinner(plotOutput("plot_confirmed"))),
          box(title = "Daily Deaths", solidHeader = T, status = "primary", width = 12, withSpinner(plotOutput("plot_deaths"))),
          box(title = "Daily Hospitalization", solidHeader = T, status = "primary", width = 12, withSpinner(plotOutput("plot_hosp"))),
          box(title = "Daily ICU", solidHeader = T, status = "primary", width = 12, withSpinner(plotOutput("plot_icu"))),
          box(title = "Daily Ventilators", solidHeader = T, status = "primary", width = 12, withSpinner(plotOutput("plot_vent"))),
          box(title = "Daily Recovered", solidHeader = T, status = "primary", width = 12, withSpinner(plotOutput("plot_recovered")))
        )
      ), 
      
      # tab: references ----
      tabItem(
        tabName = "references",
        fluidRow(
          box(title = "References", solidHeader = T, status = "primary", width = 12,
              read_lines("citations.md") %>% paste0(., collapse = "\n\n") %>% markdown()),
        )
      )
    )
  )
)
