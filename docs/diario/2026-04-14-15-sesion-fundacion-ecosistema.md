# Diario de sesión — 14 y 15 de abril de 2026

**Duración estimada:** ~7 horas (tarde-noche del 14 hasta madrugada del 15)  
**Herramientas principales:** Claude Code, OpenCode, OpenRouter, LiteLLM, Aider  
**Objetivo inicial:** Sentar la base del ecosistema de agentes y hacer funcionar Claude Code gratis vía OpenRouter

---

## Contexto de partida

El repo `ai-toolkit` existía pero sin estructura. La idea era convertirlo en el cerebro público del ecosistema de Álvaro: herramientas, guías, agentes y documentación de investigación, todo open source y a coste cero.

El objetivo de la sesión era doble:
1. Documentar la visión completa del ecosistema (qué agentes, qué modelos, qué estrategia)
2. Hacer funcionar **Claude Code conectado a OpenRouter** usando modelos gratuitos

---

## Lo que se hizo

### Fase 1 — Estructura y visión (tarde del 14)

Se creó la estructura completa del repo:
- `README.md` con la visión y el stack
- `ECOSISTEMA.md` con el roadmap de agentes
- `ESTRATEGIA.md` con la estrategia de escalado
- `ALVARO.md` con el perfil profesional ligado al ecosistema
- Carpetas `agentes/`, `guias/`, `investigacion/`, `docs/`, `prompts/`, `scripts/`, `setup/`
- README en cada carpeta para que GitHub muestre contexto

También se documentó investigación real verificada: devstral2, mem0, openclaw, benchmarks actualizados a abril 2026.

### Fase 2 — Claude Code + OpenRouter (noche del 14)

El objetivo era conectar Claude Code a OpenRouter para usar modelos gratuitos sin pagar la suscripción de Anthropic.

**Qué se intentó primero:**
- Usar `ccr` (claude-code-router) para hacer routing entre modelos → **PROBLEMA**: el router cambia el formato de los mensajes y Claude Code v2.1.108 lo detecta y falla
- Usar `settings.json` de Claude Code con `openrouterApiKey` → **PROBLEMA**: campos no reconocidos en la versión actual

**Lo que funcionó:**
```bash
OPENAI_API_KEY="$OPENROUTER_API_KEY" \
OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
claude --model openrouter/anthropic/claude-3.5-sonnet
```
Variables de entorno directas, sin proxy, sin router. Método más simple y más estable.

Se documentó en `docs/claude-code-openrouter.md` con:
- Modelos que funcionan y que NO funcionan
- Errores reales encontrados
- Troubleshooting paso a paso

### Fase 3 — LiteLLM proxy como alternativa (madrugada del 15)

Se configuró LiteLLM como proxy para tener un endpoint único (`http://localhost:4000`) que Claude Code y otros agentes pudieran usar:

```yaml
# litellm-config.yaml
model_list:
  - model_name: claude-sonnet-4-6
    litellm_params:
      model: openrouter/anthropic/claude-sonnet-4-6
      api_key: "os.environ/OPENROUTER_API_KEY"
  - model_name: deepseek-r1
    litellm_params:
      model: openrouter/deepseek/deepseek-r1:free
      api_key: "os.environ/OPENROUTER_API_KEY"
```

**Problemas con LiteLLM:**
- Puerto por defecto cambia entre versiones → se forzó a 4000
- Timeout demasiado bajo para DeepSeek R1 (modelo lento) → aumentado a 30s
- Script de arranque necesitaba `nohup` para correr en background
- Aliases de modelos fallaban con prefijo doble (`openrouter/openrouter/...`)

**Decisión final:** OpenRouter directo como método principal, LiteLLM como fallback o cuando se necesite un endpoint unificado.

### Fase 4 — OpenCode + DeepSeek R1 (madrugada del 15)

Se intentó instalar y configurar **OpenCode** como alternativa open source a Claude Code.

**Error típico encontrado:**
```json
// FICHERO MAL: ~/.config/opencode/config.json
{
  "model": "deepseek/deepseek-r1:free",
  "provider": {
    "openai": {
      "apiKey": "ENV_OPENROUTER_API_KEY",
      "baseURL": "https://openrouter.ai/api/v1"
    }
  }
}
// Error: Unrecognized keys: "apiKey", "baseURL" provider.openai
```

**Config correcta:**
```json
// FICHERO CORRECTO: ~/.config/opencode/opencode.json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "openrouter/deepseek/deepseek-r1:free"
}
```

**Arranque correcto de OpenCode con OpenRouter:**
```bash
OPENAI_API_KEY="$OPENROUTER_API_KEY" \
OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
opencode
```

**Lo que se generó con OpenCode:**
- `agentes/agente-resumen.md` — generado por OpenCode + DeepSeek R1 directamente
- `agentes/agente-revisor-de-codigo.md` — ídem
- `docs/comparativa-modelos-gratuitos.md` — investigación generada por el agente

### Fase 5 — Scripts, rotación de modelos y cierre

Se crearon scripts para automatizar el uso de múltiples modelos:
- `scripts/model-rotate.sh` — rota entre modelos gratuitos con fallback automático
- `scripts/aider-rotate.sh` — ídem específico para Aider
- Menú interactivo (`scripts/ai-menu.sh`) para elegir entre OpenCode, Aider y Claude Code

Se actualizó `CLAUDE.md` con los comandos rápidos de rotación.

---

## Problemas conocidos al cierre

| Problema | Estado | Solución / workaround |
|---|---|---|
| Claude Code falla con `ccr` | Conocido | Usar variables de entorno directas |
| LiteLLM cambia puerto entre versiones | Workaround | Forzar `--port 4000` en el script |
| DeepSeek R1 es lento (30-60s por respuesta) | Conocido | Aumentar timeout, no usar para tareas urgentes |
| OpenCode `config.json` da error | Resuelto | Usar `opencode.json` con `$schema` |
| Cerebras y Groq tienen nombres de modelo distintos en OpenRouter | Resuelto | Documentado en `docs/comparativa-modelos-gratuitos.md` |

---

## Decisiones y aprendizajes clave

1. **Claude Code + variables de entorno directas** es el método más estable para conectar a OpenRouter. No uses `ccr`, no uses `settings.json` con campos de proveedor.
2. **OpenCode necesita `opencode.json`**, no `config.json`. El nombre del archivo importa.
3. **OpenRouter directo > LiteLLM proxy** para uso diario. LiteLLM vale cuando necesitas un endpoint unificado para múltiples herramientas.
4. **DeepSeek R1 free** es bueno para razonamiento y código pero lento. Úsalo para tareas no urgentes.
5. **El ecosistema ya tiene una base sólida**: estructura, docs, scripts, agentes. El siguiente paso es usarlo, no seguir construyendo infraestructura.

---

## Próximos pasos identificados

- [ ] Probar los agentes generados (revisor de código, agente-resumen) con tareas reales de THDORA
- [ ] Crear guía de instalación completa (`guias/instalacion/opencode-openrouter-deepseek.md`)
- [ ] Añadir script de health-check que verifique que todos los agentes responden antes de empezar a trabajar
- [ ] Documentar bugs reales de THDORA identificados para pasarlos a Claude Code
- [ ] Evaluar si LiteLLM proxy merece la pena mantener o si OpenRouter directo es suficiente
