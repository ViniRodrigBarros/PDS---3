% =========================================================================
% ATIVIDADE 02 - Soma de duas senoides e analise da FFT
% -------------------------------------------------------------------------
% Gera duas senoides de frequencias distintas, soma-as e calcula a FFT do
% resultado, verificando se o espectro distingue as duas componentes.
% =========================================================================

clear; clc; close all;

% --- Parametros ---
N  = 512;
fs = 1000;             % Hz - taxa de amostragem fisica
t  = (0:N-1)/fs;       % vetor de tempo em segundos

f1 = 50;   A1 = 1.0;   % primeira componente
f2 = 120;  A2 = 0.7;   % segunda componente

% --- Geracao dos sinais ---
x1 = A1*sin(2*pi*f1*t);
x2 = A2*sin(2*pi*f2*t);
x  = x1 + x2;

% --- FFT do sinal combinado ---
X   = fft(x);
mag = abs(X)/N;
f   = (0:N-1)*(fs/N);            % eixo de frequencia em Hz
metade = 1:floor(N/2);

% --- Identificacao dos dois picos ---
[picos, locs] = findpeaks_simple(mag(metade), 0.1*max(mag(metade)));
fprintf('Frequencias detectadas no espectro:\n');
for k = 1:length(locs)
    fprintf('  f = %7.2f Hz  |  |X|/N = %.3f\n', f(locs(k)), picos(k));
end

% --- Graficos ---
fig = figure('Name','Atividade 02 - Soma de senoides','Position',[100 100 900 700]);

subplot(3,1,1);
plot(t, x1, 'b'); hold on; plot(t, x2, 'r');
title('Componentes individuais x_1(t) e x_2(t)');
xlabel('t (s)'); ylabel('amplitude');
legend(sprintf('f_1 = %d Hz', f1), sprintf('f_2 = %d Hz', f2));
grid on;

subplot(3,1,2);
plot(t, x);
title('Sinal resultante x(t) = x_1(t) + x_2(t)');
xlabel('t (s)'); ylabel('x(t)'); grid on;

subplot(3,1,3);
stem(f(metade), mag(metade), 'filled');
title('Espectro de magnitude do sinal somado');
xlabel('Frequencia (Hz)'); ylabel('|X(f)|/N'); grid on;
xlim([0 fs/2]);

% --- Salvar PNG em Resultados/ ---
script_dir = fileparts(mfilename('fullpath'));
out_dir    = fullfile(script_dir, '..', '..', 'Resultados');
if ~exist(out_dir, 'dir'); mkdir(out_dir); end
print(fig, fullfile(out_dir, 'sim2_atividade2_duas_senoides.png'), '-dpng', '-r120');
fprintf('Figura salva em: %s\n', fullfile(out_dir, 'sim2_atividade2_duas_senoides.png'));

% NOTA: a funcao auxiliar findpeaks_simple esta em arquivo separado
% (findpeaks_simple.m) na mesma pasta — funciona automaticamente.
