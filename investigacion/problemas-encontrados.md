# 🐛 Problemas Encontrados — Sesión 15-04-2026

> Registro de obstáculos encontrados para no repetirlos.
> Cada problema tiene causa + solución documentada.

---

## 1. Límite de tokens en DeepSeek V3-0324 (OpenRouter free)

- **Error:** `Prompt tokens limit exceeded: 13437 > 8406`
- **Causa:** El modelo gratuito de DeepSeek en OpenRouter tiene límite muy bajo de contexto
- **Solución:** Usar modelos con mayor contexto: Cerebras, Qwen3, Llama 3.3 en OpenRouter

---

## 2. Rate limit en Llama 3.3 70B (OpenRouter free)

- **Error:** `meta-llama/llama-3.3-70b-instruct:free is temporarily rate-limited`
- **Causa:** Demasiados usuarios en horas pico
- **Solución:** Esperar o cambiar a Qwen3 / Cerebras

---

## 3. Google AI — nombre de variable incorrecto ⚠️

- **Error:** `Google Generative AI API key is missing`
- **Causa:** OpenCode espera `GOOGLE_GENERATIVE_AI_API_KEY`, NO `GOOGLE_API_KEY`
- **Solución:**
  ```bash
  export GOOGLE_GENERATIVE_AI_API_KEY="tu-key"
  echo 'export GOOGLE_GENERATIVE_AI_API_KEY="tu-key"' >> ~/.bashrc
  source ~/.bashrc
  ```

---

## 4. Groq — límite de contexto con repos grandes ⚠️

- **Error:** `Request too large. Limit 12000, Requested 32475`
- **Causa:** Groq gratuito = 12K TPM. OpenCode manda repo entero (~32K tokens)
- **Regla:** Groq solo para prompts cortos. NUNCA como modelo principal en repos grandes.

---

## 5. Google AI — IDs de modelo incorrectos en OpenCode

- **Error:** `models/gemini-X is not found for API version v1beta`
- **Causa:** Los IDs de Gemini en OpenCode no son los mismos que en la documentación
- **IDs probados:**
  - `google/gemini-2.5-flash-preview-04-17` ❌ No existe en v1beta
  - `google/gemini-1.5-flash` ❌ No existe en v1beta
  - `google/gemini-2.0-flash` ⚠️ Existe pero rate limit en horas pico
- **Solución pendiente:** Ejecutar ListModels para ver IDs exactos:
  ```bash
  curl "https://generativelanguage.googleapis.com/v1beta/models?key=$GOOGLE_GENERATIVE_AI_API_KEY" \
    | python3 -m json.tool | grep '"name"'
  ```

---

## 6. Google AI — Rate limit Gemini 2.0 Flash en horas pico

- **Error:** `gemini is way too hot right now [retrying attempt #6/#7]`
- **Causa:** Gemini 2.0 Flash gratuito tiene RPM muy bajos. A las 7pm está saturado.
- **Solución:** Probar fuera de horas pico (mañana temprano)

---

## 7. Cerebras — Compaction en bucle con contexto grande

- **Error:** Cerebras compacta repetidamente sin poder responder
- **Causa:** llama3.1-8b tiene 8192 tokens. El repo completo lo supera.
- **Comportamiento:** compacta → intenta → sigue grande → compacta → bucle infinito
- **Solución:** Cerebras solo para prompts cortos sin contexto de repo

---

## 8. Bracketed paste mode en terminal

- **Error:** `^[[200~export: command not found`
- **Causa:** Al pegar bloques, la terminal los interpreta como texto literal
- **Solución:** Ejecutar línea por línea, no pegar bloques enteros

---

## 9. OpenRouter Qwen3 235B — requiere créditos de pago

- **Error:** `This request requires more credits`
- **Causa:** Qwen3 235B no es gratuito para contexto largo
- **Solución:** Usar modelos `:free` de OpenRouter

---

## 10. API keys — NUNCA en el chat ni en el repo

- **Regla de oro:** Solo variables de entorno. `.env` en `.gitignore`.
- Si se expone una key → revocarla inmediatamente

---

## 11. Tareas duplicadas en cola (OpenCode)

- **Problema:** Al cambiar de modelo con tareas en cola, OpenCode las duplica
- **Solución:** Usar `/clear` antes de cambiar de modelo

---

## 12. OpenCode — configuración LiteLLM con sintaxis incorrecta ⚠️

- **Error:** `Configuration is invalid: Unrecognized keys: "baseURL", "apiKey"`
- **Causa:** OpenCode NO acepta `baseURL` ni `apiKey` directamente en el JSON raíz
- **Solución:** Usar el bloque `providers` con nombre `openai` para apuntar a LiteLLM:
  ```json
  {
    "$schema": "https://opencode.ai/config.json",
    "model": "openai/principal",
    "providers": {
      "openai": {
        "api": "http://localhost:PUERTO",
        "apiKey": "sk-litellm-local"
      }
    }
  }
  ```
- **Importante:** Sustituir `PUERTO` por el que aparezca en el log de LiteLLM al arrancar

---

## 13. LiteLLM — puerto dinámico al arrancar ⚠️

- **Problema:** LiteLLM no siempre usa el puerto 4000 aunque se le indique. Asigna puerto aleatorio.
- **Ejemplo:** `Uvicorn running on http://0.0.0.0:44195` en vez de 4000
- **Causa:** Conflicto con otro proceso usando el puerto 4000, o permisos
- **Solución:** Leer el puerto real en el log de arranque y usarlo en opencode.json
  ```bash
  # Ver qué puerto usa realmente LiteLLM:
  litellm --config litellm-config.yaml --port 4000 2>&1 | grep 'Uvicorn running'
  ```
- **Fix definitivo:** Matar procesos en puerto 4000 antes de arrancar:
  ```bash
  pkill -f litellm
  litellm --config litellm-config.yaml --port 4000 &
  ```

---

## 💡 Conclusión general

**Todos los modelos gratuitos tienen límites que se activan en horas pico.**
La solución definitiva es **LiteLLM como proxy local** con rotación automática:

```
OpenCode → LiteLLM (localhost:4000) → Google AI / Groq / Cerebras / OpenRouter
```

Config correcta de OpenCode para LiteLLM:
```bash
cat > ~/.config/opencode/opencode.json << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "model": "openai/principal",
  "providers": {
    "openai": {
      "api": "http://localhost:4000",
      "apiKey": "sk-litellm-local"
    }
  }
}
EOF
```
