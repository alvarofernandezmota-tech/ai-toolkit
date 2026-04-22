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
# Claude Code con Ollama LOCAL (GRATIS, sin créditos)
export ANTHROPIC_BASE_URL="http://localhost:11434"
export ANTHROPIC_AUTH_TOKEN="ollama"
export ANTHROPIC_API_KEY=""
claude --model qwen2.5-coder:14b

# Claude Code con OpenRouter (requiere créditos)
claude --model anthropic/claude-sonnet-4-5

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

## 📡 Stack activo (22 abril 2026 — VERIFICADO)

```
✅ Claude Code + Ollama  → qwen2.5-coder:14b LOCAL (GRATIS, sin créditos)
✅ Claude Code + OR      → requiere créditos Anthropic (no funciona solo con OPENROUTER_API_KEY)
✅ OpenCode              → devstral-2:free via OpenRouter (directo, sin LiteLLM)
✅ OpenRouter key        → sk-or-v1-... activa y confirmada
✅ Ollama local          → qwen2.5-coder:14b, deepseek-r1:14b, qwen3:8b instalados
✅ LiteLLM proxy         → puerto 8000, sesión tmux "colmena"
⚠️  meta-llama/llama-4-maverick:free → funciona via curl/OpenRouter pero NO compatible con Claude Code
⚠️  anthropic/claude-sonnet-4-5      → requiere créditos Anthropic en OpenRouter
❌  anthropic/claude-sonnet-4.6       → NO existe como modelo válido
⚠️  SSH puerto 22                     → bloqueado/reseteado, usar puerto 2222
✅ SSH puerto 2222       → operativo
```

---

## 🧠 Modelos recomendados

| Tarea | Modelo | Vía | Coste |
|-------|--------|-----|-------|
| Coding agentic (PRINCIPAL) | `qwen2.5-coder:14b` | Ollama local | 🆓 Gratis |
| Razonamiento rápido | `qwen3:8b` | Ollama local | 🆓 Gratis |
| Razonamiento profundo | `deepseek-r1:14b` | Ollama local | 🆓 Gratis |
| Coding via OpenCode | `mistralai/devstral-2:free` | OpenRouter | 🆓 Gratis |
| Claude Code (con créditos) | `anthropic/claude-sonnet-4-5` | OpenRouter | 💰 Pago |
| General gratis | `meta-llama/llama-4-maverick:free` | OpenRouter | 🆓 Gratis |

---

## 🚀 Setup Claude Code GRATIS con Ollama

```bash
# 1. Asegúrate de que Ollama está corriendo
ollama serve &

# 2. Arranca Claude Code apuntando a Ollama
export ANTHROPIC_BASE_URL="http://localhost:11434"
export ANTHROPIC_AUTH_TOKEN="ollama"
export ANTHROPIC_API_KEY=""
claude --model qwen2.5-coder:14b

# O con el alias (añadir a ~/.bashrc):
alias cc-local='ANTHROPIC_BASE_URL="http://localhost:11434" ANTHROPIC_AUTH_TOKEN="ollama" ANTHROPIC_API_KEY="" claude --model qwen2.5-coder:14b'
```

> ⚠️ start-colmena.sh ya exporta estas variables automáticamente si `ANTHROPIC_PROVIDER=ollama`

---

## ⚙️ Variables de entorno necesarias

```bash
# En ~/.bashrc
export OPENROUTER_API_KEY="sk-or-v1-..."
export GROQ_API_KEY="gsk_..."
export OPENAI_API_KEY="$OPENROUTER_API_KEY"      # OpenCode
export OPENAI_BASE_URL="https://openrouter.ai/api/v1"

# Para Claude Code GRATIS (Ollama local)
export ANTHROPIC_BASE_URL="http://localhost:11434"
export ANTHROPIC_AUTH_TOKEN="ollama"
export ANTHROPIC_API_KEY=""

# Para Claude Code CON CRÉDITOS (OpenRouter)
# export ANTHROPIC_BASE_URL="https://openrouter.ai/api/v1"
# export ANTHROPIC_API_KEY="$OPENROUTER_API_KEY"

# Aliases útiles
alias cc-local='ANTHROPIC_BASE_URL="http://localhost:11434" ANTHROPIC_AUTH_TOKEN="ollama" ANTHROPIC_API_KEY="" claude --model qwen2.5-coder:14b'
alias cc-toolkit='cd ~/projects/ai-toolkit && cc-local'
alias cc-thdora='cd ~/projects/thdora && cc-local'
alias oc='OPENAI_API_KEY="$OPENROUTER_API_KEY" OPENAI_BASE_URL="https://openrouter.ai/api/v1" opencode'
```

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

## 🌎 Ecosistema de repos

| Repo | Propósito | Visibilidad |
|------|-----------|-------------|
| ai-toolkit | Scripts, configs, guías de agentes IA | Público |
| thdora | Asistente Telegram (Python, FastAPI, SQLite) | Privado |

---

## 📋 Tareas pendientes

- [ ] Añadir alias `cc-local` a `~/.bashrc` en el servidor
- [ ] Probar Claude Code con `qwen2.5-coder:14b` via Ollama
- [ ] Primera sesión real de Claude Code en THDORA (ver `agentes/thdora-primera-sesion.md`)
- [ ] Ejecutar `benchmark-runner.sh` con Devstral 2 y Qwen3 Coder
- [ ] Ver backlog completo: `ROADMAP.md`

---

_Última actualización: 22 abril 2026 — Claude Code v2.1.117, stack Ollama confirmado_
