% =========================================================================
% ATIVIDADE 03 - Efeito de Aliasing
% -------------------------------------------------------------------------
% Demonstra o fenomeno de aliasing reduzindo a taxa de amostragem de uma
% senoide de frequencia elevada. Compara os espectros antes e depois.
% =========================================================================

clear; clc; close all;

% --- Parametros do sinal "continuo" (alta taxa) ---
f_sig = 180;          % Hz - frequencia da senoide
fs1   = 1000;         % taxa de amostragem ADEQUADA   (fs1 > 2*f_sig)
fs2   = 200;          % taxa de amostragem INSUFICIENTE (fs2 < 2*f_sig)

T = 1;                % 1 segundo de sinal
t1 = 0:1/fs1:T-1/fs1;
t2 = 0:1/fs2:T-1/fs2;

x1 = sin(2*pi*f_sig*t1);
x2 = sin(2*pi*f_sig*t2);   % mesma senoide, amostrada com fs2

% --- FFT dos dois sinais ---
N1 = length(x1);  X1 = fft(x1);  f1 = (0:N1-1)*(fs1/N1);  mag1 = abs(X1)/N1;
N2 = length(x2);  X2 = fft(x2);  f2 = (0:N2-1)*(fs2/N2);  mag2 = abs(X2)/N2;

% --- Frequencia "alias" esperada quando fs < 2*f_sig ---
% Quando f_sig > fs/2, a senoide aparece em |f_sig - k*fs| dobrada em fs/2
f_alias = abs(f_sig - round(f_sig/fs2)*fs2);
fprintf('Frequencia original   : %.1f Hz\n', f_sig);
fprintf('fs adequado (Nyquist) : %.1f Hz  -> sem aliasing\n', fs1);
fprintf('fs reduzido           : %.1f Hz  -> alias em %.1f Hz\n', fs2, f_alias);

% --- Graficos ---
fig = figure('Name','Atividade 03 - Aliasing','Position',[100 100 1000 700]);

subplot(2,2,1);
plot(t1(1:200), x1(1:200));
title(sprintf('Sinal amostrado a %d Hz (fs > 2f)', fs1));
xlabel('t (s)'); ylabel('x(t)'); grid on;

subplot(2,2,2);
stem(f1(1:floor(N1/2)), mag1(1:floor(N1/2)), 'filled');
title('Espectro - sem aliasing');
xlabel('Frequencia (Hz)'); ylabel('|X|/N'); grid on;
xlim([0 fs1/2]);

subplot(2,2,3);
stem(t2(1:40), x2(1:40), 'filled');
title(sprintf('Sinal amostrado a %d Hz (fs < 2f)', fs2));
xlabel('t (s)'); ylabel('x[n]'); grid on;

subplot(2,2,4);
stem(f2(1:floor(N2/2)), mag2(1:floor(N2/2)), 'filled');
hold on;
plot(f_alias, max(mag2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
text(f_alias, max(mag2), sprintf('  alias = %.0f Hz', f_alias), ...
     'VerticalAlignment','bottom');
title('Espectro - com aliasing');
xlabel('Frequencia (Hz)'); ylabel('|X|/N'); grid on;
xlim([0 fs2/2]);

% --- Salvar PNG em Resultados/ ---
script_dir = fileparts(mfilename('fullpath'));
out_dir    = fullfile(script_dir, '..', '..', 'Resultados');
if ~exist(out_dir, 'dir'); mkdir(out_dir); end
print(fig, fullfile(out_dir, 'simulacao3atvd3.png'), '-dpng', '-r120');
fprintf('Figura salva em: %s\n', fullfile(out_dir, 'simulacao3atvd3.png'));
