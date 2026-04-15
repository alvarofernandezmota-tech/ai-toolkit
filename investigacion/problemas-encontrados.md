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
- **IDs probados:**
  - `google/gemini-2.5-flash-preview-04-17` ❌ No existe en v1beta
  - `google/gemini-1.5-flash` ❌ No existe en v1beta
  - `google/gemini-2.0-flash` ⚠️ Existe pero rate limit en horas pico
- **Solución pendiente:** Verificar IDs con curl:
  ```bash
  curl "https://generativelanguage.googleapis.com/v1beta/models?key=$GOOGLE_GENERATIVE_AI_API_KEY" | python3 -m json.tool | grep '"name"'
  ```

---

## 6. Google AI — Rate limit Gemini 2.0 Flash en horas pico

- **Error:** `gemini is way too hot right now [retrying attempt #6/#7]`
- **Causa:** Gemini 2.0 Flash gratuito saturado a las 7pm
- **Solución:** Probar fuera de horas pico o dejar que LiteLLM haga fallback

---

## 7. Cerebras — Compaction en bucle con contexto grande

- **Error:** Compacta repetidamente sin poder responder
- **Causa:** llama3.1-8b tiene 8192 tokens. El repo completo lo supera.
- **Solución:** Cerebras solo para prompts cortos. Usar como fallback, no como principal.

---

## 8. Bracketed paste mode en terminal

- **Error:** `^[[200~export: command not found`
- **Causa:** Al pegar bloques, la terminal los interpreta como texto literal
- **Solución:** Escribir comandos **uno por uno a mano**, no pegar bloques

---

## 9. OpenRouter Qwen3 235B — requiere créditos de pago

- **Error:** `This request requires more credits`
- **Solución:** Usar modelos `:free` de OpenRouter

---

## 10. API keys — NUNCA en el chat ni en el repo

- Solo variables de entorno. `.env` en `.gitignore`.
- Si se expone una key → revocarla inmediatamente

---

## 11. Tareas duplicadas en cola (OpenCode)

- **Problema:** Al cambiar de modelo con tareas en cola, OpenCode las duplica
- **Solución:** Usar `/clear` antes de cambiar de modelo

---

## 12. OpenCode — `baseURL` y `apiKey` no son claves válidas en raíz

- **Error:** `Unrecognized keys: "baseURL", "apiKey"`
- **Solución:** Usar bloque `provider` con `@ai-sdk/openai-compatible`:
  ```json
  {
    "model": "litellm/principal",
    "provider": {
      "litellm": {
        "npm": "@ai-sdk/openai-compatible",
        "name": "LiteLLM Colmena",
        "options": {
          "baseURL": "http://localhost:PUERTO/v1",
          "apiKey": "sk-litellm-local"
        }
      }
    }
  }
  ```

---

## 13. OpenCode — `providers` (plural) tampoco es válido

- **Error:** `Unrecognized key: "providers"`
- **Causa:** La clave correcta es `provider` (singular)
- **Solución:** Ver problema 12 para la sintaxis correcta

---

## 14. LiteLLM — corre en puerto 8000, no en 4000 ⚠️

- **Problema:** LiteLLM arranca con `--port 4000` pero escucha en `127.0.0.1:8000`
- **Causa:** Hay otro proceso usando el 4000, LiteLLM coge el siguiente libre
- **Diagnóstico:**
  ```bash
  ss -tlnp | grep python  # ver puerto real
  ```
- **Solución:** Usar el puerto real en opencode.json:
  ```bash
  # Ver puerto real antes de abrir OpenCode
  ss -tlnp | grep python
  # Resultado: LISTEN 127.0.0.1:8000 <- este es el puerto real
  ```
- **Fix definitivo — forzar puerto libre:**
  ```bash
  pkill -f litellm
  pkill -f uvicorn
  sleep 2
  litellm --config litellm-config.yaml --port 4000 &
  sleep 5
  ss -tlnp | grep python  # confirmar puerto
  ```

---

## 15. LiteLLM fallback no salta entre modelos

- **Problema:** Gemini falla con rate limit pero LiteLLM no intenta Groq/Cerebras
- **Causa:** Todos los modelos tenían el mismo nombre `principal` — LiteLLM no sabe a cuál hacer fallback
- **Solución:** Dar nombres distintos a cada modelo:
  ```yaml
  - model_name: principal        # Gemini - primario
  - model_name: groq-fallback    # Groq
  - model_name: cerebras-fallback # Cerebras
  - model_name: openrouter-fallback # OpenRouter
  ```
  Y en router_settings:
  ```yaml
  fallbacks:
    - {"principal": ["groq-fallback", "cerebras-fallback", "openrouter-fallback"]}
  ```

---

## 💡 Conclusión general

**Flujo correcto para arrancar la colmena:**
```bash
cd ~/projects/ai-toolkit
git pull
pkill -f litellm; pkill -f uvicorn; sleep 2
litellm --config litellm-config.yaml --port 4000 &
sleep 5
ss -tlnp | grep python  # apuntar el puerto real
# Actualizar opencode.json con el puerto real
# Luego:
opencode
```
