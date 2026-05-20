# Atividade 7 — H(z), Resposta ao Impulso e Estabilidade

**Pergunta investigada:** dado o sistema

```
H(z) = 1 / (1 − 0,8·z⁻¹)
```

qual é sua resposta ao impulso? Ela "morre" ou "explode"? E como isso se relaciona com o polo do sistema?

---

## Setup do experimento

Equação de diferenças correspondente:

```
y[n] = x[n] + 0,8·y[n−1]
```

Aplicando *x[n] = δ[n]* (impulso unitário), a saída *y[n]* é, **por definição**, a resposta ao impulso *h[n]*.

Analiticamente:

```
h[n] = (0,8)ⁿ · u[n]
```

— sequência geométrica decrescente, porque *|0,8| < 1*.

O **único polo** está em *z = 0,8*, **dentro do círculo unitário**.

## Roteiro do código

Script: [`atividade_7.m`](../Simulacoes/Octave/atividade_7.m).

```matlab
B = 1;  A = [1 -0.8];        % coeficientes de H(z)
delta = [1 zeros(1, N-1)];   % impulso unitario
h = filter(B, A, delta);     % h[n] numerica
polos = roots(A);            % localiza polo
```

## Saída da simulação

![h[n] decaindo + polo no plano-z](../Resultados/simulacao7atvd7.png)

Saída do console:

```
Polo do sistema   : z = 0.8000
|polo|            : 0.8000
Status            : ESTAVEL (todos os polos dentro do circulo unitario)
Erro maximo entre h numerica e h analitica (0.8^n): 5.55e-17
```

| Verificação | Resultado |
|---|---|
| *h[n]* obtida por `filter` × *(0,8)ⁿ* analítica | **erro ≤ 5,55·10⁻¹⁷** |
| Posição do polo | *z = 0,8* (real, dentro do círculo unitário) |

## O que o gráfico revela

**Painel superior:** *h[n]* decai geometricamente — cada amostra vale 0,8× a anterior. Visualmente, vai a "zero" depois de uns 20–30 passos.

**Painel inferior:** plano-*z*. Círculo unitário tracejado, polo em *z = 0,8* marcado com X, origem com +. O polo está claramente dentro da fronteira de estabilidade.

## Critério BIBO de Estabilidade

Um sistema LTI discreto é **estável BIBO** (*bounded-input, bounded-output*) se e somente se sua resposta ao impulso é **absolutamente somável**:

```
Σ |h[n]| < ∞
```

Para *h[n] = αⁿ·u[n]*, a soma é série geométrica:

```
Σ αⁿ = 1/(1−α)    se |α| < 1
```

— converge se e somente se |α| < 1. Equivalentemente, **todos os polos de H(z) devem estar dentro do círculo unitário no plano-z**.

## Paralelo com sistemas contínuos

| Domínio | Plano | Variável | Região estável |
|---|---|---|---|
| Contínuo (Laplace) | *s* | *s = σ + jω* | Re{s} < 0 (semi-plano esquerdo) |
| Discreto (Transformada-Z) | *z* | *z = e^{sT}* | \|z\| < 1 (interior do círculo unitário) |

O mapeamento *z = e^{sT}* leva o eixo imaginário do plano-*s* exatamente sobre o círculo unitário do plano-*z*. Ou seja: o critério físico é o mesmo — **decaimento exponencial da resposta ao impulso** — apenas a forma matemática muda.

## Lição prática

Este é o **filtro IIR passa-baixas de primeira ordem**, presente em todo lugar:

- Suavização de leituras de sensor (média móvel exponencial);
- Demoduladores de envelope simples;
- Estimadores de baseline em ECG, vibração, áudio;
- Filtragem de DC em pré-amplificadores digitais.

A estabilidade aqui depende exclusivamente de um número: |α|. Subir α perto de 1 deixa o filtro "mais seletivo" mas também mais lento; ultrapassar α = 1 transforma o "filtro" em uma exponencial divergente.
