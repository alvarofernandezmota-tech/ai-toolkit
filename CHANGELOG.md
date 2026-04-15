# CHANGELOG — ai-toolkit

Registro conciso de lo que se hace en cada sesión. Una o dos líneas por entrada. Para sesiones largas con decisiones importantes, ver `docs/diario/`.

---

## [2026-04-15] — Sesión tarde: documentación completa + ai-menu.sh

### Añadido
- `INICIO-AQUI.md` — brujula personal para volver al proyecto
- `agentes/PENDIENTES.md` — lista viva de agentes por construir con comandos concretos
- `guias/opencode-deepseek.md` — guia personal de cómo usar OpenCode + DeepSeek R1
- `scripts/ai-menu.sh` — menu interactivo 1=Claude Code 2=OpenCode 3=Aider 4=Rotate
- `docs/VISION-SISTEMA.md` — vision completa del sistema, principios y capas
- `README.md` reescrito en ingles para la comunidad (BYOK, quick start, free models)
- `ECOSISTEMA.md` actualizado con estado real del 15-abril + modelo mental BYOK

### Decisiones tomadas
- **Dos READMEs:** `README.md` para la comunidad (EN) + `INICIO-AQUI.md` para uso personal (ES)
- **Ciclo documentado:** Investigas → Documentas → Implementas → Escalas → Repo refleja todo
- **OpenCode es el agente constructor:** lee la doc existente y construye lo que falta
- **La repo es viva:** refleja siempre el estado real, no el ideal

---

## [2026-04-15] — Sesión madrugada: Claude Code + OpenCode + DeepSeek

### Añadido
- `agentes/agente-revisor-de-codigo.md` — agente para revisar código con OpenCode
- `agentes/agente-resumen.md` — agente para generar resúmenes de sesión
- `docs/comparativa-modelos-gratuitos.md` — tabla comparativa de modelos free
- Script directo a OpenRouter sin proxy LiteLLM
- Cierre de sesión con problemas conocidos y roadmap actualizado

### Corregido
- Config LiteLLM: puerto forzado a 4000, timeout a 30s
- IDs de modelos OpenRouter (prefijo doble causaba error 404)
- Método directo OpenRouter como principal, LiteLLM como fallback

### Decisiones tomadas
- **OpenRouter directo > LiteLLM proxy** para Claude Code
- **OpenCode + DeepSeek R1 free** como agente principal de investigación
- Config correcta de OpenCode es `~/.config/opencode/opencode.json` (no `config.json`)

---

## [2026-04-14] — Fundación del ecosistema + Claude Code setup

### Añadido
- `README.md` completo con visión y stack del ecosistema
- `ECOSISTEMA.md` — roadmap completo de agentes
- `ESTRATEGIA.md` — escalado THDORA privado + repo pública open source
- `ALVARO.md` — perfil profesional completo + visión ecosistema
- `CLAUDE.md` — guía en español para Claude Code
- `setup.sh` — instalador completo del ecosistema
- `scripts/aider-rotate.sh` — rotación automática de modelos con fallback
- `scripts/model-rotate.sh` — script de rotación multi-modelo
- `agentes/claude-code.md` — guía de uso de Claude Code
- Estructura base: `docs/`, `guias/`, `investigacion/`, `agentes/`, `scripts/`
- Investigación verificada: devstral2, mem0, openclaw, benchmarks reales
- Bugs reales de THDORA detectados — primera tarea para Claude Code

### Decisiones tomadas
- **Claude Code** como agente principal de coding
- **Variables de entorno directas** para conectar Claude Code a OpenRouter
- **Repo `ai-toolkit`** es el cerebro público open source; THDORA sigue privado
