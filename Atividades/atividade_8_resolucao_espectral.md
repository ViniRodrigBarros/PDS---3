# Atividade 8 — Tempo de Observação Dita a Resolução

**Pergunta investigada:** se duas senoides estão **muito próximas** em frequência, quanto tempo preciso observar o sinal para conseguir distingui-las?

---

## A regra fundamental

A resolução em frequência da DFT é:

```
Δf = Fs / N = 1 / T_obs
```

onde *T_obs = N·Ts* é o **tempo total de observação**. Para separar duas componentes a uma distância *δ* em frequência, é preciso que:

```
Δf < δ   ⇔   T_obs > 1 / δ
```

Esse é o **princípio da incerteza tempo-frequência** aplicado a sinais digitais.

## Setup do experimento

Duas senoides muito próximas:
- *f₁ = 100 Hz*
- *f₂ = 108 Hz*
- **Separação:** *δ = 8 Hz*

Comparando dois comprimentos:

| Caso | *N* | *T_obs* | Δf = *Fs/N* | Δf < δ? |
|---|---|---|---|---|
| **A** | 64 | 64 ms | 15,625 Hz | ✗ (15,6 > 8) |
| **B** | 1024 | 1,024 s | 0,977 Hz | ✓ (0,98 < 8) |

A teoria prevê que o **Caso A não distingue** as duas senoides (um único pico borrado), e o **Caso B distingue** (dois picos separados).

## Roteiro do código

Script: [`atividade_8.m`](../Simulacoes/Octave/atividade_8.m).

A rotina auxiliar `sep_status(df, δ)` (arquivo separado) gera automaticamente a descrição "separáveis" / "NÃO separáveis".

## Saída da simulação

![Resolução baixa × resolução alta — mesmas senoides](../Resultados/simulacao8atvd8.png)

Saída do console:

```
Diferenca de frequencia entre as componentes: 8.00 Hz
Resolucao com N =   64 -> df = 15.625 Hz (componentes NAO separaveis)
Resolucao com N = 1024 -> df = 0.977 Hz  (componentes separaveis)
```

## O que os dois espectros revelam

- **Caso A (N = 64):** o gráfico mostra um único pico arredondado — as duas senoides se fundiram em uma "blob" espectral. Olhando esse espectro, ninguém diria que existem **duas** componentes.
- **Caso B (N = 1024):** dois picos finos perfeitamente separados em 100 Hz e 108 Hz.

A diferença? Apenas o **tempo que olhei o sinal**. Tudo o mais é igual.

## Aumentar a taxa de amostragem ajuda?

**Não.** Aumentar *Fs* mantendo *N* constante **piora** Δf (= Fs/N cresce). O que melhora a resolução é aumentar *T_obs = N/Fs* — ou seja, observar o sinal por mais tempo, não amostrá-lo mais rápido.

## E o tal "zero-padding"?

Adicionar zeros ao sinal antes da FFT (*zero-padding*) **não melhora a resolução real**. O que ele faz é interpolar entre os bins existentes, deixando o gráfico do espectro mais "denso" visualmente. A informação espectral real continua determinada pelo *T_obs* original. **Resolução verdadeira ≠ densidade de pontos no gráfico.**

## Lição prática

A relação fundamental para projetar uma aquisição:

```
Tempo de observação necessário = 1 / (mínima separação que se quer distinguir)
```

Quer separar dois harmônicos a 1 Hz? Pelo menos 1 segundo de observação. A 0,1 Hz? 10 segundos. E assim por diante.

Mas cuidado com o outro lado: **observar mais tempo exige sinal estacionário** durante todo *T_obs*. Se o sinal muda nesse intervalo, a FFT "borra" as mudanças. Para sinais não-estacionários (música, fala, vibrações transitórias), usa-se a STFT (FFT em janelas curtas deslizantes) ou wavelets. Sempre o mesmo *trade-off*: resolução em tempo × resolução em frequência.
