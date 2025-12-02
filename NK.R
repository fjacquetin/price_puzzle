library(ggplot2)
library(dplyr)
library(tidyr)
library(R.matlab)

## Execute with matlab


matlab_exec <- "C:/Program Files/MATLAB/R2024b/bin/matlab.exe"

system(sprintf('"%s" -batch "run(\'compute_nk_model.m\')"', matlab_exec))

# Charger le .mat
mat_data <- readMat("sorties/irfs.mat")
# Extraire la liste oo_ (c'est la matrice 1x1)
oo_matrix <- mat_data$oo.         # c'est une matrice 1x1

# Extraire les IRFs (liste)
irfs_list <- oo_matrix[[20]]


# Chaque IRF est souvent une cellule contenant un vecteur
x_eb <- as.numeric(irfs_list[[6]])
pi_eb <- as.numeric(irfs_list[[7]])
int_eb <- as.numeric(irfs_list[[8]])

# Créer un dataframe long pour ggplot
irf_df <- data.frame(
  Period = 1:length(x_eb),
  `OutputGap (%)` = x_eb,
  `Inflation (pp)` = pi_eb,
  `InterestRate (pp)` = int_eb,
  check.names = FALSE
) %>%
  pivot_longer(cols = -Period, names_to = "Variable", values_to = "IRF")

# Plot ggplot avec facettes
ggplot(irf_df, aes(x = Period, y = IRF, color = Variable)) +
  theme_minimal(base_size = 14) +
  geom_line(size = 1.2) +
  facet_wrap(~Variable, ncol = 1, scales = "free_y") +
  labs(title = "IRFs to a MP shock in a NK model",
       x = "Periods",
       y = "Response") +
  geom_hline(yintercept = 0, color = "grey", linetype = "solid") + 
  geom_vline(xintercept = 0, color = "grey", linetype = "solid") +
  theme(legend.position = "none",
        strip.text = element_text(face = "bold", size = 12),
        panel.grid.major = element_line(color = "gray90"))

