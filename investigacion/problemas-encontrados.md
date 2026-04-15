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

- **Error:** `Google Generative AI API key is missing. Pass it using the 'apiKey' parameter or the GOOGLE_GENERATIVE_AI_API_KEY environment variable.`
- **Causa 1:** OpenCode espera `GOOGLE_GENERATIVE_AI_API_KEY`, NO `GOOGLE_API_KEY`
- **Causa 2:** Aunque tengas la key guardada en la repo, hay que exportarla con el nombre exacto
- **Solución:**
  ```bash
  export GOOGLE_GENERATIVE_AI_API_KEY="tu-key-aqui"
  echo 'export GOOGLE_GENERATIVE_AI_API_KEY="tu-key-aqui"' >> ~/.bashrc
  source ~/.bashrc
  ```
- **Nombre correcto del modelo en OpenCode:** `google/gemini-2.5-flash-preview-04-17`
- **Registrarse en:** [aistudio.google.com](https://aistudio.google.com) para obtener key gratuita

---

## 4. Groq — límite de contexto con repos grandes

- **Error:** `Request too large for model llama-3.3-70b-versatile. Limit 12000, Requested 32475`
- **Causa:** Groq tier gratuito tiene límite de 12.000 TPM. OpenCode manda el repo entero (~32K tokens)
- **Solución:** Groq solo sirve para prompts cortos. Usar Google AI (1M tokens) o DeepSeek como principal
- **Regla:** Nunca poner Groq como primer modelo cuando haya repos con mucho contexto

---

## 5. Scripts de agentes pendientes

- **Estado:** Los 4 scripts NO fueron creados por agotamiento de tokens/rate limits
- **Pendiente:**
  - `scripts/revisor.sh`
  - `scripts/documentador.sh`
  - `scripts/escalado.sh`
  - `scripts/run-all.sh`
- **Solución:** Usar Google AI (Gemini) o Cerebras con tarea más corta

---

## 6. API keys en el repositorio

- **Problema:** Riesgo de exponer API keys subidas accidentalmente al repo
- **Regla:** NUNCA subir keys al repo. Siempre usar variables de entorno:
  ```bash
  export OPENROUTER_API_KEY="tu-key"
  export CEREBRAS_API_KEY="tu-key"
  export GOOGLE_GENERATIVE_AI_API_KEY="tu-key"
  ```
- Añadir `.env` al `.gitignore`

---

## 7. Tareas duplicadas en cola (OpenCode)

- **Problema:** Al cambiar de modelo con tareas en cola, OpenCode las duplica
- **Solución:** Usar `/clear` antes de cambiar de modelo con tareas pendientes
