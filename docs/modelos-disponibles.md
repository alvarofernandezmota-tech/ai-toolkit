# Modelos Disponibles en ai-toolkit

> Generado: 2026-04-17  
> Fuente: `litellm-config.yaml` + `opencode.json`

---

## Modelos LiteLLM (localhost:8000)

Accesibles desde OpenCode como `litellm/<id>`

### Modelos Premium

| ID | Nombre | Proveedor |
|----|--------|----------|
| `gemini-pro` | Gemini 2.5 Pro | Google |
| `gemini-flash` | Gemini 2.0 Flash ⚡ | Google |
| `gemini-flash-lite` | Gemini 2.0 Flash Lite | Google |
| `claude-sonnet` | Claude Sonnet | Anthropic |
| `claude-opus` | Claude Opus | Anthropic |
| `gpt-4o` | GPT-4o | OpenAI |
| `gpt-4o-mini` | GPT-4o Mini | OpenAI |
| `o3-mini` | o3-mini | OpenAI |

### Modelos Open Source Cloud

| ID | Nombre | Proveedor |
|----|--------|----------|
| `sambanova-llama4` | SambaNova Llama 4 Maverick | SambaNova |
| `sambanova-deepseek` | SambaNova DeepSeek R1 | SambaNova |
| `sambanova-deepseek-v3` | SambaNova DeepSeek V3 | SambaNova |
| `together-llama4` | Together Llama 4 Maverick | Together AI |
| `together-deepseek` | Together DeepSeek R1 | Together AI |
| `llama-4-maverick` | Llama 4 Maverick | OpenRouter |
| `llama-4-scout` | Llama 4 Scout (free) | OpenRouter |
| `qwen3-235b` | Qwen3 235B | |
| `mistral-large` | Mistral Large | Mistral |
| `codestral` | Codestral | Mistral |

### Fallbacks (alta disponibilidad)

| ID | Nombre |
|----|--------|
| `principal` | Principal (auto-fallback) |
| `groq-fallback` | Groq Fallback ⚡ |
| `cerebras-fallback` | Cerebras Fallback |
| `openrouter-fallback` | OpenRouter Fallback |
| `gemini-fallback` | Gemini Fallback |
| `gemini-lite-fallback` | Gemini Lite Fallback |
| `together-fallback` | Together Fallback |
| `sambanova-fallback` | SambaNova Fallback |

---

## Modelos Ollama Local (GTX 1060, localhost:11434)

Accesibles desde OpenCode como `ollama/<id>`

| ID | Nombre | Uso |
|----|--------|-----|
| `qwen3:8b-q4_K_M` | Qwen3 8B Thinking | Agentic local, razonamiento |
| `qwen2.5-coder:7b` | Qwen2.5 Coder 7B | Código, solo VRAM |
| `qwen2.5-coder:14b` | Qwen2.5 Coder 14B 🚀 | Código avanzado, VRAM+RAM |
| `deepseek-r1:14b` | DeepSeek R1 14B Thinking 🤔 | Razonamiento, VRAM+RAM |
| `nomic-embed-text` | Nomic Embed Text | RAG / Embeddings |

---

## Modelo Default

Configurado en `opencode.json`:

```json
{
  "model": "litellm/gemini-flash"
}
```

Para cambiar temporalmente dentro de OpenCode: `/model litellm/<id>`
