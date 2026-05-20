# Atividade 6 — DFT Direta vs. FFT: Equivalência e Custo

## Enunciado

Implemente a DFT de forma direta, utilizando a definição matemática, para um sinal curto com poucas amostras. Em seguida, compare o resultado obtido com a função `fft`. Discuta a equivalência entre os resultados e a diferença no custo computacional.

---

## 1. Definição Implementada

A DFT é definida por:

X[k] = Σₙ₌₀ᴺ⁻¹ x[n] · e^{−j·2π·k·n/N},   k = 0, 1, …, N−1

Implementação direta com dois laços aninhados (script [`atividade_6.m`](../Simulacoes/Octave/atividade_6.m)):

```matlab
for k = 0:N-1
    soma = 0;
    for nn = 0:N-1
        soma = soma + x(nn+1) * exp(-1j*2*pi*k*nn/N);
    end
    X_direta(k+1) = soma;
end
```

Sinal de teste: *x[n] = cos(2π·0,125·n) + 0,5·sin(2π·0,25·n)*, *N = 16*.

---

## 2. Resultados

![DFT direta vs FFT](../Resultados/sim6_atividade6_dft_vs_fft.png)

A DFT direta e a saída de `fft` são **graficamente indistinguíveis**. Valores medidos na execução:

| Grandeza | Valor |
|---|---|
| Tempo da DFT direta (laços) | 3,42 ms |
| Tempo da FFT do Octave | 0,103 ms |
| Razão (DFT / FFT) | **≈ 33×** |
| Erro máximo |DFT_direta − FFT| | 1,96·10⁻¹⁴ |

O erro é apenas o ruído de arredondamento de ponto flutuante (epsilon de máquina). Repare que, **mesmo para *N = 16***, a FFT do Octave foi cerca de 33 vezes mais rápida que a implementação ingênua em laço duplo — bem além do ganho teórico de 4× (256/64). A diferença vem do overhead dos laços interpretados no Octave (que a FFT compilada evita) e de otimizações BLAS internas.

---

## 3. Custo Computacional

| *N* | DFT direta (*N²*) | FFT (*N log₂N*) | Ganho |
|---|---|---|---|
| 16    | 256       | 64       | 4× |
| 64    | 4 096     | 384      | 11× |
| 256   | 65 536    | 2 048    | 32× |
| 1 024 | 1 048 576 | 10 240   | 102× |
| 4 096 | 16 777 216| 49 152   | 341× |

Para um vetor de áudio de 1 s a 44,1 kHz (*N ≈ 44 100*), a DFT direta exigiria ≈ 2·10⁹ operações complexas, enquanto a FFT requer ≈ 7·10⁵ — uma diferença de mais de 3 ordens de magnitude.

---

## 4. Discussão

**A FFT não é uma transformada diferente da DFT.** É um conjunto de algoritmos (Cooley-Tukey, Bluestein, prime-factor, etc.) que exploram simetrias das exponenciais complexas *W_N^{kn} = e^{−j·2π·kn/N}* para evitar cálculos redundantes. A versão clássica de Cooley-Tukey (1965), aplicável quando *N* é potência de 2, decompõe a DFT em duas DFTs de tamanho *N/2*, recursivamente, atingindo *O(N log N)*.

Em termos práticos:

- **Tempo real**: a FFT viabiliza análise espectral em DSPs, FPGAs e microcontroladores de baixo custo;
- **Áudio digital**: cada quadro do MP3, AAC, Opus e da maioria dos codecs modernos depende de variantes da DFT;
- **OFDM** (Wi-Fi, LTE, 5G): toda a modulação é construída em torno de IFFT/FFT.

Sem a FFT, boa parte da engenharia digital moderna simplesmente não existiria como a conhecemos.
