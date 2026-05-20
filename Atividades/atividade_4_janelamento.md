# Atividade 4 — Janelamento e Redução do Vazamento Espectral

## Enunciado

Gere um sinal discreto finito e calcule sua FFT sem aplicação de janela. Em seguida, aplique uma janela de Hamming ou Hann ao mesmo sinal e recalcule o espectro. Compare os resultados e discuta o efeito do janelamento sobre o vazamento espectral.

---

## 1. Origem do Vazamento

A DFT trata o sinal como se ele fosse **periódico** com período igual à janela de observação. Quando a senoide observada **não completa um número inteiro de períodos** dentro da janela, surgem descontinuidades nas extremidades, equivalentes a uma multiplicação por uma janela retangular — que, no domínio da frequência, equivale a uma convolução com uma função *sinc*. O resultado é o **vazamento espectral** (*spectral leakage*).

Para evidenciar o efeito, escolheu-se intencionalmente *f₀ = 100,7 Hz*, com *Fs = 1000 Hz* e *N = 256*. Como *f₀·N/Fs = 25,78* não é inteiro, o vazamento é severo.

---

## 2. Implementação

Script: [`atividade_4.m`](../Simulacoes/Octave/atividade_4.m)

Janelas comparadas:

```matlab
w_hamming = 0.54 - 0.46*cos(2*pi*(0:N-1)/(N-1));   % Hamming
w_hann    = 0.5  - 0.5 *cos(2*pi*(0:N-1)/(N-1));   % Hann
```

O espectro foi plotado em **dB** para evidenciar os lóbulos laterais.

---

## 3. Resultados

![Janelamento Hamming vs Hann vs Retangular](../Resultados/simulacao4atvd4.png)

| Janela | Atenuação do 1º lóbulo lateral | Largura do lóbulo principal |
|---|---|---|
| Retangular | ≈ −13 dB | Mais estreito |
| Hann | ≈ −32 dB | Médio |
| Hamming | ≈ −43 dB | Médio |

---

## 4. Discussão

O janelamento **troca resolução por contraste**:

- **Sem janela** (retangular): o lóbulo principal é estreito (boa resolução em frequência), mas os lóbulos laterais decaem lentamente (≈ −13 dB), mascarando componentes próximas.
- **Com Hann ou Hamming**: lóbulos laterais caem drasticamente (−32 a −43 dB), permitindo enxergar picos pequenos vizinhos a picos grandes. O preço é um lóbulo principal ligeiramente mais largo.

Em análise espectral profissional (vibração, áudio, telecom), praticamente nunca se usa janela retangular — Hann e Hamming são os padrões. Para situações específicas (medida precisa de amplitude, alta dinâmica), existem janelas mais sofisticadas como Blackman-Harris, flat-top e Kaiser.
