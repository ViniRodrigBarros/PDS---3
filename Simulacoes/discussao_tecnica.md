# Discussão Técnica dos Resultados

Este documento apresenta a interpretação dos resultados obtidos em cada
uma das dez simulações da pasta `Simulacoes/Octave/`, relacionando
teoria e prática e respondendo, ao final, ao problema norteador (PBL).
Os valores numéricos foram extraídos diretamente da execução dos
scripts (saída do `run_all`).

---

## Questão 1 — Senoide discreta + FFT

A senoide com frequência normalizada *f₀ = 0,1* e *N = 128* amostras
gera, no domínio da frequência, **um pico bem localizado** próximo
ao bin teórico *k = 12,8*. Como *f₀·N* não é inteiro, a energia se
distribui entre *k = 12* e *k = 13* — uma primeira pista de que a
DFT não é "infinitamente precisa" em frequência. Na execução, o bin
de máximo ficou em *k = 13*, correspondendo a *f = 13/128 = 0,1016*
(erro relativo de 1,6 %), e a magnitude do pico foi **0,4666** —
levemente abaixo do valor teórico *A/2 = 0,5*, exatamente porque
parte da energia escapou para o bin vizinho.

**Conclusão:** o espectro confirma a frequência sintetizada com
precisão limitada pelo *Δf* da DFT, ilustrando o efeito de
vazamento quando *f₀·N* não é inteiro.

## Questão 2 — Soma de duas senoides

Ao somar uma senoide de 50 Hz (*A₁ = 1,0*) com outra de 120 Hz
(*A₂ = 0,7*) e aplicar a FFT, observam-se **dois picos bem definidos**
próximos dessas frequências. Picos medidos na execução:

| Componente | *f* esperada | *f* detectada | |X|/N medido | *A/2* teórico |
|---|---|---|---|---|
| 1 | 50 Hz  | 50,78 Hz  | 0,372 | 0,500 |
| 2 | 120 Hz | 119,14 Hz | 0,248 | 0,350 |

As amplitudes ficaram **abaixo** de *A/2* (cerca de 70 % do teórico)
porque *Δf = Fs/N = 1,953 Hz* não divide as frequências
sintetizadas — energia se distribuiu entre bins vizinhos por
vazamento. Mesmo assim, a *razão* entre as amplitudes medidas
(*0,248/0,372 = 0,67*) reproduz fielmente a razão original
(*A₂/A₁ = 0,7*).

**Conclusão:** a FFT decompõe a soma de senoides em suas componentes
elementares com precisão suficiente para identificar **frequência** e
**proporção relativa de amplitudes** — mesmo quando o vazamento
distorce os valores absolutos.

## Questão 3 — Aliasing

Uma senoide de 180 Hz amostrada a **1000 Hz** aparece corretamente em
180 Hz (sem aliasing, pois *fs > 2·f*).
Quando a mesma senoide é amostrada a **200 Hz**, o critério de Nyquist
é violado (*fs/2 = 100 < 180*). O espectro mostra o pico em
*|180 − 200| = 20 Hz*, ou seja, a componente de alta frequência passa
a se *disfarçar* de uma componente de baixa frequência. Sem a
informação prévia da frequência original, o engenheiro concluiria,
erroneamente, que o sinal possui energia em 20 Hz.

**Conclusão:** o aliasing é um erro **irrecuperável** — uma vez
ocorrido, não há como, observando apenas o sinal amostrado, descobrir
qual era a frequência verdadeira. A única defesa é o **filtro
anti-aliasing analógico** antes do A/D.

## Questão 4 — Janelamento

A senoide de **100,7 Hz** foi escolhida propositadamente por não cair
em um bin inteiro da FFT. Sem janelamento (janela retangular implícita
no truncamento), os lóbulos laterais espalham-se em torno de −13 dB,
mascarando outras componentes próximas. Aplicando-se as janelas:

| Janela        | Atenuação do 1º lóbulo lateral |
|---------------|---------------------------------|
| Retangular    | ~ −13 dB                        |
| Hann          | ~ −32 dB                        |
| Hamming       | ~ −43 dB                        |

**Conclusão:** o janelamento **troca resolução por contraste** — o
lóbulo principal alarga um pouco, mas os lóbulos laterais caem
drasticamente, deixando o espectro muito mais limpo para a
identificação de componentes próximas em amplitude diferentes.

## Questão 5 — Sinal com ruído aditivo

O sinal *s(t) + r(t)*, com ruído gaussiano de *σ = 1,2* (SNR medido
de **−4,59 dB** — ou seja, o ruído tem mais potência que a senoide),
fica **visualmente irreconhecível no domínio do tempo**. Já a FFT
mostra, sem ambiguidade, um pico em **59,57 Hz** (bin 61) emergindo
de um piso de ruído relativamente baixo. O leve desvio em relação
aos 60 Hz teóricos corresponde a *Δf/2*, limitação inerente à
resolução *Δf = Fs/N = 0,977 Hz* — não ao ruído.

A razão pela qual a senoide se destaca é elementar: sua energia
concentra-se em **um único bin**, enquanto a energia do ruído branco
distribui-se uniformemente por todos os *N/2 ≈ 512* bins. O **ganho
de processamento** da FFT é, portanto, proporcional a *N*.

**Conclusão:** a análise espectral é uma das ferramentas mais
poderosas para **detecção de sinais em meio ao ruído**, princípio
explorado em radar, sonar, comunicações digitais e diagnóstico de
vibrações.

## Questão 6 — DFT direta vs. FFT

A DFT, implementada diretamente pela definição
*X[k] = Σ x[n]·e^{−j2πkn/N}*, produz **exatamente o mesmo resultado
numérico** da função `fft`: o erro máximo medido foi
**1,96·10⁻¹⁴**, dentro da precisão de ponto flutuante.

A diferença não está na matemática, e sim no **custo computacional**.
Tempos medidos na execução (*N = 16*):

| Implementação | Tempo medido | Operações teóricas |
|---|---|---|
| DFT direta (laços duplos) | 3,42 ms | 256 (*N²*) |
| `fft` do Octave | 0,103 ms | 64 (*N·log₂N*) |
| Razão DFT/FFT | **≈ 33×** | — |

A FFT já foi 33× mais rápida mesmo para apenas 16 amostras —
**bem além** do ganho teórico de 4×. Isso revela um segundo efeito:
o overhead dos laços interpretados penaliza fortemente a
implementação ingênua. Para *N* grande, o ganho cresce ainda mais:

| N    | Operações DFT direta (*N²*) | Operações FFT (*N·log₂N*) | Ganho teórico |
|------|-----------------------------|----------------------------|---------------|
| 16   | 256                         | 64                         | 4×    |
| 256  | 65 536                      | 2 048                      | 32×   |
| 1024 | 1 048 576                   | 10 240                     | 102×  |
| 4096 | 16 777 216                  | 49 152                     | 341×  |

**Conclusão:** FFT e DFT são equivalentes em resultado, mas a FFT é o
que torna a análise espectral em **tempo real** computacionalmente
viável.

## Questão 7 — Resposta ao impulso e estabilidade

Para *H(z) = 1 / (1 − 0,8 z⁻¹)*, a resposta ao impulso obtida por
`filter` coincide com a expressão analítica *h[n] = (0,8)ⁿ·u[n]* —
erro numérico máximo medido de **5,55·10⁻¹⁷** (precisão de máquina
do tipo `double`).

A sequência **decai geometricamente** para zero, sendo absolutamente
somável. Equivalentemente, o único polo do sistema, *z = 0,8*, está
**dentro do círculo unitário**. Pelos dois caminhos, conclui-se que o
sistema é **estável BIBO**.

**Conclusão:** o critério "polos dentro do círculo unitário" é a
versão discreta do clássico "polos no semi-plano esquerdo" da
Transformada de Laplace. A Transformada-Z fornece, portanto, uma
ferramenta direta para análise de estabilidade em sistemas digitais.

## Questão 8 — Resolução espectral

Duas senoides separadas por **8 Hz** (100 Hz e 108 Hz) são analisadas
com dois comprimentos diferentes:

| N    | Δf = fs/N | Resultado                       |
|------|-----------|---------------------------------|
| 64   | 15,6 Hz   | Um único pico borrado           |
| 1024 | 0,98 Hz   | Dois picos perfeitamente separados |

**Conclusão:** a resolução em frequência depende exclusivamente do
**tempo de observação** (*N/fs*). Para distinguir componentes
próximas, é preciso observar o sinal por mais tempo — não basta apenas
amostrar mais rápido. Esta é uma das compensações fundamentais do
processamento digital: tempo vs. frequência.

## Questão 9 — Sinal harmônico (vibração mecânica)

O sinal composto por uma fundamental em **30 Hz** mais harmônicos em
**60 Hz (2×)** e **90 Hz (3×)** gera um espectro com três picos
inequívocos, cujas amplitudes refletem a contribuição relativa de
cada componente.

Na linguagem da manutenção preditiva industrial:

- 1× dominante → desbalanceamento de massa;
- 2× alto → desalinhamento de eixo;
- 3× e harmônicos superiores → folgas mecânicas, falhas em
  engrenagens.

**Conclusão:** a FFT funciona como **assinatura espectral** da
máquina, permitindo identificar não apenas *que* há um problema, mas
*qual* o problema.

## Questão 10 — Análise espectral de sinal "real"

A simulação combina rotação de eixo (25 Hz), desalinhamento (50 Hz),
falha de rolamento (154 Hz) e ruído de fundo. Aplicando-se janela de
Hann e FFT, **todos os três picos relevantes** são identificados
claramente acima do piso de ruído. Valores medidos:

| Componente | *f* esperada | *f* detectada | |X|/N medido |
|---|---|---|---|
| 1X — rotação | 25 Hz | 25,00 Hz | 0,2499 |
| 2X — desalinhamento | 50 Hz | 50,00 Hz | 0,1500 |
| BPFO — rolamento | 154 Hz | 154,00 Hz | 0,1015 |

A localização foi perfeita até a resolução de bin (*Δf = 0,5 Hz*)
porque *Fs* e *T* foram escolhidos de forma que as componentes
caíssem exatamente em bins inteiros — uma situação ideal que
dificilmente se reproduz numa aquisição real, mas que aqui evidencia
o poder de detecção da técnica.

Este exemplo unifica todas as ideias da etapa:

- amostragem adequada (*Fs = 5000 Hz*) para evitar aliasing;
- janelamento (Hann) para reduzir vazamento;
- FFT para análise eficiente;
- interpretação física dos picos como diagnóstico de falhas.

---

## Resposta ao Problema Norteador (PBL)

> *Como identificar, a partir do conteúdo espectral de um sinal real,
> informações relevantes sobre o comportamento dinâmico de um sistema
> físico e quais limitações práticas devem ser consideradas durante
> a aquisição e análise desses dados?*

O conteúdo espectral revela **as frequências características do
sistema** — rotações, harmônicos, ressonâncias, falhas periódicas e
ruído de fundo. Cada pico tem significado físico: pode indicar uma
fonte natural (rotação do motor, batida cardíaca, onda portadora) ou
uma assinatura de falha (desbalanceamento, defeito em rolamento,
oscilação de controle).

Para extrair essa informação corretamente, no entanto, é preciso
respeitar **três limitações práticas** evidenciadas nas simulações:

1. **Taxa de amostragem suficiente** (*fs > 2·f_max*), para evitar
   aliasing — Questão 3;
2. **Tempo de observação suficiente** (*N grande*), para garantir
   resolução em frequência adequada — Questão 8;
3. **Janelamento apropriado**, para mitigar o vazamento espectral
   inerente ao truncamento — Questão 4.

Quando essas três condições são atendidas, a análise espectral
deixa de ser apenas uma ferramenta matemática e passa a ser, na
prática da engenharia, uma forma de **observar o invisível**: ouvir
o que o sinal de tempo não consegue contar.
