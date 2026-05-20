# Atividade 1 — Senoide Discreta e Identificação de Frequência via FFT

**Disciplina:** Processamento Digital de Sinais
**Parte 3:** Análise no Domínio da Frequência

---

## Enunciado

Gere uma senoide discreta de frequência normalizada *f₀ = 0,1* e comprimento *N = 128*. Represente o sinal no domínio do tempo e calcule seu espectro utilizando a FFT. Identifique, no gráfico, a frequência dominante observada.

---

## 1. Definição do Sinal

A **frequência normalizada** *f₀ = 0,1* corresponde à fração da taxa de amostragem ocupada pela senoide. Em frequência angular:

ω₀ = 2π·f₀ = 0,2π rad/amostra

O sinal gerado é:

x[n] = sin(2π·f₀·n),  n = 0, 1, …, 127

Não foi especificada uma taxa de amostragem *Fs* — a análise pode ser feita em termos de frequência normalizada, com o eixo espectral em [0; 0,5] (de DC a Nyquist).

---

## 2. Implementação

O script [`atividade_1.m`](../Simulacoes/Octave/atividade_1.m) implementa o experimento. Trecho principal:

```matlab
N  = 128;
f0 = 0.1;
n  = 0:N-1;
x  = sin(2*pi*f0*n);

X      = fft(x);
mag    = abs(X)/N;
f_nrm  = (0:N-1)/N;
```

Como o sinal é real, basta exibir a metade *0 ≤ k < N/2* (frequências 0 a 0,5), conforme a simetria conjugada *X[N−k] = X*[k]*.

---

## 3. Resultados

![Senoide discreta e seu espectro](../Resultados/sim1_atividade1_senoide_fft.png)

Valores medidos na execução do script:

| Grandeza | Valor obtido |
|---|---|
| Frequência dominante detectada | *f = 0,1016* (bin *k = 13*) |
| Frequência esperada | *f₀ = 0,1000* |
| Magnitude do pico (|X|/N) | 0,4666 |

- **Domínio do tempo:** senoide periódica com *1/f₀ = 10* amostras por período. Em *N = 128* amostras, são contabilizadas *N·f₀ = 12,8* oscilações completas.
- **Domínio da frequência:** o pico aparece em *k = 13* (*f = 13/128 = 0,1016*). Como *f₀·N = 12,8* não é inteiro, a energia se distribui entre *k = 12* e *k = 13*, com leve vazamento espectral nas demais frequências.
- **Magnitude do pico ≈ 0,467**, próxima — mas não exatamente igual — a *A/2 = 0,5*. A diferença vem justamente do vazamento: parte da energia que "deveria" estar concentrada em um bin escapa para os vizinhos.

---

## 4. Discussão

A FFT confirma o conteúdo conhecido do sinal: existe uma única componente em *f₀ = 0,1*. Se *f₀·N* fosse inteiro (ex.: *f₀ = 12/128 ≈ 0,09375*), o pico cairia exatamente sobre um bin e o espectro teria apenas duas amostras não-nulas. Como esse não é o caso, observa-se um pico "estendido" — efeito que é tema da Atividade 4 (janelamento).

| Aspecto | Valor |
|---|---|
| Frequência normalizada | *f₀ = 0,1* |
| Comprimento | *N = 128* amostras |
| Períodos contidos | *N·f₀ = 12,8* |
| Posição teórica do pico no DFT | *k ≈ 12,8* (não inteiro) |
| Posição medida (bin de máximo) | *k = 13 → f = 0,1016* |
| Magnitude do pico (medida) | 0,4666 |
| Magnitude teórica | *A/2 = 0,5* |
| Erro relativo da frequência | (0,1016 − 0,1)/0,1 = 1,6 % |
