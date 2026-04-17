# CHANGELOG — ai-toolkit

## [2026-04-17 tarde] — Sistema Colmena funcional end-to-end

### 🌟 HITO: OpenCode + LiteLLM + Ollama local funcionando juntos
- `opencode.json` modelo default cambiado a `ollama/qwen2.5-coder:14b` (Gemini tenía cuota agotada)
- Script `start-colmena.sh` corregido: `chmod +x` necesario tras clone
- Colmena arrancando con 3 paneles tmux: OpenCode | LiteLLM logs | bash libre
- LiteLLM respondiendo `200 OK` en `/health/liveliness`
- OpenCode mostrando: **Qwen2.5 Coder 14B ⭐ PRINCIPAL (VRAM+RAM) Ollama Local (GTX 1060)**

### ✅ Completado en esta sesión
- `opencode.json` — modelo default → `ollama/qwen2.5-coder:14b`
- `AGENTS.md` — actualizado: contexto real del proyecto, flujo de trabajo, reglas MCP
- `scripts/start-colmena.sh` — fix tmux dentro de tmux, fix path litellm
- `ROADMAP.md` — hitos de hoy marcados completados
- `diario/2026-04-17-tarde.md` — sesión documentada

### 🐛 Bugs encontrados y resueltos
- `litellm: command not found` → path correcto: `/home/alvaro/projects/thdora/.venv/bin/litellm`
- `Permission denied` en `./scripts/start-colmena.sh` → `chmod +x scripts/start-colmena.sh`
- tmux `server exited unexpectedly` → WSL reiniciado con `wsl --shutdown` + `wsl`
- Gemini cuota agotada → fallback a Ollama local como default

### 💡 Decisión arquitectura: Core del agente
- OpenCode necesita instrucciones explícitas en `AGENTS.md` para comportarse como Claude Code
- El "core" (contexto, herramientas, reglas) hay que construirlo nosotros en `AGENTS.md` y `INICIO-AQUI.md`
- Próximo paso: enriquecer `AGENTS.md` con capacidades MCP, herramientas disponibles y flujo computer-mode

---

## [2026-04-17 noche] — Primera sesión de trabajo autónomo nocturno

### 🌟 HITO: OpenCode trabajando de forma autónoma
- OpenCode v1.4.7 ejecutando tareas sin intervención humana
- Gemini 2.0 Flash configurado como modelo por defecto (respuesta 1-2s)
- LiteLLM Colmena con 5+ `POST /v1/chat/completions 200 OK` en paralelo

### ✅ Completado en esta sesión
- **OpenCode v1.4.7** actualizado y funcionando ✅
- **5 fichas de agentes** creadas: `agentes/agente-opencode.md`, `agente-litellm.md`, `agente-ollama.md`, `agente-investigacion.md`, `agente-git-commits.md`
- **`COMO-PROCEDEMOS.md`** actualizado con lecciones del día
- **`opencode.json`** actualizado
- **`agentes/PENDIENTES.md`** reorganizado

---

## [2026-04-17 mañana] — Sesión servidor + OpenCode primera tarea real

### ✅ Completado
- LiteLLM Colmena arrancando en puerto 8000
- OpenCode v1.4.6 instalado en WSL
- Primera tarea real: `scripts/generar-diario.sh`
- Ollama local con 5 modelos descargados:
  - `qwen3:8b-q4_K_M` — 5.2 GB ✅
  - `qwen2.5-coder:7b` — 4.7 GB ✅
  - `nomic-embed-text` — 274 MB ✅
  - `qwen2.5-coder:14b` — 9.0 GB ✅
  - `deepseek-r1:14b` — descargado ✅

---

## [2026-04-16] — Setup servidor WSL + SSH + Ollama

### ✅ Completado
- OpenSSH Server instalado en Windows
- Port forwarding: puerto 2222 → WSL
- LiteLLM Colmena configurado con Ollama primero
