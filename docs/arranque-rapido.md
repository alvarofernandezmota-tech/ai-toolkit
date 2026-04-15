# Arranque Rápido — Stack Completo

> Cómo levantar todo el ecosistema en una sola terminal

## Comando único

```bash
cd ~/projects/ai-toolkit
pkill -f litellm 2>/dev/null; sleep 1
litellm --config litellm-config.yaml --port 8000 &
sleep 3 && opencode
```

## Verificar que funciona

- Barra inferior de OpenCode debe mostrar: **`Principal LiteLLM Colmena`**
- Si muestra otro modelo (Qwen3, OpenRouter...) → ver `docs/opencode-setup.md`

## Si el puerto 8000 está ocupado

```bash
lsof -i :8000
kill -9 <PID>
```

## Cambiar de modelo en OpenCode

```
Ctrl+P → escribir "model" → seleccionar
```

## Modelos disponibles

| Alias | Modelo real | Proveedor |
|---|---|---|
| `principal` | gemini-2.0-flash | Google |
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

## Variables de entorno necesarias

```bash
export GOOGLE_GENERATIVE_AI_API_KEY="..."
export ANTHROPIC_API_KEY="..."
export OPENAI_API_KEY="..."
export DEEPSEEK_API_KEY="..."
export MISTRAL_API_KEY="..."
export OPENROUTER_API_KEY="..."
export GROQ_API_KEY="..."
```
