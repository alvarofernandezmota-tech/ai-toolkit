# OpenCode + LiteLLM — Setup y Diario del Experimento

> **Fecha inicio:** 2026-04-15  
> **Proyecto:** ai-toolkit / Arquitectura Colmena  
> **Objetivo:** Conectar OpenCode al proxy LiteLLM local para poder comparar múltiples LLMs desde un único entorno de coding

---

## ¿Qué es este experimento?

Usar OpenCode como **laboratorio de comparación de LLMs**. La idea es mandar el mismo prompt / tarea a distintos modelos enrutados a través de LiteLLM como proxy unificado, y documentar para qué sirve mejor cada uno, cómo responden, cuál es más rápido, más preciso, más creativo, etc.

---

## Arquitectura

```
OpenCode (cliente UI)
    │
    │  HTTP /v1  (openai-compatible)
    ▼
LiteLLM Proxy  →  localhost:8000
    │
    ├── principal    → Gemini 2.5 Pro (Google)
    ├── gemini-flash → Gemini 2.0 Flash
    ├── claude-sonnet→ Claude Sonnet (Anthropic)
    ├── claude-opus  → Claude Opus (Anthropic)
    ├── gpt-4o       → GPT-4o (OpenAI)
    ├── o3-mini      → o3-mini Reasoning (OpenAI)
    ├── deepseek-r1  → DeepSeek R1 Reasoning
    ├── deepseek-v3  → DeepSeek V3 Chat
    ├── llama-4-*    → Meta Llama 4 (vía OpenRouter)
    ├── qwen3-235b   → Qwen3 235B Thinking (vía OpenRouter)
    ├── mistral-large→ Mistral Large
    └── codestral    → Codestral (especializado en código)
```

---

## Config OpenCode (`~/.config/opencode/opencode.json`)

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "litellm/principal",
  "provider": {
    "litellm": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "LiteLLM Colmena",
      "options": {
        "baseURL": "http://localhost:8000/v1",
        "apiKey": "sk-litellm-local"
      },
      "models": {
        "principal":       { "name": "Principal (Colmena Default)" },
        "gemini-pro":      { "name": "Gemini 2.5 Pro" },
        "gemini-flash":    { "name": "Gemini 2.0 Flash" },
        "claude-sonnet":   { "name": "Claude 3.7 Sonnet" },
        "claude-opus":     { "name": "Claude 3 Opus" },
        "gpt-4o":          { "name": "GPT-4o" },
        "gpt-4o-mini":     { "name": "GPT-4o Mini" },
        "o3-mini":         { "name": "o3-mini Reasoning" },
        "deepseek-r1":     { "name": "DeepSeek R1 Reasoning" },
        "deepseek-v3":     { "name": "DeepSeek V3" },
        "llama-4-maverick":{ "name": "Llama 4 Maverick" },
        "llama-4-scout":   { "name": "Llama 4 Scout" },
        "qwen3-235b":      { "name": "Qwen3 235B Thinking" },
        "mistral-large":   { "name": "Mistral Large" },
        "codestral":       { "name": "Codestral (Código)" }
      }
    }
  }
}
```

### Aplicar config sin editor

```bash
tee ~/.config/opencode/opencode.json << 'EOF'
# pegar el JSON de arriba
EOF
```

---

## Problemas encontrados y soluciones

### ❌ Problema 1: OpenCode seguía usando Qwen3 de OpenRouter

**Síntoma:** La barra inferior mostraba `Qwen3 235B A22B Thinking 2507 OpenRouter` aunque el config apuntaba a LiteLLM.

**Causa:** El campo `models` no estaba definido en el provider. Sin él, OpenCode no sabe qué modelo ofrecer al provider custom y cae al modelo por defecto global.

**Solución:** Añadir el bloque `models` dentro del provider con al menos la entrada `principal`.

---

### ❌ Problema 2: `opencode auth login` no encuentra "litellm"

**Síntoma:** Al buscar `litellm` en el menú de auth, devuelve `0 matches`.

**Causa:** LiteLLM no es un provider nativo de OpenCode — la autenticación se gestiona directamente por el campo `apiKey` en el config JSON, no por el sistema de auth.

**Solución:** No usar `opencode auth login`. La key `sk-litellm-local` ya está embebida en el config y LiteLLM la valida internamente.

---

### ✅ Estado final confirmado

La barra inferior de OpenCode muestra: **`Principal LiteLLM Colmena`**  
Verificado el 2026-04-15 a las 19:41 CEST.

---

## Cómo cambiar de modelo en OpenCode

1. **Desde la UI:** `Ctrl+P` → buscar `model` → seleccionar
2. **Desde config:** editar `"model": "litellm/nombre-modelo"` y relanzar
3. **Variables de entorno (override temporal):**
   ```bash
   OPENCODE_MODEL=litellm/deepseek-r1 opencode
   ```

---

## Taxonomía de modelos para el experimento

| Dimensión | Modelos a comparar | Para qué sirve |
|---|---|---|
| **Razonamiento / Thinking** | o3-mini, DeepSeek R1, Qwen3 235B, Gemini 2.5 Pro | Problemas complejos, matemáticas, lógica |
| **Código** | Codestral, Claude Sonnet, GPT-4o, DeepSeek V3 | Generación, refactor, debug |
| **Contexto largo** | Gemini 2.5 Pro (1M tokens), Claude Opus | Análisis de repos enteros, documentos |
| **Velocidad / Coste** | Gemini Flash, GPT-4o Mini, Llama 4 Scout | Tareas repetitivas, pipelines |
| **Open Source** | Llama 4, Qwen3, DeepSeek R1, Mistral Large | Privacidad, self-hosting |
| **Especializado código** | Codestral | Fill-in-the-middle, completions |

---

## Variables de entorno necesarias

Añadir a `~/.bashrc` o `~/.zshrc` según los proveedores que uses:

```bash
# Google
export GOOGLE_GENERATIVE_AI_API_KEY="..."

# Anthropic
export ANTHROPIC_API_KEY="..."

# OpenAI
export OPENAI_API_KEY="..."

# DeepSeek
export DEEPSEEK_API_KEY="..."

# Mistral
export MISTRAL_API_KEY="..."

# OpenRouter (fallbacks + modelos gratuitos)
export OPENROUTER_API_KEY="..."

# Groq (velocidad)
export GROQ_API_KEY="..."

# Cerebras (velocidad)
export CEREBRAS_API_KEY="..."
```

---

## Arrancar el stack completo

```bash
# Terminal 1 — LiteLLM proxy
litellm --config ~/projects/ai-toolkit/litellm-config.yaml --port 8000

# Terminal 2 — OpenCode
cd ~/projects/ai-toolkit
opencode
```

---

## Próximos pasos del experimento

- [ ] Crear plantilla de prompt estándar para comparaciones justas
- [ ] Documentar resultados por modelo en `investigacion/comparativa-llms.md`
- [ ] Medir latencia real de cada modelo en condiciones locales
- [ ] Probar tarea de coding compleja en cada modelo y comparar calidad
- [ ] Añadir Ollama al proxy para modelos 100% locales
