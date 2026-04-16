# Arranque Rápido — Stack Completo

> Cómo levantar todo el ecosistema en una sola terminal

## ⚠️ Regla de oro — SIEMPRE antes de arrancar

```bash
cd ~/projects/ai-toolkit
git pull                          # ← OBLIGATORIO. Sin esto corres config desactualizada.
bash scripts/start-colmena.sh
```

> Si `git pull` falla por cambios locales:
> ```bash
> git checkout -- opencode.json && git pull
> ```
> Esto descarta cambios locales y coge la config de GitHub.

---

## Verificar que funciona

- Barra inferior de OpenCode debe mostrar: **`Principal LiteLLM Colmena`**
- Si muestra otro modelo (Qwen3, OpenRouter...) → ver `docs/opencode-setup.md`

---

## Si el puerto 8000 está ocupado

```bash
lsof -i :8000
kill -9 <PID>
```

---

## Cambiar de modelo en OpenCode

```
Ctrl+P → escribir "model" → seleccionar
```

---

## Modelos disponibles — Colmena (nube via LiteLLM)

| Alias | Modelo real | Proveedor |
|---|---|---|
| `principal` | cerebras-3.3-70b (multi-fallback) | Cerebras/Groq |
| `gemini-pro` | gemini-2.5-pro-exp | Google |
| `gemini-flash` | gemini-2.0-flash | Google |
| `claude-sonnet` | claude-3-5-sonnet | Anthropic |
| `claude-opus` | claude-3-opus | Anthropic |
| `gpt-4o` | gpt-4o | OpenAI |
| `o3-mini` | o3-mini | OpenAI |
| `deepseek-r1` | deepseek-reasoner | DeepSeek |
| `deepseek-v3` | deepseek-chat | DeepSeek |
| `llama-4-maverick` | llama-4-maverick | Meta/OpenRouter |
| `qwen3-235b` | qwen3-235b-a22b | Alibaba/OpenRouter |
| `mistral-large` | mistral-large-latest | Mistral |
| `codestral` | codestral-latest | Mistral |

## Modelos disponibles — Ollama local (GTX 1060, sin internet)

| Alias en OpenCode | Tamaño | Uso |
|---|---|---|
| `ollama/qwen3:8b-q4_K_M` | 5.2 GB | Chat general, razonamiento |
| `ollama/qwen2.5-coder:7b` | 4.7 GB | Código rápido |
| `ollama/qwen2.5-coder:14b` | 9.0 GB | Código potente (VRAM+RAM) |
| `ollama/deepseek-r1:14b` | 9.0 GB | Razonamiento profundo (VRAM+RAM) |
| `ollama/nomic-embed-text` | 274 MB | Embeddings / RAG |

> Para usar Ollama local: `Ctrl+P → model → ollama/...`  
> Ollama debe estar corriendo: `ollama serve` (normalmente ya corre solo)

---

## Variables de entorno necesarias

```bash
export GOOGLE_GENERATIVE_AI_API_KEY="..."
export ANTHROPIC_API_KEY="..."
export OPENAI_API_KEY="..."
export DEEPSEEK_API_KEY="..."
export MISTRAL_API_KEY="..."
export OPENROUTER_API_KEY="..."
export GROQ_API_KEY="..."
export CEREBRAS_API_KEY="..."
```
