# load libraries ----
library(dplyr)
library(ggplot2)

# load data ----
source("get_data.R")

# load functions ----
source("create_fig.R")
source("get_axes.R")

# dashboard-server ----
shinyServer(function(input, output) {
    
    # reactive y_axis value ----
    y_axis_value <- reactive({
        get_y_axis_value(input$y_axis)
    })
    
    
    x_axis_value <- reactive({
        get_x_axis_value(input$x_axis)
    })
    
    # figures ----
    output$plot_confirmed <- renderPlot({
        viz(
            df,
            regions = as.character(input$regions),
            metrics = "confirmed",
            #log_value = input$log,
            smooth_value = input$smooth,
            y_axis_value = y_axis_value(),
            y_lab = input$y_axis,
            x_axis = x_axis_value(),
            x_lab = input$x_axis
        )
    })
    
    output$plot_hosp <- renderPlot({
        viz(
            df,
            regions = as.character(input$regions),
            metrics = "hosp",
            smooth_value = input$smooth,
            y_axis_value = y_axis_value(),
            y_lab = input$y_axis,
            x_axis = x_axis_value(),
            x_lab = input$x_axis
        )
    })
    
    output$plot_icu <- renderPlot({
        viz(
            df,
            regions = as.character(input$regions),
            metrics = "icu",
            smooth_value = input$smooth,
            y_axis_value = y_axis_value(),
            y_lab = input$y_axis,
            x_axis = x_axis_value(),
            x_lab = input$x_axis
        )
    })
    
    output$plot_vent <- renderPlot({
        viz(
            df,
            regions = as.character(input$regions),
            metrics = "vent",
            smooth_value = input$smooth,
            y_axis_value = y_axis_value(),
            y_lab = input$y_axis,
            x_axis = x_axis_value(),
            x_lab = input$x_axis
        )
    })
    
    output$plot_deaths <- renderPlot({
        viz(
            df,
            regions = as.character(input$regions),
            metrics = "deaths",
            smooth_value = input$smooth,
            y_axis_value = y_axis_value(),
            y_lab = input$y_axis,
            x_axis = x_axis_value(),
            x_lab = input$x_axis
        )
    })
    
    output$plot_recovered <- renderPlot({
        viz(
            df,
            regions = as.character(input$regions),
            metrics = "recovered",
            smooth_value = input$smooth,
            y_axis_value = y_axis_value(),
            y_lab = input$y_axis,
            x_axis = x_axis_value(),
            x_lab = input$x_axis
        )
    })
    
    output$plot_tests <- renderPlot({
        viz(
            df,
            regions = as.character(input$regions),
            metrics = "tests",
            smooth_value = input$smooth,
            y_axis_value = y_axis_value(),
            y_lab = input$y_axis,
            x_axis = x_axis_value(),
            x_lab = input$x_axis
        )
    })
    
})
