# 🔧 Devstral 2 — El mejor modelo de coding open source

> Lanzado por Mistral AI el 9 de diciembre de 2025. 123B parámetros, 72.2% en SWE-bench Verified. Mejor que DeepSeek V3.2 en coding agentic.

**Anuncio oficial:** [mistral.ai/news/devstral-2-vibe-cli](https://mistral.ai/news/devstral-2-vibe-cli)
**Cobertura VentureBeat:** [mistral-launches-powerful-devstral-2-coding-model-including-open-source](https://venturebeat.com/ai/mistral-launches-powerful-devstral-2-coding-model-including-open-source)

---

## Benchmarks reales (fuentes verificadas)

| Modelo | SWE-bench Verified | Open Source | Contexto | Tamaño |
|---|---|---|---|---|
| **Devstral 2** | **72.2%** | TBD | 256K | 123B |
| **Devstral Small 2** | 68.0% | ✅ Apache 2.0 | 256K | 24B |
| DeepSeek V3.2 | ~72% | ✅ | 128K | 671B |
| Kimi K2 | Alta | ✅ | 128K | Muy grande |
| Claude Sonnet 4 | Mejor | ❌ Propietario | 200K | Desconocido |

**Dato clave:** Devstral 2 con 123B supera a DeepSeek V3.2 de 671B. Es 3x más pequeño que DeepSeek y 8x más pequeño que Kimi K2.

**En comparaciones directas humanas:**
- Devstral 2 gana al 42.8% de las veces vs DeepSeek V3.2
- Devstral 2 gana al 53.1% de las veces vs Claude Sonnet 4.x

---

## Devstral Small 2 — La versión que puedes correr

- **24B parámetros** — corre en una RTX 4090 o Mac con 32GB RAM
- **68% SWE-bench** — mejor que la mayoría de modelos 70B
- **Apache 2.0** — completamente libre
- **Repo HuggingFace:** [mistralai/Devstral-Small-2505](https://huggingface.co/mistralai/Devstral-Small-2505)

---

## Cómo usarlo en el ecosistema (gratis vía API)

### En Claude Code
```bash
export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
export ANTHROPIC_API_KEY=sk-or-tu_key

claude --model openrouter/mistralai/devstral-2:free
```

### En Aider
```bash
aider --model openrouter/mistralai/devstral-2:free

# O para Devstral Small 2 (más rápido, sin rate limits)
aider --model openrouter/mistralai/devstral-small-2:free
```

### Con Continue.dev (VS Code)
Devstral ya está integrado en Continue.dev:
[blog.continue.dev/devstral](https://blog.continue.dev/devstral)

### Con Zed Editor
Issue de soporte: [github.com/zed-industries/zed/discussions/31154](https://github.com/zed-industries/zed/discussions/31154)

---

## Cuándo usar Devstral 2 vs otros modelos

| Tarea | Modelo recomendado | Por qué |
|---|---|---|
| **Agentic coding multi-file** | Devstral 2 | Diseñado específicamente para esto |
| **Fix rápido del día a día** | Groq llama-3.3-70b | Instantáneo, 14.400 req/día |
| **Razonamiento / arquitectura** | DeepSeek R1-0528 | Thinking más profundo |
| **Contexto muy largo** | Devstral 2 (256K) | Mayor ventana que DeepSeek |

---

## Experimento pendiente

- [ ] Probar Devstral 2 en Claude Code con THDORA para refactorización multi-fichero
- [ ] Comparar velocidad Devstral 2 vs Qwen3 Coder en OpenRouter
- [ ] Probar Devstral Small 2 local con Ollama si se tiene GPU

Resultados → añadir a [experimentos.md](experimentos.md)
