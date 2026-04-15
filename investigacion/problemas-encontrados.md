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

## 3. Gemini requiere API key propia

- **Error:** `Google Generative AI API key is missing`
- **Causa:** Gemini no va por OpenRouter — requiere key propia de Google AI Studio
- **Solución:** Registrarse en [aistudio.google.com](https://aistudio.google.com) para obtener key gratuita

---

## 4. Scripts de agentes pendientes

- **Estado:** Los 4 scripts NO fueron creados por agotamiento de tokens/rate limits
- **Pendiente para mañana:**
  - `scripts/revisor.sh`
  - `scripts/documentador.sh`
  - `scripts/escalado.sh`
  - `scripts/run-all.sh`
- **Solución:** Usar Cerebras API o Qwen3 con tarea más corta

---

## 5. API keys en el repositorio

- **Problema:** Riesgo de exponer API keys subidas accidentalmente al repo
- **Regla:** NUNCA subir keys al repo. Siempre usar variables de entorno:
  ```bash
  export OPENROUTER_API_KEY="tu-key"
  export CEREBRAS_API_KEY="tu-key"
  ```
- Añadir `.env` al `.gitignore`

---

## 6. Tareas duplicadas en cola (OpenCode)

- **Problema:** Al cambiar de modelo con tareas en cola, OpenCode las duplica
- **Solución:** Usar `/clear` antes de cambiar de modelo con tareas pendientes
