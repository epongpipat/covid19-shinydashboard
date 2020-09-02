df_la <- NULL
df_temp <- read.csv("https://raw.githubusercontent.com/datadesk/california-coronavirus-data/master/latimes-county-totals.csv") %>%
  filter(county == "Los Angeles") %>%
  select(date, region = county, confirmed = new_confirmed_cases, deaths = new_deaths) %>%
  tidyr::pivot_longer(., -c(date, region), names_to = 'metric')
df_la <- df_temp

df_temp <- read.csv("https://raw.githubusercontent.com/datadesk/california-coronavirus-data/master/cdph-hospital-patient-county-totals.csv") %>%
  filter(county == "Los Angeles") %>%
  select(date, 
         region = county, 
         hosp = positive_patients,
         icu = icu_positive_patients) %>%
  tidyr::pivot_longer(., -c(date, region), names_to = 'metric')
df_la <- rbind(df_la, df_temp)
rm(df_temp)