# 🚀 INICIO AQUÍ — ai-toolkit

> **Lee esto primero cada vez que abras el proyecto.**
> Última actualización: 2026-04-16

---

## Estado actual del stack

| Proveedor | Estado | Variable de entorno | Notas |
|-----------|--------|---------------------|-------|
| **Gemini 2.0 Flash** | ✅ OPERATIVO | `GOOGLE_GENERATIVE_AI_API_KEY` | Principal. Key renovada 2026-04-16 |
| **Groq Llama 70B** | ✅ OPERATIVO | `GROQ_API_KEY` | Segundo. Key renovada 2026-04-16 |
| **Cerebras** | ⚠️ LÍMITE DIARIO | `CEREBRAS_API_KEY` | Se resetea cada 24h |
| **OpenRouter** | ⚠️ FREE TIER | `OPENROUTER_API_KEY` | Solo modelos gratuitos, max 4096 tokens |
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

### Opción B — OpenCode directo con Gemini (sin LiteLLM)

```bash
opencode -m google/gemini-2.0-flash
```

### Opción C — OpenCode directo con Groq

```bash
opencode -m groq/llama-3.3-70b-versatile
```

---

## Variables en ~/.bashrc

```bash
# Renovar keys en: aistudio.google.com y console.groq.com
export GOOGLE_GENERATIVE_AI_API_KEY="AIza..."  # ✅ activa
export GROQ_API_KEY="gsk_..."                  # ✅ activa
export CEREBRAS_API_KEY="..."                  # completar
export OPENROUTER_API_KEY="..."                # completar
export DEEPSEEK_API_KEY="..."                  # renovar
```

Verificar:
```bash
echo "Gemini: ${GOOGLE_GENERATIVE_AI_API_KEY:0:10}..."
echo "Groq:   ${GROQ_API_KEY:0:10}..."
```

---

## Cadena de fallback automática (via LiteLLM)

```
OpenCode → LiteLLM:8000
              ↓ orden de intento
           1. Gemini 2.0 Flash   (gratis, 1M contexto)
           2. Groq Llama 70B     (gratis, muy rápido)
           3. OpenRouter Scout   (gratis, max 4096 tokens)
           4. Cerebras llama3.1  (gratis, límite diario)
```

Los saltos son **automáticos y transparentes** — OpenCode no sabe cuál usa.

---

## Cambiar modelo manualmente dentro de OpenCode

- `Ctrl+P` → escribe `model` → selecciona de la lista
- Sin LiteLLM: `opencode -m google/gemini-2.0-flash` al arrancar

---

## Diagnóstico si algo falla

```bash
# Ver logs de LiteLLM
tail -30 /tmp/litellm.log

# Probar que LiteLLM responde
curl http://localhost:8000/health/liveliness

# Reiniciar solo el proxy
bash scripts/start-colmena.sh --solo-proxy

# OpenCode directo sin proxy (siempre funciona si la key está bien)
opencode -m google/gemini-2.0-flash
```

---

## Protocolo de trabajo estándar

1. `git pull` en ai-toolkit
2. `bash scripts/start-colmena.sh`
3. Espera `✅ LiteLLM listo`
4. OpenCode arranca solo en el panel izquierdo
5. Al terminar: documenta en `CHANGELOG.md`
6. `git add -A && git commit -m "sesion: YYYY-MM-DD resumen" && git push`
