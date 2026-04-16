# CHANGELOG — ai-toolkit

---

## 2026-04-16 — Sesión madrugada: Gemini 429 resuelto, SambaNova + Together AI añadidos

### Contexto
OpenCode se quedaba bloqueado porque `cerebras/llama3.3-70b` no existe en Cerebras
(causa cascada de cooldowns). Gemini en rate limit diario del free tier.
Solución: reordenar cadena con Groq primero, añadir SambaNova y Together AI,
corregir nombre modelo Cerebras.

### Cambios aplicados

**litellm-config.yaml — fix crítico:**
- ❌ `cerebras/llama3.3-70b` → ✅ `cerebras/llama3.1-8b` (modelo que realmente existe)
- Reordenado grupo `principal`: Groq → SambaNova → Together → OpenRouter → Gemini → Gemini-Lite → Cerebras
- Añadido `gemini/gemini-2.0-flash-lite` al grupo principal y como `gemini-lite-fallback`
- `allowed_fails: 1` + `cooldown_time: 300` → fallback inmediato sin bucle de reintentos
- Fallbacks actualizados para incluir `gemini-lite-fallback`

**Modelos verificados (nombres exactos para LiteLLM):**
| Proveedor | Nombre en config | Estado |
|-----------|-----------------|--------|
| Groq | `groq/llama-3.3-70b-versatile` | ✅ |
| SambaNova | `sambanova/Llama-4-Maverick-17B-128E-Instruct` | ✅ corregido |
| SambaNova | `sambanova/DeepSeek-R1-0528` | ✅ corregido |
| SambaNova | `sambanova/DeepSeek-V3-0324` | ✅ añadido |
| Together | `together_ai/meta-llama/Llama-4-Maverick-17B-128E-Instruct-FP8` | ✅ |
| Together | `together_ai/deepseek-ai/DeepSeek-R1` | ✅ |
| OpenRouter | `openrouter/meta-llama/llama-4-scout:free` | ✅ |
| Gemini | `gemini/gemini-2.0-flash` | ✅ |
| Gemini Lite | `gemini/gemini-2.0-flash-lite` | ✅ añadido |
| Cerebras | `cerebras/llama3.1-8b` | ✅ CORREGIDO (era llama3.3-70b) |

**opencode.json — modelos añadidos al selector Ctrl+P:**
- `sambanova-llama4`, `sambanova-deepseek`, `sambanova-deepseek-v3`
- `together-llama4`, `together-deepseek`

**scripts/ai-menu.sh:**
- Opción 2: descripción actualizada → Groq→SambaNova→Together→OpenRouter→Gemini→Cerebras
- Opción 5 nueva: solo proxy `start-colmena.sh --solo-proxy`
- Checks de keys: SAMBANOVA_API_KEY, TOGETHER_API_KEY, GOOGLE_GENERATIVE_AI_API_KEY

**scripts/aider-rotate.sh — pool ampliado:**
- Groq (×3) → SambaNova (×2) → Together (×2) → OpenRouter fallback final

**setup.sh — bootstrap actualizado:**
- Instala: tmux, litellm[proxy], opencode-ai (npm), aider-chat
- .bashrc exporta: SAMBANOVA_API_KEY, TOGETHER_API_KEY, OPENROUTER_API_KEY, CEREBRAS_API_KEY
- Alias: colmena, proxy, menu, ocp, aider-samba, aider-together, aider-free

**INICIO-AQUI.md:**
- Cadena de fallback actualizada (Groq primero, no Gemini)
- Tabla de estado actualizada con SambaNova, Together AI, Gemini-Lite
- Lista completa de modelos disponibles en el proxy

**REPOS-ECOSISTEMA.md — nuevo fichero:**
- Auditoría completa de las 11 repos del ecosistema

### Estado final

| Componente | Estado |
|------------|--------|
| OpenCode v1.4.6 | ✅ instalado |
| LiteLLM proxy :8000 | ✅ corriendo |
| Groq Llama 70B | ✅ primero en cadena |
| SambaNova Llama-4 | ✅ segundo |
| Together AI Llama-4 | ✅ tercero |
| Cerebras llama3.1-8b | ✅ nombre corregido |
| Gemini Flash-Lite | ✅ añadido (más cuota) |
| Fallback automático | ✅ 1 fallo → cooldown 5 min |

### Pendiente para próxima sesión
- [ ] Verificar LiteLLM arranca con `--solo-proxy`
- [ ] Renovar `DEEPSEEK_API_KEY` en platform.deepseek.com
- [ ] Instalar `gh` CLI en WSL (`sudo apt install gh && gh auth login`)
- [ ] Probar `opencode -m sambanova-llama4` directamente
- [ ] Completar `CEREBRAS_API_KEY` y `OPENROUTER_API_KEY` en .bashrc

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
- [x] Verificar LiteLLM arranca con `--solo-proxy` — pendiente
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
