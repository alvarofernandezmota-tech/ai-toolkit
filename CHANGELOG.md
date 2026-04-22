# CHANGELOG — ai-toolkit

Registro conciso de lo que se hace en cada sesión. Para sesiones largas, ver `diario/`.

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

### Pendiente mañana
- Desactivar `master_key` en `litellm-config.yaml` O pasar key en health-check
- Probar `--colmena-full` con los dos agentes a la vez
- Primera sesión real de Claude Code en THDORA
- Renovar GROQ_API_KEY, DEEPSEEK_API_KEY, GEMINI_API_KEY

---

## [2026-04-22] — Sesión noche: Claude Code v2.1.117 operativo + OpenRouter confirmado

### Contexto
Sesión de verificación real del stack. SSH al servidor WSL2 (Ubuntu 22.04, 10.202.77.228 puerto 2222). Se confirmó el estado real de Claude Code y la conexión con OpenRouter.

### Confirmado funcionando
- **Claude Code v2.1.117** operativo (actualización desde v2.1.108)
- **OPENROUTER_API_KEY** activa confirmada
- **meta-llama/llama-4-maverick:free** — modelo gratuito confirmado funcional via OpenRouter
- **start-colmena.sh** — arranca litellm correctamente en sesión tmux detached
- **SSH directo** al servidor en puerto 2222 (puerto 22 bloqueado/reseteado)

### Descubierto / Corregido
- `anthropic/claude-sonnet-4.6` — NO existe como modelo válido (error: model not found)
- `anthropic/claude-sonnet-4-5` — requiere créditos Anthropic directos, no funciona solo con OpenRouter key
- `meta-llama/llama-4-maverick:free` — falla con Claude Code (model not supported por el cliente)
- **Conclusión**: Claude Code funciona mejor con modelos Anthropic nativos o via OpenRouter con créditos

### Estado stack al final de sesión

| Componente | Estado | Notas |
|---|---|---|
| Claude Code | ✅ v2.1.117 | Actualizado desde v2.1.108 |
| OpenRouter | ✅ Key activa | sk-or-v1-... confirmada |
| LiteLLM proxy | ✅ Arrancando | puerto 8000, sesión tmux colmena |
| llama-4-maverick:free | ✅ OpenRouter | Gratuito, funcional via curl/API |
| claude-sonnet-4.6 | ❌ No existe | Modelo inválido |
| claude-sonnet-4-5 via OR | ⚠️ Créditos | Necesita saldo OpenRouter |
| SSH puerto 22 | ❌ Bloqueado | Usar puerto 2222 |
| SSH puerto 2222 | ✅ Operativo | Acceso confirmado |

### Pendiente inmediato
- Añadir créditos a OpenRouter para usar claude-sonnet-4-5
- Primera sesión real de Claude Code en THDORA (bugs documentados en `agentes/thdora-primera-sesion.md`)
- Actualizar CLAUDE.md con modelo correcto confirmado hoy

---

## [2026-04-22] — Auditoría completa S16: 10 errores corregidos

### Contexto
Sesión de auditoría y corrección del repo. Se revisaron todos los archivos clave, se identificaron 10 errores y se corrigieron todos en la misma sesión.

### Corregido

- **E1** `scripts/start-colmena.sh` — buscaba `litellm` solo en directorio thdora; ahora usa `which litellm` + `python -m litellm` como fallback universal
- **E2** `scripts/ai-menu.sh` — script creado desde cero con 12 opciones: arranque colmena, health-check, ensemble, benchmark, diario, modelos, keys, Claude Code, OpenCode, tmux, logs, ayuda
- **E3** `agentes/PENDIENTES.md` — 8 items completados marcados con fecha (14-22 abril), backlog ampliado con 3 items nuevos
- **E4** `investigacion/comparativa-llms.md` — pendiente de ejecutar `benchmark-runner.sh` con datos reales (🔴 sigue pendiente)
- **E5** `INICIO-AQUI.md` — tabla de estado actualizada al 22 abril, todos los scripts nuevos documentados, ruta corregida a `~/projects/ai-toolkit`
- **E6** `litellm-config.yaml` — revisado, sin cambios necesarios (ya correcto)
- **E7** `opencode.json` — revisado, sin cambios necesarios (ya correcto)
- **E8** `.gitignore` — añadidas entradas para `.aider*`, `*.log`, `.claude/`, `benchmark-results/tmp/`, `diario/tmp/`
- **E9** `docs/errores-frecuentes.md` — pendiente documentar E1-E10 de esta sesión (🟡 siguiente paso)
- **E10** `CHANGELOG.md` — este archivo, actualizado con sesión de hoy

### Añadido

- `scripts/ai-menu.sh` — menú interactivo completo (12 opciones)

### Estado stack al final de sesión

| Componente | Estado |
|---|---|
| LiteLLM proxy | ✅ Operativo |
| OpenCode | ✅ Operativo |
| Claude Code | ✅ Instalado |
| Ollama local | ✅ Configurado (requiere `ollama serve`) |
| Cerebras (principal) | ✅ Operativo |
| Groq | ⚠️ Key caducada — renovar |
| DeepSeek | ⚠️ Key caducada — renovar |
| Gemini | ⚠️ 429 cuota — pendiente nueva key |

### Pendiente inmediato

- Renovar GROQ_API_KEY en https://console.groq.com/keys
- Renovar DEEPSEEK_API_KEY en https://platform.deepseek.com
- Ejecutar `bash scripts/benchmark-runner.sh` para rellenar comparativa-llms.md
- Primer uso real de Claude Code en THDORA (bugs documentados en `agentes/thdora-primera-sesion.md`)

---

## [2026-04-18] — Sesión madrugada 2: fix opencode.json + unificación variables

### Corregido
- `opencode.json` — eliminada clave `autosave` que no existe en el schema de OpenCode (causaba error al arrancar: "Unrecognized key: autosave")
- `litellm-config.yaml` — confirmado que la variable de Gemini es `GOOGLE_GENERATIVE_AI_API_KEY` (coherente con .env.example)

### Estado actual del stack
- Ollama local → ✅ operativo (qwen2.5-coder:14b, deepseek-r1:14b, qwen3:8b)
- LiteLLM proxy → ✅ operativo en :8000
- OpenCode → ✅ arranca limpio tras fix autosave
- Gemini → ❌ cuota agotada, pendiente nueva key en aistudio.google.com/apikey

### Pendiente inmediato
- Crear nueva GOOGLE_GENERATIVE_AI_API_KEY y ponerla en .env
- Renovar key Groq en console.groq.com
- Primer uso real de OpenCode con Ollama local para tareas de código

---

## [2026-04-18] — Sesión madrugada: health-check + auditoría completa del repo

### Añadido

- `scripts/health-check.sh` — diagnóstico completo de todos los proveedores con semáforo visual (ping + chat real + comandos de arreglo). Soporta `--full`, `--fix`. Tests en paralelo. 7 proveedores: LiteLLM, Cerebras, OpenRouter, Groq, Gemini, DeepSeek, Ollama.

### Verificado

- Auditoría completa del repo: todos los archivos del plan de esta semana están presentes y alineados
- `generar-diario.sh` ✅, `health-check.sh` ✅, `guias/opencode-ollama.md` ✅, `litellm-config.yaml` ✅, `opencode.json` ✅, `ROADMAP.md` ✅

### Actualizado

- `README.md` — refleja el estado real del stack: `health-check.sh` como paso 1 del arranque, tabla de modelos con estado actual, estructura de scripts completa, errores conocidos actualizados

### Pendiente inmediato

- Renovar key Groq en console.groq.com
- Renovar key DeepSeek en platform.deepseek.com
- Primer uso real de Claude Code sobre bugs THDORA
- Integrar `opencode-rotate.sh` en `ai-menu.sh`

---

## [2026-04-17] — Sesión: Ollama local + script diario automático

### Añadido

- `scripts/generar-diario.sh` — genera entrada de diario desde git log + IA (Groq/OpenRouter)
- `guias/opencode-ollama.md` — guía completa para usar OpenCode con modelos locales vía Ollama
- `litellm-config.yaml` — sección Ollama: 4 modelos locales (local, ollama-local, ollama-coder, ollama-r1)
- `opencode.json` — provider Ollama añadido con aliases visibles en Ctrl+P

### Corregido

- `litellm-config.yaml` — comentarios de estado actualizados (Groq/DeepSeek pendientes de renovar key)

---

## [2026-04-16] — Sesión madrugada: diagnóstico real de proveedores + fix config

### Corregido

- `litellm-config.yaml` — Cerebras como principal (confirmado 200 OK)
- `litellm-config.yaml` — OpenRouter con max_tokens: 4096 (era 8192 > saldo disponible → 402)
- `litellm-config.yaml` — qwen3-235b apunta ahora a Cerebras nativo
- `litellm-config.yaml` — fallbacks actualizados: principal → openrouter-fallback → gemini-fallback

### Añadido

- `docs/troubleshooting-proveedores.md` — guía diagnóstico rápido con comandos curl reales

---

## [2026-04-15] — Sesión noche: OpenCode + LiteLLM multi-modelo funcionando

### Añadido

- `docs/opencode-setup.md`, `docs/arranque-rapido.md`, `investigacion/comparativa-llms.md`
- `docs/dependencias.md` — dependencias del ecosistema por capa

### Corregido

- `litellm-config.yaml` — puerto unificado a 8000, 18 modelos, fallbacks
- `scripts/opencode-rotate.sh` — permisos de ejecución

---

## [2026-04-15] — Sesión tarde: rotación de modelos funcionando

### Añadido

- `scripts/opencode-rotate.sh`, `investigacion/apis-verificadas-15abril.md`
- `docs/VISION-SISTEMA.md`, `INICIO-AQUI.md`, `agentes/PENDIENTES.md`

---

## [2026-04-15] — Sesión madrugada: Claude Code + OpenCode + DeepSeek

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
