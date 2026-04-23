# CHANGELOG — ai-toolkit

Registro conciso de lo que se hace en cada sesión. Para sesiones largas, ver `diario/`.

---

## [2026-04-23 noche] — Sesión completa S17: PARA + scripts rutina + pruebas Claude Code

### Contexto
Sesión de 4h con Perplexity + Álvaro. Auditoría completa, estructura PARA implementada, pruebas reales de la colmena en servidor, conclusión definitiva sobre Claude Code vs OpenRouter.

### Añadido
- `context/about-alvaro.md` — perfil maestro, proyectos, reglas del ecosistema
- `context/stack.md` — servicios, puertos, modelos, variables de entorno
- `projects/thdora.md` — estado F9.4, issues, próximos pasos
- `projects/ai-toolkit.md` — estado actual, roadmap activo
- `areas/ia-desarrollo.md` — KPIs, hábitos, horizonte
- `scripts/morning.sh` — rutina inicio sesión
- `scripts/day-close.sh` — rutina cierre del día
- `scripts/weekly-planning.sh` — planificación semanal
- `prompts/contexto-claude-ia.md` — prompt de contexto para Claude IA
- `prompts/auditoria-claude-code.md` — prompt auditoría 5 pasos
- `docs/plan-evolucion-ai-toolkit.md` — 9 tareas priorizadas
- `docs/entidades-ecosistema.md` — 4 entidades del ecosistema

### Actualizado
- `AGENTS.md` — fusionado con AGENTES.md, en inglés, 4 entidades, PARA documentado
- `CLAUDE.md` — apunta a context/, projects/, areas/ para contexto automático
- `INICIO-AQUI.md` — estado real 23 abril, modelos gratuitos verificados
- `ROADMAP.md` — tareas del plan de evolución incorporadas
- `diario/2026-04-23-tarde.md` — sesión completa documentada

### Eliminado
- `AGENTES.md` — duplicado de AGENTS.md

### Conclusiones importantes
- **Claude Code v2.1.118 instalado** pero incompatible con OpenRouter — solo acepta modelos `claude-*` de Anthropic directa (de pago)
- **OpenCode = herramienta principal** para trabajo con modelos gratuitos via OpenRouter
- **LiteLLM proxy**: `healthy_count: 2`, `unhealthy_count: 14` (keys caducadas)
- **SSH desde Acer**: imposible en red diferente — pendiente Tailscale

### Estado del ecosistema a 23 abril noche
- ✅ LiteLLM proxy :8000 corriendo (2 modelos sanos)
- ✅ OpenCode corriendo en tmux colmena
- ✅ Estructura PARA implementada
- ✅ Scripts de rutina diaria listos
- ❌ Claude Code: requiere API key Anthropic de pago
- ⏳ Pendiente manual: renovar keys Groq/DeepSeek/Gemini
- ⏳ Pendiente: Tailscale para acceso remoto

### Próximos pasos
1. Renovar keys: Groq (console.groq.com), DeepSeek, Gemini
2. Fix `start-colmena.sh` — curl loop con header auth
3. Instalar Tailscale
4. Primera tarea real THDORA con OpenCode
5. Valorar API key Anthropic directa para Claude Code

---

## [2026-04-23 mediodía] — Sesión noche S17: auditoría repo, scripts verificados, ROADMAP limpiado

### Verificado (ya estaba OK)
- `scripts/health-check.sh` — fix auth ya presente
- `scripts/bootstrap.sh` — ya existía y funcional
- `AGENTES.md` — ya eliminado
- `agentes/thdora-primera-sesion.md` — actualizado con modelos reales

### Actualizado
- `ROADMAP.md` — falsos pendientes eliminados, hito noche S17 añadido

---

## [2026-04-23] — Sesión tarde S17: planificación, 4 entidades, prompts, docs

### Añadido
- `prompts/contexto-claude-ia.md`, `prompts/auditoria-claude-code.md`
- `docs/plan-evolucion-ai-toolkit.md`, `docs/entidades-ecosistema.md`
- `diario/2026-04-23-tarde.md`

### Actualizado
- `AGENTS.md`, `INICIO-AQUI.md`, `CHANGELOG.md`, `ROADMAP.md`

### Modelos gratuitos confirmados (OpenRouter, 23 abril)
- `qwen/qwen3-coder:free`, `meta-llama/llama-3.3-70b-instruct:free`
- `openai/gpt-oss-120b:free`, `nvidia/nemotron-3-super-120b-a12b:free`, `google/gemma-3-27b-it:free`

---

## [2026-04-22] — Sesión noche 2: colmena operativa, bashrc fix, LiteLLM + OpenCode

### Hecho
- **Claude Code v2.1.117** — conflicto de auth corregido
- **LiteLLM :8000** — arrancando correctamente con todos los modelos
- **SSH :2222** — confirmado operativo (IP: 10.202.77.228)
- **Colmena tmux** — 3 paneles corriendo

### Problemas identificados
- `401 Unauthorized` en health-check → LiteLLM tiene auth pero curl no manda key

---

## [2026-04-22] — Claude Code v2.1.117 operativo + OpenRouter confirmado

### Confirmado
- Claude Code v2.1.117, OPENROUTER_API_KEY activa, meta-llama/llama-4-maverick:free funcional
- `start-colmena.sh` arranca litellm correctamente

### Descubierto
- `anthropic/claude-sonnet-4.6` — no existe como modelo válido
- Claude Code funciona mejor con modelos Anthropic nativos

---

## [2026-04-22] — Auditoría completa S16: 10 errores corregidos

- `scripts/start-colmena.sh`, `scripts/ai-menu.sh` (creado), `agentes/PENDIENTES.md`
- `INICIO-AQUI.md`, `.gitignore` actualizados

---

## [2026-04-18] — Fix opencode.json + unificación variables

- `opencode.json` — eliminada clave `autosave` inválida
- `litellm-config.yaml` — variable Gemini confirmada

---

## [2026-04-18] — health-check + auditoría completa

- `scripts/health-check.sh` — diagnóstico completo de proveedores
- `README.md` — estado real del stack

---

## [2026-04-17] — Ollama local + script diario automático

- `scripts/generar-diario.sh`, `guias/opencode-ollama.md`
- Sección Ollama en `litellm-config.yaml` y `opencode.json`

---

## [2026-04-16] — Diagnóstico real de proveedores + fix config

- `litellm-config.yaml` — Cerebras como principal, OpenRouter max_tokens fix
- `docs/troubleshooting-proveedores.md`

---

## [2026-04-15] — OpenCode + LiteLLM multi-modelo funcionando

- `docs/opencode-setup.md`, `docs/arranque-rapido.md`, `investigacion/comparativa-llms.md`
- `litellm-config.yaml` — puerto 8000, 18 modelos, fallbacks

---

## [2026-04-15] — Rotación de modelos + agentes base

- `scripts/opencode-rotate.sh`, `investigacion/apis-verificadas-15abril.md`
- `docs/VISION-SISTEMA.md`, `INICIO-AQUI.md`, `agentes/PENDIENTES.md`

---

## [2026-04-15] — Claude Code + OpenCode + DeepSeek

- `agentes/agente-revisor-de-codigo.md`, `agentes/agente-resumen.md`
- `docs/comparativa-modelos-gratuitos.md`
- OpenRouter directo > LiteLLM proxy para Claude Code

---

## [2026-04-14] — Fundación del ecosistema

- Estructura base: docs/, guias/, investigacion/, agentes/, scripts/
- README.md, ECOSISTEMA.md, ESTRATEGIA.md, ALVARO.md, CLAUDE.md
- Claude Code como agente principal de coding
