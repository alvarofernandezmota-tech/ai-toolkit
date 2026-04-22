# CLAUDE.md — ai-toolkit

Instrucciones para Claude Code al arrancar en este repo. Léelo todo antes de tocar nada.

---

## ⚠️ Reglas críticas

- ⛔ Las keys NUNCA van en GitHub — solo en `~/.bashrc`
- ✅ NUNCA tocar `main` directamente — siempre rama `feature/`
- ✅ Un PR por tarea
- ✅ Commits en inglés: `feat/fix/refactor/docs/chore: descripción corta`
- ✅ No modificar `CHANGELOG.md`, `ROADMAP.md`, `INICIO-AQUI.md` sin pedirlo explícitamente
- ✅ Los scripts deben ser ejecutables: `chmod +x scripts/*.sh`

---

## ⚡ Comandos rápidos

```bash
# Claude Code (directo, sin proxy)
cd ~/projects/ai-toolkit && claude

# OpenCode con rotación automática de modelos
bash scripts/opencode-rotate.sh

# Menú interactivo completo
bash scripts/ai-menu.sh

# Health check de todos los proveedores
bash scripts/health-check.sh

# LiteLLM colmena (SOLO para benchmark/ensemble, no para coding diario)
bash scripts/start-colmena.sh
```

---

## 📡 Stack activo (22 abril 2026)

```
✅ Claude Code      → claude-sonnet-4-5 via OpenRouter (ANTHROPIC_BASE_URL)
✅ OpenCode         → devstral-2:free via OpenRouter (directo, sin LiteLLM)
✅ OpenRouter       → operativo — modelo principal para todo
✅ Ollama local     → qwen2.5-coder:14b, deepseek-r1:14b (fallback sin internet)
⚠️  Groq             → renovar key si falla (console.groq.com)
⚠️  LiteLLM proxy    → solo arrancar para benchmark, no para uso diario
```

---

## 🧠 Modelos recomendados

| Tarea | Modelo | Vía |
|-------|--------|-----|
| Coding agentic (principal) | `mistralai/devstral-2:free` | OpenRouter |
| Claude Code | `anthropic/claude-sonnet-4-5` | OpenRouter |
| Razonamiento / arquitectura | `deepseek/deepseek-r1:free` | OpenRouter |
| Fallback general | `meta-llama/llama-4-maverick:free` | OpenRouter |
| Fallback rápido | `llama-3.3-70b-versatile` | Groq |
| Sin internet | `qwen2.5-coder:14b` | Ollama local |

---

## 🗂️ Estructura del repo

```
ai-toolkit/
├── CLAUDE.md                   ← este fichero (instrucciones para Claude Code)
├── INICIO-AQUI.md              ← brújula — leer al empezar sesión
├── COMO-PROCEDEMOS.md          ← flujo de trabajo y reglas
├── CHANGELOG.md                ← historial de sesiones
├── ROADMAP.md                  ← backlog y próximos pasos
├── scripts/
│   ├── ai-menu.sh              ← menú interactivo (punto de entrada)
│   ├── health-check.sh         ← semáforo de APIs
│   ├── opencode-rotate.sh      ← OpenCode con rotación de modelos
│   ├── start-colmena.sh        ← LiteLLM (solo benchmark)
│   ├── ensemble.sh             ← mismo prompt a varios modelos
│   ├── benchmark-runner.sh     ← comparativa automática
│   └── generar-diario.sh       ← diario desde git log + IA
├── agentes/                    ← sesiones documentadas con agentes
├── docs/                       ← documentación técnica estable
├── guias/                      ← guías de setup
└── investigacion/              ← research con fuentes
```

---

## ⚙️ Variables de entorno necesarias

```bash
# En ~/.bashrc
export OPENROUTER_API_KEY="sk-or-v1-..."
export GROQ_API_KEY="gsk_..."
export ANTHROPIC_API_KEY="$OPENROUTER_API_KEY"   # Claude Code gratis via OpenRouter
export ANTHROPIC_BASE_URL="https://openrouter.ai/api/v1"
export OPENAI_API_KEY="$OPENROUTER_API_KEY"      # OpenCode
export OPENAI_BASE_URL="https://openrouter.ai/api/v1"

# Aliases útiles
alias cc-toolkit='cd ~/projects/ai-toolkit && claude'
alias cc-thdora='cd ~/projects/thdora && claude'
alias oc='OPENAI_API_KEY="$OPENROUTER_API_KEY" OPENAI_BASE_URL="https://openrouter.ai/api/v1" opencode'
```

---

## 🌎 Ecosistema de repos

| Repo | Propósito | Visibilidad |
|------|-----------|-------------|
| ai-toolkit | Scripts, configs, guías de agentes IA | Público |
| thdora | Asistente Telegram (Python, FastAPI, SQLite) | Privado |

---

## 📋 Tareas pendientes

- Primera sesión real de Claude Code en THDORA (4 bugs documentados en `agentes/thdora-primera-sesion.md`)
- Ejecutar `benchmark-runner.sh` con Devstral 2 y Qwen3 Coder
- Ver backlog completo: `ROADMAP.md`

---

_Última actualización: 22 abril 2026_
