# Atividade 9 — Sinal Harmônico e Diagnóstico de Vibração

## Enunciado

Gere um sinal contendo uma frequência principal e uma componente harmônica. Calcule o espectro e identifique as frequências presentes. Discuta como esse tipo de análise pode ser útil no diagnóstico de vibrações mecânicas e falhas periódicas.

---

## 1. Cenário Simulado

Um eixo girando a **1800 RPM** corresponde a *f₁ = 30 Hz* (frequência de rotação fundamental, "1X" em terminologia industrial). Foi simulado um sinal contendo a fundamental e duas harmônicas:

x(t) = 1,0·sin(2π·30·t) + 0,5·sin(2π·60·t) + 0,3·sin(2π·90·t)

Parâmetros: *Fs = 2000 Hz*, *T = 2 s*, *N = 4000*.

---

## 2. Implementação

Script: [`atividade_9.m`](../Simulacoes/Octave/atividade_9.m)

---

## 3. Resultados

![Sinal harmônico — espectro 1X / 2X / 3X](../Resultados/sim9_atividade9_harmonicos.png)

| Componente | Frequência | Amplitude |
|---|---|---|
| 1X (rotação) | 30 Hz | ≈ 0,5 |
| 2X (segunda harmônica) | 60 Hz | ≈ 0,25 |
| 3X (terceira harmônica) | 90 Hz | ≈ 0,15 |

---

## 4. Discussão — Vibração e Manutenção Preditiva

A análise espectral é a **espinha dorsal da manutenção preditiva industrial** (normas ISO 10816 e ISO 13373). Cada tipo de falha mecânica deixa uma **assinatura espectral característica**:

| Padrão espectral | Falha provável |
|---|---|
| 1X muito alto | Desbalanceamento de massa |
| 2X dominante | Desalinhamento de eixo, eixo empenado |
| 3X + harmônicos altos | Folgas mecânicas, falhas em mancais, engrenagens |
| Bandas laterais em torno de harmônicos | Defeitos em rolamentos (BPFO, BPFI, BSF) |
| Picos em múltiplos da frequência de engrenamento | Falhas em engrenagens |

### Por que a FFT é tão eficaz aqui?

A vibração de uma máquina é, em primeira aproximação, **periódica e linear**. Cada elemento mecânico (eixo, mancal, engrenagem) introduz componentes em frequências determinísticas, calculáveis a partir da geometria e da rotação. A FFT decompõe a vibração observada exatamente nessas componentes, atuando como uma "impressão digital" do estado da máquina.

### Limitações

- Vibrações de **impacto** (choques, falhas locais em rolamentos) geram componentes transitórias mal representadas pela FFT tradicional — exigem técnicas complementares: envelope (Hilbert), wavelet, cepstrum.
- **Mudanças bruscas** durante o tempo de observação borram o espectro — pode ser necessário usar janelas curtas (STFT).

Ainda assim, a FFT continua sendo a **primeira ferramenta** aplicada em qualquer análise de vibração — e na maioria dos casos, basta.
