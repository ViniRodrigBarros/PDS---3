# Atividade 2 — Soma de Duas Senoides e Análise via FFT

## Enunciado

Gere duas senoides de frequências distintas e some os sinais obtidos. Em seguida, calcule a FFT do sinal resultante e verifique se o espectro permite distinguir corretamente as duas componentes em frequência. Discuta a relação entre o domínio do tempo e o domínio da frequência.

---

## 1. Sinais Gerados

Foram escolhidas duas componentes com amplitudes diferentes:

- *x₁(t) = 1,0·sin(2π·50·t)*   (50 Hz)
- *x₂(t) = 0,7·sin(2π·120·t)*  (120 Hz)
- *x(t) = x₁(t) + x₂(t)*

Parâmetros: *Fs = 1000 Hz*, *N = 512* amostras. Resolução espectral: *Δf = Fs/N ≈ 1,95 Hz* — mais que suficiente para separar 50 Hz e 120 Hz.

---

## 2. Implementação

Script: [`atividade_2.m`](../Simulacoes/Octave/atividade_2.m)

```matlab
x1 = 1.0*sin(2*pi*50*t);
x2 = 0.7*sin(2*pi*120*t);
x  = x1 + x2;

X      = fft(x);
mag    = abs(X)/N;
f      = (0:N-1)*(fs/N);
```

A detecção dos picos usa uma função auxiliar `findpeaks_simple`, garantindo compatibilidade com Octave puro (sem depender do *signal* toolbox).

---

## 3. Resultados

![Soma de duas senoides + FFT](../Resultados/sim2_atividade2_duas_senoides.png)

Picos efetivamente detectados pelo script:

| Componente | *f* esperada | *f* detectada | *A/2* esperado | |X|/N medido |
|---|---|---|---|---|
| 1 | 50 Hz  | 50,78 Hz  | 0,500 | 0,372 |
| 2 | 120 Hz | 119,14 Hz | 0,350 | 0,248 |

- **Componentes individuais:** as senoides são facilmente reconhecíveis em separado.
- **Sinal somado:** *x(t)* apresenta um padrão de "batimento" no tempo cuja interpretação visual é difícil.
- **Espectro:** dois picos claramente separados, próximos das frequências sintetizadas. As magnitudes ficaram **abaixo** de *A/2* (0,372 vs 0,500 e 0,248 vs 0,350) por causa de **vazamento espectral**: como *Δf = Fs/N = 1,953 Hz*, nem 50 Hz nem 120 Hz caem exatamente em um bin (*50/1,953 = 25,6*; *120/1,953 = 61,4*), então a energia "escapa" para os bins vizinhos. Mesmo assim, a razão entre as duas amplitudes detectadas (*0,248 / 0,372 ≈ 0,67*) reproduz fielmente a razão original entre *A₂/A₁ = 0,7*.

---

## 4. Discussão

A **linearidade da DFT** garante que o espectro da soma é igual à soma dos espectros:

DFT{x₁ + x₂} = DFT{x₁} + DFT{x₂}

Por isso, mesmo quando o sinal somado parece confuso no tempo, o domínio da frequência **decompõe** o sinal de volta nas suas componentes elementares. Esta é a essência do raciocínio espectral: tempo e frequência são representações complementares — informações que estão "espalhadas" no tempo podem aparecer "concentradas" na frequência (e vice-versa).
