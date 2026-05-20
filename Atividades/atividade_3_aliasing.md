# Atividade 3 — Aliasing: Quando a Amostragem Mente

**Pergunta investigada:** o que acontece com o espectro quando a taxa de amostragem é insuficiente? E por que esse erro é irreversível?

---

## Setup do experimento

A mesma senoide de **180 Hz** foi amostrada de duas maneiras:

| Cenário | *Fs* | *Fs/2* (Nyquist) | Atende Nyquist? |
|---|---|---|---|
| Adequado | 1000 Hz | 500 Hz | Sim (180 < 500) |
| Subamostrado | 200 Hz | 100 Hz | **Não** (180 > 100) |

Pelo Teorema da Amostragem, só o primeiro cenário pode representar a senoide fielmente.

## Roteiro do código

Script: [`atividade_3.m`](../Simulacoes/Octave/atividade_3.m).

A frequência *alias* esperada para o caso ruim foi calculada pela fórmula de rebatimento:

```
f_alias = | f_sinal − round(f_sinal / Fs) · Fs |
       = | 180 − 1 · 200 | = 20 Hz
```

## Saída da simulação

![Comparação dos espectros — adequado vs subamostrado](../Resultados/simulacao3atvd3.png)

Saída do console:

```
Frequencia original   : 180.0 Hz
fs adequado (Nyquist) : 1000.0 Hz -> sem aliasing
fs reduzido           : 200.0 Hz  -> alias em 20.0 Hz
```

## O que o espectro revela

No **Caso 1** (1000 Hz), o pico aparece em 180 Hz. Tudo certo.

No **Caso 2** (200 Hz), o pico aparece em **20 Hz** — *exatamente* o valor previsto pela fórmula de rebatimento. A senoide de 180 Hz se *disfarçou* como uma senoide de 20 Hz, e **não há nada no sinal digital que permita perceber a fraude**. Um observador desavisado, recebendo só o sinal subamostrado, concluiria que se trata de um sinal de baixa frequência.

A intuição geométrica: ao amostrar uma onda mais rápida que a metade da taxa, cada amostra "pula" mais de meio ciclo. O cérebro do algoritmo interpreta esse pulo como o caminho mais curto entre duas amostras — o que vira uma senoide de frequência inferior.

## Lição prática

**Aliasing é defeito de fábrica do A/D, não da FFT.** Uma vez ocorrido, nenhum algoritmo de processamento digital consegue reverter — a informação espectral foi destruída no instante da amostragem.

A **única** defesa é um **filtro anti-aliasing analógico** (passa-baixas) instalado *antes* do conversor A/D, com frequência de corte abaixo de *Fs/2*. Esse filtro joga fora as componentes acima de Nyquist *antes* que elas se misturem com as de baixa frequência. É prática obrigatória em qualquer cadeia profissional de aquisição: osciloscópios, placas de som, sistemas embarcados de instrumentação.

> **Analogia clássica:** as rodas de carruagem que aparecem girando "para trás" em filmes de faroeste. A câmera amostra (em quadros/segundo) uma rotação cuja frequência excede metade da taxa de quadros. O cérebro humano interpreta o movimento como uma rotação inversa mais lenta — um *alias* visual.
