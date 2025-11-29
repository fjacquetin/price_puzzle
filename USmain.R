rm(list = ls())


library(tidyverse)
library(lubridate)
library(zoo)
library(fredr)
library(openxlsx)
library(mFilter)   # pour hpfilter

select <- dplyr::select  # pour éviter les conflits


fredr_set_key("2081d90b146ea654a4866e909178bfaf")

# 1. PIB réel (Real GDP) 

gdp_real <- fredr(
  series_id = "GDPC1",
  observation_start = as.Date("1960-01-01")
) %>%
  transmute(
    date   = as.yearqtr(date),
    y_real = log(value)
  ) %>%
  arrange(date)

# 2. "Output gap" 

hp_res <- hpfilter(gdp_real$y_real, freq = 1600)

gdp_real <- gdp_real %>%
  mutate(
    y_trend = as.numeric(hp_res$trend),
    y_gap   = 100 * (y_real - y_trend)
  )

ogap <- gdp_real %>%
  transmute(
    date,
    y_gap = as.numeric(y_gap)
  )

# 3. GDP deflator -> inflation 

gdpdef <- fredr(
  series_id = "GDPDEF",
  observation_start = as.Date("1960-01-01")
) %>%
  transmute(
    date = as.yearqtr(date),
    p_gdp = log(value)
  ) %>%
  arrange(date)

pi_gdp <- gdpdef %>%
  mutate(
    pi = 400 * (p_gdp - lag(p_gdp))    # inflation trimestrielle annualisée
  ) %>%
  drop_na() %>%
  select(date, pi)

# 4. Federal Funds Rate (FEDFUNDS) trimestriel -

ffr_m <- fredr(
  series_id = "FEDFUNDS",
  observation_start = as.Date("1960-01-01")
) %>%
  transmute(
    date_m = as.yearmon(date),
    ffr = value
  )

ffr_q <- ffr_m %>%
  mutate(
    date = as.yearqtr(date_m)
  ) %>%
  group_by(date) %>%
  summarise(
    ffr = mean(ffr, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  arrange(date)

# 5. Merge des séries US 

df_us <- ogap %>%
  full_join(pi_gdp, by = "date") %>%
  full_join(ffr_q,  by = "date") %>%
  arrange(date)


print(head(df_us, 10))
print(tail(df_us, 10))

# 6. Sauvegarde --

dir.create("sorties", showWarnings = FALSE)

write_csv(df_us, "sorties/data_us.csv")
write.xlsx(df_us, file = "sorties/data_us.xlsx", overwrite = TRUE)