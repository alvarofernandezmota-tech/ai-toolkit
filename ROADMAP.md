# ROADMAP — ai-toolkit

> Estado: 23 abril 2026 (noche)
> Para el detalle completo de cada tarea ver `docs/plan-evolucion-ai-toolkit.md`

---

## ✅ Completado

### Infraestructura base
- [x] LiteLLM proxy multi-modelo en :8000 (18+ modelos)
- [x] OpenCode operativo con Devstral 2 via OpenRouter
- [x] Claude Code v2.1.117 operativo con OpenRouter
- [x] Ollama local con qwen3:8b (6GB VRAM)
- [x] SSH :2222 operativo desde Windows
- [x] Colmena tmux con 3 paneles
- [x] `scripts/start-colmena.sh` — arranque multi-modo
- [x] `scripts/health-check.sh` — diagnóstico de proveedores (fix auth ✓)
- [x] `scripts/bootstrap.sh` — estado del ecosistema en 30 segundos
- [x] `scripts/ai-menu.sh` — menú interactivo 12 opciones
- [x] `scripts/generar-diario.sh` — diario desde git log
- [x] `scripts/benchmark-runner.sh` — benchmarks velocidad/calidad

### Documentación
- [x] CLAUDE.md como índice maestro para Claude Code
- [x] AGENTS.md fusionado en inglés (AGENTES.md retirado ✓)
- [x] INICIO-AQUI.md actualizado con estado real
- [x] docs/entidades-ecosistema.md — las 4 entidades documentadas
- [x] docs/plan-evolucion-ai-toolkit.md — plan priorizado
- [x] prompts/contexto-claude-ia.md — prompt de contexto
- [x] prompts/auditoria-claude-code.md — prompt de auditoría
- [x] agentes/thdora-primera-sesion.md — modelos reales y estado F9.4

### Hitos confirmados
- [x] 17 abril: OpenCode end-to-end (leer → escribir → verificar → commit)
- [x] 22 abril: Claude Code v2.1.117 + OpenRouter operativo
- [x] 22 abril: LiteLLM + OpenCode + Claude Code colmena corriendo
- [x] 23 abril mañana: Ecosistema 4 entidades documentado
- [x] 23 abril noche: Repo auditada y limpiada — todos los scripts verificados OK

---

## 🔴 Urgente — requiere acción manual de Álvaro

- [ ] **Renovar keys caducadas** — Groq (console.groq.com), DeepSeek (platform.deepseek.com), Gemini (aistudio.google.com)
- [ ] **Ejecutar auditoría** — usar `prompts/auditoria-claude-code.md` con Claude Code en el servidor

---

## 🟡 Alta prioridad — S18

- [ ] **Primera sesión real Claude Code en THDORA**
  - `bash scripts/start-colmena.sh --claude-thdora`
  - Tarea: bugs documentados en `agentes/thdora-primera-sesion.md`
- [ ] **Auto-diario mejorado** — verificar/mejorar `scripts/generar-diario.sh` con git log real
  - Complejidad: media | Claude Code solo: sí
- [ ] **Health-check con detección de keys caducadas** — distinguir entre "servicio caído" y "key caducada"
  - Complejidad: media | Claude Code solo: sí
- [ ] **Mover MDs a docs/** — reorganizar raíz, actualizar referencias internas
  - Hacerlo DESPUÉS de actualizar CLAUDE.md como índice
  - Complejidad: media | Claude Code solo: con revisión

---

## 🟢 Media prioridad — S18+

- [ ] **benchmark-runner real** — ejecutar con datos reales, rellenar `investigacion/comparativa-llms.md`
- [ ] **docs/errores-frecuentes.md** — documentar errores E1-E10 de sesión auditoría S16

---

## ❌ Descartado

- **Dashboard MD auto-actualizable** — requiere cron/trigger, complejidad no justificada. Mejor invertir en health-check.
- **Integración THDORA ↔ ai-toolkit** (endpoint /status) — complejo, para después de S17.

---

## Proyectos relacionados

| Repo | Estado | Rama activa |
|------|--------|-------------|
| ai-toolkit | ✅ Activo | main |
| thdora | ✅ Activo | feature/ui-unificada (F9.4 en progreso) |

---

_Actualizado: 23 abril 2026 noche — Perplexity + Álvaro_
