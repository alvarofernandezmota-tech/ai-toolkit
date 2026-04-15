# 🐛 Problemas Encontrados — Sesión 15-04-2026

> Registro de obstáculos encontrados para no repetirlos.

---

## 1. Límite de tokens en DeepSeek V3-0324 (OpenRouter free)

- **Error:** `Prompt tokens limit exceeded: 13437 > 8406`
- **Causa:** El modelo gratuito de DeepSeek en OpenRouter tiene un límite muy bajo de contexto
- **Solución:** Usar modelos con mayor contexto: Cerebras, Qwen3, Llama 3.3 en OpenRouter

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
- **Regla:** Nunca poner Groq como primer modelo cuando haya repos con mucho contexto

---

## 5. Google AI — ID de modelo incorrecto en OpenCode

- **Error:** `models/gemini-2.5-flash-preview-04-17 is not found for API version v1beta`
- **IDs válidos para OpenCode:**
  ```
  google/gemini-2.0-flash     ← funciona pero rate limit alto
  google/gemini-1.5-flash     ← más estable en tier gratuito
  google/gemini-1.5-pro       ← alternativa
  ```

---

## 6. Google AI — Rate limit en Gemini 2.0 Flash ⚠️

- **Error:** `gemini is way too hot right now [retrying in 53s attempt #6]`
- **Causa:** Gemini 2.0 Flash gratuito tiene límites RPM muy bajos en horas pico
- **Solución:** Cambiar a `google/gemini-1.5-flash` que tiene límites más generosos:
  ```bash
  cat > ~/.config/opencode/opencode.json << 'EOF'
  {
    "$schema": "https://opencode.ai/config.json",
    "model": "google/gemini-1.5-flash"
  }
  EOF
  ```
- **Orden recomendado Google:** `gemini-1.5-flash` > `gemini-2.0-flash` > `gemini-1.5-pro`

---

## 7. Bracketed paste mode en terminal

- **Error:** `^[[200~export: command not found` al pegar comandos
- **Causa:** La terminal interpreta el bloque pegado como texto literal
- **Solución:** Ejecutar comandos **línea por línea**, no pegar bloques enteros

---

## 8. Scripts de agentes pendientes

- **Pendiente crear:**
  - `scripts/revisor.sh`
  - `scripts/documentador.sh`
  - `scripts/escalado.sh`
  - `scripts/run-all.sh`

---

## 9. API keys — nunca en el chat ni en el repo

- **Regla:** NUNCA compartir keys en chats ni subirlas al repo
- Siempre variables de entorno. Añadir `.env` al `.gitignore`

---

## 10. Tareas duplicadas en cola (OpenCode)

- **Problema:** Al cambiar de modelo con tareas en cola, OpenCode las duplica
- **Solución:** Usar `/clear` antes de cambiar de modelo
