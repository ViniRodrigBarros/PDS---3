% =========================================================================
% sep_status - Verifica se duas frequencias sao separaveis dado um df
% -------------------------------------------------------------------------
% Funcao auxiliar usada em atividade_8.m para gerar texto descritivo
% sobre a resolucao espectral.
% =========================================================================
function s = sep_status(df, delta)
    if df < delta
        s = 'separaveis';
    else
        s = 'NAO separaveis';
    end
end
