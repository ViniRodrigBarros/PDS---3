% =========================================================================
% findpeaks_simple - Detecta picos locais acima de um limiar
% -------------------------------------------------------------------------
% Substituto leve do findpeaks do Signal Processing Toolbox, escrito em
% Octave puro para garantir portabilidade.
%
% USO:
%   [picos, locs] = findpeaks_simple(y, thr)
%     y   - vetor de amostras
%     thr - limiar minimo (amostras abaixo deste valor sao ignoradas)
%
% RETORNA:
%   picos - valores dos maximos locais
%   locs  - indices correspondentes dentro de y
% =========================================================================
function [picos, locs] = findpeaks_simple(y, thr)
    picos = [];
    locs  = [];
    for i = 2:length(y)-1
        if y(i) > y(i-1) && y(i) > y(i+1) && y(i) > thr
            picos(end+1) = y(i);   %#ok<AGROW>
            locs(end+1)  = i;      %#ok<AGROW>
        end
    end
end
