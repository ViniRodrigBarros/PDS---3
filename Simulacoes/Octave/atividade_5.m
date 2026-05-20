% =========================================================================
% ATIVIDADE 05 - Senoide com ruido aditivo
% -------------------------------------------------------------------------
% Gera uma senoide somada a ruido branco gaussiano e demonstra como a
% analise espectral permite identificar a componente util em meio ao ruido.
% =========================================================================

clear; clc; close all;

% --- Parametros ---
N      = 1024;
fs     = 1000;
t      = (0:N-1)/fs;
f0     = 60;          % Hz - frequencia "util"
A      = 1.0;
sigma  = 1.2;         % desvio padrao do ruido (SNR ~ -3 dB)

% --- Sinal + ruido ---
s = A*sin(2*pi*f0*t);
r = sigma * randn(1, N);
x = s + r;

snr_db = 10*log10( (A^2/2) / sigma^2 );
fprintf('SNR aproximado do sinal: %.2f dB\n', snr_db);

% --- FFT ---
metade = 1:floor(N/2);
f      = (0:N-1)*(fs/N);
mag    = abs(fft(x))/N;

% --- Identificacao da frequencia dominante ---
[~, idx] = max(mag(metade));
fprintf('Frequencia dominante detectada na FFT: %.2f Hz (esperado %.1f)\n', ...
        f(idx), f0);

% --- Graficos ---
fig = figure('Name','Atividade 05 - Sinal com ruido','Position',[100 100 900 700]);

subplot(3,1,1);
plot(t, s, 'b');
title('Sinal util s(t) - senoide pura');
xlabel('t (s)'); ylabel('s(t)'); grid on;

subplot(3,1,2);
plot(t, x, 'k');
title('Sinal observado x(t) = s(t) + ruido');
xlabel('t (s)'); ylabel('x(t)'); grid on;

subplot(3,1,3);
plot(f(metade), mag(metade), 'r');
hold on;
plot(f(idx), mag(idx), 'bo', 'MarkerSize', 8, 'LineWidth', 2);
title('Espectro de magnitude - a senoide aparece como pico nitido');
xlabel('Frequencia (Hz)'); ylabel('|X(f)|/N'); grid on;
xlim([0 fs/2]);

fprintf('\nNo dominio do tempo, o sinal parece dominado por ruido.\n');
fprintf('No dominio da frequencia, a componente em %.0f Hz se destaca\n', f0);
fprintf('claramente, pois sua energia esta CONCENTRADA em uma frequencia,\n');
fprintf('enquanto o ruido branco espalha sua energia por toda a banda.\n');

% --- Salvar PNG em Resultados/ ---
script_dir = fileparts(mfilename('fullpath'));
out_dir    = fullfile(script_dir, '..', '..', 'Resultados');
if ~exist(out_dir, 'dir'); mkdir(out_dir); end
print(fig, fullfile(out_dir, 'sim5_atividade5_senoide_ruido.png'), '-dpng', '-r120');
fprintf('Figura salva em: %s\n', fullfile(out_dir, 'sim5_atividade5_senoide_ruido.png'));
