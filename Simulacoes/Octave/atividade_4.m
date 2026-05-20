% =========================================================================
% ATIVIDADE 04 - Efeito do Janelamento (Hamming/Hann)
% -------------------------------------------------------------------------
% Compara o espectro de um sinal com e sem aplicacao de janela, observando
% a reducao do vazamento espectral (spectral leakage).
% =========================================================================

clear; clc; close all;

% --- Parametros ---
N  = 256;
fs = 1000;
t  = (0:N-1)/fs;

% Frequencia NAO coerente com a grade de FFT -> propositadamente provoca
% vazamento espectral significativo no caso sem janela.
f0 = 100.7;
x  = sin(2*pi*f0*t);

% --- Janelas ---
w_hamming = 0.54 - 0.46*cos(2*pi*(0:N-1)/(N-1));   % Hamming
w_hann    = 0.5  - 0.5 *cos(2*pi*(0:N-1)/(N-1));   % Hann

% --- Sinais janelados ---
x_hamm = x .* w_hamming;
x_hann = x .* w_hann;

% --- Espectros (em dB para evidenciar lobulos laterais) ---
metade = 1:floor(N/2);
f      = (0:N-1)*(fs/N);

mag_ret  = 20*log10(abs(fft(x))      / N + eps);
mag_hamm = 20*log10(abs(fft(x_hamm)) / N + eps);
mag_hann = 20*log10(abs(fft(x_hann)) / N + eps);

% --- Graficos ---
fig = figure('Name','Atividade 04 - Janelamento','Position',[100 100 900 700]);

subplot(2,1,1);
plot(0:N-1, x, 'k:'); hold on;
plot(0:N-1, x_hamm, 'b');
plot(0:N-1, x_hann, 'r');
title('Sinais janelados no dominio do tempo');
xlabel('n'); ylabel('amplitude');
legend('sem janela (retangular)','Hamming','Hann'); grid on;

subplot(2,1,2);
plot(f(metade), mag_ret(metade),  'k-',  'LineWidth', 1); hold on;
plot(f(metade), mag_hamm(metade), 'b-',  'LineWidth', 1);
plot(f(metade), mag_hann(metade), 'r-',  'LineWidth', 1);
title('Espectro de magnitude em dB - comparacao do vazamento espectral');
xlabel('Frequencia (Hz)'); ylabel('|X(f)| (dB)');
legend('Retangular','Hamming','Hann','Location','south'); grid on;
xlim([0 fs/2]); ylim([-100 0]);

fprintf('Observe na escala em dB:\n');
fprintf('  - Janela retangular     -> lobulos laterais altos (~ -13 dB)\n');
fprintf('  - Janela de Hamming     -> lobulos laterais ~ -43 dB\n');
fprintf('  - Janela de Hann        -> lobulos laterais ~ -32 dB\n');
fprintf('Quanto menor o lobulo lateral, menor o vazamento espectral.\n');

% --- Salvar PNG em Resultados/ ---
script_dir = fileparts(mfilename('fullpath'));
out_dir    = fullfile(script_dir, '..', '..', 'Resultados');
if ~exist(out_dir, 'dir'); mkdir(out_dir); end
print(fig, fullfile(out_dir, 'sim4_atividade4_janelamento.png'), '-dpng', '-r120');
fprintf('Figura salva em: %s\n', fullfile(out_dir, 'sim4_atividade4_janelamento.png'));
