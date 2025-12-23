
# Charger la série mensuelle WTI 
oil_m <- fredr::fredr(
  series_id = "PPIIDC", #PPIACO
  observation_start = as.Date("1960-01-01")
) %>%
  transmute(
    date_m = as.yearmon(date),
    oil    = value
  ) %>%
  drop_na(oil)

oil_q <- oil_m %>%
  mutate(date = as.yearqtr(date_m)) %>%
  group_by(date) %>%
  summarise(oil = mean(oil), .groups = "drop") %>%
  mutate(
    oil_log = log(oil),
    poil    = 400 * (oil_log - dplyr::lag(oil_log))   # inflation du pétrole
  ) %>%
  dplyr::select(date, poil) %>%
  drop_na()

# Fusion avec données US (y_gap, pi, ffr)
df_us_oil <- df_us %>%
  inner_join(oil_q, by = "date") %>%
  arrange(date) %>%
  dplyr::select(date,poil,y_gap,pi,ffr)

# Définir les 3 sous-périodes
df_pre_oil <- df_us_oil %>% filter(date <= as.yearqtr("1979 Q4"))
df_post_oil <- df_us_oil %>% filter(date >= as.yearqtr("1980 Q1"),
                                    date <= as.yearqtr("2006 Q2"))
df_end_oil <- df_us_oil %>% filter(date >= as.yearqtr("2009 Q4"),
                                   date <= as.yearqtr("2019 Q4"))

Y_pre_ts_oil  <- df_to_ts(df_pre_oil)
Y_post_ts_oil <- df_to_ts(df_post_oil)
Y_end_ts_oil  <- df_to_ts(df_end_oil)

# Choix des lags
p_pre_oil  <- VARselect(Y_pre_ts_oil,  lag.max = 8)$selection["SC(n)"]
p_post_oil <- VARselect(Y_post_ts_oil, lag.max = 8)$selection["SC(n)"]
p_end_oil  <- VARselect(Y_end_ts_oil,  lag.max = 16)$selection["SC(n)"]

# Estimation VAR
var_pre_oil  <- VAR(Y_pre_ts_oil,  p = p_pre_oil,  type = "const")
var_post_oil <- VAR(Y_post_ts_oil, p = p_post_oil, type = "const")
var_end_oil  <- VAR(Y_end_ts_oil,  p = p_end_oil,  type = "const")

# IRFs Cholesky
irf_pre_oil  <- irf(var_pre_oil,  impulse="ffr", response=c("y_gap","pi","poil","ffr"),
                    n.ahead=20, boot=TRUE, runs=500, ortho=TRUE)
irf_post_oil <- irf(var_post_oil, impulse="ffr", response=c("y_gap","pi","poil","ffr"),
                    n.ahead=20, boot=TRUE, runs=500, ortho=TRUE)
irf_end_oil  <- irf(var_end_oil,  impulse="ffr", response=c("y_gap","pi","poil","ffr"),
                    n.ahead=20, boot=TRUE, runs=500, ortho=TRUE)

# Mise en forme tidy
df1 <- irf_to_df(irf_pre_oil, "ffr")  %>% mutate(period = "Pré-1979")
df2 <- irf_to_df(irf_post_oil, "ffr") %>% mutate(period = "Post-1979")
df3 <- irf_to_df(irf_end_oil, "ffr")  %>% mutate(period = "Post-2007")

df_irf_oil <- bind_rows(df1, df2, df3) %>%
  mutate(period = factor(period, levels=c("Pré-1979","Post-1979","Post-2007")))

# Affichage clean
p_oil <- ggplot(df_irf_oil) +
  geom_ribbon(aes(x = horizon, ymin = lower, ymax = upper, fill = period),
              alpha = 0.15, color = NA) +
  geom_line(aes(x = horizon, y = irf, color = period), size = 1) +
  facet_grid(variable ~ period, scales = "free_y") +
  scale_color_manual(values = c("Pré-1979" = "red",
                                "Post-1979" = "blue",
                                "Post-2007" = "green")) +
  scale_fill_manual(values = c("Pré-1979" = "red",
                               "Post-1979" = "blue",
                               "Post-2007" = "green")) +
  labs(title = "IRFs to a monetary policy shock (VAR with Oil)",
       x = "Horizon (quarters)", y = NULL) +
  theme_minimal(base_size = 12) +
  theme(
    strip.text  = element_text(face = "bold"),
    plot.title  = element_text(face = "bold", hjust = 0.5)
  )

print(p_oil)
```
