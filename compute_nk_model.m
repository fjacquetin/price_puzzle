%% Script MATLAB pour simuler le fichier .mod Dynare

clc; clear;


addpath('C:\dynare\6.3\matlab'); 

dynare nk_model.mod noclearall

save('sorties/irfs.mat', 'oo_');

% IRF of monetary policy shock
figure;
subplot(3,1,1);
plot(oo_.irfs.x_eb); title('Output gap'); grid on;

subplot(3,1,2);
plot(oo_.irfs.pi_eb); title('Inflation'); grid on;

subplot(3,1,3);
plot(oo_.irfs.int_eb); title('Interest rate'); grid on;