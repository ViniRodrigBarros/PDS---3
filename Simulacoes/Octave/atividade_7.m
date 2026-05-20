% =========================================================================
% ATIVIDADE 07 - Resposta ao impulso e estabilidade via Transformada-Z
% -------------------------------------------------------------------------
%             1
%   H(z) = --------------
%          1 - 0.8 z^{-1}
%
% Determina numericamente a resposta ao impulso h[n] e discute a
% estabilidade do sistema a partir do comportamento de h[n] e da posicao
% do polo no plano-z.
% =========================================================================

clear; clc; close all;

% --- Coeficientes da funcao de transferencia ---
% H(z) = B(z)/A(z) com B = 1 e A = [1 -0.8]
B = 1;
A = [1 -0.8];

% --- Resposta ao impulso h[n] ---
N = 40;
delta = [1 zeros(1, N-1)];      % impulso unitario
h     = filter(B, A, delta);    % h[n] = (0.8)^n * u[n]

% --- Polos (numericamente) ---
polos = roots(A);
raio  = abs(polos);

fprintf('Polo do sistema   : z = %.4f\n', polos);
fprintf('|polo|            : %.4f\n', raio);
if all(raio < 1)
    fprintf('Status            : ESTAVEL (todos os polos dentro do circulo unitario)\n');
else
    fprintf('Status            : INSTAVEL\n');
end

% --- Verificacao analitica: h[n] = 0.8^n ---
h_analitica = (0.8).^(0:N-1);
erro_max = max(abs(h - h_analitica));
fprintf('Erro maximo entre h numerica e h analitica (0.8^n): %.2e\n', erro_max);

% --- Graficos ---
fig = figure('Name','Atividade 07 - Resposta ao impulso e estabilidade', ...
             'Position',[100 100 900 700]);

subplot(2,1,1);
stem(0:N-1, h, 'filled');
title('Resposta ao impulso h[n] = (0.8)^n u[n]');
xlabel('n'); ylabel('h[n]'); grid on;
text(N/2, 0.5, sprintf('h[n] -> 0 quando n -> inf\nSistema ESTAVEL'), ...
     'FontWeight','bold','BackgroundColor','w');

subplot(2,1,2);
theta = linspace(0, 2*pi, 200);
plot(cos(theta), sin(theta), 'k--'); hold on; axis equal; grid on;
plot(real(polos), imag(polos), 'rx', 'MarkerSize', 14, 'LineWidth', 2);
plot(0, 0, 'k+');
title('Plano-z: polo de H(z)');
xlabel('Re\{z\}'); ylabel('Im\{z\}');
legend('Circulo unitario','Polo','Origem','Location','southwest');
xlim([-1.2 1.2]); ylim([-1.2 1.2]);

fprintf('\nConclusao: como h[n] decai geometricamente para zero, sua soma\n');
fprintf('eh absolutamente convergente, atendendo ao criterio BIBO.\n');
fprintf('Isso equivale, no plano-z, a observar que o polo (z=0.8) esta\n');
fprintf('estritamente dentro do circulo unitario.\n');

% --- Salvar PNG em Resultados/ ---
script_dir = fileparts(mfilename('fullpath'));
out_dir    = fullfile(script_dir, '..', '..', 'Resultados');
if ~exist(out_dir, 'dir'); mkdir(out_dir); end
print(fig, fullfile(out_dir, 'sim7_atividade7_resposta_impulso.png'), '-dpng', '-r120');
fprintf('Figura salva em: %s\n', fullfile(out_dir, 'sim7_atividade7_resposta_impulso.png'));
