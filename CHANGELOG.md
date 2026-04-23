# CHANGELOG — ai-toolkit

Registro conciso de lo que se hace en cada sesión. Para sesiones largas, ver `diario/`.

---

## [2026-04-23] — Sesión tarde S17: planificación, 4 entidades, prompts, docs

### Contexto
Sesión de planificación y documentación con Perplexity + Álvaro. No se tocó código. Se auditó el estado real del repo y se dejó todo preparado para que Claude Code ejecute la auditoría técnica.

### Añadido
- `prompts/contexto-claude-ia.md` — prompt de contexto para Claude IA con todo el ecosistema
- `prompts/auditoria-claude-code.md` — prompt de auditoría en 5 pasos para Claude Code
- `docs/plan-evolucion-ai-toolkit.md` — plan priorizado con 9 tareas y estados
- `docs/entidades-ecosistema.md` — las 4 entidades, cuándo usar cada una
- `diario/2026-04-23-tarde.md` — diario de esta sesión

### Actualizado
- `AGENTS.md` — fusionado con AGENTES.md, migrado a inglés, 4 entidades documentadas, modelos free confirmados (5 en OpenRouter)
- `INICIO-AQUI.md` — estado real a 23 abril, modelos gratuitos verificados, lista de urgentes actualizada
- `CHANGELOG.md` — esta entrada
- `ROADMAP.md` — nuevas tareas del plan de evolución incorporadas

### Modelos gratuitos confirmados (OpenRouter, 23 abril)
- `qwen/qwen3-coder:free` — código
- `meta-llama/llama-3.3-70b-instruct:free` — razonamiento
- `openai/gpt-oss-120b:free`, `nvidia/nemotron-3-super-120b-a12b:free`, `google/gemma-3-27b-it:free`

### Decisiones
- AGENTS.md en inglés (Claude Code lo entiende mejor)
- CLAUDE.md como índice maestro para Claude Code
- Integración THDORA ↔ ai-toolkit → descartada para S17
- Dashboard MD auto-actualizable → descartado, invertir en health-check

### Pendiente inmediato
- Fix health-check 401 (añadir `-H "Authorization: Bearer sk-litellm-local"` en curl)
- Renovar keys: Groq (console.groq.com), DeepSeek (platform.deepseek.com), Gemini (aistudio.google.com)
- Ejecutar `prompts/auditoria-claude-code.md` con Claude Code
- Crear `bootstrap.sh` — estado del ecosistema en 30 segundos
- Continuar THDORA feature/ui-unificada — tarea F9.4

---

## [2026-04-22] — Sesión noche 2: colmena operativa, bashrc fix, LiteLLM + OpenCode

### Contexto
Sesión de puesta en marcha real completa. LiteLLM arrancó con todos los modelos. Se corrigió el conflicto de auth de Claude Code y se actualizó `~/.bashrc`.

### Hecho
- **Claude Code v2.1.117** — conflicto de auth corregido (`unset ANTHROPIC_API_KEY` en ~/.bashrc)
- **OPENROUTER_API_KEY** — añadida definitivamente a `~/.bashrc`
- **LiteLLM :8000** — arrancando correctamente con todos los modelos (gpt-4o, llama-4-maverick, qwen3-235b, groq-fallback, ollama-fallback, etc.)
- **SSH :2222** — confirmado operativo desde Windows (IP: 10.202.77.228)
- **Colmena tmux** — 3 paneles corriendo: Claude Code + LiteLLM + bash libre

### Problemas identificados
- `401 Unauthorized` en health-check → LiteLLM tiene auth pero health-check no manda key
- `--colmena-full` no arrancó esta noche (key no estaba en bashrc al lanzar) → arreglado
- `qwen2.5-coder:14b` muy lento en 6GB VRAM → script ya usa `qwen3:8b` por defecto

### Pendiente
- Desactivar `master_key` en `litellm-config.yaml` O pasar key en health-check
- Probar `--colmena-full` con los dos agentes a la vez
- Primera sesión real de Claude Code en THDORA
- Renovar GROQ_API_KEY, DEEPSEEK_API_KEY, GEMINI_API_KEY

---

## [2026-04-22] — Sesión noche: Claude Code v2.1.117 operativo + OpenRouter confirmado

### Confirmado funcionando
- **Claude Code v2.1.117** operativo (actualización desde v2.1.108)
- **OPENROUTER_API_KEY** activa confirmada
- **meta-llama/llama-4-maverick:free** — modelo gratuito confirmado funcional via OpenRouter
- **start-colmena.sh** — arranca litellm correctamente en sesión tmux detached
- **SSH directo** al servidor en puerto 2222

### Descubierto / Corregido
- `anthropic/claude-sonnet-4.6` — NO existe como modelo válido
- `anthropic/claude-sonnet-4-5` — requiere créditos Anthropic directos
- `meta-llama/llama-4-maverick:free` — falla con Claude Code (model not supported)
- **Conclusión**: Claude Code funciona mejor con modelos Anthropic nativos o via OpenRouter con créditos

### Pendiente
- Añadir créditos a OpenRouter para usar claude-sonnet-4-5
- Primera sesión real de Claude Code en THDORA
- Actualizar CLAUDE.md con modelo correcto confirmado

---

## [2026-04-22] — Auditoría completa S16: 10 errores corregidos

### Corregido
- **E1** `scripts/start-colmena.sh` — buscaba `litellm` solo en directorio thdora; ahora usa `which litellm` + `python -m litellm` como fallback universal
- **E2** `scripts/ai-menu.sh` — script creado desde cero con 12 opciones
- **E3** `agentes/PENDIENTES.md` — 8 items completados marcados con fecha, backlog ampliado
- **E5** `INICIO-AQUI.md` — tabla de estado actualizada al 22 abril
- **E8** `.gitignore` — añadidas entradas para `.aider*`, `*.log`, `.claude/`, etc.

### Añadido
- `scripts/ai-menu.sh` — menú interactivo completo (12 opciones)

### Pendiente
- Renovar GROQ_API_KEY, DEEPSEEK_API_KEY, GEMINI_API_KEY
- Ejecutar `bash scripts/benchmark-runner.sh`
- Primera sesión real de Claude Code en THDORA

---

## [2026-04-18] — Fix opencode.json + unificación variables

### Corregido
- `opencode.json` — eliminada clave `autosave` que no existe en el schema
- `litellm-config.yaml` — confirmado variable Gemini correcta

---

## [2026-04-18] — health-check + auditoría completa

### Añadido
- `scripts/health-check.sh` — diagnóstico completo de todos los proveedores

### Actualizado
- `README.md` — refleja estado real del stack

---

## [2026-04-17] — Ollama local + script diario automático

### Añadido
- `scripts/generar-diario.sh`, `guias/opencode-ollama.md`
- Sección Ollama en `litellm-config.yaml` y `opencode.json`

---

## [2026-04-16] — Diagnóstico real de proveedores + fix config

### Corregido
- `litellm-config.yaml` — Cerebras como principal, OpenRouter max_tokens fix, fallbacks

### Añadido
- `docs/troubleshooting-proveedores.md`

---

## [2026-04-15] — OpenCode + LiteLLM multi-modelo funcionando

### Añadido
- `docs/opencode-setup.md`, `docs/arranque-rapido.md`, `investigacion/comparativa-llms.md`
- `docs/dependencias.md`

### Corregido
- `litellm-config.yaml` — puerto 8000, 18 modelos, fallbacks
- `scripts/opencode-rotate.sh` — permisos

---

## [2026-04-15] — Rotación de modelos + agentes base

### Añadido
- `scripts/opencode-rotate.sh`, `investigacion/apis-verificadas-15abril.md`
- `docs/VISION-SISTEMA.md`, `INICIO-AQUI.md`, `agentes/PENDIENTES.md`

---

## [2026-04-15] — Claude Code + OpenCode + DeepSeek

### Añadido
- `agentes/agente-revisor-de-codigo.md`, `agentes/agente-resumen.md`
- `docs/comparativa-modelos-gratuitos.md`

### Decisiones
- OpenRouter directo > LiteLLM proxy para Claude Code
- OpenCode + DeepSeek R1 free como agente de investigación

---

## [2026-04-14] — Fundación del ecosistema

### Añadido
- Estructura base: docs/, guias/, investigacion/, agentes/, scripts/
- README.md, ECOSISTEMA.md, ESTRATEGIA.md, ALVARO.md, CLAUDE.md
- setup.sh, litellm-config.yaml, scripts de rotación

### Decisiones
- Claude Code como agente principal de coding
- Variables de entorno directas para OpenRouter
- ai-toolkit es el cerebro público del ecosistema
