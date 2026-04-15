# Diario de Sesión — 2026-04-15

**Hora:** 19:30 – 20:00 CEST  
**Objetivo:** Conectar OpenCode al proxy LiteLLM local y preparar el experimento de comparativa de LLMs  
**Estado final:** ✅ Stack funcionando completamente

---

## Contexto del experimento

La idea es usar OpenCode como **laboratorio de comparación de LLMs** — el mismo prompt lanzado a distintos modelos enrutados a través de LiteLLM como proxy unificado. El objetivo es documentar para qué sirve mejor cada modelo, cómo responden, cuál es más rápido, más preciso, más creativo.

Visión más ambiciosa: **múltiples cabezas pensantes en paralelo** — mandar una tarea grande a varios modelos simultáneamente y fusionar las mejores respuestas. Esto se llama LLM routing con ensemble y es arquitectura de producción real.

---

## Cronología de la sesión

### 19:30 — Problema inicial

OpenCode arrancaba pero mostraba en la barra inferior:
```
Build  Qwen3 235B A22B Thinking 2507 OpenRouter
```
En vez de conectar al proxy LiteLLM local.

### 19:35 — Diagnóstico del config

El `~/.config/opencode/opencode.json` tenía la estructura correcta pero **faltaba el campo `models`** dentro del provider. Sin ese campo, OpenCode no sabe qué modelos ofrecer al provider custom y cae al modelo por defecto global (Qwen3 vía OpenRouter).

**Config que no funcionaba:**
```json
{
  "model": "litellm/principal",
  "provider": {
    "litellm": {
      "npm": "@ai-sdk/openai-compatible",
      "options": {
        "baseURL": "http://localhost:8000/v1",
        "apiKey": "sk-litellm-local"
      }
    }
  }
}
```

**Config que funciona:**
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "litellm/principal",
  "provider": {
    "litellm": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "LiteLLM Colmena",
      "options": {
        "baseURL": "http://localhost:8000/v1",
        "apiKey": "sk-litellm-local"
      },
      "models": {
        "principal": { "name": "Principal (Colmena Default)" }
      }
    }
  }
}
```

**Clave:** el campo `models` es obligatorio para que OpenCode reconozca el provider custom.

### 19:40 — Intento de auth fallido

Se probó `opencode auth login` buscando "litellm" en el menú de proveedores. Resultado: `0 matches`.

**Conclusión:** LiteLLM no es un provider nativo de OpenCode. La autenticación se gestiona directamente por el campo `apiKey` en el config JSON. No usar `opencode auth login` para providers custom.

### 19:41 — Éxito confirmado

Barra inferior de OpenCode muestra: **`Principal LiteLLM Colmena`** ✅

### 19:42 — Puerto 4000 → 8000

Se detectó que el litellm-config.yaml tenía `port: 4000` pero OpenCode apuntaba a `localhost:8000`. Se unificó todo a puerto **8000**.

### 19:43 — Ampliar modelos en el config

Se actualizó el `litellm-config.yaml` con 18 modelos organizados por familia:
- Google: gemini-pro, gemini-flash, gemini-flash-lite
- Anthropic: claude-sonnet, claude-opus
- OpenAI: gpt-4o, gpt-4o-mini, o3-mini
- DeepSeek: deepseek-r1, deepseek-v3
- Meta: llama-4-maverick, llama-4-scout
- Alibaba: qwen3-235b
- Mistral: mistral-large, codestral
- Fallbacks: groq-fallback, cerebras-fallback

### 19:44 — Problema puerto 8000 ocupado

Al relanzar LiteLLM:
```
ERROR: [Errno 98] error while attempting to bind on address ('0.0.0.0', 8000): address already in use
```

Solución:
```bash
lsof -i :8000
# Mostró uvicorn PID 6593 y python3 PID 12331
kill -9 6593 12331
```

El PID 6593 era el servidor FastAPI del proyecto `thdora` (`uvicorn src.api.main:app --reload`) que estaba usando el mismo puerto.

### 19:55 — Error 404 Gemini 2.5 Pro

Al lanzar el primer prompt en OpenCode:
```
litellm.NotFoundError: models/gemini-2.5-pro-preview-03-25 is not found for API version v1beta
```

**Causa:** El nombre `gemini-2.5-pro-preview-03-25` no está disponible con la API key actual de Google (requiere acceso especial o ya fue deprecado).

**Solución:** Cambiar `principal` a `gemini/gemini-2.0-flash` (estable, siempre disponible) y `gemini-pro` a `gemini/gemini-2.5-pro-exp-03-25`.

### 19:56 — Stack completo funcionando

```
LiteLLM: 18 modelos inicializados
INFO: Application startup complete.
INFO: Uvicorn running on http://0.0.0.0:8000
```

OpenCode barra inferior: **`Principal LiteLLM Colmena`** ✅

---

## Problemas encontrados y soluciones

| # | Problema | Causa | Solución |
|---|---|---|---|
| 1 | OpenCode usaba Qwen3 OpenRouter | Faltaba campo `models` en config | Añadir bloque `models` al provider |
| 2 | `opencode auth login` no encuentra litellm | LiteLLM no es provider nativo | No usar auth, la key va en config JSON |
| 3 | Puerto 8000 ocupado | Servidor thdora usando mismo puerto | `kill -9 PID` del proceso conflictivo |
| 4 | Gemini 2.5 Pro 404 | Nombre de modelo incorrecto/sin acceso | Cambiar a `gemini-2.0-flash` como principal |
| 5 | Config con datos de terminal pegados | Bracketed paste en heredoc | Usar `tee` con `<< 'EOF'` |

---

## Estado final del stack

```bash
# Arranque completo
pkill -f litellm 2>/dev/null; sleep 1
litellm --config ~/projects/ai-toolkit/litellm-config.yaml --port 8000 &
cd ~/projects/ai-toolkit && opencode
```

### Config OpenCode activo
`~/.config/opencode/opencode.json` → ver `docs/opencode-setup.md`

### LiteLLM config activo  
`~/projects/ai-toolkit/litellm-config.yaml`

---

## Próximos pasos

- [ ] Lanzar prompt estándar en `principal` (gemini-flash) y anotar resultado
- [ ] Cambiar a cada modelo con Ctrl+P → model y repetir
- [ ] Rellenar tabla de resultados en `investigacion/comparativa-llms.md`
- [ ] Actualizar ranking de modelos con puntuaciones reales
- [ ] Investigar arquitectura ensemble (múltiples modelos en paralelo)
- [ ] Añadir Ollama al proxy para modelos 100% locales
- [ ] Integrar script `opencode-rotate.sh` al menú principal

---

## Aprendizajes clave

1. **OpenCode necesita el campo `models` en providers custom** — sin él ignora el provider
2. **LiteLLM se autentica por config, no por `opencode auth`** — la key va en `options.apiKey`
3. **Los nombres de modelos de Google cambian** — siempre verificar en la documentación de LiteLLM
4. **LiteLLM en background con `&`** — permite usar la misma terminal para OpenCode
5. **El puerto 8000 es común** — verificar con `lsof -i :8000` antes de arrancar
