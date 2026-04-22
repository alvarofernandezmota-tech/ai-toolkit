# Modos de arranque — ai-toolkit

Guía completa de todas las formas de arrancar el sistema.

---

## Resumen rápido

| Modo | Comando | Coste | Velocidad | Cuándo usarlo |
|---|---|---|---|---|
| OpenCode + OpenRouter | `--opencode` | Gratis | ⚡⚡⚡ | **Recomendado para el día a día** |
| Claude Code + Groq | `--groq` | Gratis | ⚡⚡⚡ | Cuando quieres Claude Code con modelo potente |
| Claude Code + Ollama | `--claude-local` | Gratis | 🐢 | Sin internet, con GPU dedicada |
| Colmena completa | `--colmena-full` | Gratis | ⚡⚡ | Máxima autonomía, 2 agentes |
| Solo proxy LiteLLM | `--solo-proxy` | - | - | Debug / desarrollo |

---

## Modos detallados

### `--opencode` — Recomendado

**OpenCode + Llama 3.3 70B vía OpenRouter (GRATIS)**

```bash
bash scripts/start-colmena.sh --opencode
```

Requiere:
```bash
export OPENROUTER_API_KEY="sk-or-v1-..."
```

Dentro de OpenCode:
- El modelo ya viene seleccionado (`llama-3.3-70b-instruct:free`)
- Si quieres cambiarlo: `Ctrl+P` → busca el modelo
- Para salir sin matar la sesión: `q` y luego `tmux attach`

---

### `--groq` — Claude Code gratis y rápido

**Claude Code → LiteLLM → Groq (GRATIS)**

```bash
bash scripts/start-colmena.sh --groq
```

Requiere cuenta Groq gratuita:
1. Regístrate en https://console.groq.com
2. Crea una API key
3. Añade a `~/.bashrc`:
```bash
export GROQ_API_KEY="gsk_..."
```

Modelo: `llama-3.3-70b-versatile` (Groq) — 70B parámetros, extremadamente rápido.

---

### `--claude-local` — Sin internet

**Claude Code + Ollama local**

```bash
bash scripts/start-colmena.sh --claude-local
```

⚠️ **Limitación con 6GB VRAM**: Solo caben modelos hasta 8B.
- ✅ `qwen3:8b` — recomendado
- ❌ `qwen2.5-coder:14b` — no cabe, se cuelga

Si el modelo tarda más de 90 segundos en responder, usa `--opencode` o `--groq`.

---

### `--colmena-full` — Modo máxima autonomía

**3 paneles: Claude Code (Ollama) + OpenCode (OpenRouter) + bash**

```bash
bash scripts/start-colmena.sh --colmena-full
```

Requiere: `OPENROUTER_API_KEY` + Ollama corriendo + qwen3:8b descargado.

Layout:
```
┌────────────────────┬─────────────────────┐
│                    │  OPENCODE           │
│  CLAUDE CODE       │  llama-3.3-70b      │
│  qwen3:8b (local)  │  (OpenRouter free)  │
│                    ├─────────────────────┤
│                    │  BASH LIBRE         │
└────────────────────┴─────────────────────┘
```

---

### `--claude-thdora` — Agente nocturno en thdora

```bash
bash scripts/start-colmena.sh --claude-thdora
```

Arranca Claude Code directamente en el repo `~/projects/thdora`.
Ver `agentes/thdora-primera-sesion.md` para las instrucciones del agente.

---

## Setup inicial (una vez)

```bash
# Añadir a ~/.bashrc:
export OPENROUTER_API_KEY="sk-or-v1-..."
export GROQ_API_KEY="gsk_..."           # opcional, para --groq

# Descargar modelo local pequeño:
ollama pull qwen3:8b

# Recargar bashrc:
source ~/.bashrc
```

---

## Combinaciones de modelos gratuitos

| Herramienta | Proveedor | Modelo | Límite |
|---|---|---|---|
| OpenCode | OpenRouter | llama-3.3-70b-instruct:free | Rate limits generosos |
| OpenCode | OpenRouter | meta-llama/llama-4-maverick:free | Más nuevo |
| OpenCode | OpenRouter | mistralai/devstral-2:free | Especializado en código |
| Claude Code | Groq via LiteLLM | llama-3.3-70b-versatile | 6000 req/día gratis |
| Claude Code | Ollama local | qwen3:8b | Sin límites (6GB VRAM) |

---

## Reconectar sesiones

```bash
# Ver sesiones activas:
tmux ls

# Reconectar:
tmux attach -t colmena
tmux attach -t colmena-full
tmux attach -t thdora

# Matar todo:
tmux kill-server
```

_Última actualización: 2026-04-22_
