# Contexto para Claude IA — Ecosistema ai-toolkit

> Pega este prompt al inicio de cualquier sesión nueva con Claude IA (web).
> Última actualización: 23 abril 2026.

---

## Las 4 entidades del ecosistema

- **Álvaro** — Director. Toma decisiones, da contexto, supervisa.
- **Perplexity** — IA conversacional web con acceso MCP a GitHub. Planificación, diarios, commits tracking, auditorías de repos.
- **Claude Code** — Agente CLI en el terminal. Vive dentro del repo, ejecuta tareas autónomas, lee/escribe archivos, hace commits técnicos.
- **Claude IA (tú)** — Modelo de lenguaje web. Razonamiento, código puntual, análisis. Sin acceso directo al repo (el contexto llega vía Álvaro).

**Dinámica:** Perplexity + Álvaro planifican → Claude Code ejecuta → Álvaro supervisa.

---

## El repo: ai-toolkit

- GitHub: https://github.com/alvarofernandezmota-tech/ai-toolkit
- Ruta local: `~/projects/ai-toolkit`
- Cerebro del ecosistema: configs, scripts, documentación y prompts para coordinar agentes IA.

---

## Stack actual (abril 2026)

- Claude Code v2.1.117 via LiteLLM :8000 o OpenRouter directo
- OpenCode con Devstral 2 via OpenRouter (modelo principal)
- LiteLLM proxy puerto 8000 (18+ modelos)
- Ollama local: qwen3:8b (6GB VRAM)
- Scripts principales: `start-colmena.sh`, `ai-menu.sh`, `health-check.sh`

## Modelos gratuitos disponibles en OpenRouter (confirmados 23 abril 2026)

- `meta-llama/llama-3.3-70b-instruct:free` — el más capaz
- `qwen/qwen3-coder:free` — especializado en código
- `google/gemma-3-27b-it:free`
- `nvidia/nemotron-3-super-120b-a12b:free`
- `openai/gpt-oss-120b:free`

---

## Estructura del repo (raíz)

**Archivos MD:** CLAUDE.md, AGENTS.md, ALVARO.md, ECOSISTEMA.md,
ARQUITECTURA.md, ARQUITECTURA-SERVIDOR.md, INICIO-AQUI.md, CEREBRO.md,
COMO-PROCEDEMOS.md, ESTRATEGIA.md, REPOS-ECOSISTEMA.md, README.md, ROADMAP.md, CHANGELOG.md

**Configs:** litellm-config.yaml (12.9KB, 18+ modelos), opencode.json, tui.json, .env.example

**Scripts:** setup.sh + carpeta scripts/

**Carpetas:** agentes/ diario/ docs/ guias/ herramientas/ investigacion/ opensource/ prompts/ pruebas/ setup/

---

## Proyecto principal: THDORA

- Repo: https://github.com/alvarofernandezmota-tech/thdora
- Stack: Python 3.13 + FastAPI (puerto 8001) + SQLite + python-telegram-bot 21+
- Rama activa: `feature/ui-unificada` — tarea F9.4 en progreso
- Arquitectura: AbstractLifeManager → implementaciones concretas → FastAPI REST → Telegram bot

---

## Forma de trabajar

- Perplexity y Álvaro planifican y preparan prompts → Claude Code ejecuta
- Diarios de sesión en `ai-toolkit/diario/` (formato: YYYY-MM-DD-momento.md)
- Commits en inglés: `feat/fix/refactor/docs: descripción corta`
- NUNCA commits directos a main en thdora — siempre rama `feature/`

---

## Tu rol en esta sesión

[AQUI DESCRIBES LO QUE QUIERES QUE HAGA CLAUDE IA]
