# Changelog

Todos los cambios importantes del proyecto ai-toolkit.

## [2026-04-17 02:00] — Colmena 100% operativa + hallazgos sesión nocturna

### ✅ Estado confirmado esta sesión
- **OpenCode**: operativo, panel "Ask anything..." listo
- **LiteLLM Colmena** `:8000`: `200 OK` en `/health/liveliness` ✅
- **Ollama local** `:11434`: respondiendo correctamente ✅
- **Git panel**: listo para commits desde OpenCode ✅

### 🔧 Bug encontrado y resuelto: start-colmena.sh
- **Problema**: el script hacía `source` o `eval` del `litellm-config.yaml` → el shell interpretaba los nombres de modelos como comandos bash → `principal: command not found`, `ollama-coder: command not found`, etc.
- **Fix**: lanzar LiteLLM directamente:
  ```bash
  pkill -f litellm ; sleep 2
  /home/alvaro/projects/thdora/.venv/bin/litellm --config /home/alvaro/projects/ai-toolkit/litellm-config.yaml --port 8000 &
  ```
- **TODO**: corregir `scripts/start-colmena.sh` para que use este comando directamente

### 🔧 Fix aplicado: timeout Ollama
- `request_timeout`: `15s` → `120s` en `litellm_settings`
- Causa: Ollama tarda ~30-60s en cargar modelo en RAM (primera petición)
- Con 15s: timeout → caía a Groq → 429 TPM superado → todo fallaba
- Con 120s: Ollama siempre responde, sin tocar APIs externas
- Confirmado con `curl` manual: respuesta correcta `¡Hola! ¿En qué puedo ayudarte hoy?`

### 📋 Primera tarea real asignada a OpenCode
OpenCode está ejecutando:
```
Lee ROADMAP.md y opencode.json.
Crea scripts/generar-diario.sh que:
1. Genere un brief diario en markdown con fecha de hoy
2. Lo guarde en diario/YYYY-MM-DD.md
3. Incluya secciones: ## Fecha, ## Objetivos del día, ## Tareas pendientes, ## Notas
4. Sea ejecutable (chmod +x)
```
Esta es la primera tarea autónoma real del agente en el ecosistema.

### 📚 Aprendizajes arquitectura
- Los modelos locales (Ollama) son la base — sin límites, sin coste, código privado
- El timeout era el único bloqueante — con 120s funciona perfectamente
- `start-colmena.sh` tenía un bug crítico de sintaxis — necesita reescritura
- OpenCode + LiteLLM + Ollama = stack completamente funcional y autónomo

---

## [2026-04-17 01:48] — Fix timeout Ollama + Agentes hoja de ruta

### 🔧 Fix crítico
- **`litellm-config.yaml`**: `request_timeout` subido de `15s` a `120s`

### 📚 Documentación
- **`AGENTES.md`**: nuevo fichero con hoja de ruta de agentes auto-configuradores

---

## [2026-04-17 01:30] — Ollama local PRIMERO en la Colmena

### Cambios
- Ollama `qwen2.5-coder:14b` movido al inicio del `model_list` bajo `principal`
- Añadidos `deepseek-r1:14b` y `qwen3:8b-q4_K_M` al grupo `principal`

---

## [2026-04-16] — Arquitectura Colmena inicial

### Añadido
- `litellm-config.yaml` con router multi-proveedor
- `opencode.json` apuntando a LiteLLM local
- `scripts/start-colmena.sh` para arranque
- Documentación: ECOSISTEMA.md, CEREBRO.md, INICIO-AQUI.md
