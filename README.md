# Processamento Digital de Sinais — Etapa 03

**Análise no Domínio da Frequência**
**Disciplina:** Processamento Digital de Sinais
**Instituição:** Instituto Federal da Paraíba (IFPB)
**Curso:** Engenharia da Computação / Telemática

---

## Problema Norteador (PBL)

> **Como identificar, a partir do conteúdo espectral de um sinal real, informações relevantes sobre o comportamento dinâmico de um sistema físico e quais limitações práticas devem ser consideradas durante a aquisição e análise desses dados?**

**Resposta resumida:** A identificação espectral de um sistema dinâmico segue uma sequência metodológica clara — escolher *Fs ≥ 2·F_max* com filtro anti-aliasing analógico, definir o tempo de observação *T* conforme a resolução *Δf = 1/T* desejada, aplicar janela suave (Hann/Hamming) para reduzir vazamento, calcular o espectro via FFT e exibir a metade informativa *[0, Fs/2]*. A interpretação física conecta cada pico a um fenômeno mecânico, elétrico ou estrutural específico (rotação, harmônicos, ressonâncias). As limitações práticas a considerar são: **aliasing** (irreversível, prevenido apenas no estágio analógico), **vazamento espectral** (atenuado por janelamento mas nunca eliminado), **resolução espectral finita** (limitada pelo tempo de observação), **piso de ruído** (define o limite de detectabilidade) e **estacionariedade** (a FFT assume que o sinal não muda durante a janela — caso contrário, exige-se STFT ou wavelet).

---

## Estrutura do Repositório

```
Processamento-Digital-de-Sinais---Etapa-03/
├── README.md
├── Teoria/
│   └── resumo_teorico.md
├── Atividades/
│   ├── atividade_1_senoide_fft.md
│   ├── atividade_2_duas_senoides.md
│   ├── atividade_3_aliasing.md
│   ├── atividade_4_janelamento.md
│   ├── atividade_5_senoide_ruido.md
│   ├── atividade_6_dft_vs_fft.md
│   ├── atividade_7_funcao_transferencia.md
│   ├── atividade_8_resolucao_espectral.md
│   └── atividade_9_harmonicos.md
├── Desafio/
│   └── analise_sinal_real.md
├── Simulacoes/
│   ├── discussao_tecnica.md
│   └── Octave/
│       ├── atividade_1.m
│       ├── atividade_2.m
│       ├── atividade_3.m
│       ├── atividade_4.m
│       ├── atividade_5.m
│       ├── atividade_6.m
│       ├── atividade_7.m
│       ├── atividade_8.m
│       ├── atividade_9.m
│       ├── pbl_analise_espectral_sensor.m
│       └── run_all.m          <- script principal: roda tudo + salva PNGs
└── Resultados/
    ├── sim1_atividade1_senoide_fft.png
    ├── sim2_atividade2_duas_senoides.png
    ├── sim3_atividade3_aliasing.png
    ├── sim4_atividade4_janelamento.png
    ├── sim5_atividade5_senoide_ruido.png
    ├── sim6_atividade6_dft_vs_fft.png
    ├── sim7_atividade7_resposta_impulso.png
    ├── sim8_atividade8_resolucao.png
    ├── sim9_atividade9_harmonicos.png
    └── sim10_desafio_sinal_real.png
```

---

## Conteúdos Abordados

- **Transformada de Fourier em Tempo Discreto (DTFT)** — representação contínua em frequência;
- **Transformada Discreta de Fourier (DFT)** — versão amostrada para computação;
- **FFT (Fast Fourier Transform)** — algoritmo eficiente da DFT, base do PDS prático;
- **Transformada-Z** — análise no plano complexo, estabilidade e ROC;
- **Aliasing** — fenômeno de subamostragem, irreversibilidade, anti-aliasing analógico;
- **Janelamento** — vazamento espectral, comparação entre Retangular, Hann e Hamming;
- **Resolução espectral** — *Δf = Fs/N*, princípio da incerteza tempo-frequência;
- **Análise harmônica** — diagnóstico de máquinas rotativas por assinatura espectral.

---

## Tabela das Atividades

| # | Atividade | Conceito-chave | Script |
|:---:|---|---|---|
| 1 | [Senoide + FFT](Atividades/atividade_1_senoide_fft.md) | Identificação de frequência dominante | [`atividade_1.m`](Simulacoes/Octave/atividade_1.m) |
| 2 | [Duas senoides](Atividades/atividade_2_duas_senoides.md) | Separação espectral, linearidade da DFT | [`atividade_2.m`](Simulacoes/Octave/atividade_2.m) |
| 3 | [Aliasing](Atividades/atividade_3_aliasing.md) | Subamostragem, rebatimento, Nyquist | [`atividade_3.m`](Simulacoes/Octave/atividade_3.m) |
| 4 | [Janelamento](Atividades/atividade_4_janelamento.md) | Vazamento espectral, Hann vs Hamming | [`atividade_4.m`](Simulacoes/Octave/atividade_4.m) |
| 5 | [Senoide em ruído](Atividades/atividade_5_senoide_ruido.md) | Ganho de processamento, detecção espectral | [`atividade_5.m`](Simulacoes/Octave/atividade_5.m) |
| 6 | [DFT vs FFT](Atividades/atividade_6_dft_vs_fft.md) | Equivalência numérica, custo computacional | [`atividade_6.m`](Simulacoes/Octave/atividade_6.m) |
| 7 | [H(z) e resposta ao impulso](Atividades/atividade_7_funcao_transferencia.md) | Transformada-Z, polos, estabilidade | [`atividade_7.m`](Simulacoes/Octave/atividade_7.m) |
| 8 | [Resolução espectral](Atividades/atividade_8_resolucao_espectral.md) | *Δf = 1/T_obs*, princípio da incerteza | [`atividade_8.m`](Simulacoes/Octave/atividade_8.m) |
| 9 | [Harmônicos e vibração](Atividades/atividade_9_harmonicos.md) | Diagnóstico de máquinas rotativas | [`atividade_9.m`](Simulacoes/Octave/atividade_9.m) |
| 10 | [Sinal real (Desafio PBL)](Desafio/analise_sinal_real.md) | Integração: sensor industrial completo | [`pbl_analise_espectral_sensor.m`](Simulacoes/Octave/pbl_analise_espectral_sensor.m) |

---

## Como Executar

### Pré-requisitos

- **GNU Octave** 6.0+ ou **MATLAB** R2020a+;
- Pacote `signal` do Octave (opcional, recomendado):

```bash
# No Octave
pkg load signal
```

### Rodar todas as simulações de uma vez (script principal)

O arquivo [`Simulacoes/Octave/run_all.m`](Simulacoes/Octave/run_all.m) executa em sequência **todas as 10 simulações** e salva automaticamente cada figura como PNG em `Resultados/`:

```matlab
cd Simulacoes/Octave/
run_all
```

Ao final, é exibida uma tabela com o status (OK / ERRO / tempo) de cada simulação.

### Executar uma simulação individualmente

Cada script é independente e gera/salva sua própria figura:

```matlab
cd Simulacoes/Octave/
atividade_1                       % ou atividade_2, atividade_3, ...
pbl_analise_espectral_sensor      % desafio PBL
```

---

## Resultados Esperados

Ao final desta etapa, o estudante é capaz de:

- **Interpretar sinais discretos no domínio da frequência** — identificar frequências dominantes, harmônicos e ruído de fundo;
- **Compreender a relação entre domínio do tempo e da frequência** — aplicar linearidade, simetria conjugada, princípio da incerteza;
- **Identificar efeitos de aliasing e janelamento** — diagnosticar erros de aquisição e escolher janelas apropriadas;
- **Utilizar ferramentas matemáticas e computacionais para análise espectral** — DTFT, DFT, FFT, Transformada-Z;
- **Relacionar o conteúdo espectral de sinais com aplicações práticas em engenharia** — diagnóstico industrial, telecomunicações, instrumentação.

---

## Aplicações Tecnológicas Abordadas

- **Análise de vibração em máquinas rotativas** (Atividades 9 e 10) — fundamento da manutenção preditiva (ISO 10816, ISO 13373);
- **Sistemas de aquisição com sensores** — engenharia de instrumentação digital;
- **Análise de ruído em telecomunicações** (Atividade 5);
- **Filtros digitais IIR de primeira ordem** (Atividade 7).

---

## Documentação Adicional

- [**Resumo Teórico Completo**](Teoria/resumo_teorico.md) — fundamentação matemática de todos os conceitos;
- [**Discussão Técnica Integrada**](Simulacoes/discussao_tecnica.md) — síntese dos resultados das 10 simulações.

---

## Referências

- OPPENHEIM, A. V.; SCHAFER, R. W. *Discrete-Time Signal Processing*. 3. ed. Pearson, 2010.
- PROAKIS, J. G.; MANOLAKIS, D. G. *Digital Signal Processing: Principles, Algorithms and Applications*. 4. ed. Pearson, 2007.
- LATHI, B. P. *Sinais e Sistemas Lineares*. 2. ed. Bookman, 2007.
- LYONS, R. G. *Understanding Digital Signal Processing*. 3. ed. Pearson, 2011.
- COOLEY, J. W.; TUKEY, J. W. An algorithm for the machine calculation of complex Fourier series. *Mathematics of Computation*, v. 19, p. 297-301, 1965.
- ISO 10816-1. *Mechanical vibration — Evaluation of machine vibration by measurements on non-rotating parts*.
- ISO 13373-3. *Condition monitoring and diagnostics of machines — Vibration condition monitoring*.
