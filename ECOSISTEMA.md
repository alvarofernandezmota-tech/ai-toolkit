# 🤖 Ecosistema Personal de Agentes IA

> Agentes que trabajan para ti: en tu código, en tu vida, en tu información. Coste = 0€.
> Última actualización: **18 abril 2026**

---

## La visión

```
TÚ
 │
 ├── Telegram (THDORA)           → agente de vida: citas, hábitos, búsqueda web
 ├── Terminal (Claude Code)      → agente de código: edita repos, hace commits
 ├── Terminal (OpenCode)         → agente open source: investigación, docs, coding
 ├── n8n (self-hosted)            → orquestador: conecta todo con 400+ servicios
 └── ai-toolkit repo              → memoria: guias, diarios, contexto de todo

Todo gratis. Todo tuyo. Todo conectado.
```

### El modelo mental: BYOK (Bring Your Own Key)

Este ecosistema se construye sobre una idea sencilla: **las APIs de IA ya son gratuitas si las usas directamente**. No necesitas pagar suscripciones. Solo necesitas tus propias keys y saber cómo conectarlas.

- **OpenRouter** da acceso a DeepSeek R1, Llama 4, Qwen3 y más — gratis
- **Cerebras** inferencia ultra-rápida — gratis
- **Claude Code** funciona con tu OPENROUTER_API_KEY apuntando a modelos gratuitos
- **OpenCode** funciona igual, con cualquier modelo compatible con OpenAI API
- **Ollama** modelos 100% locales — sin key, sin límites, sin internet

La infraestructura ya existe. El trabajo es conectarla bien y documentar lo que funciona.

---

## 📡 Estado actual del stack — 18 Abril 2026

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

| Bloque | Estado | Notas |
|---|---|---|
| THDORA bot (citas + hábitos) | ✅ Funcionando | v0.14.0 en producción |
| THDORA NLP Groq (modo Toki) | ⚠️ Degradado | Groq key caducada |
| Claude Code + OpenRouter | ✅ Funciona | Variables de entorno directas, sin ccr |
| OpenCode + LiteLLM proxy | ✅ Funciona | Fix autosave aplicado 18 abril |
| Ollama modelos locales | ✅ Funciona | qwen2.5-coder:14b, deepseek-r1:14b, qwen3:8b |
| Cerebras (LiteLLM) | ✅ Funciona | Principal para tareas rápidas |
| Scripts de rotación de modelos | ✅ Listo | model-rotate.sh, opencode-rotate.sh, aider-rotate.sh |
| health-check.sh | ✅ Listo | Diagnóstico completo de proveedores |
| generar-diario.sh | ✅ Listo | Diario automático desde git log |
| setup.sh instalador | ✅ Listo | 1 comando instala todo |
| Agente revisor de código | 🛠 Borrador | Necesita prueba real en THDORA |
| n8n self-hosted | ❌ Mayo 2026 | Docker ya documentado |
| Búsqueda web en THDORA | ❌ Junio 2026 | DuckDuckGo o Tavily |
| Multi-agente CrewAI | ❌ Otoño 2026 | Diseño listo |

---

## ⚡ Consumo de recursos — ¿pesa en el ordenador?

### La respuesta corta: NO. Casi cero.

| Pieza | CPU en uso | RAM | Dónde corre la IA |
|---|---|---|---|
| **THDORA bot** | ~0% idle | ~50 MB | Groq (nube, gratis) |
| **Claude Code** | ~0% idle | ~60 MB | OpenRouter (nube, gratis) |
| **OpenCode** | ~0% idle | ~40 MB | LiteLLM proxy local |
| **LiteLLM proxy** | ~0% idle | ~80 MB | Local |
| **Ollama** | ~0% idle | ~8 GB VRAM | Local (GPU) |
| **TOTAL sin Ollama** | **<1% CPU** | **~370 MB RAM** | — |

> Ollama usa VRAM de la GPU, no RAM del sistema. El resto del ecosistema es texto puro.

---

## 📊 Comparativa de agentes de coding (verificado abril 2026)

| Agente | Modelo base | Coste | Mejor para | Estado |
|---|---|---|---|---|
| **Claude Code** | llama-4-maverick via OpenRouter | Gratis | Coding en repo real, leer contexto amplio | ✅ Funciona |
| **OpenCode** | Cerebras / Ollama via LiteLLM | Gratis | Investigación, docs, coding offline | ✅ Funciona |
| **Aider** | Cualquier modelo | Gratis | Cambios rápidos en archivos concretos | ✅ Funciona |

### Por qué Claude Code es el principal
- Entiende el repo entero sin añadir archivos manualmente
- Hace commits, crea ramas, resuelve conflictos solo
- Con OpenRouter + modelos gratuitos es 0€
- ⛔ NO usar `ccr` — rompe mensajes en v2.1.108+

### Por qué OpenCode es el segundo
- 100% open source, sin dependencia de Anthropic
- Funciona con Ollama local — sin internet, sin key
- Cerebras como backend en la nube cuando se necesita velocidad

---

## 🧠 Modelos recomendados (abril 2026)

| Tarea | Modelo | Proveedor |
|---|---|---|
| Código del día a día | qwen2.5-coder:14b | Ollama local |
| Razonamiento profundo | deepseek-r1:14b | Ollama local |
| Tareas rápidas | llama-4-maverick:free | OpenRouter |
| Velocidad máxima | gpt-oss-120b | Cerebras |
| Sin conexión | cualquier modelo Ollama | Local |

### Modelos OpenRouter (Claude Code)

| Modelo | ID exacto | Para qué |
|---|---|---|
| Llama 4 Maverick | `meta-llama/llama-4-maverick:free` | Principal diario |
| DeepSeek R1 | `deepseek/deepseek-r1:free` | Razonamiento |
| Qwen3 235B | `qwen/qwen3-235b-a22b:free` | Código avanzado |
| Llama 3.3 70B | `meta-llama/llama-3.3-70b-instruct:free` | Fallback |

### Modelos Ollama local (sin internet)

| Modelo | Para qué |
|---|---|
| qwen2.5-coder:14b | Código (principal) |
| deepseek-r1:14b | Razonamiento |
| qwen3:8b | Rápido y ligero |

---

## 🎯 Mapa completo de agentes

### Agentes de vida personal (THDORA)

| Agente | Estado | Qué hace |
|---|---|---|
| 🗓️ **Agenda** | ✅ Vivo | Citas, conflictos, semana completa |
| 💧 **Hábitos** | ✅ Vivo | Agua, sueño, ejercicio |
| 🤖 **NLP Toki** | ⚠️ Degradado | Groq key caducada |
| 🎤 **Voz Whisper** | ❌ F15 | Hablas → transcribe → actúa |
| 🌐 **Búsqueda web** | ❌ Junio | Preguntas en tiempo real |
| 📅 **Brief diario** | ❌ Mayo | Cada noche: qué tienes mañana |

### Agentes de código (terminal)

| Agente | Herramienta | Estado | Qué hace |
|---|---|---|---|
| 🔧 **Coding THDORA** | Claude Code | 🔧 Siguiente | Edita código real, hace commits |
| 🧠 **Investigación** | OpenCode + Ollama | ✅ Funciona | Investiga, genera docs en MD |
| 📝 **Generador docs** | OpenCode | 🛠 Borrador | ARCHITECTURE.md, docstrings |
| 🧪 **Tests** | CrewAI | ❌ Otoño | Crea tests automáticamente |

### Agentes de orquestación (n8n — Mayo 2026)

| Agente | Cuándo | Qué produce |
|---|---|---|
| 📓 **Diario nocturno** | 23:00 | Commit automático en repo personal |
| 📦 **Resumen semanal** | Lunes 8:00 | Informe: citas, hábitos, commits |
| ⚠️ **Alerta hábitos** | 22:00 | Telegram si no los marcaste |
| 🔔 **Brief mañana** | 22:00 | Telegram: qué tienes mañana |

---

## 🚀 Cómo arrancar en cada sesión

### Claude Code (agente coding principal)
```bash
# Rotación automática de modelos (RECOMENDADO)
cc

# ⛔ NO usar ccr (claude-code-router) — rompe el formato de mensajes en v2.1.108+
```

### OpenCode + LiteLLM proxy
```bash
# LiteLLM proxy debe estar activo en :8000
litellm --config ~/projects/ai-toolkit/litellm-config.yaml &

# Rotación automática de modelos
bash ~/projects/ai-toolkit/scripts/opencode-rotate.sh
```

### Diagnóstico completo del ecosistema
```bash
bash ~/projects/ai-toolkit/scripts/health-check.sh
```

### Aider (alternativa ligera)
```bash
bash scripts/aider-rotate.sh
```

---

## 🗂️ Estructura de repos del ecosistema

| Repo | Qué es | Regla |
|---|---|---|
| `thdora` | Tu asistente personal | Lo que **vives** y personalizas |
| `ai-toolkit` | Caja de herramientas pública | Lo que **aprendes** y generalizas |
| `personal` | Tu memoria escrita | Diarios, tracking, contexto de vida |

**La diferencia clave:** THDORA tiene tus keys reales y tu BBDD. ai-toolkit tiene plantillas con `$TU_KEY` para que cualquier dev pueda usarlo.

---

## 🗺️ Hoja de ruta

```
Abril 2026 (AHORA)
  ├── ✅ Claude Code + OpenRouter funcionando
  ├── ✅ OpenCode + LiteLLM proxy + Ollama funcionando
  ├── ✅ Scripts rotación modelos listos
  ├── ✅ health-check.sh operativo
  ├── ✅ generar-diario.sh operativo
  ├── ❌ Renovar Groq key → console.groq.com
  ├── ❌ Renovar DeepSeek key → platform.deepseek.com
  ├── ❌ Nueva Gemini key → aistudio.google.com/apikey
  └── 🔧 Siguiente: primer uso real de Claude Code en THDORA

Mayo 2026
  ├── Docker en WSL
  ├── n8n arrancando en localhost:5678
  └── Workflows: brief diario + alerta hábitos + diario automático

Junio 2026
  └── Búsqueda web en THDORA (DuckDuckGo + Groq)

Otoño 2026
  └── CrewAI: revisor + tester automático
```

---

## 🔑 APIs y keys necesarias (todo gratis)

| Servicio | Para qué | Estado | Link |
|---|---|---|---|
| **OpenRouter** | Claude Code + modelos thinking | ✅ Activo | [openrouter.ai](https://openrouter.ai) |
| **Cerebras** | LiteLLM proxy principal | ✅ Activo | [cerebras.ai](https://cerebras.ai) |
| **Groq** | NLP THDORA + Aider | ❌ Renovar | [console.groq.com](https://console.groq.com) |
| **DeepSeek** | API remota | ❌ Renovar | [platform.deepseek.com](https://platform.deepseek.com) |
| **Gemini** | Modelos Google | ❌ Renovar | [aistudio.google.com](https://aistudio.google.com/apikey) |
| **Ollama** | Modelos locales | ✅ Activo | Local, sin key |
| **Telegram Bot** | THDORA | ✅ Activo | [@BotFather](https://t.me/BotFather) |

---

## 🔄 Ciclo 24/7 cuando esté montado

```
08:00  n8n → brief del día → Telegram
       ↓
Todo el día → THDORA escucha Telegram
             → Groq responde en <1s
             → Claude Code disponible en terminal
             → OpenCode + Ollama para offline
       ↓
22:00  n8n → alerta si no marcaste hábitos
       n8n → brief de mañana → Telegram
       ↓
23:00  n8n → diario automático → commit en personal repo

Consumo total: <1% CPU, ~370 MB RAM, 0€/mes
```

---

*Última actualización: 18 abril 2026 — Ollama integrado, LiteLLM proxy operativo, OpenCode fix autosave, Cerebras como principal.*
