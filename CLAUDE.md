# CLAUDE.md

Este fichero proporciona contexto a Claude Code cuando trabaja en este repositorio.

---

## ⚠️ Reglas críticas — leer antes de nada

- ⛔ NUNCA usar `ccr` (claude-code-router) — rompe los mensajes en Claude Code v2.1.108+
- ⛔ Las keys NUNCA van en GitHub — solo en `~/.bashrc` o `~/.claude/settings.json` local
- ✅ Usar siempre `cc` en lugar de `claude` para aprovechar rotación de modelos
- ✅ Las sesiones de trabajo van en `diario/sesion-DD-mes-YYYY.md` (NO en docs/)
- ✅ El primer comando en cualquier repo nuevo es `bash setup.sh`
- ✅ Para commits usar convención: feat/fix/docs/chore/config

---

## ⚡ Comandos rápidos

```bash
# Claude Code con rotación automática (RECOMENDADO)
cc

# OpenCode con rotación automática
bash ~/projects/ai-toolkit/scripts/opencode-rotate.sh

# Aider con rotación automática
bash ~/projects/ai-toolkit/scripts/aider-rotate.sh

# Health check completo de todos los proveedores
bash ~/projects/ai-toolkit/scripts/health-check.sh

# Generar diario automático desde git log
bash ~/projects/ai-toolkit/scripts/generar-diario.sh

# Ver qué modelo está activo ahora
cat ~/.claude/settings.json

# Ver log de rotaciones
cat ~/.claude/rotate.log
```

---

## 📡 Estado actual del stack (18 abril 2026)

```
✅ Ollama local     → operativo (qwen2.5-coder:14b, deepseek-r1:14b, qwen3:8b)
✅ LiteLLM proxy    → operativo en :8000
✅ OpenCode         → operativo (fix autosave aplicado)
✅ Cerebras         → operativo (principal en LiteLLM)
✅ OpenRouter       → operativo (max_tokens: 4096)
❌ Groq             → key caducada → renovar en console.groq.com
❌ DeepSeek API     → key inválida → renovar en platform.deepseek.com
❌ Gemini           → cuota agotada → nueva key en aistudio.google.com/apikey
```

---

## 🧠 Modelos recomendados hoy

| Tarea | Modelo recomendado | Proveedor |
|---|---|---|
| Código del día a día | qwen2.5-coder:14b | Ollama local |
| Razonamiento profundo | deepseek-r1:14b | Ollama local |
| Tareas rápidas | llama-4-maverick:free | OpenRouter |
| Sin conexión | cualquier modelo Ollama | Local |

### Modelos disponibles — OpenRouter (Claude Code)

| Modelo | ID exacto | Para qué |
|---|---|---|
| DeepSeek R1 | `deepseek/deepseek-r1:free` | Razonamiento profundo |
| Qwen3 235B | `qwen/qwen3-235b-a22b:free` | Código avanzado |
| Llama 4 Maverick | `meta-llama/llama-4-maverick:free` | Código del día a día |
| Gemini 2.5 Pro | `google/gemini-2.5-pro-exp-03-25:free` | Arquitectura |
| Llama 3.3 70B | `meta-llama/llama-3.3-70b-instruct:free` | Fallback final |

### Modelos disponibles — Ollama local

| Modelo | Para qué |
|---|---|
| qwen2.5-coder:14b | Código (principal local) |
| deepseek-r1:14b | Razonamiento (principal local) |
| qwen3:8b | Tareas rápidas locales |

---

## 🗂️ Estructura del repo

```
ai-toolkit/
├── CLAUDE.md              → contexto para agentes (este fichero)
├── ECOSISTEMA.md          → visión completa del ecosistema
├── CHANGELOG.md           → historial de sesiones
├── ROADMAP.md             → qué viene
├── ALVARO.md              → quién soy yo, cómo pienso
├── AGENTES.md             → definición de agentes (ES)
├── AGENTS.md              → definición de agentes (EN)
├── ARQUITECTURA.md        → diseño del sistema
├── CEREBRO.md             → principios y valores
├── INICIO-AQUI.md         → brújula del proyecto
├── COMO-PROCEDEMOS.md     → reglas de trabajo
├── REPOS-ECOSISTEMA.md    → mapa de repos
├── ESTRATEGIA.md          → estrategia general
├── setup.sh               → instalador en 1 comando
├── litellm-config.yaml    → config proxy multi-modelo
├── opencode.json          → config OpenCode
├── tui.json               → config TUI
├── .env.example           → plantilla de keys (nunca keys reales)
├── agentes/               → definiciones y workflows de agentes
├── diario/                → sesiones de trabajo (formato: sesion-DD-mes-YYYY.md)
├── docs/                  → documentación técnica
├── guias/                 → guías de modelos y herramientas
├── herramientas/          → herramientas del ecosistema
├── investigacion/         → experimentos y comparativas
├── opensource/            → referencias open source
├── prompts/               → prompts reutilizables
├── pruebas/               → experimentos y tests
├── scripts/               → automatización
│   ├── ai-menu.sh
│   ├── aider-rotate.sh
│   ├── opencode-rotate.sh
│   ├── model-rotate.sh
│   ├── generar-diario.sh
│   ├── health-check.sh
│   └── benchmark-runner.sh
└── setup/                 → guías de instalación por herramienta
```

---

## ⚙️ Configuración Claude Code

`~/.claude/settings.json` (gestionado por `model-rotate.sh`):
```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://openrouter.ai/api/v1",
    "ANTHROPIC_AUTH_TOKEN": "$OPENROUTER_API_KEY",
    "ANTHROPIC_API_KEY": "",
    "ANTHROPIC_MODEL": "meta-llama/llama-4-maverick:free"
  }
}
```
> ⚠️ Nunca pongas la key real aquí. Usa `~/.bashrc` o `~/.claude/settings.json` local.

---

## 🌐 Ecosistema de repos

| Repo | Propósito | Visibilidad |
|---|---|---|
| ai-toolkit | Cerebro público — guías, scripts, configs | Público |
| thdora | Asistente Telegram — producción, keys reales | Privado |
| personal | Diarios, finanzas, tracking de vida | Privado |

---

_Última actualización: 18 abril 2026_
