# CHANGELOG — ai-toolkit

Registro conciso de lo que se hace en cada sesión. Para sesiones largas, ver `docs/diario/`.

---

## [2026-04-15] — Sesión tarde: rotación de modelos funcionando

### Añadido
- `scripts/opencode-rotate.sh` — rotación automática Groq → Cerebras → OpenRouter
- `investigacion/apis-verificadas-15abril.md` — resultados de test real con IDs correctos
- `docs/VISION-SISTEMA.md` — vision completa del sistema y principios
- `INICIO-AQUI.md` — brujula personal del proyecto
- `agentes/PENDIENTES.md` — lista viva de agentes por construir

### Corregido
- `scripts/ai-menu.sh` — opción 2 ahora llama a `opencode-rotate.sh` directamente
- `scripts/ai-menu.sh` — muestra estado de las 4 keys (OpenRouter, Groq, Cerebras, Google)
- IDs de modelos verificados: curl ≠ OpenCode (prefijo diferente)
- Groq requiere `max_tokens >= 10` en tests (con 1 da 400)

### Decisiones tomadas
- **Groq como modelo principal** de OpenCode: más rápido, verificado 200 OK
- **Cerebras como segundo fallback**: también verificado 200 OK
- **OpenRouter como último fallback**: da 404 hoy, puede estar saturado
- **IDs distintos**: OpenCode necesita prefijo (`groq/`), curl directo no

---

## [2026-04-15] — Sesión madrugada: Claude Code + OpenCode + DeepSeek

### Añadido
- `agentes/agente-revisor-de-codigo.md`
- `agentes/agente-resumen.md`
- `docs/comparativa-modelos-gratuitos.md`
- Script directo a OpenRouter sin proxy LiteLLM

### Corregido
- Config LiteLLM: puerto forzado a 4000, timeout a 30s
- IDs de modelos OpenRouter (prefijo doble causaba error 404)
- Método directo OpenRouter como principal, LiteLLM como fallback

### Decisiones tomadas
- **OpenRouter directo > LiteLLM proxy** para Claude Code
- **OpenCode + DeepSeek R1 free** como agente principal de investigación
- Config correcta de OpenCode es `~/.config/opencode/opencode.json`

---

## [2026-04-14] — Fundación del ecosistema

### Añadido
- Estructura base completa: `docs/`, `guias/`, `investigacion/`, `agentes/`, `scripts/`
- `README.md`, `ECOSISTEMA.md`, `ESTRATEGIA.md`, `ALVARO.md`, `CLAUDE.md`
- `setup.sh` instalador, `litellm-config.yaml`, scripts de rotación
- Investigación verificada: devstral2, mem0, openclaw, benchmarks reales

### Decisiones tomadas
- **Claude Code** como agente principal de coding
- **Variables de entorno directas** para conectar a OpenRouter
- **Repo `ai-toolkit`** es el cerebro público; THDORA sigue privado
