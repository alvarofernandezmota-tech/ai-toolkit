# Agente LiteLLM Colmena — Proxy Unificado de Modelos

> El proxy que unifica todos los proveedores de IA en un único endpoint local.

---

## ¿Qué es?

LiteLLM actúa como "colmena" — expone un único endpoint OpenAI-compatible en `:8000` y enruta las peticiones a Gemini, Groq, OpenRouter, SambaNova, Cerebras u Ollama local según disponibilidad y fallback configurado.

**Sin LiteLLM, OpenCode no funciona.** Es la capa de infraestructura fundamental.

---

## Stack

| Componente | Valor |
|---|---|
| Herramienta | LiteLLM Proxy |
| Instalación | `/home/alvaro/projects/thdora/.venv/bin/litellm` |
| Config | `~/projects/ai-toolkit/litellm-config.yaml` |
| Puerto | `:8000` |
| API key local | `sk-litellm-local` |
| RAM en idle | ~370 MB |
| CPU en idle | <1% |

---

## Arranque

```bash
# Arranque completo (tmux + LiteLLM + OpenCode)
bash ~/projects/ai-toolkit/scripts/start-colmena.sh

# Verificar que está vivo
curl -s http://localhost:8000/health/liveliness
# → {"status": "healthy"}

# Verificar modelos disponibles (requiere auth)
curl -s http://localhost:8000/v1/models \
  -H "Authorization: Bearer sk-litellm-local" | python3 -m json.tool | grep '"id"'
```

---

## Cadena de fallback (orden de prioridad)

```
principal:
  1. ollama/qwen3:8b-q4_K_M     ← LOCAL primero (sin coste, sin latencia red)
  2. gemini/gemini-2.0-flash    ← Gratis, rápido
  3. groq/llama-3.3-70b         ← Gratis, muy rápido
  4. openrouter/...             ← Fallback cloud
  5. cerebras/...               ← Fallback velocidad
  6. sambanova/...              ← Fallback potencia
```

---

## Proveedores configurados

| Proveedor | Keys necesarias | Coste |
|---|---|---|
| Ollama local | Ninguna | $0 siempre |
| Google Gemini | `GOOGLE_GENERATIVE_AI_API_KEY` | $0 (free tier) |
| Groq | `GROQ_API_KEY` | $0 (free tier) |
| Cerebras | `CEREBRAS_API_KEY` | $0 (free tier) |
| OpenRouter | `OPENROUTER_API_KEY` | $0 (modelos free) |
| SambaNova | `SAMBANOVA_API_KEY` | $0 (free tier) |
| DeepSeek | `DEEPSEEK_API_KEY` | Muy barato |
| Mistral | `MISTRAL_API_KEY` | Muy barato |

---

## Problemas conocidos

### Timeout en modelos locales grandes
**Causa:** qwen2.5-coder:14b y deepseek-r1:14b tardan >60s en cold start.  
**Solución:** `timeout: 120` configurado en `litellm-config.yaml`. Si falla, relanzar con `tmux kill-server && bash scripts/start-colmena.sh`.

### OpenCode hace GET /v1/models sin auth → 401
**Impacto:** Ninguno. Solo afecta al listing, no a las llamadas de chat.

---

## Estado

- ✅ Corriendo en producción desde 16/04/2026
- ✅ Timeout ajustado a 120s para modelos locales
- ✅ Ollama configurado como primera opción en fallback
- ✅ PATH de npm-global incluido en `start-colmena.sh`
