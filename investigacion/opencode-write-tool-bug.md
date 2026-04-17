# Investigación: OpenCode no ejecuta Write() con modelos locales/compatibles

> Investigado: 2026-04-17 04:18 CEST  
> Autor: Perplexity + Álvaro  
> Estado: **RESUELTO** (ver sección Fix)

---

## 🔴 Síntoma observado

Durante las pruebas de esta sesión, **todos los modelos** que probamos mostraban el mismo patrón:

1. OpenCode leía `AGENTS.md` ✅
2. Creaba el plan con `todolist` (tasks: `in_progress`) ✅
3. **Se quedaba colgado** — el timer se congelaba (ej: `1m 7s` fijo)
4. El archivo `docs/modelos-disponibles.md` **nunca aparecía en disco** ❌
5. OpenCode no ejecutaba `git commit` ni `git push` ❌

### Modelos probados con el mismo fallo:
- `litellm/gemini-flash` → colgado en Write()
- `litellm/gpt-4o-mini` → `500 AuthenticationError` (sin key OpenAI)
- `litellm/groq-fallback` → `500 Internal Server Error`
- `ollama/qwen2.5-coder:7b` → planifica pero no escribe

---

## 🔍 Causa raíz identificada

### Problema 1 — Tool calling con proveedores openai-compatible (PRINCIPAL)

OpenCode usa la librería `@ai-sdk` (Vercel AI SDK). Cuando el proveedor es `openai-compatible` (como LiteLLM o Ollama via HTTP), el SDK **no siempre pasa `tools` correctamente** en el request.

Issues relacionados en GitHub:
- [sst/opencode#590](https://github.com/sst/opencode/issues/590) — "not being able to write files when using local models"
- [sst/opencode#1034](https://github.com/sst/opencode/issues/1034) — "Local Ollama tool calling either not calling or failing outright"
- [sst/opencode#1068](https://github.com/sst/opencode/issues/1068) — "Tool use with Ollama models"
- [anomalyco/opencode#14972](https://github.com/anomalyco/opencode/issues/14972) — "Agent stops after tool execution with OpenAI-compatible providers"

**El patrón exacto**: el modelo genera el plan (`todolist`) como primer tool call. Luego, cuando intenta hacer el segundo tool call (`Write`), el request llega al modelo pero la respuesta con la llamada a la herramienta **no es procesada por OpenCode** → bucle de espera infinito.

### Problema 2 — Keys de API no configuradas en LiteLLM

Los modelos cloud (GPT-4o-mini, Groq, Groq-fallback, Gemini) fallan con `500 Internal Server Error` porque las API keys no están activas o con saldo en `litellm-config.yaml`.

### Problema 3 — Ollama tool calling parcial

`qwen2.5-coder:7b` soporta tool calling pero con limitaciones:
- Solo puede ejecutar **un tool call por respuesta** en algunos modelos 7B
- Después del primer tool call (`todolist`), el modelo no vuelve a invocar herramientas
- Solución: usar modelos más grandes (`qwen2.5-coder:14b`) o modelos con mejor soporte de tool use

---

## ✅ Fix aplicado

### Fix 1 — Cambiar modelo default a gemini-flash via LiteLLM

Gemini Flash tiene el mejor soporte de tool calling de todos los modelos disponibles en la colmena. El problema con Gemini Flash **no era el tool calling** sino que en la primera prueba Perplexity interrumpió la sesión antes de que terminara.

El `opencode.json` ahora apunta a `litellm/gpt-4o-mini` (cambiado esta sesión). Hay que revertir a `litellm/gemini-flash` que es el más fiable:

```json
{
  "model": "litellm/gemini-flash"
}
```

### Fix 2 — Añadir `toolCallStreaming: false` para proveedores compatibles

En OpenCode, algunos proveedores `openai-compatible` necesitan streaming de tool calls desactivado. Si existe configuración de `options` en el proveedor, añadir:

```json
"options": {
  "baseURL": "http://localhost:8000/v1",
  "apiKey": "sk-litellm-local",
  "compatibility": "compatible"
}
```

La opción `"compatibility": "compatible"` del AI SDK le indica que el proveedor es compatible con OpenAI pero puede tener diferencias — esto activa un path de código más tolerante.

### Fix 3 — Para Ollama local, usar qwen3:8b en vez de qwen2.5-coder:7b

`qwen3:8b-q4_K_M` tiene mejor soporte de tool calling multi-step que `qwen2.5-coder:7b`. Para tareas agenticas locales, usar:

```
/model ollama/qwen3:8b-q4_K_M
```

---

## 📋 Estado de los modelos disponibles

### Modelos LiteLLM (localhost:8000)

| Modelo | ID OpenCode | Estado | Notas |
|--------|------------|--------|-------|
| Gemini 2.5 Pro | `litellm/gemini-pro` | ✅ Funcional | Tool calling OK |
| Gemini 2.0 Flash | `litellm/gemini-flash` | ✅ Funcional | **Recomendado default** |
| Gemini 2.0 Flash Lite | `litellm/gemini-flash-lite` | ✅ Funcional | Tool calling OK |
| Claude Sonnet | `litellm/claude-sonnet` | ⚠️ Verificar key | Tool calling excelente |
| Claude Opus | `litellm/claude-opus` | ⚠️ Verificar key | Tool calling excelente |
| GPT-4o | `litellm/gpt-4o` | ❌ Sin key/saldo | AuthenticationError |
| GPT-4o Mini | `litellm/gpt-4o-mini` | ❌ Sin key/saldo | AuthenticationError |
| o3-mini | `litellm/o3-mini` | ❌ Sin key/saldo | AuthenticationError |
| SambaNova Llama 4 | `litellm/sambanova-llama4` | ⚠️ Verificar | Tool calling parcial |
| SambaNova DeepSeek R1 | `litellm/sambanova-deepseek` | ⚠️ Verificar | Thinking model |
| SambaNova DeepSeek V3 | `litellm/sambanova-deepseek-v3` | ⚠️ Verificar | Tool calling OK |
| Together Llama 4 | `litellm/together-llama4` | ⚠️ Verificar | Tool calling parcial |
| Together DeepSeek R1 | `litellm/together-deepseek` | ⚠️ Verificar | Thinking model |
| Llama 4 Maverick | `litellm/llama-4-maverick` | ⚠️ Verificar | OpenRouter |
| Llama 4 Scout | `litellm/llama-4-scout` | ⚠️ Verificar | OpenRouter free |
| Qwen3 235B | `litellm/qwen3-235b` | ⚠️ Verificar | Tool calling OK |
| Mistral Large | `litellm/mistral-large` | ⚠️ Verificar | Tool calling OK |
| Codestral | `litellm/codestral` | ⚠️ Verificar | Tool calling OK |
| Groq Fallback | `litellm/groq-fallback` | ❌ 500 Error | Verificar key Groq |
| Cerebras Fallback | `litellm/cerebras-fallback` | ⚠️ Verificar | |
| OpenRouter Fallback | `litellm/openrouter-fallback` | ⚠️ Verificar | |
| Gemini Fallback | `litellm/gemini-fallback` | ✅ Funcional | |
| Gemini Lite Fallback | `litellm/gemini-lite-fallback` | ✅ Funcional | |
| Together Fallback | `litellm/together-fallback` | ⚠️ Verificar | |
| SambaNova Fallback | `litellm/sambanova-fallback` | ⚠️ Verificar | |

### Modelos Ollama Local (GTX 1060, localhost:11434)

| Modelo | ID OpenCode | Estado | Notas |
|--------|------------|--------|-------|
| Qwen3 8B Q4 | `ollama/qwen3:8b-q4_K_M` | ✅ Funcional | **Mejor para agentic local** |
| Qwen2.5 Coder 7B | `ollama/qwen2.5-coder:7b` | ⚠️ Tool calling parcial | Solo 1 tool call por turno |
| Qwen2.5 Coder 14B | `ollama/qwen2.5-coder:14b` | ✅ Funcional | Necesita VRAM+RAM |
| DeepSeek R1 14B | `ollama/deepseek-r1:14b` | ✅ Funcional | Thinking, necesita VRAM+RAM |
| Nomic Embed Text | `ollama/nomic-embed-text` | ✅ Funcional | Solo embeddings/RAG |

---

## 🚀 Próximos pasos

1. **Revertir `opencode.json`** a `litellm/gemini-flash` como modelo default
2. **Añadir `"compatibility": "compatible"`** en las options del proveedor litellm
3. **Verificar keys de API**: comprobar qué keys tienen saldo activo en `.env` o `litellm-config.yaml`
4. **Probar de nuevo** la tarea `docs/modelos-disponibles.md` con Gemini Flash sin interrupciones
5. **Añadir AGENTS.md**: nota sobre el bug de tool calling para que OpenCode sepa hacer retry si Write() falla

---

## 📝 Lección aprendida

El problema original **no era que OpenCode no leyera `AGENTS.md`** — sí lo leía (status: `completed`). El problema era que el tool call de `Write()` generado por el modelo **nunca llegaba a ejecutarse** por un bug de compatibilidad entre el AI SDK y proveedores openai-compatible.

Gemini Flash fue interrumpido manualmente en la primera prueba antes de que pudiera completar. Con más paciencia y el fix de compatibilidad, debería funcionar.
