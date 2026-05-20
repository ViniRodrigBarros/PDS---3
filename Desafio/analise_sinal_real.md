# Desafio PBL — Análise Espectral Completa de uma Vibração

**Pergunta investigada:** integrar tudo da Etapa 3 em um único experimento. Dado um sinal de vibração realista (rotação + falha + ruído), como extrair informação de diagnóstico do espectro? E quais cuidados a aquisição precisa ter para que o diagnóstico seja confiável?

> **Problema norteador (PBL):** Como identificar, a partir do conteúdo espectral de um sinal real, informações relevantes sobre o comportamento dinâmico de um sistema físico e quais limitações práticas devem ser consideradas durante a aquisição e análise desses dados?

---

## O cenário simulado: máquina rotativa com falha

Foi sintetizado um sinal de **acelerômetro instalado em uma máquina industrial** com quatro contribuições:

| Componente | Frequência | Amplitude | Significado físico |
|---|---|---|---|
| 1× | 25 Hz (1500 RPM) | 1,0 | Rotação do eixo |
| 2× | 50 Hz | 0,6 | Desalinhamento entre eixos |
| BPFO | 154 Hz | 0,4 (modulado em 1×) | Falha em pista externa de rolamento |
| Ruído | banda larga | σ = 0,3 | Ruído elétrico/mecânico |

**Detalhe sobre a falha de rolamento:** quando uma esfera (ou rolete) passa por um defeito na pista externa, gera um impulso. Esses impulsos repetitivos ocorrem a uma frequência chamada **BPFO** (*Ball Pass Frequency, Outer race*) — calculada a partir da geometria do rolamento e da rotação do eixo. O impulso, sendo periódico, aparece no espectro como um pico em BPFO. Modelei isso como uma senoide em 154 Hz **modulada em amplitude** pela rotação do eixo, reproduzindo o padrão típico observado em rolamentos com defeito.

Parâmetros de aquisição:
- *Fs = 5000 Hz* — bem acima de 2× a maior componente (154 Hz)
- *T = 2 s*
- *N = 10 000*
- Δf = 0,5 Hz — folgada para todas as componentes

## Pipeline de processamento

Script: [`pbl_analise_espectral_sensor.m`](../Simulacoes/Octave/pbl_analise_espectral_sensor.m).

1. Geração das três componentes determinísticas + ruído gaussiano
2. Aplicação de **janela de Hann** para reduzir vazamento espectral
3. FFT do sinal janelado
4. Identificação automática dos picos esperados
5. Plotagem em três painéis (tempo bruto, tempo janelado, espectro)

## Saída da simulação

![Sinal de vibração + janela + espectro](../Resultados/simulacao10desafio.png)

Os três picos relevantes foram detectados com precisão de bin:

| Componente | *f* esperada | *f* detectada | |X|/N medido |
|---|---|---|---|
| 1× (rotação) | 25 Hz | **25,00 Hz** | 0,2499 |
| 2× (desalinhamento) | 50 Hz | **50,00 Hz** | 0,1500 |
| BPFO (rolamento) | 154 Hz | **154,00 Hz** | 0,1015 |

O acerto em frequência foi **exato** (erro nulo até Δf = 0,5 Hz) porque *Fs* e *T* foram escolhidos de forma que cada componente caísse em um bin inteiro da DFT. Em aquisição real, é normal observar erros de até ½ bin na localização dos picos.

## Resposta ao problema norteador (PBL)

### O que o espectro me conta sobre a máquina?

- **Picos em 25 e 50 Hz** confirmam a rotação do eixo e indicam que o **desalinhamento** está presente (componente 2× anormalmente forte).
- **Pico em ~154 Hz**, **fora dos harmônicos** da rotação (que seriam 25, 50, 75, 100, 125, 150, ...), sugere uma **frequência não-síncrona** — assinatura típica de **falha localizada em rolamento**.
- **Piso de ruído** define o limite de detectabilidade. Qualquer pico abaixo dele é impossível de identificar com confiança.

Cada pico tem **significado físico mensurável**. Isso é o que diferencia uma "análise de Fourier" de um "diagnóstico de manutenção": a ponte entre matemática e engenharia mecânica.

### Cinco cuidados práticos (todos evidenciados nas atividades anteriores)

1. **Taxa de amostragem adequada** (*Fs > 2·f_max*) — **com filtro anti-aliasing analógico** no estágio A/D. Sem isso, frequências acima de *Fs/2* contaminam irrecuperavelmente o espectro. (Atividade 3)

2. **Tempo de observação suficiente** para a resolução desejada (*Δf = 1/T_obs*). Querer separar harmônicos próximos exige observar o sinal por tempo proporcional. (Atividade 8)

3. **Janelamento apropriado** (Hann, Hamming, Blackman) para mitigar vazamento espectral do truncamento. Sem janela, picos pequenos próximos a picos grandes desaparecem nos lóbulos laterais. (Atividade 4)

4. **Piso de ruído** abaixo da amplitude das componentes de interesse. O ruído branco se espalha; aumentar *N* aumenta o **ganho de processamento** e expõe sinais cada vez mais fracos. (Atividade 5)

5. **Estacionariedade** do sinal durante a janela observada. A FFT clássica assume que o sinal não muda durante *T_obs*. Para sinais transitórios (impactos, regime variável), exige-se STFT, wavelet, ou análise por envelope.

### Síntese final

Quando esses cinco cuidados são atendidos, a análise espectral transcende seu papel de ferramenta matemática e se torna, na prática da engenharia, uma forma de **observar o invisível**: extrair, de um traçado caótico no tempo, informação organizada e acionável sobre o estado de um sistema físico.

O mesmo arcabouço que aqui diagnostica um rolamento defeituoso é o que permite:

- Detectar uma portadora de rádio em meio ao ruído atmosférico (radioastronomia);
- Reconhecer um sintoma cardíaco em um ECG (medicina);
- Monitorar a saúde de uma estrutura civil (engenharia civil);
- Caracterizar a resposta acústica de uma sala (acústica arquitetônica).

A FFT, em última análise, é uma das ferramentas mais universais da engenharia moderna — e a Etapa 3 cobriu seus fundamentos e armadilhas.
