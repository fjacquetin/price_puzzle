rm(list = ls())

library(tidyverse)
library(lubridate)
library(zoo)
library(vars)
library(openxlsx)
library(patchwork)

source("utils.R")

# ------------------------------------------------------------
# 1. Charger les données 
# ------------------------------------------------------------

select <- dplyr::select
df_us <- read_csv("sorties/data_us.csv",
                  show_col_types = FALSE) %>%
  mutate(date = as.yearqtr(date))

# ------------------------------------------------------------
# 2. Restriction de l'échantillon 
# ------------------------------------------------------------

df_us_sub <- df_us %>%
  filter(
    date >= as.yearqtr("1966 Q1"),
    date <= as.yearqtr("2006 Q4")
  ) %>%
  drop_na(y_gap, pi, ffr)

# ------------------------------------------------------------
# 3. Deux sous-échantillons 
# ------------------------------------------------------------

df_pre  <- df_us_sub %>%
  filter(date <= as.yearqtr("1979 Q3"))

df_post <- df_us_sub %>%
  filter(date >= as.yearqtr("1979 Q4"))

cat("Pré-1979 : ", min(df_pre$date), "->", max(df_pre$date), " (n =", nrow(df_pre), ")\n")
cat("Post-1979:", min(df_post$date), "->", max(df_post$date), " (n =", nrow(df_post), ")\n")

# ------------------------------------------------------------
# 4. Format ts pour VAR 
# ------------------------------------------------------------

Y_pre <- df_pre %>% select(y_gap, pi, ffr)
Y_post <- df_post %>% select(y_gap, pi, ffr)

Y_pre_ts <- ts(
  Y_pre,
  start = c(as.integer(format(min(df_pre$date), "%Y")),
            as.integer(cycle(min(df_pre$date)))),
  frequency = 4
)

Y_post_ts <- ts(
  Y_post,
  start = c(as.integer(format(min(df_post$date), "%Y")),
            as.integer(cycle(min(df_post$date)))),
  frequency = 4
)

# ------------------------------------------------------------
# 5. Choix des lags (BIC)
# ------------------------------------------------------------

lags_pre  <- VARselect(Y_pre_ts,  lag.max = 8, type = "const")
lags_post <- VARselect(Y_post_ts, lag.max = 8, type = "const")

print(lags_pre$selection)
print(lags_post$selection)

p_pre  <- lags_pre$selection["SC(n)"]
p_post <- lags_post$selection["SC(n)"]

cat("Lags retenus (pré)  :", p_pre,  "\n")
cat("Lags retenus (post) :", p_post, "\n")

# ------------------------------------------------------------
# 6. Estimation des VAR
# ------------------------------------------------------------

var_pre  <- VAR(Y_pre_ts,  p = p_pre,  type = "const")
var_post <- VAR(Y_post_ts, p = p_post, type = "const")

# ------------------------------------------------------------
# 7. IRFs (Cholesky)
# ------------------------------------------------------------

irf_pre <- irf(
  var_pre,
  impulse = "ffr",
  response = c("y_gap", "pi", "ffr"),
  n.ahead = 20,
  boot = TRUE,
  runs = 500,
  ortho = TRUE
)

irf_post <- irf(
  var_post,
  impulse = "ffr",
  response = c("y_gap", "pi", "ffr"),
  n.ahead = 20,
  boot = TRUE,
  runs = 500,
  ortho = TRUE
)

# ------------------------------------------------------------
# 1. Conversion IRF → tibble pour ggplot
# ------------------------------------------------------------
irf_to_df <- function(irf_obj) {
  map_dfr(names(irf_obj$irf), function(resp) {
    
    mat_irf   <- as.data.frame(irf_obj$irf[[resp]])
    mat_lower <- as.data.frame(irf_obj$Lower[[resp]])
    mat_upper <- as.data.frame(irf_obj$Upper[[resp]])
    
    tibble(
      horizon = 0:(nrow(mat_irf)-1),
      y_gap   = mat_irf$y_gap,
      pi      = mat_irf$pi,
      ffr     = mat_irf$ffr,
      lower_y_gap = mat_lower$y_gap,
      lower_pi    = mat_lower$pi,
      lower_ffr   = mat_lower$ffr,
      upper_y_gap = mat_upper$y_gap,
      upper_pi    = mat_upper$pi,
      upper_ffr   = mat_upper$ffr
    ) %>%
      pivot_longer(
        cols = c(y_gap, pi, ffr),
        names_to = "variable",
        values_to = "irf"
      ) %>%
      pivot_longer(
        cols = starts_with("lower_"),
        names_to = "lower_var",
        values_to = "lower"
      ) %>%
      pivot_longer(
        cols = starts_with("upper_"),
        names_to = "upper_var",
        values_to = "upper"
      ) %>%
      filter(
        variable == sub("lower_", "", lower_var),
        variable == sub("upper_", "", upper_var)
      ) %>%
      select(horizon, variable, irf, lower, upper)
  })
}

# ------------------------------------------------------------
# 2. Créer les dataframes IRF et ajouter la période
# ------------------------------------------------------------
df_irf_pre  <- irf_to_df(irf_pre)  %>% mutate(period = "Pré-1979")
df_irf_post <- irf_to_df(irf_post) %>% mutate(period = "Post-1979")

df_all <- bind_rows(df_irf_pre, df_irf_post)

df_all <- df_all %>%
  mutate(period = factor(period, levels = c("Pré-1979", "Post-1979")))

# ------------------------------------------------------------
# 3. Plot final
# ------------------------------------------------------------
plot_irf_ffr <- function(df) {
  ggplot(df, aes(x = horizon, y = irf)) +
    geom_hline(yintercept = 0, linewidth = 0.4, alpha = 0.7) +
    geom_ribbon(aes(ymin = lower, ymax = upper), alpha = 0.15, fill = "steelblue") +
    geom_line(linewidth = 1, color = "steelblue") +
    facet_grid(variable ~ period, scales = "free_y") +
    labs(
      x = "Horizon",
      y = "Réponse",
      title = "Réponses des variables à un choc de FFR : Pré- vs Post-1979"
    ) +
    theme_minimal(base_size = 13) +
    theme(
      plot.title = element_text(face = "bold", size = 15, hjust = 0.5),
      strip.text = element_text(face = "bold", size = 12),
      panel.grid.minor = element_blank()
    )
}

# Affichage
final_plot <- plot_irf_ffr(df_all)
final_plot

# ------------------------------------------------------------
# 11. Affichage
# ------------------------------------------------------------

final_plot <- plot_irf_ffr(df_all)
final_plot



# ------------------------------------------------------------
# 10. Export PNG
# ------------------------------------------------------------

dir.create("sorties/figures", showWarnings = FALSE)

ggsave(
  "sorties/figures/IRF_pre_post_Cholesky.png",
  final_plot,
  width = 10, height = 12, dpi = 300
)
