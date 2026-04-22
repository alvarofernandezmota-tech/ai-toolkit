# Diario — 23 abril 2026 (madrugada 01:00-01:20 CEST)

## Objetivo de la sesión
Dejar Claude Code trabajando autónomamente en ai-toolkit toda la noche con un prompt largo para preparar el ecosistema THDORA.

## Lo que intentamos

### 1. Arrancar Claude Code con modelo local (FALLÓ)
- Claude Code arrancó con `qwen2.5-coder:14b` (modelo por defecto)
- Ollama NO estaba corriendo → LiteLLM no podía conectar
- El health-check falló: 20 intentos de curl, todos fallaron (`....................`)
- Resultado: Claude Code sin modelo operativo

### 2. Cambiar modelo con /model (FALLÓ — error de sintaxis)
- Intentamos `/model [llama-4-maverick]` — error: `Model '[llama-4-maverick]' not found`
- Los corchetes NO son parte del nombre del modelo
- Sintaxis correcta: `/model groq-fallback` (sin corchetes)

### 3. Modelos disponibles en LiteLLM (confirmados en pantalla)
Los modelos que aparecían en la lista de Claude Code:
- `gpt-4o` / `gpt-4o-mini` / `o3-mini` (OpenAI — de pago)
- `sambanova-llama4` / `sambanova-deepseek` / `sambanova-deepseek-v3`
- `together-llama4` / `together-deepseek`
- `llama-4-maverick` / `llama-4-scout` (vía OpenRouter)
- `qwen3-235b` (vía Cerebras)
- `mistral-large` / `codestral`
- `groq-fallback` ← **RECOMENDADO cuando Ollama no está**
- `ollama-fallback` / `cerebras-fallback` / `openrouter-fallback`
- `gemini-fallback` / `gemini-lite-fallback`
- `together-fallback` / `sambanova-fallback`

### 4. Prompt preparado (NO ejecutado esta noche)
Se preparó un prompt completo con 5 bloques de trabajo:
- BLOQUE 1: Fix LiteLLM health-check (quitar master_key)
- BLOQUE 2: Crear agentes/thdora-primera-sesion.md
- BLOQUE 3: Actualizar ROADMAP.md con milestone THDORA
- BLOQUE 4: Crear docs/errores-frecuentes.md
- BLOQUE 5: Verificación final + diario

El prompt queda pendiente para la próxima sesión.

## Causa raíz del problema
Ollama no estaba corriendo → LiteLLM no podía servir el modelo local → Claude Code sin respuesta.

**Fix para la próxima vez:**
```bash
# Arrancar Ollama ANTES de lanzar la colmena
ollama serve &
sleep 5
bash scripts/start-colmena.sh
```

O directamente usar `groq-fallback` que no depende de Ollama:
```
/model groq-fallback
```

## Lección aprendida
- Siempre verificar que Ollama está corriendo antes de arrancar Claude Code
- El health-check que falla 20 veces = Ollama no está activo
- `/model nombre` sin corchetes para cambiar modelo en Claude Code
- Documentar aunque la sesión no produzca código — el contexto tiene valor

## Estado al cerrar
- Claude Code: sin modelo activo (pendiente `/model groq-fallback`)
- LiteLLM: corriendo en puerto 8000
- Ollama: no activo
- Commits hoy 23 abril: 0 (este diario es el primero)
- Prompt para Claude Code autónomo: listo, pendiente de ejecutar
