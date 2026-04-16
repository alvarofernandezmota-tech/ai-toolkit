# Changelog

Todos los cambios importantes del proyecto ai-toolkit.

## [2026-04-17] — Fix timeout Ollama + Agentes hoja de ruta

### 🔧 Fix crítico
- **`litellm-config.yaml`**: `request_timeout` subido de `15s` a `120s`
  - **Causa del bug**: Ollama tarda ~30-60s en cargar modelo en RAM la primera petición
  - **Síntoma**: LiteLLM agotaba timeout → caía a Groq → Groq petaba con 429 (contexto >12000 tokens) → todo fallaba
  - **Fix**: Con 120s Ollama siempre responde. Confirmado con curl manual: respuesta correcta en ~45s primera carga

### 📚 Documentación
- **`AGENTES.md`**: Nuevo fichero con hoja de ruta de agentes auto-configuradores
  - Stack actual confirmado con estados
  - Fases 1-3 de agentes (repo-setup, mantenimiento, onboarding)
  - Tarea concreta para OpenCode
  - Arquitectura objetivo visual

## [2026-04-17 01:30] — Ollama local PRIMERO en la Colmena

### Cambios
- Ollama `qwen2.5-coder:14b` movido al inicio del `model_list` bajo `principal`
- Añadidos `deepseek-r1:14b` y `qwen3:8b-q4_K_M` al grupo `principal`
- Comentarios de estado actualizados (Gemini cuota agotada, Groq límite TPM)

## [2026-04-16] — Arquitectura Colmena inicial

### Añadido
- `litellm-config.yaml` con router multi-proveedor
- `opencode.json` apuntando a LiteLLM local
- `scripts/start-colmena.sh` para arranque
- Documentación: ECOSISTEMA.md, CEREBRO.md, INICIO-AQUI.md
