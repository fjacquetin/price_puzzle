rm(list = ls())

library(tidyverse)
library(lubridate)
library(zoo)
library(vars)
library(openxlsx)

source("utils.R")

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
  filter(date <= as.yearqtr("1979 Q4"))

df_post <- df_us_sub %>%
  filter(date >= as.yearqtr("1980 Q1"))

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

# --- Fonction pour transformer IRF en data.frame long ---


df_irf_pre  <- irf_to_df(irf_pre, impulse_name = "ffr")
df_irf_post <- irf_to_df(irf_post, impulse_name = "ffr")

df_irf_pre$period  <- factor("Pré-1979", levels = c("Pré-1979", "Post-1979"))
df_irf_post$period <- factor("Post-1979", levels = c("Pré-1979", "Post-1979"))

df_irf_all <- bind_rows(df_irf_pre, df_irf_post)

# Plot comparatif
ggplot(df_irf_all, aes(x = horizon, y = irf, color = period, fill = period)) +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = 0.15, color = NA) +
  geom_line(size = 1.2) +
  facet_grid(variable ~ period, scales = "free_y") +
  scale_color_manual(values = c("Pré-1979" = "red", "Post-1979" = "blue")) +
  scale_fill_manual(values = c("Pré-1979" = "red", "Post-1979" = "blue")) +
  labs(title = "Comparaison des IRFs du choc de taux", x = "Horizon (trimestres)", y = "Réponse") +
  theme_minimal(base_size = 13) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold"),
    strip.text = element_text(face = "bold")
  )

# --- Affichage empilé (optionnel) ---
#g_pre / g_post



ggsave(
  "sorties/figures/IRF_pre_post_Cholesky.png",
  final_plot,
  width = 10, height = 12, dpi = 300
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


# --- Paramètres
Sigma <- cov(resid(var_pre))
P <- t(chol(Sigma))
n.sim <- 5000
H <- 12
N <- ncol(Y_pre_ts)

# --- Companion matrix
A_raw <- vars::Bcoef(var_pre)
if (is.list(A_raw)) {
  A <- do.call(cbind, A_raw)
} else {
  A <- A_raw
}

A_no_const <- A[, 1:(N*var_pre$p)]
A_big[1:N, 1:(N*var_pre$p)] <- A_no_const

if (var_pre$p > 1) {
  A_big[(N+1):(N*var_pre$p), 1:(N*(var_pre$p-1))] <- diag(N*(var_pre$p-1))
}

# --- IRF manuelle
manual_irf <- function(B, H) {
  irf_mat <- matrix(0, H, N)
  A_power <- diag(1, N*var_pre$p)
  for (h in 1:H) {
    A_power <- A_big %*% A_power
    irf_mat[h, ] <- (A_power[1:N, 1:N] %*% B)[,1]
  }
  colnames(irf_mat) <- colnames(Y_pre_ts)
  return(irf_mat)
}

# --- Simulation avec sign restrictions
irfs_kept <- list()
count <- 0
set.seed(123)

for (i in 1:n.sim) {
  Z <- matrix(rnorm(N*N), N, N)
  Q <- qr.Q(qr(Z))
  B <- P %*% Q
  
  irf_B <- manual_irf(B, H)
  
  dy_response   <- irf_B[1, "y_gap"]
  taux_response <- irf_B[1, "ffr"]
  
  if (taux_response >= 0 && dy_response <= 0) {
    count <- count + 1
    irfs_kept[[count]] <- irf_B
  }
}

percent_kept <- count / n.sim * 100
cat(percent_kept,"% de simulations vérifient les sign restrictions")

# --- Conversion en tidy data
irf_df <- map_dfr(irfs_kept, ~as.data.frame(.x) %>% mutate(h = 1:H), .id = "sim") %>%
  pivot_longer(cols = -c(sim, h), names_to = "variable", values_to = "irf")

# --- Calcul des statistiques
irf_summary <- irf_df %>%
  group_by(h, variable) %>%
  summarise(
    mean = mean(irf),
    lower68 = quantile(irf, 0.16),
    upper68 = quantile(irf, 0.84),
    lower90 = quantile(irf, 0.05),
    upper90 = quantile(irf, 0.95),
    .groups = "drop"
  )

ggplot(irf_summary, aes(x = h, y = mean)) +
  geom_line(size = 1.2, color = "black") + # lignes noires, ou color distincte si tu veux
  geom_ribbon(aes(ymin = lower68, ymax = upper68), alpha = 0.3, fill = "blue") +
  geom_ribbon(aes(ymin = lower90, ymax = upper90), alpha = 0.15, fill = "lightblue") +
  labs(x = "Horizon", y = "IRF", title = "Réponses à un choc monétaire (sign restrictions)") +
  theme_minimal() +
  facet_wrap(~variable, scales = "free_y")  # <- ici la bonne colonne


## Modèle 3 : avec anticipations d'inflation

green <- read.xlsx("data/greenbook.xlsx")

df <- df_pre %>%
  mutate(date=gsub(" ","",date)) %>%
  inner_join(green,by="date") 

df_inf <- df %>% dplyr::select(date,pi,green)  %>%
  mutate(
    pi = as.numeric(pi),
    green = as.numeric(green),
    date = as.yearqtr(date, format = "%YQ%q")  # conversion en date trimestrielle
  )

ggplot(df_inf, aes(x = date)) +
  theme_minimal() +
  geom_line(aes(y = pi, color = "pi"), linewidth = 1) +
  geom_line(aes(y = green, color = "exp"), linewidth = 1) +
  scale_color_manual(values = c("pi" = "blue", "exp" = "darkgreen")) +
  labs(
    x = "Date",
    y = "Valeur",
    color = "Variable",
    title = "Évolution de pi et green"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

df_ts <- df_to_ts(df)

select_exp  <- VARselect(df_ts,  lag.max = 8, type = "const")

lags_exp  <- select_exp$selection["SC(n)"]

VAR_exp <- VAR(df_ts,  p = lags_exp,  type = "const")

irf_exp <- irf(
  VAR_exp,
  # impulse = "ffr",
  response = c("green","y_gap", "pi", "ffr"),
  n.ahead = 20,
  boot = TRUE,
  runs = 500,
  ortho = TRUE  # Cholesky
)

plot(irf_exp)
