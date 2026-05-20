% =========================================================================
% ATIVIDADE 08 - Resolucao espectral em funcao do numero de amostras
% -------------------------------------------------------------------------
% Compara a resolucao espectral obtida pela FFT de dois sinais com a mesma
% frequencia fundamental, mas com numero de amostras diferente.
% =========================================================================

clear; clc; close all;

fs = 1000;          % Hz
f1 = 100;           % Hz - duas componentes proximas
f2 = 108;           % Hz

% --- Caso A: poucas amostras (baixa resolucao) ---
N_A = 64;
t_A = (0:N_A-1)/fs;
x_A = sin(2*pi*f1*t_A) + sin(2*pi*f2*t_A);
f_axisA = (0:N_A-1)*(fs/N_A);
mag_A   = abs(fft(x_A))/N_A;
df_A    = fs/N_A;

% --- Caso B: muitas amostras (alta resolucao) ---
N_B = 1024;
t_B = (0:N_B-1)/fs;
x_B = sin(2*pi*f1*t_B) + sin(2*pi*f2*t_B);
f_axisB = (0:N_B-1)*(fs/N_B);
mag_B   = abs(fft(x_B))/N_B;
df_B    = fs/N_B;

fprintf('Diferenca de frequencia entre as componentes: %.2f Hz\n', f2-f1);
fprintf('Resolucao com N = %4d  -> df = %.3f Hz  (componentes %s)\n', ...
        N_A, df_A, sep_status(df_A, f2-f1));
fprintf('Resolucao com N = %4d  -> df = %.3f Hz  (componentes %s)\n', ...
        N_B, df_B, sep_status(df_B, f2-f1));

% --- Graficos ---
fig = figure('Name','Atividade 08 - Resolucao espectral','Position',[100 100 900 700]);

subplot(2,1,1);
plot(f_axisA(1:N_A/2), mag_A(1:N_A/2), 'b-o','LineWidth',1);
title(sprintf('N = %d  (df = %.2f Hz) - resolucao BAIXA', N_A, df_A));
xlabel('f (Hz)'); ylabel('|X|/N'); grid on;
xlim([80 140]);

subplot(2,1,2);
plot(f_axisB(1:N_B/2), mag_B(1:N_B/2), 'r-','LineWidth',1);
title(sprintf('N = %d  (df = %.2f Hz) - resolucao ALTA', N_B, df_B));
xlabel('f (Hz)'); ylabel('|X|/N'); grid on;
xlim([80 140]);

fprintf('\nA resolucao espectral eh df = fs/N. Para distinguir duas\n');
fprintf('frequencias proximas, df deve ser MENOR que a separacao entre\n');
fprintf('elas. Aumentar N (observar o sinal por mais tempo) e o caminho\n');
fprintf('direto para melhorar a resolucao em frequencia.\n');

% --- Salvar PNG em Resultados/ ---
script_dir = fileparts(mfilename('fullpath'));
out_dir    = fullfile(script_dir, '..', '..', 'Resultados');
if ~exist(out_dir, 'dir'); mkdir(out_dir); end
print(fig, fullfile(out_dir, 'sim8_atividade8_resolucao.png'), '-dpng', '-r120');
fprintf('Figura salva em: %s\n', fullfile(out_dir, 'sim8_atividade8_resolucao.png'));

% NOTA: a funcao auxiliar sep_status esta em arquivo separado
% (sep_status.m) na mesma pasta — funciona automaticamente.
