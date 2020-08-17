y_axis_list <- c(
  "Number of People" = "raw",
  "Per Thousand" = "per_thousand",
  "% of Respective Region's Population" = "perc_pop",
  "% of Respective Region's Tests" = "perc_tests",
  "% of Respective World's Metric" = "perc_world_metric"
)

get_y_axis_value <- function(y_axis_name) {
  as.character(y_axis_list[which(y_axis_name == names(y_axis_list))])
}