# Stack técnico — referencia rápida

> Actualizado: 23 abril 2026

## Máquinas

| Máquina | Rol | Acceso |
|---|---|---|
| Ordenador grande | Servidor principal, GPU, Ollama | Local o SSH |
| Acer portátil | Cliente ligero | SSH :2222 → 10.202.77.228 |

## Servicios activos

| Servicio | Puerto | Estado | Arranque |
|---|---|---|---|
| LiteLLM proxy | :8000 | ⚠️ Manual | `bash scripts/start-colmena.sh` |
| Ollama | :11434 | ⚠️ Manual | `ollama serve` |
| THDORA bot | — | ⚠️ Manual | `cd ~/thdora && python main.py` |

## Modelos disponibles

| Modelo | Vía | Coste | Mejor para |
|---|---|---|---|
| `qwen3:8b` | Ollama local | Gratis | Código rápido |
| `qwen3-coder:free` | OpenRouter | Gratis | Código, mejor free |
| `llama-3.3-70b-instruct:free` | OpenRouter | Gratis | Chat/razonamiento |
| `gpt-oss-120b:free` | OpenRouter | Gratis | Tareas complejas |
| `kimi-k2` | OpenRouter | Gratis | MoE razonamiento |

## Variables de entorno clave

```bash
# En ~/.bashrc del servidor
export OPENROUTER_API_KEY="..."
export LITELLM_MASTER_KEY="sk-litellm-local"
unset ANTHROPIC_API_KEY  # crítico para Claude Code

# Caducadas — renovar
# GROQ_API_KEY → console.groq.com
# DEEPSEEK_API_KEY → platform.deepseek.com
# GOOGLE_GENERATIVE_AI_API_KEY → aistudio.google.com
```

## Scripts clave

```bash
bash scripts/health-check.sh          # diagnóstico APIs
bash scripts/health-check.sh --full   # test con respuesta real
bash scripts/bootstrap.sh             # estado ecosistema en 30s
bash scripts/start-colmena.sh         # arrancar colmena tmux
bash scripts/morning.sh               # contexto del día
bash scripts/day-close.sh             # cierre diario
bash scripts/weekly-planning.sh       # plan de semana
```

## Archivos de contexto por herramienta

| Herramienta | Lee automáticamente |
|---|---|
| Claude Code | `CLAUDE.md` |
| OpenCode | `AGENTS.md` |
| Cualquier IA | `context/about-alvaro.md`, `context/stack.md` |
