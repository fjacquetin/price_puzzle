library(tidyverse)

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
  # Convertir la colonne date en yearqtr
  period <- as.yearqtr(data[[date_col]], format = "%Y Q%q")
  
  # Extraire année et trimestre pour le premier point
  start_year <- as.numeric(format(period[1], "%Y"))
  start_quarter <- as.numeric(format(period[1], "%q"))
  
  # Retirer la colonne date
  data2 <- data[, !(names(data) == date_col), drop = FALSE]
  
  # Créer la ts trimestrielle
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


irf_to_df <- function(irf_obj, impulse_name = "ffr") {
  # Horizon
  horizon <- 0:(nrow(irf_obj$irf[[impulse_name]]) - 1)
  
  # Data frame long
  df <- data.frame(irf_obj$irf[[impulse_name]]) %>%
    mutate(horizon = horizon) %>%
    pivot_longer(cols = -horizon, names_to = "variable", values_to = "irf") %>%
    mutate(
      lower = as.vector(t(irf_obj$Lower[[impulse_name]])),
      upper = as.vector(t(irf_obj$Upper[[impulse_name]]))
    )
  
  return(df)
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