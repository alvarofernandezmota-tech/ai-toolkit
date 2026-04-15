# 🐛 Problemas Encontrados — Sesión 15-04-2026

> Registro de obstáculos encontrados para no repetirlos.

---

## 1. Límite de tokens en DeepSeek V3-0324 (OpenRouter free)

- **Error:** `Prompt tokens limit exceeded: 13437 > 8406`
- **Causa:** El modelo gratuito de DeepSeek en OpenRouter tiene un límite muy bajo de contexto (8406 tokens de prompt)
- **Solución:** Para tareas largas con mucho contexto, usar modelos con mayor contexto:
  - `qwen/qwen3-235b-a22b:free` (131K tokens)
  - `meta-llama/llama-3.3-70b-instruct:free` (131K tokens)
  - Cerebras API (128K tokens, gratis)

---

## 2. Rate limit en Llama 3.3 70B (OpenRouter free)

- **Error:** `meta-llama/llama-3.3-70b-instruct:free is temporarily rate-limited`
- **Causa:** Demasiados usuarios usando el modelo gratuito simultáneamente
- **Solución:** Esperar o cambiar a Qwen3 / Cerebras

---

## 3. Google AI — nombre de variable de entorno incorrecto ⚠️

- **Error:** `Google Generative AI API key is missing`
- **Causa:** OpenCode espera `GOOGLE_GENERATIVE_AI_API_KEY`, NO `GOOGLE_API_KEY`
- **Solución:**
  ```bash
  export GOOGLE_GENERATIVE_AI_API_KEY="tu-key-aqui"
  echo 'export GOOGLE_GENERATIVE_AI_API_KEY="tu-key-aqui"' >> ~/.bashrc
  source ~/.bashrc
  ```

---

## 4. Groq — límite de contexto con repos grandes

- **Error:** `Request too large for model llama-3.3-70b-versatile. Limit 12000, Requested 32475`
- **Causa:** Groq tier gratuito tiene límite de 12.000 TPM. OpenCode manda el repo entero (~32K tokens)
- **Solución:** Groq solo sirve para prompts cortos. Usar Google AI (1M tokens) como principal
- **Regla:** Nunca poner Groq como primer modelo cuando haya repos con mucho contexto

---

## 5. Google AI — ID de modelo incorrecto en OpenCode ⚠️

- **Error:** `models/gemini-2.5-flash-preview-04-17 is not found for API version v1beta`
- **Causa:** El ID `google/gemini-2.5-flash-preview-04-17` no funciona en OpenCode
- **IDs que funcionan con OpenCode (verificar uno a uno):**
  ```
  google/gemini-2.0-flash          ← probar primero
  google/gemini-2.5-flash          ← probar segundo  
  google/gemini-1.5-flash          ← fallback seguro
  google/gemini-1.5-pro            ← alternativa
  ```
- **Solución:** Cambiar el config:
  ```bash
  cat > ~/.config/opencode/opencode.json << 'EOF'
  {
    "$schema": "https://opencode.ai/config.json",
    "model": "google/gemini-2.0-flash"
  }
  EOF
  ```

---

## 6. Bracketed paste mode en terminal

- **Error:** `^[[200~export: command not found` al pegar comandos
- **Causa:** La terminal interpreta el bloque pegado como texto literal con caracteres especiales
- **Solución:** Ejecutar los comandos **línea por línea**, no pegar bloques enteros

---

## 7. Scripts de agentes pendientes

- **Estado:** Los 4 scripts NO fueron creados por agotamiento de tokens/rate limits
- **Pendiente:**
  - `scripts/revisor.sh`
  - `scripts/documentador.sh`
  - `scripts/escalado.sh`
  - `scripts/run-all.sh`

---

## 8. API keys en el repositorio

- **Problema:** Riesgo de exponer API keys subidas accidentalmente al repo
- **Regla:** NUNCA subir keys al repo ni compartirlas en chats. Siempre variables de entorno.
- Añadir `.env` al `.gitignore`

---

## 9. Tareas duplicadas en cola (OpenCode)

- **Problema:** Al cambiar de modelo con tareas en cola, OpenCode las duplica
- **Solución:** Usar `/clear` antes de cambiar de modelo con tareas pendientes
