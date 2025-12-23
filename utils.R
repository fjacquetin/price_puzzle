transform_df <- function(df, table, diff=TRUE) {
  
  df_transformed <- df
  
  for (i in seq_len(nrow(table))) {
    var <- table$variable[i]
    do_log <- table$log[i] == "Oui"
    do_diff <- table$diff[i] == "Oui"
    
    if (var %in% colnames(df_transformed)) {
      x <- df_transformed[[var]]
      
      if (do_log) x <- log(x)
      if (do_diff==TRUE & diff==TRUE) x <- c(NA, 100*diff(x))
      
      df_transformed[[var]] <- x
    } else {
      warning(paste("Variable", var, "non trouvée dans df"))
    }
  }
  
  return(df_transformed)
}

df_to_ts <- function(data, date_col = "date") {
  period <- as.yearqtr(data[[date_col]], format = "%Y Q%q")
  
  start_year <- as.numeric(format(period[1], "%Y"))
  start_quarter <- as.numeric(format(period[1], "%q"))
  
  data2 <- data[, !(names(data) == date_col), drop = FALSE]
  
  ts(data2, start = c(start_year, start_quarter), frequency = 4)
}


ts_to_df <- function(data_ts){
  
  data_df <- as.data.frame(data_ts)
  freq <- frequency(data_ts)
  date_ts <- time(data_ts)
  date_df <- convert_to_quarter(date_ts)
  df_date <- data.frame(date=date_df)
  data <- cbind(df_date,data_df)
  
  return(data)
}

convert_to_quarter <- function(ts_index) {
  year <- floor(ts_index)
  quarter <- ((ts_index - year) * 4) + 1
  quarter_label <- paste0(year, "Q", quarter)
  return(quarter_label)
}

restrict_base <- function (df,variables=NULL,start=NULL,end=NULL){
  df <- df %>%
    select(date,variables)
  df_ts <- df_to_ts(df)
  if (is.null(start)) {
    start <- start(df_ts)
  }
  if (is.null(end)) {
    end <- end(df_ts)
  }
  if(is.null(variables)) {
    variables <- colnames(df_ts)
  }
  
  df <- window(df_ts,start = c(1999,1),end=c(2019,4))

  return(df)
}

irf_to_df <- function(irf_obj, impulse_name) {
  
  stopifnot(
    impulse_name %in% names(irf_obj$irf),
    impulse_name %in% names(irf_obj$Lower),
    impulse_name %in% names(irf_obj$Upper)
  )
  
  irf_mat   <- irf_obj$irf[[impulse_name]]
  lower_mat <- irf_obj$Lower[[impulse_name]]
  upper_mat <- irf_obj$Upper[[impulse_name]]
  
  horizons <- seq_len(nrow(irf_mat)) - 1
  vars     <- colnames(irf_mat)
  
  tibble(
    horizon  = rep(horizons, times = length(vars)),
    variable = rep(vars, each = length(horizons)),
    irf      = as.vector(irf_mat),
    lower    = as.vector(lower_mat),
    upper    = as.vector(upper_mat)
  )
}

plot_irf <- function(df, title = "") {
  p <- ggplot(df, aes(x = horizon, y = irf)) +
    geom_ribbon(aes(ymin = lower, ymax = upper), fill = "red", alpha = 0.15) +
    geom_line(size = 1.2, color = "red") +
    facet_wrap(~variable, scales = "free_y", ncol = 1) +
    labs(title = title, x = "Horizon (trimestres)", y = "Réponse") +
    theme_minimal(base_size = 13) +
    theme(
      plot.title = element_text(face = "bold"),
      strip.text = element_text(face = "bold")
    )
  return(p)
}



manual_irf <- function(B, A_big, N, p, H, var_names){
  irf_mat <- matrix(0, H, N)
  A_power <- diag(1, N*p)
  
  # h = 0
  irf_mat[1, ] <- B[, 1]
  
  # h = 1,...,H-1
  for(h in 2:H){
    A_power <- A_big %*% A_power
    irf_mat[h, ] <- (A_power[1:N, 1:N] %*% B)[, 1]
  }
  
  colnames(irf_mat) <- var_names
  irf_mat
}

get_greenbook_forecast <- function(df_long, h = 1) {
  
  stopifnot(h %in% 1:4)
  
  df_long %>%
    mutate(
      # trimestre courant
      quarter_start = make_date(year, (qtr - 1) * 3 + 1, 1),
      
      # trimestre cible t+h
      target_quarter_start = quarter_start %m+% months(3 * h),
      
      # trimestre d'information t+h-1
      info_quarter_start = quarter_start %m+% months(3 * (h - 1)),
      info_quarter_end   = info_quarter_start %m+% months(3)
    ) %>%
    
    # premier vintage du trimestre précédent le trimestre cible
    filter(
      vintage_date >= info_quarter_start,
      vintage_date <  info_quarter_end
    ) %>%
    
    group_by(year, qtr) %>%
    arrange(vintage_date) %>%   # le plus tôt possible
    slice(1) %>%
    ungroup() %>%
    
    transmute(
      quarter = paste0(year, "Q", qtr),
      target_quarter = paste0(
        year(target_quarter_start),
        "Q",
        lubridate::quarter(target_quarter_start)
      ),
      horizon = h,
      green_forecast = forecast,
      vintage_date
    )
}

# --------------------------------------------------
# IRF MANUELLE – choc explicitement sur ffr
# --------------------------------------------------
manual_irf <- function(B, A_big, N, p, H, var_names, shock = "ffr"){
  
  shock_id <- match(shock, var_names)
  if (is.na(shock_id)) stop("Shock variable not found")
  
  irf <- matrix(0, H, N)
  colnames(irf) <- var_names
  
  # Choc orthogonal canonique
  e <- rep(0, N)
  e[shock_id] <- 1
  
  # h = 0
  irf[1, ] <- B %*% e
  
  A_power <- diag(1, N * p)
  
  # h = 1,...,H-1
  for (h in 2:H) {
    A_power <- A_big %*% A_power
    irf[h, ] <- A_power[1:N, 1:N] %*% (B %*% e)
  }
  
  irf
}


# --------------------------------------------------
# Règle de restriction de signe (choc monétaire)
# --------------------------------------------------
sr_monetary <- function(irf){
  irf[1,"ffr"] > 0 && irf[1,"y_gap"] < 0
}

sr_monetary2 <- function(irf){
  irf[1,"ffr"] > 0
}

compute_sr_irf <- function(
    var_fit,
    restrictions = NULL,   # 🔑 par défaut : aucune restriction
    horizon = 12,
    n.sim = 5000,
    model_name = "Sign restrictions",
    seed = 123
){
  set.seed(seed)
  
  Y <- var_fit$y
  N <- ncol(Y)
  p <- var_fit$p
  var_names <- colnames(Y)
  
  # Matrice de variance-covariance et Cholesky
  Sigma <- cov(resid(var_fit))
  P <- t(chol(Sigma))
  
  # Matrice companion
  A_raw <- vars::Bcoef(var_fit)
  A <- if (is.list(A_raw)) do.call(cbind, A_raw) else A_raw
  
  A_big <- matrix(0, N * p, N * p)
  A_big[1:N, 1:(N * p)] <- A[, 1:(N * p)]
  if (p > 1)
    A_big[(N + 1):(N * p), 1:(N * (p - 1))] <- diag(N * (p - 1))
  
  # Simulations
  irfs <- list()
  k <- 0
  
  for (i in 1:n.sim) {
    Q <- qr.Q(qr(matrix(rnorm(N * N), N, N)))
    B <- P %*% Q
    colnames(B) <- var_names
    
    irf_B <- manual_irf(
      B, A_big, N, p,
      H = horizon + 1,
      var_names = var_names
    )
    
    # 🔒 règle d'acceptation
    accept <- if (is.null(restrictions)) TRUE else restrictions(irf_B)
    
    if (accept) {
      k <- k + 1
      irfs[[k]] <- irf_B
    }
  }
  
  # Mise en forme finale
  purrr::map_dfr(
    irfs,
    ~ as.data.frame(.x) %>%
      mutate(horizon = 0:horizon),
    .id = "sim"
  ) %>%
    pivot_longer(
      cols = -c(sim, horizon),
      names_to = "variable",
      values_to = "irf"
    ) %>%
    group_by(horizon, variable) %>%
    summarise(
      mean     = mean(irf),
      lower68 = quantile(irf, 0.16),
      upper68 = quantile(irf, 0.84),
      lower90 = quantile(irf, 0.05),
      upper90 = quantile(irf, 0.95),
      .groups = "drop"
    ) %>%
    rename(irf=mean) %>%
    mutate(model = model_name)
}

compute_sr_irf <- function(
    var_fit,
    restrictions = NULL,
    horizon = 12,
    n.sim = 5000,
    model_name = "Sign restrictions",
    seed = 123
){
  
  set.seed(seed)
  
  Y <- var_fit$y
  N <- ncol(Y)
  p <- var_fit$p
  var_names <- colnames(Y)
  
  # Cholesky
  Sigma <- cov(resid(var_fit))
  P <- t(chol(Sigma))
  
  # Companion matrix
  A_raw <- vars::Bcoef(var_fit)
  A <- if (is.list(A_raw)) do.call(cbind, A_raw) else A_raw
  
  A_big <- matrix(0, N*p, N*p)
  A_big[1:N, 1:(N*p)] <- A[, 1:(N*p)]
  if (p > 1)
    A_big[(N+1):(N*p), 1:(N*(p-1))] <- diag(N*(p-1))
  
  # =========================
  # STOCKAGE COMPLET
  # =========================
  irfs_all  <- vector("list", n.sim)
  B_all     <- vector("list", n.sim)
  accepted  <- logical(n.sim)
  
  for (i in 1:n.sim) {
    
    Q <- qr.Q(qr(matrix(rnorm(N*N), N, N)))
    B <- P %*% Q
    colnames(B) <- var_names
    
    irf_B <- manual_irf(
      B, A_big, N, p,
      H = horizon + 1,
      var_names = var_names,
      shock = "ffr"
    )
    
    irfs_all[[i]] <- irf_B
    B_all[[i]]    <- B
    
    accepted[i] <- if (is.null(restrictions)) TRUE else restrictions(irf_B)
  }
  
  # =========================
  # IRFs ACCEPTÉES — résumé
  # =========================
  irf_summary <- purrr::map_dfr(
    irfs_all[accepted],
    ~ as.data.frame(.x) %>% mutate(horizon = 0:horizon),
    .id = "sim"
  ) %>%
    pivot_longer(
      cols = -c(sim, horizon),
      names_to = "variable",
      values_to = "irf"
    ) %>%
    group_by(horizon, variable) %>%
    summarise(
      mean     = mean(irf),
      lower68 = quantile(irf, 0.16),
      upper68 = quantile(irf, 0.84),
      lower90 = quantile(irf, 0.05),
      upper90 = quantile(irf, 0.95),
      .groups = "drop"
    ) %>%
    rename(irf=mean) %>%
    mutate(model = model_name)
  
  # =========================
  # SORTIE COMPLÈTE
  # =========================
  list(
    irf_summary = irf_summary,     # bandes + moyenne
    irfs_all    = irfs_all,        # TOUTES les IRFs
    irfs_kept   = irfs_all[accepted],
    B_all       = B_all,           # TOUS les B
    B_kept      = B_all[accepted],
    accepted    = accepted
  )
}

