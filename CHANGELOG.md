# CHANGELOG — ai-toolkit

Registro conciso de lo que se hace en cada sesión. Una o dos líneas por entrada. Para sesiones largas con decisiones importantes, ver `docs/diario/`.

---

## [2026-04-15] — Sesión Claude Code + OpenCode + DeepSeek (madrugada)

### Añadido
- `agentes/agente-revisor-de-codigo.md` — agente para revisar código con OpenCode
- `agentes/agente-resumen.md` — agente para generar resúmenes de sesión
- `docs/comparativa-modelos-gratuitos.md` — tabla comparativa de modelos free en OpenRouter, Groq y Cerebras
- Script directo a OpenRouter sin proxy LiteLLM (en `scripts/`)
- Menú interactivo con opciones para OpenCode, Aider y Claude Code
- Cierre de sesión con problemas conocidos y roadmap actualizado

### Corregido
- Config LiteLLM: puerto forzado a 4000, timeout a 30s, mensaje de espera visible
- Script proxy-start con `nohup` y auto-accept del warning de licencia
- Nombre correcto de modelos Cerebras y Groq (quitado prefijo doble)
- Config LiteLLM con aliases correctos para `claude-sonnet-4-6`
- IDs de modelos OpenRouter (prefijo doble causaba error 404)
- Método directo OpenRouter como principal, LiteLLM como fallback

### Decisiones tomadas
- **OpenRouter directo > LiteLLM proxy** para Claude Code: más rápido, menos puntos de fallo
- **OpenCode + DeepSeek R1 free** como agente principal de investigación/coding open source
- Config correcta de OpenCode es `~/.config/opencode/opencode.json` (no `config.json`)

---

## [2026-04-14] — Fundación del ecosistema + Claude Code setup

### Añadido
- `README.md` completo con visión y stack del ecosistema
- `ECOSISTEMA.md` — roadmap completo de agentes para THDORA y vida personal
- `ESTRATEGIA.md` — escalado THDORA privado + repo pública open source + hoja de ruta migración
- `ALVARO.md` — perfil profesional completo + visión ecosistema para búsqueda de trabajo
- `CLAUDE.md` — guía en español para Claude Code con comandos rápidos y rotación de keys
- `setup.sh` — instalador completo del ecosistema en un comando
- `litellm-config.yaml` — proxy con fallbacks automáticos
- `scripts/aider-rotate.sh` — rotación automática de modelos con fallback
- `scripts/model-rotate.sh` — script de rotación multi-modelo con fallback automático
- `agentes/claude-code.md` — guía de uso de Claude Code como agente principal
- `docs/` — estructura base de carpetas del ecosistema
- `guias/` — estructura base para guías de instalación y configuración
- `investigacion/` — investigación verificada: devstral2, mem0, openclaw, benchmarks reales
- Comparativa agentes de código 2026: Aider vs Claude Code vs Roo Code
- Comparativa alternativas a THDORA + registro de experimentos
- Tabla maestra de modelos actualizada a abril 2026 por caso de uso
- Docs de estrategia de bootstrapping: el primer agente construye el resto
- Bugs reales de THDORA detectados en sesión — primera tarea para Claude Code

### Corregido
- `setup.sh` actualizado: Claude Code como agente principal + modelos gratuitos 2026
- `docs/claude-code-openrouter.md` actualizado con lecciones aprendidas:
  - Modelos que funcionan y que NO funcionan con Claude Code v2.1.108
  - Problema del `ccr` (claude-code-router) y cómo evitarlo
  - Solución definitiva con variable de entorno directa
  - Sección de troubleshooting con errores reales
- Config definitiva con `openrouter/free` y `settings.json`
- README en todas las carpetas del ecosistema

### Decisiones tomadas
- **Claude Code** como agente principal de coding (no Aider, no Roo Code)
- **Variables de entorno directas** para conectar Claude Code a OpenRouter (no `settings.json` ni `ccr`)
- **Modelo base para Claude Code**: `anthropic/claude-3.5-sonnet` vía OpenRouter free tier
- Repo `ai-toolkit` es el **cerebro público open source**; THDORA sigue siendo privado
