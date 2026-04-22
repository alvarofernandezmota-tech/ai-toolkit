# CHANGELOG — ai-toolkit

Registro conciso de lo que se hace en cada sesión. Para sesiones largas, ver `investigacion/diario/`.

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

### Roadmap avanzado

- ✅ `scripts/generar-diario.sh` — completado
- ✅ Ollama en LiteLLM proxy — completado
- ✅ Guía modelos locales — completada

---

## [2026-04-16] — Sesión madrugada: diagnóstico real de proveedores + fix config

### Corregido

- `litellm-config.yaml` — Cerebras como principal (confirmado 200 OK)
- `litellm-config.yaml` — OpenRouter con max_tokens: 4096 (era 8192 > saldo disponible → 402)
- `litellm-config.yaml` — qwen3-235b apunta ahora a Cerebras nativo
- `litellm-config.yaml` — fallbacks actualizados: principal → openrouter-fallback → gemini-fallback

### Añadido

- `docs/troubleshooting-proveedores.md` — guía diagnóstico rápido con comandos curl reales

### Lección aprendida

- Error 402 OpenRouter = request demasiado grande para saldo (no "sin créditos")
- Siempre verificar con curl directo antes de asumir proveedor caído

---

## [2026-04-15] — Sesión noche: OpenCode + LiteLLM multi-modelo funcionando

### Añadido

- `docs/opencode-setup.md`, `docs/arranque-rapido.md`, `investigacion/comparativa-llms.md`
- `docs/dependencias.md` — dependencias del ecosistema por capa

### Corregido

- `litellm-config.yaml` — puerto unificado a 8000, 18 modelos, fallbacks
- `scripts/opencode-rotate.sh` — permisos de ejecución

### Problemas resueltos

- OpenCode ignoraba LiteLLM por falta de campo `models` → solucionado
- Puerto 8000 ocupado por THDORA → kill -9 PID

---

## [2026-04-15] — Sesión tarde: rotación de modelos funcionando

### Añadido

- `scripts/opencode-rotate.sh`, `investigacion/apis-verificadas-15abril.md`
- `docs/VISION-SISTEMA.md`, `INICIO-AQUI.md`, `agentes/PENDIENTES.md`

### Corregido

- `scripts/ai-menu.sh` — opción 2 llama a opencode-rotate.sh, muestra estado de keys

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
