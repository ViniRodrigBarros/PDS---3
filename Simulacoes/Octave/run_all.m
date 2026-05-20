% =========================================================================
% RUN_ALL - Script principal para executar todas as simulacoes da Etapa 3
% -------------------------------------------------------------------------
% Executa em sequencia as 9 atividades + o desafio PBL, gerando todas as
% figuras correspondentes e salvando-as automaticamente como arquivos PNG
% na pasta ../../Resultados/.
%
% USO:
%   1. No Octave/MatLab, navegue ate esta pasta:
%        cd Simulacoes/Octave/
%   2. Execute:
%        run_all
%
% Ao final e exibida uma tabela com o status de cada simulacao.
%
% NOTA TECNICA: Esta arquivo eh uma FUNCAO (e nao um script) para isolar
% o workspace da execucao de cada simulacao. Sem isso, o "clear" dentro
% de cada atividade apagaria as variaveis do loop e o run_all rodaria
% somente a primeira simulacao.
% =========================================================================

function run_all()

    fprintf('=========================================================\n');
    fprintf('  PDS - Etapa 03 - Execucao em lote de todas as simulacoes\n');
    fprintf('=========================================================\n\n');

    % --- Pacotes do Octave (silencioso se nao estiverem instalados) ---
    if exist('OCTAVE_VERSION', 'builtin')
        try, pkg load signal;  catch, end
        try, pkg load control; catch, end
    end

    % --- Localizar a propria pasta e a pasta Resultados/ ---
    script_dir = fileparts(mfilename('fullpath'));
    out_dir    = fullfile(script_dir, '..', '..', 'Resultados');
    if ~exist(out_dir, 'dir'); mkdir(out_dir); end

    % --- Lista de simulacoes a executar ---
    sims = { ...
        'atividade_1',                  'Senoide + FFT'; ...
        'atividade_2',                  'Soma de duas senoides'; ...
        'atividade_3',                  'Aliasing'; ...
        'atividade_4',                  'Janelamento'; ...
        'atividade_5',                  'Senoide + ruido'; ...
        'atividade_6',                  'DFT direta vs FFT'; ...
        'atividade_7',                  'Resposta ao impulso (Transformada-Z)'; ...
        'atividade_8',                  'Resolucao espectral'; ...
        'atividade_9',                  'Harmonicos (vibracao mecanica)'; ...
        'pbl_analise_espectral_sensor', 'Desafio PBL - sinal de vibracao real' ...
    };

    n_sims = size(sims, 1);
    status = cell(n_sims, 1);

    t_total = tic;

    % --- Loop principal ---
    for i = 1:n_sims
        nome  = sims{i, 1};
        descr = sims{i, 2};
        fprintf('--- [%2d/%d] %s :: %s ---\n', i, n_sims, nome, descr);

        full_path = fullfile(script_dir, [nome '.m']);
        t_i = tic;
        try
            run_one(full_path);    % executa em workspace isolado
            elapsed = toc(t_i);
            status{i} = sprintf('OK   (%.2fs)', elapsed);
            fprintf('    >> Concluida em %.2f s\n\n', elapsed);
        catch err
            status{i} = sprintf('ERRO: %s', err.message);
            fprintf(2, '    >> FALHOU: %s\n\n', err.message);
        end

        close all;   % libera memoria das figuras entre simulacoes
    end

    t_total = toc(t_total);

    % --- Resumo final ---
    fprintf('\n=========================================================\n');
    fprintf('  RESUMO DA EXECUCAO     (tempo total: %.2f s)\n', t_total);
    fprintf('=========================================================\n');
    for i = 1:n_sims
        fprintf('  [%2d] %-32s  %s\n', i, sims{i,1}, status{i});
    end
    fprintf('\nFiguras geradas em: %s\n', out_dir);
    fprintf('=========================================================\n');

end

% -------------------------------------------------------------------------
% Funcao auxiliar - executa um unico script .m em workspace ISOLADO.
% Como esta funcao tem workspace proprio, o "clear" interno de cada
% atividade_N.m so apaga as variaveis aqui dentro, sem afetar o loop
% do run_all() acima.
% -------------------------------------------------------------------------
function run_one(full_path)
    run(full_path);
end
