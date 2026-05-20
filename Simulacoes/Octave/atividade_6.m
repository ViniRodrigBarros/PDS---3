% =========================================================================
% ATIVIDADE 06 - DFT direta (definicao) vs. funcao fft
% -------------------------------------------------------------------------
% Implementa a DFT diretamente a partir da definicao matematica e compara
% o resultado com a saida da funcao fft. Avalia o erro numerico e o custo
% computacional.
% =========================================================================

clear; clc; close all;

% --- Sinal curto para inspecao ---
N = 16;
n = 0:N-1;
x = cos(2*pi*0.125*n) + 0.5*sin(2*pi*0.25*n);

% --- DFT direta pela definicao: X[k] = sum_{n=0}^{N-1} x[n] e^{-j2*pi*k*n/N}
X_direta = zeros(1, N);
tic;
for k = 0:N-1
    soma = 0;
    for nn = 0:N-1
        soma = soma + x(nn+1) * exp(-1j*2*pi*k*nn/N);
    end
    X_direta(k+1) = soma;
end
t_direta = toc;

% --- DFT via algoritmo FFT ---
tic;
X_fft = fft(x);
t_fft = toc;

% --- Comparacao numerica ---
erro_max = max(abs(X_direta - X_fft));

fprintf('Resultado do experimento (N = %d):\n', N);
fprintf('--------------------------------------------\n');
fprintf('Tempo DFT direta : %.6f s   ( O(N^2)     = %d ops )\n', ...
        t_direta, N*N);
fprintf('Tempo FFT        : %.6f s   ( O(N log N) = %d ops )\n', ...
        t_fft, round(N*log2(N)));
fprintf('Erro maximo absoluto entre as duas saidas: %.2e\n', erro_max);

% --- Comparacao para N grande: apenas custo, sem rodar DFT direta enorme ---
Ns = [16 64 256 1024 4096];
fprintf('\nEstimativa de operacoes em funcao de N:\n');
fprintf('   N    |   DFT (N^2)   |   FFT (N log N)\n');
fprintf('--------+---------------+----------------\n');
for k = 1:length(Ns)
    fprintf(' %5d  | %12d  | %12d\n', ...
            Ns(k), Ns(k)^2, round(Ns(k)*log2(Ns(k))));
end

% --- Graficos ---
fig = figure('Name','Atividade 06 - DFT direta vs FFT','Position',[100 100 900 700]);

subplot(2,1,1);
stem(n, x, 'filled');
title('Sinal de entrada x[n]');
xlabel('n'); ylabel('x[n]'); grid on;

subplot(2,1,2);
stem(0:N-1, abs(X_direta), 'bo', 'LineWidth', 1.5); hold on;
stem(0:N-1, abs(X_fft),    'rx', 'LineWidth', 1.5);
title('|X[k]| - DFT direta (o) vs FFT (x)');
xlabel('k'); ylabel('|X[k]|');
legend('DFT direta','FFT'); grid on;

% --- Salvar PNG em Resultados/ ---
script_dir = fileparts(mfilename('fullpath'));
out_dir    = fullfile(script_dir, '..', '..', 'Resultados');
if ~exist(out_dir, 'dir'); mkdir(out_dir); end
print(fig, fullfile(out_dir, 'sim6_atividade6_dft_vs_fft.png'), '-dpng', '-r120');
fprintf('Figura salva em: %s\n', fullfile(out_dir, 'sim6_atividade6_dft_vs_fft.png'));
