# load libraries ----
library("dplyr")

# region summary ----
region_summary <- list(
  "World" = list(level = 0, population = 7349000000), # estimated from 2015 from https://en.wikipedia.org/wiki/World_population
  "USA" = list(level = 1, population = 326687501), # rest are estimations from the COVID19 package
  "Thailand" = list(level = 1, population = 69428524),
  "Guatemala" = list(level = 1, population = 17247807),
  "California" = list(level = 2, population = 39512223),
  "Texas" = list(level = 2, population = 28995881),
  "Dallas" = list(level = 3, population = 2635516),
  "Los Angeles" = list(level = 3, population = 10039107)
)

print("# get data ----")
df_all <- NULL
metrics_of_interest <- c('tests', 
                         'confirmed', 
                         'recovered', 
                         'deaths', 
                         'hosp', 
                         'vent', 
                         'icu')

print("## counties data ----")
# counties ----
df_temp <- read.csv(url("https://storage.covid19datahub.io/data-3.csv")) %>%
  mutate(date = as.Date(date)) %>%
  ungroup() %>%
  filter(administrative_area_level_2 %in% c("California", "Texas"),
         administrative_area_level_3 %in% c("Dallas", "Los Angeles")) %>%
  select(date, region = administrative_area_level_3, all_of(metrics_of_interest))
df_all <- rbind(df_all, df_temp)
rm(df_temp)

print("## states data ----")
# states ----
df_temp <- read.csv(url("https://storage.covid19datahub.io/data-2.csv")) %>%
  mutate(date = as.Date(date)) %>%
  ungroup() %>%
  filter(administrative_area_level_2 %in% c("California", "Texas")) %>%
  select(date, region = administrative_area_level_2, all_of(metrics_of_interest))
df_all <- rbind(df_all, df_temp)

print("## world data ----")
# world ----
df_temp <- read.csv(url("https://storage.covid19datahub.io/data-1.csv")) %>%
  mutate(date = as.Date(date)) %>%
  ungroup() %>%
  group_by(date) %>%
  summarize(tests = sum(tests),
            confirmed = sum(confirmed),
            recovered = sum(recovered),
            deaths = sum(deaths),
            hosp = sum(hosp),
            vent = sum(vent),
            icu = sum(icu)) %>% 
  mutate(region = 'World')
df_all <- rbind(df_all, df_temp)

print("## countries data ----")
# countries ----
df_temp <- read.csv(url("https://storage.covid19datahub.io/data-1.csv")) %>%
  mutate(date = as.Date(date)) %>%
  filter(administrative_area_level_1 %in% c("United States", "Thailand", "Guatemala")) %>%
  select(date, region = id, all_of(metrics_of_interest)) %>%
  ungroup() %>%
  mutate(region = case_when(
    region == 'GTM' ~ "Guatemala",
    region == 'THA' ~ "Thailand",
    region == 'USA' ~ "USA"
  ))
df_all <- rbind(df_all, df_temp)
rm(df_temp)

print("# transform data ----")
print("## daily data ----")
# get daily data ----
df_daily <- df_all %>%
  arrange(date) %>%
  group_by(region) %>%
  mutate(tests = c(NA, diff(tests)),
         confirmed = c(NA, diff(confirmed)),
         recovered = c(NA, diff(recovered)),
         deaths = c(NA, diff(deaths)),
  ) %>%
  ungroup()
rm(df_all)

print("## long format ----")
# get long format ----
df_long <- df_daily %>%
  tidyr::pivot_longer(., -c(date, region), names_to = 'metric') %>%
 na.omit()
rm(df_daily)

print("## 7-day moving average ----")
# get 7-day moving average ----
df_sma7 <- df_long %>%
  arrange(date) %>%
  group_by(region, metric) %>%
  mutate(value_sma7 = TTR::SMA(value, 7)) %>%
  tidyr::pivot_longer(., c(value, value_sma7), names_to = 'smooth', values_to = 'value') %>%
  mutate(smooth = ifelse(smooth == 'value_sma7', T, F)) %>%
  ungroup() %>%
  na.omit()
rm(df_long)

# get respective percent of population ----
print("## percent population ----")
df_perc_pop <- df_sma7 %>%
  arrange(date) %>%
  group_by(region, metric) %>%
  mutate(perc_pop = NA)
for (i in 1:nrow(df_perc_pop)) {
  region_idx <- which(df_perc_pop$region[i]==names(region_summary))
  df_perc_pop$perc_pop[i] <- df_perc_pop$value[i]/as.numeric(region_summary[[region_idx]]$population)
}

print("## percent of respective world metric ----")
# get respective percent of world metric ----
df_world_temp <- df_sma7 %>%
  arrange(date) %>%
  filter(region == "World") %>%
  select(date, metric, smooth, smooth, world_value = value)
df_world <- full_join(df_sma7, df_world_temp, by = c("date", "metric", "smooth")) %>%
  mutate(perc_world_metric = ifelse(world_value > 0, value / world_value, 0)) %>%
  select(-world_value)
rm(df_world_temp)

print("## per 1K ----")
# get per thousand ----
df_per_thousand <- df_sma7 %>%
  arrange(date) %>%
  group_by(region, metric) %>%
  mutate(per_thousand = value / 10^3)

df_per_tests_temp <- df_sma7 %>%
  filter(metric == "tests") %>%
  select(-metric) %>%
  rename(value_tests = value)
df_per_tests <- full_join(df_sma7, df_per_tests_temp, by = c("date", "region", "smooth")) %>%
  mutate(perc_tests = ifelse(value_tests > 0, value / value_tests, 0))
rm(df_per_tests_temp)

print("## combine ----")
df <- full_join(df_sma7, df_perc_pop, by = c("date", "region", "metric", "smooth", "value")) %>%
  full_join(., df_world, by = c("date", "region", "metric", "smooth", "value")) %>%
  full_join(., df_per_thousand, by = c("date", "region", "metric", "smooth", "value")) %>%
  full_join(., df_per_tests, by = c("date", "region", "metric", "smooth", "value")) %>%
  tidyr::pivot_longer(., c("value", "perc_pop", "perc_world_metric", "per_thousand", "perc_tests"), names_to = "y_axis") %>%
  mutate(y_axis = ifelse(y_axis == "value", "raw", y_axis)) %>%
  na.omit()
rm(df_sma7, df_perc_pop, df_world, df_per_thousand, df_per_tests)

df_unreliable <- df %>%
  select(region, metric, value) %>%
  group_by(region, metric) %>%
  unique() %>%
  tidyr::nest() %>%
  mutate(n_data = purrr::map_int(data, nrow)) %>%
  select(-data) %>%
  mutate(reliable = ifelse(n_data == 1, F, T)) %>%
  filter(reliable == F) %>%
  select(region, metric)