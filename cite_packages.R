# get citations
packages <-
  c(
    "shiny",
    "shinydashboard",
    "shinycssloaders",
    "shinythemes",
    "dplyr",
    "ggplot2",
    "purrr",
    "TTR",
    "tidyr",
    "COVID19",
    "grateful",
    "base",
    "readr"
  ) %>%
  sort() %>%
  unique()

cites <- get_citations(packages)
rmd <- create_rmd(cites)
render_citations(rmd, "md")
