y_axis_list <- c(
  "Number of People" = "raw",
  "Per Thousand" = "per_thousand",
  "% of Respective Region's Population" = "perc_pop",
  "% of Respective Region's Tests" = "perc_tests",
  "% of Respective World's Metric" = "perc_world_metric"
)

x_axis_list <- c(
  "Date" = "date",
  "Days Since First Confirmed" = "days_since_first_confirmed"
)

get_y_axis_value <- function(y_axis_name) {
  as.character(y_axis_list[which(y_axis_name == names(y_axis_list))])
}

get_x_axis_value <- function(x_axis_name) {
  as.character(x_axis_list[which(x_axis_name == names(x_axis_list))])
}