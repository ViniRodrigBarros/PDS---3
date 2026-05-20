% =========================================================================
% ATIVIDADE 01 - Senoide discreta + FFT
% -------------------------------------------------------------------------
% Gera uma senoide discreta de frequencia normalizada f0 = 0.1 com N = 128
% amostras, exibe o sinal no dominio do tempo e calcula seu espectro via
% FFT, identificando a frequencia dominante.
% =========================================================================

clear; clc; close all;

% --- Parametros do sinal ---
N  = 128;          % numero de amostras
f0 = 0.1;          % frequencia normalizada (ciclos/amostra)
n  = 0:N-1;        % vetor de indices de tempo discreto

% --- Geracao da senoide discreta ---
x = sin(2*pi*f0*n);

% --- Calculo da FFT ---
X     = fft(x);                 % espectro complexo
mag   = abs(X)/N;               % magnitude normalizada
f_nrm = (0:N-1)/N;              % frequencia normalizada (0 a 1)

% --- Identificacao da frequencia dominante (somente metade do espectro) ---
metade        = 1:floor(N/2);
[pico, idx]   = max(mag(metade));
freq_pico     = f_nrm(idx);

fprintf('Frequencia dominante detectada: f = %.4f (esperado %.4f)\n', ...
        freq_pico, f0);
fprintf('Magnitude do pico: %.4f\n', pico);

% --- Graficos ---
fig = figure('Name','Atividade 01 - Senoide + FFT','Position',[100 100 900 600]);

subplot(2,1,1);
stem(n, x, 'filled');
title('Sinal no dominio do tempo: x[n] = sin(2\pi f_0 n)');
xlabel('n (amostras)'); ylabel('x[n]'); grid on;

subplot(2,1,2);
stem(f_nrm(metade), mag(metade), 'filled');
hold on;
plot(freq_pico, pico, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
text(freq_pico, pico, sprintf('  f_0 = %.2f', freq_pico), ...
     'VerticalAlignment','bottom');
title('Espectro de magnitude |X[k]| (FFT)');
xlabel('Frequencia normalizada'); ylabel('|X[k]|/N'); grid on;

% --- Salvar PNG em Resultados/ ---
script_dir = fileparts(mfilename('fullpath'));
out_dir    = fullfile(script_dir, '..', '..', 'Resultados');
if ~exist(out_dir, 'dir'); mkdir(out_dir); end
print(fig, fullfile(out_dir, 'simulacao1atvd1.png'), '-dpng', '-r120');
fprintf('Figura salva em: %s\n', fullfile(out_dir, 'simulacao1atvd1.png'));
