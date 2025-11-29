clc; clear;

% Ajouter Dynare
addpath('C:\dynare\6.3\matlab');

% Lancer Dynare
dynare nk_model.mod noclearall;

% Sauvegarder les IRFs dans un fichier .mat
save('irfs.mat', 'oo_');

% Optionnel : tracer dans MATLAB
figure;
subplot(3,1,1);
plot(oo_.irfs.x_eb); title('Output gap'); grid on;

subplot(3,1,2);
plot(oo_.irfs.pi_eb); title('Inflation'); grid on;

subplot(3,1,3);
plot(oo_.irfs.int_eb); title('Interest rate'); grid on;