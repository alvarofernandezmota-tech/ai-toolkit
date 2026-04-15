# 🧭 INICIO AQUÍ — La brújula del ecosistema

> Lee esto al principio de cada sesión. Tiene todo lo que necesitas para arrancar.

---

## ¿Qué es esto?

Este repo es el **cerebro del ecosistema**. Aquí se documenta todo lo que se construye, se prueba y se aprende. El objetivo es tener agentes de IA trabajando en paralelo mientras yo (Alvaro) tomo decisiones de alto nivel.

**Arquitectura objetivo:**
```
Alvaro + Perplexity (chat)     →  estrategia, diseño, decisiones
        ↓
OpenCode + LiteLLM (terminal)  →  ejecución, código, commits
        ↓
Agentes especializados          →  tareas concretas en paralelo
```

---

## ▶️ Arranque rápido (cada sesión)

```bash
# 1. Ir al proyecto
cd ~/projects/ai-toolkit

# 2. Actualizar desde GitHub
git pull

# 3. Comprobar que el puerto 8000 está libre
lsof -i :8000
# Si está ocupado (THDORA u otro proceso):
# kill -9 <PID>

# 4. Arrancar LiteLLM en background
pkill -f litellm; pkill -f uvicorn; sleep 2
litellm --config litellm-config.yaml --port 8000 &

# 5. Esperar a ver:
# INFO: Application startup complete.
# INFO: Uvicorn running on http://0.0.0.0:8000

# 6. Abrir OpenCode
opencode

# ✓ Barra inferior debe decir: Principal LiteLLM Colmena
```

---

## 📊 Estado del stack hoy

| Componente | Estado | Versión |
|---|---|---|
| LiteLLM | ✅ Funcionando | 1.83.7 |
| OpenCode | ✅ Funcionando | 1.4.6 |
| Claude Code | ✅ Instalado | 2.1.108 |
| THDORA API | ⚠️ Conflicto puerto 8000 | — |
| n8n | ⏳ Pendiente | — |
| Ollama | ⏳ Pendiente | — |

**Modelo principal activo:** `groq/llama-3.3-70b-versatile`  
*(Google free tier agotado el 15-04-2026, cambiar cuando se resetee)*

---

## 🤖 Modelos disponibles en LiteLLM

| Alias OpenCode | Modelo real | Gratis |
|---|---|---|
| `principal` | groq/llama-3.3-70b-versatile | ✅ |
| `gemini-flash` | gemini/gemini-2.0-flash | ✅ (limitado) |
| `gemini-pro` | gemini/gemini-2.5-pro-exp | ✅ (limitado) |
| `deepseek-r1` | deepseek/deepseek-reasoner | 💳 barato |
| `deepseek-v3` | deepseek/deepseek-chat | 💳 barato |
| `claude-sonnet` | anthropic/claude-3-5-sonnet | 💳 |
| `gpt-4o` | openai/gpt-4o | 💳 |
| `qwen3-235b` | openrouter/qwen3-235b | ✅ (via OR) |
| `groq-fallback` | groq/llama-3.3-70b | ✅ |
| `cerebras-fallback` | cerebras/llama3.1-8b | ✅ |

Cambiar modelo en OpenCode: `Ctrl+P` → escribir `model`

---

## ⚠️ Problemas conocidos y soluciones

### Puerto 8000 ocupado
```bash
lsof -i :8000          # Ver qué lo usa
kill -9 <PID>          # Matarlo
# Normalmente es uvicorn de THDORA
```

### Google 429 (quota agotada)
```bash
# Cambiar principal a Groq en litellm-config.yaml:
sed -i 's|gemini/gemini-2.0-flash|groq/llama-3.3-70b-versatile|g' litellm-config.yaml
```

### OpenCode muestra modelo incorrecto
- Verificar `~/.config/opencode/opencode.json`
- El campo `models` dentro del provider es obligatorio
- Ver `docs/opencode-setup.md` para el JSON completo

### `opencode auth login` no encuentra litellm
- Normal. LiteLLM no es provider nativo de OpenCode
- La API key va en `options.apiKey` del config JSON
- No usar `auth login` para providers custom

---

## 📂 Mapa del repo

```
ai-toolkit/
├── INICIO-AQUI.md          ← estás aquí
├── ROADMAP.md              ← qué hay que construir
├── CHANGELOG.md            ← qué se ha hecho y cuándo
├── ECOSISTEMA.md           ← visión grande del sistema
├── litellm-config.yaml     ← configuración de 18 modelos
├── docs/
│   ├── dependencias.md         ← todo lo que hay instalado
│   ├── arranque-rapido.md      ← comandos de arranque
│   ├── opencode-setup.md       ← config completa OpenCode
│   └── VISION-SISTEMA.md       ← el norte del proyecto
├── investigacion/
│   ├── comparativa-llms.md     ← fichas de 14 modelos
│   └── diario/                 ← diario de cada sesión
├── agentes/
│   └── PENDIENTES.md           ← agentes por construir
└── scripts/
    ├── ai-menu.sh              ← menú principal
    └── opencode-rotate.sh      ← rotación de modelos
```

---

## 🎯 Flujo de trabajo ideal

```
1. Perplexity (este chat)  →  estrategia y diseño
2. Git pull                →  sincronizar repo
3. LiteLLM up              →  proxy de modelos
4. OpenCode                →  ejecutar tareas en el código
5. Git push                →  guardar lo hecho
6. Perplexity              →  documentar y planificar siguiente
```

**Regla de oro:** todo lo que se aprende, se falla o se construye va en el repo.

---

## 📚 Documentos clave por orden de lectura

1. Este archivo — arrancar
2. `ROADMAP.md` — qué toca hacer
3. `CHANGELOG.md` — dónde quedó la última sesión
4. `investigacion/diario/` — detalles de cada sesión
5. `docs/dependencias.md` — si hay que instalar algo nuevo

---

*Última actualización: 2026-04-15 sesión noche*
