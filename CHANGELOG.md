# CHANGELOG — ai-toolkit

## 2026-04-17 — Ollama primero + fix timeout

- `litellm-config.yaml`: `request_timeout` 15s → 120s (Ollama necesita tiempo)
- Ollama añadido como primera opción en fallback chain (coste 0, privado)
- Nuevos modelos locales: `ollama-coder`, `ollama-qwen3`, `ollama-coder-7b`
- Documentación sesión: `docs/SESION-2026-04-17.md`
- OpenCode ✅ instalado y verificado respondiendo

## 2026-04-16 04:52 — Fix timeouts y orden Gemini

- `request_timeout`: 60s → 15s para fallar rápido entre modelos cloud
- `num_retries`: 3 → 1
- Gemini siempre al final de los fallbacks
- OpenRouter slug corregido (sin `:free`)
- `cooldown_time`: 30s, `allowed_fails`: 3

## 2026-04-15 — Arquitectura Colmena

- LiteLLM Proxy como hub central en `:8000`
- Modelo `principal` con auto-fallback entre proveedores
- Integración Groq, Sambanova, Together AI, OpenRouter, Cerebras, Gemini
- Script `scripts/start-colmena.sh` para arranque en tmux
