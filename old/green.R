df <- read.xlsx("data/gPGDP_1967_1984.xlsx")
df2 <- read.xlsx("data/gPGDP_1985_Last.xlsx")

df_long <- df %>%
  mutate(Date = as.character(Date)) %>%
  separate(
    Date,
    into = c("year", "qtr"),
    sep = "\\.",
    convert = TRUE
  ) %>%
  pivot_longer(
    cols = starts_with("gPGDP_"),
    names_to = "vintage",
    values_to = "forecast"
  ) %>%
  mutate(
    vintage_date = ymd(substr(vintage, 7, 14)),
    quarter_start = make_date(year, (qtr - 1) * 3 + 1, 1),
    target_quarter_start = quarter_start %m+% months(3)
  ) %>%
  filter(!is.na(forecast))

selected_forecasts <- df_long %>%
  mutate(
    is_before = vintage_date < target_quarter_start,
    distance_days = abs(as.numeric(vintage_date - target_quarter_start))
  ) %>%
  group_by(year, qtr) %>%
  arrange(
    desc(is_before),      
    distance_days       
  ) %>%
  slice(1) %>%
  ungroup()

result <- selected_forecasts %>%
  transmute(
    quarter = paste0(year, "Q", qtr),
    target_quarter = paste0(
      year(target_quarter_start),
      "Q",
      lubridate::quarter(target_quarter_start)
    ),
    forecast_next_q = forecast,
    vintage_date
  ) %>%
  slice(-c(1:4)) %>%
  slice(-((n() - 3):n()))

df2_long <- df2 %>%
  mutate(Date = as.character(Date)) %>%
  separate(
    Date,
    into = c("year", "qtr"),
    sep = "\\.",
    convert = TRUE
  ) %>%
  pivot_longer(
    cols = starts_with("gPGDP_"),
    names_to = "vintage",
    values_to = "forecast"
  ) %>%
  mutate(
    vintage_date = ymd(substr(vintage, 7, 14)),
    quarter_start = make_date(year, (qtr - 1) * 3 + 1, 1),
    target_quarter_start = quarter_start %m+% months(3)
  ) %>%
  filter(!is.na(forecast))

selected_forecasts2 <- df2_long %>%
  mutate(
    is_before = vintage_date < target_quarter_start,
    distance_days = abs(as.numeric(vintage_date - target_quarter_start))
  ) %>%
  group_by(year, qtr) %>%
  arrange(
    desc(is_before),      
    distance_days       
  ) %>%
  slice(1) %>%
  ungroup()

result2 <- selected_forecasts2 %>%
  transmute(
    quarter = paste0(year, "Q", qtr),
    target_quarter = paste0(
      year(target_quarter_start),
      "Q",
      lubridate::quarter(target_quarter_start)
    ),
    forecast_next_q = forecast,
    vintage_date
  ) %>%
  slice(-c(1:4)) %>%
  slice(-((n() - 7):n()))

result

final <- rbind(result,result2)
