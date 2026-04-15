# Dependencias del Ecosistema

> Todo lo que hay que tener instalado para que el stack funcione.  
> Organizado por capa. Actualizado: 2026-04-15

---

## Capa 0 — Sistema base (WSL / Linux)

```bash
# Herramientas base
sudo apt update && sudo apt install -y \
  git curl wget tmux \
  python3 python3-pip python3-venv \
  nodejs npm
```

| Herramienta | Versión mínima | Para qué |
|---|---|---|
| git | 2.x | Control de versiones |
| tmux | 3.x | Múltiples terminales |
| python3 | 3.10+ | LiteLLM, THDORA, scripts |
| nodejs | 18+ | OpenCode |
| npm | 9+ | OpenCode |

---

## Capa 1 — LiteLLM Proxy

```bash
pip install litellm
# O con extras para todos los proveedores:
pip install 'litellm[proxy]'
```

| Paquete | Versión | Función |
|---|---|---|
| `litellm` | latest | Proxy unificado de LLMs |
| `uvicorn` | latest | Servidor ASGI (se instala con litellm) |

**Arranque:**
```bash
litellm --config ~/projects/ai-toolkit/litellm-config.yaml --port 8000
```

---

## Capa 2 — OpenCode

```bash
npm install -g opencode-ai
```

| Paquete | Versión | Función |
|---|---|---|
| `opencode-ai` | 1.4.6+ | IDE de IA en terminal |
| `@ai-sdk/openai-compatible` | auto | Provider OpenAI-compatible (LiteLLM) |

**Config:** `~/.config/opencode/opencode.json`  
Ver `docs/opencode-setup.md` para el JSON completo.

---

## Capa 3 — APIs necesarias por proveedor

| Variable de entorno | Proveedor | Modelos | Free tier |
|---|---|---|---|
| `GOOGLE_GENERATIVE_AI_API_KEY` | Google AI Studio | gemini-flash, gemini-pro | Sí (limitado) |
| `GROQ_API_KEY` | Groq | llama-3.3-70b, llama3.1-8b | Sí (generoso) |
| `CEREBRAS_API_KEY` | Cerebras | llama3.1-8b | Sí |
| `OPENROUTER_API_KEY` | OpenRouter | qwen3-235b, llama-4, deepseek-r1 | Sí (modelos :free) |
| `ANTHROPIC_API_KEY` | Anthropic | claude-sonnet, claude-opus | No |
| `OPENAI_API_KEY` | OpenAI | gpt-4o, o3-mini | No |
| `DEEPSEEK_API_KEY` | DeepSeek | deepseek-r1, deepseek-v3 | No |
| `MISTRAL_API_KEY` | Mistral | mistral-large, codestral | No |

**Dónde conseguirlas:**
- Google: https://aistudio.google.com/apikey
- Groq: https://console.groq.com/keys
- Cerebras: https://cloud.cerebras.ai
- OpenRouter: https://openrouter.ai/keys
- Anthropic: https://console.anthropic.com
- OpenAI: https://platform.openai.com/api-keys
- DeepSeek: https://platform.deepseek.com
- Mistral: https://console.mistral.ai

**Añadir al `.bashrc`:**
```bash
export GOOGLE_GENERATIVE_AI_API_KEY="..."
export GROQ_API_KEY="..."
export CEREBRAS_API_KEY="..."
export OPENROUTER_API_KEY="..."
# Opcionales (de pago):
export ANTHROPIC_API_KEY="..."
export OPENAI_API_KEY="..."
export DEEPSEEK_API_KEY="..."
export MISTRAL_API_KEY="..."
```

---

## Capa 4 — THDORA (proyecto principal)

```bash
cd ~/projects/thdora
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Dependencias clave de THDORA (ver su propio `requirements.txt`):

| Paquete | Para qué |
|---|---|
| `aiogram` | Bot de Telegram |
| `fastapi` + `uvicorn` | API REST (puerto 8000 — cuidado con conflicto LiteLLM) |
| `sqlalchemy` | Base de datos |
| `openai` | Cliente OpenAI compatible |

> ⚠️ **Conflicto conocido:** THDORA usa `uvicorn` en puerto 8000. LiteLLM también usa 8000.  
> Solución: arrancar THDORA en otro puerto o comprobar con `lsof -i :8000` antes de lanzar LiteLLM.

---

## Capa 5 — Herramientas opcionales

```bash
# Claude Code (alternativa a OpenCode)
npm install -g @anthropic-ai/claude-code

# Para futura integración con n8n
docker pull n8nio/n8n

# Para modelos locales (futura integración)
curl -fsSL https://ollama.ai/install.sh | sh
```

| Herramienta | Estado | Para qué |
|---|---|---|
| Claude Code | Instalado | Coding agent alternativo |
| n8n | Pendiente | Automatizaciones |
| Ollama | Pendiente | Modelos 100% locales |
| Docker | Pendiente (WSL) | Contenerización |

---

## Verificación rápida del stack

```bash
# ¿LiteLLM funciona?
curl http://localhost:8000/v1/models

# ¿OpenCode conectado?
# Barra inferior debe mostrar: Principal LiteLLM Colmena

# ¿Groq funciona?
curl -X POST https://api.groq.com/openai/v1/chat/completions \
  -H "Authorization: Bearer $GROQ_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"llama-3.3-70b-versatile","messages":[{"role":"user","content":"hola"}],"max_tokens":10}'
```
