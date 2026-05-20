% =========================================================================
% DESAFIO PBL - Analise espectral de um sinal real (vibracao simulada)
% -------------------------------------------------------------------------
% Aplica todas as ferramentas estudadas (FFT, janelamento, identificacao
% de picos) sobre um sinal mais realista, que combina:
%   - rotacao de eixo (1X)
%   - desalinhamento (2X)
%   - falha em pista externa de rolamento (frequencia BPFO)
%   - ruido de fundo
% Apresenta o sinal no tempo, o espectro e a interpretacao fisica.
% =========================================================================

clear; clc; close all;

% --- Parametros de aquisicao ---
fs   = 5000;        % Hz - taxa de amostragem
T    = 2;           % s
t    = 0:1/fs:T-1/fs;
N    = length(t);

% --- "Maquina rotativa" simulada ---
f_rot   = 25;            % Hz (1500 RPM) - frequencia de rotacao
f_align = 2 * f_rot;     % 50 Hz - componente 2X (desalinhamento)
f_bpfo  = 154;           % Hz - frequencia simulada de falha em rolamento

x_rot   = 1.0 * sin(2*pi*f_rot   * t);
x_align = 0.6 * sin(2*pi*f_align * t);

% Falha em rolamento -> modulacao + impulsos repetitivos
x_falha = 0.4 * sin(2*pi*f_bpfo * t) .* (1 + 0.5*sin(2*pi*f_rot*t));

% Ruido de fundo (eletrico/mecanico)
ruido = 0.3 * randn(1, N);

% Sinal observado
x = x_rot + x_align + x_falha + ruido;

% --- Janelamento (Hann) ---
w   = 0.5 - 0.5*cos(2*pi*(0:N-1)/(N-1));
x_w = x .* w;

% --- FFT do sinal janelado ---
metade = 1:floor(N/2);
f      = (0:N-1)*(fs/N);
mag    = abs(fft(x_w))/N;

% --- Localizar picos relevantes ---
alvos = [f_rot f_align f_bpfo];
nomes = {'1X (rotacao)','2X (desalinhamento)','BPFO (rolamento)'};
fprintf('\n  Frequencia esperada | Frequencia detectada |  |X|/N \n');
fprintf('-----------------------+----------------------+--------\n');
for k = 1:length(alvos)
    [~, idx] = min(abs(f - alvos(k)));
    fprintf('  %6.1f Hz  %-12s | %12.2f Hz       | %.4f\n', ...
            alvos(k), nomes{k}, f(idx), mag(idx));
end

% --- Graficos ---
fig = figure('Name','Desafio PBL - Sinal real (vibracao)', ...
             'Position',[100 100 900 800]);

subplot(3,1,1);
plot(t, x);
title('Sinal de vibracao no dominio do tempo');
xlabel('t (s)'); ylabel('a(t)  [m/s^2 simulado]'); grid on;
xlim([0 0.5]);

subplot(3,1,2);
plot(t, x_w);
title('Sinal apos janela de Hann (usado na FFT)');
xlabel('t (s)'); ylabel('x_w(t)'); grid on;
xlim([0 0.5]);

subplot(3,1,3);
plot(f(metade), mag(metade), 'b'); hold on;
xline(f_rot,   'r--', '1X');
xline(f_align, 'g--', '2X');
xline(f_bpfo,  'm--', 'BPFO');
title('Espectro de magnitude - assinatura espectral da maquina');
xlabel('Frequencia (Hz)'); ylabel('|X(f)|/N');
xlim([0 300]); grid on;

fprintf('\nInterpretacao fisica do espectro:\n');
fprintf('  - Picos em 25 e 50 Hz revelam a rotacao do eixo e\n');
fprintf('    o desalinhamento (componente 2X).\n');
fprintf('  - O pico em ~154 Hz, fora dos harmonicos da rotacao, sugere\n');
fprintf('    falha localizada em rolamento (frequencia BPFO).\n');
fprintf('  - O ruido de fundo aparece como um piso espectral mais\n');
fprintf('    elevado, mas nao mascara os picos: e justamente esse\n');
fprintf('    o poder de diagnostico da analise espectral.\n');

% --- Salvar PNG em Resultados/ ---
script_dir = fileparts(mfilename('fullpath'));
out_dir    = fullfile(script_dir, '..', '..', 'Resultados');
if ~exist(out_dir, 'dir'); mkdir(out_dir); end
print(fig, fullfile(out_dir, 'simulacao10desafio.png'), '-dpng', '-r120');
fprintf('Figura salva em: %s\n', fullfile(out_dir, 'simulacao10desafio.png'));
