# INICIO AQUÍ — ai-toolkit

> Lee esto primero cada vez que abras una nueva sesión.

---

## Estado actual — 2026-04-23

| Componente | Estado | Notas |
|---|---|---|
| OpenCode | ✅ Operativo | vía LiteLLM proxy :8000 |
| Claude Code v2.1.117 | ✅ Operativo | vía OpenRouter (Acer SSH) |
| LiteLLM proxy :8000 | ⚠️ Arranca OK, health 401 | fix pendiente: header auth |
| OpenRouter | ✅ Key en ~/.bashrc | qwen3-coder:free + llama-3.3-70b:free |
| SSH :2222 | ✅ Operativo | IP: 10.202.77.228 |
| Ollama local | ✅ qwen3:8b | 6GB VRAM — NO usar modelos 14B |
| Kimi K2 | ✅ Añadido a opencode.json | vía LiteLLM proxy |
| Groq | ⚠️ Key caducada | Renovar en console.groq.com |
| DeepSeek | ⚠️ Key caducada | Renovar en platform.deepseek.com |
| Gemini | ⚠️ Cuota agotada | Renovar en aistudio.google.com |

---

## 🖥️ ORDENADOR GRANDE — OpenCode + LiteLLM

OpenCode es la herramienta principal en el ordenador grande.
Se conecta al proxy LiteLLM local que gestiona todos los modelos.

```
┌────────────────────┬─────────────────────┐
│                    │  LiteLLM proxy      │
│  OpenCode          │  logs/status        │
│  (izquierda)       ├─────────────────────┤
│                    │  bash libre         │
└────────────────────┴─────────────────────┘
```

### Arranque rápido

```bash
cd ~/projects/ai-toolkit
source ~/.bashrc
bash scripts/start-colmena.sh --colmena-full   # ← PRINCIPAL
```

### Modos disponibles

```bash
bash scripts/start-colmena.sh --colmena-full   # 3 paneles: OpenCode + proxy + bash
bash scripts/start-colmena.sh --opencode       # solo OpenCode (sin proxy)
bash scripts/start-colmena.sh --solo-proxy     # solo LiteLLM proxy
```

### Modelos disponibles en OpenCode

Dentro de OpenCode usa `Ctrl+X` → cambiar modelo:

| Alias | Modelo | Coste |
|---|---|---|
| `principal` | Ollama qwen3:8b → Groq → Nube | Gratis (local primero) |
| `kimi-k2` | Kimi K2 MoE 1T | OpenRouter |
| `ollama-fast` | qwen3:8b local | Gratis |
| `llama-4-scout` | Llama 4 Scout | OpenRouter free |
| `groq-fallback` | llama3.3-70b Groq | Gratis |

---

## 💻 ACER (vía SSH) — Claude Code + OpenRouter

Claude Code es la herramienta en el Acer, conectado por SSH al ordenador grande.
Se conecta directamente a OpenRouter, sin necesitar proxy local.

```
┌────────────────────┬─────────────────────┐
│                    │                     │
│  Claude Code       │  bash libre         │
│  (izquierda)       │  (git, curl, etc.)  │
│                    │                     │
└────────────────────┴─────────────────────┘
```

### Conexión SSH desde el Acer

```bash
ssh alvaro@10.202.77.228 -p 2222
cd ~/projects/ai-toolkit
source ~/.bashrc
bash scripts/start-colmena.sh --claude-acer   # ← PRINCIPAL
```

### Modos disponibles

```bash
bash scripts/start-colmena.sh --claude-acer     # 2 paneles: Claude Code + bash ← PRINCIPAL
bash scripts/start-colmena.sh --claude-thdora   # Claude Code en ~/projects/thdora
```

### Variables necesarias en ~/.bashrc

```bash
export OPENROUTER_API_KEY="sk-or-v1-..."
unset ANTHROPIC_API_KEY        # CRÍTICO: sin esto hay conflicto de auth
# NO setear ANTHROPIC_AUTH_TOKEN junto con ANTHROPIC_API_KEY
```

### Modelos gratuitos confirmados (OpenRouter)

```
qwen/qwen3-coder:free           ← mejor para código
meta-llama/llama-3.3-70b-instruct:free
openai/gpt-oss-120b:free
nvidia/nemotron-3-super-120b-a12b:free
google/gemma-3-27b-it:free
```

Dentro de Claude Code: `/model openrouter/qwen/qwen3-coder:free`

---

## Lo más urgente

1. **Arreglar health-check 401** — añadir `-H "Authorization: Bearer sk-litellm-local"` al curl en scripts/health-check.sh
2. **Renovar keys** — Groq, DeepSeek, Gemini
3. **Añadir kimi-k2 a litellm-config.yaml** — ya está en opencode.json, falta el proxy
4. **Primera sesión THDORA** — `bash scripts/start-colmena.sh --claude-thdora`

---

## Scripts disponibles

| Script | Qué hace |
|---|---|
| `scripts/start-colmena.sh` | Arranque completo (todos los modos) |
| `scripts/health-check.sh` | Diagnóstico de todos los proveedores |
| `scripts/ai-menu.sh` | Menú interactivo |
| `scripts/generar-diario.sh` | Genera entrada de diario desde git log |
| `scripts/benchmark-runner.sh` | Benchmarks velocidad/calidad |

---

## Archivos clave

| Archivo | Para qué |
|---|---|
| `CLAUDE.md` | Contexto automático para Claude Code |
| `AGENTS.md` | Reglas para OpenCode |
| `ALVARO.md` | Quién eres, proyectos, decisiones |
| `opencode.json` | Config de OpenCode (modelos, keybinds) |
| `litellm-config.yaml` | Config del proxy LiteLLM |
| `.env.example` | Variables de entorno necesarias |
| `prompts/contexto-claude-ia.md` | Prompt de contexto para Claude IA |
| `prompts/auditoria-claude-code.md` | Prompt de auditoría para Claude Code |
| `diario/` | Registro de sesiones |

---

## Repo

- GitHub: https://github.com/alvarofernandezmota-tech/ai-toolkit
- Rama principal: `main`
- Ruta local: `~/projects/ai-toolkit`

_Actualizado: 23 abril 2026, ~16:54 CEST — OpenCode y Claude Code separados, Kimi K2 añadido, modelos 14B eliminados_
