# CHANGELOG — ai-toolkit

---

## 2026-04-16 — Sesión nocturna: Stack estabilizado con Gemini + Groq

### Contexto
Sesión compleja. Problema principal: ningún modelo respondía consistentemente.
Groq key caducada (401), Cerebras con límite diario agotado, Gemini con
rate limit por alta demanda nocturna, OpenRouter sin créditos para modelos grandes.

### Cambios aplicados

**Keys renovadas (guardadas en ~/.bashrc, NO en la repo):**
- `GROQ_API_KEY` → renovada 2026-04-16 en console.groq.com
- `GOOGLE_GENERATIVE_AI_API_KEY` → renovada 2026-04-16 en aistudio.google.com

**litellm-config.yaml:**
- Gemini 2.0 Flash → **primer modelo principal** (antes Cerebras)
- Groq Llama 70B → **segundo** (reactivado con key nueva)
- `gemini-fallback` y `groq-fallback` reactivados
- Cadena: `Gemini → Groq → OpenRouter(free) → Cerebras`
- OpenRouter apunta a `llama-4-scout:free`

**scripts/start-colmena.sh — fixes críticos:**
- ✅ Detecta si está dentro de tmux → arranca solo el proxy (fix del `[exited]`)
- ✅ Busca litellm en: `.venv/` propio → thdora → PATH global
- ✅ Logs redirigidos a `/tmp/litellm.log`
- ✅ Health check mejorado: 20 intentos
- ✅ Verificación de variables de entorno al arrancar

**INICIO-AQUI.md:**
- Tabla de estado actualizada
- Opciones B y C (OpenCode directo sin LiteLLM)
- Protocolo de trabajo estándar
- Sección de diagnóstico con comandos útiles

### Estado final de la sesión

| Componente | Estado |
|------------|--------|
| OpenCode v1.4.6 | ✅ instalado |
| Gemini 2.0 Flash directo | ✅ key activa |
| Groq Llama 70B directo | ✅ key renovada |
| LiteLLM proxy config | ✅ correcto |
| start-colmena.sh | ✅ fix [exited] aplicado |
| Fallback automático | ✅ Gemini→Groq→OpenRouter→Cerebras |

### Pendiente para próxima sesión
- [ ] Verificar LiteLLM arranca con `--solo-proxy`
- [ ] Renovar `DEEPSEEK_API_KEY` en platform.deepseek.com
- [ ] Instalar litellm en venv propio de ai-toolkit (independizar de thdora)
- [ ] Completar `CEREBRAS_API_KEY` y `OPENROUTER_API_KEY` en .bashrc

---

## 2026-04-15 — Instalación inicial OpenCode + LiteLLM

- OpenCode v1.4.6 instalado
- LiteLLM proxy configurado en puerto 8000
- Arquitectura Colmena definida (tmux 3 paneles)
- Cerebras como modelo principal inicial
- OpenRouter como fallback
- Groq configurado (key caducó esa noche)
