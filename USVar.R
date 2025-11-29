rm(list = ls())

library(tidyverse)
library(lubridate)
library(zoo)
library(vars)
library(openxlsx)

# 1. Charger les données 

df_us <- read_csv("sorties/data_us.csv",
                  show_col_types = FALSE) %>%
  mutate(date = as.yearqtr(date))

# 2. Restriction de l'échantillon comme dans l'article -
# 1966Q1–2006Q4, puis coupure 1979Q3/1979Q4

df_us_sub <- df_us %>%
  filter(
    date >= as.yearqtr("1966 Q1"),
    date <= as.yearqtr("2006 Q4")
  ) %>%
  drop_na(y_gap, pi, ffr)

# 3. Construire deux sous-échantillons pré-/post-Volcker 

df_pre  <- df_us_sub %>%
  filter(date <= as.yearqtr("1979 Q3"))

df_post <- df_us_sub %>%
  filter(date >= as.yearqtr("1979 Q4"))

# Petit check
cat("Pré-1979 : ", min(df_pre$date), "->", max(df_pre$date), " (n = ", nrow(df_pre), ")\n")
cat("Post-1979:", min(df_post$date), "->", max(df_post$date), " (n = ", nrow(df_post), ")\n")

# 4. Mettre les données au format ts pour VAR ------

Y_pre <- df_pre %>%
  dplyr::select(y_gap, pi, ffr)

Y_post <- df_post %>%
  dplyr::select(y_gap, pi, ffr)

Y_pre_ts <- ts(
  Y_pre,
  start = c(as.integer(format(min(df_pre$date), "%Y")),
            as.integer(cycle(min(df_pre$date)))),  # trimestre de départ
  frequency = 4
)

Y_post_ts <- ts(
  Y_post,
  start = c(as.integer(format(min(df_post$date), "%Y")),
            as.integer(cycle(min(df_post$date)))),
  frequency = 4
)

# 5. Choix des lags (BIC / SC)

lags_pre  <- VARselect(Y_pre_ts,  lag.max = 8, type = "const")
lags_post <- VARselect(Y_post_ts, lag.max = 8, type = "const")

print(lags_pre$selection)
print(lags_post$selection)

p_pre  <- lags_pre$selection["SC(n)"]
p_post <- lags_post$selection["SC(n)"]

cat("Lags retenus (pré)  :", p_pre,  "\n")
cat("Lags retenus (post) :", p_post, "\n")

# dans le papier 2 lags pré, 4 lags post
# p_pre  <- 2
# p_post <- 4

# 6. Estimation des VAR -

var_pre <- VAR(Y_pre_ts,  p = p_pre,  type = "const")
var_post <- VAR(Y_post_ts, p = p_post, type = "const")

summary(var_pre)
summary(var_post)

# 7. IRFs avec identification Cholesky 

irf_pre <- irf(
  var_pre,
  impulse = "ffr",
  response = c("y_gap", "pi", "ffr"),
  n.ahead = 20,
  boot = TRUE,
  runs = 500,
  ortho = TRUE  # Cholesky
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

# 8. Sauvegarder les IRFs en graphiques 

dir.create("sorties/figures", showWarnings = FALSE)

pdf("sorties/figures/IRF_pre_Cholesky.pdf", width = 8, height = 6)
plot(irf_pre)
dev.off()

pdf("sorties/figures/IRF_post_Cholesky.pdf", width = 8, height = 6)
plot(irf_post)
dev.off()

# Exporter les IRFs en tableau pour latex / rapport 

# Fonction utilitaire pour extraire les IRFs sous forme de tibble
irf_to_tibble <- function(irf_obj, regime_label) {
  # irf_obj$irf est une liste par variable réponse
  # irf_obj$Lower / Upper idem pour les bandes
  responses <- names(irf_obj$irf)
  out <- map_dfr(responses, function(resp) {
    tibble(
      horizon = 0:(nrow(irf_obj$irf[[resp]]) - 1),
      response = resp,
      irf     = as.numeric(irf_obj$irf[[resp]][, "ffr"]),
      lower   = as.numeric(irf_obj$Lower[[resp]][, "ffr"]),
      upper   = as.numeric(irf_obj$Upper[[resp]][, "ffr"]),
      regime  = regime_label
    )
  })
  out
}

irf_pre_tbl  <- irf_to_tibble(irf_pre,  "pre79")
irf_post_tbl <- irf_to_tibble(irf_post, "post79")

irf_all <- bind_rows(irf_pre_tbl, irf_post_tbl)

write_csv(irf_all, "sorties/IRF_Cholesky_pre_post.csv")