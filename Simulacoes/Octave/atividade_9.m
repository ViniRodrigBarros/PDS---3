% =========================================================================
% ATIVIDADE 09 - Sinal com fundamental + harmonicos (vibracao mecanica)
% -------------------------------------------------------------------------
% Gera um sinal com uma frequencia principal (1X) e harmonicos (2X, 3X),
% simulando uma assinatura tipica de desbalanceamento + desalinhamento em
% maquinas rotativas. A FFT identifica claramente cada componente.
% =========================================================================

clear; clc; close all;

fs = 2000;          % Hz
T  = 2;             % segundos
t  = 0:1/fs:T-1/fs;
N  = length(t);

% --- Frequencia fundamental e harmonicos ---
f1 = 30;            % Hz - rotacao de eixo (1800 RPM)
% Tipico de diagnostico:
%   1X: desbalanceamento
%   2X: desalinhamento
%   3X: folgas mecanicas
x = 1.0*sin(2*pi*1*f1*t) + ...
    0.5*sin(2*pi*2*f1*t) + ...
    0.3*sin(2*pi*3*f1*t);

% --- FFT ---
metade = 1:floor(N/2);
f      = (0:N-1)*(fs/N);
mag    = abs(fft(x))/N;

% --- Identificacao dos picos ---
candidatos = [1 2 3] * f1;
fprintf('Frequencias esperadas e detectadas:\n');
for k = 1:length(candidatos)
    [~, idx] = min(abs(f - candidatos(k)));
    fprintf('  %dX (%.0f Hz) -> pico em %.1f Hz, |X|/N = %.3f\n', ...
            k, candidatos(k), f(idx), mag(idx));
end

% --- Graficos ---
fig = figure('Name','Atividade 09 - Sinal harmonico','Position',[100 100 900 700]);

subplot(2,1,1);
plot(t(1:500), x(1:500));
title('Sinal de vibracao: fundamental + 2 harmonicos');
xlabel('t (s)'); ylabel('x(t)'); grid on;

subplot(2,1,2);
plot(f(metade), mag(metade), 'LineWidth', 1);
hold on;
for k = 1:length(candidatos)
    xline(candidatos(k), 'r--', sprintf('%dX', k));
end
title('Espectro de magnitude - assinatura espectral 1X / 2X / 3X');
xlabel('Frequencia (Hz)'); ylabel('|X(f)|/N');
xlim([0 200]); grid on;

fprintf('\nInterpretacao em diagnostico de maquinas:\n');
fprintf('  1X muito alto  -> indicio de desbalanceamento\n');
fprintf('  2X dominante   -> indicio de desalinhamento\n');
fprintf('  Harmonicos     -> folgas, falhas em mancais ou engrenagens\n');
fprintf('A FFT eh, portanto, a impressao digital do estado da maquina.\n');

% --- Salvar PNG em Resultados/ ---
script_dir = fileparts(mfilename('fullpath'));
out_dir    = fullfile(script_dir, '..', '..', 'Resultados');
if ~exist(out_dir, 'dir'); mkdir(out_dir); end
print(fig, fullfile(out_dir, 'simulacao9atvd9.png'), '-dpng', '-r120');
fprintf('Figura salva em: %s\n', fullfile(out_dir, 'simulacao9atvd9.png'));
