# ROADMAP — ai-toolkit

> Estado: 23 abril 2026 (~20:29 CEST)
> Para el detalle completo de cada tarea ver `docs/plan-evolucion-ai-toolkit.md`

---

## ✅ Completado

### Infraestructura base
- [x] LiteLLM proxy multi-modelo en :8000
- [x] OpenCode operativo con OpenRouter
- [x] Claude Code v2.1.118 instalado en WSL
- [x] Ollama local con qwen3:8b (6GB VRAM)
- [x] SSH :2222 operativo en red local
- [x] Colmena tmux con paneles
- [x] `scripts/start-colmena.sh` — arranque multi-modo
- [x] `scripts/health-check.sh` — fix auth ✓
- [x] `scripts/bootstrap.sh` — estado ecosistema 30s
- [x] `scripts/ai-menu.sh` — menú interactivo 12 opciones
- [x] `scripts/morning.sh` — rutina inicio sesión
- [x] `scripts/day-close.sh` — rutina cierre día
- [x] `scripts/weekly-planning.sh` — planificación semanal

### Documentación y estructura PARA
- [x] `CLAUDE.md` — índice maestro para Claude Code / OpenCode
- [x] `AGENTS.md` — fusionado en inglés (AGENTES.md retirado ✓)
- [x] `context/about-alvaro.md` — perfil maestro del ecosistema
- [x] `context/stack.md` — servicios, puertos, modelos, variables
- [x] `projects/thdora.md` — estado F9.4
- [x] `projects/ai-toolkit.md` — estado actual
- [x] `areas/ia-desarrollo.md` — KPIs y hábitos
- [x] `docs/entidades-ecosistema.md` — 4 entidades documentadas
- [x] `docs/plan-evolucion-ai-toolkit.md` — plan priorizado
- [x] `prompts/contexto-claude-ia.md` — prompt de contexto
- [x] `prompts/auditoria-claude-code.md` — prompt de auditoría

### Hitos confirmados
- [x] 17 abril: OpenCode end-to-end operativo
- [x] 22 abril: Claude Code + OpenRouter + colmena corriendo
- [x] 23 abril: Repo auditada, estructura PARA implementada, scripts rutina creados

---

## 🔴 BLOQUEANTE — sin esto no funciona nada

- [ ] **Renovar `OPENROUTER_API_KEY`** — la key actual da `User not found 401`
  - Ve a [openrouter.ai/keys](https://openrouter.ai/keys) → crea key nueva
  - Actualiza en `~/projects/ai-toolkit/.env`
  - Recarga: `source ~/projects/ai-toolkit/.env`
  - Reinicia colmena: `bash scripts/start-colmena.sh --colmena-full`
  - **Sin esto: LiteLLM proxy, OpenCode y todo el ecosistema están muertos**

---

## 🔴 Urgente — acción manual de Álvaro

- [ ] **Renovar keys caducadas** — Groq (console.groq.com), DeepSeek (platform.deepseek.com), Gemini (aistudio.google.com)
- [ ] **Instalar Tailscale** — SSH desde cualquier red (ahora solo funciona en red local)
  - `curl -fsSL https://tailscale.com/install.sh | sh` en el servidor
  - Instalar también en el Acer

---

## 🟡 Alta prioridad — después de renovar keys

- [ ] **Fix `start-colmena.sh`** — curl del loop de espera sin header auth (401 falso)
  - Cambiar `/health` por `/readyz` (endpoint público de LiteLLM)
  - Complejidad: baja | OpenCode solo: sí
- [ ] **Primera sesión real OpenCode en THDORA** — usar `prompts/auditoria-claude-code.md`
  - `bash scripts/start-colmena.sh --colmena-full`
  - Tarea: F9.4 UI unificada
- [ ] **Valorar API key Anthropic directa** — Claude Code no funciona con OpenRouter
  - Claude Code solo acepta modelos `claude-*` de Anthropic nativa (de pago)
  - Alternativa: usar OpenCode como herramienta principal (ya funciona)
- [ ] **Health-check mejorado** — distinguir "servicio caído" vs "key caducada"

---

## 🟢 Media prioridad — S18+

- [ ] **benchmark-runner real** — ejecutar con datos reales
- [ ] **docs/errores-frecuentes.md** — documentar errores E1-E10
- [ ] **Mover MDs a docs/** — reorganizar raíz (hacer después de actualizar CLAUDE.md)

---

## ❌ Descartado

- **Dashboard MD auto-actualizable** — complejidad no justificada
- **Integración THDORA ↔ ai-toolkit** (endpoint /status) — para después de S17

---

## Proyectos relacionados

| Repo | Estado | Rama activa |
|------|--------|--------------|
| ai-toolkit | ✅ Activo | main |
| thdora | ✅ Activo | feature/ui-unificada (F9.4) |

---

_Actualizado: 23 abril 2026, ~20:29 CEST — Perplexity + Álvaro_
