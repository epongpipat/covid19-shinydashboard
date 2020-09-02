# counties: dallas ----
temp_path <- tempfile()
df_dallas <- NULL

### confirmed ----
download.file("https://dshs.texas.gov/coronavirus/TexasCOVID19DailyCountyCaseCountData.xlsx", temp_path)
df_temp <- readxl::read_excel(temp_path, skip = 2, col_names = TRUE) %>%
  rename(region = `County Name`) %>%
  filter(region == "Dallas") %>%
  tidyr::pivot_longer(., -region, names_to = "date", values_to = "value") %>%
  mutate(date = stringr::str_remove(date, "Cases "),
         date = stringr::str_remove_all(date, "\r"),
         date = stringr::str_remove_all(date, "\n"),
         date = stringr::str_remove_all(date, "[*]"),
         date = stringr::str_squish(date),
         date = as.Date(paste0("2020-", date)),
         value = c(NA, diff(value)),
         metric = "confirmed")
df_dallas <- df_temp
rm(df_temp)

### fatalities ----
download.file("https://dshs.texas.gov/coronavirus/TexasCOVID19DailyCountyFatalityCountData.xlsx", temp_path)
df_temp <- readxl::read_excel(temp_path, skip = 2, col_names = TRUE) %>%
  rename(region = `County Name`) %>%
  filter(region == "Dallas") %>%
  tidyr::pivot_longer(., -region, names_to = "date", values_to = "value") %>%
  mutate(date = stringr::str_remove(date, "Fatalities "),
         date = paste0("2020-", date),
         date = as.Date(date),
         metric = 'deaths',
         value = c(NA, diff(value)))
df_dallas <- rbind(df_dallas, df_temp)
rm(df_temp)

### tests ----
download.file("https://dshs.texas.gov/coronavirus/TexasCOVID-19CumulativeTestsOverTimebyCounty.xlsx", temp_path)
df_temp <- readxl::read_excel(temp_path, skip = 1, col_names = T) %>%
  rename(region = `County`) %>%
  filter(region == "Dallas") %>%
  as.matrix() %>%
  as.data.frame() %>%
  tidyr::pivot_longer(., -region, names_to = "date", values_to = "value") %>%
  mutate(date = stringr::str_remove(date, "Tests Through "),
         date = as.Date(lubridate::parse_date_time(paste0(date, ", 2020"), orders = "bd,y")),
         value = stringr::str_remove_all(value, "-"),
         value = as.numeric(value),
         value = c(NA, diff(value)),
         metric = 'tests')
df_dallas <- rbind(df_dallas, df_temp)
rm(df_temp)

# hospitalization
# this is for DFW metroplex
download.file("https://dshs.texas.gov/coronavirus/TexasCOVID-19HospitalizationsOverTimebyTSA.xlsx", temp_path)
df_temp <- readxl::read_excel(temp_path, skip = 2, col_names = T) %>%
  rename(region = `TSA AREA`) %>%
  filter(region == "Dallas/Ft. Worth") %>%
  mutate(region = "Dallas") %>%
  select(-'TSA ID') %>%
  tidyr::pivot_longer(., -region, names_to = "date", values_to = "value") %>%
  mutate(value = as.numeric(value),
         metric = 'hosp')
excel_date_idx <- which(is.na(as.Date(df_temp$date)))
fixed_dates <- as.character(as.Date(as.numeric(df_temp$date[excel_date_idx]), origin = "1899-12-30"))
df_temp <- df_temp %>%
  mutate(date = as.Date(date))
df_temp$date[excel_date_idx] <- fixed_dates
df_dallas <- rbind(df_dallas, df_temp) %>%
  mutate(value = as.integer(value))
rm(df_temp, temp_path, fixed_dates, excel_date_idx)

