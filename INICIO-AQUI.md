# 🚀 INICIO AQUÍ — ai-toolkit

> **Lee esto primero cada vez que abras el proyecto.**
> Última actualización: 2026-04-16

---

## Estado actual del stack

| Proveedor | Estado | Variable de entorno | Notas |
|-----------|--------|---------------------|-------|
| **Groq Llama 70B** | ✅ OPERATIVO | `GROQ_API_KEY` | Primero. Key renovada 2026-04-16 |
| **SambaNova Llama-4** | ✅ OPERATIVO | `SAMBANOVA_API_KEY` | Segundo. Gratis |
| **Together AI Llama-4** | ✅ OPERATIVO | `TOGETHER_API_KEY` | Tercero. $1 crédito |
| **OpenRouter Scout** | ✅ FALLBACK | `OPENROUTER_API_KEY` | Solo modelos gratuitos |
| **Gemini 2.0 Flash** | ⚠️ RATE LIMIT | `GOOGLE_GENERATIVE_AI_API_KEY` | Free tier, 1500 req/día |
| **Gemini 2.0 Flash-Lite** | ✅ OPERATIVO | `GOOGLE_GENERATIVE_AI_API_KEY` | Más cuota gratis que Flash |
| **Cerebras llama3.1-8b** | ⚠️ LÍMITE DIARIO | `CEREBRAS_API_KEY` | Se resetea cada 24h |
| **DeepSeek** | ❌ AUTH ERROR | `DEEPSEEK_API_KEY` | Renovar en platform.deepseek.com |

---

## Arranque rápido

### Opción A — Stack completo con LiteLLM (RECOMENDADO)

```bash
cd ~/projects/ai-toolkit
git pull
bash scripts/start-colmena.sh
```

> ⚠️ Si ya estás dentro de tmux, el script lo detecta y arranca solo el proxy.
> Luego abre OpenCode con `Ctrl+B %` en un panel nuevo.

### Opción B — OpenCode directo con Groq (sin LiteLLM)

```bash
opencode -m groq/llama-3.3-70b-versatile
```

### Opción C — OpenCode directo con Gemini

```bash
opencode -m google/gemini-2.0-flash
```

---

## Variables en ~/.bashrc

```bash
export GROQ_API_KEY="gsk_..."                  # ✅ activa
export SAMBANOVA_API_KEY="..."                 # ✅ activa
export TOGETHER_API_KEY="..."                  # ✅ activa (NO TOGETHERAI_API_KEY)
export GOOGLE_GENERATIVE_AI_API_KEY="AIza..."  # ⚠️ rate limit frecuente
export CEREBRAS_API_KEY="..."                  # completar
export OPENROUTER_API_KEY="..."                # completar
export DEEPSEEK_API_KEY="..."                  # renovar
```

Verificar:
```bash
echo "Groq:      ${GROQ_API_KEY:0:10}..."
echo "SambaNova: ${SAMBANOVA_API_KEY:0:10}..."
echo "Together:  ${TOGETHER_API_KEY:0:10}..."
echo "Gemini:    ${GOOGLE_GENERATIVE_AI_API_KEY:0:10}..."
```

---

## Cadena de fallback automática (via LiteLLM)

```
OpenCode → LiteLLM:8000
              ↓ orden de intento
           1. Groq Llama 70B        (gratis, 6000 req/día, más rápido)
           2. SambaNova Llama-4     (gratis, alta calidad)
           3. Together AI Llama-4   (gratis, $1 crédito)
           4. OpenRouter Scout      (gratis, max 4096 tokens)
           5. Gemini 2.0 Flash      (1500 req/día, rate limit frecuente)
           6. Gemini 2.0 Flash-Lite (más cuota que Flash)
           7. Cerebras llama3.1-8b  (gratis, límite diario)
```

Los saltos son **automáticos y transparentes** — OpenCode no sabe cuál usa.
`allowed_fails: 1` → 1 fallo y el modelo entra en cooldown 5 min.

---

## Cambiar modelo manualmente dentro de OpenCode

- `Ctrl+P` → escribe `model` → selecciona de la lista
- Modelos disponibles en el proxy: `principal`, `groq-fallback`, `sambanova-llama4`, `sambanova-deepseek`, `sambanova-deepseek-v3`, `together-llama4`, `together-deepseek`, `gemini-flash`, `gemini-flash-lite`, `cerebras-fallback`
- Sin LiteLLM: `opencode -m groq/llama-3.3-70b-versatile` al arrancar

---

## Diagnóstico si algo falla

```bash
# Ver logs de LiteLLM
tail -30 /tmp/litellm.log

# Probar que LiteLLM responde
curl http://localhost:8000/health/liveliness

# Ver modelos disponibles
curl http://localhost:8000/v1/models | jq '.data[].id'

# Reiniciar solo el proxy
bash scripts/start-colmena.sh --solo-proxy

# OpenCode directo sin proxy (siempre funciona si la key está bien)
opencode -m groq/llama-3.3-70b-versatile
```

---

## Protocolo de trabajo estándar

1. `git pull` en ai-toolkit
2. `bash scripts/start-colmena.sh`
3. Espera `✅ LiteLLM listo`
4. OpenCode arranca solo en el panel izquierdo
5. Al terminar: documenta en `CHANGELOG.md`
6. `git add -A && git commit -m "sesion: YYYY-MM-DD resumen" && git push`

---

## Repos del ecosistema

Ver [`REPOS-ECOSISTEMA.md`](REPOS-ECOSISTEMA.md) para auditoría completa de las 11 repos.
