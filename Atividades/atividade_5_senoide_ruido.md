# Atividade 5 — Detecção de Senoide em Meio a Ruído

## Enunciado

Considere um sinal composto por uma senoide e ruído aditivo. Gere o sinal, calcule sua FFT e analise a dificuldade de identificar a frequência principal na presença do ruído. Discuta como a análise espectral pode auxiliar na separação entre componente útil e perturbações.

---

## 1. Sinal Sintetizado

- *s(t) = 1,0·sin(2π·60·t)* — senoide útil em 60 Hz
- *r(t) ~ N(0, σ²)* — ruído branco gaussiano com *σ = 1,2*
- *x(t) = s(t) + r(t)*

SNR aproximado:

SNR_dB = 10·log₁₀( (A²/2) / σ² ) = 10·log₁₀( 0,5 / 1,44 ) ≈ **−4,59 dB**

Ou seja, **o ruído tem mais potência que a senoide** — visualmente, o sinal no tempo parece ruído puro.

---

## 2. Implementação

Script: [`atividade_5.m`](../Simulacoes/Octave/atividade_5.m). Parâmetros: *Fs = 1000 Hz*, *N = 1024*.

---

## 3. Resultados

![Senoide em meio ao ruído](../Resultados/sim5_atividade5_senoide_ruido.png)

Valores medidos:

| Grandeza | Valor |
|---|---|
| SNR no tempo | −4,59 dB |
| Frequência esperada | 60 Hz |
| Frequência detectada na FFT | 59,57 Hz (bin 61) |
| Resolução *Δf = Fs/N* | 0,977 Hz |

- **Sinal útil** *s(t)*: senoide limpa.
- **Sinal observado** *x(t)*: caos visual — sem inspeção espectral, ninguém adivinharia que há uma senoide ali.
- **Espectro:** pico nítido em ≈ 60 Hz, claramente acima do piso de ruído. O leve erro (59,57 vs 60 Hz) corresponde a meio bin de discretização — limitação inerente da resolução *Δf*, não do ruído.

---

## 4. Discussão

Por que a senoide aparece no espectro mesmo "afogada" no tempo?

- A energia da **senoide está concentrada** em uma única frequência;
- A energia do **ruído branco está espalhada** uniformemente por toda a banda *[0, Fs/2]*.

Ao calcular a FFT com *N* amostras, a senoide concentra-se em ≈ 2 bins, enquanto a energia do ruído se divide por *N/2 ≈ 512* bins. O **ganho de processamento** da FFT é, portanto, proporcional a *N*, e cresce com mais amostras.

Este é o princípio operacional de praticamente toda a engenharia de detecção:

- **Radar/sonar**: detectar ecos fracos em meio a ruído de fundo.
- **Telecom**: separar canais e detectar portadoras enterradas no ruído térmico do receptor.
- **Diagnóstico de vibração**: revelar uma falha incipiente cuja vibração ainda é pequena comparada ao ruído ambiente.

A análise espectral é, em essência, **um filtro casado distribuído** — cada bin atua como um filtro estreito centrado em sua frequência.
