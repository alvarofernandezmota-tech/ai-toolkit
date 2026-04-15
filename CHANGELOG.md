# CHANGELOG — ai-toolkit

Registro conciso de lo que se hace en cada sesión. Para sesiones largas, ver `investigacion/diario/`.

---

## [2026-04-16] — Sesión madrugada: diagnóstico real de proveedores + fix config

### Corregido
- `litellm-config.yaml` — Cerebras como principal (confirmado 200 OK)
- `litellm-config.yaml` — OpenRouter con `max_tokens: 4096` (era 8192 > saldo disponible → 402)
- `litellm-config.yaml` — qwen3-235b apunta ahora a Cerebras nativo (`qwen-3-235b-a22b-instruct-2507`)
- `litellm-config.yaml` — Gemini fuera del principal (429 rate limit esta noche)
- `litellm-config.yaml` — fallbacks actualizados: principal → openrouter-fallback → gemini-fallback

### Añadido
- `docs/troubleshooting-proveedores.md` — guía diagnóstico rápido con comandos curl reales

### Diagnóstico real 2026-04-16 00:04 (comprobado con curl directo)
| Proveedor | HTTP | Causa real |
|---|---|---|
| Cerebras `gpt-oss-120b` | ✅ 200 | Operativo. Modelos: gpt-oss-120b, llama3.1-8b, qwen-3-235b-a22b-instruct-2507 |
| OpenRouter `llama-4-maverick` | ✅ 200 | Operativo. Problema era `max_tokens=8192 > 5501` disponibles → limitado a 4096 |
| Gemini `gemini-2.0-flash` | ❌ 429 | Rate limit free tier (demasiadas peticiones esta noche) |
| Groq `llama-3.3-70b` | ❌ 401 | API key caducada → renovar en console.groq.com |
| DeepSeek | ❌ AuthError | API key inválida → renovar en platform.deepseek.com |

### Lección aprendida
- El error 402 de OpenRouter NO es "sin créditos" — es "request demasiado grande para tu saldo"
- Siempre verificar con curl directo antes de asumir que un proveedor está caído
- Cerebras lista sus modelos en `GET /v1/models` con la API key
- `max_tokens: 4096` en litellm_params limita el output, no el contexto de entrada

### Pendiente
- Renovar key Groq en console.groq.com
- Renovar key DeepSeek en platform.deepseek.com
- Recargar créditos OpenRouter cuando haga falta

---

## [2026-04-15] — Sesión noche: OpenCode + LiteLLM multi-modelo funcionando

### Añadido
- `docs/opencode-setup.md` — setup completo OpenCode + LiteLLM con problemas y soluciones
- `docs/arranque-rapido.md` — comando único para levantar todo el stack
- `investigacion/comparativa-llms.md` — fichas de 14 modelos + plantilla de prueba estándar
- `investigacion/diario/2026-04-15-sesion-opencode-litellm.md` — diario completo de la sesión
- `docs/dependencias.md` — todas las dependencias del ecosistema documentadas por capa

### Corregido
- `litellm-config.yaml` — puerto unificado a 8000 (antes 4000 en config, 8000 en OpenCode)
- `litellm-config.yaml` — 18 modelos añadidos organizados por familia
- `litellm-config.yaml` — nombre modelo Gemini 2.5 Pro corregido (daba 404)
- `litellm-config.yaml` — `principal` cambiado a `groq/llama-3.3-70b-versatile` (Google free tier agotado)
- `scripts/opencode-rotate.sh` — permisos de ejecución (chmod +x)

### Problemas encontrados
- OpenCode ignoraba LiteLLM porque faltaba campo `models` en el provider → solucionado
- `opencode auth login` no encuentra litellm (no es provider nativo) → no usar auth, key en config
- Puerto 8000 ocupado por servidor uvicorn de THDORA → `kill -9 PID`
- Gemini 2.5 Pro Preview da 404 (nombre incorrecto o sin acceso) → usar gemini-2.0-flash
- Google free tier agotado (429) → cambiar principal a Groq

### Decisiones tomadas
- **`principal` = Groq Llama 3.3 70B** mientras se agota free tier de Google
- **LiteLLM en background** con `&` permite usar misma terminal para OpenCode
- **tmux** como gestor de terminales para separar LiteLLM / OpenCode / trabajo
- Arquitectura objetivo: Perplexity (estrategia) + OpenCode (ejecución) + Agentes (tareas)
- Documentar dependencias por capa es prioritario para reproducibilidad

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
