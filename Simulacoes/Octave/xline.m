% =========================================================================
% xline - Polyfill para xline (compatibilidade com Octave antigo / MATLAB)
% -------------------------------------------------------------------------
% Desenha uma linha vertical no eixo atual, em x = x_val, com estilo
% opcional e rotulo opcional. Reproduz a sintaxe basica do xline do MATLAB
% (R2018b+), que nao existe nas versoes mais antigas do Octave.
%
% USO:
%   xline(x)
%   xline(x, style)
%   xline(x, style, label)
%
% EXEMPLO:
%   xline(60, 'r--', '60 Hz');
% =========================================================================
function xline(x_val, style, label)
    if nargin < 2 || isempty(style); style = 'k--'; end
    if nargin < 3;                   label = '';    end

    % Captura estado de hold para nao alterar o comportamento do grafico
    hold_state = ishold;
    hold on;

    % Extrair cor do estilo (1o caractere) para usar no texto, com fallback
    color_letters = 'bgrcmykw';
    if ~isempty(style) && any(style(1) == color_letters)
        c = style(1);
    else
        c = 'k';
    end

    yl = ylim;
    plot([x_val x_val], yl, style, 'LineWidth', 1);

    if ~isempty(label)
        text(x_val, yl(2) - 0.05*(yl(2) - yl(1)), ['  ' label], ...
             'Color', c, 'VerticalAlignment', 'top');
    end

    if ~hold_state; hold off; end
end
