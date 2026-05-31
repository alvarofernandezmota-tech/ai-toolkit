# 🤖 Ecosistema Personal de Agentes IA

> Agentes que trabajan para ti: en tu código, en tu vida, en tu información. Coste = 0€.
> Última actualización: **31 mayo 2026**

---

## La visión

```
TÚ
 │
 ├── Telegram (THDORA)           → agente de vida: citas, hábitos, búsqueda web
 ├── Terminal (Claude Code)      → agente de código: edita repos, hace commits
 ├── Terminal (OpenCode)         → agente open source: investigación, docs, coding
 ├── n8n (self-hosted)            → orquestador: conecta todo con 400+ servicios
 └── ai-toolkit repo              → cerebro: guias, diarios, contexto de todo

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

## 🗂️ Arquitectura de repos — Mayo 2026

> **Decisión de diseño (31 mayo 2026):** cada dominio tiene su propia repo para que la IA pueda gestionarla con contexto limpio, sin ruido de otros proyectos.

| Repo | Tipo | Qué contiene | Link |
|------|------|--------------|------|
| **ai-toolkit** | 🧠 Sistema | Cerebro IA, herramientas, stack, agentes, guías genéricas | [→](https://github.com/alvarofernandezmota-tech/ai-toolkit) |
| **personal** | 📔 Vida personal | Diarios, tracking vida, contexto personal (no técnico) | [→](https://github.com/alvarofernandezmota-tech/personal) |
| **thdora** | 🤖 Proyecto | Bot Telegram + FastAPI + asistente personal IA | [→](https://github.com/alvarofernandezmota-tech/thdora) |
| **impresion-3d** | 🖨️ Proyecto | Anycubic Photon V1, resinas, modelos, diarios de sesión | [→](https://github.com/alvarofernandezmota-tech/impresion-3d) |
| **python-snippets** | 📚 Formación | Posts Instagram Python — cada carpeta = un post | [→](https://github.com/alvarofernandezmota-tech/python-snippets) |
| **unix** | 📚 Formación | Apuntes Sistemas Operativos II | [→](https://github.com/alvarofernandezmota-tech/unix) |
| **ejerciciosbego** | 📚 Formación | Python desde cero para Bego | [→](https://github.com/alvarofernandezmota-tech/ejerciciosbego) |
| **image-calculator** | 🛠️ Proyecto | OCR + operaciones matemáticas sobre imágenes | [→](https://github.com/alvarofernandezmota-tech/image-calculator) |
| **AppointmentManager** | 🛠️ Proyecto | Gestor de citas (anterior a THDORA) | [→](https://github.com/alvarofernandezmota-tech/AppointmentManager) |

### Regla de oro: ¿dónde va cada cosa?

```
¿Es una herramienta IA reutilizable?  → ai-toolkit
¿Es tu vida, diario, tracking?        → personal
¿Es un proyecto concreto?             → su propia repo
¿Es formación/contenido educativo?    → su propia repo
```

**Por qué repos separadas:** la IA (Claude Code, OpenCode) carga el contexto de una repo entera al arrancar. Si todo está mezclado, pierde foco. Repo pequeña y cohesionada = IA más precisa y rápida.

---

## 📡 Estado actual del stack — 31 Mayo 2026

```
✅ Ollama local     → operativo (qwen2.5-coder:14b, deepseek-r1:14b, qwen3:8b)
✅ LiteLLM proxy    → operativo en :8000
✅ OpenCode         → operativo
✅ Cerebras         → operativo (principal en LiteLLM)
✅ OpenRouter       → operativo (llama-4-maverick, qwen3-235b)
✅ Google Gemini    → operativo (rate limit ocasional)
⚠️ Groq             → key caducada → renovar en console.groq.com
⚠️ DeepSeek API     → key caducada → renovar en platform.deepseek.com
✅ THDORA           → v0.14.0 en producción
✅ n8n              → pendiente levantar en Docker/WSL
```

| Bloque | Estado | Notas |
|---|---|---|
| THDORA bot (citas + hábitos) | ✅ Funcionando | v0.14.0 en producción |
| THDORA NLP Groq (modo Toki) | ⚠️ Degradado | Groq key caducada |
| Claude Code + OpenRouter | ✅ Funciona | Variables de entorno directas, sin ccr |
| OpenCode + LiteLLM proxy | ✅ Funciona | Fix puerto uvicorn aplicado 22 abril |
| Ollama modelos locales | ✅ Funciona | qwen2.5-coder:14b, deepseek-r1:14b, qwen3:8b |
| Cerebras (LiteLLM) | ✅ Funciona | Principal para tareas rápidas |
| **ai-menu.sh** | ✅ Activo | Menú interactivo 12 opciones — punto de entrada |
| Scripts rotación modelos | ✅ Listo | model-rotate.sh, opencode-rotate.sh, aider-rotate.sh |
| health-check.sh | ✅ Listo | Diagnóstico completo de proveedores |
| generar-diario.sh | ✅ Listo | Diario automático desde git log |
| benchmark-runner.sh | ✅ Listo | Script listo — falta ejecutarlo con datos reales |
| ensemble.sh | ✅ Listo | Mismo prompt a varios modelos en paralelo |
| Agente revisor de código | 🛠 Borrador | Necesita prueba real en THDORA |
| n8n self-hosted | ⚠️ Pendiente | Docker documentado, sin levantar aún |
| Búsqueda web en THDORA | ❌ Junio 2026 | DuckDuckGo o Tavily |
| Multi-agente CrewAI | ❌ Otoño 2026 | Diseño listo |

---

## ⚡ Consumo de recursos

### La respuesta corta: NO pesa. Casi cero.

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

## 🧠 Modelos recomendados (mayo 2026)

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
| 🔧 **Coding THDORA** | Claude Code | 🔧 Activo | Edita código real, hace commits |
| 🧠 **Investigación** | OpenCode + Ollama | ✅ Funciona | Investiga, genera docs en MD |
| 📝 **Generador docs** | OpenCode | 🛠 Borrador | ARCHITECTURE.md, docstrings |
| 🧪 **Tests** | CrewAI | ❌ Otoño | Crea tests automáticamente |

### Agentes de orquestación (n8n — pendiente)

| Agente | Cuándo | Qué produce |
|---|---|---|
| 📓 **Diario nocturno** | 23:00 | Commit automático en repo personal |
| 📦 **Resumen semanal** | Lunes 8:00 | Informe: citas, hábitos, commits |
| ⚠️ **Alerta hábitos** | 22:00 | Telegram si no los marcaste |
| 🔔 **Brief mañana** | 22:00 | Telegram: qué tienes mañana |

---

## 🚀 Cómo arrancar en cada sesión

### Punto de entrada principal
```bash
cd ~/projects/ai-toolkit
git pull
bash scripts/ai-menu.sh     # menú interactivo con todo el stack
```

### Claude Code (agente coding principal)
```bash
cc   # rotación automática de modelos
# ⛔ NO usar ccr — rompe mensajes en v2.1.108+
```

### OpenCode + LiteLLM proxy
```bash
bash scripts/start-colmena.sh   # tmux con 3 paneles: OpenCode + logs + bash
```

### Diagnóstico completo del ecosistema
```bash
bash scripts/health-check.sh
bash scripts/health-check.sh --full   # test con llamada real
bash scripts/health-check.sh --fix    # muestra comandos de arreglo
```

### Ensemble (mismo prompt a varios modelos)
```bash
bash scripts/ensemble.sh "¿Cuál es la mejor arquitectura para X?"
```

---

## 🔑 APIs y keys necesarias (todo gratis)

| Servicio | Para qué | Estado | Link |
|---|---|---|---|
| **OpenRouter** | Claude Code + modelos thinking | ✅ Activo | [openrouter.ai](https://openrouter.ai) |
| **Cerebras** | LiteLLM proxy principal | ✅ Activo | [cerebras.ai](https://cerebras.ai) |
| **Google Gemini** | Fallback en LiteLLM | ✅ Activo | [aistudio.google.com](https://aistudio.google.com/apikey) |
| **Groq** | NLP THDORA + Aider | ⚠️ Renovar | [console.groq.com](https://console.groq.com) |
| **DeepSeek** | API remota | ⚠️ Renovar | [platform.deepseek.com](https://platform.deepseek.com) |
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

## 🗺️ Hoja de ruta

```
Abril 2026 ✅
  ├── ✅ Claude Code + OpenRouter funcionando
  ├── ✅ OpenCode + LiteLLM proxy + Ollama funcionando
  ├── ✅ Scripts rotación modelos listos
  ├── ✅ health-check.sh operativo
  ├── ✅ generar-diario.sh operativo
  └── ✅ ai-menu.sh — menú interactivo

Mayo 2026 (AHORA)
  ├── ✅ Arquitectura multi-repo definida (ai-toolkit / personal / proyectos / formación)
  ├── ⚠️ Renovar Groq key → console.groq.com
  ├── ⚠️ Renovar DeepSeek key → platform.deepseek.com
  ├── ❌ n8n en Docker/WSL
  └── ❌ Ejecutar benchmark-runner.sh con datos reales

Junio 2026
  └── Búsqueda web en THDORA (DuckDuckGo + Groq)

Otoño 2026
  └── CrewAI: revisor + tester automático
```

---

*Última actualización: 31 mayo 2026 — arquitectura multi-repo definida, estado APIs actualizado.*
