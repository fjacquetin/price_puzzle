
## Ce script exécute, via matlab


matlab_exec <- "C:/Program Files/MATLAB/R2024b/bin/matlab.exe"

system(sprintf('"%s" -batch "run(\'compute_nk_model.m\')"', matlab_exec))
