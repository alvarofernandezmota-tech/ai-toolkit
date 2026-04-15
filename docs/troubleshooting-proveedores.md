# Troubleshooting de Proveedores LLM

Cuando LiteLLM falla, **primero verifica con curl directo** antes de tocar el config.
Así sabes exactamente qué proveedor está mal y por qué.

## Diagnóstico rápido (un comando)

```bash
echo "=== CEREBRAS ===" && \
curl -s -o /dev/null -w "%{http_code}" -X POST https://api.cerebras.ai/v1/chat/completions \
  -H "Authorization: Bearer $CEREBRAS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-oss-120b","messages":[{"role":"user","content":"hi"}],"max_tokens":5}' && \

echo "" && echo "=== GEMINI ===" && \
curl -s -o /dev/null -w "%{http_code}" \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$GOOGLE_GENERATIVE_AI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"contents":[{"parts":[{"text":"hi"}]}]}' && \

echo "" && echo "=== GROQ ===" && \
curl -s -o /dev/null -w "%{http_code}" -X POST https://api.groq.com/openai/v1/chat/completions \
  -H "Authorization: Bearer $GROQ_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"llama-3.3-70b-versatile","messages":[{"role":"user","content":"hi"}],"max_tokens":5}' && \

echo "" && echo "=== OPENROUTER ===" && \
curl -s -o /dev/null -w "%{http_code}" -X POST https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"meta-llama/llama-4-maverick","messages":[{"role":"user","content":"hi"}],"max_tokens":5}' && echo ""
```

## Tabla de códigos HTTP

| Código | Significado | Solución |
|--------|-------------|----------|
| `200` | ✅ Funciona | — |
| `401` | ❌ API key inválida o caducada | Renovar key en el portal del proveedor |
| `402` | ❌ Sin créditos / request demasiado grande | Reducir `max_tokens` o recargar saldo |
| `429` | ❌ Rate limit o daily limit agotado | Esperar reset (suele ser medianoche UTC) |
| `404` | ❌ Modelo no existe | Verificar nombre con `GET /v1/models` |
| `000` | ❌ Sin conexión | Revisar red o URL |

## Causa real del error 402 de OpenRouter

El 402 NO significa "sin dinero". Significa:
> **"Tu saldo actual no alcanza para un request con `max_tokens=8192`"**

Solución: añadir `max_tokens: 4096` en el litellm_params del modelo en cuestión.
Con 4096 tokens de output necesitas menos créditos por petición.

## Ver modelos disponibles en Cerebras

```bash
curl -s https://api.cerebras.ai/v1/models \
  -H "Authorization: Bearer $CEREBRAS_API_KEY" | python3 -m json.tool | grep '"id"'
```

Modelos verificados (2026-04-16):
- `gpt-oss-120b` — modelo principal, 120B parámetros
- `llama3.1-8b` — modelo rápido y ligero
- `qwen-3-235b-a22b-instruct-2507` — Qwen3 235B nativo en Cerebras
- `zai-glm-4.7` — modelo alternativo

## Cuándo se resetean los límites

| Proveedor | Reset daily limit | Zona horaria |
|-----------|-------------------|-------------|
| Cerebras | Medianoche | UTC |
| Gemini (free) | Medianoche | PT (California) |
| Groq (free) | Medianoche | UTC |

## Proveedores con keys caducadas (2026-04-16)

- **Groq** → renovar en [console.groq.com/keys](https://console.groq.com/keys)
- **DeepSeek** → renovar en [platform.deepseek.com](https://platform.deepseek.com)

Después de renovar, actualizar en `~/.bashrc`:
```bash
export GROQ_API_KEY="nueva_key"
export DEEPSEEK_API_KEY="nueva_key"
source ~/.bashrc
```

Y reactivar en `litellm-config.yaml` descomentando los bloques correspondientes.
